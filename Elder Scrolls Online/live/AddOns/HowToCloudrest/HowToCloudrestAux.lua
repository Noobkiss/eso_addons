HowToCloudrest = HowToCloudrest or {}
HTC_AUX = {}
local HowToCloudrest = HowToCloudrest
----------------------------------------------------------
--                  Auxilliary functions                --
----------------------------------------------------------
-- Takes a deep copy of a lua table
function HTC_AUX:DeepCopy(obj, seen)
    -- credit: https://gist.github.com/tylerneylon/81333721109155b2d244
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[HTC_AUX:DeepCopy(k, s)] = HTC_AUX:DeepCopy(v, s) end
    return res
end

function HTC_AUX:FadeInControl(control, duration)
  local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA, control)
  control:SetAlpha(0)
  control:SetHidden(false)
  animation:SetAlphaValues(0, 1)
  animation:SetDuration(duration or 1000)
  timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)
  timeline:PlayFromStart()
end
----------------------------------------------------------
--                      Colors                          --
----------------------------------------------------------
HowToCloudrest.Color = {
    green = function (stringToColor) return "|c00ff00".. stringToColor .. "|r" end,
    yellow = function (stringToColor) return "|cffff00".. stringToColor .. "|r" end,
    red = function (stringToColor) return "|cff0000".. stringToColor .. "|r" end,
    white = function (stringToColor) return "|cffffff".. stringToColor .. "|r" end,

    heavyAttack = function (stringToColor) return "|cff1493".. stringToColor .. "|r" end,

    siroLight = function (stringToColor) return "|cff4500".. stringToColor .. "|r" end,
    releLight = function (stringToColor) return "|c33ccff".. stringToColor .. "|r" end,

    releDark = function (stringToColor) return "|cff3f3f".. stringToColor .. "|r" end,

    galeLight = function (stringToColor) return "|c66EFEF" .. stringToColor .. "|r" end,
    galeDark = function (stringToColor) return "|c3269df".. stringToColor .. "|r" end,

    portalClosed = function (stringToColor) return "|c7e7aff".. stringToColor .. "|r" end,
    portalOpen = function (stringToColor) return "|c4b4999".. stringToColor .. "|r" end,
    portalOne = function (stringToColor) return "|cff4500".. stringToColor .. "|r" end,
    portalTwo = function (stringToColor) return "|c3269df".. stringToColor .. "|r" end,

    zmajaDark = function (stringToColor) return "|cff00ff".. stringToColor .. "|r" end,
    orbs = function (stringToColor) return "|cB439A3".. stringToColor .. "|r" end,

    creeper = function (stringToColor) return "|c2D9239".. stringToColor .. "|r" end,
}

