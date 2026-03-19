local FC = FontChanger or {}
local LAM2 = LibAddonMenu2

FC.name = "FontChanger"
FC.version = "1.5"

function FC:SetUIFonts()
	for key, value in zo_insecurePairs(_G) do
		if (key):find("^Zo") and type(value) == "userdata" and value.SetFont then
			local font = {value:GetFontInfo()}
			-- DEFAULT USED AS REGULAR/CHAT FONT -- 
			if (font[1] == "EsoUI/Common/Fonts/Univers57.slug") or (font[1] == "$(MEDIUM_FONT)") then
				font[1] = self.SV.menu_font
				-- Default Size: 1 --
				font[2] = font[2] * self.SV.menu_font_scale
				value:SetFont(table.concat(font, "|"))
			end
			-- DEFAULT USED AS BOLD FONT --
			if (font[1] == "EsoUI/Common/Fonts/Univers67.slug") or (font[1] == "$(BOLD_FONT)") then
				font[1] = self.SV.menu_bold_font
				-- Default Size: 0.9 --
				font[2] = font[2] * self.SV.menu_bold_font_scale
				value:SetFont(table.concat(font, "|"))
			end
			-- DEFAULT USED AS BOOK FONT --
			if (font[1] == "EsoUI/Common/Fonts/ProseAntiquePSMT.slug") or (font[1] == "$(ANTIQUE_FONT)") then
				font[1] = self.SV.book_font
				-- Default Size: 0.9 --
				font[2] = font[2] * self.SV.book_font_scale
				value:SetFont(table.concat(font, "|"))
			end
			-- DEFAULT USED AS HANDWRITTEN FONT --
			if (font[1] == "EsoUI/Common/Fonts/Handwritten_Bold.slug") or (font[1] == "$(HANDWRITTEN_FONT)") then
				font[1] = self.SV.letter_font
				-- Default Size: 1 --
				font[2] = font[2] * self.SV.letter_font_scale
				value:SetFont(table.concat(font, "|"))
			end
			-- DEFAULT USED AS STONE TABLET FONT --
			if (font[1] == "EsoUI/Common/Fonts/TrajanPro-Regular.slug") or (font[1] == "$(STONE_TABLET_FONT)") then
				font[1] = self.SV.tablet_font
				-- Default Size: 1 --
				font[2] = font[2] * self.SV.tablet_font_scale
				value:SetFont(table.concat(font, "|"))
			end

			if self.SV.gamepad_fonts_enabled then
				-- DEFAULT USED AS GAMEPAD_LIGHT_FONT --
				if (font[1] == "EsoUI/Common/Fonts/FTN47.slug") or (font[1] == "$(GAMEPAD_LIGHT_FONT)") then
					font[1] = self.SV.menu_font
					-- Default Size: 1 --
					font[2] = font[2] * self.SV.menu_font_scale
					value:SetFont(table.concat(font, "|"))
				end
				-- DEFAULT USED AS GAMEPAD_MEDIUM_FONT --
				if (font[1] == "EsoUI/Common/Fonts/FTN57.slug") or (font[1] == "$(GAMEPAD_MEDIUM_FONT)") then
					font[1] = self.SV.menu_font
					-- Default Size: 1 --
					font[2] = font[2] * self.SV.menu_font_scale
					value:SetFont(table.concat(font, "|"))
				end
				-- DEFAULT USED AS GAMEPAD_BOLD_FONT --
				if (font[1] == "EsoUI/Common/Fonts/FTN87.slug") or (font[1] == "$(GAMEPAD_BOLD_FONT)") then
					font[1] = self.SV.menu_bold_font
					-- Default Size: 1 --
					font[2] = font[2] * self.SV.menu_bold_font_scale
					value:SetFont(table.concat(font, "|"))
				end
			end
		end
	end
end

function FC:SetNameplateFont(style, size)
	local Font, CurrentFontStyle
	local NewFontAndSize = (self.SV.nameplate_font .. size)

	-- d("SetNameplateFont, gamepad mode:" .. tostring(IsInGamepadPreferredMode()))

	-- Gamepad Mode  -- 
	if IsInGamepadPreferredMode() then
		if not self.SV.gamepad_fonts_enabled then
			SetNameplateGamepadFont("EsoUI/Common/Fonts/FTN57.slug|30|", self.SV.default_nameplate_style)
			return
		end
		CurrentFontAndSize, CurrentFontStyle = GetNameplateGamepadFont()
		if CurrentFontAndSize ~= NewFontAndSize or CurrentFontStyle ~= style then
			SetNameplateGamepadFont(self.SV.nameplate_font .. "|" .. size .. "|", style)
		end
		-- Keyboard Mode --
	else
		CurrentFontAndSize, CurrentFontStyle = GetNameplateKeyboardFont()
		if CurrentFontAndSize ~= NewFontAndSize or CurrentFontStyle ~= style then
			SetNameplateKeyboardFont(self.SV.nameplate_font .. "|" .. size .. "|", style)
		end
	end
