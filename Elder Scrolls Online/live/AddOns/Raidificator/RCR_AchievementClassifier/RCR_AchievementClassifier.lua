--------------------------------------------------------------------------------
-- This tool generates the achievement data for Raidificator, and is intended
-- for use only by an addon developer for the maintenance of Raidificator. It is
-- disabled and will not load unless manually enabled by renaming the manifest.
--
-- Usage: Invoke /rcrach, then /reloadui, then look in SavedVariables.
--------------------------------------------------------------------------------


local LCCC = LibCodesCommonCode
local LMAC = LibMultiAccountCollectibles
local RCR = Raidificator
local Data, HardcodedAchievements, InjectedAchievements, ManualHardModeIds, ExpectedCounts, Trophies, Seen

local IA_ZONE = 1436
local OO_ZONE = 1565

local FIELD_SIZE = RCR.ACHIEVEMENT_FIELD_SIZE
local FLAGS_SIZE = RCR.FLAGS_FIELD_SIZE
local FLAGS = RCR.ACHIEVEMENT_FLAGS

local F_VET = FLAGS.V
local F_NCLR = FLAGS.C
local F_VCLR = FLAGS.V + FLAGS.C
local F_HM = FLAGS.V + FLAGS.H
local F_SR = FLAGS.V + FLAGS.S
local F_ND = FLAGS.V + FLAGS.N
local F_TRI = FLAGS.V + FLAGS.T


-- Additional flags used only for ESO Clears Bot (ESOCB) support ---------------
local F_HMF = FLAGS.V + FLAGS.H + FLAGS.F
local F_MISC = FLAGS.V + FLAGS.M

local FinalHardModeHints = { }

local function MarkFinalHardMode( zoneId, achievements )
	-- Mark which HM is the final one, either by explicit hint or by highest ID
	local lastIndex = 0
	for i, ach in ipairs(achievements) do
		if (ach[2] == F_HM) then
			if (FinalHardModeHints[ach[1]]) then
				ach[2] = F_HMF
				return
			else
				lastIndex = i
			end
		end
	end
	if (lastIndex > 0) then
		achievements[lastIndex][2] = F_HMF
	end
end

local function CheckChallenger( zoneId, name )
	if (RCR.ZONES.D[zoneId] and string.find(name, "Challenger$")) then
		return true
	else
		return false
	end
end

local function ShouldExpectMisc( zoneId )
	return (RCR.ZONES.D[zoneId] and RCR.ZONES.D[zoneId][3] >= 2015) or (RCR.ZONES.T[zoneId] and RCR.ZONES.T[zoneId][1] >= 2016)
end
--------------------------------------------------------------------------------


