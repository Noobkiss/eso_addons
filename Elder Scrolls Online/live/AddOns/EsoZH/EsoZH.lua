local EsoZH = {}
EsoZH.name = "EsoZH"
EsoZH.Flags = { "en", "zh" }
EsoZH.Version = "v1.0.8"
EsoZH.API = 101043
EsoZH.dropDownparm = { 
	["zh"] = "仅中文",
	["zh+en"] = "中文+英文",
	["en+zh"] = "英文+中文",
	["en"] = "仅英文",
}
EsoZH.LangDownparm = { 
	["en"] = "英文",
	["zh"] = "中文",
}
EsoZH.FontSizeDownparm = { 
	[30] = "30",
	[28] = "28",
	[26] = "26",
	[24] = "24",
	[22] = "22",
	[21] = "21",
	[20] = "20",
	[19] = "19",
	[18] = "18",
}
EsoZH.StringsBackup = {
	["SI_ABILITY_NAME_AND_RANK"] = GetString(SI_ABILITY_NAME_AND_RANK),
	["SI_ABILITY_TOOLTIP_NAME"] = GetString(SI_ABILITY_TOOLTIP_NAME),
	["SI_ITEM_FORMAT_STR_ENCHANT_HEADER_NAMED"] = GetString(SI_ITEM_FORMAT_STR_ENCHANT_HEADER_NAMED),
	["SI_ITEM_FORMAT_STR_ITEM_TRAIT_HEADER"] = GetString(SI_ITEM_FORMAT_STR_ITEM_TRAIT_HEADER),
	["SI_ITEM_FORMAT_STR_ITEM_TRAIT_WITH_ICON_HEADER"] = GetString(SI_ITEM_FORMAT_STR_ITEM_TRAIT_WITH_ICON_HEADER),
	["SI_ITEM_FORMAT_STR_SET_NAME"] = GetString(SI_ITEM_FORMAT_STR_SET_NAME),
	["SI_ITEM_FORMAT_STR_PERFECTED_SET_NAME"] = GetString(SI_ITEM_FORMAT_STR_PERFECTED_SET_NAME),
	["SI_TOOLTIP_ITEM_NAME"] = GetString(SI_TOOLTIP_ITEM_NAME),
	["SI_ITEM_FORMAT_STR_SET_NAME_NO_COUNT"] = GetString(SI_ITEM_FORMAT_STR_SET_NAME_NO_COUNT),
}

ZO_CreateStringId("ESOZH_ADDON_OUTDATE", "双语插件似乎已落后当前游戏版本，请查看网站找寻最新版本。你也可以直接点击下边的”查看最新版本”按钮，然后确认提示，会在你电脑的默认浏览器内自动打开汉化插件的网页地址。")
ZO_CreateStringId("ESOZH_DATA_OUTDATE", "数据库看起来不符合当前游戏版本，需要重新导出文本，否则可能有文本不匹配或错乱的情况出现。导出文本视你电脑配置可能需要1~3分钟的时间，请耐心等待！期间可能会自动重载界面数次，请不要强行退出游戏。点击“确定”按钮开始导出游戏文本，点击“取消”按钮本次暂不导出最新数据。")
ZO_CreateStringId("ESOZH_DATA_REEXPORT", "导出文本视你电脑配置可能需要1~3分钟的时间，请耐心等待！期间可能会自动重载界面数次，请不要强行退出游戏。点击“确定”按钮开始导出游戏文本，点击“取消”按钮本次暂不导出最新数据。")
ZO_CreateStringId("ESOZH_DATA_UNCOMPLETE", "插件数据库导出不完整，需要重新导出。导出文本视你电脑配置可能需要1~3分钟的时间，请耐心等待！期间可能会自动重载界面数次，请不要强行退出游戏。点击“确定”按钮开始导出游戏文本。")
ZO_CreateStringId("ESOZH_INIT_DATA", "欢迎使用插件，当前未找寻到插件数据库，需要导出游戏部分文本才可使用双语功能。导出文本视你电脑配置可能需要1~3分钟的时间，请耐心等待！期间可能会自动重载界面数次，请不要强行退出游戏。点击“确定”按钮开始导出游戏文本。")
ZO_CreateStringId("ESOZH_DATA_REEXPORT_DONE", "文本导出完毕，在聊天窗口内输入 /esozh 然后回车来对插件进行一些设置和访问额外功能。\n\n\n\n|ac|t256:128:EsoZH/Textures/Donate.dds|t\n\n\n\n|al你也可以适当捐助来让插件变得更好。")
ZO_CreateStringId("ESOZH_DONATE", "你可以在聊天窗口内输入 /esozh 然后回车来对插件进行一些设置和访问额外功能。\n\n\n\n|ac|t256:128:EsoZH/Textures/Donate.dds|t\n\n\n\n|al你也可以适当捐助来让插件变得更好。")
--ZO_CreateStringId("ESOZH_GUILD_SA", "|H1:guild:660663|hSplendid Achievers|h\nSA|cfff600主会|r面向CP160以上玩家，每周竞拍商铺并且每周必需缴纳5K金币会费。\n\n|H1:guild:688589|hSplendid Achievers II|h\n|H1:guild:774193|hSplendid Achievers IlI|h\n|H1:guild:848581|hSplendid Achievers IV|h\n|H1:guild:848561|hSplendid Achievers V|h\nSA|cfff600分会|r面向休闲玩家，会有简单休闲的跑图活动，带萌新开传送祭坛及清理天空碎片、世界Boss等。\n\n|H1:guild:848579|hSplendid Achievers PVP|h\nSA|cfff600PvP分会|r面向PvP玩家，主要方便战场或角斗场玩家进行联络沟通。\n\n点击确定后，在|cfff600聊天窗口|r中点击公会链接以选择您想加入的公会。")
--ZO_CreateStringId("ESOZH_GUILD_SA_JOIN_ALREADY", "你已经加入了 Splendid Achievers 主会或某一分会，不建议同时加入多个分会。")
--ZO_CreateStringId("ESOZH_GUILD_PL_JOIN_ALREADY", "你已经加入了Pigeon Legion鸽子军团。")
ZO_CreateStringId("ESOZH_LIVE_ONLY", "仅支持正式服。")
ZO_CreateStringId("ESOZH_LIVE_NA_ONLY", "仅支持美服。")
ZO_CreateStringId("ESOZH_ADDON_JF", "已检测到曾用机翻插件，使用双语功能需要切换至官方汉化语言。导出文本视你电脑配置可能需要1~3分钟的时间，请耐心等待！期间可能会自动重载界面数次，请不要强行退出游戏。点击“确定”按钮开始导出游戏文本并切换语言。")
ZO_CreateStringId("ESOZH_LANGTO_ZH", "你确定要修改游戏语言至中文吗？切换会自动重载游戏界面，请在安全的地方切换。")
ZO_CreateStringId("ESOZH_LANGTO_EN", "你确定要修改游戏语言至英文吗？切换会自动重载游戏界面，请在安全的地方切换。")

