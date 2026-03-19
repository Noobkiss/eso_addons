local LCK = LibCharacterKnowledge
local LEJ = LibExtendedJournal
local CharacterKnowledge = CharacterKnowledge


--------------------------------------------------------------------------------
-- CharacterKnowledge.AddTooltipExtension
--------------------------------------------------------------------------------

local ScriptTooltip = ExtendedJournalTextTooltip

local function HookHandler( parent, handler, child )
	local origFn = parent:GetHandler(handler)
	parent:SetHandler(handler, function( ... )
		parent:SetHandler(handler, origFn)
		ClearTooltip(child)
		if (origFn) then
			origFn(...)
		end
	end)
end

function CharacterKnowledge.AddTooltipExtension( tooltip, itemLink, server, account, charIdMotif, scriptId, grimoireId )
	local usingOriginalLink = true
	local category = LCK.GetItemCategory(itemLink)

	-- If the item is a craftable result, then show information for the source
	if (category == LCK.ITEM_CATEGORY_NONE and not LEJ.GetActiveTab()) then
		itemLink = LCK.GetItemLinkFromItemId(LCK.GetSourceItemIdFromResultItem(itemLink))
		category = LCK.GetItemCategory(itemLink)
		usingOriginalLink = false
	end

	-- Abort if the item is not something we can handle
	if (category == LCK.ITEM_CATEGORY_NONE) then return end

	-- Initialize
	local pinnedChars = CharacterKnowledge.serverVars.tooltips.pinnedCharsForChapters
	local extension = LEJ.TooltipExtensionInitialize(true)

	-- Motif knowledge sections
	if (category == LCK.ITEM_CATEGORY_MOTIF) then
		local items = LCK.GetMotifItemsFromStyle(LCK.GetStyleAndChapterFromMotif(itemLink))

		-- Achievement text
		local achievementId = items and items.achievementId
		if (achievementId and achievementId ~= 0 and achievementId ~= 1030 and achievementId ~= 1043) then
			local name, description = GetAchievementInfo(achievementId)
			extension:AddSection(zo_strformat(name), description)
		end

		if (items and #items.chapters > 0) then
			local includedCharIds = { [CharacterKnowledge.charId] = true }
			if (charIdMotif) then
				includedCharIds[charIdMotif] = true
			end

			for i, character in ipairs(LCK.GetItemKnowledgeList(itemLink, server, includedCharIds)) do
				if ((i <= pinnedChars and (not account or account == character.account)) or includedCharIds[character.id]) then
					local chapters = { }
					local known = 0

					for _, chapter in ipairs(LCK.GetMotifChapterNames()) do
						local knowledge = LCK.GetItemKnowledgeForCharacter(items.chapters[chapter.id], server, character.id)
						if (LCK.IsKnowledgeUsable(knowledge)) then
							table.insert(chapters, string.format("|c%06X%s|r", LEJ.GetTooltipColor(1, knowledge), chapter.name))
							if (knowledge == LCK.KNOWLEDGE_KNOWN) then
								known = known + 1
							end
						end
					end

					if (#chapters > 0) then
						extension:AddSection(
							string.format("%s (%d/%d)", character.name, known, #chapters),
							(known < #chapters) and table.concat(chapters, ", ") or string.format("|c%06X%s|r", LEJ.GetTooltipColor(1, LCK.KNOWLEDGE_KNOWN), GetString(SI_ACHIEVEMENTS_TOOLTIP_COMPLETE))
						)
					end
				end
			end
		end
	end

	-- Characters section
	local characters = LCK.GetItemKnowledgeList(itemLink, server)
	if (#characters > 0) then
		local results = { }
		local found = 0
		local total = 0

		-- BoP restriction is applicable only for "wild" tooltips, not for browser tooltips
		local restrictBOP = GetItemLinkBindType(itemLink) == BIND_TYPE_ON_PICKUP and account == nil

		for _, character in ipairs(characters) do
			if ((not account or account == character.account) and (not restrictBOP or character.account == CharacterKnowledge.userId)) then
				local color = LEJ.GetTooltipColor(2, character.knowledge)
				if (character.id == CharacterKnowledge.charId) then
					table.insert(results, string.format("|c%06X|l0:1:1:1:1:%06X|l%s|l|r", color, color, character.name))
				else
					table.insert(results, string.format("|c%06X%s|r", color, character.name))
				end
				if (character.knowledge == LCK.KNOWLEDGE_KNOWN) then
					found = found + 1
				end
				total = total + 1
			end
		end

		extension:AddSection(
			string.format("%s (%d/%d)", GetString(usingOriginalLink and SI_CK_TT_HEADER or SI_CK_TT_HEADER_RESULT), found, total),
			table.concat(results, ", ")
		)
	end

	extension:Finalize(tooltip)

	-- Calls from the browser will always have a script ID, so this is for external tooltips
	if (not scriptId and category == LCK.ITEM_CATEGORY_SCRIBING and CharacterKnowledge.vars.tooltips.scriptInfo and GetItemLinkItemType(itemLink) == ITEMTYPE_CRAFTED_ABILITY_SCRIPT) then
		scriptId = GetItemLinkItemUseReferenceId(itemLink)
	end

	-- Show script information
	if (scriptId and scriptId > 0) then
		HookHandler(tooltip, "OnCleared", ScriptTooltip)
		HookHandler(tooltip, "OnHide", ScriptTooltip)
		InitializeTooltip(ScriptTooltip, tooltip, TOPRIGHT, 0, 0, TOPLEFT)
		CharacterKnowledge.PopulateCraftedAbilityScriptTooltip(ScriptTooltip, scriptId, grimoireId)
	end
end


--------------------------------------------------------------------------------
-- CharacterKnowledge.HookExternalTooltips
--------------------------------------------------------------------------------

local AreExternalTooltipsHooked = false

function CharacterKnowledge.HookExternalTooltips( )
	if (AreExternalTooltipsHooked or not CharacterKnowledge.vars.tooltips.enabled) then return end
	AreExternalTooltipsHooked = true

	local TooltipHook = function( control, functionName, linkFunction )
		ZO_PostHook(control, functionName, function( self, ... )
			if (CharacterKnowledge.vars.tooltips.enabled) then
				CharacterKnowledge.AddTooltipExtension(control, linkFunction(...), nil)
			end
		end)
	end

	local ItemLinkPassthrough = function( itemLink )
		return itemLink
	end

	TooltipHook(PopupTooltip, "SetLink", ItemLinkPassthrough)
	TooltipHook(ItemTooltip, "SetLink", ItemLinkPassthrough)
	TooltipHook(ItemTooltip, "SetBagItem", GetItemLink)
	TooltipHook(ItemTooltip, "SetTradeItem", GetTradeItemLink)
	TooltipHook(ItemTooltip, "SetBuybackItem", GetBuybackItemLink)
	TooltipHook(ItemTooltip, "SetStoreItem", GetStoreItemLink)
	TooltipHook(ItemTooltip, "SetAttachedMailItem", GetAttachedItemLink)
	TooltipHook(ItemTooltip, "SetLootItem", GetLootItemLink)
	TooltipHook(ItemTooltip, "SetReward", GetItemRewardItemLink)
	TooltipHook(ItemTooltip, "SetQuestReward", GetQuestRewardItemLink)
	TooltipHook(ItemTooltip, "SetTradingHouseItem", GetTradingHouseSearchResultItemLink)
	TooltipHook(ItemTooltip, "SetTradingHouseListing", GetTradingHouseListingItemLink)
	TooltipHook(ItemTooltip, "SetPlacedFurniture", GetPlacedFurnitureLink)
end

LCK.RegisterForCallback("CharacterKnowledgeTooltip", LCK.EVENT_INITIALIZED, CharacterKnowledge.HookExternalTooltips)


--------------------------------------------------------------------------------
-- CharacterKnowledge.PopulateCraftedAbilityScriptTooltip
--------------------------------------------------------------------------------

local function AddText( tooltip, lines )
	local r, g, b = ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB()
	tooltip:AddLine(table.concat(lines, "\n\n"), "$(MEDIUM_FONT)|$(KB_16)|soft-shadow-thin", r, g, b, LEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
end

function CharacterKnowledge.PopulateCraftedAbilityScriptTooltip( tooltip, craftedAbilityScriptId, craftedAbilityId )
	local formatted = { { }, { } }
	for _, result in ipairs(LCK.GetCraftedAbilityScriptDescriptions(craftedAbilityScriptId)) do
		table.insert(formatted[(result[3] == craftedAbilityId) and 1 or 2], string.format("|c66CCFF|l1:1:1:2:2:66CCFF|l%s:|l|r %s", unpack(result)))
	end
	if (#formatted[1] > 0) then
		AddText(tooltip, formatted[1])
		tooltip:AddLine("")
		ZO_Tooltip_AddDivider(tooltip)
		tooltip:AddLine("")
	end
	AddText(tooltip, formatted[2])
end