local function Initialize( )
	if (not RCR_AchievementClassifier) then RCR_AchievementClassifier = { } end
	Data = RCR_AchievementClassifier
	Data.results = { }
	Data.forced = { }
	Data.unmatched = { }

	local BASE_D = {
		{ 1573, F_VCLR },
		{ 1622, F_HM },
		{ 1618, F_VET },
		{ 1592, F_SR },
		{ 1645, F_ND },
		{ 1555, F_NCLR },
	}

	-- { zoneId, forceMatch, { sampleCategoryAchId, defaultCategoryFlags }[, ...] }
	-- If sampleCategoryAchId corresponds to a hard mode achievement, it is also used
	-- as a hint for flagging which hard mode is the final hard mode for ESOCB
	Zones = {
		-- Dungeons ----------------------------------------------------------------
		{  144, false, unpack(BASE_D) }, -- Spindleclutch I
		{  936, false, unpack(BASE_D) }, -- Spindleclutch II
		{  380, false, unpack(BASE_D) }, -- The Banished Cells I
		{  935, false, unpack(BASE_D) }, -- The Banished Cells II
		{  283, false, unpack(BASE_D) }, -- Fungal Grotto I
		{  934, false, unpack(BASE_D) }, -- Fungal Grotto II
		{  146, false, unpack(BASE_D) }, -- Wayrest Sewers I
		{  933, false, unpack(BASE_D) }, -- Wayrest Sewers II
		{  126, false, unpack(BASE_D) }, -- Elden Hollow I
		{  931, false, unpack(BASE_D) }, -- Elden Hollow II
		{   63, false, unpack(BASE_D) }, -- Darkshade Caverns I
		{  930, false, unpack(BASE_D) }, -- Darkshade Caverns II
		{  130, false, unpack(BASE_D) }, -- Crypt of Hearts I
		{  932, false, unpack(BASE_D) }, -- Crypt of Hearts II
		{  176, false, unpack(BASE_D) }, -- City of Ash I
		{  681, false, unpack(BASE_D) }, -- City of Ash II
		{  148, false, unpack(BASE_D) }, -- Arx Corinium
		{   22, false, unpack(BASE_D) }, -- Volenfell
		{  131, false, unpack(BASE_D) }, -- Tempest Island
		{  449, false, unpack(BASE_D) }, -- Direfrost Keep
		{   38, false, unpack(BASE_D) }, -- Blackheart Haven
		{   31, false, unpack(BASE_D) }, -- Selene's Web
		{   64, false, unpack(BASE_D) }, -- Blessed Crucible
		{   11, false, unpack(BASE_D) }, -- Vaults of Madness
		{  678, true, { 1303 } }, -- Imperial City Prison
		{  688, true, { 1279 } }, -- White-Gold Tower
		{  843, false, { 1795, 0 }, { 1506, F_VET } }, -- Ruins of Mazzatun
		{  848, false, { 1795, 0 }, { 1524, F_VET } }, -- Cradle of Shadows
		{  973, false, { 1705, 0 }, { 1696, F_VET } }, -- Bloodroot Forge
		{  974, false, { 1705, 0 }, { 1704, F_VET } }, -- Falkreath Hold
		{ 1009, false, { 1974, 0 }, { 1965, F_VET } }, -- Fang Lair
		{ 1010, false, { 1974, 0 }, { 1981, F_VET } }, -- Scalecaller Peak
		{ 1052, false, { 2317, 0 }, { 2154, F_VET } }, -- Moon Hunter Keep
		{ 1055, false, { 2317, 0 }, { 2164, F_VET } }, -- March of Sacrifices
		{ 1081, false, { 2504, 0 }, { 2272, F_VET } }, -- Depths of Malatar
		{ 1080, false, { 2504, 0 }, { 2262, F_VET } }, -- Frostvault
		{ 1122, false, { 2629, 0 }, { 2417, F_VET } }, -- Moongrave Fane
		{ 1123, false, { 2629, 0 }, { 2427, F_VET } }, -- Lair of Maarselok
		{ 1152, false, { 2747, 0 }, { 2541, F_VET } }, -- Icereach
		{ 1153, false, { 2747, 0 }, { 2551, F_VET } }, -- Unhallowed Grave
		{ 1197, false, { 2849, 0 }, { 2755, F_VET } }, -- Stone Garden
		{ 1201, false, { 2849, 0 }, { 2706, F_VET } }, -- Castle Thorn
		{ 1228, false, { 2991, 0 }, { 2833, F_VET } }, -- Black Drake Villa
		{ 1229, false, { 2991, 0 }, { 2843, F_VET } }, -- The Cauldron
		{ 1267, false, { 3044, 0 }, { 3018, F_VET } }, -- Red Petal Bastion
		{ 1268, false, { 3044, 0 }, { 3028, F_VET } }, -- The Dread Cellar
		{ 1301, false, { 3229, 0 }, { 3153, F_VET } }, -- Coral Aerie
		{ 1302, false, { 3229, 0 }, { 3154, F_VET } }, -- Shipwright's Regret
		{ 1360, false, { 3423, 0 }, { 3377, F_VET } }, -- Earthen Root Enclave
		{ 1361, false, { 3423, 0 }, { 3396, F_VET } }, -- Graven Deep
		{ 1389, false, { 3546, 0 }, { 3470, F_VET } }, -- Bal Sunnar
		{ 1390, false, { 3546, 0 }, { 3531, F_VET } }, -- Scrivener's Hall
		{ 1470, false, { 4011, 0 }, { 3812, F_VET } }, -- Oathsworn Pit
		{ 1471, false, { 4011, 0 }, { 3853, F_VET } }, -- Bedlam Veil
		{ 1496, false, { 4147, 0 }, { 4111, F_VET } }, -- Exiled Redoubt
		{ 1497, false, { 4147, 0 }, { 4130, F_VET } }, -- Lep Seclusa
		{ 1551, false, { 4330, 0 }, { 4313, F_VET } }, -- Naj-Caldeesh
		{ 1552, false, { 4330, 0 }, { 4336, F_VET } }, -- Black Gem Foundry

		-- Trials ------------------------------------------------------------------
		{  636, false, { 1136 } }, -- Hel Ra Citadel
		{  638, false, { 1137 } }, -- Aetherian Archive
		{  639, false, { 1138 } }, -- Sanctum Ophidia
		{  725, true, { 1344 } }, -- Maw of Lorkhaj
		{  975, true, { 1829 } }, -- Halls of Fabrication
		{ 1000, true, { 2079 } }, -- Asylum Sanctorium
		{ 1051, true, { 2136 } }, -- Cloudrest
		{ 1121, true, { 2466 } }, -- Sunspire
		{ 1196, true, { 2739 } }, -- Kyne's Aegis
		{ 1263, true, { 3007 } }, -- Rockgrove
		{ 1344, true, { 3252 } }, -- Dreadsail Reef
		{ 1427, true, { 3568 } }, -- Sanity's Edge
		{ 1478, true, { 4023 } }, -- Lucent Citadel
		{ 1548, true, { 4276 } }, -- Ossein Cage
		{ 1565, false }, -- Opulent Ordeal

		-- Arenas ------------------------------------------------------------------
		{  635, false, { 1474 } }, -- Dragonstar Arena
		{  677, true, { 1330 } }, -- Maelstrom Arena
		{ 1082, true, { 2364 } }, -- Blackrose Prison
		{ 1227, true, { 2911 } }, -- Vateshran Hollows
		{ 1436, true, { 3772 }, { 3931 } }, -- Infinite Archive
	}

	HardcodedAchievements = {
		-- CoA2
		[1082] = { 681, 0 }, -- Undaunted Rescuer
		[1111] = { 681, 0 }, -- Easy as Pie
		[1159] = { 681, F_VET }, -- Deadlands Savvy

		-- BRP
		[2365] = { 1082, F_ND }, -- Unchained and Undying
		[2367] = { 1082, F_VET }, -- Blackrose Buccaneer

		-- VH
		[2920] = { 1227, F_VET }, -- Missed Me by That Much
		[2960] = { 1227, 0 }, -- Honor to the Spiritblood

		-- Unmatched
		[1985] = { 1010 }, -- Scalecaller Savior
		[1990] = { 1010 }, -- Stand Your Ground
		[2671] = { 1152 }, -- Brush Fire
		[2680] = { 1153 }, -- Ceramic Panic
		[2681] = { 1153 }, -- Shattered Shields
		[2685] = { 1153 }, -- Skeletal Shutout
		[2881] = { 1228 }, -- Amphibians Arrested (typo)
		[3035] = { 1267 }, -- Sly Terror (typo)
		[3662] = { 1390 }, -- Missing Map Recovered
		[3664] = { 1390 }, -- Vault Guardian
		[4011] = { 1471 }, -- Obscured and Erased

		-- HM false positives (generally the extra-hard mode achievements)
		[2301] = { 1052 }, -- Strangling Cowardice
		[2824] = { 1197 }, -- Old Fashioned
		[2828] = { 1201 }, -- Guardian Preserved
		[3042] = { 1268 }, -- Settling Scores
		[3224] = { 1302 }, -- Sans Spirit Support
		[3226] = { 1301 }, -- Tentacless Triumph
		[3255] = { 1344, F_VET }, -- Full Tour
		[3391] = { 1360 }, -- Scourge of Archdruid Devyric
		[3410] = { 1361 }, -- Pressure in the Deep
		[3484] = { 1389 }, -- No Time to Waste
		[3538] = { 1390 }, -- Harsh Edit
		[3826] = { 1470 }, -- Dogged Avenger
		[3867] = { 1471 }, -- Martial Gift
		[4120] = { 1496 }, -- Exposed to the Elements
		[4125] = { 1496 }, -- Life's for the Living
		[4281] = { 1548, F_VET }, -- Heating Up
		[4327] = { 1551 }, -- No Time to Explore
		[4350] = { 1552 }, -- Entry-Level Position

		-- ND false positives
		[1837] = {  975 }, -- Stress Tested
		[2890] = { 1229 }, -- Hold It Together
	}

	ManualHardModeIds = {
		1829, -- Halls of Fabrication
		2466, 2469, 2470, -- Sunspire
		2079, 2085, 2086, -- Asylum Sanctorium
		2134, 2135, 2136, -- Cloudrest
		1279, 1303, 1704, 1965, 1981, 2164, 2262, 2272, 2417, 2427, 2541, 2551, -- Dungeons
	}

	-- Ignored achievements
	for _, id in ipairs({ 1071, 1072, 1073, 1074, 1075, 1078, 1079, 1115, 1116, 1117, 1139 }) do
		HardcodedAchievements[id] = { 0, 0 }
	end

	InjectedAchievements = {
		-- Imperial City Prison
		[678] = {
			{ 1132, F_MISC },
		},

		-- Opulent Ordeal
		[1565] = {
			{ 4517, F_NCLR },
			{ 4532, 0 },
			{ 4485, FLAGS.N },
		},
	}

	ExpectedCounts = {
		[F_NCLR] = { },
		[F_VCLR] = { },
		[F_HM] = {
			[1197] = 3,
			[1228] = 3,
		},
		[F_SR] = {
			[635] = 0,
			[677] = 0,
		},
		[F_ND] = {
			[635] = 0,
			[636] = 0,
			[638] = 0,
			[639] = 0,
		},
		[F_TRI] = { },
		-- ESOCB
		[F_MISC] = {
			[678] = 0,
			[1565] = 0,
		},
	}

	-- Nothing from IA or OO should be flagged
	for k, v in pairs(ExpectedCounts) do
		v[IA_ZONE] = 0
		v[OO_ZONE] = 0
	end

	Trophies = { }
	for i = 1, LMAC.GetMaxCollectibleId() do
		if (string.find(GetCollectibleName(i), "^Trophy:")) then
			table.insert(Trophies, i)
		end
	end

	Seen = { }

	return Data.results
