---------------------------------------------
------- ADDON VARIABLES --
---------------------------------------------
RidinDirtyX = {}
local RidinDirty = {
	name = "RidinDirty",
	author = "@sinnereso",
	version = "2026.03.14",
	svName = "RidinDirtyVars",
	svVersion = 1,
}
function RidinDirty.BetaList(value)
	local names = {
	"@sinnereso",
	"@MisBHaven",
	"@snipareso",
	}
	for _, userName in ipairs(names) do
		if userName == value then return true end
	end
	return false
end
local rdLogo = "|c6666FF[RD]|r "
local hasPassenger = false
local passengerName = ""
local chatModding = false
local evacSwitch = false
local lastEvacId = 0
local playerSearch = nil
local houseSearch = nil
local chatStamp = nil
local compStamp = 0
local LCK = LibCharacterKnowledge
---------------------------------------------
--------- ADDON LOADED --
---------------------------------------------
function RidinDirty.AddOnLoaded(eventCode, addOnName)
	if addOnName ~= "RidinDirty" then return end
	-- Keybindings --
	ZO_CreateStringId("SI_BINDING_NAME_MOUNT_PLAYER", "Mount Group Member")
	ZO_CreateStringId("SI_BINDING_NAME_TRAVEL_TO_PLAYER", "Travel To Player & In Zone")
	ZO_CreateStringId("SI_BINDING_NAME_TRAVEL_TO_HOME", "Travel To Home & IC EVAC")
	ZO_CreateStringId("SI_BINDING_NAME_ARMORY_UNLOCK", "Temporary Armory Unlock")
	ZO_CreateStringId("SI_BINDING_NAME_TRADER_ACTIVITY", "Trader Activity & Enhancements")
	ZO_CreateStringId("SI_BINDING_NAME_LEAVE_GROUP", "Leave Group & Exit Instance")
	if not BUI then ZO_CreateStringId("SI_BINDING_NAME_SIEGE_CAMERA_TOGGLE", "Siege Camera Toggle") end
	ZO_CreateStringId("SI_BINDING_NAME_RELOADUI", "Reload UI")
	EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_ADD_ON_LOADED)
	RidinDirty.Initialize()--<< SAVED VARIABLES AND OPTIONS
