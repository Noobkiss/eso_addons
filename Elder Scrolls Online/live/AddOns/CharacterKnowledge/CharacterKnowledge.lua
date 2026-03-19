local LCCC = LibCodesCommonCode
local LCK = LibCharacterKnowledge
local LEJ = LibExtendedJournal

LEJ.Used = true

CharacterKnowledge = {
	name = "CharacterKnowledge",

	title = GetString(SI_CK_TITLE),
	url = "https://www.esoui.com/downloads/info2938.html",

	-- Default settings
	defaults = {
		filterId = 1,
		singleAccount = false,
		tooltips = {
			enabled = true,
			scriptInfo = true,
		},
		featureRev = 0,
	},

	-- Default settings, server-specific
	serverDefaults = {
		tooltips = {
			pinnedCharsForChapters = 1,
		},
	},

	userId = GetDisplayName(),
	charId = GetCurrentCharacterId(),
	libReady = false,
}
local CharacterKnowledge = CharacterKnowledge

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= CharacterKnowledge.name) then return end

	EVENT_MANAGER:UnregisterForEvent(CharacterKnowledge.name, EVENT_ADD_ON_LOADED)

	CharacterKnowledge.vars = ZO_SavedVars:NewAccountWide("CharacterKnowledgeSavedVariables", 1, nil, CharacterKnowledge.defaults, nil, "$InstallationWide")
	CharacterKnowledge.serverVars = ZO_SavedVars:NewAccountWide("CharacterKnowledgeSavedVariables", 1, nil, CharacterKnowledge.serverDefaults, nil, LCCC.GetServerName())
	CharacterKnowledge.RegisterSettingsPanel()

	LCCC.RegisterLinkHandler("cklck", LCK.OpenSettingsPanel)
	LCCC.RegisterLinkHandler("ckweb", function() RequestOpenUnsafeURL(CharacterKnowledge.url) end)

	LCK.RegisterForCallback(CharacterKnowledge.name, LCK.EVENT_INITIALIZED, function( )
		CharacterKnowledge.libReady = true
		CharacterKnowledge.RunOnce()
	end)

	CharacterKnowledge.InitializeBrowser()
end

function CharacterKnowledge.RunOnce( )
	-- Special one-time actions for fresh installs or upgrades
	local CURRENT_FEATURE_REV = 1

	if (CharacterKnowledge.vars.featureRev < 1) then
		CHAT_ROUTER:AddSystemMessage(GetString(SI_CK_WELCOME))
	end

	CharacterKnowledge.vars.featureRev = CURRENT_FEATURE_REV
end

do
	local matchSelectedAccount = function( character, selectedAccount )
		return character.account == selectedAccount or not selectedAccount
	end
	local matchSelectedCharacter = function( character, selectedCharId, selectedAccount )
		return character.id == selectedCharId or (not selectedCharId and matchSelectedAccount(character, selectedAccount))
	end

	function CharacterKnowledge.IsInventorySlotLearnableForSelected( slot, selectedCharId, selectedAccount )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local bindType = GetItemBindType(slot.bagId, slot.slotIndex)
		local stack = GetSlotStackSize(slot.bagId, slot.slotIndex)

		for _, character in ipairs(LCK.GetItemKnowledgeList(itemLink)) do
			if (character.knowledge == LCK.KNOWLEDGE_UNKNOWN) then
				if (bindType == BIND_TYPE_ON_PICKUP_BACKPACK) then
					if (character.id == CharacterKnowledge.charId and matchSelectedCharacter(character, selectedCharId, selectedAccount)) then
						return true
					end
				elseif (bindType ~= BIND_TYPE_ON_PICKUP or character.account == CharacterKnowledge.userId) then
					if (matchSelectedCharacter(character, selectedCharId, selectedAccount)) then
						return stack > 0
					else
						stack = stack - 1
					end
				end
			end
		end

		return false
	end

	function CharacterKnowledge.IsInventorySlotUnknownForSelected( slot, selectedCharId, selectedAccount )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)

		if (selectedCharId) then
			return LCK.GetItemKnowledgeForCharacter(itemLink, nil, selectedCharId) == LCK.KNOWLEDGE_UNKNOWN
		else
			for _, character in ipairs(LCK.GetCharacterList()) do
				if (matchSelectedAccount(character, selectedAccount) and LCK.GetItemKnowledgeForCharacter(itemLink, nil, character.id) == LCK.KNOWLEDGE_UNKNOWN) then
					return true
				end
			end
			return false
		end
	end
