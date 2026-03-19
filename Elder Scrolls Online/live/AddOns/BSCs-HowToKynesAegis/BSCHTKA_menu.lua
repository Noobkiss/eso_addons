BSCHTKAHelper = BSCHTKAHelper or {}
local BSCHTKA = BSCHTKAHelper

local optionsTable = {}

local function AddSendFeedBack()
    table.insert(optionsTable,     {
		type = "description",
		--text = "Trial timers, alerts and indicators for Dreadsail Reef.",
		text = "凯恩之盾相关机制的计时器、警报和指示器.汉化：@Pr4gMat1c, 来自公会OneNOnly(PC-NA)",
	})
end

local function AddTexture(control, strIcon, strDesciption)
	table.insert(control, {
        type = "texture",
        image =  GetAbilityIcon(strIcon),
		tooltip = strDesciption,
        imageWidth = 32,
        imageHeight = 32,
        width = "half",
	})
end

local function AddDivider(control)
	table.insert(control, {
		type = "divider",
	})
end

local TEST_COLOR = { 0, 0.8, 0, 0.4 }
local function AddTestAlert()
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		--name = "Use Select Color Alert",
		name = "使用所选颜色弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.USE_COLOR end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.USE_COLOR = value
		end,
        --width = "half",
	})	
	table.insert(optionsTable, {
		type = "colorpicker",
		--name = "Test Alert Color",
		name = "测试弹窗使用的颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(TEST_COLOR) end,
		setFunc = function(r,g,b,a) 
			TEST_COLOR={r,g,b,a} 
			CombatAlerts.AlertCast( 133515, "Test Alert", 4000, { -3, 0, false, { r , g, b, a }, { r , g, b, 1 } } )
			CombatAlerts.Alert(nil, "Test Alert!", BSCHTKA:BuildHexColor(TEST_COLOR), SOUNDS.NONE, 4000)
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	table.insert(optionsTable, {
        type = "button",
        --name = "Test Alert",
		name = "测试弹窗",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
        func = function()
			CombatAlerts.AlertCast( 133515, "Test Alert", 4000, { -3, 0, false, { unpack(TEST_COLOR) }, { TEST_COLOR[1] , TEST_COLOR[2], TEST_COLOR[3], 1 }})
			CombatAlerts.Alert(nil, "Test Alert!", BSCHTKA:BuildHexColor(TEST_COLOR), SOUNDS.NONE, 4000)
        end,
        width = "full",
    })	
end

local function AddUISettings()
	table.insert(optionsTable, {
        type = "header",
        name = "UI设置",
    })
	table.insert(optionsTable, {
		type = "checkbox",
		name = "显示BOSS UI",
		getFunc = function() return BSCHTKA.SV_ACC.SHOW_UI_BOSS end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.SHOW_UI_BOSS = value
		end,
        --width = "half",
	})	
	table.insert(optionsTable, {
		type = "checkbox",
		name = "锁定 Boss UI",
		getFunc = function() return BSCHTKA.SV_ACC.LOCK_UI_I end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.LOCK_UI_I = value
			BSCHTKAHelperInfoUI:SetMovable(not BSCHTKA.SV_ACC.LOCK_UI_I)
		end,
        --width = "half",
	})	
	table.insert(optionsTable, {
        type = "button",
        name = "重置BOSS UI位置",
        func = function()
			BSCHTKAHelperInfoUI:ClearAnchors()
			BSCHTKAHelperInfoUI:SetAnchor(BOTTOM, GuiRoot, CENTER, 500, -150)	
			BSCHTKA.SV_ACC.UI_LEFT_I = 500
			BSCHTKA.SV_ACC.UI_TOP_I = -150
        end,
        width = "full",
    })	
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		name = "显示尾王血量百分比提醒",
		getFunc = function() return BSCHTKA.SV_ACC.SHOW_UI_PERCENT end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.SHOW_UI_PERCENT = value
		end,
        --width = "half",
	})	
	table.insert(optionsTable, {
		type = "checkbox",
		name = "锁定尾王血量百分比提醒位置",
		getFunc = function() return BSCHTKA.SV_ACC.LOCK_UI_B end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.LOCK_UI_B = value
			BSCHTKAUIBossP:SetMovable(not BSCHTKA.SV_ACC.LOCK_UI_B)
		end,
        --width = "half",
	})
	table.insert(optionsTable, {
        type = "button",
        name = "重置尾王血量百分比提醒位置",
        func = function()
			BSCHTKAUIBossP:ClearAnchors()
			BSCHTKAUIBossP:SetAnchor(BOTTOM, GuiRoot, CENTER, 0, -165)
			BSCHTKA.SV_ACC.UI_LEFT_B = 0 
			BSCHTKA.SV_ACC.UI_TOP_B = -165
        end,
        width = "full",
    })	