end
---------------------------------------------
------- INITIALIZE AFTER ADDON LOADED --
---------------------------------------------
function RidinDirty.Initialize()
	local defaultAccountVars = {
		savedPlayer = "|ccc0000@NotSet|r",
		travelOutside = false,
		lockArmory = false,
		fontBoost = false,
		chatNotify = false,
		traderEnhance = false,
		withdrawOne = false,
		withdrawAmount = 25,
		companionRapport = false,
		lootLogging = false,
		lootQuality = 2,
		tauntAssist = false,
		autoQueue = false,
		autoRecharge = false,
		aptLog = false,
		minimumApT = 50,
		pvpKillFeed = false,
		pvpKillsReset = RidinDirty.GetLastDailyResetTimestamp(),
		pvpKills = 0,
		pvpDeaths = 0,
		bankStack = false,
		bankALL = false,
		houseStack = false,
		houseALL = false,
		goldDeposit = false,
		noDeposit = "|ccc0000*DISABLED*|r",
		goldReserve = 10000,
		apDeposit = false,
		apReserve = 0,
		telvarDeposit = false,
		telvarReserve = 0,
		voucherDeposit = false,
		balanceDisplay = false,
		junkManager = false,
		junkSilentMode = false,
		saveCraftables = true,
		junkTreasures = false,
		junkIntricates = false,
		junkStolen = false,
		junkMaps = false,
		junkKnownScripts = false,
	}
	local defaultCharVars = {
		charClass = GetUnitClass("player"),
		lastLogin = 0,
	}
	local defaultJunkVars = {
	}
	local defaultAddonVars = {
	}
	RidinDirty.savedVariables = ZO_SavedVars:NewAccountWide( RidinDirty.svName, RidinDirty.svVersion, nil, defaultAccountVars )
	RidinDirty.charVariables = ZO_SavedVars:NewAccountWide( RidinDirty.svName, RidinDirty.svVersion, GetUnitName("player"), defaultCharVars )
	RidinDirty.junkMemory = ZO_SavedVars:NewAccountWide( RidinDirty.svName, RidinDirty.svVersion, "Junk Memory", defaultJunkVars )
	RidinDirty.addonMemory = ZO_SavedVars:NewAccountWide( RidinDirty.svName, RidinDirty.svVersion, "Addon Memory", defaultAddonVars )
	if RidinDirty.savedVariables.lootLog ~= nil then RidinDirty.savedVariables.lootLogging = RidinDirty.savedVariables.lootLog RidinDirty.savedVariables.lootLog = nil end
	RidinDirty.savedVariables.ttcPricing = nil
	--RidinDirty.savedVariables.pvpLastReset = nil--<< SAVE
	--RidinDirty.charVariables.lastEvacId = nil--<< SAVE
	--- BASE FEATURES --
	local late = LibCustomMenu.CATEGORY_LATE
	LibCustomMenu:RegisterGuildRosterContextMenu(RidinDirty.SaveMenu, late)
	LibCustomMenu:RegisterFriendsListContextMenu(RidinDirty.SaveMenu, late)
	LibCustomMenu:RegisterGroupListContextMenu(RidinDirty.SaveMenu, late)
	EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_MOUNTED_STATE_CHANGED, RidinDirty.PassengerStateChange)
	-- ADDITIONAL FEATURES --
	if RidinDirty.savedVariables.junkManager then
		local tertiary = LibCustomMenu.CATEGORY_TERTIARY
		LibCustomMenu:RegisterContextMenu(RidinDirty.MarkPermJunkMenu, tertiary)
		LibCustomMenu:RegisterContextMenu(RidinDirty.UnMarkPermJunkMenu, tertiary)
		LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, RidinDirty.ChatLinkUnMarkMenu)
	end
	if RidinDirty.savedVariables.bankStack or RidinDirty.savedVariables.houseStack or RidinDirty.savedVariables.goldDeposit or
		RidinDirty.savedVariables.apDeposit or RidinDirty.savedVariables.telvarDeposit or RidinDirty.savedVariables.voucherDeposit or
			RidinDirty.savedVariables.balanceDisplay then EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_OPEN_BANK, RidinDirty.AutoBanking)
	end
	if RidinDirty.savedVariables.junkManager then
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.JunkManager)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyJunk", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_OPEN_STORE, RidinDirty.AutoSellRepair)
	end
	if RidinDirty.savedVariables.lockArmory then
		ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled = false
		local actionName = "ARMORY_UNLOCK"
		local textOptions = KEYBIND_TEXT_OPTIONS_ABBREVIATED_NAME
		local textureOptions = KEYBIND_TEXTURE_OPTIONS_NONE
		local bindingIndex = 1
		local bindingString = ZO_Keybindings_GetBindingStringFromAction(actionName, textOptions, textureOptions, bindingIndex)
		ARMORY_KEYBOARD.keybindStripDescriptor[2].name = ("Press " .. bindingString .. " to unlock")
	end
	if RidinDirty.savedVariables.chatNotify then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CHAT_MESSAGE_CHANNEL, RidinDirty.ChatNotify)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_FRIEND_PLAYER_STATUS_CHANGED, RidinDirty.FSC)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, RidinDirty.GSC)
	end
	if RidinDirty.savedVariables.traderEnhance then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_OPEN_TRADING_HOUSE, RidinDirty.DefaultTraderTab)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CHATTER_BEGIN, RidinDirty.TraderChatter)
	end
	if RidinDirty.savedVariables.companionRapport then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_COMPANION_RAPPORT_UPDATE, RidinDirty.CompanionRapport)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyCompDeath", EVENT_UNIT_DEATH_STATE_CHANGED, RidinDirty.CompanionDeathStateChanged)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyCompDeath", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "companion")
	end
	if RidinDirty.savedVariables.autoQueue then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, RidinDirty.AutoQueue)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CAMPAIGN_QUEUE_STATE_CHANGED, RidinDirty.AutoPvpQueue)
	end
	if RidinDirty.savedVariables.autoRecharge then
		EVENT_MANAGER:RegisterForEvent("RidinDirtyRepair", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.AutoRepCharge)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyRepair", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_CLOSE_STORE, RidinDirty.BrokenGearCheck)
	end
	if RidinDirty.savedVariables.tauntAssist then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PLAYER_COMBAT_STATE, RidinDirty.CombatState)
		SCENE_MANAGER:RegisterCallback("SceneStateChanged", RidinDirty.SceneStateChanged)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyPlayerDeath", EVENT_UNIT_DEATH_STATE_CHANGED, RidinDirty.PlayerDeathStateChanged)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyPlayerDeath", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "player")
	end
	if RidinDirty.savedVariables.withdrawOne then
		local primary = LibCustomMenu.CATEGORY_PRIMARY
		LibCustomMenu:RegisterContextMenu(RidinDirty.WithdrawMenu, primary)
	end
	if RidinDirty.savedVariables.aptLog then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_ALLIANCE_POINT_UPDATE, RidinDirty.ApLog)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_TELVAR_STONE_UPDATE, RidinDirty.TelvarLog)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PENDING_CURRENCY_REWARD_CACHED, RidinDirty.ApLog)
	end
	if RidinDirty.savedVariables.lootLogging then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_LOOT_RECEIVED, RidinDirty.lootLogging)
		--ZO_PostHook(ItemTooltip, "SetBagItem", function(tooltipControl, bagId, slotIndex)--SecurePostHook--ItemTooltip, "SetBagItem",
			 --1. Get the Item Link to identify the item
			--local itemLink = GetItemLink(bagId, slotIndex)
			 --2. Add your custom text to the tooltip
			--if itemLink ~= "" then
				--ItemTooltip:AddLine("TESTING")
			--end
			--ZO_Tooltip_AddDivider(ItemTooltip)
			--ItemTooltip:AddLine("Custom Information Here", "", 1, 1, 1)
		--end)
		for _, i in pairs(PLAYER_INVENTORY.inventories) do
			local ListView = i.listView
			if ListView and ListView.dataTypes and ListView.dataTypes[1] and ListView:GetName() ~= "ZO_PlayerInventoryQuest" then
				local DataType = ListView.dataTypes[1]
				SecurePostHook(DataType, 'setupCallback', function(control, slot)
					if SCENE_MANAGER:GetCurrentScene() ~= STABLES_SCENE then
						RidinDirty.NeedsSuggestedPrice(control, slot)
					end
				end)
			end
		end
		--deconstruction (assistant)
		SecurePostHook(ZO_UniversalDeconstructionTopLevel_KeyboardPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--deconstruction (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--refinement (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelRefinementPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--improvement (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelImprovementPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--enchanting (crafting stations)
		SecurePostHook(ZO_EnchantingTopLevelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
	end
	if RidinDirty.savedVariables.pvpKillFeed then
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PVP_KILL_FEED_DEATH, RidinDirty.PvpKillFeed)
		--ZO_PreHook("Logout", RidinDirty.SetClearKillFeed(false))
		--ZO_PreHook("Quit", RidinDirty.SetClearKillFeed(false))
	end
	if os.time() > (RidinDirty.savedVariables.pvpKillsReset + 86400) then RidinDirty.SetClearKillFeed(false) end
	EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PLAYER_ACTIVATED, RidinDirty.PlayerActivated)
	RidinDirty.charVariables.lastLogin = (GetDate() .. "[" .. ZO_FormatClockTime() .. "]")
	RidinDirty.CreateSettingsWindow()--<< CREATE SETTINGS PANEL
end
---------------------------------------------
--------- SETTINGS PANEL --
---------------------------------------------
function RidinDirty.GetSettingsCharacterList()--<< SETTINGS CHARACTER LIST
	local charList = {}
	local disabled = "|ccc0000*DISABLED*|r"
	local count = 1
	for i = 1, GetNumCharacters() do
		local charName = GetCharacterInfo(i)
		charName = charName:sub(1, charName:find("%^") - 1)
		if count == 1 then table.insert(charList, disabled) end
		if (nil == charList[charName]) then
			table.insert(charList, charName)
		end
		count = (count + 1)
	end
	return charList
end

function RidinDirty.CreateSettingsWindow()
	local panelName = "RidinDirtySettingsPanel"
	local panelData = {
		type = "panel",
		name = "RidinDirty",
		displayName = "|c6666FFRIDINDIRTY|r",
		author = RidinDirty.author,
		version = RidinDirty.version,
		feedback = "https://www.esoui.com/downloads/info3560-RidinDirty.html#comments",
		registerForRefresh = true,
	}
	local optionsData = {
    {
		type = "header",
		name = "|c999900TRAVEL SETTINGS|r",
		width = "full",
    },
    {
		type = "description",
		text = ("Saved Player: " .. RidinDirty.savedVariables.savedPlayer),
		reference = "RIDINDIRTY_SETTINGS_SAVEDPLAYER_TEXT",
		width = "half",
	},
	{
		type = "checkbox",
		name = "Travel Home (Outside)",
		getFunc = function() return RidinDirty.savedVariables.travelOutside end,
		setFunc = function(value) RidinDirty.TravelHomeToggle(value) end,
		width = "half",
	},
	{
        type = "submenu",
        name = "|c999900BANK, STORAGE & INVENTORY MANAGEMENT|r",
        controls = {
            {
				type = "checkbox",
				name = "Auto Bank Deposit",
				tooltip = "Fills select existing stacks in bank. Does not stack foods, drinks, potions, poisons, soul gems or tools",
				getFunc = function() return RidinDirty.savedVariables.bankStack end,
				setFunc = function(value) RidinDirty.savedVariables.bankStack = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "checkbox",
				name = "              Deposit ALL",
				tooltip = "Fills ALL existing stacks in bank",
				getFunc = function() return RidinDirty.savedVariables.bankALL end,
				setFunc = function(value) RidinDirty.savedVariables.bankALL = (value) end,
				disabled = function() return not RidinDirty.savedVariables.bankStack end,
			},
			{
				type = "checkbox",
				name = "Auto House Deposit",
				tooltip = "Fills select existing stacks in house storages. Does not stack foods, drinks, potions, poisons, soul gems or tools",
				getFunc = function() return RidinDirty.savedVariables.houseStack end,
				setFunc = function(value) RidinDirty.savedVariables.houseStack = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "checkbox",
				name = "              Deposit ALL",
				tooltip = "Fills ALL existing stacks in house storages",
				getFunc = function() return RidinDirty.savedVariables.houseALL end,
				setFunc = function(value) RidinDirty.savedVariables.houseALL = (value) end,
				disabled = function() return not RidinDirty.savedVariables.houseStack end,
			},
			{
				type = "header",
				name = "|c999900CURRENCY SETTINGS|r",
				width = "full",
			},
			{
				type = "checkbox",
				name = "Auto Gold Deposit",
				tooltip = "Auto deposits or withdraws gold above or below GOLD RESERVE to or from bank",
				getFunc = function() return RidinDirty.savedVariables.goldDeposit end,
				setFunc = function(value) RidinDirty.savedVariables.goldDeposit = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "dropdown",
				name = "          Gold Reserve",
				tooltip = "Maximum gold to reserve on each character",
				choices = {"|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "0", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "10,000", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "50,000", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "100,000", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "500,000", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "1,000,000", "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. "10,000,000"},
				choicesValues = {0, 10000, 50000, 100000, 500000, 1000000, 10000000},
				getFunc = function() return RidinDirty.savedVariables.goldReserve end,
				setFunc = function(var) RidinDirty.savedVariables.goldReserve = (var) end,
				disabled = function() return not RidinDirty.savedVariables.goldDeposit end,
			},
			{
				type = "dropdown",
				name = "          Gold Hoarder",
				tooltip = "Character that does not auto deposit gold per account",
				choices = RidinDirty.GetSettingsCharacterList(),
				getFunc = function() return RidinDirty.savedVariables.noDeposit end,
				setFunc = function(var) RidinDirty.savedVariables.noDeposit = (var) end,
				disabled = function() return not RidinDirty.savedVariables.goldDeposit end,
			},
			{
				type = "checkbox",
				name = "Auto (AP) Deposit",
				tooltip = "Auto deposits ALL alliance points into bank",
				getFunc = function() return RidinDirty.savedVariables.apDeposit end,
				setFunc = function(value) RidinDirty.savedVariables.apDeposit = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "dropdown",---------------------------
				name = "          (AP) Reserve",
				tooltip = "Maximum AP to reserve on each character",
				choices = {"|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "0", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "10,000", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "50,000", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "100,000", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "500,000", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "1,000,000", "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "10,000,000"},
				choicesValues = {0, 10000, 50000, 100000, 500000, 1000000, 10000000},
				getFunc = function() return RidinDirty.savedVariables.apReserve end,
				setFunc = function(var) RidinDirty.savedVariables.apReserve = (var) end,
				disabled = function() return not RidinDirty.savedVariables.apDeposit end,
			},
			{
				type = "checkbox",
				name = "Auto Telvar Deposit",
				tooltip = "Auto deposits or withdraws telvar stones above or below TELVAR RESERVE to or from bank",
				getFunc = function() return RidinDirty.savedVariables.telvarDeposit end,
				setFunc = function(value) RidinDirty.savedVariables.telvarDeposit = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "dropdown",
				name = "          Telvar Reserve",
				tooltip = "Maximum telvar to reserve on each character for X multiplier",
				choices = {"|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "0", "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "100", "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "1,000", "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "10,000"},
				choicesValues = {0, 100, 1000, 10000},
				choicesTooltips = {"No Multiplier", "2X Multiplier", "3X Multiplier", "4X Multiplier"},
				getFunc = function() return RidinDirty.savedVariables.telvarReserve end,
				setFunc = function(var) RidinDirty.savedVariables.telvarReserve = (var) end,
				disabled = function() return not RidinDirty.savedVariables.telvarDeposit end,
			},
			{
				type = "checkbox",
				name = "Auto Voucher Deposit",
				tooltip = "Auto deposits ALL writ vouchers into bank",
				getFunc = function() return RidinDirty.savedVariables.voucherDeposit end,
				setFunc = function(value) RidinDirty.savedVariables.voucherDeposit = (value) end,
				warning = "Temporarily disables while crafting writ active",
			},
			{
				type = "checkbox",
				name = "Display Bank Balances",
				tooltip = "Displays all banked balances to chat when opening the bank or after auto balancing",
				getFunc = function() return RidinDirty.savedVariables.balanceDisplay end,
				setFunc = function(value) RidinDirty.savedVariables.balanceDisplay = (value) end,
			},
			{
				type = "header",
				name = "|c999900JUNK MANAGER SETTINGS|r",
				width = "full",
			},
			{
				type = "checkbox",
				name = "Auto Junk Manager",
				tooltip = "Marks & sells all trash, monster trophy's, rare fish and ornates plus enabled options below. Also self cleans junk list of enabled options below as looted and repairs all gear at merchants",
				getFunc = function() return RidinDirty.savedVariables.junkManager end,
				setFunc = function(value) RidinDirty.JunkManagerToggle(value) end,
				width = "half",
			},
			{
				type = "checkbox",
				name = "Silent Junk Mode",
				tooltip = "Silently move junk without chat output",
				getFunc = function() return RidinDirty.savedVariables.junkSilentMode end,
				setFunc = function(value) RidinDirty.savedVariables.junkSilentMode = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
				width = "half",
			},
			{
				type = "checkbox",
				name = "         Save Craftables",
				tooltip = "Don't move all newly crafted items to junk",
				getFunc = function() return RidinDirty.savedVariables.saveCraftables end,
				setFunc = function(value) RidinDirty.savedVariables.saveCraftables = (value) end,
				disabled = function() return RidinDirty.savedVariables.junkManager or not RidinDirty.savedVariables.junkManager end,
				warning = "Forced on for crafting writ compatibility",
			},
			{
				type = "checkbox",
				name = "          Junk Intricates",
				tooltip = "Move all newly looted intricates to junk",
				getFunc = function() return RidinDirty.savedVariables.junkIntricates end,
				setFunc = function(value) RidinDirty.savedVariables.junkIntricates = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
			},
			{
				type = "checkbox",
				name = "         Junk Treasures",
				tooltip = "Move all newly looted treasures with a value greater than 0 to junk",
				getFunc = function() return RidinDirty.savedVariables.junkTreasures end,
				setFunc = function(value) RidinDirty.savedVariables.junkTreasures = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
			},
			{
				type = "checkbox",
				name = "     Junk Stolen Items",
				tooltip = "Move all newly looted stolen items to junk",
				getFunc = function() return RidinDirty.savedVariables.junkStolen end,
				setFunc = function(value) RidinDirty.savedVariables.junkStolen = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
			},
			{
				type = "checkbox",
				name = "  Junk Known Scripts",
				tooltip = "Move all newly looted known scribing scripts to junk",
				getFunc = function() return RidinDirty.savedVariables.junkKnownScripts end,
				setFunc = function(value) RidinDirty.savedVariables.junkKnownScripts = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
				warning = "Requires LibCharacterKnowledge to detect what is knownst on other characters",
			},
			{
				type = "checkbox",
				name = " Junk Treasure Maps",
				tooltip = "Move all newly looted treasure maps to junk",
				getFunc = function() return RidinDirty.savedVariables.junkMaps end,
				setFunc = function(value) RidinDirty.savedVariables.junkMaps = (value) end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
			},
			{
				type = "button",
				name = "|ccc0000RESET JUNK LIST|r",
				tooltip = "Clears and completely resets junk list & reloads UI. *Can't be undone!*",
				func = function() RidinDirty.ClearJunkList() end,
				disabled = function() return not RidinDirty.savedVariables.junkManager end,
				width = "full",
			},
		},
	},
	{
		type = "header",
		name = "|c999900ADDITIONAL FEATURES|r",
		width = "full",
    },
	{
		type = "checkbox",
		name = "Lock Armory Save Build",
		tooltip = "Locks armory save build button from accidental use",
		getFunc = function() return RidinDirty.savedVariables.lockArmory end,
		setFunc = function(value) RidinDirty.LockArmoryToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Nameplate Font Boost",
		tooltip = "Increase nameplate font size from 20pt to 28pt",
		getFunc = function() return RidinDirty.savedVariables.fontBoost end,
		setFunc = function(value) RidinDirty.NamePlatesToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Channel Notifications",
		tooltip = "Audio notification of whispers, group and yells in any channel and enhanced saved player login / logout / away info",
		getFunc = function() return RidinDirty.savedVariables.chatNotify end,
		setFunc = function(value) RidinDirty.ChatNotifyToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Log Companion Info",
		tooltip = "Logs companion rapport changes to chat with display of current / maximum rapport & notifies on companion death",
		getFunc = function() return RidinDirty.savedVariables.companionRapport end,
		setFunc = function(value) RidinDirty.CompanionRapportToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Auto Accept Queues",
		tooltip = "Auto accept queues for dungeons, battlegrounds, cyrodiil and imperial city",
		getFunc = function() return RidinDirty.savedVariables.autoQueue end,
		setFunc = function(value) RidinDirty.AutoQueueToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Trader Enhancements",
		tooltip = "Adds guild cycling / weekly trader activity to keybind and skip dialogs / auto last search",
		getFunc = function() return RidinDirty.savedVariables.traderEnhance end,
		setFunc = function(value) RidinDirty.TraderEnhanceToggle(value) end,
		warning = "likely not compatible with AwesomeGuildStore",
	},
	{
		type = "checkbox",
		name = "Combat & Taunt Reticle",
		tooltip = "Shows if in combat or target taunt time left(more aggressively as TANK role) in the center of reticle",
		getFunc = function() return RidinDirty.savedVariables.tauntAssist end,
		setFunc = function(value) RidinDirty.TauntAssistToggle(value) end,
	},
	{
		type = "checkbox",
		name = "Auto Recharge & Repair",
		tooltip = "Auto recharges and repairs weapons and gear in combat with gems or repair kits at a fixed optimal threshold",
		getFunc = function() return RidinDirty.savedVariables.autoRecharge end,
		setFunc = function(value) RidinDirty.RechargeToggle(value) end,
		disabled = function() return not RidinDirty.savedVariables.junkManager end,
	},
	{
		type = "checkbox",
		name = "Withdraw Custom Amounts",
		tooltip = "Adds popup withdraw 1 and withdraw(custom) to all storages if stack size permits",
		getFunc = function() return RidinDirty.savedVariables.withdrawOne end,
		setFunc = function(value) RidinDirty.WithdrawOneToggle(value) end,
		width = "half",
	},
	{
        type = "slider",
        name = "Custom withdraw amount",
		tooltip = "Amount for additional popup withdraw option from all storages if stack size permits",
        min = 10,
        max = 50,
        step = 5,
        getFunc = function() return RidinDirty.savedVariables.withdrawAmount end,
        setFunc = function(value) RidinDirty.savedVariables.withdrawAmount = (value) end,
		disabled = function() return not RidinDirty.savedVariables.withdrawOne end,
		width = "half",
	},
	{
		type = "checkbox",
		name = "AP & Telvar Log To Chat",
		tooltip = "Displays ap and telvar gains in chat window",
		getFunc = function() return RidinDirty.savedVariables.aptLog end,
		setFunc = function(value) RidinDirty.ApTLogToggle(value) end,
		width = "half",
	},
	{
        type = "slider",
        name = "Minimum AP & Telvar Logged",
		tooltip = "Minimum ap and telvar to display in chat window",
        min = 10,
        max = 100,
        step = 10,
        getFunc = function() return RidinDirty.savedVariables.minimumApT end,
        setFunc = function(value) RidinDirty.MinimumApT(value) end,
		disabled = function() return not RidinDirty.savedVariables.aptLog end,
		width = "half",
	},
	{
		type = "checkbox",
		name = "Loot Logging & TTC Pricing",
		tooltip = "Basic loot logging to chat and Filters out most trash and anything below selected quality with a minimal whitelist. Also utilizes TTC if available for custom inventory suggested pricing intended to mitigate malicious trading activity",
		getFunc = function() return RidinDirty.savedVariables.lootLogging end,
		setFunc = function(value) RidinDirty.lootLoggingToggle(value) end,
		warning = "Disabling requires reload to properly unload certain aspects",
		width = "half",
	},
	{
		type = "dropdown",
		name = "Loot Logging Minimum Quality",
		tooltip = "Minimum general loot quality to log to chat",
		choices = {"|cF8FAFCWHITE|r", "|c7CCF35GREEN|r", "|c2B7FFFBLUE|r", "|cAD46FFPURPLE|r", "|cFFDF20GOLD|r"},
		choicesValues = {1, 2, 3, 4, 5},
		getFunc = function() return RidinDirty.savedVariables.lootQuality end,
		setFunc = function(var) RidinDirty.savedVariables.lootQuality = (var) end,
		disabled = function() return not RidinDirty.savedVariables.lootLogging end,
		warning = "Requires LibCharacterKnowledge to detect what is knownst on other characters & TTC for pricing data",
		width = "half",
	},
	{
		type = "checkbox",
		name = "PvP Personal / Group Kill Feed",
		tooltip = "Enables personal / group kill feed including personal total daily killing blows, deaths and ratio% in cyrodiil, imperial city & battlegrounds",
		getFunc = function() return RidinDirty.savedVariables.pvpKillFeed end,
		setFunc = function(value) RidinDirty.PvpKillFeedToggle(value) end,
		warning = "Audio feedback only if ingame global kill feed is enabled",
	},
	{
		type = "button",
		name = "|ccc0000CLEAR & SET|r",
		tooltip = "Set to current time for daily reset & clear daily statistics for pvp personal kill feed",
		func = function() RidinDirty.SetClearKillFeed(true) end,
		disabled = function() return not RidinDirty.savedVariables.pvpKillFeed end,
		width = "half",
	},
	{
		type = "button",
		name = "|ccc0000RESET TO DEFAULT|r",
		tooltip = "Reset to default original daily reset time for pvp personal kill feed",
		func = function() RidinDirty.ResetKillFeed() end,
		disabled = function() return not RidinDirty.savedVariables.pvpKillFeed end,
		width = "half",
	},
	{
		type = "header",
		name = "|c999900SLASH FUNCTIONS|r",
		width = "full",
    },
	{
		type = "description",
		text = ("/tp partialoverworldzonename or /tp exact@name partialhousename\n/junklist = Print junk memory to chat for review & edit\n/rdfc = Time remaining to use forward camp in cyrodiil\n/rdc = Writworthy craftqueue windows\n/rdt = Group trade chat links for BoP tradeable items that you don't need\n/rdpvp on/off = PvP performance mode toggle for saved addons below"),
	},
	{
		type = "button",
		name = "|ccc0000SAVE ENABLED ADDONS|r",
		tooltip = "Saves list of currently enabled addons you want for PvP performance mode",
		func = function() RidinDirty.AddonSave() end,
	},
	}
	local LAM2 = LibAddonMenu2
	RidinDirty.settingsPanel = LAM2:RegisterAddonPanel(panelName, panelData)
	LAM2:RegisterOptionControls(panelName, optionsData)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", function(panel)
		if panel ~= RidinDirty.settingsPanel then return end
		RidinDirty.UpdateSettingsSavedPlayer(RidinDirty.savedVariables.savedPlayer)
	end)
	RidinDirty.Controls()--<< CREATE CONTROLS
end
	--CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(panel)
		--if panel ~= RidinDirty.settingsPanel then return end
		--RidinDirty.UpdateSettingsSavedPlayer(RidinDirty.savedVariables.savedPlayer)
	--end)
---------------------------------------------
------ CONTROLS & ANIMATIONS
---------------------------------------------
function RidinDirty.Controls()
	-- Ouroboros Hourglass Animation --
	RidinDirty.HourGlass = WINDOW_MANAGER:CreateTopLevelWindow("HourGlass")
	RidinDirty.HourGlass.image = WINDOW_MANAGER:CreateControl("HourGlassImage", RidinDirty.HourGlass, CT_TEXTURE)
	RidinDirty.HourGlass.label = WINDOW_MANAGER:CreateControl("HourGlassLabel", RidinDirty.HourGlass, CT_LABEL)
	RidinDirty.HourGlass:SetDimensions(128,128)
	RidinDirty.HourGlass:SetAnchor(CENTER, GuiRoot, TOP, 0, 300)
	RidinDirty.HourGlass.image:SetAnchorFill(RidinDirty.HourGlass)
	RidinDirty.HourGlass.image:SetTexture("/esoui/art/screens_app/load_ourosboros.dds")
	RidinDirty.HourGlass.label:SetAnchor(CENTER, RidinDirty.HourGlass, CENTER, 0, -60)
	RidinDirty.HourGlass.label:SetColor( 128,128,0,0.8 )
	RidinDirty.HourGlass.label:SetHorizontalAlignment( CENTER )
	RidinDirty.HourGlass.label:SetVerticalAlignment( CENTER )
	RidinDirty.HourGlass.label:SetFont("ZoFontWinH2")
	RidinDirty.HourGlass.label:SetText ("")
	RidinDirty.HourGlass.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("LoadIconAnimation", RidinDirty.HourGlass.image)
	RidinDirty.HourGlass.animation:GetFirstAnimation():SetDuration(6000)
	RidinDirty.HourGlass:SetTopmost()
	RidinDirty.HourGlass:SetHidden(true)
	-- Combat Indicator --
	RidinDirty.Combat = WINDOW_MANAGER:CreateTopLevelWindow("Combat")
	RidinDirty.Combat.image = WINDOW_MANAGER:CreateControl("CombatImage", RidinDirty.Combat, CT_TEXTURE)
	RidinDirty.Combat:SetDimensions(32,32)
	RidinDirty.Combat:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
	RidinDirty.Combat.image:SetAnchorFill(RidinDirty.Combat)
	RidinDirty.Combat.image:SetTexture("/esoui/art/mainmenu/menubar_map_up.dds")
	RidinDirty.Combat.image:SetTransformRotationZ(math.rad(45))
	RidinDirty.Combat.image:SetColor( 128,0,0,1 )
	RidinDirty.Combat:SetTopmost()
	RidinDirty.Combat:SetHidden(true)
	-- Taunt Timer Indicator --
	RidinDirty.TauntCounter = WINDOW_MANAGER:CreateTopLevelWindow("TauntCounter")
	RidinDirty.TauntCounter.label = WINDOW_MANAGER:CreateControl("TauntCounterLabel", RidinDirty.TauntCounter, CT_LABEL)
	RidinDirty.TauntCounter:SetDimensions(64,64)
	RidinDirty.TauntCounter:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
	RidinDirty.TauntCounter.label:SetAnchor(CENTER, RidinDirty.TauntCounter, CENTER, 0, 0)
	RidinDirty.TauntCounter.label:SetColor( 128,128,128,1 )
	RidinDirty.TauntCounter.label:SetHorizontalAlignment( CENTER )
	RidinDirty.TauntCounter.label:SetVerticalAlignment( CENTER )
	RidinDirty.TauntCounter.label:SetFont("ZoFontWinH4")
	RidinDirty.TauntCounter.label:SetText ("")
	RidinDirty.TauntCounter:SetTopmost()
	RidinDirty.TauntCounter:SetHidden(true)
	-- Addon Load Complete --
end
---------------------------------------------
-------- PLAYER ACTIVATED --
---------------------------------------------
function RidinDirty.PlayerActivated()
	if not RidinDirty.HourGlass:IsHidden() then
		RidinDirty.HourGlass:SetHidden(true)
		RidinDirty.HourGlass.animation:Stop()
		if evacSwitch then
			zo_callLater(function() if not IsPlayerMoving() then QueueForCampaign(lastEvacId) PlaySound("PlayerAction_NotEnoughMoney")
				df(rdLogo .. "*Imperial City Return In (3s)*") evacSwitch = false
					else ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Movement Detected! EVAC Halted!") evacSwitch = false end
						end, 7000)
		end
		if IsInCampaign() and GetAssignedCampaignId() == GetCurrentCampaignId() and RidinDirty.GetHomeCampLeadScore() and not evacSwitch then
			local rank, points = RidinDirty.GetHomeCampLeadScore()
			df(rdLogo .. "You are currently ranked " .. rank .. " with " .. points .. " points")
		end
	end
	if RidinDirty.savedVariables.lockArmory and ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled ~= false then
		ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled = false
		local actionName = "ARMORY_UNLOCK"
		local textOptions = KEYBIND_TEXT_OPTIONS_ABBREVIATED_NAME
		local textureOptions = KEYBIND_TEXTURE_OPTIONS_NONE
		local bindingIndex = 1
		local bindingString = ZO_Keybindings_GetBindingStringFromAction(actionName, textOptions, textureOptions, bindingIndex)
		ARMORY_KEYBOARD.keybindStripDescriptor[2].name = ("Press " .. bindingString .. " to unlock")
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Armory save build auto locked.")
	end
	if not chatModding and RidinDirty.savedVariables.lootLogging then
		chatModding = true
		local origFormatter = CHAT_ROUTER:GetRegisteredMessageFormatters()[EVENT_CHAT_MESSAGE_CHANNEL]
		CHAT_ROUTER:RegisterMessageFormatter(EVENT_CHAT_MESSAGE_CHANNEL, function(channelType, fromName, text, isCustomerService, fromDisplayName)
			local formattedText, saveTarget, _, originalText = origFormatter(channelType, fromName, text, isCustomerService, fromDisplayName)
			local modifiedText = formattedText
			local isNeeded = ""
			for itemLink in formattedText:gmatch("|H.-|h.-|h") do
				local itemId = GetItemLinkItemId(itemLink)
				local itemType, specialType = GetItemLinkItemType(itemLink)
				if RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) then 
					isNeeded = RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType)
						modifiedText = string.gsub(modifiedText, itemLink, (isNeeded .. itemLink)) end
			end
			return modifiedText, saveTarget, fromDisplayName, originalText end)
	end
	if RidinDirty.savedVariables.fontBoost then
		SetNameplateKeyboardFont(string.format("%s|%d", "$(BOLD_FONT)", "28"), FONT_STYLE_SOFT_SHADOW_THIN)
	end
	RidinDirty.PassengerStateChange()
	--if RidinDirty.BetaList(GetUnitDisplayName("player")) and IsCollectibleUnlocked(1384) and IsCollectibleUsable(1384) and GetCollectibleCooldownAndDuration(1384) == 0 then
		--UseCollectible(1384)
	--end
end
---------------------------------------------
---------- SAVE PLAYER --
---------------------------------------------
function RidinDirty.SaveMenu(data)
	if data.displayName == GetUnitDisplayName("player") then return end
	AddCustomMenuItem("Save for RidinDirty", function() RidinDirty.SavePlayer(data.displayName) end)
end

