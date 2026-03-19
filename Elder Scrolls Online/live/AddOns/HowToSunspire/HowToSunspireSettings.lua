HowToSunspire = HowToSunspire or {}

local HowToSunspire 						= HowToSunspire
local LAM 											= LibAddonMenu2
local WM 												= WINDOW_MANAGER
----------------------------------------------------------------------------------------------------------
---------------------------------------------[ 		PANEL    ]----------------------------------------------
----------------------------------------------------------------------------------------------------------
function HowToSunspire.CreateSettingsWindow()
  local panelData = {
    type 									= "panel",
    name 									= "HowToSunspire",
    displayName 					= "HowTo|cffbf00Sunspire|r",
    author 								= "Floliroy, @nogetrandom [PC EU]",
    version 							= HowToSunspire.version,
    slashCommand 					= "/HowToSunspire",
    registerForRefresh 		= true,
    registerForDefaults 	= true,
  }

  local cntrlOptionsPanel = LAM:RegisterAddonPanel("HowToSunspire_Settings", panelData)
  local Unlock = {
    Alerts 					= false,

    HA 							= false,
    Block 					= false,
    Leap 						= false,
    Shield 					= false,
    Comet 					= false,
    MeteorNames     = false,
    Spit 						= false,
    Geyser 					= false,
    -- Flare 					= false,
    Breath 					= false,
    SweepBreath 		= false,
    Thrash 					= false,
    SoulTear 				= false,
    PowerfulSlam 		= false,
    -- HailOfStone 		= false,
    Negate 					= false,
    GlacialFist			= false,
    Stonefist				= false,
    ------------------------
    Timers 					= false,

    IceTomb 				= false,
    LaserLokke 			= false,
    HP		 					= false,
    Landing					= false,
    Atro 						= false,
    Cata 						= false,
    NextFlare 			= false,
    Storm 					= false,
    Portal 					= false,
    Wipe 						= false,
    NextMeteor 			= false,
  }

  local sV = HowToSunspire.savedVariables
  local optionsData = {
    {
      type = "description",
      --text = "Trial timers, alerts and indicators for Dreadsail Reef.",
      text = "太阳尖顶机制的计时器，警报和指示器.汉化：@Pr4gMat1c, 来自公会OneNOnly(PC-NA)",
    },{
      type = "divider",
    },
    {	type = "header",      name = "用户界面",
    },
    { type = "checkbox",    name = "机制音效",
      tooltip = "启用机制音效提醒",
      getFunc = function() return sV.Enable.Sound end,
      setFunc = function(newValue)
        sV.Enable.Sound = newValue
      end,
    },
    {	type = "header",      name = "提醒位置与大小设置",
    },
    { type = "submenu",     name = "即时提醒",
      controls = {
        {	type = "description",
          text = "需要立刻做出反应的即时机制提醒，解锁后设置各项的位置",
        },
        {	type = "checkbox",    name = "解锁全部即时提醒",
          tooltip = "设置全部即时提醒的位置",
          default = false,
          getFunc = function() return Unlock.Alerts end,
          setFunc = function(newValue)
            Unlock.Alerts = newValue

            Unlock.HA = newValue
            Hts_Ha:SetHidden(not newValue)
            Unlock.Block = newValue
            Hts_Block:SetHidden(not newValue)
            Unlock.Leap = newValue
            Hts_Leap:SetHidden(not newValue)
            Unlock.Shield = newValue
            Hts_Shield:SetHidden(not newValue)
            Unlock.Comet = newValue
            Hts_Comet:SetHidden(not newValue)
            Unlock.MeteorNames = newValue
            Hts_MeteorNames:SetHidden(not newValue)
            Unlock.Spit = newValue
            Hts_GlacialFist:SetHidden(not newValue)
            Unlock.GlacialFist = newValue
            Hts_Stonefist:SetHidden(not newValue)
            Unlock.Stonefist = newValue
            Hts_Spit:SetHidden(not newValue)
            Unlock.Geyser = newValue
            Hts_Geyser:SetHidden(not newValue)
            -- Unlock.Flare = newValue
            -- Hts_Flare:SetHidden(not newValue)
            Unlock.Breath = newValue
            Hts_Breath:SetHidden(not newValue)
            Unlock.SweepBreath = newValue
            Hts_Sweep:SetHidden(not newValue)
            Unlock.Thrash = newValue
            Hts_Thrash:SetHidden(not newValue)
            Unlock.SoulTear = newValue
            Hts_SoulTear:SetHidden(not newValue)
            Unlock.PowerfulSlam = newValue
            Hts_PowerfulSlam:SetHidden(not newValue)
            -- Unlock.HailOfStone = newValue
            -- Hts_HailOfStone:SetHidden(not newValue)
            Unlock.Negate = newValue
            Hts_Negate:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "slider",      name = "提醒大小",
          tooltip = "设置全部即时提醒的大小",
          getFunc = function() return sV.AlertSize end,
          setFunc = function(newValue)
            sV.AlertSize = newValue
            HowToSunspire.SetFontSize(Hts_Ha_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Block_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Leap_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Shield_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Comet_Label, newValue)
            HowToSunspire.SetMeteorNameSize()
            HowToSunspire.SetFontSize(Hts_Spit_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Geyser_Label, newValue)
            -- HowToSunspire.SetFontSize(Hts_Flare_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Breath_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Sweep_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Thrash_Label, newValue)
            HowToSunspire.SetFontSize(Hts_SoulTear_Label, newValue)
            HowToSunspire.SetFontSize(Hts_PowerfulSlam_Label, newValue)
            -- HowToSunspire.SetFontSize(Hts_HailOfStone_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Negate_Label, newValue)
            HowToSunspire.SetFontSize(Hts_GlacialFist_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Stonefist_Label, newValue)
          end,
          min = 24,
          max = 56,
          step = 2,
          default = 40,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "checkbox",    name = "重击",
          tooltip = "设置各种敌人重击提醒的位置",
          default = false,
          getFunc = function() return Unlock.HA end,
          setFunc = function(newValue)
            Unlock.HA = newValue
            Hts_Ha:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "粉碎",
          tooltip = "设置乔德的火焰獠牙释放粉碎时，格挡提醒的位置",
          default = false,
          getFunc = function() return Unlock.Block end,
          setFunc = function(newValue)
            Unlock.Block = newValue
            Hts_Block:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "奋力强袭",
          tooltip = "设置警戒雕像释放奋力强袭时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.PowerfulSlam end,
          setFunc = function(newValue)
            Unlock.PowerfulSlam = newValue
            Hts_PowerfulSlam:SetHidden(not newValue)
          end,
          width = "half",
        },

        -- {	type = "checkbox",
        --   name = "Vigil Statue's Hail of Stones",
        --   tooltip = "Adjust the position of the Hail of Stones text.",
        --   default = false,
        --   getFunc = function() return Unlock.HailOfStone end,
        --   setFunc = function(newValue)
        --     Unlock.HailOfStone = newValue
        --     Hts_HailOfStone:SetHidden(not newValue)
        --   end,
        --   width = "half",
        -- },

        {	type = "checkbox",    name = "冰川之拳",
          tooltip = "设置寒霜侍灵释放冰川之拳时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.GlacialFist end,
          setFunc = function(newValue)
            Unlock.Fist = newValue
            Hts_GlacialFist:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "岩石之拳",
          tooltip = "设置警戒雕像释放岩石之拳时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Stonefist end,
          setFunc = function(newValue)
            Unlock.Fist = newValue
            Hts_Stonefist:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "风暴之跃",
          tooltip = "设置艾尔克许的意志释放风暴之跃时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Leap end,
          setFunc = function(newValue)
            Unlock.Leap = newValue
            Hts_Leap:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "彗星/流星",
          tooltip = "设置彗星和流星机制出现时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Comet end,
          setFunc = function(newValue)
            Unlock.Comet = newValue
            Hts_Comet:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "熔火流星目标",
          tooltip = "设置成为熔火流星目标的玩家ID显示位置",
          default = false,
          getFunc = function() return Unlock.MeteorNames end,
          setFunc = function(newValue)
            Unlock.MeteorNames = newValue
            Hts_MeteorNames:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "盾牌冲锋",
          tooltip = "设置艾尔克许遗迹对你释放盾牌冲锋时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Shield end,
          setFunc = function(newValue)
            Unlock.Shield = newValue
            Hts_Shield:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "火焰迸射",
          tooltip = "设置你成为火焰迸射目标时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Spit end,
          setFunc = function(newValue)
            Unlock.Spit = newValue
            Hts_Spit:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "熔岩喷涌",
          tooltip = "设置熔岩喷涌在你脚下生成时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Geyser end,
          setFunc = function(newValue)
            Unlock.Geyser = newValue
            Hts_Geyser:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "吐息",
          tooltip = "设置你成为洛克提兹、尤尔纳克林或纳温塔丝的吐息对象时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Breath end,
          setFunc = function(newValue)
            Unlock.Breath = newValue
            Hts_Breath:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "扫掠吐息",
          tooltip = "设置纳温塔丝释放扫掠吐息时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.SweepBreath end,
          setFunc = function(newValue)
            Unlock.SweepBreath = newValue
            Hts_Sweep:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "鞭笞",
          tooltip = "设置纳温塔丝释放鞭笞时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Thrash end,
          setFunc = function(newValue)
            Unlock.Thrash = newValue
            Hts_Thrash:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "灵魂撕裂",
          tooltip = "设置纳温塔丝释放灵魂撕裂时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.SoulTear end,
          setFunc = function(newValue)
            Unlock.SoulTear = newValue
            Hts_SoulTear:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "反魔法力场",
          tooltip = "设置永恒仆从对你释放反魔法力场时，提醒的位置",
          default = false,
          getFunc = function() return Unlock.Negate end,
          setFunc = function(newValue)
            Unlock.Negate = newValue
            Hts_Negate:SetHidden(not newValue)
          end,
          width = "half",
        },

        -- {	type = "checkbox",
        --   name = "Flare",
        --   tooltip = "Adjust the position of fire atro light attack alert.",
        --   default = false,
        --   getFunc = function() return Unlock.Flare end,
        --   setFunc = function(newValue)
        --     Unlock.Flare = newValue
        --     Hts_Flare:SetHidden(not newValue)
        --   end,
        --   width = "half",
        -- },

      },
    },
    { type = "submenu",     name = "计时监控",
      controls = {
        {	type = "description",
          text = "定时机制与目标数值机制监控，解锁后设置各项的位置",
        },
        {	type = "checkbox",    name = "解锁全部计时监控",
          tooltip = "设置全部计时监控的位置",
          default = false,
          getFunc = function() return Unlock.Timers end,
          setFunc = function(newValue)
            Unlock.Timers = newValue

            Unlock.IceTomb = newValue
            Hts_Ice:SetHidden(not newValue)
            Unlock.LaserLokke = newValue
            Hts_Laser:SetHidden(not newValue)
            Unlock.HP = newValue
            Hts_HP:SetHidden(not newValue)
            Unlock.Landing = newValue
            Hts_Landing:SetHidden(not newValue)
            Unlock.Atro = newValue
            Hts_Atro:SetHidden(not newValue)
            Unlock.Cata = newValue
            Hts_Cata:SetHidden(not newValue)
            Unlock.NextFlare = newValue
            Hts_NextFlare:SetHidden(not newValue)
            Unlock.Storm = newValue
            Hts_Storm:SetHidden(not newValue)
            Unlock.Portal = newValue
            Hts_Portal:SetHidden(not newValue)
            Unlock.Wipe = newValue
            Hts_Wipe:SetHidden(not newValue)
            Unlock.NextMeteor = newValue
            Hts_NextMeteor:SetHidden(not newValue)

          end,
          width = "half",
        },
        {	type = "slider",      name = "监控大小",
          tooltip = "设置全部计时监控的大小",
          getFunc = function() return sV.TimerSize end,
          setFunc = function(newValue)
            sV.TimerSize = newValue
            HowToSunspire.SetIceSize()
            HowToSunspire.SetFontSize(Hts_Laser_Label, newValue)
            HowToSunspire.SetFontSize(Hts_HP_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Landing_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Atro_Label, newValue)
            HowToSunspire.SetFontSize(Hts_NextFlare_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Cata_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Portal_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Wipe_Label, newValue)
            HowToSunspire.SetFontSize(Hts_Storm_Label, newValue)
            HowToSunspire.SetFontSize(Hts_NextMeteor_Label, newValue)
          end,
          min = 24,
          max = 56,
          step = 2,
          default = 40,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "checkbox",    name = "Boss生命值监控",
          tooltip = "设置Boss起飞前，生命值监控的位置",
          default = false,
          getFunc = function() return Unlock.HP end,
          setFunc = function(newValue)
            Unlock.HP = newValue
            Hts_HP:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "Boss落地监控",
          tooltip = "设置Boss落地前，监控的位置",
          default = false,
          getFunc = function() return Unlock.Landing end,
          setFunc = function(newValue)
            Unlock.Landing = newValue
            Hts_Landing:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "冰冻墓穴",
          tooltip = "设置冰冻墓穴刷新后，监控的位置",
          default = false,
          getFunc = function() return Unlock.IceTomb end,
          setFunc = function(newValue)
            Unlock.IceTomb = newValue
            Hts_Ice:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "风暴之怒",
          tooltip = "设置洛克提兹释放风暴之怒前，监控的位置",
          default = false,
          getFunc = function() return Unlock.LaserLokke end,
          setFunc = function(newValue)
            Unlock.LaserLokke = newValue
            Hts_Laser:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "余烬风暴",
          tooltip = "设置尤尔纳克林释放余烬风暴召唤火焰侍灵时，监控的位置",
          default = false,
          getFunc = function() return Unlock.Atro end,
          setFunc = function(newValue)
            Unlock.Atro = newValue
            Hts_Atro:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "灾变",
          tooltip = "设置灾变结束前，监控的位置",
          default = false,
          getFunc = function() return Unlock.Cata end,
          setFunc = function(newValue)
            Unlock.Cata = newValue
            Hts_Cata:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "专注之火",
          tooltip = "设置尤尔纳克林释放专注之火前，监控的位置",
          default = false,
          getFunc = function() return Unlock.NextFlare end,
          setFunc = function(newValue)
            Unlock.NextFlare = newValue
            Hts_NextFlare:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "火焰风暴",
          tooltip = "设置纳温塔丝释放火焰风暴时，监控的位置",
          default = false,
          getFunc = function() return Unlock.Storm end,
          setFunc = function(newValue)
            Unlock.Storm = newValue
            Hts_Storm:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "传送门监控",
          tooltip = "设置与传送门相关监控的位置\n|cff0000注意|r: 包括时间迁移、翻译启示录及震荡闪电",
          default = false,
          getFunc = function() return Unlock.Portal end,
          setFunc = function(newValue)
            Unlock.Portal = newValue
            Hts_Portal:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "团灭监控",
          tooltip = "设置击杀永恒仆从监控倒计时的位置",
          default = false,
          getFunc = function() return Unlock.Wipe end,
          setFunc = function(newValue)
            Unlock.Wipe = newValue
            Hts_Wipe:SetHidden(not newValue)
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "熔火流星",
          tooltip = "设置纳温塔丝释放熔火流星的监控位置",
          default = false,
          getFunc = function() return Unlock.NextMeteor end,
          setFunc = function(newValue)
            Unlock.NextMeteor = newValue
            Hts_NextMeteor:SetHidden(not newValue)
          end,
          width = "half",
        },
      },
    },
    {	type = "description", text = "设置所需机制提醒",
    },
    {	type = "submenu",     name = "通用",
      controls = {
        {	type = "description",
          text = "各种小怪的机制提醒",
        },
        {	type = "checkbox",
          name = "重击提醒",
          tooltip = "所有怪物的重击提醒，包括Boss与永恒仆从",
          default = true,
          getFunc = function() return sV.Enable.HA end,
          setFunc = function(newValue)
            sV.Enable.HA = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "粉碎",
          tooltip = "乔德的火焰獠牙释放粉碎时提醒格挡",
          default = true,
          getFunc = function() return sV.Enable.Block end,
          setFunc = function(newValue)
            sV.Enable.Block = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "风暴之跃",
          tooltip = "艾尔克许的意志释放风暴之跃时提醒",
          default = true,
          getFunc = function() return sV.Enable.Leap end,
          setFunc = function(newValue)
            sV.Enable.Leap = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "盾牌冲锋",
          tooltip = "艾尔克许遗迹对你释放盾牌冲锋时提醒",
          default = true,
          getFunc = function() return sV.Enable.Shield end,
          setFunc = function(newValue)
            sV.Enable.Shield = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "彗星/流星",
          tooltip = "彗星和流星机制出现时提醒，包括霜冻彗星与熔火流星",
          default = true,
          getFunc = function() return sV.Enable.Comet end,
          setFunc = function(newValue)
            sV.Enable.Comet = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "火焰迸射",
          tooltip = "你成为火焰迸射的目标时提醒，该机制会在你脚下缓慢生成一个AOE，随后爆炸并生成一个火焰侍灵\n|cff0000注意:|r 洛克提兹和纳温塔丝Boss战中建议开启此项",
          default = true,
          getFunc = function() return sV.Enable.Spit end,
          setFunc = function(newValue)
            sV.Enable.Spit = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "熔岩喷涌",
          tooltip = "熔岩喷涌在你脚下生成时提醒\n|cff0000注意:|r 建议全程开启此项",
          default = true,
          getFunc = function() return sV.Enable.Geyser end,
          setFunc = function(newValue)
            sV.Enable.Geyser = newValue
          end,
          width = "half",
        },
      },
    },
    { type = "submenu",	    name = "Boss战通用",
      controls = {
        {	type = "checkbox",
          name = "吐息",
          tooltip = "当你成为洛克提兹、尤尔纳克林或纳温塔丝的吐息对象时提醒",
          default = true,
          getFunc = function() return sV.Enable.Breath end,
          setFunc = function(newValue)
            sV.Enable.Breath = newValue
          end,
          width = "full",
        },
        { type = "divider",
        },
        {	type = "description",
          text = "由于Boss动画的问题，落地监控可能略有误差\n后续尝试改进",
        },
        { type = "divider",
        },
        {	type = "checkbox",
          name = "洛克提兹生命值监控",
          tooltip = "洛克提兹起飞前显示生命值监控，用于时间预估",
          default = true,
          getFunc = function() return sV.Enable.hpLokke end,
          setFunc = function(newValue)
            sV.Enable.hpLokke = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "洛克提兹落地监控",
          tooltip = "显示洛克提兹落地监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.landingLokke end,
          setFunc = function(newValue)
            sV.Enable.landingLokke = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "尤尔纳克林生命值监控",
          tooltip = "尤尔纳克林起飞前显示生命值监控，用于时间预估",
          default = true,
          getFunc = function() return sV.Enable.hpYolna end,
          setFunc = function(newValue)
            sV.Enable.hpYolna = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "尤尔纳克林落地监控",
          tooltip = "显示尤尔纳克林落地监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.landingYolna end,
          setFunc = function(newValue)
            sV.Enable.landingYolna = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "纳温塔丝生命值监控",
          tooltip = "纳温塔丝起飞前显示生命值监控，用于时间预估",
          default = true,
          getFunc = function() return sV.Enable.hpNahvii end,
          setFunc = function(newValue)
            sV.Enable.hpNahvii = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "纳温塔丝落地监控",
          tooltip = "显示纳温塔丝落地监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.landingNahvii end,
          setFunc = function(newValue)
            sV.Enable.landingNahvii = newValue
          end,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "slider",
          name = "生命值监控百分比",
          tooltip = "Boss起飞前生命值剩余 %时显示监控",
          getFunc = function() return sV.hpShowPercent end,
          setFunc = function(newValue)
            sV.hpShowPercent = newValue
          end,
          min = 2,
          max = 10,
          step = 1,
          default = 5,
          width = "half",
        },
        {	type = "slider",
          name = "落地监控时间",
          tooltip = "Boss落地前 秒时显示监控",
          getFunc = function() return sV.timeBeforeLanding end,
          setFunc = function(newValue)
            sV.timeBeforeLanding = newValue
          end,
          min = 2,
          max = 10,
          step = 1,
          default = 5,
          width = "half",
        },
        -- {	type = "checkbox",
        -- 	name = "Show HP% left until Flying",
        -- 	tooltip = "On = display % left until flying.\nOff = display active % of boss HP.",
        -- 	default = true,
        -- 	getFunc = function() return sV.Enable.PercentToFly end,
        -- 	setFunc = function(newValue)
        --     sV.Enable.PercentToFly = newValue
        --   end,
        --   width = "half",
        -- },
      },
    },
    {	type = "submenu",     name = "洛克提兹选项",
      controls = {
        { type = "divider",
        },
        {	type = "checkbox",
          name = "冰冻墓穴",
          tooltip = "显示冰冻墓穴刷新提醒与进入监控",
          default = true,
          getFunc = function() return sV.Enable.IceTomb end,
          setFunc = function(newValue)
            sV.Enable.IceTomb = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "风暴之怒",
          tooltip = "显示洛克提兹释放风暴之怒监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.LaserLokke end,
          setFunc = function(newValue)
            sV.Enable.LaserLokke = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "冰川之拳",
          tooltip = "显示寒霜侍灵释放冰川之拳监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.GlacialFist end,
          setFunc = function(newValue)
            sV.Enable.GlacialFist = newValue
          end,
          width = "half",
        },
      },
    },
    { type = "submenu",     name = "尤尔纳克林选项",
      controls = {
        { type = "divider",
        },
        {	type = "checkbox",
          name = "余烬风暴",
          tooltip = "尤尔纳克林释放余烬风暴召唤火焰侍灵时提醒",
          default = true,
          getFunc = function() return sV.Enable.Atro end,
          setFunc = function(newValue)
            sV.Enable.Atro = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "专注之火",
          tooltip = "显示尤尔纳克林释放专注之火监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.NextFlare end,
          setFunc = function(newValue)
            sV.Enable.NextFlare = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "灾变",
          tooltip = "显示灾变结束监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.Cata end,
          setFunc = function(newValue)
            sV.Enable.Cata = newValue
          end,
          width = "half",
        },
        -- {	type = "checkbox",
        -- 	name = "Flame Atronarch Aggro",
        -- 	tooltip = "Alerts you when you are the target of a Flame Atronarch's attacks.\n|cff0000Note:|r This alert will only activate on Veteran Hard Mode and is meant to alert dd's using Simmering Frenzy of incoming attacks.",
        -- 	default = true,
        -- 	getFunc = function() return sV.Enable.Flare end,
        -- 	setFunc = function(newValue)
        --   		sV.Enable.Flare = newValue
        --   	end,
        --   	width = "half",
        -- },
      },
    },
    {	type = "submenu",     name = "纳温塔丝选项",
      controls = {
        { type = "divider",
        },
        {	type = "checkbox",    name = "扫掠吐息",
          tooltip = "纳温塔丝释放扫掠吐息时提醒，并显示其方向",
          default = true,
          getFunc = function() return sV.Enable.SweepBreath end,
          setFunc = function(newValue)
            sV.Enable.SweepBreath = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "鞭笞",
          tooltip = "纳温塔丝释放鞭笞时提醒",
          default = true,
          getFunc = function() return sV.Enable.Thrash end,
          setFunc = function(newValue)
            sV.Enable.Thrash = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "灵魂撕裂",
          tooltip = "纳温塔丝释放灵魂撕裂时提醒",
          default = true,
          getFunc = function() return sV.Enable.SoulTear end,
          setFunc = function(newValue)
            sV.Enable.SoulTear = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "熔火流星",
          tooltip = "显示纳温塔丝释放熔火流星监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.NextMeteor end,
          setFunc = function(newValue)
            sV.Enable.NextMeteor = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "奋力强袭",
          tooltip = "警戒雕像对你释放奋力强袭时提醒",
          default = true,
          getFunc = function() return sV.Enable.PowerfulSlam end,
          setFunc = function(newValue)
            sV.Enable.PowerfulSlam = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "落石术",
          tooltip = "警戒雕像引导落石术时提醒",
          default = true,
          getFunc = function() return sV.Enable.HailOfStone end,
          setFunc = function(newValue)
            sV.Enable.HailOfStone = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "岩石之拳",
          tooltip = "警戒雕像对你释放岩石之拳时提醒",
          default = true,
          getFunc = function() return sV.Enable.Stonefist end,
          setFunc = function(newValue)
            sV.Enable.Stonefist = newValue
          end,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "description", text = "HM难度下的斩杀阶段，显示带有方向指示的熔火流星排布提醒，防止伤害重叠\n方向指示以你面对Boss、背对入口为准",
        },
        {	type = "checkbox",    name = "熔火流星目标",
          tooltip = "显示成为熔火流星目标的玩家ID(只显示DPS的ID)",
          default = true,
          getFunc = function() return sV.Enable.MeteorNames end,
          setFunc = function(newValue)
            sV.Enable.MeteorNames = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "熔火流星目标(仅自己)",
          tooltip = "仅在你成为熔火流星目标时显示ID",
          default = true,
          getFunc = function() return sV.MeteorSelfOnly end,
          setFunc = function(newValue)
            sV.MeteorSelfOnly = newValue
          end,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "checkbox",    name = "火焰风暴",
          tooltip = "显示纳温塔丝释放火焰风暴监控倒计时\n如果启用了数据共享，传送门中的玩家也可看到火焰风暴监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.Storm end,
          setFunc = function(newValue)
            sV.Enable.Storm = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",    name = "数据共享",
          tooltip = "启用数据共享，为传送门队伍提供火焰风暴监控数据",
          default = false,
          getFunc = function() return sV.Enable.Sending end,
          setFunc = function(newValue)
            sV.Enable.Sending = newValue
          end,
          warning = "|cff0000注意:|r 仅需一个非传送门玩家开启即可\n建议开启",
          disabled = function()
            if LibGPS3 and LibMapPing then
              return false --not disabled
            else
              return true --disabled
            end
          end,
          width = "half",
        },
        { type = "header",      name = "传送门选项",
        },
        {	type = "description", text = "纳温塔丝Boss战中所有与传送门相关的机制",
        },
        { type = "divider",
        },
        {	type = "checkbox",
          name = "时间迁移",
          tooltip = "显示时间迁移提醒与结束时间监控",
          default = true,
          getFunc = function() return sV.Enable.Portal end,
          setFunc = function(newValue)
            sV.Enable.Portal = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "翻译启示录",
          tooltip = "显示永恒仆从释放翻译启示录的打断监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.Interrupt end,
          setFunc = function(newValue)
            sV.Enable.Interrupt = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "震荡闪电",
          tooltip = "显示永恒仆从释放震荡闪电监控倒计时",
          default = true,
          getFunc = function() return sV.Enable.Pins end,
          setFunc = function(newValue)
            sV.Enable.Pins = newValue
          end,
          width = "half",
        },
        {	type = "checkbox",
          name = "反魔法力场",
          tooltip = "永恒仆从对你释放反魔法力场时提醒",
          default = true,
          getFunc = function() return sV.Enable.Negate end,
          setFunc = function(newValue)
            sV.Enable.Negate = newValue
          end,
          width = "half",
        },
        { type = "divider",
        },
        {	type = "checkbox",
          name = "团灭监控",
          tooltip = "显示击杀永恒仆从监控倒计时,倒计时结束团灭",
          default = true,
          getFunc = function() return sV.Enable.Wipe end,
          setFunc = function(newValue)
            sV.Enable.Wipe = newValue
          end,
          width = "half",
        },
        {	type = "slider",
          name = "团灭监控时间",
          tooltip = "团灭前 秒时显示监控",
          getFunc = function() return sV.wipeCallLater end,
          setFunc = function(newValue)
            sV.wipeCallLater = newValue
          end,
          min = 10,
          max = 90,
          step = 1,
          default = 90,
          width = "half",
        },
      },
    },
  }

  LAM:RegisterOptionControls("HowToSunspire_Settings", optionsData)
end