EsoZH.Defaults = {
    FirstInit = true,
    NeedUpdate = true,
    versionInt = 1,
	LocationDoubleName = "zh+en",
	ItemDoubleName = "zh+en",
	ItemTraits = "zh+en",
	NpcName = "zh+en",
	SkillName = "zh+en",
	EnchantsName = "zh+en",
	SetsName = "zh+en",
	ChampionName = "zh+en",
--	CraftName = "zh",
	DonateMsgbox = true,
	NamePlateFontSize = 20,
	SCTFontSize = 26,
}
EsoZH.Settings = EsoZH.Defaults

EsoZH.ExportNames = {
	ExportVersion = 0,
	AddonVersion = "",
	Skills = {},
	Items = {},
	Sets = {},
	SetsNames = {},
	Traits = {},
	Potions = {},
	Locations = {},
	Parts = {},
	Prefixes = {},
	Affixes = {},
	EnchantPrefixes = {},
}

EsoZH.Names = EsoZH.ExportNames

local Font_Univers57 = "EsoZH/fonts/Univers57.slug"

local panelData = {
    type = "panel",
    --name = "中英双语插件",
    name = EsoZH.name,
    displayName = "中英双语插件",
    author = "Kevin熊熊",
    version = EsoZH.Version,
    slashCommand = "/esozh",
    registerForRefresh = true,
    registerForDefaults = true,
	website = "https://kevinbear91.com/addonmanager",
}

local optionsTable = { }