function RidinDirty.SavePlayer(displayName)
	RidinDirty.savedVariables.savedPlayer = displayName
	df(rdLogo .. "Saving: " .. displayName)
	RidinDirty.UpdateSettingsSavedPlayer(displayName)
end

function RidinDirty.UpdateSettingsSavedPlayer(displayName)
	if RIDINDIRTY_SETTINGS_SAVEDPLAYER_TEXT ~= nil then
		RIDINDIRTY_SETTINGS_SAVEDPLAYER_TEXT.data.text = ("Saved Player: " .. displayName)
		RIDINDIRTY_SETTINGS_SAVEDPLAYER_TEXT:UpdateValue()
	end
end
---------------------------------------------
-------- MOUNT GROUP MEMBER --
---------------------------------------------
function RidinDirtyX.MountPlayer()
	local displayNamePref = nil
	local isMountable = false
	for iD = 1, GetGroupSize() do
		local playerID = GetGroupUnitTagByIndex(iD)
		local playerCharName = GetUnitName(playerID)
		local playerDisplayName = GetUnitDisplayName(playerID)
		local mountedState, hasEnabledGroupMount, hasFreePassengerSlot = GetTargetMountedStateInfo(playerDisplayName)
		if mountedState == MOUNTED_STATE_MOUNT_RIDER and hasEnabledGroupMount and hasFreePassengerSlot then isMountable = true else isMountable = false end
		if not ZO_ShouldPreferUserId() then displayNamePref = playerCharName else displayNamePref = playerDisplayName end
		displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
		if playerDisplayName ~= GetUnitDisplayName("player") and IsUnitOnline(playerID) and IsUnitInGroupSupportRange(playerID) and isMountable and RidinDirty.DistanceToUnit(playerID) < 5.0 then
			local dismount = RidinDirty.Dismount()
			CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_SMALL_TEXT, "New_Mail", ("|cC99912Mounting " .. displayNamePref .. "|r"), nil, nil, nil, nil, nil, 5000, nil)
			UseMountAsPassenger(playerDisplayName)
			return
		end
	end
	ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "No player in group mountable.")
end

function RidinDirty.PassengerStateChange(eventCode, isMounted)
	local mountedState, hasEnabledGroupMount, hasFreePassengerSlot = GetTargetMountedStateInfo(GetUnitDisplayName("player"))
	if mountedState ~= MOUNTED_STATE_MOUNT_RIDER or not hasEnabledGroupMount then
		hasPassenger = false
		return
	elseif mountedState == MOUNTED_STATE_MOUNT_RIDER and hasEnabledGroupMount and hasFreePassengerSlot and hasPassenger then
		hasPassenger = false CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_SMALL_TEXT, "New_Mail", ("|cC99912" .. tostring(passengerName) .. " has dismounted|r"), nil, nil, nil, nil, nil, 5000, nil)
	elseif mountedState == MOUNTED_STATE_MOUNT_RIDER and hasEnabledGroupMount and not hasFreePassengerSlot and not hasPassenger then
		hasPassenger = true CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_SMALL_TEXT, "New_Mail", ("|cC99912" .. tostring(RidinDirty.GetPassengerName()) .. " is RidinDirty|r"), nil, nil, nil, nil, nil, 5000, nil)
	end
	if mountedState == MOUNTED_STATE_MOUNT_RIDER and hasEnabledGroupMount then zo_callLater(function() RidinDirty.PassengerStateChange() end, 1000) end
end

function RidinDirty.GetPassengerName()
	local displayNamePref = nil
	for iD = 1, GetGroupSize() do
		local playerID = GetGroupUnitTagByIndex(iD)
		local charName = GetUnitName(playerID)
		local displayName = GetUnitDisplayName(playerID)
		local mountedState, hasEnabledGroupMount, hasFreePassengerSlot = GetTargetMountedStateInfo(displayName)
		if mountedState == MOUNTED_STATE_MOUNT_PASSENGER and RidinDirty.DistanceToUnit(playerID) < 0.1 then
			if not ZO_ShouldPreferUserId() then displayNamePref = charName else displayNamePref = displayName end
			displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
			passengerName = displayNamePref
			return displayNamePref
		end
	end
	return "UNKNOWN"
end
---------------------------------------------
-------- TRAVEL TO SAVED PLAYER OR In Zone --
---------------------------------------------
function RidinDirtyX.TravelToPlayer()
	local savedPlayer = RidinDirty.savedVariables.savedPlayer
	local displayNamePref = nil
	local spOnline = false
	if IsInCampaign() or IsActiveWorldBattleground() then ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Unable to travel from " .. GetUnitZone("player") .. ".")) return end
	for sP = 1, GetGroupSize() do
		local playerID = GetGroupUnitTagByIndex(iD)
		local playerDisplayName = GetUnitDisplayName(playerID)
		if playerDisplayName == savedPlayer and IsUnitOnline(playerID) then
			spOnline = true
		end
	end
	for iD = 1, GetGroupSize() do
		local playerID = GetGroupUnitTagByIndex(iD)
		local zoneName = GetUnitZone(playerID)
		local zoneIndex = GetUnitZoneIndex(playerID)
		local zoneID = GetZoneId(zoneIndex)
		local playerCharName = GetUnitName(playerID)
		local playerDisplayName = GetUnitDisplayName(playerID)
		if not ZO_ShouldPreferUserId() then displayNamePref = playerCharName else displayNamePref = playerDisplayName end
		displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
		if playerDisplayName == savedPlayer and IsUnitOnline(playerID) then
			if IsUnitInCombat("player") then
				if not RidinDirty.HourGlass:IsHidden() then
					RidinDirty.TeleportPlayerQueueOff()
					return
				else
					RidinDirty.TeleportPlayerQueueOn(displayNamePref)
					return
				end
			else
				local dismount = RidinDirty.Dismount()
				df(rdLogo .. "Traveling to " .. displayNamePref .. " in " .. GetUnitZone(playerID))
				JumpToGroupMember(savedPlayer)
				return
			end
		elseif playerDisplayName ~= GetUnitDisplayName("player") and zoneName == GetUnitZone("player") and IsUnitOnline(playerID) and not spOnline then
			if IsUnitInCombat("player") then
				if not RidinDirty.HourGlass:IsHidden() then
					RidinDirty.TeleportPlayerQueueOff()
					return
				else
					RidinDirty.TeleportPlayerQueueOn(displayNamePref)
					return
				end
			else
				local dismount = RidinDirty.Dismount()
				df(rdLogo .. "Traveling to " .. displayNamePref .. " in zone")
				JumpToGroupMember(playerDisplayName)
				return
			end
		end
	end
	for friendIndex = 1, GetNumFriends() do
		local friendName, _, friendStatus = GetFriendInfo(friendIndex)
		local _, friendCharName, friendZone = GetFriendCharacterInfo(friendIndex)
		if not ZO_ShouldPreferUserId() then displayNamePref = friendCharName else displayNamePref = friendName end
		displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
		if friendZone == GetUnitZone("player") and friendStatus ~= PLAYER_STATUS_OFFLINE then
			if IsUnitInCombat("player") then
				if not RidinDirty.HourGlass:IsHidden() then
					RidinDirty.TeleportPlayerQueueOff()
					return
				else
					RidinDirty.TeleportPlayerQueueOn(displayNamePref)
					return
				end
			else
				local dismount = RidinDirty.Dismount()
				df(rdLogo .. "Traveling to " .. displayNamePref .. " in zone")
				JumpToFriend(friendName)
				return
			end
		end
	end
	for guildIndex = 1, GetNumGuilds() do
		local guildId = GetGuildId(guildIndex)
		local memberNumber = GetNumGuildMembers(guildId)
		local myIndex = GetPlayerGuildMemberIndex(guildId)
		for memberIndex = 1, memberNumber, 1 do
			local memberName, _, _, memberStatus = GetGuildMemberInfo(guildId, memberIndex)
			local _, memberCharName, memberZone = GetGuildMemberCharacterInfo(guildId, memberIndex)
			if not ZO_ShouldPreferUserId() then displayNamePref = memberCharName else displayNamePref = memberName end
			displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
			if memberIndex ~= myIndex and memberName ~= GetUnitDisplayName("player") and memberZone == GetUnitZone("player") and memberStatus ~= PLAYER_STATUS_OFFLINE then
				if IsUnitInCombat("player") then
					if not RidinDirty.HourGlass:IsHidden() then
						RidinDirty.TeleportPlayerQueueOff()
						return
					else
						RidinDirty.TeleportPlayerQueueOn(displayNamePref)
						return
					end
				else
					local dismount = RidinDirty.Dismount()
					df(rdLogo .. "Traveling to " .. displayNamePref .. " in zone")
					JumpToGuildMember(memberName)
					return
				end
			end
		end
	end
	ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "No player found in zone.")
	return
end

function RidinDirty.TeleportPlayerQueueOn(playerName)
	EVENT_MANAGER:RegisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE, RidinDirty.TeleportPlayerQueue)
	PlaySound("GuildRoster_Added")
	RidinDirty.HourGlass.label:SetText (rdLogo .. "Travel To " .. playerName .. " Combat Queued")
	RidinDirty.HourGlass:SetHidden(false)
	RidinDirty.HourGlass.animation:PlayForward()
	if RidinDirty.BetaList(GetUnitDisplayName("player")) then--<< TESTING
		if GetUnitGender("player") == GENDER_MALE then
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9863) then DoCommand("/ritualcasting") end
		else
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9004) then DoCommand("/dayoflights") end
		end
	end
end

function RidinDirty.TeleportPlayerQueue()
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
	RidinDirtyX.TravelToPlayer()
end

function RidinDirty.TeleportPlayerQueueOff()
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
end
---------------------------------------------
------- TRAVEL TO PRIMARY HOME --
---------------------------------------------
function RidinDirtyX.TravelToHome()
	local travelOutside = RidinDirty.savedVariables.travelOutside
	if IsInCampaign() or IsActiveWorldBattleground() then--<< IC EVAC
		if IsInImperialCity() and not evacSwitch then
			lastEvacId = GetCurrentCampaignId()
			local egqR = GetExpectedGroupQueueResult()
			if egqR == 0 or egqR == 9 or egqR == 13 then
				if DoesTelVarAmountPreventQueuingForCampaign(RidinDirty.GetLowPopCyroCampaignId()) then
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Unable to EVAC with 100+ telvar on you" .. "."))
					return
				elseif RidinDirty.GetLowPopCyroCampaignId() then
					QueueForCampaign(RidinDirty.GetLowPopCyroCampaignId())
				else
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Unable to find low pop campaign.")
					return
				end
				PlaySound("PlayerAction_NotEnoughMoney")
				df(rdLogo .. "|cFF3399*PREMATURE EVACUATION*|r")
				evacSwitch = true
				return
			end
		end
		if not evacSwitch then ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Unable to travel from " .. GetUnitZone("player") .. ".")) end
		return
	elseif IsUnitInCombat("player") then
		if not RidinDirty.HourGlass:IsHidden() then
			RidinDirty.TeleportHomeQueueOff()
			return
		else
			RidinDirty.TeleportHomeQueueOn()
			return
		end
	else
		local dismount = RidinDirty.Dismount()
		if RidinDirty.BetaList(GetUnitDisplayName("player")) and GetUnitDisplayName("player") ~= RidinDirty.author then--<< TESTING
			df(rdLogo .. "|cFF3399Headin To The LOOOVE SHACK BAEEEBY!!!|r")
		else
			if travelOutside then
				df(rdLogo .. "Traveling to " .. tostring(GetCollectibleNickname(GetCollectibleIdForHouse(GetHousingPrimaryHouse()))) .. " (Outside)")
			else
				df(rdLogo .. "Traveling to " .. tostring(GetCollectibleNickname(GetCollectibleIdForHouse(GetHousingPrimaryHouse()))) .. " (Inside)")
			end
		end
		RequestJumpToHouse(GetHousingPrimaryHouse(), travelOutside)
		return
	end
end

function RidinDirty.TeleportHomeQueueOn()
	EVENT_MANAGER:RegisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE, RidinDirty.TeleportHomeQueue)
	PlaySound("GuildRoster_Added")
	RidinDirty.HourGlass.label:SetText (rdLogo .. "Travel Home Combat Queued")
	RidinDirty.HourGlass:SetHidden(false)
	RidinDirty.HourGlass.animation:PlayForward()
	if RidinDirty.BetaList(GetUnitDisplayName("player")) then--<< TESTING
		if GetUnitGender("player") == GENDER_MALE then
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9863) then DoCommand("/ritualcasting") end
		else
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9004) then DoCommand("/dayoflights") end
		end
	end
end

function RidinDirty.TeleportHomeQueue()
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
	RidinDirtyX.TravelToHome()
end

function RidinDirty.TeleportHomeQueueOff()
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
end

function RidinDirty.TravelHomeToggle(toggle)
	RidinDirty.savedVariables.travelOutside = toggle
end
---------------------------------------------
------ TRAVEL TO PLAYER HOUSE OR ZONES /tp --
---------------------------------------------
function RidinDirty.Teleport(value1, value2)
	local displayNamePref = nil
	if IsInCampaign() or IsActiveWorldBattleground() then ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Unable to travel from " .. GetUnitZone("player") .. ".")) return end
	if playerSearch ~= nil then
		value1 = playerSearch
		value2 = houseSearch
		playerSearch = nil
		houseSearch = nil
	end
	if value2 ~= nil and value2 ~= "" then
		if IsUnitInCombat("player") then
			if not RidinDirty.HourGlass:IsHidden() then
				RidinDirty.TeleportZoneQueueOff()
				return
			else
				playerSearch = value1
				houseSearch = value2
				RidinDirty.TeleportZoneQueueOn(value1, value2)
				return
			end
		else
			local dismount = RidinDirty.Dismount()
			df(rdLogo .. "Traveling to " .. GetHousingLink(RidinDirty.FindHouseID(value2), value1))
			JumpToSpecificHouse(value1, RidinDirty.FindHouseID(value2))
			return
		end
	end
	for iD = 1, GetGroupSize() do
		local playerID = GetGroupUnitTagByIndex(iD)
		local zoneIndex = GetUnitZoneIndex(playerID)
		local zoneID = GetZoneId(zoneIndex)
		local memberZone = GetUnitZone(playerID)
		local memberName = GetUnitDisplayName(playerID)
		local memberCharName = GetUnitName(playerID)
		if not ZO_ShouldPreferUserId() then displayNamePref = memberCharName else displayNamePref = memberName end
		displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
		if memberName ~= GetUnitDisplayName("player") and string.find(string.lower(memberZone), string.lower(value1), 1, true) ~= nil and IsUnitOnline(playerID) and RidinDirty.ZoneWhitelist(memberZone) then
			if IsUnitInCombat("player") then
				if not RidinDirty.HourGlass:IsHidden() then
					RidinDirty.TeleportZoneQueueOff()
					return
				else
					playerSearch = value1
					RidinDirty.TeleportZoneQueueOn(displayNamePref)
					return
				end
			else
				local dismount = RidinDirty.Dismount()
				df(rdLogo .. "Traveling to " .. displayNamePref .. " in " .. memberZone)
				JumpToGroupMember(memberName)
				return
			end
		end
	end
	for friendIndex = 1, GetNumFriends() do
		local friendName, _, friendStatus = GetFriendInfo(friendIndex)
		local _, friendCharName, friendZone, _, _, _, _, friendzoneID = GetFriendCharacterInfo(friendIndex)
		if not ZO_ShouldPreferUserId() then displayNamePref = friendCharName else displayNamePref = friendName end
		displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
		if string.find(string.lower(friendZone), string.lower(value1), 1, true) ~= nil and friendStatus ~= PLAYER_STATUS_OFFLINE and RidinDirty.ZoneWhitelist(friendZone) then
			if IsUnitInCombat("player") then
				if not RidinDirty.HourGlass:IsHidden() then
					RidinDirty.TeleportZoneQueueOff()
					return
				else
					playerSearch = value1
					RidinDirty.TeleportZoneQueueOn(displayNamePref)
					return
				end
			else
				local dismount = RidinDirty.Dismount()
				df(rdLogo .. "Traveling to " .. displayNamePref .. " in " .. friendZone)
				JumpToFriend(friendName)
				return
			end
		end
	end
	for guildIndex = 1, GetNumGuilds() do
		local guildId = GetGuildId(guildIndex)
		local memberNumber = GetNumGuildMembers(guildId)
		local myIndex = GetPlayerGuildMemberIndex(guildId)
		for memberIndex = 1, memberNumber, 1 do
			local memberName, _, _, memberStatus = GetGuildMemberInfo(guildId, memberIndex)
			local _, memberCharName, memberZone, _, _, _, _, memberzoneID = GetGuildMemberCharacterInfo(guildId, memberIndex)
			if not ZO_ShouldPreferUserId() then displayNamePref = memberCharName else displayNamePref = memberName end
			displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
			if memberIndex ~= myIndex and string.find(string.lower(memberZone), string.lower(value1), 1, true) ~= nil and memberStatus ~= PLAYER_STATUS_OFFLINE and RidinDirty.ZoneWhitelist(memberZone) then
				if IsUnitInCombat("player") then
					if not RidinDirty.HourGlass:IsHidden() then
						RidinDirty.TeleportZoneQueueOff()
						return
					else
						playerSearch = value1
						RidinDirty.TeleportZoneQueueOn(displayNamePref)
						return
					end
				else
					local dismount = RidinDirty.Dismount()
					df(rdLogo .. "Traveling to " .. displayNamePref .. " in " .. memberZone)
					JumpToGuildMember(memberName)
					return
				end
			end
		end
	end
	if value2 == nil or value2 == "" then
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("No player found anywhere matching: " .. value1 .. "."))
	end
	return
end

function RidinDirty.TeleportZoneQueueOn(value1, value2)
	EVENT_MANAGER:RegisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE, RidinDirty.TeleportZoneQueue)
	PlaySound("GuildRoster_Added")
	local teleportTarget = nil
	if value2 == nil then teleportTarget = value1 else teleportTarget = GetHousingLink(RidinDirty.FindHouseID(value2), value1) end
	RidinDirty.HourGlass.label:SetText (rdLogo .. "Travel To " .. teleportTarget .. " Combat Queued")
	RidinDirty.HourGlass:SetHidden(false)
	RidinDirty.HourGlass.animation:PlayForward()
	if RidinDirty.BetaList(GetUnitDisplayName("player")) then--<< TESTING
		if GetUnitGender("player") == GENDER_MALE then
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9863) then DoCommand("/ritualcasting") end
		else
			if SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and IsCollectibleUnlocked(9004) then DoCommand("/dayoflights") end
		end
	end