end
	
local function AddYandirSetting()
	table.insert(optionsTable, {
        type = "header",
        name = "1. Boss (屠夫扬迪尔)",
    })
	AddTexture(optionsTable, 133559, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "查鲁斯图腾（毒图腾）弹窗提醒",
		getFunc = function() return BSCHTKA.SV_ACC.POISION_TOTEM end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.POISION_TOTEM = value
		end,
        width = "half",
	})		
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "查鲁斯图腾（毒图腾）弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_POISION_TOTEM) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_POISION_TOTEM={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 133549, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "石像鬼图腾弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.GARGYL_TOTEM end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.GARGYL_TOTEM = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "石像鬼图腾弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_GARGYL_TOTEM) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_GARGYL_TOTEM={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 70010, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "治疗弹窗",
		tooltip = "在HM模式下，每隔一段时间BOSS会治疗增援（即狮鹫和海蛇）",
		getFunc = function() return BSCHTKA.SV_ACC.HEALING_YANDIR end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.HEALING_YANDIR = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "治疗弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_HEALING_YANDIR) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_HEALING_YANDIR={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 132588, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "雷霆之跃弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.JUMP_YANDIR end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.JUMP_YANDIR = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "雷霆之跃弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_JUMP_YANDIR) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_JUMP_YANDIR={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 136678, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "海蛇强袭弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.SEA_ADDER_BILE_SPRAY end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.SEA_ADDER_BILE_SPRAY = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "海蛇强袭弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_SEA_ADDER_BILE) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_SEA_ADDER_BILE={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
end

local function AddVrolSetting()
	table.insert(optionsTable, {
        type = "header",
        name = "2. Boss (威若船长)",
    })
	AddTexture(optionsTable, 134016, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "传送门弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.PORTAL_CAST_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.PORTAL_CAST_VROL = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "传送门弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_PORTAL_CAST_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_PORTAL_CAST_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 134016, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "传送门倒计时（仅对于传送门玩家）",
		getFunc = function() return BSCHTKA.SV_ACC.PORTAL_KTIME_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.PORTAL_KTIME_VROL = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "传送门倒计时弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_PORTAL_KTIME_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_PORTAL_KTIME_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 134016, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "传送门位置图标",
		getFunc = function() return BSCHTKA.SV_ACC.PORTAL_ICON_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.PORTAL_ICON_VROL = value
			if value then 
				if BSCHTKA.bVrol then BSCHTKA.AddPortalIcon() end
			else 
				BSCHTKA.RemovePortalIcon() 
			end 
		end,
        width = "half",
	})	
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "传送门弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_PORTAL_CAST_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_PORTAL_CAST_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 140375, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "冰冷之雾弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.FOG_CAST_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.FOG_CAST_VROL = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "冰冷之雾弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_FOG_CAST_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_FOG_CAST_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 124468, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "电击鱼叉倒计时",
		getFunc = function() return BSCHTKA.SV_ACC.HARPOON_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.HARPOON_VROL = value
		end,
        width = "half",
	})	
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "电击鱼叉倒计时颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_HARPOON_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_HARPOON_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 140261, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "打断药剂师弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.APOTHECARY_VROL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.APOTHECARY_VROL = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "打断药剂师弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_APOTHECARY_VROL) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_APOTHECARY_VROL={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
end 