local Color = HowToCloudrest.Color
----------------------------------------------------------
--                      Strings                         --
----------------------------------------------------------
HowToCloudrest.Strings = {
    -- General
    RazorThorns = Color.zmajaDark(">>快翻滚<<"),
    DarkTalons = Color.siroLight(">>快翻滚<<"),

    Mini_Jump_Off_Cooldown = Color.yellow("战斗中"),
    Mini_Jump_Cast = Color.red("现在"),

    Mini_Bash_Off_Cooldown = Color.yellow("战斗中"),
    Mini_Bash_Cast = Color.red("打断"),
    Mini_Bash_Faded = Color.green("完成"),

    Mini_Skill_Off_Cooldown = Color.yellow("战斗中"),
    Mini_Skill_Cast = Color.red("现在"),

    Mini_Dead = Color.green("死亡"),

    -- Siroria
    Flare = Color.siroLight("        去和 ") .. Color.white("@Floliroy") .. Color.siroLight("叠火: "),
    FlareFunc = function (name) return Color.siroLight("        去和 ") .. Color.white(name)  .. Color.siroLight("叠火: ") end,
    FlareExecFunc = function (name1, name2, timer) 
        return Color.white(name1) .. Color.siroLight("|t100%:100%:Esoui/Art/Buttons/large_leftarrow_up.dds|t Flare: ") .. Color.red(timer) 
            .. Color.siroLight("|t100%:100%:Esoui/Art/Buttons/large_rightarrow_up.dds|t") .. Color.white(name2)
    end,

    -- Relequen
    Announcement_ReleBash_Faded = Color.releLight("OK"),
    Announcement_ReleBash_1 = Color.releLight("打断"),
    Announcement_ReleBash_2 = Color.red(">") .. Color.releLight("打断") .. Color.red("<"),
    Announcement_ReleBash_3 = Color.red(">>") .. Color.releLight("打断") .. Color.red("<<"),
    Announcement_ReleBash_4 = Color.red(">>>") .. Color.releLight("打断") .. Color.red("<<<"), -- never gets used

    Overload_Incoming = Color.releLight("电点名!切到副手: "),
    Overload_Static = Color.releDark("不要切手: "),
    Overload_Tab1 = Color.releLight("不要 ") .. Color.releDark("切手    : "),
    Overload_Tab2 = Color.releDark("   不要 ") .. Color.releLight("切手 : "),

    ReleHA = Color.releLight("粉碎: "),

    -- Galenwe
    Announcement_GaleBash_Faded = Color.galeDark("完成"),
    Announcement_GaleBash_1 = Color.galeDark("打断"),
    Announcement_GaleBash_2 = Color.red(">") .. Color.galeDark("打断") .. Color.red("<"),
    Announcement_GaleBash_3 = Color.red(">>") .. Color.galeDark("打断") .. Color.red("<<"),
    Announcement_GaleBash_4 = Color.red(">>>") .. Color.galeDark("打断") .. Color.red("<<<"),
    Announcement_GaleBash_5 = Color.yellow(">>>") .. Color.galeDark("打断") .. Color.yellow("<<<"),
    Announcement_GaleBash_6 = Color.red(">>>") .. Color.galeDark("打断") .. Color.red("<<<"),

    Hoarfrost_Base = Color.galeDark("冰风: "),
    Hoarfrost_Base_Last = Color.galeDark("上次 ") .. Color.green("丢") .. Color.galeDark(" 冰: "),
    Hoarfrost_Pick_Up = Color.galeDark("快捡冰!"),
    Hoarfrost_Incoming = Color.galeDark("冰 ") .. Color.red("战斗中"),
    Hoarfrost_Drop = Color.galeDark("快 ") .. Color.red("丢冰!"),
    Hoarfrost_Drop_Last = Color.galeDark("现在 ") .. Color.green("快") .. Color.galeDark(" 丢 ") .. Color.red("冰!"),

    ChillingComet_Base = Color.galeDark("彗星: "),

    -- Portal
    Portal_Open_Cast_1 = Color.portalOpen("传送门 "),
    Portal_Open_Cast_2 = Color.portalOpen(" 开了!"),
    Portal_Open_1 = Color.portalOpen("传送门 "),
    Portal_Open_2 = Color.portalOpen(" 关闭: "),
    Portal_Off_Cooldown = Color.yellow("马上"),
    Portal_Closed_Cast = Color.green("下地成功!"),
    Portal_Closed_1 = Color.portalClosed("下次出现传送门 ("),
    Portal_Closed_2 = Color.portalClosed("): "),
    Portal_Out_Of_Time = Color.red("下地失败"),

    Portal_Announcement_1 = Color.portalOpen("传送门 "),
    Portal_Announcement_2 = Color.portalOpen(" 开了!"),

    -- Z'Maja
    ZMaja_Jump_Base = Color.zmajaDark("Z'Maja下次传送: "),
    ZMaja_Jump_Off_Cooldown = Color.yellow("战斗中"),
    ZMaja_Jump_Cast = Color.red("现在"),

    ZMaja_Bash_Cast_1 = Color.red(">") .. Color.zmajaDark("打断") .. Color.red("<"),
    ZMaja_Bash_Cast_2 = Color.red(">>") .. Color.zmajaDark("打断") .. Color.red("<<"),
    ZMaja_Bash_Cast_3 = Color.red(">>>") .. Color.zmajaDark("打断") .. Color.red("<<<"),
    ZMaja_Bash_Cast_4 = Color.yellow(">>>") .. Color.zmajaDark("打断") .. Color.yellow("<<<"),
    ZMaja_Bash_Faded = Color.zmajaDark("OK"),

    ZMaja_BanefulMark_Base = Color.zmajaDark("有害标记: "),
    ZMaja_BanefulMark_Off_Cooldown = Color.yellow("战斗中"),
    ZMaja_BanefulMark_Cast = Color.red("现在!"),

    ZMaja_CrushingDarkness_Kite_Base = Color.zmajaDark("黑圈kite: "),
    ZMaja_CrushingDarkness_Kite_Cast = Color.red("现在"),
    ZMaja_CrushingDarkness_Kite_Faded = Color.green("结束!"),

    ZMaja_CrushingDarkness_Next_Base = Color.zmajaDark("下次黑圈kite时间: "),
    ZMaja_CrushingDarkness_Next_Off_Cooldown = Color.yellow("战斗中"),
    ZMaja_CrushingDarkness_Next_Cast = Color.green("现在"),

    ZMaja_MaliciousSphere_Timer_Next = Color.orbs("下次出球: "),
    ZMaja_MaliciousSphere_Timer_Kill = Color.red("打") .. Color.orbs(" 球: "),
    ZMaja_MaliciousSphere_Timer_Off_Cooldown = Color.yellow("战斗中"),
    ZMaja_MaliciousSphere_Timer_Cast = Color.red("现在"),
    ZMaja_MaliciousSphere_Timer_Failed = Color.red("失败"),
    ZMaja_MaliciousSphere_Timer_Success = Color.green("OK"),
    Zmaja_MaliciousSphere_OrbSpawning = Color.orbs("球出现了!"),

    ZMaja_MaliciousSphere_Tracking_Alive = "esoui/art/mappins/battlegrounds_murderball_purple.dds",
    ZMaja_MaliciousSphere_Tracking_Dead = "esoui/art/mappins/battlegrounds_murderball_green.dds",
    ZMaja_MaliciousSphere_Tracking_Collided = "esoui/art/mappins/battlegrounds_murderball_orange.dds",

    Zmaja_CreeperSpawning = Color.creeper("藤蔓出现了!"),
}
