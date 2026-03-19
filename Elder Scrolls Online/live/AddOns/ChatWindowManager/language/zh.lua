local CWMAddon = _G['CWMAddon']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- chinese
------------------------------------------------------------------------------------------------------------------

-- General strings
	L.CWMAddon_Reload			= "重启UI"
	L.CWMAddon_Clear			= "清空聊天窗口"
	L.CWMAddon_ClearT			= "清除当前聊天窗口"
	L.CWMAddon_Toggle			= "切换聊天窗口"
	L.CWMAddon_Online			= "切换在线状态"
	L.CWMAddon_RBox				= "是否要重新加载 UI?"

-- Settings panel
	L.CWMAddon_Title			= "聊天窗口管理器"
	L.CWMAddon_AutoHide			= "自动隐藏聊天窗口"
	L.CWMAddon_AutoHideT		= "在登录、更改区域或重新加载 UI 时最小化聊天窗口。"
	L.CWMAddon_RemState			= "记住聊天状态"
	L.CWMAddon_RemStateT		= "通过在加载屏幕之间保持先前的聊天状态来覆盖下一个选项。"
	L.CWMAddon_RButton			= "添加重新加载/清除按钮"
	L.CWMAddon_RButtonT			= "向聊天窗口添加一个按钮以重新加载 UI，或按住 Shift 键单击以清除当前聊天。"
	L.CWMAddon_ROffset			= "重新加载按钮偏移"
	L.CWMAddon_ROffsetT			= "聊天最大化时更改重新加载按钮的水平位置（为了与其他插件兼容）。"
	L.CWMAddon_RConfirm			= "确认重新加载用户界面"
	L.CWMAddon_RConfirmT		= "单击重新加载 UI 按钮时添加确认框以避免意外重新加载。"
	L.CWMAddon_SButton			= "添加玩家状态菜单"
	L.CWMAddon_SButtonT			= "聊天窗口增加玩家在线状态选择菜单。"
	L.CWMAddon_SChat			= "聊天中的状态切换"
	L.CWMAddon_SChatT			= "当通过键绑定或其他方法更改时，在聊天中显示玩家在线状态。"
	L.CWMAddon_SOffset			= "状态偏移"
	L.CWMAddon_SOffsetT			= "聊天最大化时更改在线状态指示器的水平位置（为了与其他插件兼容）。"
	L.CWMAddon_Extras			= "额外选项"
	L.CWMAddon_DConfirm			= "简单删除确认"
	L.CWMAddon_DConfirmT		= "删除某些内容时无需键入“DELETE”。 相反，您会得到一个框来单击“是”或“否”。"
	L.CWMAddon_HideFriend		= "隐藏好友登录和注销"
	L.CWMAddon_HideFriendT		= "防止朋友登录和注销状态消息出现在聊天中。"
	L.CWMAddon_TutorialOff		= "禁用教程"
	L.CWMAddon_TutorialOffT		= "在登录时自动禁用弹出教程（以及启用此选项时）。 可以从游戏设置中重新启用。"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'zh') then -- overwrite GetLanguage for new language
	for k,v in pairs(CWMAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function CWMAddon:GetLanguage() -- set new language return
		return L
	end
end