end

function CharacterKnowledge.RegisterSettingsPanel( )
	local LAM = LibAddonMenu2

	if (LAM) then
		local panelId = "CharacterKnowledgeSettings"

		CharacterKnowledge.settingsPanel = LAM:RegisterAddonPanel(panelId, {
			type = "panel",
			name = CharacterKnowledge.title,
			version = LCCC.FormatVersion(LCCC.GetAddOnVersion(CharacterKnowledge.name)),
			author = "@code65536",
			website = CharacterKnowledge.url,
			donation = CharacterKnowledge.url .. "#donate",
			registerForRefresh = true,
		})

		LAM:RegisterOptionControls(panelId, {
			--------------------------------------------------------------------
			{
				type = "description",
				text = SI_CK_SETTINGS_DESCRIPTION,
				enableLinks = LCK.OpenSettingsPanel,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_CK_SETTINGS_SECTION_TTCHAP,
			},
			--------------------
			{
				type = "slider",
				name = SI_CK_SETTINGS_SETTING_PINNED,
				min = 0,
				max = 6,
				getFunc = function() return CharacterKnowledge.serverVars.tooltips.pinnedCharsForChapters end,
				setFunc = function(number) CharacterKnowledge.serverVars.tooltips.pinnedCharsForChapters = number end,
				tooltip = SI_CK_SETTINGS_TOOLTIP_PINNED,
			},
			--------------------
			{
				type = "colorpicker",
				name = SI_CK_SETTINGS_SETTING_KNOWN,
				getFunc = function() return LEJ.GetTooltipColorUnpacked(1, LCK.KNOWLEDGE_KNOWN) end,
				setFunc = function(...) LEJ.SetTooltipColor(1, LCK.KNOWLEDGE_KNOWN, ...) end,
			},
			--------------------
			{
				type = "colorpicker",
				name = SI_CK_SETTINGS_SETTING_UNKNOWN,
				getFunc = function() return LEJ.GetTooltipColorUnpacked(1, LCK.KNOWLEDGE_UNKNOWN) end,
				setFunc = function(...) LEJ.SetTooltipColor(1, LCK.KNOWLEDGE_UNKNOWN, ...) end,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_CK_SETTINGS_SECTION_TTCHAR,
			},
			--------------------
			{
				type = "colorpicker",
				name = SI_CK_SETTINGS_SETTING_KNOWN,
				getFunc = function() return LEJ.GetTooltipColorUnpacked(2, LCK.KNOWLEDGE_KNOWN) end,
				setFunc = function(...) LEJ.SetTooltipColor(2, LCK.KNOWLEDGE_KNOWN, ...) end,
			},
			--------------------
			{
				type = "colorpicker",
				name = SI_CK_SETTINGS_SETTING_UNKNOWN,
				getFunc = function() return LEJ.GetTooltipColorUnpacked(2, LCK.KNOWLEDGE_UNKNOWN) end,
				setFunc = function(...) LEJ.SetTooltipColor(2, LCK.KNOWLEDGE_UNKNOWN, ...) end,
			},
			--------------------
			{
				type = "colorpicker",
				name = SI_CK_SETTINGS_SETTING_NODATA,
				getFunc = function() return LEJ.GetTooltipColorUnpacked(2, LCK.KNOWLEDGE_NODATA) end,
				setFunc = function(...) LEJ.SetTooltipColor(2, LCK.KNOWLEDGE_NODATA, ...) end,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_CK_SETTINGS_SECTION_TTEXT,
			},
			--------------------
			{
				type = "checkbox",
				name = SI_CK_SETTINGS_SETTING_TT,
				getFunc = function() return CharacterKnowledge.vars.tooltips.enabled end,
				setFunc = function( enabled )
					CharacterKnowledge.vars.tooltips.enabled = enabled
					if (enabled) then
						CharacterKnowledge.HookExternalTooltips()
					end
				end,
			},
			--------------------
			{
				type = "checkbox",
				name = string.format("|u40:0::%s|u", GetString(SI_CK_SETTINGS_SETTING_SCRIPT)),
				getFunc = function() return CharacterKnowledge.vars.tooltips.scriptInfo end,
				setFunc = function(enabled) CharacterKnowledge.vars.tooltips.scriptInfo = enabled end,
				disabled = function() return not CharacterKnowledge.vars.tooltips.enabled end
			},
		})
	end
end

EVENT_MANAGER:RegisterForEvent(CharacterKnowledge.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