end

function RidinDirty.TeleportZoneQueue()
	local value1 = playerSearch
	local value2 = houseSearch
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
	RidinDirty.Teleport(value1, value2)
end

function RidinDirty.TeleportZoneQueueOff()
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyQueue", EVENT_PLAYER_COMBAT_STATE)
	RidinDirty.HourGlass:SetHidden(true)
	RidinDirty.HourGlass.animation:Stop()
end
---------------------------------------------
------ AUTO BANK & STORAGE STACKER --
---------------------------------------------
function RidinDirty.AutoBanking(eventCode, bankBag)
	if bankBag ~= BAG_BANK and not RidinDirty.savedVariables.houseStack then return end
	if RidinDirty.HasWritQuest() then ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Auto deposit disabled while writ quests active.") RidinDirty.BankBalances(eventCode, bankBag) return end--<< CRAFTING WRIT COMPATIBILITY
	local bankCache = SHARED_INVENTORY:GetOrCreateBagCache(bankBag)
	local bagCache  = SHARED_INVENTORY:GetOrCreateBagCache(BAG_BACKPACK)
	if (RidinDirty.savedVariables.bankStack and bankBag == BAG_BANK) or (RidinDirty.savedVariables.houseStack and bankBag ~= BAG_BANK) then
		for bankSlot, bankSlotData in pairs(bankCache) do
			local bankStack, bankMaxStack = GetSlotStackSize(bankBag, bankSlot)
			if bankStack > 0 and bankStack < bankMaxStack then
				for bagSlot, bagSlotData in pairs(bagCache) do
					if ((bankBag == BAG_BANK and not RidinDirty.savedVariables.bankALL) or (bankBag ~= BAG_BANK and not RidinDirty.savedVariables.houseALL))
						and (bankSlotData.itemType == ITEMTYPE_FOOD or bankSlotData.itemType == ITEMTYPE_DRINK or bankSlotData.itemType == ITEMTYPE_POTION
						or bankSlotData.itemType == ITEMTYPE_POISON or bankSlotData.itemType == ITEMTYPE_SOUL_GEM or bankSlotData.itemType == ITEMTYPE_TOOL
						or bankSlotData.itemType == ITEMTYPE_AVA_REPAIR or bankSlotData.itemType == ITEMTYPE_RECALL_STONE or bankSlotData.itemType == ITEMTYPE_SIEGE) then break end
					if bankSlotData.rawName == bagSlotData.rawName and not bagSlotData.stolen and not (bagSlotData.itemType == ITEMTYPE_SIEGE and select(23, ZO_LinkHandler_ParseLink(GetItemLink(BAG_BACKPACK, bagSlot, LINK_STYLE_DEFAULT))) ~= "0") then
						local bagStack, bagMaxStack = GetSlotStackSize(BAG_BACKPACK, bagSlot)
						local bagItemLink = GetItemLink(BAG_BACKPACK, bagSlot, LINK_STYLE_DEFAULT)
						local quantity = zo_min(bagStack, bankMaxStack - bankStack)
						if IsProtectedFunction("RequestMoveItem") then
							CallSecureProtected("RequestMoveItem", BAG_BACKPACK, bagSlot, bankBag, bankSlot, quantity)
						else
							RequestMoveItem(BAG_BACKPACK, bagSlot, bankBag, bankSlot, quantity)
						end
						df(zo_strformat(rdLogo .. "Deposited: [<<1>>/<<2>>] <<t:3>>", quantity, bagStack, bagItemLink))
						local bankStack = bankStack + quantity
						if bankStack == bankMaxStack then
							break
						end
					end
				end
			end
		end
	end
	if IsESOPlusSubscriber() then
		local subBankCache = SHARED_INVENTORY:GetOrCreateBagCache(BAG_SUBSCRIBER_BANK)
		local subBagCache  = SHARED_INVENTORY:GetOrCreateBagCache(BAG_BACKPACK)
		if (RidinDirty.savedVariables.bankStack and bankBag == BAG_BANK) then
			for bankSlot, bankSlotData in pairs(subBankCache) do
				local bankStack, bankMaxStack = GetSlotStackSize(BAG_SUBSCRIBER_BANK, bankSlot)
				if bankStack > 0 and bankStack < bankMaxStack then
					for bagSlot, bagSlotData in pairs(subBagCache) do
						if (bankBag == BAG_BANK and not RidinDirty.savedVariables.bankALL)
							and (bankSlotData.itemType == ITEMTYPE_FOOD or bankSlotData.itemType == ITEMTYPE_DRINK or bankSlotData.itemType == ITEMTYPE_POTION
							or bankSlotData.itemType == ITEMTYPE_POISON or bankSlotData.itemType == ITEMTYPE_SOUL_GEM or bankSlotData.itemType == ITEMTYPE_TOOL
							or bankSlotData.itemType == ITEMTYPE_AVA_REPAIR or bankSlotData.itemType == ITEMTYPE_RECALL_STONE or bankSlotData.itemType == ITEMTYPE_SIEGE) then break end
						if bankSlotData.rawName == bagSlotData.rawName and not bagSlotData.stolen and not (bagSlotData.itemType == ITEMTYPE_SIEGE and select(23, ZO_LinkHandler_ParseLink(GetItemLink(BAG_BACKPACK, bagSlot, LINK_STYLE_DEFAULT))) ~= "0") then
							local bagStack, bagMaxStack = GetSlotStackSize(BAG_BACKPACK, bagSlot)
							local bagItemLink = GetItemLink(BAG_BACKPACK, bagSlot, LINK_STYLE_DEFAULT)
							local quantity = zo_min(bagStack, bankMaxStack - bankStack)
							if IsProtectedFunction("RequestMoveItem") then
								CallSecureProtected("RequestMoveItem", BAG_BACKPACK, bagSlot, BAG_SUBSCRIBER_BANK, bankSlot, quantity)
							else
								RequestMoveItem(BAG_BACKPACK, bagSlot, BAG_SUBSCRIBER_BANK, bankSlot, quantity)
							end
							df(zo_strformat(rdLogo .. "Deposited: [<<1>>/<<2>>] <<t:3>>", quantity, bagStack, bagItemLink))
							local bankStack = bankStack + quantity
							if bankStack == bankMaxStack then
								break
							end
						end
					end
				end
			end
		end
	end
	if bankBag ~= BAG_BANK then return end
	RidinDirty.DepositCurrency(eventCode, bankBag)
end

function RidinDirty.DepositCurrency(eventCode, bankBag)
	local moveGold = false
	local moveAP = false
	local moveTelvar = false
	local moveVoucher = false
	local carriedGold = GetCarriedCurrencyAmount(CURT_MONEY)
	local goldReserve = RidinDirty.savedVariables.goldReserve
	local withdrawGold = 0
	local carriedAP = GetCarriedCurrencyAmount(CURT_ALLIANCE_POINTS)
	local apReserve = RidinDirty.savedVariables.apReserve
	local withdrawAP = 0
	local carriedTelvar = GetCarriedCurrencyAmount(CURT_TELVAR_STONES)
	local telvarReserve = RidinDirty.savedVariables.telvarReserve
	local withdrawTelvar = 0
	local carriedVoucher = GetCarriedCurrencyAmount(CURT_WRIT_VOUCHERS)
	if RidinDirty.savedVariables.goldDeposit and GetUnitName("player") ~= RidinDirty.savedVariables.noDeposit then
		if (carriedGold < goldReserve) and ((goldReserve - carriedGold) < GetBankedCurrencyAmount(CURT_MONEY)) then
			moveGold = true
			withdrawGold = (goldReserve - carriedGold)
			carriedGold = (withdrawGold - (withdrawGold*2))
			WithdrawCurrencyFromBank(CURT_MONEY, withdrawGold)
			df(rdLogo .. "Withdrew: " .. "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(carriedGold))
		elseif (carriedGold > goldReserve) then
			moveGold = true
			carriedGold = (carriedGold - goldReserve)
			DepositCurrencyIntoBank(CURT_MONEY, carriedGold)
			df(rdLogo .. "Deposited: " .. "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(carriedGold))
		end
	end
	if RidinDirty.savedVariables.apDeposit then
		if (carriedAP < apReserve) and ((apReserve - carriedAP) < GetBankedCurrencyAmount(CURT_ALLIANCE_POINTS)) then
			moveAP = true
			withdrawAP = (apReserve - carriedAP)
			carriedAP = (withdrawAP - (withdrawAP*2))
			WithdrawCurrencyFromBank(CURT_ALLIANCE_POINTS, withdrawAP)
			df(rdLogo .. "Withdrew: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(carriedAP) .. "|r")
		elseif (carriedAP > apReserve) then
			moveAP = true
			carriedAP = (carriedAP - apReserve)
			DepositCurrencyIntoBank(CURT_ALLIANCE_POINTS, carriedAP)
			df(rdLogo .. "Deposited: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(carriedAP) .. "|r")
		end
	end
	if RidinDirty.savedVariables.telvarDeposit then
		if (carriedTelvar < telvarReserve) and ((telvarReserve - carriedTelvar) < GetBankedCurrencyAmount(CURT_TELVAR_STONES)) then
			moveTelvar = true
			withdrawTelvar = (telvarReserve - carriedTelvar)
			carriedTelvar = (withdrawTelvar - (withdrawTelvar*2))
			WithdrawCurrencyFromBank(CURT_TELVAR_STONES, withdrawTelvar)
			df(rdLogo .. "Withdrew: " .. "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "|c33CCCC" .. ZO_LocalizeDecimalNumber(carriedTelvar) .. "|r")
		elseif (carriedTelvar > telvarReserve) then
			moveTelvar = true
			carriedTelvar = (carriedTelvar - telvarReserve)
			DepositCurrencyIntoBank(CURT_TELVAR_STONES, carriedTelvar)
			df(rdLogo .. "Deposited: " .. "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "|c33CCCC" .. ZO_LocalizeDecimalNumber(carriedTelvar) .. "|r")
		end
	end
	if RidinDirty.savedVariables.voucherDeposit then
		if (carriedVoucher > 0) then
			moveVoucher = true
			DepositCurrencyIntoBank(CURT_WRIT_VOUCHERS, carriedVoucher)
			df(rdLogo .. "Deposited: " .. "|t16:16:/esoui/art/currency/currency_writvoucher.dds|t" .. "|cFFEECC" .. ZO_LocalizeDecimalNumber(carriedVoucher) .. "|r")
		end
	end
	RidinDirty.BankBalances(eventCode, bankBag, carriedGold, carriedAP, carriedTelvar, carriedVoucher, moveGold, moveAP, moveTelvar, moveVoucher)
end

function RidinDirty.BankBalances(eventCode, bankBag, carriedGold, carriedAP, carriedTelvar, carriedVoucher, moveGold, moveAP, moveTelvar, moveVoucher)
	if not RidinDirty.savedVariables.balanceDisplay then return end
	local bankedCurrencies = (rdLogo .. "Balances:")
	local curbankGold = GetBankedCurrencyAmount(CURT_MONEY)
	local curbankAP = GetBankedCurrencyAmount(CURT_ALLIANCE_POINTS)
	local curbankTelvar = GetBankedCurrencyAmount(CURT_TELVAR_STONES)
	local curbankVouchers = GetBankedCurrencyAmount(CURT_WRIT_VOUCHERS)
	if moveGold then curbankGold = (carriedGold + GetBankedCurrencyAmount(CURT_MONEY)) moveGold = false end
	if moveAP then curbankAP = (carriedAP + GetBankedCurrencyAmount(CURT_ALLIANCE_POINTS)) moveAP = false end
	if moveTelvar then curbankTelvar = (carriedTelvar + GetBankedCurrencyAmount(CURT_TELVAR_STONES)) moveTelvar = false end
	if moveVoucher then curbankVouchers = (carriedVoucher + GetBankedCurrencyAmount(CURT_WRIT_VOUCHERS)) moveVoucher = false end
	if curbankGold > 0 then
		bankedCurrencies = (bankedCurrencies .. " " .. "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(curbankGold))
	end
	if curbankAP > 0 then
		bankedCurrencies = (bankedCurrencies .. " " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(curbankAP) .. "|r")
	end
	if curbankTelvar > 0 then
		bankedCurrencies = (bankedCurrencies .. " " .. "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "|c33CCCC" .. ZO_LocalizeDecimalNumber(curbankTelvar) .. "|r")
	end
	if curbankVouchers > 0 then
		bankedCurrencies = (bankedCurrencies .. " " .. "|t16:16:/esoui/art/currency/currency_writvoucher.dds|t" .. "|cFFEECC" .. ZO_LocalizeDecimalNumber(curbankVouchers) .. "|r")
	end
	if bankedCurrencies ~= (rdLogo .. "Balances:") then df(bankedCurrencies) end
end
---------------------------------------------
-------- JUNK MANAGER --
---------------------------------------------
function RidinDirty.JunkManager(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange, triggeredByCharacterName, triggeredByDisplayName, isLastUpdateForMessage, bonusDropSource)
	local itemId = GetItemId(bagId, slotIndex)
	local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
	local itemType, specialType = GetItemType(bagId, slotIndex)
	local itemTrait = GetItemTraitInformation(bagId, slotIndex)
	local itemValue = GetItemSellValueWithBonuses(bagId, slotIndex)
	local isCrafted = (IsItemLinkCrafted(itemLink) and (itemType ~= ITEMTYPE_BLACKSMITHING_MATERIAL and
		itemType ~= ITEMTYPE_CLOTHIER_MATERIAL and itemType ~= ITEMTYPE_WOODWORKING_MATERIAL and
			itemType ~= ITEMTYPE_JEWELRYCRAFTING_MATERIAL and itemType ~= ITEMTYPE_ENCHANTING_RUNE_ASPECT and
				itemType ~= ITEMTYPE_ENCHANTING_RUNE_ESSENCE and itemType ~= ITEMTYPE_ENCHANTING_RUNE_POTENCY))--<< Crafting Addon Compatibility
	local isTrash = (itemType == ITEMTYPE_TRASH or itemTrait == ITEM_TRAIT_INFORMATION_ORNATE or
		(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY) or
			(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH) or
				(RidinDirty.savedVariables.junkIntricates and itemTrait == ITEM_TRAIT_INFORMATION_INTRICATE) or
					(RidinDirty.savedVariables.junkTreasures and itemType == ITEMTYPE_TREASURE and itemValue > 0) or
						(RidinDirty.savedVariables.junkStolen and IsItemStolen(bagId, slotIndex)) or
							(RidinDirty.savedVariables.junkMaps and (itemType == ITEMTYPE_TROPHY and specialType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP and not CanItemBeUsedToLearn(bagId, slotIndex))) or
								(RidinDirty.savedVariables.junkKnownScripts and (itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT and IsItemBound(bagId, slotIndex) and not RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType))))
	if not IsItemJunk(bagId, slotIndex) and (RidinDirty.junkMemory[itemId] ~= nil or isTrash) and isNewItem and not IsItemPlayerLocked(bagId, slotIndex) then
		if isCrafted then RidinDirty.junkMemory[itemId] = nil return end--<< Junk Memory Cleanup
		if isTrash then RidinDirty.junkMemory[itemId] = nil end--<< Junk Memory Cleanup
		if RidinDirty.junkMemory[itemId] ~= nil then RidinDirty.junkMemory[itemId] = itemLink end--<< Convert names to links
		SetItemIsJunk(bagId, slotIndex, true)
		if not RidinDirty.savedVariables.junkSilentMode then df(rdLogo .. "Moved " .. itemLink .. " to junk!") end
	end
end

function RidinDirty.MarkPermJunkMenu(inventorySlot, slotActions)
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
	local itemId = GetItemId(bagId, slotIndex)
	local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
	local itemType, specialType = GetItemType(bagId, slotIndex)
	local itemTrait = GetItemTraitInformation(bagId, slotIndex)
	local itemValue = GetItemSellValueWithBonuses(bagId, slotIndex)
	local isCrafted = (IsItemLinkCrafted(itemLink) and (itemType ~= ITEMTYPE_BLACKSMITHING_MATERIAL and
		itemType ~= ITEMTYPE_CLOTHIER_MATERIAL and itemType ~= ITEMTYPE_WOODWORKING_MATERIAL and
			itemType ~= ITEMTYPE_JEWELRYCRAFTING_MATERIAL and itemType ~= ITEMTYPE_ENCHANTING_RUNE_ASPECT and
				itemType ~= ITEMTYPE_ENCHANTING_RUNE_ESSENCE and itemType ~= ITEMTYPE_ENCHANTING_RUNE_POTENCY))--<< Crafting Addon Compatibility
	local isTrash = (itemType == ITEMTYPE_TRASH or itemTrait == ITEM_TRAIT_INFORMATION_ORNATE or
		(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY) or
			(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH) or
				(RidinDirty.savedVariables.junkIntricates and itemTrait == ITEM_TRAIT_INFORMATION_INTRICATE) or
					(RidinDirty.savedVariables.junkTreasures and itemType == ITEMTYPE_TREASURE and itemValue > 0) or
						(RidinDirty.savedVariables.junkStolen and IsItemStolen(bagId, slotIndex)) or
							(RidinDirty.savedVariables.junkMaps and (itemType == ITEMTYPE_TROPHY and specialType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP and not CanItemBeUsedToLearn(bagId, slotIndex))) or
								(RidinDirty.savedVariables.junkKnownScripts and (itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT and IsItemBound(bagId, slotIndex) and not RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType))))
	if IsItemJunk(bagId, slotIndex) or IsItemPlayerLocked(bagId, slotIndex) or not RidinDirty.ValidJunkContainer(bagId) or not CanItemBeMarkedAsJunk(bagId, slotIndex) or RidinDirty.junkMemory[itemId] ~= nil or isCrafted or isTrash then return end
	AddCustomMenuItem("Mark Perm Junk", function() RidinDirty.junkMemory[itemId] = itemLink--itemName
		SetItemIsJunk(bagId, slotIndex, true) df(rdLogo .. "Added " .. itemLink .. " to junk list!") end)
end

function RidinDirty.UnMarkPermJunkMenu(inventorySlot, slotActions)
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
	local itemId = GetItemId(bagId, slotIndex)
	local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
	local itemType, specialType = GetItemType(bagId, slotIndex)
	local itemTrait = GetItemTraitInformation(bagId, slotIndex)
	local itemValue = GetItemSellValueWithBonuses(bagId, slotIndex)
	local isCrafted = (IsItemLinkCrafted(itemLink) and (itemType ~= ITEMTYPE_BLACKSMITHING_MATERIAL and
		itemType ~= ITEMTYPE_CLOTHIER_MATERIAL and itemType ~= ITEMTYPE_WOODWORKING_MATERIAL and
			itemType ~= ITEMTYPE_JEWELRYCRAFTING_MATERIAL and itemType ~= ITEMTYPE_ENCHANTING_RUNE_ASPECT and
				itemType ~= ITEMTYPE_ENCHANTING_RUNE_ESSENCE and itemType ~= ITEMTYPE_ENCHANTING_RUNE_POTENCY))--<< Crafting Addon Compatibility
	local isTrash = (itemType == ITEMTYPE_TRASH or itemTrait == ITEM_TRAIT_INFORMATION_ORNATE or
		(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY) or
			(itemType == ITEMTYPE_COLLECTIBLE and specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH) or
				(RidinDirty.savedVariables.junkIntricates and itemTrait == ITEM_TRAIT_INFORMATION_INTRICATE) or
					(RidinDirty.savedVariables.junkTreasures and itemType == ITEMTYPE_TREASURE and itemValue > 0) or
						(RidinDirty.savedVariables.junkStolen and IsItemStolen(bagId, slotIndex)) or
							(RidinDirty.savedVariables.junkMaps and (itemType == ITEMTYPE_TROPHY and specialType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP and not CanItemBeUsedToLearn(bagId, slotIndex))) or
								(RidinDirty.savedVariables.junkKnownScripts and (itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT and IsItemBound(bagId, slotIndex) and not RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType))))
	if not IsItemJunk(bagId, slotIndex) or not RidinDirty.ValidJunkContainer(bagId) or RidinDirty.junkMemory[itemId] == nil or isCrafted or isTrash then return end
	AddCustomMenuItem("UnMark Perm Junk", function() RidinDirty.junkMemory[itemId] = nil
		SetItemIsJunk(bagId, slotIndex, false) df(rdLogo .. "Removed " .. itemLink .. " from junk list!") end)
end

function RidinDirty.ChatLinkUnMarkMenu(itemLink, button, _, _, linkType, ...)
	local itemId = GetItemLinkItemId(itemLink)
	if button == MOUSE_BUTTON_INDEX_RIGHT and linkType == ITEM_LINK_TYPE and RidinDirty.junkMemory[itemId] ~= nil then
		zo_callLater(function()
			AddCustomMenuItem("UnMark Perm Junk", function() RidinDirty.junkMemory[itemId] = nil
			for slotIndex = 1, GetBagSize(BAG_BACKPACK) do
				local bagitemId = GetItemId(BAG_BACKPACK, slotIndex)
				if IsItemJunk(BAG_BACKPACK, slotIndex) and bagitemId == itemId then
					SetItemIsJunk(BAG_BACKPACK, slotIndex, false)
				end
			end
			df(rdLogo .. "Removed " .. itemLink .. " from junk list!")
			end, MENU_ADD_OPTION_LABEL)
			ShowMenu()
		end, 25)
	end
end

function RidinDirty.ValidJunkContainer(bagId)
	if (bagId == BAG_BACKPACK) then
		return true
	else
		return false
	end
end

function RidinDirty.ClearJunkList()
	RidinDirty.junkMemory = ZO_SavedVars:NewAccountWide( RidinDirty.svName, 2, "Junk Memory", defaultJunkVars )
	zo_callLater(function() ReloadUI() end, 500)
end

function RidinDirty.AutoSellRepair()
	local junkValue = 0
	if HasAnyJunk(BAG_BACKPACK, true) then
		for slotIndex = 1, GetNumBagUsedSlots(BAG_BACKPACK) do
			if IsItemJunk(BAG_BACKPACK, slotIndex) and not IsItemStolen(BAG_BACKPACK, slotIndex) then
				junkValue = junkValue + (GetItemSellValueWithBonuses(BAG_BACKPACK, slotIndex) * GetSlotStackSize(BAG_BACKPACK, slotIndex))
			end
		end
		if junkValue > 0 then
			df(rdLogo .. "All junk sold for " .. "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(junkValue))
		end
		SellAllJunk()
	end
	local repairCost = GetRepairAllCost()
	if not CanStoreRepair() then return end
	if repairCost > 0 and repairCost < GetCurrentMoney() then
		df(rdLogo .. "All items repaired for " .. "|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(repairCost))
		RepairAll()
	elseif repairCost > 0 and repairCost > GetCurrentMoney() then
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Insufficient gold for repairs.")
	end
end
--DestroyAllJunk()
function RidinDirty.JunkManagerToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.junkManager = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.JunkManager)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyJunk", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_OPEN_STORE, RidinDirty.AutoSellRepair)
		local tertiary = LibCustomMenu.CATEGORY_TERTIARY
		LibCustomMenu:RegisterContextMenu(RidinDirty.MarkPermJunkMenu, tertiary)
		LibCustomMenu:RegisterContextMenu(RidinDirty.UnMarkPermJunkMenu, tertiary)
	else
		RidinDirty.savedVariables.junkManager = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyJunk", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyJunk", EVENT_OPEN_STORE)
		ReloadUI()
	end
end
---------------------------------------------
--------- LEAVE GROUP & EXIT INSTANCE ----LeaveBattleground()
---------------------------------------------
function RidinDirtyX.GroupLeave()
	if IsUnitGrouped("player") then
		GroupLeave()
	elseif CanExitInstanceImmediately() then
		ExitInstanceImmediately()
	elseif not IsUnitGrouped("player") and not CanExitInstanceImmediately() and RidinDirty.BetaList(GetUnitDisplayName("player")) then--<< TESTING
		if not IsFriend(RidinDirty.savedVariables.savedPlayer) then
			ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Inviting " .. RidinDirty.savedVariables.savedPlayer .. " to be friends."))
			RequestFriend(RidinDirty.savedVariables.savedPlayer, "")
		end
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("Inviting " .. RidinDirty.savedVariables.savedPlayer .. " to group."))
		GroupInviteByName(RidinDirty.savedVariables.savedPlayer)
	end
end
---------------------------------------------
------- Trader Activity & Enhancements--
---------------------------------------------
function RidinDirtyX.TraderActivity()
	local traderDelay = 300
	local salesData = 0
	local guildData = 0
	local guildTotal = 0
	if RidinDirty.savedVariables.traderEnhance and SCENE_MANAGER:GetCurrentScene() == TRADING_HOUSE_SCENE and GetNumTradingHouseGuilds() > 1 then
		local currentId = GetSelectedTradingHouseGuildId()
		local numGuilds = GetNumTradingHouseGuilds()
		local nextIndex = 1
		for i = 1, numGuilds do
			local guildId = GetTradingHouseGuildDetails(i)
			if guildId == currentId then
				nextIndex = (i % numGuilds) + 1
				break
			end
		end
		local nextGuildId = GetTradingHouseGuildDetails(nextIndex)
		SelectTradingHouseGuildId(nextGuildId)
		if not CanSellOnTradingHouse(GetCurrentTradingHouseGuildDetails()) and not HasTradingHouseListings() then RidinDirtyX.TraderActivity() return end
		if TRADING_HOUSE:GetCurrentMode() == ZO_TRADING_HOUSE_MODE_BROWSE then
			zo_callLater(function()
				if TRADING_HOUSE_SEARCH:CanDoCommonOperation() then TRADING_HOUSE_SEARCH:DoSearch() end
			end, traderDelay)
		end
	elseif not IsUnitInCombat("player") and GetNumGuilds() > 0 then
		local resetTimestamp = RidinDirty.GetLastKioskResetTimestamp()
		df("-------- Weekly Trader Activity Since Kiosk Reset --------")
		for i = 1, GetNumGuilds() do
			local guildID = GetGuildId(i)
			local guildName = GetGuildName(guildID)
			if IsPlayerInGuild(guildID) then
				local CATEGORY = GUILD_HISTORY_EVENT_CATEGORY_TRADER
				for x = 1, GetNumGuildHistoryEvents(guildID, CATEGORY) do
					local eventStamp = GetGuildHistoryEventTimestamp(guildID, CATEGORY, x)
					local param1, timeStamp, param3, param4, sellerName, buyerName, itemLink, itemQuantity, itemPrice, itemTax = GetGuildHistoryTraderEventInfo(guildID, x)
					local sellerName = ("@" .. sellerName)
					local buyerName = ("@" .. buyerName)
					local myData = (sellerName == GetUnitDisplayName("player") or buyerName == GetUnitDisplayName("player"))
					if eventStamp > resetTimestamp then
						guildTotal = (guildTotal + itemPrice)
					end
					if myData and eventStamp > resetTimestamp then
						guildData = (guildData + itemPrice)
						salesData = (salesData + itemPrice)
					end
				end
				if guildData > 0 then df("|t16:16:/esoui/art/currency/currency_gold.dds|t" .. tostring(ZO_LocalizeDecimalNumber(guildData) .. " --> " .. tostring(guildName)) .. " (|t16:16:/esoui/art/currency/currency_gold.dds|t" .. ZO_LocalizeDecimalNumber(guildTotal) .. ")") end
				guildData = 0
				guildTotal = 0
			end
		end
		if salesData > 0 then df("(|t16:16:/esoui/art/currency/currency_gold.dds|t" .. tostring(ZO_LocalizeDecimalNumber(salesData)) .. ") <-- Your Total Weekly Trader Activity") end
		df("------------- BASED ON YOUR CACHED DATA --------------")
	elseif RidinDirty.BetaList(GetUnitDisplayName("player")) and (IsUnitDead("companion") or not HasActiveCompanion()) and not IsInCampaign() and not IsActiveWorldBattleground() and not IsUnitDeadOrReincarnating("player") and compStamp < GetTimeStamp() then--<< TESTING
			UseCollectible(300)
			compStamp = (GetTimeStamp() + 1)
	end
end
--ZO_MenuBar_SelectDescriptor(TRADING_HOUSE.menuBar, ZO_TRADING_HOUSE_MODE_BROWSE, true, true)
--CanSellOnTradingHouse(guildId)--HasTradingHouseListings()--ZO_TRADING_HOUSE_MODE_BROWSE--ZO_TRADING_HOUSE_MODE_SELL--ZO_TRADING_HOUSE_MODE_LISTINGS
function RidinDirty.DefaultTraderTab()
	local traderDelay = 300
	zo_callLater(function()
		local guildId, guildName, guildAlliance = GetCurrentTradingHouseGuildDetails()
		zo_callLater(function()
			if TRADING_HOUSE_SEARCH:CanDoCommonOperation() then TRADING_HOUSE_SEARCH:DoSearch() end
		end, traderDelay)
	end, traderDelay)
end
--GetChatterOptionCount() do
function RidinDirty.TraderChatter(eventCode, optionCount, debugSource)
	for i = 1, optionCount do
		local _, choice = GetChatterOption(i)
		if i == 1 and choice == CHATTER_START_TRADINGHOUSE then
			SelectChatterOption(i)
		end
	end
end

function RidinDirty.TraderEnhanceToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.traderEnhance = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_OPEN_TRADING_HOUSE, RidinDirty.DefaultTraderTab)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CHATTER_BEGIN, RidinDirty.TraderChatter)
	else
		RidinDirty.savedVariables.traderEnhance = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_OPEN_TRADING_HOUSE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_CHATTER_BEGIN)
	end
end
---------------------------------------------
-------- SIEGE CAMERA TOGLE --
---------------------------------------------
function RidinDirtyX.SiegeCameraToggle()
	PlaySound("GuildRoster_Added")
	local setting = GetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY)
    if setting == "1" then setting = "0" else setting = "1" end
    SetSetting(SETTING_TYPE_CAMERA, CAMERA_SETTING_THIRD_PERSON_SIEGE_WEAPONRY, setting, 1)
