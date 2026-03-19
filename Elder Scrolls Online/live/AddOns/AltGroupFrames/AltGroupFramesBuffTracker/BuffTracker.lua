local NAME = "AltGroupFramesBuffTracker"
local SV_VER = 4

local SETTINGS

ALTGF_BuffDebuffIcon_Keyboard_XY = 35
ALTGF_BuffDebuffIcon_Keyboard_Inner_XY = ALTGF_BuffDebuffIcon_Keyboard_XY - 4
ALTGF_BuffDebuffIcon_Gamepad_XY = 40
ALTGF_BuffDebuffIcon_Gamepad_Inner_XY = ALTGF_BuffDebuffIcon_Gamepad_XY - 4
ALTGF_BuffDebuffIcon_Offset = 3

local buggedLongDuration = {
	147417, -- Minor Courage
}

local function countTracked()
	local num = 0
	for _, enabled in pairs(SETTINGS.TRACK) do
		num = enabled and num + 1 or num
	end
	return num
end

local settingsOverride
local function applyStyleSettings()
	if settingsOverride ~= nil then
		ALT_GROUP_FRAMES:RemoveOverrideSettings(settingsOverride)
		settingsOverride = nil
	end

	local numTrack = countTracked()
	if SETTINGS.ENABLED and (numTrack > 0 or SETTINGS.BORDER_AB_ID > 0) then
		settingsOverride = ALT_GROUP_FRAMES:OverrideSettings()

		if numTrack > 0 then
			local platformMult = IsInGamepadPreferredMode()
					and ALTGF_BuffDebuffIcon_Gamepad_XY + ALTGF_BuffDebuffIcon_Offset
				or ALTGF_BuffDebuffIcon_Keyboard_XY + ALTGF_BuffDebuffIcon_Offset
			settingsOverride.UNIT_FRAME_PAD_X = ALTGF_BuffDebuffIcon_Offset + (numTrack * platformMult)
		end
		if SETTINGS.BORDER_AB_ID and SETTINGS.BORDER_AB_ID > 0 then
			settingsOverride.UNIT_FRAME_PAD_Y = SETTINGS.BORDER_THICK -- + ALT_GROUP_FRAMES.SAVEVARS.UNIT_FRAME_PAD_Y
		end
	end
	ALT_GROUP_FRAMES:RefreshView(true)
