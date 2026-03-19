HowToCloudrest = HowToCloudrest or {}
local HowToCloudrest = HowToCloudrest

local LAM = LibAddonMenu2

local colorChoice = {
  [1] = {1,0,0},
  [2] = {0,1,0},
  [3]	= {0,0,1},
  [4]	= {1,0,1},
  [5]	= {0,1,1},
  [6]	= {1,1,0},
}
local colorChoiceLabel  = {
  [1] = "Red",
  [2]	= "Green",
  [3]	= "Blue",
  [4] = "Pink",
  [5] = "Cyan",
  [6] = "Yellow",
}

local defaultSettingsLabel = {
  [1] = "显示所有",
  [2]	= "大爷d",
  [3]	= "打球员",
  [4]	= "下地d",
  [5]	= "人群奶",
  [6] = "kite奶",
  [7]	= "下楼t",
  [8]	= "小王t",
  [9] = "什么都不显示",
}

local defaultSettings = {
	-- Show Everything
	[1]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.RazorThorns = true
				sV.HA = false

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = true

				sV.Announcement_MiniBash = true

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = true
				sV.Portal_Announcement = true
				sV.MalevolentCores = true
				sV.Spears = true

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = true

				sV.ShadowSplash = true
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = true
				sV.MaliciousSphere_Announcement = true
				sV.MaliciousSphere_Tracking = true
				sV.MaliciousSphere_Execute = true

				sV.Creeper_Announcement = true
		end,
	-- DD (Upstairs)
	[2]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.RazorThorns = true
				sV.HA = false

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = false

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = false

				sV.ShadowSplash = false
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = true

				sV.Creeper_Announcement = true
			end,
	-- DD (Orb duty)
	[3]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = false

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = false

				sV.ShadowSplash = false
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = true
				sV.MaliciousSphere_Announcement = true
				sV.MaliciousSphere_Tracking = true
				sV.MaliciousSphere_Execute = true

				sV.Creeper_Announcement = true
			end,
	-- DD (Portal)
	[4]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = true
				sV.Portal_Announcement = true
				sV.MalevolentCores = true
				sV.Spears = true

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = false

				sV.ShadowSplash = false
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = true

				sV.Creeper_Announcement = true
			   end,
	-- Heal (Group)
	[5]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = false

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = false

				sV.ShadowSplash = false
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = true
				sV.MaliciousSphere_Announcement = true
				sV.MaliciousSphere_Tracking = true
				sV.MaliciousSphere_Execute = true

				sV.Creeper_Announcement = true
			end,
	-- Heal (Kite)
	[6]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = true

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = true

				sV.ShadowSplash = false
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = false

				sV.Creeper_Announcement = true
			end,
	-- Tank (Portal)
    [7]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = true
				sV.Portal_Announcement = true
				sV.MalevolentCores = true
				sV.Spears = true

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = true

				sV.ShadowSplash = true
				sV.BanefulMark = true

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = false

				sV.Creeper_Announcement = true
			end,
	-- Tank (Minis)
	[8]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.HA = false
				sV.RazorThorns = true

				-- Mini Frame
				sV.MiniFrame = true
				sV.MiniJump = true
				sV.MiniBash = true
				sV.MiniSkill = true

				sV.Announcement_MiniBash = true

				-- Siroria
				sV.DarkTalons = true
				sV.Flare = true

				-- Relequen
				sV.ReleHA = true
				sV.Overload = true
				sV.Overload_Tabulation = true

				-- Galenwe
				sV.Hoarfrost = true
				sV.ChillingComet = true

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = false

				-- Z'Maja
				sV.ZmajaJump = true

				sV.CrushingDarkness_Kite = true
				sV.CrushingDarkness_Next = true

				sV.ShadowSplash = false
				sV.BanefulMark = false

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = false

				sV.Creeper_Announcement = true
			   end,
	-- Show nothing
	[9]	= 	function ()
				local sV = HowToCloudrest.savedVariables.Enable
				-- General
				sV.RazorThorns = false
				sV.HA = false

				-- Mini Frame
				sV.MiniFrame = false
				sV.MiniJump = false
				sV.MiniBash = false
				sV.MiniSkill = false

				sV.Announcement_MiniBash = false

				-- Siroria
				sV.DarkTalons = false
				sV.Flare = false

				-- Relequen
				sV.ReleHA = false
				sV.Overload = false
				sV.Overload_Tabulation = false

				-- Galenwe
				sV.Hoarfrost = false
				sV.ChillingComet = false

				-- Portal
				sV.Portal = false
				sV.Portal_Announcement = false
				sV.MalevolentCores = false
				sV.Spears = false

				-- Z'Maja
				sV.ZmajaJump = false

				sV.CrushingDarkness_Kite = false
				sV.CrushingDarkness_Next = false

				sV.ShadowSplash = false
				sV.BanefulMark = false

				sV.MaliciousSphere_Timer = false
				sV.MaliciousSphere_Announcement = false
				sV.MaliciousSphere_Tracking = false
				sV.MaliciousSphere_Execute = false

				sV.Creeper_Announcement = false
	end,
}