local function AddFalgravnSetting()
	table.insert(optionsTable, {
        type = "header",
        name = 'Trash & Boss',
    })
	AddTexture(optionsTable, 132570, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "鲜血喷涌格挡提醒",
		getFunc = function() return BSCHTKA.SV_ACC.BLOOD_FOUNTAIN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.BLOOD_FOUNTAIN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "鲜血喷涌格挡提醒颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_BLOOD_FOUNTAIN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_BLOOD_FOUNTAIN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	AddDivider(optionsTable)
	AddTexture(optionsTable, 137292, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "灌注提醒",
		getFunc = function() return BSCHTKA.SV_ACC.INFUSER_INFUSE end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.INFUSER_INFUSE = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "灌注弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_INFUSER_INFUSE) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_INFUSER_INFUSE={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	table.insert(optionsTable, {
        type = "header",
        name = '3. Boss "Mini" (齐格文中尉)',
    })
	AddTexture(optionsTable, 136988, "Lieutenant Njordal")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "桑吉恩之握（保持移动）",
		getFunc = function() return BSCHTKA.SV_ACC.M_MOVE_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.M_MOVE_FALGRAVN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "桑吉恩之握倒计时颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_M_MOVE_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_M_MOVE_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	AddDivider(optionsTable)
	AddTexture(optionsTable, 137499, "Lieutenant Njordal")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "鲜血狂怒 (格挡)",
		getFunc = function() return BSCHTKA.SV_ACC.M_BLOCK_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.M_BLOCK_FALGRAVN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "鲜血狂怒倒计时颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_M_BLOCK_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_M_BLOCK_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 136976, "Lieutenant Njordal")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "鲜血劈砍弹窗 (翻滚)",
		getFunc = function() return BSCHTKA.SV_ACC.M_DODGE_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.M_DODGE_FALGRAVN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "鲜血劈砍弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_M_DODGE_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_M_DODGE_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	--	
	table.insert(optionsTable, {
        type = "header",
        name = "3. Boss (法文格福领主)",
    })
	--AddTexture(optionsTable, 121272, "")
	--table.insert(optionsTable, {
	--	type = "checkbox",
	--	name = "90% 80% Countdown", 
	--	getFunc = function() return BSCHTKA.SV_ACC.CONNECT_TIME_FALGRAVN end,
	--	setFunc = function(value) 
	--		BSCHTKA.SV_ACC.CONNECT_TIME_FALGRAVN = value
	--	end,
    --    width = "half",
	--})
	table.insert(optionsTable, {
		type = "checkbox",
		name = "连点位置标点 (90% 80%时连电)",
		getFunc = function() return BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE = value
		end,
        --width = "half",
	})
	table.insert(optionsTable, {
		type = "slider",
		disabled = function() return not BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE end,
		name = "Ody位置图标大小",
		min = 0,
		max = 300,
		step = 1,
		default = 100,	
		getFunc = function() return BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_SIZE end,
		setFunc = function(value)
			BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_SIZE = value
			BSCHTKA.UpdateAllPosIconConn()
			BSCHTKA.UpdateAllTorturerIcons()
			BSCHTKA.UpdateAllPosIconBlood()
		end,
	})
	table.insert(optionsTable, {
		type = "dropdown",
		disabled = function() return not BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE end,
		name = "我的连电位置",
		tooltip = "1号位置紧靠墙壁，5号位置接近场地中心",
        choices = {"NONE", "Positon 1", "Positon 2", "Positon 3", "Positon 4", "Positon 5"},		
		getFunc = function()		
			if BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == -1 then
				return "NONE" 
			elseif BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == 1 then
				return "Positon 1"
			elseif BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == 2 then
				return "Positon 2"
			elseif BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == 3 then
				return "Positon 3"
			elseif BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == 4 then
				return "Positon 4"
			elseif BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS == 5 then
				return "Positon 5"
			else			
				return "NONE" 
			end
		end,
		setFunc = function(v) 
			if v == "NONE" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = -1 
			elseif v == "Positon 1" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = 1 
			elseif v == "Positon 2" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = 2 
			elseif v == "Positon 3" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = 3 
			elseif v == "Positon 4" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = 4
			elseif v == "Positon 5" then
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = 5 
			else
				BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_POS = -1 
			end	
			BSCHTKA.UpdatePosIcon()
		end,
        width = "full",
	})
	table.insert(optionsTable, {
		type = "checkbox",
		name = "显示所有的图标",
		disabled = function() return not BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE end,
		tooltip = "你选择的位置会变成绿色，其余位置图标为红色",
		getFunc = function() return BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE_ALL end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.TUT_ODYICON_POS_FALGRAVN_ENABLE_ALL = value
			BSCHTKA.UpdatePosIcon()
		end,
        --width = "half",
	})	
	AddDivider(optionsTable)	
	AddTexture(optionsTable, 135092, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "鲜血监狱死亡倒计时",
		getFunc = function() return BSCHTKA.SV_ACC.PRISON_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.PRISON_FALGRAVN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "鲜血监狱死亡倒计时颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_M_DODGE_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_M_DODGE_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 135092, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "在玩家头上添加血狱技能图标",
		getFunc = function() return BSCHTKA.SV_ACC.PRISON_ICON end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.PRISON_ICON = value
		end,
        width = "half",
	})
	AddDivider(optionsTable)
	AddTexture(optionsTable, 137963, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "尾王二阶段流血提醒（移动会受到伤害）",
		getFunc = function() return BSCHTKA.SV_ACC.OPEN_DOOR_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.OPEN_DOOR_FALGRAVN = value
		end,
        width = "half",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "尾王二阶段流血提醒颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_OPEN_DOOR_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_OPEN_DOOR_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})	
	AddDivider(optionsTable)
	AddTexture(optionsTable, 144159, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "处刑者提醒",
		getFunc = function() return BSCHTKA.SV_ACC.TUT_FEED_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.TUT_FEED_FALGRAVN = value
		end,
        width = "half",
	})	
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "处刑者提醒颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_TUT_FEED_FALGRAVN) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_TUT_FEED_FALGRAVN={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})		
	AddDivider(optionsTable)
	AddTexture(optionsTable, 140944, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "中电图标",
		getFunc = function() return BSCHTKA.SV_ACC.INSTABILITY_ICON end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.INSTABILITY_ICON = value
		end,
        width = "half",
	})	
	AddDivider(optionsTable)
	AddTexture(optionsTable, 129936, "")
	table.insert(optionsTable, {
		type = "checkbox",
		name = "诅咒协同图标（别吃 吃了扣血）",
		tooltip = "The player who did take the Blop Synergie..",
		getFunc = function() return BSCHTKA.SV_ACC.EXECRATION_ICON end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.EXECRATION_ICON = value
		end,
        width = "half",
	})	
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		name = "血球位置图标",
		getFunc = function() return BSCHTKA.SV_ACC.BB_ODYICON_POS_FALGRAVN_ENABLE end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.BB_ODYICON_POS_FALGRAVN_ENABLE = value
		end,
        --width = "half",
	})
	table.insert(optionsTable, {
		type = "slider",
		disabled = function() return not BSCHTKA.SV_ACC.BB_ODYICON_POS_FALGRAVN_ENABLE end,
		name = "血球图标大小",
		min = 0,
		max = 300,
		step = 1,
		default = 200,	
		getFunc = function() return BSCHTKA.SV_ACC.BB_ODYICON_FALGRAVN_SIZE end,
		setFunc = function(value)
			BSCHTKA.SV_ACC.BB_ODYICON_FALGRAVN_SIZE = value
			BSCHTKA.UpdateAllPosIconBlood()
		end,
	})
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		name = "处刑者图标",
		getFunc = function() return BSCHTKA.SV_ACC.TUT_ODYICON_FALGRAVN end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.TUT_ODYICON_FALGRAVN = value
		end,
        width = "full",
	})
	table.insert(optionsTable, {
		type = "slider",
		disabled = function() return not BSCHTKA.SV_ACC.TUT_ODYICON_FALGRAVN end,
		name = "处刑者图标尺寸",
		min = 0,
		max = 300,
		step = 1,
		default = 200,	
		getFunc = function() return BSCHTKA.SV_ACC.TUT_ODYICON_FALGRAVN_SIZE end,
		setFunc = function(value)
			BSCHTKA.SV_ACC.TUT_ODYICON_FALGRAVN_SIZE = value
			BSCHTKA.UpdateAllTorturerIcons()
		end,
	})	
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		name = "处刑者传送弹窗",
		getFunc = function() return BSCHTKA.SV_ACC.FALGRAVN_TORTURER_ESC end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.FALGRAVN_TORTURER_ESC = value
		end,
        width = "full",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "处刑者传送弹窗颜色",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_FALGRAVN_TORTURER_ESC) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_FALGRAVN_TORTURER_ESC={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})		
	AddDivider(optionsTable)
	table.insert(optionsTable, {
		type = "checkbox",
		name = "处刑者轻击弹窗（DPS & HEALER）",
		getFunc = function() return BSCHTKA.SV_ACC.FALGRAVN_TORTURER_LA end,
		setFunc = function(value) 
			BSCHTKA.SV_ACC.FALGRAVN_TORTURER_LA = value
		end,
        width = "full",
	})
	table.insert(optionsTable, {
		type = "colorpicker",
		name = "处刑者对你轻击弹窗",
		disabled = function() return not BSCHTKA.SV_ACC.USE_COLOR end,
		getFunc = function() return unpack(BSCHTKA.SV_ACC.C_FALGRAVN_TORTURER_LA) end,
		setFunc = function(r,g,b,a) 
			BSCHTKA.SV_ACC.C_FALGRAVN_TORTURER_LA={r,g,b,a} 
		end,
		width = "full",
		default = function() return {r=248/255,g=248/255,b=255/255} end, 
	})