end
-------------------------------------
--Settings Menu--
-------------------------------------
local function InitializeAddonMenu()
	local LAM2 = LibAddonMenu2

	local abilityIdChoices = {
		0, -- select none
		-- settings use half width, so let "paired buffs" be together
		61744, -- Minor Berserk
		61745, -- Major Berserk
		147417, -- Minor Courage
		109966, -- Major Courage
		61693, -- Minor Resolve
		61694, -- Major Resolve
		61715, -- Minor Evasion
		61716, -- Major Evasion
		61735, -- Minor Expedition
		61736, -- Major Expedition
		61708, -- Minor Heroism
		61709, -- Major Heroism

		88490, -- Minor Toughness
		61691, -- Minor Prophecy
		61666, -- Minor Savagery
		61662, -- Minor Brutality
		61685, -- Minor Sorcery
		61737, -- Empower

		93109, -- Major Slayer
		61747, -- Major Force

		61771, -- Powerful Assault
		40224, -- War Horn
		38564, -- Aggressive Horn
		40221, -- Sturdy Horn
		172055, -- Pillager's Profit
		--172056, -- Pillager's Profit cooldown [does not work]
	}
	local borderChoices = {}
	for _, abilityId in ipairs(abilityIdChoices) do
		if abilityId > 0 then
			table.insert(
				borderChoices,
				zo_iconFormat(GetAbilityIcon(abilityId), 18, 18) .. " " .. GetAbilityName(abilityId)
			)
		else
			table.insert(borderChoices, "None")
		end
	end

	-- clear old/unused abilityId settings (if abilityIdChoices was changed)
	for abilityId, _ in pairs(SETTINGS.TRACK) do
		if ZO_IndexOfElementInNumericallyIndexedTable(abilityIdChoices, abilityId) == nil then
			SETTINGS.TRACK[abilityId] = nil
		end
	end

	LAM2:RegisterAddonPanel("ALTGF_BuffTrackerSettings", {
		type = "panel",
		name = "Alternative Group Frames Buffs",
		displayName = "Alternative Group Frames Buff Tracker",
		author = "|c943810BulDeZir|r",
		version = string.format("|c00FF00%s|r", 1),
	})

	local OptionControls = {
		{
			type = "description",
			text = "This module settings are Character-wide", -- \n|cff0000This module is in BETA state and may have bugs|r
		},
		{
			type = "checkbox",
			name = "Enabled",
			requiresReload = true,
			default = true,
			getFunc = function()
				return SETTINGS.ENABLED
			end,
			setFunc = function(newValue)
				SETTINGS.ENABLED = newValue
			end,
		},
		{
			type = "divider",
		},
		{
			type = "dropdown",
			name = "Track with frame border",
			choices = borderChoices,
			choicesValues = abilityIdChoices,
			disabled = function()
				return not SETTINGS.ENABLED
			end,
			getFunc = function()
				return SETTINGS.BORDER_AB_ID
			end,
			setFunc = function(newValue)
				SETTINGS.BORDER_AB_ID = newValue
				ALT_GROUP_FRAMES:ForEach(function(UnitFrame)
					if UnitFrame.borderCooldown then
						UnitFrame.borderCooldown:Reset()
					end
				end)
				applyStyleSettings()
			end,
		},
		{
			type = "colorpicker",
			name = "Frame border color",
			disabled = function()
				return not SETTINGS.ENABLED
			end,
			default = function()
				return ZO_ColorDef:New({ 0.2, 0.75, 0.15, 1 })
			end,
			getFunc = function()
				return unpack(SETTINGS.BORDER_COLOR)
			end,
			setFunc = function(...)
				SETTINGS.BORDER_COLOR = { ... }
				ALT_GROUP_FRAMES:ForEach(function(UnitFrame)
					if UnitFrame.borderCooldown then
						UnitFrame.borderCooldown:SetColor(unpack(SETTINGS.BORDER_COLOR))
					end
				end)
			end,
		},
		{
			type = "slider",
			name = "Frame border thickness",
			min = 2,
			max = 8,
			step = 1,
			disabled = function()
				return not SETTINGS.ENABLED
			end,
			default = function()
				return 6
			end,
			getFunc = function()
				return zo_round(SETTINGS.BORDER_THICK)
			end,
			setFunc = function(newValue)
				SETTINGS.BORDER_THICK = zo_round(newValue)
				ALT_GROUP_FRAMES:ForEach(function(UnitFrame)
					if UnitFrame.borderCooldown then
						UnitFrame.borderCooldown:SetThickness(SETTINGS.BORDER_THICK)
					end
				end)
				applyStyleSettings()
			end,
		},
		{
			type = "header",
			name = "Track with icon-cooldown",
		},
	}
	for i, abilityId in ipairs(abilityIdChoices) do
		if abilityId > 0 then
			table.insert(OptionControls, {
				type = "checkbox",
				name = borderChoices[i],
				width = "half",
				disabled = function()
					return not SETTINGS.ENABLED
				end,
				default = false,
				getFunc = function()
					return SETTINGS.TRACK[abilityId]
				end,
				setFunc = function(newValue)
					SETTINGS.TRACK[abilityId] = newValue
					applyStyleSettings()
				end,
			})
		end
	end

	LAM2:RegisterOptionControls("ALTGF_BuffTrackerSettings", OptionControls)
end

-------------------------------------
--Custom Container Object--
-------------------------------------
local UnitBuffTrackerContrainer

UnitBuffTrackerContrainer = ZO_BuffDebuff_ContainerObject:Subclass()

function UnitBuffTrackerContrainer:New(UnitFrame, ...)
	local object = ZO_BuffDebuff_ContainerObject.New(self, ...)

	object.iconControlTemplate = "ALTGF_BuffDebuffIcon"
	object.unitFrame = UnitFrame

	return object
end

function UnitBuffTrackerContrainer:SetIconControlTemplate(t)
	self.iconControlTemplate = t
end

function UnitBuffTrackerContrainer:ShouldContextuallyShow()
	return SETTINGS.ENABLED
end