table.insert(optionsTable,{
		type = "header",
		name = "双语选项",
		width = "full",	--or "half" (optional)
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "地名",
	tooltip = "对于已翻译的地名，选择是否中英语显示。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.LocationDoubleName end,
	setFunc = (function(value)
		EsoZH.Settings.LocationDoubleName = value

		if value ~= "zh" and EsoZh_doubleNameLocation then
			EsoZh_doubleNameLocation(EsoZH)
		end

		FRIENDS_LIST_MANAGER:BuildMasterList()
		FRIENDS_LIST_MANAGER:OnSocialDataLoaded()
		GUILD_ROSTER_MANAGER:BuildMasterList()
		GUILD_ROSTER_MANAGER:OnGuildDataLoaded()

		LFGDoubleNames(EsoZH)

		CADWELLS_ALMANAC:RefreshList()
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
		EsoZH:MapNameStyle()
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "装备名称",
	tooltip = "对于已翻译的装备名称，选择是否中英语显示。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.ItemDoubleName end,
	setFunc = (function(value)
		EsoZH.Settings.ItemDoubleName = value

		if value ~= "zh" and EsoZH_doubleNameItems then
			EsoZH_doubleNameItems(EsoZH)
		end
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "装备特性",
	tooltip = "选择是否双语显示装备特性。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.ItemTraits end,
	setFunc = (function(value)
		EsoZH.Settings.ItemTraits = value

		if value ~= "zh" and EsoZH_doubleNameItems then
			EsoZH_doubleNameItems(EsoZH)
		end
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "符文名",
	tooltip = "选择是否双语显示符文名。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.EnchantsName end,
	setFunc = (function(value)
		EsoZH.Settings.EnchantsName = value

		if value ~= "zh" and EsoZH_doubleNameItems then
			EsoZH_doubleNameItems(EsoZH)
		end
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "套装名",
	tooltip = "选择是否双语显示套装名。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.SetsName end,
	setFunc = (function(value)
		EsoZH.Settings.SetsName = value

		if value ~= "zh" and EsoZH_doubleNameItems then
			EsoZH_doubleNameItems(EsoZH)
		end
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "NPC名",
	tooltip = "选择是否双语显示NPC名字。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.NpcName end,
	setFunc = (function(value)
		EsoZH.Settings.NpcName = value

		if value ~= "zh" and EsoZh_doubleNameNPC then
			EsoZh_doubleNameNPC(EsoZH)
		end
	end),
	width = "full",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "技能名",
	tooltip = "选择是否双语显示技能名。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.SkillName end,
	setFunc = (function(value)
		EsoZH.Settings.SkillName = value

		if value ~= "zh" and EsoZH_doubleNameSkills then
			EsoZH_doubleNameSkills(EsoZH)
		end

		SKILLS_WINDOW:RebuildSkillLineList()
		COMPANION_SKILLS_DATA_MANAGER:RebuildSkillsData()
	end),
	width = "full",
})
table.insert(optionsTable,{
	type = "dropdown",
	name = "勇士星座名",
	tooltip = "选择是否双语显示勇士星座名。",
	choices = {
		EsoZH.dropDownparm["zh"],
		EsoZH.dropDownparm["zh+en"],
		EsoZH.dropDownparm["en+zh"],
		EsoZH.dropDownparm["en"],
	},
	choicesValues = {"zh","zh+en","en+zh","en"},
	getFunc = function() return EsoZH.Settings.ChampionName end,
	setFunc = (function(value)
		EsoZH.Settings.ChampionName = value

		if value ~= "zh" and EsoZH_doubleNameChampion then
			EsoZH_doubleNameChampion(EsoZH)
		end

		SKILLS_WINDOW:RebuildSkillLineList()
		COMPANION_SKILLS_DATA_MANAGER:RebuildSkillsData()
	end),
	width = "full",
})
--table.insert(optionsTable,{
--	type = "dropdown",
--	name = "套装制造台",
--	tooltip = "选择是否双语显示套装制造台。",
--	choices = {
--		EsoZH.dropDownparm["zh"],
--		EsoZH.dropDownparm["zh+en"],
--		EsoZH.dropDownparm["en+zh"],
--		EsoZH.dropDownparm["en"],
--	},
--	choicesValues = {"zh","zh+en","en+zh","en"},
--	getFunc = function() return EsoZH.Settings.CraftName end,
--	setFunc = (function(value)
--		EsoZH.Settings.CraftName = value

--		if value ~= "zh" and EsoZh_doubleNameCraft then
--			EsoZh_doubleNameCraft(EsoZH)
--		end
--	end),
--	width = "full",
--})

table.insert(optionsTable,{
	type = "button",
	name = "导出数据",
	tooltip = "导出双语插件需要的数据",
	func = function()
		EsoZH:ShowMsgBox("提示", ESOZH_DATA_REEXPORT, 1)
	end,
	width = "half",	--or "half" (optional)
})

table.insert(optionsTable,{
	type = "header",
	name = "额外功能",
	width = "full",	--or "half" (optional)
})

--table.insert(optionsTable,{
--	type = "button",
--	name = "SA公会大厅",
--	tooltip = "传送到 辉煌成就者 公会大厅，美服或欧服会自动识别",
--	func = function()
--		if GetWorldName() == "NA Megaserver" then
--			JumpToSpecificHouse("@raven_wong", 71)
--		elseif GetWorldName() == "EU Megaserver" then
--			JumpToHouse("@Star-Sky")
--		else	
--			EsoZH:ShowMsgBox("提示", "\n\n|ac|t256:128:EsoZH/Textures/EsozhLogo.dds|t\n\n\n|al仅支持正式服。", 2)
--		end 
--	end,
--	width = "half",	--or "half" (optional)
--})

table.insert(optionsTable,{
	type = "dropdown",
	name = "切换游戏语言",
	tooltip = "选择游戏语言，切换到英语会使双语功能失效。",
	choices = {
		EsoZH.LangDownparm["zh"],
		EsoZH.LangDownparm["en"],
	},
	choicesValues = {"zh","en"},
	getFunc = function() return GetCVar("language.2") end,
	setFunc = (function(value)
		if value ~= GetCVar("language.2") then
			if value == "zh" then
				EsoZH:ShowMsgBox("提示", ESOZH_LANGTO_ZH, 5)
			elseif value == "en" then
				EsoZH:ShowMsgBox("提示", ESOZH_LANGTO_EN, 6)
			end
		end
	end),
	width = "half",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "人物铭牌字号",
	tooltip = "调整人物与NPC的名字字号，重载界面后生效，设置完毕后请在聊天窗口内输入 /reloadui 回车生效。",
	choices = {
		EsoZH.FontSizeDownparm[30],
		EsoZH.FontSizeDownparm[28],
		EsoZH.FontSizeDownparm[26],
		EsoZH.FontSizeDownparm[24],
		EsoZH.FontSizeDownparm[22],
		EsoZH.FontSizeDownparm[21],
		EsoZH.FontSizeDownparm[20],
		EsoZH.FontSizeDownparm[19],
		EsoZH.FontSizeDownparm[18],
	},
	choicesValues = {30, 28, 26, 24, 22, 21, 20, 19, 18},
	getFunc = function() return EsoZH.Settings.NamePlateFontSize end,
	setFunc = (function(value)
		if value ~= EsoZH.Settings.NamePlateFontSize then
			EsoZH.Settings.NamePlateFontSize = value
		end
	end),
	width = "half",
})

table.insert(optionsTable,{
	type = "dropdown",
	name = "游戏漂浮提示字号",
	tooltip = "调整伤害显示与翻滚格挡等漂浮提示的字号，重载界面后生效，设置完毕后请在聊天窗口内输入 /reloadui 回车生效。",
	choices = {
		EsoZH.FontSizeDownparm[30],
		EsoZH.FontSizeDownparm[28],
		EsoZH.FontSizeDownparm[26],
		EsoZH.FontSizeDownparm[24],
		EsoZH.FontSizeDownparm[22],
		EsoZH.FontSizeDownparm[21],
		EsoZH.FontSizeDownparm[20],
		EsoZH.FontSizeDownparm[19],
		EsoZH.FontSizeDownparm[18],
	},
	choicesValues = {30, 28, 26, 24, 22, 21, 20, 19, 18},
	getFunc = function() return EsoZH.Settings.SCTFontSize end,
	setFunc = (function(value)
		if value ~= EsoZH.Settings.SCTFontSize then
			EsoZH.Settings.SCTFontSize = value
		end
	end),
	width = "half",
})

--table.insert(optionsTable,{
--	type = "header",
--	name = "公会加入",
--	width = "full",	--or "half" (optional)
--})

--table.insert(optionsTable,{
--	type = "button",
--	name = "鸽子军团(美服)",
--	tooltip = "加入美服公会 Pigeon Legion 鸽子军团",
--	func = function()
--		if GetWorldName() == "NA Megaserver" then
--			if ZO_ValidatePlayerGuildId(665471) then
--				EsoZH:ShowMsgBox("提示", ESOZH_GUILD_PL_JOIN_ALREADY, 2)
--			end
--			ZO_LinkHandler_OnLinkClicked("|H1:guild:665471|hPigeon Legion|h", 1, nil)
--		else
--			EsoZH:ShowMsgBox("提示", ESOZH_LIVE_NA_ONLY, 2)
--		end end,
--	width = "half",	--or "half" (optional)
--})

--table.insert(optionsTable,{
--	type = "button",
--	name = "辉煌成就者分会",
--	tooltip = "加入公会 Splendid Achievers 辉煌成就者分会",
--	func = function() EsoZH:JoinSA() end,
--	width = "half",	--or "half" (optional)
--})

table.insert(optionsTable,{
	type = "header",
	name = "捐助打赏",
	width = "full",	--or "half" (optional)
})

table.insert(optionsTable,{
	type = "description",
	text ="\n\n\n\n\n\n|ac|t512:256:EsoZH/Textures/Donate.dds|t\n\n\n\n\n\n|al汉化插件需要你的捐助支持！\n\n从微攻略人工版汉化与机翻汉化迭代而来。学生请不要大额捐助。\n\nBevis熊熊",
	width = "full",	--or "half" (optional)
})

--function EsoZH:JoinSA()
--	if GetWorldName() == "NA Megaserver" then
--			if ZO_ValidatePlayerGuildId(660663) or ZO_ValidatePlayerGuildId(688589) or ZO_ValidatePlayerGuildId(774193) or ZO_ValidatePlayerGuildId(848581) or ZO_ValidatePlayerGuildId(848561) or ZO_ValidatePlayerGuildId(848579) then
--				EsoZH:ShowMsgBox("提示", ESOZH_GUILD_SA_JOIN_ALREADY, 2)
--			end
--			EsoZH:ShowMsgBox("提示", ESOZH_GUILD_SA, 2)
--			d('主会：|H1:guild:660663|hSplendid Achievers|h')
--			d('二会：|H1:guild:688589|hSplendid Achievers II|h')
--			d('三会：|H1:guild:774193|hSplendid Achievers IlI|h') 
--			d('四会：|H1:guild:848581|hSplendid Achievers IV|h')
--			d('五会：|H1:guild:848561|hSplendid Achievers V|h')
--			d('PvP会：|H1:guild:848579|hSplendid Achievers PVP|h')
--	elseif (GetWorldName() == "EU Megaserver") then
--			if ZO_ValidatePlayerGuildId(641060) then
--				EsoZH:ShowMsgBox("提示", ESOZH_GUILD_SA_JOIN_ALREADY, 2)
--			else
--				ZO_LinkHandler_OnLinkClicked("|H1:guild:641060|hSplendid Achievers|h", 1, nil)
--			end
--	else
--		EsoZH:ShowMsgBox("提示", ESOZH_LIVE_ONLY, 2)
--	end
	
--end

-- 改变游戏语言
function EsoZH.ChangeLang(lang)
    if lang ~= GetCVar("language.2") then
	    SetCVar("IgnorePatcherLanguageSetting", "1")
	    SetCVar("language.2", lang)
    end
end

-- 是否是全 ascii 字符串，用来判断是否汉化了
function EsoZH.IsAscii(s)
    for i = 1, #s do
       if string.byte(string.sub(s, i, i)) >= 128 then
            return true
        end
    end
    return false
end

function EsoZH:SCTFix()
	if GetCVar("language.2") == "zh" then
		SetSCTKeyboardFont("$(MEDIUM_FONT)" .. "|" .. EsoZH.Settings.SCTFontSize .. "|shadow")
		--SetSCTGamepadFont(Font_Medium .. "|" .. 42 .. "|",FONT_STYLE_SOFT_SHADOW_THICK)
		SetNameplateKeyboardFont("$(MEDIUM_FONT)" .. "|" .. EsoZH.Settings.NamePlateFontSize .. "|shadow")
	end
end

function EsoZH:StartupMessage()
	if self.Settings.NeedUpdate and self:IsOldDB() then
		self:ShowMsgBox("数据库需要更新", ESOZH_DATA_OUTDATE,1)
	end

	if self:IsOldDB() and not self.Settings.NeedUpdate then
		EsoZH:ShowMsgBox("欢迎使用双语插件", ESOZH_DATA_OUTDATE, 1)
		--d("aaaaaaa")
	end

	self:CheckExportStatus()

	--if EsoZH.Settings.DonateMsgbox then
	--	EsoZH:ShowMsgBox("欢迎使用双语插件", ESOZH_DATA_REEXPORT_DONE, 2)
	--	--EsoZH.Settings.DonateMsgbox = false
	--end
	
	--if EsoZH.API ~= GetAPIVersion() then
	--	EsoZH:ShowMsgBox("汉化插件需要更新", "\n\n|ac|t256:128:EsoZH/Textures/EsozhLogo.dds|t\n\n\n|al汉化插件看起来已经过时，使用旧版的汉化插件可能会引起文本缺失、文本无法对应等问题。\n\n请到微攻略网站查看并下载最新版本的汉化插件。\n\nhttps://vstab.com/local \n\n你也可以直接点击下边的 查看最新版本 按钮，然后确认提示，会在你电脑的默认浏览器内自动打开汉化插件的地址。", 3)
	--end
	
	EVENT_MANAGER:UnregisterForEvent("EsoZH_StartupMessage", EVENT_PLAYER_ACTIVATED)
end

-- 插件初始化时调用
function EsoZH:OnInitialize(eventCode, addOnName)

	if zo_strlower(addOnName) ~= zo_strlower(EsoZH.name) then return end
	EVENT_MANAGER:UnregisterForEvent("EsoZH_OnAddOnLoaded", EVENT_ADD_ON_LOADED)
	
    self.Settings = ZO_SavedVars:NewAccountWide("EsoZH_Variables", 1, nil, self.Defaults)
    self.Names = ZO_SavedVars:NewAccountWide("EsoZh_ExportData", 1, nil, self.ExportNames)

	--local lang = GetCVar("language.2")
	
	if self.Settings.FirstInit == true then
		SetSetting(SETTING_TYPE_SUBTITLES, SUBTITLE_SETTING_ENABLED_FOR_NPCS, "true")
		SetSetting(SETTING_TYPE_SUBTITLES, SUBTITLE_SETTING_ENABLED_FOR_VIDEOS, "true")
		self.Settings.FirstInit = false
		--EsoZH:ShowMsgBox("欢迎使用双语插件", ESOZH_INIT_DATA, 1)
	end

    
    -- chinese gamepad hack
    for k, v in pairs( ZO_TOOLTIP_STYLES ) do
        v.fontFace = "EsoZH/fonts/Univers57.slug"
    end
    
    for k, v in pairs( ZO_CRAFTING_TOOLTIP_STYLES ) do
        v.fontFace = "EsoZH/fonts/Univers57.slug"
    end
    
 	for _, flagCode in pairs(EsoZH.Flags) do
        ZO_CreateStringId("SI_BINDING_NAME_"..string.upper(flagCode), string.upper(flagCode))
    end

   -- EsoZH.RefreshUI()
    
	if not LibAddonMenu2 then return end
	LibAddonMenu2:RegisterAddonPanel(EsoZH.name.."Options", panelData)
	LibAddonMenu2:RegisterOptionControls(EsoZH.name.."Options", optionsTable)

	if GetCVar("language.2") == "zh" then
		EsoZH_init()
	end

    --SLASH_COMMANDS["/esozhexport"]=EsoZH.DumpEn
end

function EsoZH:CloseMsgBox()
	ZO_Dialogs_ReleaseDialog("EsoZHDialog", false)
end


function EsoZH_init()

	if EsoZH.Settings.LocationDoubleName ~= "zh" and EsoZh_doubleNameLocation then
		LFGDoubleNames(EsoZH)
		EsoZh_doubleNameLocation(EsoZH)
	end

	if (EsoZH.Settings.ItemDoubleName ~= "zh" or EsoZH.Settings.ItemTraits ~= "zh" or EsoZH.Settings.EnchantsName ~= "zh" or EsoZH.Settings.SetsName ~= "zh") and EsoZH_doubleNameItems then
		EsoZH_doubleNameItems(EsoZH)
	end
	
	if EsoZH.Settings.NpcName ~= "zh" and EsoZh_doubleNameNPC then
		EsoZh_doubleNameNPC(EsoZH)
	end

	if EsoZH.Settings.SkillName ~= "zh" and EsoZH_doubleNameSkills then
		EsoZH_doubleNameSkills(EsoZH)
	end

	if EsoZH.Settings.ChampionName ~= "zh" and EsoZH_doubleNameChampion then
		EsoZH_doubleNameChampion(EsoZH)
	end

	--if EsoZH.Settings.CraftName ~= "zh" and EsoZh_doubleNameCraft then
	--	EsoZh_doubleNameCraft(EsoZH)
	--end

	--if (EsoZH.Settings.EnchantsName ~= "zh" or EsoZH.Settings.EnchantsName ~= "zh") and EsoZH_doubleNameItems then
	--	EsoZH_doubleNameItems(EsoZH)
	--end
	
	--if (EsoZH.Settings.SetsName ~= "zh" or EsoZH.Settings.SetsName ~= "zh") and EsoZH_doubleNameItems then
	--	EsoZH_doubleNameItems(EsoZH)
	--end

end

function EsoZH:ShowMsgBox(title, msg, typ)

	local callback = {}
	--local msgBody = msg()
	
	if typ == 1 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "确定导出", 
				callback =
					function ()
						EsoZH.Settings.DonateMsgbox = true
						EsoZH.Settings.FirstInit = false
						EsoZH_ExportDB()
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
                text = "取消",
                callback = 
                	function()
	                	EsoZH.Settings.NeedUpdate = false
                	end,
                clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
	elseif typ == 2 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = SI_OK,
				callback =
					function ()
						EsoZH.Settings.DonateMsgbox = false
						EsoZH.Settings.FirstInit = false
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			}
		}
	elseif typ == 3 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "查看最新版本", 
				callback =
					function ()
						RequestOpenUnsafeURL("https://www.bevisbear.com/addonmanager/")
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
                text = "取消",
                clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
		elseif typ == 4 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "访问Steam社区组", 
				callback =
					function ()
						RequestOpenUnsafeURL("https://steamcommunity.com/groups/ESOChina")
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
                text = "取消",
                clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
		elseif typ == 5 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "切换至中文", 
				callback =
					function ()
						EsoZH.ChangeLang("zh")
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
                text = "取消",
                clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
		elseif typ == 6 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "切换至英文", 
				callback =
					function ()
						EsoZH.ChangeLang("en")
					end,
                clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
                text = "取消",
                clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
	--elseif typ == 5 then
	--	callback = {
	--		[1] = 
	--		{
	--			keybind = "DIALOG_PRIMARY",
	--			text = "访问汉化组招新申请页面", 
	--			callback =
	--				function ()
	--					RequestOpenUnsafeURL("https://www.edigame.com/join")
	--				end,
 --               clickSound = SOUNDS.DIALOG_ACCEPT,
	--		},
	--		[2] =
	--		{
	--			keybind = "DIALOG_NEGATIVE",
 --               text = "取消",
 --               clickSound = SOUNDS.DIALOG_DECLINE,
	--		},
	--	}
	end
	
	local confirmDialog = 
	{
		canQueue = true,
		onlyQueueOnce = true,
		gamepadInfo = { dialogType = GAMEPAD_DIALOGS.BASIC },
		title = { text = title },
		mainText = { text = GetString(msg) },
		buttons = callback
	}
	
	ZO_Dialogs_RegisterCustomDialog("EsoZHDialog", confirmDialog)
	EsoZH:CloseMsgBox()
	
	--else
		ZO_Dialogs_ShowDialog("EsoZHDialog")
	--end
end

-- 修改字幕显示时间，因为中文文本一般会比英文短
if not EsoZH.old_OnShowSubtitle then
    EsoZH.old_OnShowSubtitle = ZO_SubtitleManager.OnShowSubtitle
end
ZO_SubtitleManager.OnShowSubtitle = function(self, ...)
    EsoZH.old_OnShowSubtitle(self, ...)
    local message = self.currentSubtitle and self.currentSubtitle.messageText
    --local lang = GetCVar("Language.2")
    if GetCVar("Language.2") == "zh" and message and EsoZH.IsAscii(message) then
        local minLen = 3
        local maxLen = 12
        local messageLength = ZoUTF8StringLength(message)
        local charactersPerSecond = 4  -- default is 10
        self.currentSubtitle.displayLengthSeconds = zo_clamp(messageLength / charactersPerSecond, minLen, maxLen)
    end
end

function EsoZH:IsOldDB()
	local db = self.Names
	if not db.ExportVersion or not db.AddonVersion or (db.ExportVersion ~= GetAPIVersion()) or (db.AddonVersion ~= EsoZH.Version) then
		return true
	else
		return false
	end
end


function EsoZH:CheckExportStatus()
	if GetCVar("language.2") == "en" and EsoZH.Names["ExportEN"] ~= nil then
		EsoZH:DumpEn()
	end
	
	if GetCVar("language.2") == "zh" and EsoZH.Names["ExportZH"] ~= nil then
		EsoZH.Names["ExportZH"] = nil
		EsoZH:DumpZh()
	end

	if EsoZH.Names["ExportDone"] ~= nil then
		EsoZH.Names["ExportDone"] = nil
	end
	
end


function EsoZH_ExportDB()
	EsoZH.Names.Skills = {}
	EsoZH.Names.Items = {}
	EsoZH.Names.Sets = {}
	EsoZH.Names.SetsNames = {}
	EsoZH.Names.Traits = {}
	EsoZH.Names.Potions = {}
	EsoZH.Names.Locations = {}
	EsoZH.Names.Parts = {}
	EsoZH.Names.Prefixes = PrefixesDict
	EsoZH.Names.Affixes = AffixesDict
	EsoZH.Names.EnchantPrefixes = EnchantPrefixesDict

	if GetCVar("language.2") == "zh" then
		EsoZH:DumpZh()
	else
		EsoZH.Names["ExportZH"] = true
		SetCVar("language.2", "zh")
	end

end


function EsoZH:MagicReplace(str, what, with)
    what = zo_strgsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    with = zo_strgsub(with, "[%%]", "%%%%")
    return zo_strgsub(str, what, with)
end

function EsoZH:MapNameStyle()		
	if EsoZH.Settings.LocationDoubleNames == "zh+en" or EsoZH.Settings.LocationDoubleNames == "en+zh" then
		ZO_WorldMapCornerTitle:SetFont("ZoFontWinH3")
	else
		ZO_WorldMapCornerTitle:SetFont("ZoFontWinH1")
	end
	
	local scrollData = ZO_ScrollList_GetDataList(ZO_WorldMapLocationsList)
    ZO_ClearNumericallyIndexedTable(scrollData)
	WORLD_MAP_LOCATIONS_DATA:RefreshLocationList()
	WORLD_MAP_LOCATIONS:BuildLocationList()
end

function EsoZH:IsAddonRunning(addonName)
    local manager = GetAddOnManager()
    for i = 1, manager:GetNumAddOns() do
        local name, _, _, _, _, state = manager:GetAddOnInfo(i)
        if name == addonName and state == ADDON_STATE_ENABLED then
	        d(addonName)
            return true
        end
    end
    return false
end


function EsoZH:DumpZh()

	for i = 1, 300000 do

		local hasSet, setName = GetItemLinkSetInfo(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", i)) 
		
		if hasSet then
			EsoZH.Names.SetsNames[ZO_CachedStrFormat("<<z:1>>", setName)] = i
		end
	end
	
	for i = 1, #zhPotLinks do
		EsoZH.Names.Potions[GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", zhPotLinks[i]))] = zhPotLinks[i]
	end
	
	for i = 1, #zhParts do
		EsoZH.Names.Parts[ZO_CachedStrFormat("<<z:1>>", GetItemLinkName(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", zhParts[i])))] = zhParts[i]
	end
	
	--for i = 1, #zhEnchantPrefixes do
	--	EsoZH.Names.EnchantPrefixes[EsoZH:MagicReplace(GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", zhEnchantPrefixes[i])), " " .. GetItemLinkName("|H1:item:5364:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), "")] = zhEnchantPrefixes[i]
	--end
	
	--for i = 1, #zhPrefixes do
	--	local str = EsoZH:MagicReplace(ZO_CachedStrFormat("<<z:1>>", GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", zhPrefixes[i]))), " " .. ZO_CachedStrFormat("<<z:1>>", GetItemLinkName("|H1:item:" .. string.match(zhPrefixes[i], "^(%d+):") .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")), "")
	--	EsoZH.Names.Prefixes[str:sub(1, #str - 3)] = zhPrefixes[i]
	--end
	
	--for i = 1, #zhAffixes do
	--	EsoZH.Names.Affixes[EsoZH:MagicReplace(ZO_CachedStrFormat("<<z:1>>", GetItemLinkName(string.format("|H1:item:43533:0:0:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", zhAffixes[i]))), ZO_CachedStrFormat("<<z:1>>", GetItemLinkName("|H1:item:43533:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " ", "")] = zhAffixes[i]
	--end
	
	-- Locations
	
	local backupLocations = EsoZH.Settings.LocationDoubleName
	EsoZH.Settings.LocationDoubleName = "zh"
	
	local zonesCount = GetNumZones()
	for i = 1, zonesCount do
		local locationName = ZO_CachedStrFormat("<<z:1>>", GetZoneNameByIndex(i))
		if locationName then
			EsoZH.Names.Locations[locationName] = string.format("zone:%d:0", i)
		end
		
		local POIsCount = GetNumPOIs(i)
		for j = 1, POIsCount do
			local locationName = ZO_CachedStrFormat("<<z:1>>", GetPOIInfo(i, j))
			if locationName then
				EsoZH.Names.Locations[locationName] = string.format("poi:%d:%d", i, j)
			end
		end
	end
	
	local fastTravelNodesCount = GetNumFastTravelNodes()
	for i = 1, fastTravelNodesCount do
		local _, locationName = GetFastTravelNodeInfo(i)
		if locationName then
			EsoZH.Names.Locations[ZO_CachedStrFormat("<<z:1>>", locationName)] = string.format("ft:%d:0", i)
		end
	end
	
	for i = 1, 1000 do
		local locationName = ZO_CachedStrFormat("<<z:1>>", GetKeepName(i))
		if locationName then
			EsoZH.Names.Locations[locationName] = string.format("keep:%d:0", i)
		end
	end
	
	EsoZH.Settings.LocationDoubleName = backupLocations

	EsoZH.Names["ExportEN"] = true
	SetCVar("language.2", "en")
end

function EsoZH:DumpEn()

local numSkillTypes = GetNumSkillTypes()
	
	for i = 1, numSkillTypes do
		local numSkillLines = GetNumSkillLines(i)
		
		for j = 1, numSkillLines do
			local numSkillAbilities = GetNumSkillAbilities(i, j)
			
			for k = 1, numSkillAbilities do
				
				local _, _, _, passive = GetSkillAbilityInfo(i, j, k)
				
				if passive then
					for l = 1,GetNumPassiveSkillRanks(i, j, k) do
						local currentMorphId = GetSpecificSkillAbilityInfo(i, j, k, 0, l)
						EsoZH.Names.Skills[currentMorphId] = GetAbilityName(currentMorphId)
					end
				else
					local currentMorphId = GetSpecificSkillAbilityInfo(i, j, k, 0, 1)
					EsoZH.Names.Skills[currentMorphId] = GetAbilityName(currentMorphId)
					
					local currentMorphId = GetSpecificSkillAbilityInfo(i, j, k, 1, 1)
					EsoZH.Names.Skills[currentMorphId] = GetAbilityName(currentMorphId)
					
					local currentMorphId = GetSpecificSkillAbilityInfo(i, j, k, 2, 1)
					EsoZH.Names.Skills[currentMorphId] = GetAbilityName(currentMorphId)
				end
			end
		end
	end

	--for key,value in pairs(ruesoCompanionAbilities) do
	--	EsoZH.Names.Skills[key] = GetAbilityName(key)
	--end

	for i = 1, GetNumChampionDisciplines() do
		for j = 1, GetNumChampionDisciplineSkills(i) do
			EsoZH.Names.Skills[GetChampionAbilityId(GetChampionSkillId(i, j))] = GetChampionSkillName(GetChampionSkillId(i, j))
		end
	end

	for i = 1, 300000 do
		local itemName = GetItemLinkName(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", i))
		
		if itemName and itemName ~= "" and not string.match(itemName, "_") then
			EsoZH.Names.Items[i] = ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, itemName)
		end

		local hasSet, setName, _, _, _, setId = GetItemLinkSetInfo(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", i))
		
		if hasSet then
			EsoZH.Names.Sets[setId] = setName
		end

	end

	-- Set Names
	
	for index,value in pairs(EsoZH.Names.SetsNames) do
		local hasSet, setName = GetItemLinkSetInfo(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value))
		EsoZH.Names.SetsNames[index] = ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, setName)
	end
	
	-- Alchemy
	
	for index,value in pairs(EsoZH.Names.Potions) do
		EsoZH.Names.Potions[index] = ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value)))
	end
	
	-- Item Parts
	
	for index,value in pairs(EsoZH.Names.Parts) do
		EsoZH.Names.Parts[index] = ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(string.format("|H1:item:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value)))
	end
	
	-- Enchantment Prefixes
	
	--for index,value in pairs(EsoZH.Names.EnchantPrefixes) do
	--	EsoZH.Names.EnchantPrefixes[index] = ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, EsoZH:MagicReplace(GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value)), " " .. GetItemLinkName("|H1:item:5364:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), ""))
	--end
	
	-- Item Prefixes
	
	--for index,value in pairs(EsoZH.Names.Prefixes) do
	--	EsoZH.Names.Prefixes[index] = EsoZH:MagicReplace(ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(string.format("|H1:item:%s:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value))), " " .. ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:" .. string.match(value, "^(%d+):") .. ":0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")), "")
	--end
	
	-- Item Affixes
	
	--for index,value in pairs(EsoZH.Names.Affixes) do
	--	EsoZH.Names.Affixes[index] = EsoZH:MagicReplace(ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(string.format("|H1:item:43533:0:0:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", value))), ZO_CachedStrFormat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H1:item:43533:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")) .. " ", "")
	--end

	-- Traits
	
	for i = 1, 100 do
		local traitName = GetString("SI_ITEMTRAITTYPE", i)
		
		if traitName and traitName ~= "" then
			EsoZH.Names.Traits[i] = traitName
		end
	end

	-- Locations
	
	for index,value in pairs(EsoZH.Names.Locations) do
		local locType, locId, locSubId = string.match(value, "^(.*):(%d+):(%d+)$")
		
		if locType and locId and locSubId then
			if locType == "zone" then
				EsoZH.Names.Locations[index] = ZO_CachedStrFormat(SI_ZONE_NAME, GetZoneNameByIndex(locId))
			elseif locType == "poi" then
				EsoZH.Names.Locations[index] = ZO_CachedStrFormat(SI_ZONE_NAME, GetPOIInfo(locId, locSubId))
			elseif locType == "keep" then
				EsoZH.Names.Locations[index] = ZO_CachedStrFormat(SI_ZONE_NAME, GetKeepName(locId))
			elseif locType == "ft" then
				local _, locationName = GetFastTravelNodeInfo(locId)
				EsoZH.Names.Locations[index] = ZO_CachedStrFormat(SI_ZONE_NAME, locationName)
			end
		end
	end

	EsoZH.Names["ExportEN"] = nil
	EsoZH.Names["ExportDone"] = true

	EsoZH.Names.ExportVersion = GetAPIVersion()
	EsoZH.Names.AddonVersion = EsoZH.Version
	EsoZH.Settings.NeedUpdate = true

	SetCVar("language.2", "zh")
	
end


-- 注册初始化事件

--function OnAddonLoaded(eventType, addonName)
--	if addonName == EsoZH.name then
--		Initialize()
--		--UnregisterForEvent--
--		EVENT_MANAGER:UnregisterForEvent(EsoZH.name, eventType)
--	end
--	--EsoZH:SetFonts()
--end
--EVENT_MANAGER:RegisterForEvent(EsoZH.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
EVENT_MANAGER:RegisterForEvent("EsoZH_OnAddOnLoaded", EVENT_ADD_ON_LOADED, function(_event, _name) EsoZH:OnInitialize(_event, _name) end)
EVENT_MANAGER:RegisterForEvent("EsoZH_StartupMessage", EVENT_PLAYER_ACTIVATED, function(...) EsoZH:StartupMessage() end)
EVENT_MANAGER:RegisterForEvent("EsoZH_SCTFix", EVENT_PLAYER_ACTIVATED, function(...) EsoZH:SCTFix() end)
--EVENT_MANAGER:RegisterForEvent("EsoZH_LoadScreen", EVENT_PLAYER_ACTIVATED, function(...) EsoZH.LoadScreen() end)

--ZO_CompassCenterOverPinLabel:SetHandler("OnTextChanged", function() 
--	local pinLabelText = ZO_CompassCenterOverPinLabel:GetText()
	
--	if pinLabelText ~= nil and pinLabelText ~= "" then
--		ZO_CompassCenterOverPinLabel:SetText(ZO_CachedStrFormat(SI_UNIT_NAME, pinLabelText))
--	end
--end)
