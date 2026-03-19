--------------------------------------------------------------------------------
-- This tool generates the motif data for LCK's CuratedData.lua, and is intended
-- for use only by an addon developer for the maintenance of LCK. While the code
-- for this tool is now included in LCK, it is disabled and will not load unless
-- manually enabled by renaming the manifest.
--
-- The bitfield structures are defined in Internal.LoadMotifData()
--
-- Usage: Invoke /lckstyles, then /reloadui, then look in SavedVariables.
--------------------------------------------------------------------------------


local LCCC = LibCodesCommonCode
local Internal = LibCharacterKnowledgeInternal
local Public = LibCharacterKnowledge
local LMAA = LibMultiAccountAchievements
local Data, Styles, ChapterNames, NameAdjustments, CrownNumbers, Achievements

local function Initialize( )
	if (not LCK_MotifDataTool) then LCK_MotifDataTool = { } end
	Data = LCK_MotifDataTool
	Data.styles = { }
	Styles = Data.styles

	ChapterNames = {
		{ id = ITEM_STYLE_CHAPTER_SHOULDERS, name = "Cops" }, -- Manual fix for Scalecaller
		{ id = ITEM_STYLE_CHAPTER_DAGGERS, name = "Concord Dagger" }, -- Manual fix for Kindred's Concord
		{ id = ITEM_STYLE_CHAPTER_HELMETS, name = "Concord Helmet" }, -- Manual fix for Kindred's Concord
		{ id = ITEM_STYLE_CHAPTER_SHIELDS, name = "Concord Shield" }, -- Manual fix for Kindred's Concord
		unpack(Public.GetMotifChapterNames()),
	}

	-- More manual fixes
	NameAdjustments = {
		["Psijic Order"] = "Psijic",
		["Order of the Hour"] = "Order Hour",
	}

	CrownNumbers = {
		[43] = true, -- Grim Harlequin
		[46] = true, -- Frostcaster
		[53] = true, -- Tsaesci
		[129] = true, -- Hircine Bloodhunter
	}

	AchievementAdjustments = {
		["Hollowjack"] = "Happy Work for Hollowjack",
		["Psijic Order"] = "Psijic Style Master",
		["Moongrave Fane"] = "Moongrave Style Master",
		["Annihilarch's Chosen"] = "Annihilarch's Style Master",
	}

	Achievements = {
		[15] = 1043, -- Ancient Elf
		[17] = 1043, -- Barbaric
		[19] = 1043, -- Primal
		[20] = 1043, -- Daedric
		[34] = 1043, -- Imperial
	}
	for i = 1, 9 do
		Achievements[i] = 1030
	end
end

local function FindLower( haystack, needle )
	return zo_plainstrfind(zo_strlower(haystack), zo_strlower(needle))
end

local function GetDetails( itemId )
	local itemLink = Internal.GetItemLink(itemId)
	local name = LocalizeString("<<t:1>>", GetItemLinkName(itemLink))
	local itemType, specializedItemType = GetItemLinkItemType(itemLink)

	local styleId, chapterId

	for id, data in pairs(Styles) do
		if (FindLower(name, string.format(": %s", data.name))) then
			if (styleId) then
				Internal.Msg(string.format("[ERROR] Extra style ID: %s (%s and %s)", itemLink, Styles[styleId].name, data.name))
			end
			styleId = id
		end
	end

	if (specializedItemType == SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_BOOK) then
		chapterId = ITEM_STYLE_CHAPTER_ALL
	else
		for _, chapter in ipairs(ChapterNames) do
			if (FindLower(name, string.format(" %s", chapter.name))) then
				if (chapterId) then
					Internal.Msg(string.format("[ERROR] Extra chapter ID: %s (%s)", itemLink, chapter.name))
				end
				chapterId = chapter.id
			end
		end

		if (not chapterId) then
			if (string.find(name, "^Crown") or string.find(name, "Style$")) then
				chapterId = ITEM_STYLE_CHAPTER_ALL
			end
		end
	end

	if not styleId then
		Internal.Msg(string.format("[ERROR] Cannot identify style for %s", itemLink))
	end
	if not chapterId then
		Internal.Msg(string.format("[ERROR] Cannot identify chapter for %s", itemLink))
	end

	local _, _, number = string.find(name, " (%d+)")
	number = (number or 0) + 0
	if chapterId == ITEM_STYLE_CHAPTER_ALL and number == 0 then
		Internal.Msg(string.format("[ERROR] Cannot identify number for %s", itemLink))
	end

	local bopChapter = false
	if (chapterId and chapterId ~= ITEM_STYLE_CHAPTER_ALL and GetItemLinkBindType(itemLink) == BIND_TYPE_ON_PICKUP) then
		bopChapter = true
	end

	return itemLink, name, styleId, chapterId, number, bopChapter