function HowToCloudrest.UnlockUI(newValue)
	local sV = HowToCloudrest.savedVariables
	HowToCloudrest.SetDefaultUIValues()
	HowToCloudrest.SetMiniFrameDefault()
	-- General
	if (sV.Enable.HA) then
		HTC_Ha:SetHidden(not newValue)
	end

	if (sV.Enable.DarkTalons or sV.Enable.RazorThorns) then
		HTC_Rooted:SetHidden(not newValue)
	end

	if (sV.Enable.MiniFrame) then
		HTC_MiniFrame:SetHidden(not newValue)
	end
	if (sV.Enable.Announcement_MiniBash) then
		HTC_Announcement_MiniBash:SetHidden(not newValue)
	end

	-- Siroria
	if (sV.Enable.Flare) then
		HTC_Flare:SetHidden(not newValue)
	end

	-- Relequen
	if (sV.Enable.ReleHA) then
		HTC_ReleHA:SetHidden(not newValue)
	end
	if (sV.Enable.Overload) then
		HTC_OverloadTimer:SetHidden(not newValue)
	end

	-- Galenwe
	if (sV.Enable.Hoarfrost) then
		HTC_Hoarfrost:SetHidden(not newValue)
	end
	if (sV.Enable.ChillingComet) then
		HTC_ChillingComet:SetHidden(not newValue)
	end

	-- Portal
	if (sV.Enable.Portal) then
		HTC_Portal:SetHidden(not newValue)
	end
	if (sV.Enable.Portal_Announcement) then
		HTC_Portal_Announcement:SetHidden(not newValue)
	end

	-- Z'Maja
	if (sV.Enable.ZmajaJump) then
		HTC_ZmajaJump:SetHidden(not newValue)
	end

	if (sV.Enable.CrushingDarkness_Kite) then
		HTC_CrushingDarkness_Kite:SetHidden(not newValue)
	end
	if (sV.Enable.CrushingDarkness_Next) then
		HTC_CrushingDarkness_Next:SetHidden(not newValue)
	end

	if (sV.Enable.ShadowSplash) then
		HTC_ShadowSplash:SetHidden(not newValue)
	end
	if (sV.Enable.BanefulMark) then
		HTC_BanefulMark:SetHidden(not newValue)
	end

	if (sV.Enable.MaliciousSphere_Timer) then
		HTC_MaliciousSphere_Timer:SetHidden(not newValue)
	end
	if (sV.Enable.MaliciousSphere_Announcement) then
		HTC_MaliciousSphere_Announcement:SetHidden(not newValue)
	end
	if (sV.Enable.MaliciousSphere_Tracking) then
		HTC_MaliciousSphere_Tracking:SetHidden(not newValue)
	end

	if (sV.Enable.Creeper_Announcement) then
		HTC_Creeper_Announcement:SetHidden(not newValue)
	end
end

