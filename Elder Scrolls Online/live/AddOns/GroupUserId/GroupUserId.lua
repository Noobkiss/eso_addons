local groupEntryPostHook
groupEntryPostHook = function(self, control, data)
  if not ZO_ShouldPreferUserId() then
    return false
  end
  control.characterNameLabel:SetText(zo_strformat(SI_GROUP_LIST_PANEL_CHARACTER_NAME, data.index, data.displayName))
  return true
end

local leaderboardEntryPostHook
leaderboardEntryPostHook = function(self, control, data)
  if not ZO_ShouldPreferUserId() then
    return false
  end
  control.nameLabel:SetText(data.displayName)
  return false
end

local refreshEmperorPostHook
refreshEmperorPostHook = function(self, control, data)
  if not ZO_ShouldPreferUserId() then
    return false
  end
  if DoesCampaignHaveEmperor(self.campaignId) then -- when there is no emperor we do nothing
	  local alliance, characterName, displayName = GetCampaignEmperorInfo(self.campaignId)
	  local emperorName = self.emperorName
	  if not emperorName then
	     return false
	  end
	  emperorName:SetText(displayName)
	  
	  emperorName:SetMouseEnabled(true)
	  emperorName:SetHandler("OnMouseEnter", function(emperorName)
		ZO_Tooltips_ShowTextTooltip(emperorName, TOP, characterName)
	  end)
		
	  emperorName:SetHandler("OnMouseExit", function(emperorName)
		ZO_Tooltips_HideTextTooltip()
	  end)
   end   

  return false
end


local socialListOnMouseEnterPostHook
socialListOnMouseEnterPostHook = function(self, control)
  if not ZO_ShouldPreferUserId() then
    return false
  end
  local row = control:GetParent()
  local data = ZO_ScrollList_GetData(row)
  InitializeTooltip(InformationTooltip)
  local textwidth = control:GetTextDimensions()
  InformationTooltip:ClearAnchors()
  InformationTooltip:SetAnchor(BOTTOM, control, TOPLEFT, textwidth * 0.5, 0)
  if data.characterName then
      SetTooltipText(InformationTooltip, data.characterName)  
  else
      SetTooltipText(InformationTooltip, data.name) 
  end
  
  return false
end

local GroupUserId
do
  local _class_0
  local _base_0 = {
    name = "GroupUserId",
    hookUI = function(self)
      ZO_PostHook(GROUP_LIST, "SetupGroupEntry", groupEntryPostHook)
      ZO_PostHook(ZO_LeaderboardsManager_Shared, "SetupLeaderboardPlayerEntry", leaderboardEntryPostHook)
	  ZO_PostHook(CampaignEmperor_Shared, "SetupLeaderboardEntry", leaderboardEntryPostHook)
	  ZO_PostHook(CampaignEmperor_Shared, "RefreshEmperor", refreshEmperorPostHook)
      return ZO_PostHook(ZO_SocialListKeyboard, "CharacterName_OnMouseEnter", socialListOnMouseEnterPostHook)
    end,
    onAddonLoaded = function(_, addonName)
      if addonName == GroupUserId.name then
        EVENT_MANAGER:UnregisterForEvent(GroupUserId.name, EVENT_ADD_ON_LOADED)
        return GroupUserId:hookUI()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "GroupUserId"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GroupUserId = _class_0
end

return EVENT_MANAGER:RegisterForEvent(GroupUserId.name, EVENT_ADD_ON_LOADED, GroupUserId.onAddonLoaded)