function UnitBuffTrackerContrainer:CreateMetaPool(container, buffControlPool)
	local metaPool = ZO_MetaPool:New(buffControlPool)
	metaPool.container = container

	local function OnAcquired(control)
		control:ClearAnchors()

		if control.platformStyle ~= self.currentPlatformStyle then
			control.platformStyle = self.currentPlatformStyle
			ApplyTemplateToControl(control, ZO_GetPlatformTemplate(self.iconControlTemplate))
		end

		if not metaPool.firstControl then
			metaPool.firstControl = control
			control:SetAnchor(LEFT, container)
		else
			control:SetAnchor(LEFT, metaPool.lastControl, RIGHT, ALTGF_BuffDebuffIcon_Offset, 0)
		end

		metaPool.lastControl = control

		control:SetParent(container)
	end

	local function OnReset(control)
		control.blinkAnimation:Stop()

		control.cooldown:ResetCooldown()
		control.cooldown:SetHidden(true)
	end

	metaPool:SetCustomAcquireBehavior(OnAcquired)
	metaPool:SetCustomResetBehavior(OnReset)

	return metaPool
end

-------------------------------------
--Custom Style--
-------------------------------------
local UnitBuffTrackerStyle

UnitBuffTrackerStyle = ZO_BuffDebuffStyleObject:Subclass()
function UnitBuffTrackerStyle:New(...)
	return ZO_BuffDebuffStyleObject.New(self, ...)
end

function UnitBuffTrackerStyle:UpdateContainer(containerObject)
	ZO_ClearNumericallyIndexedTable(self.sortedBuffs)
	ZO_ClearNumericallyIndexedTable(self.sortedDebuffs)

	if containerObject:ShouldContextuallyShow() then
		local currentTime = GetFrameTimeSeconds()
		local unitTag = containerObject:GetUnitTag()
		local uid = 1

		for i = 1, GetNumBuffs(unitTag) do
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, _, castByPlayer =
				GetUnitBuffInfo(unitTag, i)
			local permanent = IsAbilityPermanent(abilityId)
			local timeRemainingS = timeEnding - currentTime

			-- d(unitTag..': '..buffName..' ['..abilityId..']')
			if
				(timeRemainingS > 0 or ZO_IsElementInNumericallyIndexedTable(buggedLongDuration, abilityId))
				and SETTINGS.TRACK[abilityId] == true
			then
				local data = {
					buffName = buffName,
					timeStarted = timeStarted,
					timeEnding = timeEnding,
					buffSlot = buffSlot,
					stackCount = stackCount,
					iconFilename = iconFilename,
					buffType = buffType,
					effectType = effectType,
					abilityType = abilityType,
					statusEffectType = statusEffectType,
					abilityId = abilityId,
					uid = uid,
					duration = timeEnding - timeStarted,
					castByPlayer = castByPlayer,
					permanent = permanent,
					isArtificial = false,
				}
				local appropriateTable = (effectType == BUFF_EFFECT_TYPE_BUFF) and self.sortedBuffs
					or self.sortedDebuffs
				table.insert(appropriateTable, data)
				uid = uid + 1
			end
		end

		if #self.sortedBuffs then
			table.sort(self.sortedBuffs, self.SortCallbackFunction)
		end
		if #self.sortedDebuffs then
			table.sort(self.sortedDebuffs, self.SortCallbackFunction)
		end

		local buffPool, debuffPool = containerObject:GetPools()

		for _, data in ipairs(self.sortedBuffs) do
			local buffControl = buffPool:AcquireObject()
			buffControl.data = data
			self:SetupIcon(buffControl)
		end

		for _, data in ipairs(self.sortedDebuffs) do
			local debuffControl = debuffPool:AcquireObject()
			debuffControl.data = data
			self:SetupIcon(debuffControl)
		end
	end
end

function UnitBuffTrackerStyle:SortFunction(buffData1, buffData2)
	-- fixed positions
	if buffData1.abilityId == buffData2.abilityId then
		return buffData1.uid < buffData2.uid
	else
		return buffData1.abilityId < buffData2.abilityId
	end
end

-------------------------------------
--Track Ability with UnitFrame Border
-------------------------------------
local BorderBuffTrack