end
---------------------------------------------
--------- LOCK ARMORY SAVE BUILD --
---------------------------------------------
function RidinDirty.LockArmoryToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.lockArmory = toggle
		ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled = false
	else
		RidinDirty.savedVariables.lockArmory = toggle
		ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled = true
	end
end

function RidinDirtyX.UnLockArmory()
	local armoryScene = SCENE_MANAGER:GetScene("armoryKeyboard")
	if RidinDirty.savedVariables.lockArmory and armoryScene:GetState() == SCENE_SHOWN then
		if not ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled then SCENE_MANAGER:Show("hud") ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", "Armory save temporarily enabled.") end
		ARMORY_KEYBOARD.keybindStripDescriptor[2].name = ("Save Build")
		ARMORY_KEYBOARD.keybindStripDescriptor[2].enabled = true
	end
end
---------------------------------------------
-------- NAMEPLATE FONT BOOST --
---------------------------------------------
function RidinDirty.NamePlatesToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.fontBoost = toggle
		SetNameplateKeyboardFont(string.format("%s|%d", "$(BOLD_FONT)", "28"), FONT_STYLE_SOFT_SHADOW_THIN)
	else
		RidinDirty.savedVariables.fontBoost = toggle
		SetNameplateKeyboardFont(string.format("%s|%d", "$(BOLD_FONT)", "20"), FONT_STYLE_SOFT_SHADOW_THIN)
	end
end
---------------------------------------------
-------- CHAT NOTIFICATIONS --
---------------------------------------------
--or IsFriend(fromDisplayName)
function RidinDirty.ChatNotify(eventCode, channelType, fromName, chatText, isCustomerService, fromDisplayName)
	if (channelType == CHAT_CHANNEL_WHISPER or channelType == CHAT_CHANNEL_PARTY or channelType == CHAT_CHANNEL_YELL) and (fromDisplayName ~= GetUnitDisplayName("player") and channelType ~= CHAT_CHANNEL_WHISPER_SENT) then
		PlaySound("New_Mail")
	end
end

function RidinDirty.FSC(eventCode, displayName, charName, oldStatus, newStatus)
	if displayName == GetUnitDisplayName("player") or displayName ~= RidinDirty.savedVariables.savedPlayer or GetTimeStamp() == chatStamp then return end
	local guildId = nil
	local zoneName = RidinDirty.GetFriendZone(charName)
	RidinDirty.GSC(eventCode, guildId, displayName, oldStatus, newStatus, charName, zoneName)
end

function RidinDirty.GetFriendZone(characterName)
	for friendIndex = 1, GetNumFriends() do
		local hasCharacter, charName, zoneName, classType, alliance, level, championRank, zoneId, consoleId = GetFriendCharacterInfo(friendIndex)
		if charName == characterName then
			return zoneName
		end
	end
end

function RidinDirty.GSC(eventCode, guildId, displayName, oldStatus, newStatus, charName, zoneName)
	if displayName == GetUnitDisplayName("player") or displayName ~= RidinDirty.savedVariables.savedPlayer or IsIgnored(displayName) or GetTimeStamp() == chatStamp then return end
	local displayNamePref = nil
	if guildId ~= nil then _, charName, zoneName = GetGuildMemberCharacterInfo(guildId, GetGuildMemberIndexFromDisplayName(guildId, displayName)) end
	if not ZO_ShouldPreferUserId() then displayNamePref = charName else displayNamePref = displayName end
	local displayNamePref = zo_strformat("<<1>>", displayNamePref)--<< Strip genders
	chatStamp = GetTimeStamp()
	if not IsFriend(displayName) and newStatus ~= PLAYER_STATUS_OFFLINE and oldStatus == PLAYER_STATUS_OFFLINE then
		PlaySound("New_Mail")
		df(rdLogo .. tostring(ZO_FormatClockTime()) .. " " .. tostring(displayNamePref) .. " logged on in " .. zoneName)
	elseif not IsFriend(displayName) and newStatus == PLAYER_STATUS_OFFLINE then
		PlaySound("New_Mail")
		df(rdLogo .. tostring(ZO_FormatClockTime()) .. " " .. tostring(displayNamePref) .. " logged off in " .. zoneName)
	elseif newStatus == PLAYER_STATUS_ONLINE and oldStatus == PLAYER_STATUS_AWAY then
		PlaySound("New_Mail")
		df(rdLogo .. tostring(ZO_FormatClockTime()) .. " " .. tostring(displayNamePref) .. " is BACK in " .. zoneName)
	elseif newStatus == PLAYER_STATUS_AWAY and oldStatus == PLAYER_STATUS_ONLINE then
		PlaySound("New_Mail")
		df(rdLogo .. tostring(ZO_FormatClockTime()) .. " " .. tostring(displayNamePref) .. " is AWAY in " .. zoneName)
	end
end

function RidinDirty.ChatNotifyToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.chatNotify = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CHAT_MESSAGE_CHANNEL, RidinDirty.ChatNotify)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_FRIEND_PLAYER_STATUS_CHANGED, RidinDirty.FSC)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, RidinDirty.GSC)
	else
		RidinDirty.savedVariables.chatNotify = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_CHAT_MESSAGE_CHANNEL)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_FRIEND_PLAYER_STATUS_CHANGED)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED)
	end
end
---------------------------------------------
-------- LOG COMPANION RAPPORT & DEATH--
---------------------------------------------
function RidinDirty.CompanionRapport(eventCode, companionId, prevRapport, currRapport, rapportChange)
	local companionName = zo_strformat("<<1>>", GetCompanionName(companionId))--<< Strip Genders
	df(rdLogo .. companionName .. " Rapport: " .. tostring(currRapport - prevRapport) .. " ( " .. currRapport .. " / " .. GetMaximumRapport() .. " )")
end

function RidinDirty.CompanionDeathStateChanged(eventCode, unitTag, isDead)
	if isDead and not IsUnitDeadOrReincarnating("player") then
		local companionName = zo_strformat("<<1>>", GetUnitName(unitTag))--<< Strip Genders
		CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_LARGE_TEXT, "Console_Game_Enter", ("|ccc0000WARNING! " .. companionName .. " DIED...|r"), nil, nil, nil, nil, nil, 5000, nil)
	end
end

function RidinDirty.CompanionRapportToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.companionRapport = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_COMPANION_RAPPORT_UPDATE, RidinDirty.CompanionRapport)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyCompDeath", EVENT_UNIT_DEATH_STATE_CHANGED, RidinDirty.CompanionDeathStateChanged)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyCompDeath", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "companion")
	else
		RidinDirty.savedVariables.companionRapport = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_COMPANION_RAPPORT_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyCompDeath", EVENT_UNIT_DEATH_STATE_CHANGED)
	end
