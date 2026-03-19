-- DDPositions_IN.lua

DDPositions = DDPositions or {}
DDPositions.DDPGroup_IN = {}
local DDPGroup_IN = DDPositions.DDPGroup_IN

local function msg(text)
    d("::[DDPositions]:: " .. tostring(text))
end

local function CleanName(name)
    if not name or name == "" then return "" end
    return ZO_CachedStrFormat("<<1>>", name)
end

local function GetRoleText(role)
    if role == LFG_ROLE_TANK then return "|c0211A2(Tank)|r" end
    if role == LFG_ROLE_HEAL then return "|c3394A3(Healer)|r" end
    if role == LFG_ROLE_DPS then return "|cFF0000(DPS)|r" end
    return "|c999999(Unknown)|r"
end

DDPGroup_IN.groupMembers = {}
DDPGroup_IN.rolesByDisplay = {}
DDPGroup_IN.displayByCharacter = {}
DDPGroup_IN.leader = nil

function DDPGroup_IN:ClearAll()
    ZO_ClearTable(self.groupMembers)
    ZO_ClearTable(self.rolesByDisplay)
    ZO_ClearTable(self.displayByCharacter)
    self.leader = nil
end

function DDPGroup_IN:BuildGroupTable()
    self:ClearAll()

    local groupSize = GetGroupSize()
    if groupSize == 0 then return end

    local leaderTag = GetGroupLeaderUnitTag()
    if leaderTag and DoesUnitExist(leaderTag) then
        self.leader = CleanName(GetUnitDisplayName(leaderTag))
    end

    for i = 1, groupSize do
        local unitTag = GetGroupUnitTagByIndex(i)
        if DoesUnitExist(unitTag) then
            local displayName = CleanName(GetUnitDisplayName(unitTag))
            local characterName = CleanName(GetUnitName(unitTag))
            local role = GetGroupMemberAssignedRole(unitTag)
            local roleText = GetRoleText(role)

            self.groupMembers[displayName] = roleText
            self.rolesByDisplay[displayName] = roleText
            self.displayByCharacter[characterName] = displayName
        end
    end
end

function DDPGroup_IN:CheckIgnoredPlayers()
    local groupSize = GetGroupSize()
    if groupSize == 0 then return end

    local localPlayer = GetUnitDisplayName("player")
    local ignoredList = {}

    for i = 1, groupSize do
        local unitTag = GetGroupUnitTagByIndex(i)
        local displayName = GetUnitDisplayName(unitTag)

        if displayName ~= localPlayer and IsIgnored(displayName) then
            local noteFound = ""
            local numIgnored = GetNumIgnored()
            for j = 1, numIgnored do
                local ignoredName, ignoredNote = GetIgnoredInfo(j)
                if ignoredName == displayName then
                    noteFound = ignoredNote or ""
                    break
                end
            end

            if noteFound ~= "" then
                table.insert(ignoredList, "|cFF0000" .. displayName .. "|r Reason: " .. noteFound)
            else
                table.insert(ignoredList, "|cFF0000" .. displayName .. "|r")
            end
        end
    end

    if #ignoredList > 0 then
        msg("Ignored player(s) detected:")
        for _, line in ipairs(ignoredList) do
            msg(line)
        end
    end
end

local function OnGroupMemberJoined(_, memberCharacterName, memberDisplayName, isLocalPlayer)
    local cleanDisp = CleanName(memberDisplayName)
    local cleanChar = CleanName(memberCharacterName)
    local unitRole = LFG_ROLE_INVALID

    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if DoesUnitExist(unitTag) and GetUnitDisplayName(unitTag) == memberDisplayName then
            unitRole = GetGroupMemberSelectedRole(unitTag)
            break
        end
    end

    if unitRole == LFG_ROLE_INVALID then return end

    local roleText = GetRoleText(unitRole)
    DDPGroup_IN.groupMembers[cleanDisp] = roleText
    DDPGroup_IN.rolesByDisplay[cleanDisp] = roleText
    DDPGroup_IN.displayByCharacter[cleanChar] = cleanDisp

    if not isLocalPlayer then
        msg(string.format("%s %s joined the group.", cleanDisp, roleText))
    end

    DDPGroup_IN:BuildGroupTable()
    DDPGroup_IN:CheckIgnoredPlayers()