end

local function CleanZoneName( zoneName )
	zoneName = string.gsub(zoneName, "^The ", "")
	zoneName = string.gsub(zoneName, "%-", ".")
	return zoneName
end

local function FindTrophyId( pattern )
	for _, id in ipairs(Trophies) do
		if (string.find(GetCollectibleDescription(id) .. " ", pattern)) then
			return id
		end
	end
	return 0
end

local function CheckND( description )
	if (string.find(description, "without suffering a .+ member death") or string.find(description, "^Complete .+ without dying") or string.find(description, "without experiencing the death of a group member")) then
		return true
	else
		return false
	end
end

local function CheckND2( description )
	if (string.find(description, "without dying")) then
		return true
	else
		return false
	end
end

local function CheckSR( description )
	if (string.find(description, "within .+ minutes") or string.find(description, "in under .+ minutes")) then
		return true
	else
		return false
	end
end

local function CheckHMById( achievementId )
	for _, id in ipairs(ManualHardModeIds) do
		if (achievementId == id) then
			return true
		end
	end
	return false
end

local function CheckHM( description, name )
	if (string.find(name, "Difficult Mode$") or string.find(zo_strlower(description), "defeat .+ after.* enraging") or string.find(description, "Scroll of Glorious Battle") or string.find(zo_strlower(description), "challenge banner") or string.find(description, "without .+ Sigil")) then
		return true
	else
		return false
	end