end

function FC:SetSCTFont(style, size)
	local CurrentFontAndSize, CurrentFontStyle
	local NewFontAndSize = (self.SV.sct_font .. size)

	-- d("SetSCTFont, gamepad mode:" .. tostring(IsInGamepadPreferredMode()))

	-- Gamepad Mode -- 
	if IsInGamepadPreferredMode() then
		if not self.SV.gamepad_fonts_enabled then
			SetSCTGamepadFont("EsoUI/Common/Fonts/FTN87.slug|52|", self.SV.default_sct_style)
			return
		end
		CurrentFontAndSize, CurrentFontStyle = GetSCTGamepadFont()
		if CurrentFontAndSize ~= NewFontAndSize or CurrentFontStyle ~= style then
			SetSCTGamepadFont(self.SV.sct_font .. "|" .. size .. "|", style)
		end
		-- Keyboard Mode --
	else
		CurrentFontAndSize, CurrentFontStyle = GetSCTKeyboardFont()
		if CurrentFontAndSize ~= NewFontAndSize or CurrentFontStyle ~= style then
			SetSCTKeyboardFont(self.SV.sct_font .. "|" .. size .. "|", style)
		end
	end
end

function FC:ChangeChatFonts()
	local fontStyle = self.SV.chat_font
	local fontSize = GetChatFontSize()
	local fontWeight = self.SV.chat_style
	local fontName = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	-- Entry Box --
	ZoFontEditChat:SetFont(fontName)
	-- Chat Window --
	ZoFontChat:SetFont(fontName)
	-- Size --
	CHAT_SYSTEM:SetFontSize(CHAT_SYSTEM.GetFontSizeFromSetting())
end

function FC:SetDefaults()
	-- Set Defaults --

	-- Fonts
	if self.SV.menu_font == nil then
		self.SV.menu_font = self.SV.default_menu_font
	end
	if self.SV.menu_bold_font == nil then
		self.SV.menu_bold_font = self.SV.default_menu_bold_font
	end
	if self.SV.chat_font == nil then
		self.SV.chat_font = self.SV.default_chat_font
	end
	if self.SV.nameplate_font == nil then
		self.SV.nameplate_font = self.SV.default_nameplate_font
	end
	if self.SV.sct_font == nil then
		self.SV.sct_font = self.SV.default_sct_font
	end
	if self.SV.book_font == nil then
		self.SV.book_font = self.SV.default_book_font
	end
	if self.SV.letter_font == nil then
		self.SV.letter_font = self.SV.default_letter_font
	end
	if self.SV.tablet_font == nil then
		self.SV.tablet_font = self.SV.default_tablet_font
	end

	-- Scales
	if self.SV.menu_font_scale == nil then
		self.SV.menu_font_scale = self.SV.default_menu_font_scale
	end
	if self.SV.menu_bold_font_scale == nil then
		self.SV.menu_bold_font_scale = self.SV.default_menu_bold_font_scale
	end
	if self.SV.book_font_scale == nil then
		self.SV.book_font_scale = self.SV.default_book_font_scale
	end
	if self.SV.letter_font_scale == nil then
		self.SV.letter_font_scale = self.SV.default_letter_font_scale
	end
	if self.SV.tablet_font_scale == nil then
		self.SV.tablet_font_scale = self.SV.default_tablet_font_scale
	end

	-- Sizes
	if self.SV.nameplate_size == nil then
		self.SV.nameplate_size = self.SV.default_nameplate_size
	end
	if self.SV.sct_size == nil then
		self.SV.sct_size = self.SV.default_sct_size
	end

	-- Styles
	if self.SV.nameplate_style == nil then
		self.SV.nameplate_style = self.SV.default_nameplate_style
	end
	if self.SV.sct_style == nil then
		self.SV.sct_style = self.SV.default_sct_style
	end
	if self.SV.chat_style == nil then
		self.SV.chat_style = self.SV.default_chat_style
	end

	-- Misc
	if self.SV.gamepad_fonts_enabled == nil then
		self.SV.gamepad_fonts_enabled = self.SV.default_gamepad_fonts_enabled
	end
end