end


function BSCHTKA:InitMenu()
	-- the panel for the addons menu
	local panelData = {
		type = "panel",
		name = BSCHTKA.NameMenu,
		displayName = BSCHTKA.NameSpaced,
		author = BSCHTKA.Author,
		version = BSCHTKA.VersionDisplay,
		registerForRefresh = true,
	}
	
	AddSendFeedBack()
	AddTestAlert()	
	AddYandirSetting()
	AddVrolSetting()
	AddFalgravnSetting()
	AddUISettings()
	
    local addonpanel = LibAddonMenu2:RegisterAddonPanel(BSCHTKA.NameSpaced, panelData)
    LibAddonMenu2:RegisterOptionControls(BSCHTKA.NameSpaced, optionsTable)
	
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(currentpanel) 
		if addonpanel == currentpanel then 
			BSCHTKAUIBossP:SetHidden(false) 
			BSCHTKAUIBossP:GetNamedChild("BossPercent"):SetText("Boss信息")
			BSCHTKAHelperInfoUI:SetHidden(false) 
			BSCHTKAHelperInfoUI:GetNamedChild("InfoTOP"):SetText("Boss 名称")
			BSCHTKAHelperInfoUI:GetNamedChild("Info1"):SetText("信息1")
			BSCHTKAHelperInfoUI:GetNamedChild("Info2"):SetText("信息2")
			BSCHTKAHelperInfoUI:GetNamedChild("Info3"):SetText("信息3")
			BSCHTKAHelperInfoUI:GetNamedChild("Info4"):SetText("信息4")
		end 
	end)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(currentpanel) 
		if addonpanel == currentpanel then  
			BSCHTKAUIBossP:SetHidden(true) 		
			BSCHTKAUIBossP:GetNamedChild("BossPercent"):SetText("")
			BSCHTKAHelperInfoUI:SetHidden(true)	
			BSCHTKAHelperInfoUI:GetNamedChild("InfoTOP"):SetText("")
			BSCHTKAHelperInfoUI:GetNamedChild("Info1"):SetText("")
			BSCHTKAHelperInfoUI:GetNamedChild("Info2"):SetText("")
			BSCHTKAHelperInfoUI:GetNamedChild("Info3"):SetText("")
			BSCHTKAHelperInfoUI:GetNamedChild("Info4"):SetText("")	
		end 
	end)
end