end

local function CheckMeta( description )
	if (string.find(description, "^Complete .+ listed") or string.find(description, "^Complete .+ following.* achievements") or string.find(description, "^Complete all achievements")) then
		return true
	else
		return false
	end
end

local function CheckClearN( description, name )
	if (string.find(name, "Completed$") or string.find(name, "Vanquisher$") or string.find(name, "Arena Champion$")) then
		return true
	else
		return false
	end
end

local function CheckClearV( description, name )
	if (string.find(name, "Conqueror$") and not string.find(name, "^Veteran")) then
		return true
	else
		return false
	end
end

local function Hex( flags )
	return string.format("0x%02X", flags)
end

local function GetExpectedHMCount( zoneId )
	if (RCR.ZONES.D[zoneId]) then
		return zoneId < 1267 and 1 or 3
	elseif (RCR.ZONES.T[zoneId]) then
		return zoneId < 1000 and 1 or 3
	elseif (RCR.ZONES.A[zoneId]) then
		return zoneId < 1082 and 0 or 1
	else
		return 0
	end
end

local function CheckGroup( data, flags, expected, desc, zoneId )
	local group = data[Hex(flags)]
	local count = group and LCCC.CountTable(group) or 0
	expected = ExpectedCounts[flags][zoneId] or expected
	if (count ~= expected) then
		RCR.Msg(string.format("[WARNING] Incorrect %s count: %s (%d found, %d expected)", desc, LCCC.GetZoneName(zoneId), count, expected))
	end