end
---------------------------------------------
--------- RETICLE TAUNT ASSIST --
---------------------------------------------
--eventCode(131123)--Taunt(38254)--companmion provoke 157235--TauntStacks(52790)--OffBalance(45902)--OffBalanceImmunity(134599)--MinorVul(79717)--MajorVul(106754)--CCI(28301)
function RidinDirty.Taunted()
	local target = "reticleover"
	if DoesUnitExist(target) and not IsUnitPlayer(target) and not IsUnitDeadOrReincarnating("player") then
		for buff = 1, GetNumBuffs(target) do
			local buffName, timeStarted, timeEnding, _, stackCount, _, buffType, effectType, abilityType, _, abilityId, _  = GetUnitBuffInfo(target, buff)
			if abilityId == 38254 or abilityId == 157235 then
				local timeLeft = zo_roundToNearest(timeEnding - GetFrameTimeSeconds(), 1)
				if timeLeft <= 3 then
					RidinDirty.TauntCounter.label:SetColor( 128,128,0,1 )
				else
					RidinDirty.TauntCounter.label:SetColor( 0,128,0,1 )
				end
				RidinDirty.TauntCounter.label:SetText(timeLeft)
				RidinDirty.Combat:SetHidden(true)
				RidinDirty.TauntCounter:SetHidden(false)
				return
			end
		end
		RidinDirty.TauntCounter:SetHidden(true)
		RidinDirty.Combat:SetHidden(false)
	else
		RidinDirty.TauntCounter:SetHidden(true)
		RidinDirty.Combat:SetHidden(false)
	end
end
--EVENT_MANAGER:RegisterForEvent("RidinDirtyTaunt", EVENT_RETICLE_TARGET_CHANGED, RidinDirty.Taunted)
function RidinDirty.CombatState(eventCode, inCombat)
	if (inCombat or IsUnitInCombat("player")) and SCENE_MANAGER:GetCurrentScene() == HUD_SCENE and not IsUnitDeadOrReincarnating("player") then
		if not IsInCampaign() and not IsActiveWorldBattleground() then
			EVENT_MANAGER:RegisterForUpdate("RDTaunt", 1000, RidinDirty.Taunted)
			EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_RETICLE_TARGET_CHANGED, RidinDirty.Taunted)
		else
			RidinDirty.Combat:SetHidden(false)
		end
	else
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_RETICLE_TARGET_CHANGED)
		EVENT_MANAGER:UnregisterForUpdate("RDTaunt")
		RidinDirty.Combat:SetHidden(true)
		RidinDirty.TauntCounter:SetHidden(true)
	end
end
--if scene:GetName() == "hud" and oldState == "showing" and newState == "shown" then
function RidinDirty.SceneStateChanged(scene, oldState, newState)
	 RidinDirty.CombatState()
end

function RidinDirty.PlayerDeathStateChanged(eventCode, unitTag, isDead)
	if isDead then
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_RETICLE_TARGET_CHANGED)
		EVENT_MANAGER:UnregisterForUpdate("RDTaunt")
		RidinDirty.TauntCounter:SetHidden(true)
		RidinDirty.Combat:SetHidden(true)
	else
		RidinDirty.CombatState()
	end
end

function RidinDirty.TauntAssistToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.tauntAssist = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PLAYER_COMBAT_STATE, RidinDirty.CombatState)
		SCENE_MANAGER:RegisterCallback("SceneStateChanged", RidinDirty.SceneStateChanged)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyPlayerDeath", EVENT_UNIT_DEATH_STATE_CHANGED, RidinDirty.PlayerDeathStateChanged)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyPlayerDeath", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "player")
	else
		RidinDirty.savedVariables.tauntAssist = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_PLAYER_COMBAT_STATE)
		SCENE_MANAGER:UnregisterCallback("SceneStateChanged", RidinDirty.SceneStateChanged)
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyPlayerDeath", EVENT_UNIT_DEATH_STATE_CHANGED)
	end
end
---------------------------------------------
------ AUTO ACCEPT QUEUES --
---------------------------------------------
function RidinDirty.AutoQueue(eventCode, queueStatus)
	if queueStatus ~= ACTIVITY_FINDER_STATUS_READY_CHECK then
		return
	elseif IsActiveWorldBattleground() then
		return
	elseif HasLFGReadyCheckNotification() then
		AcceptLFGReadyCheckNotification()
		return
	end
end

function RidinDirty.AutoPvpQueue(eventCode, id, isGroup, state)
	if state == CAMPAIGN_QUEUE_REQUEST_STATE_CONFIRMING then
		PlaySound("GuildRoster_Added")
		RidinDirty.HourGlass.label:SetText (rdLogo .. "|cCCCC00Entering Campaign (" .. GetCampaignName(id) .. ")|r")
		RidinDirty.HourGlass:SetHidden(false)
		RidinDirty.HourGlass.animation:PlayForward()
		ConfirmCampaignEntry(id, isGroup, true)
	end
end

function RidinDirty.AutoQueueToggle(toggle)
   if toggle then
		RidinDirty.savedVariables.autoQueue = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, RidinDirty.AutoQueue)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_CAMPAIGN_QUEUE_STATE_CHANGED, RidinDirty.AutoPvpQueue)
	else
		RidinDirty.savedVariables.autoQueue = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_CAMPAIGN_QUEUE_STATE_CHANGED)
	end
end
---------------------------------------------
-------- AUTO RECHARGE & REPAIR --
---------------------------------------------
--if IsItemChargeable(BAG_WORN, slotIndex) or DoesItemHaveDurability(BAG_WORN, slotIndex) then df(tostring(GetItemName(BAG_WORN, slotIndex))) end
function RidinDirty.AutoRepCharge(eventCode, bagId, slotIndex, isNewItem, _, inventoryUpdateReason, stackCountChange, triggeredByCharacterName, triggeredByDisplayName, _, _)
	if inventoryUpdateReason == INVENTORY_UPDATE_REASON_ITEM_CHARGE then
		local minCharge = 50--500 max
		local charge, maxCharge = GetChargeInfoForItem(bagId, slotIndex)
		if IsItemChargeable(bagId, slotIndex) and charge <= minCharge and not IsUnitDeadOrReincarnating("player") then
			local gemSlot = RidinDirty.GetGems()
			if gemSlot ~= nil then
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "InventoryItem_ApplyCharge", (GetItemName(bagId, slotIndex) .. " recharged."))
				ChargeItemWithSoulGem(bagId, slotIndex, BAG_BACKPACK, gemSlot)
			else
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("No soul gems to recharge " .. GetItemName(bagId, slotIndex) .. "."))
			end
		end
	elseif inventoryUpdateReason == INVENTORY_UPDATE_REASON_DURABILITY_CHANGE then
		local minDura = 10--100 max
		if DoesItemHaveDurability(bagId, slotIndex) and GetItemCondition(bagId, slotIndex) <= minDura and not IsUnitDeadOrReincarnating("player") then
			local kitSlot = RidinDirty.GetRepairKits()
			if kitSlot ~= nil then
				PlaySound("InventoryItem_ApplyCharge")
				RepairItemWithRepairKit(bagId, slotIndex, BAG_BACKPACK, kitSlot)
			else
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("No repair kits to repair " .. GetItemName(bagId, slotIndex) .. "."))
			end
		end
	end
end

function RidinDirty.GetGems()
	for slotId = 0, GetBagSize(BAG_BACKPACK) do
		if IsItemSoulGem(SOUL_GEM_TYPE_FILLED, BAG_BACKPACK, slotId) then
			return slotId
		end
	end
end

function RidinDirty.GetRepairKits()
	for slotId = 0, GetBagSize(BAG_BACKPACK) do
		if IsItemRepairKit(BAG_BACKPACK, slotId) and IsItemNonCrownRepairKit(BAG_BACKPACK, slotId) and IsItemNonGroupRepairKit(BAG_BACKPACK, slotId) then
			return slotId
		end
	end
end
--if RidinDirty.savedVariables.autoRecharge then zo_callLater(function() RidinDirty.BrokenGearCheck() end, 2000) end--<< RUN AUTO RECHARGE IF ENABLED
function RidinDirty.BrokenGearCheck()
	local equipment = {
		EQUIP_SLOT_MAIN_HAND,
		EQUIP_SLOT_OFF_HAND,
		EQUIP_SLOT_BACKUP_MAIN,
		EQUIP_SLOT_BACKUP_OFF,
		EQUIP_SLOT_CHEST,
		EQUIP_SLOT_LEGS,
		EQUIP_SLOT_HEAD,
		EQUIP_SLOT_SHOULDERS,
		EQUIP_SLOT_FEET,
		EQUIP_SLOT_HAND,
		EQUIP_SLOT_WAIST,
	}
	for _, slotIndex in ipairs(equipment) do
		local charge, maxCharge = GetChargeInfoForItem(BAG_WORN, slotIndex)
		if IsItemChargeable(BAG_WORN, slotIndex) and charge == 0 and not IsUnitDeadOrReincarnating("player") then
			local gemSlot = RidinDirty.GetGems()
			if gemSlot ~= nil then
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "InventoryItem_ApplyCharge", (GetItemName(BAG_WORN, slotIndex) .. " recharged."))
				ChargeItemWithSoulGem(BAG_WORN, slotIndex, BAG_BACKPACK, gemSlot)
				zo_callLater(function() RidinDirty.BrokenGearCheck() end, 2000)
				return
			else
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("No soul gems to recharge " .. GetItemName(BAG_WORN, slotIndex) .. "."))
				break
			end
		elseif DoesItemHaveDurability(BAG_WORN, slotIndex) and GetItemCondition(BAG_WORN, slotIndex) == 0 and not IsUnitDeadOrReincarnating("player") then
			local kitSlot = RidinDirty.GetRepairKits()
			if kitSlot ~= nil then
				PlaySound("InventoryItem_ApplyCharge")
				RepairItemWithRepairKit(BAG_WORN, slotIndex, BAG_BACKPACK, kitSlot)
				zo_callLater(function() RidinDirty.BrokenGearCheck() end, 2000)
				return
			else
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, "PlayerAction_NotEnoughMoney", ("No repair kits to repair " .. GetItemName(BAG_WORN, slotIndex) .. "."))
				break
			end
		end
	end
	--StackBag(BAG_BACKPACK)
end

function RidinDirty.RechargeToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.autoRecharge = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirtyRepair", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.AutoRepCharge)
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyRepair", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)--REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE, REGISTER_FILTER_BAG_ID, BAG_WORN)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyJunk", EVENT_CLOSE_STORE, RidinDirty.BrokenGearCheck)
	else
		RidinDirty.savedVariables.autoRecharge = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyRepair", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyJunk", EVENT_CLOSE_STORE)
	end
end
---------------------------------------------
------- WITHDRAW 1 and ? POPUP MENU --
---------------------------------------------
function RidinDirty.WithdrawMenu(inventorySlot, slotActions)
	if not RidinDirty.Valid(inventorySlot, 1) then return end
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
    local itemId = GetItemId(bagId, slotIndex)
	AddCustomMenuItem("Withdraw 1", function() RidinDirty.Take(inventorySlot, itemId, 1) end)
	if RidinDirty.Valid(inventorySlot, RidinDirty.savedVariables.withdrawAmount) then
		AddCustomMenuItem(("Withdraw " .. tostring(RidinDirty.savedVariables.withdrawAmount)), function() RidinDirty.Take(inventorySlot, itemId, RidinDirty.savedVariables.withdrawAmount) end)
	end
end

function RidinDirty.Valid(inventorySlot, amount)
    local slotType = ZO_InventorySlot_GetType(inventorySlot)
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
	if not (slotType == SLOT_TYPE_BANK_ITEM or slotType == SLOT_TYPE_GUILD_BANK_ITEM or slotType == SLOT_TYPE_CRAFT_BAG_ITEM or slotType == SLOT_TYPE_FURNITURE_VAULT) then return false end
	if not (GetSlotStackSize(bagId, slotIndex) > amount) then return false end
	if slotType == SLOT_TYPE_GUILD_BANK_ITEM then
		local guildId = GetSelectedGuildBankId()
		if not guildId then return false end
		if not DoesGuildHavePrivilege(guildId, GUILD_PRIVILEGE_BANK_DEPOSIT) then
			return false
		elseif not (DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_BANK_DEPOSIT) and DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_BANK_WITHDRAW)) then
			return false
		end
	end
	if (slotType == SLOT_TYPE_BANK_ITEM or slotType == SLOT_TYPE_CRAFT_BAG_ITEM or slotType == SLOT_TYPE_FURNITURE_VAULT) and not CheckInventorySpaceSilently(1) then 
	    return false
	elseif slotType == SLOT_TYPE_GUILD_BANK_ITEM and not CheckInventorySpaceSilently(2) then
	    return false
	end
	return true
end

function RidinDirty.Take(inventorySlot, selectedID, amount)
	local slotType = ZO_InventorySlot_GetType(inventorySlot)
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
	if not slotIndex then return end
	local itemLink = GetItemLink(bagId, slotIndex)
	local itemId = GetItemLinkItemId(itemLink)
	if not (itemId == selectedID) then return end
	local targetSlot = FindFirstEmptySlotInBag(BAG_BACKPACK)
	if not targetSlot then return end
	local quantity = GetSlotStackSize(bagId, slotIndex)
	if (slotType == SLOT_TYPE_BANK_ITEM or slotType == SLOT_TYPE_CRAFT_BAG_ITEM or slotType == SLOT_TYPE_FURNITURE_VAULT) then
		for stackIndex = 1, GetBagSize(BAG_BACKPACK) do
			local bagitemId = GetItemId(BAG_BACKPACK, stackIndex)
			local stackAmount, maxStack = GetSlotStackSize(BAG_BACKPACK, stackIndex)
			if itemId == bagitemId and stackAmount < maxStack then
				CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, stackIndex, amount)
				return
			end
		end
		CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, targetSlot, amount)
	elseif slotType == SLOT_TYPE_GUILD_BANK_ITEM then
	    EVENT_MANAGER:RegisterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.Split(itemId, quantity, amount))
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
		TransferFromGuildBank(slotIndex)	
	end
end

function RidinDirty.Split(itemId, quantity, amount)
	return function(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, updateReason, stackCountChange)
		if not (bagId == BAG_BACKPACK) then return end
		local itemLink = GetItemLink(bagId, slotIndex)
		local _itemId = GetItemLinkItemId(itemLink)
		if not (_itemId == itemId) then return end
		local _quantity = GetSlotStackSize(bagId, slotIndex)
		if not (_quantity == quantity) then return end
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        local targetSlot = FindFirstEmptySlotInBag(BAG_BACKPACK)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RidinDirty.Return(bagId, slotIndex, targetSlot))
		EVENT_MANAGER:AddFilterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
		CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, targetSlot, amount)
	end
end

function RidinDirty.Return(bagId, slotIndex, targetSlot)
	return function(eventCode, _bagId, _slotIndex, isNewItem, itemSoundCategory, updateReason, stackCountChange)
		if not (targetSlot == _slotIndex) then return end
		EVENT_MANAGER:UnregisterForEvent("RidinDirtyWithdrawOne", EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		TransferToGuildBank(bagId, slotIndex)
		EVENT_MANAGER:RegisterForEvent("RidinDirtyWithdrawOne", EVENT_CLOSE_GUILD_BANK, RidinDirty.CloseGuildBank)
	end
end

function RidinDirty.CloseGuildBank(eventCode)
	EVENT_MANAGER:UnregisterForEvent("RidinDirtyWithdrawOne", EVENT_CLOSE_GUILD_BANK)
end

function RidinDirty.WithdrawOneToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.withdrawOne = toggle
		local primary = LibCustomMenu.CATEGORY_PRIMARY
		LibCustomMenu:RegisterContextMenu(RidinDirty.WithdrawMenu, primary)
	else
		RidinDirty.savedVariables.withdrawOne = toggle
		ReloadUI()
	end
end
---------------------------------------------
-------- AP & TELVAR LOG TO CHAT --
---------------------------------------------
function RidinDirty.ApLog(eventCode, _, _, currencyAmount, changeReason, reasonInfo)
	if currencyAmount < RidinDirty.savedVariables.minimumApT then return end
	if changeReason ~= CURRENCY_CHANGE_REASON_BANK_DEPOSIT and changeReason ~= CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL and changeReason ~= CURRENCY_CHANGE_REASON_VENDOR then
		if changeReason == CURRENCY_CHANGE_REASON_OFFENSIVE_KEEP_REWARD then
			PlaySound("Duel_Accepted") df(rdLogo .. GetKeepName(reasonInfo) .. " Capture: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(currencyAmount) .. "|r")
		elseif changeReason == CURRENCY_CHANGE_REASON_DEFENSIVE_KEEP_REWARD then
			PlaySound("Duel_Accepted") df(rdLogo .. GetKeepName(reasonInfo) .. " Defence: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(currencyAmount) .. "|r")
		elseif changeReason == CURRENCY_CHANGE_REASON_KEEP_REPAIR then
			PlaySound("AlliancePoint_Transact") df(rdLogo .. "Repair: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(currencyAmount) .. "|r")
		else
			PlaySound("AlliancePoint_Transact") df(rdLogo .. "Gained: " .. "|t16:16:/esoui/art/currency/alliancepoints.dds|t" .. "|c339933" .. ZO_LocalizeDecimalNumber(currencyAmount) .. "|r")
		end
	end
end

function RidinDirty.TelvarLog(eventCode, newStones, oldStones, updateReason)
	local difference = newStones - oldStones
	if difference > (RidinDirty.savedVariables.minimumApT - (RidinDirty.savedVariables.minimumApT * 2)) and difference < RidinDirty.savedVariables.minimumApT then return end
	if updateReason == CURRENCY_CHANGE_REASON_PVP_KILL_TRANSFER or updateReason == CURRENCY_CHANGE_REASON_LOOT or updateReason == CURRENCY_CHANGE_REASON_LOOT_CURRENCY_CONTAINER or updateReason == CURRENCY_CHANGE_REASON_DEATH then
		if difference > 0 then
			df(rdLogo .. "Gained: " .. "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "|c33CCCC" .. ZO_LocalizeDecimalNumber(difference) .. "|r")
		else
			df(rdLogo .. "Lost: " .. "|t16:16:/esoui/art/currency/currency_telvar.dds|t" .. "|ccc0000" .. ZO_LocalizeDecimalNumber(difference) .. "|r")
		end
	end
end

function RidinDirty.MinimumApT(value)
	RidinDirty.savedVariables.minimumApT = value
end

function RidinDirty.ApTLogToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.aptLog = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PENDING_CURRENCY_REWARD_CACHED, RidinDirty.ApLog)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_ALLIANCE_POINT_UPDATE, RidinDirty.ApLog)
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_TELVAR_STONE_UPDATE, RidinDirty.TelvarLog)
	else
		RidinDirty.savedVariables.aptLog = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_PENDING_CURRENCY_REWARD_CACHED)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_ALLIANCE_POINT_UPDATE)
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_TELVAR_STONE_UPDATE)
	end