end

local function OnGroupMemberLeft(_, memberCharacterName, reason, isLocalPlayer, isLeader, memberDisplayName)
    if not memberDisplayName then return end
    local display = CleanName(memberDisplayName)
    local role = DDPGroup_IN.rolesByDisplay[display] or "|c999999(Unknown)|r"

    if reason == GROUP_LEAVE_REASON_DISBAND and isLeader then
        msg(string.format("%s disbanded the group.", DDPGroup_IN.leader or "Leader"))
    elseif reason == GROUP_LEAVE_REASON_KICKED then
        if isLocalPlayer then
            msg(string.format("You %s have been removed by %s.", role, DDPGroup_IN.leader or "leader"))
        else
            msg(string.format("%s %s was removed by %s.", display, role, DDPGroup_IN.leader or "leader"))
        end
    elseif reason == GROUP_LEAVE_REASON_VOLUNTARY and not isLocalPlayer then
        msg(string.format("%s %s left the group.", display, role))
    end

    DDPGroup_IN.groupMembers[display] = nil
    DDPGroup_IN.rolesByDisplay[display] = nil
    DDPGroup_IN.displayByCharacter[CleanName(memberCharacterName)] = nil

    DDPGroup_IN:BuildGroupTable()
end

local function OnGroupMemberRoleChanged(_, unitTag, newRole)
    if not DoesUnitExist(unitTag) or newRole == LFG_ROLE_INVALID then return end

    local displayName = CleanName(GetUnitDisplayName(unitTag))
    local newText = GetRoleText(newRole)
    local oldText = DDPGroup_IN.rolesByDisplay[displayName]

    if not oldText or oldText == "|c999999(Unknown)|r" then
        DDPGroup_IN.rolesByDisplay[displayName] = newText
        DDPGroup_IN.groupMembers[displayName] = newText
        return
    end

    if oldText == newText then return end

    DDPGroup_IN.rolesByDisplay[displayName] = newText
    DDPGroup_IN.groupMembers[displayName] = newText

    if displayName ~= GetUnitDisplayName("player") then
        msg(string.format("%s changed role %s → %s.", displayName, oldText, newText))
    end

    DDPGroup_IN:BuildGroupTable()
end

local function OnGroupChanged()
    DDPGroup_IN:BuildGroupTable()
    if DDPGroup_IN.leader then
        msg(string.format("New leader → %s", DDPGroup_IN.leader))
    end
end

local function OnPlayerActivated()
    if IsUnitGrouped("player") then
        DDPGroup_IN:BuildGroupTable()
        DDPGroup_IN:CheckIgnoredPlayers()
    end
end

local function OnGroupMemberConnected(_, unitTag, isOnline)
    if not DoesUnitExist(unitTag) or isOnline then return end
    local name = CleanName(GetUnitDisplayName(unitTag))
    msg(string.format("%s is now |c999999offline|r.", name))
end

local function OnAddonLoaded(_, addonName)
    if addonName ~= "DDPositions" then return end
    EVENT_MANAGER:UnregisterForEvent("DDPositions_IN", EVENT_ADD_ON_LOADED)

    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_JOINED, OnGroupMemberJoined)
    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_LEFT, OnGroupMemberLeft)
    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_ROLE_CHANGED, OnGroupMemberRoleChanged)
    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_LEADER_UPDATE, OnGroupChanged)
    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_CONNECTED_STATUS, OnGroupMemberConnected)

    EVENT_MANAGER:AddFilterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_ROLE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    EVENT_MANAGER:AddFilterForEvent("DDPositions_IN", EVENT_GROUP_MEMBER_CONNECTED_STATUS, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")

    msg("DDPositions_IN initialized with enhanced group tracking.")
end

EVENT_MANAGER:RegisterForEvent("DDPositions_IN", EVENT_ADD_ON_LOADED, OnAddonLoaded)