end

local function GetAchievementInfoEx(...)
	local results = { GetAchievementInfo(...) }
	results[1] = zo_strformat(results[1])
	return unpack(results)
end

local function Process( )
	local results = Initialize()
	local classified = { }
	local trophies = { }

	for _, zone in ipairs(Zones) do
		local zoneId = zone[1]
		local zoneName = LCCC.GetZoneName(zoneId)
		local forceMatch = zone[2]
		local patN = CleanZoneName(zoneName) .. "[^I]"
		local patV = "Veteran " .. patN

		results[zoneId] = { name = zoneName, trophy = FindTrophyId(patN) }
		local achievements = { }

		for i = 3, #zone do
			FinalHardModeHints[zone[i][1]] = true -- ESOCB
			local topLevelIndex, subCategoryIndex = GetCategoryInfoFromAchievementId(zone[i][1])
			local numAchievements = subCategoryIndex and select(2, GetAchievementSubCategoryInfo(topLevelIndex, subCategoryIndex)) or select(3, GetAchievementCategoryInfo(topLevelIndex))
			local flagsBase = zone[i][2]
			local expectNormal = flagsBase == 0
			for j = 1, numAchievements do
				local achievementId = GetAchievementId(topLevelIndex, subCategoryIndex, j)
				while true do
					local nextAchievementId = GetNextAchievementInLine(achievementId)
					if (nextAchievementId ~= 0) then
						achievementId = nextAchievementId
					else
						break
					end
				end
				if (achievementId == 0) then
					RCR.Msg(string.format("[ERROR] Invalid Index for %s: %d/%d/%d", zoneName, topLevelIndex or 0, subCategoryIndex or 0, j))
				end
				local name, description = GetAchievementInfoEx(achievementId)
				local matched = false
				local flags = flagsBase or 0

				if (not Seen[achievementId]) then
					Seen[achievementId] = true
				end

				local hardcode = HardcodedAchievements[achievementId]
				if (hardcode) then
					if (hardcode[1] == 0) then
						Seen[achievementId] = hardcode[1]
					elseif (hardcode[1] == zoneId) then
						matched = true
						if (hardcode[2]) then
							flags = hardcode[2]
						end
					end
				else
					if (string.find(description .. " ", patV)) then
						matched = true
						flags = BitOr(flags, F_VET)
					elseif (string.find(description .. " ", patN)) then
						matched = true
					elseif (string.find(name, patN)) then
						matched = true
					end

					if (not matched and forceMatch) then
						matched = true
						Data.forced[achievementId] = string.format("%s----%s", name, description)
					end

					if (matched) then
						if (CheckHMById(achievementId)) then
							flags = BitOr(flags, F_HM)
						elseif (CheckChallenger(zoneId, name)) then -- ESOCB
							flags = BitOr(flags, F_MISC)
						elseif (CheckND(description)) then
							flags = BitOr(flags, CheckSR(description) and F_TRI or F_ND)
						elseif (CheckSR(description)) then
							flags = BitOr(flags, CheckND2(description) and F_TRI or F_SR)
						elseif (CheckHM(description, name)) then
							flags = BitOr(flags, F_HM)
						elseif (CheckClearN(description, name)) then
							flags = BitOr(flags, F_NCLR)
						elseif (CheckClearV(description, name)) then
							flags = BitOr(flags, F_VCLR)
						elseif (CheckMeta(description)) then
							flags = BitOr(flags, RCR.ZONES.T[zoneId] and F_MISC or F_VET) -- ESOCB
						end
					end
				end

				if (matched) then
					Seen[achievementId] = zoneId
					if (zoneId == IA_ZONE) then flags = 0 end -- Nothing from IA should be flagged
					results[zoneId][Hex(flags)] = results[zoneId][Hex(flags)] or { }
					results[zoneId][Hex(flags)][achievementId] = string.format("%s----%s", name, description)
					table.insert(achievements, { achievementId, flags })
					if (expectNormal and BitAnd(flags, F_VET) == F_VET) then
						RCR.Msg(string.format("[WARNING] Unexpected Veteran: %d/%s", achievementId, name))
					end
				end
			end
		end

		for _, achievement in ipairs(InjectedAchievements[zoneId] or { }) do
			table.insert(achievements, achievement)
		end

		table.insert(classified, { zoneId = zoneId, achievements = achievements })
		table.insert(trophies, results[zoneId].trophy)
	end

	for achievementId, status in pairs(Seen) do
		if (status == true) then
			Data.unmatched[achievementId] = string.format("%s----%s", GetAchievementInfoEx(achievementId))
			RCR.Msg(string.format("[WARNING] Unmatched: %d/%s", achievementId, GetAchievementInfoEx(achievementId)))
		end
	end

	for zoneId, data in pairs(results) do
		CheckGroup(data, F_NCLR, 1, "normal clear", zoneId)
		CheckGroup(data, F_VCLR, 1, "vet clear", zoneId)
		CheckGroup(data, F_HM, GetExpectedHMCount(zoneId), "hard mode", zoneId)
		CheckGroup(data, F_SR, 1, "speedrun", zoneId)
		CheckGroup(data, F_ND, 1, "no-death", zoneId)
		CheckGroup(data, F_TRI, zoneId < 975 and 0 or 1, "trifecta", zoneId)
		-- ESOCB
		CheckGroup(data, F_MISC, ShouldExpectMisc(zoneId) and 1 or 0, "misc", zoneId)
	end

	local encoded = { }
	for _, data in ipairs(classified) do
		table.sort(data.achievements, function( a, b )
			return a[1] < b[1]
		end)
		MarkFinalHardMode(data.zoneId, data.achievements) -- ESOCB
		local fields = { LCCC.Encode(data.zoneId, FIELD_SIZE) }
		for _, achievement in ipairs(data.achievements) do
			table.insert(fields, LCCC.Encode(achievement[1], FIELD_SIZE) .. LCCC.Encode(achievement[2], FLAGS_SIZE))
		end
		table.insert(encoded, table.concat(fields, ""))
	end

	local signature = string.format("Generated by RCR_AchievementClassifier on %s (%d: %s)", os.date("%Y/%m/%d %H:%M:%S", GetTimeStamp()), GetAPIVersion(), GetESOVersionString())
	Data.encoded = LCCC.Chunk(table.concat(encoded, ","))
	Data.encoded.signature = signature
	RCR.Msg(signature)

	Data.trophies = table.concat(trophies, ",")
end

LCCC.RunAfterInitialLoadscreen(function( )
	SLASH_COMMANDS["/rcrach"] = Process
end)