end

local function FindAchievement( styleName )
	for i = 1, LMAA.GetMaxAchievementId() do
		if (FindLower(zo_strformat(GetAchievementName(i)), AchievementAdjustments[styleName] or styleName .. " Style Master")) then
			return i
		end
	end
end

local function GetStyles( )
	Initialize()

	local fieldSizesValid = true

	for i = 1, GetNumValidItemStyles() do
		local styleId = GetValidItemStyleId(i)
		if (styleId ~= GetUniversalStyleId()) then
			local name = GetItemStyleName(styleId)
			Styles[styleId] = {
				name = NameAdjustments[name] or name,
				mat = GetItemStyleMaterialLink(styleId),
				books = { },
				chapters = { },
				achievement = Achievements[styleId] or FindAchievement(name) or 0,
			}
		end
	end

	local encoded = { }
	local encodedBop = { }
	local duplicates = { }
	local metadata = { }

	for _, id in ipairs(Internal.ids[Internal.CATEGORY_MOTIF]) do
		local itemLink, name, styleId, chapterId, number, bopChapter = GetDetails(id)

		if (styleId and chapterId) then
			-- Update styles table, which is saved for human inspection
			local formattedName = string.format("%d: %s", id, name)
			if (chapterId == ITEM_STYLE_CHAPTER_ALL) then
				table.insert(Styles[styleId].books, formattedName)
			else
				local chapters = Styles[styleId].chapters
				if (chapters[chapterId] == nil) then
					chapters[chapterId] = formattedName
				else
					duplicates[styleId] = true
					if (type(chapters[chapterId]) == "table") then
						table.insert(chapters[chapterId], formattedName)
					else
						chapters[chapterId] = { chapters[chapterId], formattedName }
					end
				end
			end

			if (not Styles[styleId].number) then
				Styles[styleId].number = number
			elseif (Styles[styleId].number ~= number) then
				Internal.Msg(string.format("[WARNING] Potential motif number error for %s (expected %d)", itemLink, Styles[styleId].number))
			end

			-- Update encoded table, for inclusion in LCK
			table.insert(bopChapter and encodedBop or encoded, LCCC.Encode(id, 3) .. LCCC.Encode(BitLShift(styleId, 4) + chapterId, 2))
			if (id >= 2^18 or styleId >= 2^8) then
				fieldSizesValid = false
			end
		end
	end

	for styleId in pairs(duplicates) do
		Internal.Msg(string.format("[NOTICE] Duplicate chapters found in %s", Styles[styleId].name))
	end

	local styleIds = { }
	for styleId, data in pairs(Styles) do
		if (data.number) then
			table.insert(styleIds, styleId)
			if (data.achievement == 0 and not CrownNumbers[data.number]) then
				Internal.Msg(string.format("[WARNING] No achievement found for %s", data.name))
			end
		end
	end
	table.sort(styleIds)

	for _, styleId in ipairs(styleIds) do
		local number = Styles[styleId].number
		local achId = Styles[styleId].achievement
		local shiftedNumber = BitLShift(number, 8)
		local shiftedCrown = BitLShift(CrownNumbers[number] and 1 or 0, 16)
		local shiftedAchId = BitLShift(achId, 17)
		table.insert(metadata, LCCC.Encode(styleId + shiftedNumber + shiftedCrown + shiftedAchId, 5))
		if (styleId >= 2^8 or number >= 2^8 or achId >= 2^13) then
			fieldSizesValid = false
		end
	end

	if (not fieldSizesValid) then
		Internal.Msg("[CRITICAL] Data exceeds field sizes; reapportionment is required.")
		return
	end

	local signature = string.format("Generated by LCK_MotifDataTool on %s (%d: %s)", os.date("%Y/%m/%d %H:%M:%S", GetTimeStamp()), GetAPIVersion(), GetESOVersionString())
	Data.encoded = LCCC.Chunk(table.concat(encodedBop, "") .. table.concat(encoded, ""))
	Data.encoded.metadata = table.concat(metadata, "")
	Data.encoded.signature = signature
	Internal.Msg(signature)
end

Public.RegisterForCallback("LCK_MotifDataTool", Public.EVENT_INITIALIZED, function( )
	SLASH_COMMANDS["/lckstyles"] = GetStyles
end)