BorderBuffTrack = ZO_Object:Subclass()
function BorderBuffTrack:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function BorderBuffTrack:Initialize(UnitFrame)
	local ns = "BuffCooldown" .. UnitFrame:GetUnitTag()
	self.control = CreateControlFromVirtual(ns, UnitFrame:GetControl(), "ALTGF_Cooldown")
	self.control:SetValue(0)
	self.control:SetColor(unpack(SETTINGS.BORDER_COLOR))
	self:SetThickness(SETTINGS.BORDER_THICK)
	UnitFrame.borderCooldown = self

	local function OnAnimationTransitionUpdate(animation, progress)
		local newBarValue = zo_lerp(animation.initialValue, animation.endValue, progress)
		self.control:SetValue(newBarValue)
	end

	self.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("ALTGF_StatusBarGrowTemplate")
	local customAnimation = self.animation:GetFirstAnimation()
	customAnimation:SetUpdateFunction(OnAnimationTransitionUpdate)

	local function PlayAnim(duration, oldValue)
		self.control:SetMinMax(0, duration * 1000)
		customAnimation.initialValue = oldValue * 1000
		customAnimation.endValue = 0
		customAnimation:SetDuration(duration * 1000)
		self.animation:PlayFromStart()
	end

	-- eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceUnitType
	local function OnBorderTrackChanged(_, changeType, _, _, _, beginTime, endTime, _, _, _, _, _, _, _, _, abilityId)
		if SETTINGS.ENABLED then
			if SETTINGS.BORDER_AB_ID and abilityId == SETTINGS.BORDER_AB_ID then
				if changeType == EFFECT_RESULT_FADED then
					self:Reset()
				else
					PlayAnim(endTime - beginTime, endTime - GetFrameTimeSeconds())
				end
			end
		end
	end

	UnitFrame:GetControl():RegisterForEvent(EVENT_EFFECT_CHANGED, OnBorderTrackChanged)
	UnitFrame:GetControl():AddFilterForEvent(EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, UnitFrame:GetUnitTag())
end

function BorderBuffTrack:SetThickness(value)
	self.control:SetHeight(value)
end

function BorderBuffTrack:SetColor(...)
	self.control:SetColor(...)
end

function BorderBuffTrack:Reset()
	self.animation:Stop()
	self.control:SetValue(0)
end

-------------------------------------
--Init--
-------------------------------------

local function Initialize()
	--local UnitBuffTrackerStyleObject = ZO_BuffDebuffCenterOutStyle:New("ALTGF_BuffDebuffCenterOutStyle_Template")
	local UnitBuffTrackerStyleObject = UnitBuffTrackerStyle:New("ALTGF_BuffDebuffCenterOutStyle_Template")

	local controlPool = ZO_ControlPool:New("ALTGF_BuffDebuffIcon", nil, "FGBuff")

	local function initFrame(UnitFrame)
		local overridenUnitTag = UnitFrame:GetUnitTag() == "player" and "customplayer" or UnitFrame:GetUnitTag()
		if BUFF_DEBUFF.containerObjectsByUnitTag[overridenUnitTag] == nil then
			BorderBuffTrack:New(UnitFrame)

			local containerControl = CreateControlFromVirtual(
				"AltGroupBuffDebuff" .. UnitFrame:GetUnitTag(),
				UnitFrame:GetControl(),
				"ZO_BuffDebuffContainerTemplate"
			)
			containerControl:ClearAnchors()
			containerControl:SetAnchor(RIGHT, UnitFrame:GetControl(), RIGHT, 0, 0)

			local containerObject = UnitBuffTrackerContrainer:New(
				UnitFrame,
				containerControl,
				controlPool,
				UnitFrame:GetUnitTag(),
				EVENT_PLAYER_ACTIVATED
			)

			containerObject:SetStyleObject(UnitBuffTrackerStyleObject, true)

			BUFF_DEBUFF:AddContainerObject(overridenUnitTag, containerObject)
		end
	end
	CALLBACK_MANAGER:RegisterCallback(ALT_GROUP_FRAMES.EVENT.UNIT_FRAME_CREATED, initFrame)
	ALT_GROUP_FRAMES:ForEach(initFrame)

	ZO_PlatformStyle:New(function()
		applyStyleSettings()
	end, 1, 2)
end

local function OnAddOnLoaded(_, addonName)
	if addonName == NAME then
		EVENT_MANAGER:UnregisterForEvent(NAME, EVENT_ADD_ON_LOADED)

		SETTINGS = ZO_SavedVars:NewCharacterIdSettings("AltGroupFramesBuffTrackerSV", SV_VER, nil, {
			ENABLED = true,
			TRACK = {},
			BORDER_AB_ID = 0,
			BORDER_COLOR = { 0.2, 0.75, 0.15, 1 },
			BORDER_THICK = 4,
		})

		InitializeAddonMenu()

		if SETTINGS.ENABLED then
			Initialize()
		end
	end
end

EVENT_MANAGER:RegisterForEvent(NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