end
---------------------------------------------
--------- BASIC LOOT LOGGING --
---------------------------------------------
--local iconImage = ("|t18:18:" .. icon .. "|t")----iconImage = "" leadHeader = "LEAD: " end
--and (itemType ~= ITEMTYPE_TOOL and specialType ~= SPECIALIZED_ITEMTYPE_TOOL) or (itemType == ITEMTYPE_CONTAINER) or (lootType == LOOT_TYPE_ANTIQUITY_LEAD)
function RidinDirty.lootLogging(eventCode, receivedBy, itemLink, quantity, _, lootType, isSelf, isPickpocketLoot, questItemIcon, itemId, isStolen)
	local itemType, specialType = GetItemLinkItemType(itemLink)
	local _, _, _, equipType, itemStyleId = GetItemLinkInfo(itemLink)
	local leadHeader = ""
	local needHeader = ""
	if (itemType == ITEMTYPE_ARMOR or itemType == ITEMTYPE_WEAPON) and not (GetItemLinkSetInfo(itemLink, false) or GetItemStyleName(itemStyleId) == (nil or "")) then return end
	if RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) then needHeader = RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) end
	if (GetItemLinkDisplayQuality(itemLink) >= RidinDirty.savedVariables.lootQuality and itemType ~= ITEMTYPE_TRASH and itemType ~= ITEMTYPE_TREASURE and itemType ~= ITEMTYPE_SOUL_GEM)
	or (lootType == LOOT_TYPE_ANTIQUITY_LEAD) or (RidinDirty.lootLoggingWhitelist(itemId)) or needHeader ~= "" then
		local receivedBy = zo_strformat("<<1>>", receivedBy)--<< Strip Genders
		local traitType, traitDesc = GetItemLinkTraitInfo(itemLink)
		local traitName = ""
		if lootType == LOOT_TYPE_ANTIQUITY_LEAD then leadHeader = "LEAD: " end
		if traitType ~= 0 then traitName = (" |ccccccc[" .. string.lower(GetString("SI_ITEMTRAITTYPE", traitType)) .. "]|r") end
		if quantity > 1 then quantity = (" x" .. quantity) else quantity = "" end
		if isSelf then receivedBy = "" else receivedBy = (" --> " .. receivedBy) end
		df(zo_strformat(rdLogo .. leadHeader .. needHeader .. itemLink .. traitName .. quantity .. receivedBy))
	end
end
--local statusControl = control:GetNamedChild("StatusTexture")--("StatusIcon")--("Status")
--if not statusControl then return end
--df(nameText .. " - " .. tostring(statusControl:IsHidden()))--statusControl:SetHidden(true)
function RidinDirty.NeedsSuggestedPrice(control, slot)
	local ItemData = control.dataEntry.data
	local bagId = ItemData.bagId
	local slotIndex = ItemData.slotIndex
	local itemId = GetItemId(bagId, slotIndex)
	local itemLink =  GetItemLink(bagId, slotIndex)
	local itemType, specialType = GetItemType(bagId, slotIndex)
	local nameControl = control:GetNamedChild("Name")
	if not nameControl then return end
	local nameText = nameControl:GetText()
	if RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) then nameControl:SetText(RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) .. " " .. nameText) end
	if IsItemBound(bagId, slotIndex) or IsItemBoPAndTradeable(bagId, slotIndex) then return end
	if not TamrielTradeCentre then return end
	local SellPriceControl = control:GetNamedChild("SellPriceText")
	if not SellPriceControl then return end
	local ItemPriceData = TamrielTradeCentrePrice:GetPriceInfo(itemLink)
	if not ItemPriceData then return end
	local RDPrice = ((ItemPriceData.Avg + (ItemPriceData.SaleAvg or ItemPriceData.Avg)) / 2)
	local RDStackPrice = (RDPrice * ItemData.stackCount)
	if ItemData.stackCount > 1 then
		SellPriceControl:SetText("|cC99912" .. tostring(ZO_LocalizeDecimalNumber(zo_roundToNearest(RDStackPrice, 1))) .. " |t16:16:/esoui/art/currency/currency_gold.dds|t\n@ " .. tostring(ZO_LocalizeDecimalNumber(zo_roundToNearest(RDPrice, 1))) .. "|r")
	else
		SellPriceControl:SetText("|cC99912" .. tostring(ZO_LocalizeDecimalNumber(zo_roundToNearest(RDStackPrice, 1))) .. " |t16:16:/esoui/art/currency/currency_gold.dds|t" .. "|r")
	end
end

function RidinDirty.lootLoggingToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.lootLogging = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_LOOT_RECEIVED, RidinDirty.lootLogging)
		--ZO_PostHook(ItemTooltip, "SetBagItem", function(tooltipControl, bagId, slotIndex)
			-- 1. Get the Item Link to identify the item
			--local itemLink = GetItemLink(bagId, slotIndex)
			-- 2. Add your custom text to the tooltip
			--if itemLink ~= "" then
				--ItemTooltip:AddLine("@sinnereso custom info")
			--end
		--end)
		chatModding = true
		local origFormatter = CHAT_ROUTER:GetRegisteredMessageFormatters()[EVENT_CHAT_MESSAGE_CHANNEL]
		CHAT_ROUTER:RegisterMessageFormatter(EVENT_CHAT_MESSAGE_CHANNEL, function(channelType, fromName, text, isCustomerService, fromDisplayName)
			local formattedText, saveTarget, _, originalText = origFormatter(channelType, fromName, text, isCustomerService, fromDisplayName)
			local modifiedText = formattedText
			local isNeeded = ""
			for itemLink in formattedText:gmatch("|H.-|h.-|h") do
				local itemId = GetItemLinkItemId(itemLink)
				local itemType, specialType = GetItemLinkItemType(itemLink)
				if RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) then 
					isNeeded = RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType)
						modifiedText = string.gsub(modifiedText, itemLink, (isNeeded .. itemLink)) end
			end
			return modifiedText, saveTarget, fromDisplayName, originalText end)
		for _, i in pairs(PLAYER_INVENTORY.inventories) do
			local ListView = i.listView
			if ListView and ListView.dataTypes and ListView.dataTypes[1] and ListView:GetName() ~= "ZO_PlayerInventoryQuest" then
				local DataType = ListView.dataTypes[1]
				SecurePostHook(DataType, 'setupCallback', function(control, slot)
					if SCENE_MANAGER:GetCurrentScene() ~= STABLES_SCENE then
						RidinDirty.NeedsSuggestedPrice(control, slot)
					end
				end)
			end
		end
		--deconstruction (assistant)
		SecurePostHook(ZO_UniversalDeconstructionTopLevel_KeyboardPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--deconstruction (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--refinement (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelRefinementPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--improvement (crafting stations)
		SecurePostHook(ZO_SmithingTopLevelImprovementPanelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
		--enchanting (crafting stations)
		SecurePostHook(ZO_EnchantingTopLevelInventoryBackpack.dataTypes[1], "setupCallback", function(control, slot)
			RidinDirty.NeedsSuggestedPrice(control, slot)
		end)
	else
		RidinDirty.savedVariables.lootLogging = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_LOOT_RECEIVED)
		ReloadUI()
	end
end
---------------------------------------------
--------- PVP PERSONAL / GROUP KILL FEED ----GetDate() = "20231009"--GetTimeString() >= "06:00:00"
---------------------------------------------
function RidinDirty.PvpKillFeed(eventCode, killLocation, killerDisplayName, killerCharacterName, killerAlliance, killerRank, victomDisplayName, victomCharacterName, victomAlliance, victomRank, isKillLocation)
	if (GetUnitDisplayName('player') == killerDisplayName or IsPlayerInGroup(killerDisplayName)) and not isKillLocation then
		if GetUnitDisplayName('player') == killerDisplayName then RidinDirty.savedVariables.pvpKills = (RidinDirty.savedVariables.pvpKills + 1) end
		PlaySound("Ability_Companion_Ultimate_Ready_Sound")
		if RidinDirty.PvpKillFeedEnabled() then return end--<< Ingame Kill Feed Compatibility
		if not ZO_ShouldPreferUserId() then
			victomCharacterName = zo_strformat("<<1>>", victomCharacterName)--<< Strip gemders
			killerCharacterName = zo_strformat("<<1>>", killerCharacterName)--<< Strip gemders
			if GetUnitDisplayName('player') == killerDisplayName then
				df(rdLogo .. "|cCC6600You killed " .. tostring(victomCharacterName) .. " [K-" .. tostring(RidinDirty.savedVariables.pvpKills) .. " / D-" .. tostring(RidinDirty.savedVariables.pvpDeaths) .. " / " .. tostring(zo_round((RidinDirty.savedVariables.pvpKills / math.max(1, RidinDirty.savedVariables.pvpDeaths)) * 100)) .. "%%]|r")
			else
				df(rdLogo .. "|cCC6600" .. killerCharacterName .. " killed " .. tostring(victomCharacterName) .. "|r")
			end
		else
			if GetUnitDisplayName('player') == killerDisplayName then
				df(rdLogo .. "|cCC6600You killed " .. tostring(victomDisplayName) .. " [K-" .. tostring(RidinDirty.savedVariables.pvpKills) .. " / D-" .. tostring(RidinDirty.savedVariables.pvpDeaths) .. " / " .. tostring(zo_round((RidinDirty.savedVariables.pvpKills / math.max(1, RidinDirty.savedVariables.pvpDeaths)) * 100)) .. "%%]|r")
			else
				df(rdLogo .. "|cCC6600" .. killerDisplayName .. " killed " .. tostring(victomDisplayName) .. "|r")
			end
		end
	elseif (GetUnitDisplayName('player') == victomDisplayName or IsPlayerInGroup(victomDisplayName)) and not isKillLocation then
		if GetUnitDisplayName('player') == victomDisplayName then RidinDirty.savedVariables.pvpDeaths = (RidinDirty.savedVariables.pvpDeaths + 1) end
		if RidinDirty.PvpKillFeedEnabled() then return end--<< Ingame Kill Feed Compatibility
		if not ZO_ShouldPreferUserId() then
			killerCharacterName = zo_strformat("<<1>>", killerCharacterName)--<< Strip genders
			victomCharacterName = zo_strformat("<<1>>", victomCharacterName)--<< Strip genders
			if GetUnitDisplayName('player') == victomDisplayName then
				df(rdLogo .. "|cCC6600Killed by " .. tostring(killerCharacterName) .. " [K-" .. tostring(RidinDirty.savedVariables.pvpKills) .. " / D-" .. tostring(RidinDirty.savedVariables.pvpDeaths) .. " / " .. tostring(zo_round((RidinDirty.savedVariables.pvpKills / math.max(1, RidinDirty.savedVariables.pvpDeaths)) * 100)) .. "%%]|r")
			else
				df(rdLogo .. "|cCC6600" .. victomCharacterName .. " killed by " .. tostring(killerCharacterName) .. "|r")
			end
		else
			if GetUnitDisplayName('player') == victomDisplayName then
				df(rdLogo .. "|cCC6600Killed by " .. tostring(killerDisplayName) .. " [K-" .. tostring(RidinDirty.savedVariables.pvpKills) .. " / D-" .. tostring(RidinDirty.savedVariables.pvpDeaths) .. " / " .. tostring(zo_round((RidinDirty.savedVariables.pvpKills / math.max(1, RidinDirty.savedVariables.pvpDeaths)) * 100)) .. "%%]|r")
			else
				df(rdLogo .. "|cCC6600" .. victomDisplayName .. " killed by " .. tostring(killerDisplayName) .. "|r")
			end
		end
	end
end

function RidinDirty.SetClearKillFeed(isSetting)
	RidinDirty.savedVariables.pvpKills = 0
	RidinDirty.savedVariables.pvpDeaths = 0
	if isSetting then
		local time = os.time()
		local t = os.date("*t", time)
		local target = os.time({year = t.year, month = t.month, day = t.day, hour = t.hour, min = 0, sec = 0})
		RidinDirty.savedVariables.pvpKillsReset = target
		--df(rdLogo .. "|cCC6600PvP Kill Feed statistics cleared and set to " .. tostring(os.date("%H:%M:%S", target)) .. " daily|r")
		CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_SMALL_TEXT, "New_Mail", ("|cCC6600PvP Kill Feed statistics cleared and set to " .. tostring(os.date("%H:%M:%S", target)) .. " daily|r"), nil, nil, nil, nil, nil, 5000, nil)
	else
		local reset = RidinDirty.savedVariables.pvpKillsReset
		local time = os.time()
		local r = os.date("!*t", reset)
		local t = os.date("!*t", time)
		local difference_seconds = os.difftime(time, reset)
		local difference_days = difference_seconds / (24 * 60 * 60)
		local whole_days = math.floor(difference_days)
		local wholedays_seconds = (whole_days * 86400)
		RidinDirty.savedVariables.pvpKillsReset = (RidinDirty.savedVariables.pvpKillsReset + wholedays_seconds)
		zo_callLater(function() df(rdLogo .. "|cCC6600PvP Kill Feed *DAILY RESET*|r") end, 7000)
		--local rs = os.date("!*t", RidinDirty.savedVariables.pvpKillsReset)
		--zo_callLater(function() df("Last Reset Set To: " .. tostring(os.date("%Y-%m-%d %H:%M:%S", os.time(rs))) .. "\nFrom: " .. tostring(os.date("%Y-%m-%d %H:%M:%S", os.time(r)))) end, 7000)
	end
end

function RidinDirty.ResetKillFeed()
	RidinDirty.savedVariables.pvpKillsReset = RidinDirty.GetLastDailyResetTimestamp()
	--df(rdLogo .. "|cCC6600PvP Kill Feed reset to default " .. tostring(os.date("%H:%M:%S", RidinDirty.savedVariables.pvpKillsReset)) .. " daily|r")
	CENTER_SCREEN_ANNOUNCE:AddMessage( 0, CSA_CATEGORY_SMALL_TEXT, "New_Mail", ("|cCC6600PvP Kill Feed reset to default " .. tostring(os.date("%H:%M:%S", RidinDirty.savedVariables.pvpKillsReset)) .. " daily|r"), nil, nil, nil, nil, nil, 5000, nil)
end

function RidinDirty.PvpKillFeedEnabled()
	if GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_SHOW_PVP_KILL_FEED_NOTIFICATIONS) then return true end
	return false
end

function RidinDirty.PvpKillFeedToggle(toggle)
	if toggle then
		RidinDirty.savedVariables.pvpKillFeed = toggle
		EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_PVP_KILL_FEED_DEATH, RidinDirty.PvpKillFeed)
	else
		RidinDirty.savedVariables.pvpKillFeed = toggle
		EVENT_MANAGER:UnregisterForEvent("RidinDirty", EVENT_PVP_KILL_FEED_DEATH)
	end
end
---------------------------------------------
------- HELPER & COMPATIBILITY FUNCTIONS --
---------------------------------------------
--/script SCENE_MANAGER:RegisterCallback("SceneStateChanged", function(scene, oldState, newState) d(scene:GetName() .. " " .. newState) end)
function RidinDirty.Dismount()
	EnablePreviewMode(true)
	DisablePreviewMode()
end
--/script df(tostring(RidinDirty.DistanceToUnit("group1")))--player--companion--reticleover--reticleovertarget--groupX--groupXcompanion--playerpetX
function RidinDirty.DistanceToUnit(unitID)
	local _, selfX, selfY, selfH = GetUnitWorldPosition("player")
	local _, targetX, targetY, targetH = GetUnitWorldPosition(unitID)
	local nDistance = zo_distance3D(targetX, targetY, targetH, selfX, selfY, selfH) / 100
	return nDistance
end

function RidinDirty.HasWritQuest()
	for quest = 1, MAX_JOURNAL_QUESTS do
		if GetJournalQuestType(quest) == QUEST_TYPE_CRAFTING then return true end
	end
	return false
end
--IsCollectibleUnlocked(GetCollectibleIdFromLink(itemLink))--if itemType == ITEMTYPE_COLLECTIBLE
function RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType)
	if IsItemLinkSetCollectionPiece(itemLink) and not IsItemSetCollectionPieceUnlocked(itemId) then return "|cFB2C36(+)|r" end
	if LibCharacterKnowledge then
		if specialType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_STYLE_PAGE and CanItemLinkBeUsedToLearn(itemLink) then return "|cFB2C36(+)|r" end
		if LCK.GetItemKnowledgeForCharacter(itemId, nil, GetCurrentCharacterId()) == LCK.KNOWLEDGE_UNKNOWN then return "|cFB2C36(+)|r" end
		local characters = LCK.GetItemKnowledgeList(itemLink)
		for i = 1, GetNumCharacters() do
			local charName, charGender, charLevel, charClassID, charRaceID, charAlliance, charID, charLocatonID = GetCharacterInfo(i)
			for c, character in ipairs(characters) do
				if (character.id == charID) then
					if LCK.GetItemKnowledgeForCharacter(itemId, nil, charID) == LCK.KNOWLEDGE_UNKNOWN then return "|cC99912(+)|r" end
				end
			end
		end
	else
		if CanItemLinkBeUsedToLearn(itemLink) then return "|cFB2C36(+)|r" end
		if itemType == ITEMTYPE_CRAFTED_ABILITY_SCRIPT then
			local isItemUseTypeCraftedAbilityScript = GetItemLinkItemUseType(itemLink) == ITEM_USE_TYPE_CRAFTED_ABILITY_SCRIPT
			local craftedAbilityScriptId = isItemUseTypeCraftedAbilityScript and GetItemLinkItemUseReferenceId(itemLink) or 0
			if not IsCraftedAbilityScriptUnlocked(craftedAbilityScriptId) then return "|cFB2C36(+)|r" end
		end
	end
	return false
end