-- function FC:SetupEvents(toggle)
-- 	if toggle then
-- 		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, function(...)
-- 			-- self:SetNameplateFont(self.SV.nameplate_style, self.SV.nameplate_size)
-- 			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
-- 		end)
-- 		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, function(...)
-- 			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
-- 		end)
-- 		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, function(...)
-- 			-- self:SetNameplateFont(self.SV.nameplate_style, self.SV.nameplate_size)
-- 			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
-- 		end)
-- 	else
-- 		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED)
-- 		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ZONE_CHANGED)
-- 		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED)
-- 	end
-- end

function FC:ShowScreenAlert(msg)
    -- ZO_Alert是ESO原生提示接口，参数：提示类型、显示时长（毫秒）、提示文字
    -- ALERT_CATEGORY_INFO：信息类提示（浅蓝/白色文字），无弹窗音效
    ZO_Alert(ALERT_CATEGORY_INFO, SOUNDS.NONE, msg)
end

function FC:RefreshFontOnce()

     if not self.SV then return end
    
    self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
end

-- function FC:SetupEvents(toggle)
--      if toggle then
--         -- 保留原有基础事件 + 新增覆盖失效场景的事件（仅监听，不重复执行）
--         local refreshFontFunc = function()
--             self:RefreshFontOnce() -- 仅执行一次字体设置
--         end

--         -- 基础事件（原有）
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, refreshFontFunc)
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, refreshFontFunc)
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, refreshFontFunc)
--         -- 新增场景相关事件（覆盖副本/复活/UI重载）
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED_IN_INSTANCE, refreshFontFunc)
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_REVIVED, refreshFontFunc)
-- 		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_LOGIN, refreshFontFunc)
--         -- UI重载后仅单次执行
--         EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ADD_ON_LOADED, function(_, addonName)
--             if addonName == self.name then
--                 zo_callLater(refreshFontFunc, 500) -- 等UI初始化完单次执行
--             end
--         end)

--         -- 注册后立即单次刷新
--         refreshFontFunc()
--     else
--         -- 注销所有事件（和之前一致）
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ZONE_CHANGED)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED_IN_INSTANCE)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_REVIVED)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_LOGIN)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_DEACTIVATED)
--         EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
--     end
-- end

function FC:SetupEvents(toggle)
    if toggle then
        -- 创建一个专门用于设置SCT字体的延迟函数
        local setSCTDelayed = function()
            zo_callLater(function() 
                if self.SV.sct_style and self.SV.sct_size then
                    self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
                    -- 可选：调试提示
                    -- self:ShowScreenAlert("SCT字体已刷新")
                end
            end, 300) -- 延迟300毫秒，等UI重建完
        end

        -- 所有事件都触发延迟的SCT字体设置
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, setSCTDelayed)
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, setSCTDelayed)  -- 关键：场景切换
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, setSCTDelayed)
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED_IN_INSTANCE, setSCTDelayed)
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_REVIVED, setSCTDelayed)
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_LOGIN, setSCTDelayed)
        
        -- UI重载后多等一会儿
        EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ADD_ON_LOADED, function(_, addonName)
            if addonName == self.name then
                zo_callLater(setSCTDelayed, 1000)
            end
        end)

        -- 立即执行一次
        setSCTDelayed()
    else
        -- 注销所有事件（保持不变）
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ZONE_CHANGED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED_IN_INSTANCE)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_REVIVED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_LOGIN)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_DEACTIVATED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
    end
end

function FC:Initialize()

	local manager = GetAddOnManager()

	for i = 1, manager:GetNumAddOns() do
		local name, _, _, _, _, state = manager:GetAddOnInfo(i)
		if name == self.name then
			self.version = manager:GetAddOnVersion(i)
		end
	end

	-- Load Saved Variables --
	self.SV = ZO_SavedVars:NewAccountWide("FontChangerSettings", self.version, "Settings", self.defaults)

	-- Run Functions --
	self:SetupEvents(true)
	-- self:SetDefaults()
	-- self:SetNameplateFont(self.SV.nameplate_style, self.SV.nameplate_size)
	self:RefreshFontOnce()
	-- self:SetUIFonts()
	-- self:ChangeChatFonts()
end

function FC.OnLoad(event, addonName)
	if addonName ~= FC.name then
		return
	end
	EVENT_MANAGER:UnregisterForEvent(FC.name, EVENT_ADD_ON_LOADED, FC.OnLoad)
	FC:InitializeAddonMenu()
	FC:Initialize()
end

EVENT_MANAGER:RegisterForEvent(FC.name, EVENT_ADD_ON_LOADED, FC.OnLoad)