function HowToCloudrest.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "HowToCloudrest",
		displayName = "HowTo|cff00ffCloudrest|r",
		author = "Floliroy, |cc0c0c0@|rn|cc0c0c0ogetrandom|r, XL_Olsen",
		version = HowToCloudrest.version,
		slashCommand = "/HowToCloudrest",
		registerForRefresh = true,
		registerForDefaults = true,
	}

	local cntrlOptionsPanel = LAM:RegisterAddonPanel("HowToCloudrest_Settings", panelData)
	local Unlock = {
		Everything = false,
		-- General
		HA = false,

		MiniFrame = false,
		Announcement_MiniBash = false,

		Rooted = false,

		-- Siroria
		Flare = false,

		-- Relequen
		ReleHA = false,
		DirectCurrent = false,
		Overload = false,
		OverloadOverlay = false,

		-- Galenwe
		Hoarfrost = false,
		ChillingComet = false,
		GlacialSpikes = false,

		-- Portal
		Portal = false,
		Portal_Announcement = false,

		-- Z'Maja
		ZmajaJump = false,

		CrushingDarkness_Kite = false,
		CrushingDarkness_Next = false,

		ShadowSplash = false,
		BanefulMark = false,

		MaliciousSphere_Timer = false,
		MaliciousSphere_Announcement = false,
		MaliciousSphere_Tracking = false,

		Creeper_Announcement = false,
	}

	local sV = HowToCloudrest.savedVariables

	local optionsData = {
		{
			type = "description",
			--text = "Trial timers, alerts and indicators for Dreadsail Reef.",
			text = "云栖城机制的计时器，警报和指示器.汉化：@Pr4gMat1c, 来自公会OneNOnly(PC-NA)",
		},{
			type = "divider",
		},
		{
			type = "dropdown",
			name = "角色预设配置选择",
			tooltip = "根据在队伍中的特定位置开启不同的设置，保证定位上的人专注于做自己的事情不被其他信息打扰。",
			choices = defaultSettingsLabel,
			default = defaultSettingsLabel[1],
			getFunc = function() return sV.defaultSettingsChoice end,
			setFunc = function(selected)
				for index, name in ipairs(defaultSettingsLabel) do
					if name == selected then
						sV.defaultSettingsChoice = name
						if Unlock.Everything then
							HowToCloudrest.UnlockUI(not Unlock.Everything)
						end
						defaultSettings[index]()
						if Unlock.Everything then
							HowToCloudrest.UnlockUI(Unlock.Everything)
						end
						break
					end
				end
			end,
		},
		{
			type = "description",
			text = "这些预设配置会覆盖你手动启用的配置，且预设配置暂时无法更改。",
		},
		{
			type = "checkbox",
			name = "解锁UI",
			default = false,
			getFunc = function() return Unlock.Everything end,
			setFunc = function(newValue)
				Unlock.Everything = newValue
				HowToCloudrest.SetDefaultUIValues()
				HowToCloudrest.UnlockUI(newValue)
			end,
		},
		{
			type = "description",
			text = "屏幕通知测试 (CSA):",
		},
		{
			type = "button",
			name = "测试 CSA",
			func =
				function ()
					local CSA = CENTER_SCREEN_ANNOUNCE
					local messageParams = CSA:CreateMessageParams(CSA_CATEGORY_SMALL_TEXT, SOUNDS.SKILL_LINE_ADDED)
					messageParams:SetText("Test Center Screen Announcement")
					messageParams:SetPriority(1)
					CSA:AddMessageWithParams(messageParams)
				end,
		},
		{
			type = "submenu",
			name = "基础设置",
			controls = {
				{
					type = "header",
					name = "缠绕通知选项",
				},
				{
					type = "checkbox",
					name = "启用藤蔓瞄准通知",
					tooltip = "当藤蔓瞄准你缠绕时，显示通知.",
					default = true,
					getFunc = function() return sV.Enable.RazorThorns end,
					setFunc = function(newValue)
						sV.Enable.RazorThorns = newValue
						if (Unlock.Everything or Unlock.Rooted) then
							HTC_Rooted:SetHidden(not newValue)
						else
							HTC_Rooted:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "启用藤蔓缠绕通知",
					tooltip = "当藤蔓缠绕到你时，显示通知 (rooted).",
					default = true,
					getFunc = function() return sV.Enable.DarkTalons end,
					setFunc = function(newValue)
						sV.Enable.DarkTalons = newValue
						if (Unlock.Everything or Unlock.Rooted) then
							HTC_Rooted:SetHidden(not newValue)
						else
							HTC_Rooted:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "显示藤蔓通知",
					tooltip = "解锁藤蔓通知位置 (Creepers' Razor Thorns & Sirorias' Dark Talons).",
					default = false,
					getFunc = function() return Unlock.Rooted end,
					setFunc = function(newValue)
						Unlock.Rooted = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Rooted:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "藤蔓通知大小",
					tooltip = "设置藤蔓通知大小.",
					getFunc = function() return sV.FontSize_Rooted end,
					setFunc = function(newValue)
						sV.FontSize_Rooted = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
			}
		},
		{
			type = "submenu",
			name = "小王选项",
			controls = {
				{
					type = "header",
					name = "通常",
				},
				{
					type = "checkbox",
					name = "启用小王列表",
					tooltip = "显示包含有关小王传送、打断和特殊技能的信息的小王列表.",
					default = true,
					getFunc = function() return sV.Enable.MiniFrame end,
					setFunc = function(newValue)
						sV.Enable.MiniFrame = newValue
						if (Unlock.Everything or Unlock.MiniFrame) then
							HTC_MiniFrame:SetHidden(not newValue)
						else
							HTC_MiniFrame:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "解锁小王列表",
					tooltip = "设置小王列表.",
					default = false,
					getFunc = function() return Unlock.MiniFrame end,
					setFunc = function(newValue)
						Unlock.MiniFrame = newValue
						HowToCloudrest.SetMiniFrameDefault()
						HowToCloudrest.SetDefaultUIValues()
						HTC_MiniFrame:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "小王列表大小",
					tooltip = "设置小王列表大小.",
					getFunc = function() return sV.Size_MiniFrame end,
					setFunc = function(newValue)
						sV.Size_MiniFrame = newValue
						HowToCloudrest.SetSize_MiniFrame()
					end,
					min = 1,
					max = 12,
					step = 1,
					default = 5,
					decimals = 0,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用小王传送计时",
					tooltip = "显示一个计时器，它会告诉你小王传送的冷却时间.",
					default = true,
					getFunc = function() return sV.Enable.MiniJump end,
					setFunc = function(newValue)
						sV.Enable.MiniJump = newValue
						HowToCloudrest.SetMiniFrameDefault()
					end,
				},
				{
					type = "checkbox",
					name = "启用小王打断计时",
					tooltip = "显示一个计时器，它会告诉你小王需要打断的技能的冷却时间.",
					default = true,
					getFunc = function() return sV.Enable.MiniBash end,
					setFunc = function(newValue)
						sV.Enable.MiniBash = newValue
						HowToCloudrest.SetMiniFrameDefault()
					end,
				},
				{
					type = "checkbox",
					name = "启用小王技能计时",
					tooltip = "显示一个计时器，它会告诉你小王使用技能的冷却时间.",
					default = true,
					getFunc = function() return sV.Enable.MiniSkill end,
					setFunc = function(newValue)
						sV.Enable.MiniSkill = newValue
						HowToCloudrest.SetMiniFrameDefault()
					end,
				},
				{
					type = "divider"
				},
				{
					type = "checkbox",
					name = "启用小王打断通知",
					tooltip = "当释放Relequens 的Direct Current和Galenwes的Glacial Spikes时显示通知.",
					default = true,
					getFunc = function() return sV.Enable.Announcement_MiniBash end,
					setFunc = function(newValue)
						sV.Enable.Announcement_MiniBash = newValue
						if (Unlock.Everything or Unlock.Announcement_MiniBash) then
							HTC_Announcement_MiniBash:SetHidden(not newValue)
						else
							HTC_Announcement_MiniBash:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "解锁小王打断通知位置",
					tooltip = "设置小王打断通知位置.",
					default = false,
					getFunc = function() return Unlock.Announcement_MiniBash end,
					setFunc = function(newValue)
						Unlock.Announcement_MiniBash = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Announcement_MiniBash:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "小王打断通知大小",
					tooltip = "设置小王打断通知的大小",
					getFunc = function() return sV.FontSize_BashAnnouncement end,
					setFunc = function(newValue)
						sV.FontSize_BashAnnouncement = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{	type = "checkbox",
					name = "启用小王重击通知",
					tooltip = "监控所有小王重击.",
					default = true,
					getFunc = function() return sV.Enable.HA end,
					setFunc = function(newValue)
						sV.Enable.HA = newValue
						if (Unlock.Everything or Unlock.HA) then
							HTC_Ha:SetHidden(not newValue)
						else
							HTC_Ha:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "解锁小王重击通知位置",
					tooltip = "设置小王重击通知位置.",
					default = false,
					getFunc = function() return Unlock.HA end,
					setFunc = function(newValue)
						Unlock.HA = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Ha:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "小王重击通知大小",
					tooltip = "设置小王重击通知大小.",
					getFunc = function() return sV.FontSize_HA end,
					setFunc = function(newValue)
								sV.FontSize_HA = newValue
								HowToCloudrest.SetAllFontSizes()
							end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},

				-- {
				-- 	type = "desciption",
				-- 	name = "Siroria",
				-- },

				{
					type = "header",
					name = "Siroria",
				},
				{
					type = "checkbox",
                    name = "启用叠火通知",
                    tooltip = "显示叠火的人是谁，斩杀阶段显示去谁右侧和左侧.",
                    default = true,
                    getFunc = function() return sV.Enable.Flare end,
                    setFunc = function(newValue)
						sV.Enable.Flare = newValue
						if (Unlock.Everything or Unlock.Flare) then
							HTC_Flare:SetHidden(not newValue)
						else
							HTC_Flare:SetHidden(newValue)
						end
                    end,
                },
                {
					type = "checkbox",
                    name = "解锁叠火通知",
                    tooltip = "设置叠火通知位置.",
                    default = false,
                    getFunc = function() return Unlock.Flare end,
                    setFunc = function(newValue)
                        Unlock.Flare = newValue
                        HowToCloudrest.SetDefaultUIValues()
                        HTC_Flare:SetHidden(not newValue)
                    end,
                },
                {
					type = "slider",
                    name = "叠火通知大小",
                    tooltip = "设置叠火通知大小.",
                    getFunc = function() return sV.FontSize_Flare end,
                    setFunc = function(newValue)
                        sV.FontSize_Flare = newValue
                        HowToCloudrest.SetAllFontSizes()
                    end,
                    min = 22,
                    max = 58,
                    step = 2,
                    default = 40,
                    width = "full",
				},
				{
					type = "header",
					name = "Relequen",
				},
				{
					type = "checkbox",
					name = "启用 Relequen 重击通知",
					tooltip = "当你需要从Relquens Heavy Attack中寻找AoE时，显示计时器.",
					default = true,
					getFunc = function() return sV.Enable.ReleHA end,
					setFunc = function(newValue)
						sV.Enable.ReleHA = newValue
						if (Unlock.Everything or Unlock.ReleHA) then
							HTC_ReleHA:SetHidden(not newValue)
						else
							HTC_ReleHA:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "解锁Relequen 重击通知",
					tooltip = "设置Relequen 重击通知的位置.",
					default = false,
					getFunc = function() return Unlock.ReleHA end,
					setFunc = function(newValue)
						Unlock.ReleHA = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_ReleHA:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "Relequen 重击通知大小",
					tooltip = "Set the size of Relequen Heavy Attack alert.",
					getFunc = function() return sV.FontSize_ReleHA end,
					setFunc = function(newValue)
								sV.FontSize_ReleHA = newValue
								HowToCloudrest.SetAllFontSizes()
							end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用过载通知",
					tooltip = "点你电切手期间的过载通知.",
					default = true,
					getFunc = function() return sV.Enable.Overload end,
					setFunc = function(newValue)
						sV.Enable.Overload = newValue
						if (Unlock.Everything or Unlock.Overload) then
							HTC_OverloadTimer:SetHidden(not newValue)
						else
							HTC_OverloadTimer:SetHidden(newValue)
						end
					end,
				},
				{
					type = "checkbox",
					name = "解锁过载通知位置",
					tooltip = "设置过载通知位置.",
					default = false,
					getFunc = function() return Unlock.Overload end,
					setFunc = function(newValue)
						Unlock.Overload = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_OverloadTimer:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "过载通知大小",
					tooltip = "设置过载通知大小",
					getFunc = function() return sV.FontSize_Overload end,
					setFunc = function(newValue)
						sV.FontSize_Overload = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 50,
					width = "full",
				},
				{
					type = "checkbox",
					name = "启用过载通知悬浮窗",
					tooltip = "过载时在屏幕两侧显示彩色悬浮窗.",
					default = false,
					getFunc = function() return sV.Enable.Overload_Overlay end,
					setFunc = function(newValue)
						sV.Enable.Overload_Overlay = newValue
					end,
				},
				{
					type = "checkbox",
					name = "启用过载悬浮窗",
					tooltip = "使用它显示过载悬浮窗查看颜色.",
					default = false,
					getFunc = function() return Unlock.OverloadOverlay end,
					setFunc = function(newValue)
						Unlock.OverloadOverlay = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Overload:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "启用过载闪烁",
					tooltip = "启用时，过载通知的'不要切手'文本将闪烁，使其更易于跟踪.",
					default = true,
					getFunc = function() return sV.Enable.Overload_Tabulation end,
					setFunc = function(newValue)
						sV.Enable.Overload_Tabulation = newValue
					end,
				},
				{
					type = "slider",
					name = "过载闪烁频率",
					tooltip = "设置过载闪烁频率.",
					getFunc = function() return sV.OverloadFrequency end,
					setFunc = function(newValue)
						sV.OverloadFrequency = newValue
					end,
					min = 1,
					max = 20,
					step = 1,
					default = 5,
					width = "full",
				},
				{
					type = "dropdown",
					name = "过载悬浮窗颜色",
					tooltip = "选择你想要的过载悬浮窗的颜色.",
					choices = colorChoiceLabel,
					default = colorChoiceLabel[4],
					getFunc = function() return colorChoiceLabel[sV.overloadColorChoice] end,
					setFunc = function(selected)
						for index, name in ipairs(colorChoiceLabel) do
							if name == selected then
								sV.overloadColorChoice = index
								sV.overloadColor = colorChoice[index]
								local c = sV.overloadColor
								HowToCloudrest.SetOverloadOverlay(c[1], c[2], c[3])
								break
							end
						end
					end,
				},

				{
					type = "header",
					name = "Galenwe",
				},
				{
					type = "checkbox",
                    name = "显示冰风通知",
                    tooltip = "追踪何时需要丢冰风，以及冰风何时被其他人丢了.",
                    default = true,
                    getFunc = function() return sV.Enable.Hoarfrost end,
                    setFunc = function(newValue)
						sV.Enable.Hoarfrost = newValue
						if (Unlock.Everything or Unlock.Hoarfrost) then
							HTC_Hoarfrost:SetHidden(not newValue)
						else
							HTC_Hoarfrost:SetHidden(newValue)
						end
                    end,
                },
                {
					type = "checkbox",
                    name = "解锁冰风通知位置",
                    tooltip = "设置冰风通知位置.",
                    default = false,
                    getFunc = function() return Unlock.Hoarfrost end,
                    setFunc = function(newValue)
                        Unlock.Hoarfrost = newValue
                        HowToCloudrest.SetDefaultUIValues()
                        HTC_Hoarfrost:SetHidden(not newValue)
                    end,
                },
                {
					type = "slider",
                    name = "冰风通知大小",
                    tooltip = "设置冰风通知大小.",
                    getFunc = function() return sV.FontSize_Hoarfrost end,
                    setFunc = function(newValue)
                        sV.FontSize_Hoarfrost = newValue
                        HowToCloudrest.SetAllFontSizes()
                    end,
                    min = 22,
                    max = 58,
                    step = 2,
                    default = 40,
                    width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
                    name = "启用冰彗星通知",
                    tooltip = "冰彗星点你的时候告诉你.",
                    default = true,
                    getFunc = function() return sV.Enable.ChillingComet end,
                    setFunc = function(newValue)
						sV.Enable.ChillingComet = newValue
						if (Unlock.Everything or Unlock.ChillingComet) then
							HTC_ChillingComet:SetHidden(not newValue)
						else
							HTC_ChillingComet:SetHidden(newValue)
						end
                    end,
                },
                {
					type = "checkbox",
                    name = "解锁冰彗星通知位置",
                    tooltip = "设置冰彗星通知位置.",
                    default = false,
                    getFunc = function() return Unlock.ChillingComet end,
                    setFunc = function(newValue)
                        Unlock.ChillingComet = newValue
                        HowToCloudrest.SetDefaultUIValues()
                        HTC_ChillingComet:SetHidden(not newValue)
                    end,
                },
                {
					type = "slider",
                    name = "冰彗星通知大小",
                    tooltip = "设置冰彗星通知大小.",
                    getFunc = function() return sV.FontSize_ChillingComet end,
                    setFunc = function(newValue)
                        sV.FontSize_ChillingComet = newValue
                        HowToCloudrest.SetAllFontSizes()
                    end,
                    min = 22,
                    max = 58,
                    step = 2,
                    default = 40,
                    width = "full",
                },
			} -- Mini Boss submenu end
		},
		{
			type = "submenu",
			name = "传送门选项",
			controls = {
				{
					type = "checkbox",
					name = "启用传送门通知",
					tooltip = "显示传送门计时，以及下一个下地的组.",
					default = false,
					getFunc = function() return sV.Enable.Portal end,
					setFunc = function(newValue)
						sV.Enable.Portal = newValue
						if (Unlock.Everything or Unlock.Portal) then
							HTC_Portal:SetHidden(not newValue)
						else
							HTC_Portal:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁传送门通知位置",
					tooltip = "设置传送门追踪计时的位置.",
					default = false,
					getFunc = function() return Unlock.Portal end,
					setFunc = function(newValue)
						Unlock.Portal = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Portal:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "传送门通知大小",
					tooltip = "Set the size of the portal timer",
					getFunc = function() return sV.FontSize_Portal end,
					setFunc = function(newValue)
						sV.FontSize_Portal = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用传送门出现通知",
					tooltip = "传送门出现时通知.",
					default = false,
					getFunc = function() return sV.Enable.Portal_Announcement end,
					setFunc = function(newValue)
						sV.Enable.Portal_Announcement = newValue
						if (Unlock.Everything or Unlock.Portal_Announcement) then
							HTC_Portal_Announcement:SetHidden(not newValue)
						else
							HTC_Portal_Announcement:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁传送门出现通知",
					tooltip = "设置解锁传送门出现通知位置.",
					default = false,
					getFunc = function() return Unlock.Portal_Announcement end,
					setFunc = function(newValue)
						Unlock.Portal_Announcement = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Portal_Announcement:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "传送门通知的大小",
					tooltip = "设置传送门出现通知的大小.",
					getFunc = function() return sV.FontSize_Portal_Announcement end,
					setFunc = function(newValue)
						sV.FontSize_Portal_Announcement = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
			}
		},
		{
			type = "submenu",
			name = "泽玛亚选项",
			controls = {
				{
					type = "checkbox",
					name = "启用Zmaja传送跟踪通知",
					tooltip = "显示Zmaja即将进入下一个地方时的计时器.",
					default = true,
					getFunc = function() return sV.Enable.ZmajaJump end,
					setFunc = function(newValue)
						sV.Enable.ZmajaJump = newValue
						if (Unlock.Everything or Unlock.ZmajaJump) then
							HTC_ZmajaJump:SetHidden(not newValue)
						else
							HTC_ZmajaJump:SetHidden(newValue)
						end
					end,
				},
				{	type = "checkbox",
					name = "解锁Zmaja传送跟踪通知",
					tooltip = "设置Zmaja传送跟踪通知.",
					default = false,
					getFunc = function() return Unlock.ZmajaJump end,
					setFunc = function(newValue)
						Unlock.ZmajaJump = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_ZmajaJump:SetHidden(not newValue)
					end,
				},
				{	type = "slider",
					name = "Zmaja传送跟踪通知大小",
					tooltip = "设置Zmaja传送跟踪通知大小.",
					getFunc = function() return sV.FontSize_ZmajaJump end,
					setFunc = function(newValue)
							sV.FontSize_ZmajaJump = newValue
							HowToCloudrest.SetAllFontSizes()
						end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用黑圈（kite）通知",
					tooltip = "告诉你Z'Maja的黑圈还要kite多久.",
					default = false,
					getFunc = function() return sV.Enable.CrushingDarkness_Kite end,
					setFunc = function(newValue)
						sV.Enable.CrushingDarkness_Kite = newValue
						if (Unlock.Everything or Unlock.CrushingDarkness_Kite) then
							HTC_CrushingDarkness_Kite:SetHidden(not newValue)
						else
							HTC_CrushingDarkness_Kite:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁黑圈（kite）通知",
					tooltip = "设置黑圈（kite）通知的位置.",
					default = false,
					getFunc = function() return Unlock.CrushingDarkness_Kite end,
					setFunc = function(newValue)
						Unlock.CrushingDarkness_Kite = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_CrushingDarkness_Kite:SetHidden(not newValue)
					end,
				},
				{	type = "slider",
					name = "黑圈（kite）通知大小",
					tooltip = "设置黑圈（kite）通知大小.",
					getFunc = function() return sV.FontSize_CrushingDarkness_Kite end,
					setFunc = function(newValue)
							sV.FontSize_CrushingDarkness_Kite = newValue
							HowToCloudrest.SetAllFontSizes()
						end,
					min = 22,
					max = 58,
					step = 2,
					default = 40,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "下次黑圈（kite）计时通知",
					tooltip = "告诉你黑圈（kite）什么时候来.",
					default = false,
					getFunc = function() return sV.Enable.CrushingDarkness_Next end,
					setFunc = function(newValue)
						sV.Enable.CrushingDarkness_Next = newValue
						if (Unlock.Everything or Unlock.CrushingDarkness_Next) then
							HTC_CrushingDarkness_Next:SetHidden(not newValue)
						else
							HTC_CrushingDarkness_Next:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁下次黑圈（kite）计时通知",
					tooltip = "设置下次黑圈（kite）计时通知位置.",
					default = false,
					getFunc = function() return Unlock.CrushingDarkness_Next end,
					setFunc = function(newValue)
						Unlock.CrushingDarkness_Next = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_CrushingDarkness_Next:SetHidden(not newValue)
					end,
				},
				{	type = "slider",
					name = "下次黑圈（kite）计时通知大小",
					tooltip = "设置下次黑圈（kite）计时通知大小.",
					getFunc = function() return sV.FontSize_CrushingDarkness_Next end,
					setFunc = function(newValue)
							sV.FontSize_CrushingDarkness_Next = newValue
							HowToCloudrest.SetAllFontSizes()
						end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用zmaja打断 (Interrupt) 警告",
					tooltip = "告诉你什么时候该打断zmaja.",
					default = false,
					getFunc = function() return sV.Enable.ShadowSplash end,
					setFunc = function(newValue)
						sV.Enable.ShadowSplash = newValue
						if (Unlock.Everything or Unlock.ShadowSplash) then
							HTC_ShadowSplash:SetHidden(not newValue)
						else
							HTC_ShadowSplash:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁zmaja打断 (Interrupt) 警告",
					tooltip = "设置zmaja打断 (Interrupt) 警告位置.",
					default = false,
					getFunc = function() return Unlock.ShadowSplash end,
					setFunc = function(newValue)
						Unlock.ShadowSplash = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_ShadowSplash:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "zmaja打断 (Interrupt) 警告大小",
					tooltip = "设置zmaja打断 (Interrupt) 警告大小",
					getFunc = function() return sV.FontSize_ShadowSplash end,
					setFunc = function(newValue)
						sV.FontSize_ShadowSplash = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用斩杀阶段有害标记计时通知",
					tooltip = "Z'Maja斩杀阶段的有害标记计时器.",
					default = false,
					getFunc = function() return sV.Enable.BanefulMark end,
					setFunc = function(newValue)
						sV.Enable.BanefulMark = newValue
						if (Unlock.Everything or Unlock.BanefulMark) then
							HTC_BanefulMark:SetHidden(not newValue)
						else
							HTC_BanefulMark:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁斩杀阶段有害标记计时通知",
					tooltip = "设置解锁斩杀阶段有害标记计时通知大小.",
					default = false,
					getFunc = function() return Unlock.BanefulMark end,
					setFunc = function(newValue)
						Unlock.BanefulMark = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_BanefulMark:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "斩杀阶段有害标记计时通知大小",
					tooltip = "设置斩杀阶段有害标记计时通知",
					getFunc = function() return sV.FontSize_BanefulMark end,
					setFunc = function(newValue)
						sV.FontSize_BanefulMark = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用打球计时",
					default = false,
					getFunc = function() return sV.Enable.MaliciousSphere_Timer end,
					setFunc = function(newValue)
						sV.Enable.MaliciousSphere_Timer = newValue
						if (Unlock.Everything or Unlock.MaliciousSphere_Timer) then
							HTC_MaliciousSphere_Timer:SetHidden(not newValue)
						else
							HTC_MaliciousSphere_Timer:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁打球计时位置",
					tooltip = "设置打球计时位置.",
					default = false,
					getFunc = function() return Unlock.MaliciousSphere_Timer end,
					setFunc = function(newValue)
						Unlock.MaliciousSphere_Timer = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_MaliciousSphere_Timer:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "打球计时通知大小",
					tooltip = "设置打球计时通知大小",
					getFunc = function() return sV.FontSize_MaliciousSphere_Timer end,
					setFunc = function(newValue)
						sV.FontSize_MaliciousSphere_Timer = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用打球计时通知",
					tooltip = "Tells you when Z'Maja is spawning Malicious Spheres (Orbs).",
					default = false,
					getFunc = function() return sV.Enable.MaliciousSphere_Announcement end,
					setFunc = function(newValue)
						sV.Enable.MaliciousSphere_Announcement = newValue
						if (Unlock.Everything or Unlock.MaliciousSphere_Announcement) then
							HTC_MaliciousSphere_Announcement:SetHidden(not newValue)
						else
							HTC_MaliciousSphere_Announcement:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁打球计时通知",
					tooltip = "设置打球计时通知位置.",
					default = false,
					getFunc = function() return Unlock.MaliciousSphere_Announcement end,
					setFunc = function(newValue)
						Unlock.MaliciousSphere_Announcement = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_MaliciousSphere_Announcement:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "打球计时通知大小",
					tooltip = "设置打球计时通知大小",
					getFunc = function() return sV.FontSize_MaliciousSphere_Announcement end,
					setFunc = function(newValue)
						sV.FontSize_MaliciousSphere_Announcement = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用打球计数追踪",
					tooltip = "告诉你打多少球.",
					default = false,
					getFunc = function() return sV.Enable.MaliciousSphere_Tracking end,
					setFunc = function(newValue)
						sV.Enable.MaliciousSphere_Tracking = newValue
						if (Unlock.Everything or Unlock.MaliciousSphere_Tracking) then
							HTC_MaliciousSphere_Tracking:SetHidden(not (sV.Enable.MaliciousSphere_Execute or newValue))
						else
							HTC_MaliciousSphere_Tracking:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "启用斩杀阶段打球计数追踪",
					tooltip = "告诉你斩杀要打多少球.",
					default = false,
					getFunc = function() return sV.Enable.MaliciousSphere_Execute end,
					setFunc = function(newValue)
						sV.Enable.MaliciousSphere_Execute = newValue
						if (Unlock.Everything or Unlock.MaliciousSphere_Tracking) then
							HTC_MaliciousSphere_Tracking:SetHidden(not (sV.Enable.MaliciousSphere_Tracking or newValue))
						else
							HTC_MaliciousSphere_Tracking:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁打球计数追踪",
					tooltip = "设置启用打球计数追踪位置.",
					default = false,
					getFunc = function() return Unlock.MaliciousSphere_Tracking end,
					setFunc = function(newValue)
						Unlock.MaliciousSphere_Tracking = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_MaliciousSphere_Tracking:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "打球计数追踪大小",
					tooltip = "设置打球计数追踪大小",
					getFunc = function() return sV.FontSize_MaliciousSphere_Tracking end,
					setFunc = function(newValue)
						sV.FontSize_MaliciousSphere_Tracking = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 32,
					max = 80,
					step = 2,
					default = 32,
					width = "full",
				},
				{
					type = "divider",
				},
				{
					type = "checkbox",
					name = "启用藤蔓生成通知",
					tooltip = "告诉你藤蔓什么时候生成了.",
					default = false,
					getFunc = function() return sV.Enable.Creeper_Announcement end,
					setFunc = function(newValue)
						sV.Enable.Creeper_Announcement = newValue
						if (Unlock.Everything or Unlock.Creeper_Announcement) then
							HTC_Creeper_Announcement:SetHidden(not newValue)
						else
							HTC_Creeper_Announcement:SetHidden(newValue)
						end
					end
				},
				{
					type = "checkbox",
					name = "解锁藤蔓生成通知",
					tooltip = "设置藤蔓生成通知位置.",
					default = false,
					getFunc = function() return Unlock.Creeper_Announcement end,
					setFunc = function(newValue)
						Unlock.Creeper_Announcement = newValue
						HowToCloudrest.SetDefaultUIValues()
						HTC_Creeper_Announcement:SetHidden(not newValue)
					end,
				},
				{
					type = "slider",
					name = "藤蔓生成通知大小",
					tooltip = "设置藤蔓生成通知大小",
					getFunc = function() return sV.FontSize_Creeper_Announcement end,
					setFunc = function(newValue)
						sV.FontSize_Creeper_Announcement = newValue
						HowToCloudrest.SetAllFontSizes()
					end,
					min = 22,
					max = 58,
					step = 2,
					default = 32,
					width = "full",
				},
			} -- Z'Maja submenu end
		},

	}

	LAM:RegisterOptionControls("HowToCloudrest_Settings", optionsData)
end