function RidinDirty.GetLastDailyResetTimestamp()
	local now = os.time()
	local local_table = os.date("*t", now)
	local utc_table = os.date("!*t", now)
	local local_sec = os.time(local_table)
	local utc_sec = os.time(utc_table)
	local offset = os.difftime(local_sec, utc_sec) / 3600
	local t = os.date("!*t", now)
	if GetWorldName() == "NA Megaserver" then t.hour = (10 + offset) else t.hour = (3 + offset) end
	local target = os.time({year = t.year, month = t.month, day = t.day, hour = t.hour, min = 0, sec = 0})
	if target > now then target = target - 86400 end
	--df("Last Reset: " .. tostring(os.date("%Y-%m-%d %H:%M:%S", target)) .. ", Stamp: " .. tostring(target) .. ", Timezone: (" .. tostring(offset) .. ")")
	return target
end

function RidinDirty.GetLastKioskResetTimestamp()
	local now = os.time()
	local local_table = os.date("*t", now)
	local utc_table = os.date("!*t", now)
	local local_sec = os.time(local_table)
	local utc_sec = os.time(utc_table)
	local offset = os.difftime(local_sec, utc_sec) / 3600
	local t = os.date("!*t", now)
	local currentWday = tonumber(os.date("!%w", now))
    local daysToSubtract = (currentWday - 2 + 7) % 7
    if daysToSubtract == 0 then daysToSubtract = 7 end
	t.day = t.day - daysToSubtract
	if GetWorldName() == "NA Megaserver" then t.hour = (19 + offset) else t.hour = (14 + offset) end
	local target = os.time({year = t.year, month = t.month, day = t.day, hour = t.hour, min = 0, sec = 0})
	--df("Last Reset: " .. tostring(os.date("%Y-%m-%d %H:%M:%S", target)) .. ", Stamp: " .. tostring(target) .. ", Timezone: (" .. tostring(offset) .. ")")
	return target
end
--if itemType == ITEMTYPE_RECIPE and not IsItemLinkRecipeKnown(itemLink) then return true end --if itemType == ITEMTYPE_RACIAL_STYLE_MOTIF and (specialType == SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_BOOK or specialType == SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_CHAPTER)--and not IsItemLinkBookKnown(itemLink) then return true end
function RidinDirty.GetHomeCampLeadScore()
	for index = 1, GetNumCampaignAllianceLeaderboardEntries(GetAssignedCampaignId(), GetUnitAlliance("player")) do
		local isPlayer, rank, name, points, class, displayName = GetCampaignAllianceLeaderboardEntryInfo(GetAssignedCampaignId(), GetUnitAlliance("player"), index)
		if isPlayer then
			return rank, ZO_LocalizeDecimalNumber(points)
		end
	end
	return false
end

function RidinDirty.GetLowPopCyroCampaignId()
	QueryCampaignSelectionData()
	for index = 1, GetNumSelectionCampaigns() do
		local campaignId = GetSelectionCampaignId(index)
		local campaignPopEstimate = GetSelectionCampaignPopulationData(index, GetUnitAlliance("player"))
		if not IsImperialCityCampaign(campaignId) and not CanCampaignBeAllianceLocked(campaignId) and campaignPopEstimate <= 2 then return campaignId end
	end
	return false
end
-- /script df(tostring(GetPlayerActiveZoneName()))
function RidinDirty.ZoneWhitelist(value)
	local zones = {
	"Alik'r Desert",
	"Apocrypha",
	"Artaeum",
	"Auridon",
	"Bal Foyen",
	"Bangkorai",
	"Betnikh",
	"Blackreach: Arkthzand Cavern",
	"Blackreach: Greymoor Caverns",
	"Blackwood",
	"Bleakrock Isle",
	"Clockwork City",
	"Coldharbour",
	"Craglorn",
	"Deshaan",
	"Eastmarch",
	"Fargrave",
	"Galen",
	"Glenumbra",
	"Gold Coast",
	"Grahtwood",
	"Greenshade",
	"Hew's Bane",
	"High Isle",
	"Khenarthi's Roost",
	"Malabal Tor",
	"Murkmire",
	"Northern Elsweyr",
	"Reaper's March",
	"Rivenspire",
	"Shadowfen",
	"Southern Elsweyr",
	"Solstice",
	"Stirk",
	"Stonefalls",
	"Stormhaven",
	"Stros M'Kai",
	"Summerset",
	"Telvanni Peninsula",
	"The Brass Fortress",
	"The Deadlands",
	"The Reach",
	"The Rift",
	"The Scholarium",
	"The Shambles",
	"Tideholm",
	"Vvardenfell",
	"Western Skyrim",
	"West Weald",
	"Wrothgar",
	}
	for _, zoneName in ipairs(zones) do
		if zoneName == value then return true end
	end
	return false
end
--<< /script df(tostring(GetCurrentZoneHouseId()))--/script df("Testing " .. GetHousingLink(106, RidinDirtyX.author))
function RidinDirty.FindHouseID(value)
	local playerHouses = {
	["Mara's Kiss Public House"] = 1,
	["The Rosy Lion"] = 2,
	["The Ebony Flask Inn Room"] = 3,
	["Barbed Hook Private Room"] = 4,
	["Sisters of the Sands Apartment"] = 5,
	["Flaming Nix Deluxe Garret"] = 6,
	["Black Vine Villa"] = 7,
	["Cliffshade"] = 8,
	["Mathiisen Manor"] = 9,
	["Humblemud"] = 10,
	["The Ample Domicile"] = 11,
	["Stay-Moist Mansion"] = 12,
	["Snugpod"] = 13,
	["Bouldertree Refuge"] = 14,
	["The Gorinir Estate"] = 15,
	["Captain Margaux's Place"] = 16,
	["Ravenhurst"] = 17,
	["Gardner House"] = 18,
	["Kragenhome"] = 19,
	["Velothi Reverie"] = 20,
	["Quondam Indorilia"] = 21,
	["Moonmirth House"] = 22,
	["Sleek Creek House"] = 23,
	["Dawnshadow"] = 24,
	["Cyrodilic Jungle House"] = 25,
	["Domus Phrasticus"] = 26,
	["Strident Springs Demesne"] = 27,
	["Autumn's-Gate"] = 28,
	["Grymharth's Woe"] = 29,
	["Old Mistveil Manor"] = 30,
	["Hammerdeath Bungalow"] = 31,
	["Mournoth Keep"] = 32,
	["Forsaken Stronghold"] = 33,
	["Twin Arches"] = 34,
	["House of the Silent Magnifico"] = 35,
	["Hunding's Palatial Hall"] = 36,
	["Serenity Falls Estate"] = 37,
	["Daggerfall Overlook"] = 38,
	["Ebonheart Chateau"] = 39,
	["Grand Topal Hideaway"] = 40,
	["Earthtear Cavern"] = 41,
	["Saint Delyn Penthouse"] = 42,
	["Amaya Lake Lodge"] = 43,
	["Ald Velothi Harbor House"] = 44,
	["Tel Galen"] = 45,
	["Linchal Grand Manor"] = 46,
	["Coldharbour Surreal Estate"] = 47,
	["Hakkvild's High Hall"] = 48,
	["Exorcised Coven Cottage"] = 49,
	["Pariah's Pinnacle"] = 54,
	["The Orbservatory Prior"] = 55,
	["The Erstwhile Sanctuary"] = 56,
	["Princely Dawnlight Palace"] = 57,
	["Golden Gryphon Garret"] = 58,
	["Alinor Crest Townhouse"] = 59,
	["Colossal Aldmeri Grotto"] = 60,
	["Hunter's Glade"] = 61,
	["Grand Psijic Villa"] = 62,
	["Enchanted Snow Globe Home"] = 63,
	["Lakemire Xanmeer Manor"] = 64,
	["Frostvault Chasm"] = 65,
	["Elinhir Private Arena"] = 66,
	["Sugar Bowl Suite"] = 68,
	["Jode's Embrace"] = 69,
	["Hall of the Lunar Champion"] = 70,
	["Moon-Sugar Meadow"] = 71,
	["Wraithhome"] = 72,
	["Lucky Cat Landing"] = 73,
	["Potentate's Retreat"] = 74,
	["Forgemaster Falls"] = 75,
	["Thieves' Oasis"] = 76,
	["Snowmelt Suite"] = 77,
	["Proudspire Manor"] = 78,
	["Bastion Sanguinaris"] = 79,
	["Stillwaters Retreat"] = 80,
	["Antiquarian's Alpine Gallery"] = 81,
	["Shalidor's Shrouded Realm"] = 82,
	["Stone Eagle Aerie"] = 83,
	["Kushalit Sanctuary"] = 85,
	["Varlaisvea Ayleid Ruins"] = 86,
	["Pilgrim's Rest"] = 87,
	["Water's Edge"] = 88,
	["Pantherfang Chapel"] = 89,
	["Doomchar Plateau"] = 90,
	["Sweetwater Cascades"] = 91,
	["Ossa Accentium"] = 92,
	["Agony's Ascent"] = 93,
	["Seaveil Spire"] = 94,
	["Ancient Anchor Berth"] = 95,
	["Highhallow Hold"] = 96,
	["Fogbreak Lighthouse"] = 98,
	["Fair Winds"] = 99,
	["Journey's End Lodgings"] = 100,
	["Emissary's Enclave"] = 101,
	["Shadow Queen's Labyrinth"] = 102,
	["Sword-Singer's Redoubt"] = 103,
	["Kelesan'ruhn"] = 104,
	["Gladesong Arboretum"] = 105,
	["Tower of Unutterable Truths"] = 106,
	["Willowpond Haven"] = 107,
	["Zhan Khaj Crest"] = 108,
	["Rosewine Retreat"] = 109,
	["Merryvine Estate"] = 110,
	["Seabloom Villa"] = 111,
	["Haven of the Five Companions"] = 112,
	["Kthendral Deep Mines"] = 113,
	["Grand Gallery of Tamriel"] = 114,
	["Shattered Mirror Isle"] = 115,
	["Castle Skingrad"] = 116,
	["Bismuth Steam Baths"] = 117,
	["Sleepy Sloth"] = 118,
	["Theater of the Ancestors"] = 119,
	["Hiddenspring Cottage"] = 120,
	["Wildgrown Chapel of Julianos"] = 121,
	["Cradle of the Worm Colossus"] = 122,
	["Druidspring Conservatory"] = 123,
	["Night's Den"] = 124,
	["Buccaneer Bay"] = 125,
	}
	for houseName, houseId in pairs(playerHouses) do
		if string.find(string.lower(houseName), string.lower(value), 1, true) ~= nil then return houseId end
	end
	return nil
end
--|H1:item:190013:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
function RidinDirty.lootLoggingWhitelist(value)
	local items = {
	114895,--heartwood
	114892,--mundane rune
	114894,--decorative wax
	139411,--aurbic amber
	139409,--dawn prism
	139412,--gilding wax
	139414,--slaughterstone
	56862,--fortified nirncrux
	56863,--potent nirncrux
	68342,--hakeijo
	166045,--indeko
	204881,--luminous ink
	178470,--Hidden Treasure Bag
	197790,--Research Portfolio
	188144,--Fallen Knight's Pack
	187747,--Hidden Wallet
	135005,--Prisoner's Ragged Style Box
	78003,--Large Laundered Shipment
	79677,--Assassin's Potion Kit
	126012,--Waterlogged Strong Box
	}
	local greened = {
	187909,--Tribute Roister Purse
	134583,--Trans Geode 1
	171531,--Trans Geode 3
	134622,--Uncracked Trans Geode 1-3
	}
	if RidinDirty.savedVariables.lootQuality == ITEM_DISPLAY_QUALITY_MAGIC then
		for _, itemId in ipairs(greened) do
			if itemId == value then return true end
		end
	end
	for _, itemId in ipairs(items) do
		if itemId == value then return true end
	end
	return false
end
---------------------------------------------
--------- SLASH COMMANDS --
---------------------------------------------
if not Teleport and not EasyTravel then
	SLASH_COMMANDS["/tp"] = function (option)
		if (option == nil or option == "") then df(rdLogo .. " /tp partialzonename => overland zones") df(rdLogo .. " /tp exact@name partialhousename => player houses") return end
		local options = {}
		local searchResult = { string.match(option, "^(%S*)%s*(%S*)$") }
		for i, v in pairs(searchResult) do
			if (v ~= nil and v ~= "") then
				options[i] = v
			end
		end
		if options[1] ~= nil and not string.find(options[1], "^(@)") and options[2] == nil then
			RidinDirty.Teleport(options[1])
		elseif options[1] ~= nil and string.find(options[1], "^(@)") and options[1] ~= GetUnitDisplayName("player") and options[2] ~= nil and RidinDirty.FindHouseID(options[2]) then
			RidinDirty.Teleport(options[1], options[2])
		else
			df(rdLogo .. " /tp partialzonename => overland zones") df(rdLogo .. " /tp exact@name partialhousename => player houses")
		end
	end
end

SLASH_COMMANDS["/junklist"] = function (option)
	if RidinDirty.savedVariables.junkManager then
		df("---------------- Junk List START --------------")
		for i, v in pairs(RidinDirty.savedVariables["Junk Memory"]) do
			if i ~= nil and i ~= "version" then
				df(v)
			end
		end
		df("----------------- Junk List END ----------------")
	end
end

SLASH_COMMANDS["/rdc"] = function (option) if WritWorthy then DoCommand("/writworthy mat") DoCommand("/writworthy") end end

SLASH_COMMANDS["/rdfc"] = function (option) local secondsLeft = ((GetNextForwardCampRespawnTime() - GetGameTimeMilliseconds()) / 1000)
	if GetNextForwardCampRespawnTime() ~= 0 and secondsLeft > 0 then
		local respawnTime = ZO_FormatTimeAsDecimalWhenBelowThreshold(secondsLeft)
			df(rdLogo .. "You can respawn in " .. tostring(respawnTime))
				else df(rdLogo .. "CLEAR TO RESURRECT") end
end

SLASH_COMMANDS["/rdt"] = function (option)
	local bagId = BAG_BACKPACK
	local count = 0
	local links = ""
	for slotIndex = 0, GetBagSize(bagId) do
		local itemId = GetItemId(bagId, slotIndex)
		local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
		local itemType, specialType = GetItemType(bagId, slotIndex)
		if count < 4 and IsItemBoPAndTradeable(bagId, slotIndex) and not RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) and not RidinDirty.InTradeTable(itemLink) then
			count = count + 1
			table.insert(RidinDirtyX.tradeTable, itemLink)
			if count == 1 then links = (links .. itemLink) else links = (links .. "-" .. itemLink) end
		end
	end
	StartChatInput(links, CHAT_CHANNEL_PARTY)
	EVENT_MANAGER:RegisterForUpdate("RDTrade", 500, function() if CHAT_SYSTEM.textEntry:GetEditControl():GetText() == "" then DoCommand("/rdt") end end)
	if count == 0 then EVENT_MANAGER:UnregisterForUpdate("RDTrade") RidinDirtyX.tradeTable = {} df(rdLogo .. "Linking complete") CHAT_SYSTEM.textEntry:GetEditControl():LoseFocus() end
end

RidinDirtyX.tradeTable = {}
function RidinDirty.InTradeTable(value)
	for _, link in ipairs(RidinDirtyX.tradeTable) do
		if link == value then return true end
	end
	return false
end

SLASH_COMMANDS["/rdpvp"] = function (option)
	local addOnManager = GetAddOnManager()
	local numAddOns = addOnManager:GetNumAddOns()
	if string.lower(option) == "on" then
		df(rdLogo .. "PvP Performance Mode Enabled")
		for addonIndex = 1, numAddOns do
			if addonIndex ~= nil then addOnManager:SetAddOnEnabled(addonIndex, false) end
		end
		for addonIndex = 1, numAddOns do
			local addonName, addonTitle, addonAuthor, addonDescription, isEnabled, addonState, isOutOfDate, isLibrary = addOnManager:GetAddOnInfo(addonIndex)
			for i, v in pairs(RidinDirty.savedVariables["Addon Memory"]) do
				if i ~= nil and i ~= "version" then
					if v == addonName then addOnManager:SetAddOnEnabled(addonIndex, true) end
				end
			end
		end
	elseif string.lower(option) == "off" then
		df(rdLogo .. "PvP Performance Mode Disabled")
		for addonIndex = 1, numAddOns do
			local addonName, addonTitle, addonAuthor, addonDescription, isEnabled, addonState, isOutOfDate, isLibrary = addOnManager:GetAddOnInfo(addonIndex)
			addOnManager:SetAddOnEnabled(addonIndex, true)
		end
	else 
		df(rdLogo .. "Choose /rdpvp on/off") return
	end
	zo_callLater(function() ReloadUI() end, 2000)
end

function RidinDirty.AddonSave()
	local addOnManager = GetAddOnManager()
	local numAddOns = addOnManager:GetNumAddOns()
	RidinDirty.savedVariables["Addon Memory"] = nil
	RidinDirty.addonMemory = ZO_SavedVars:NewAccountWide( RidinDirty.svName, RidinDirty.svVersion, "Addon Memory", defaultAddonVars )
	for addonIndex = 1, numAddOns do
		local addonName, addonTitle, addonAuthor, addonDescription, isEnabled, addonState, isOutOfDate, isLibrary = addOnManager:GetAddOnInfo(addonIndex)
		if (isEnabled and addonState == 2) or (addonName == "RidinDirty") then RidinDirty.addonMemory[addonIndex] = addonName end
	end
	df(rdLogo .. "PvP Performance Mode Addons Saved")
end	

SLASH_COMMANDS["/rdtest"] = function (option)--<< TESTING
	if not RidinDirty.BetaList(GetUnitDisplayName("player")) then df(rdLogo .. "FEATURE IS CURRENTLY UNAVAILABLE") return end
	if option ~= "" then
		local links = ("|H1:item:" .. option .. ":1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
		StartChatInput(links, CHAT_CHANNEL_PARTY)
	else
		local bagId = BAG_BACKPACK
		for slotIndex = 0, GetBagSize(bagId) do
			local itemId = GetItemId(bagId, slotIndex)
			local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
			local itemType, specialType = GetItemType(bagId, slotIndex)
			if RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) then itemLink = (RidinDirty.KnowledgeUnknown(itemId, itemLink, itemType, specialType) .. itemLink) end
			if (itemLink ~= nil and itemLink ~= "") then
				df(itemLink .. " - " .. itemId .. " - " .. itemType .. " - " .. specialType)
			end
		end
	end
end
EVENT_MANAGER:RegisterForEvent("RidinDirty", EVENT_ADD_ON_LOADED, RidinDirty.AddOnLoaded)