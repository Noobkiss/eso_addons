local FC = FontChanger or {}
local LAM2 = LibAddonMenu2
--[[
function FC:DefaultEverything()
	self:SetFont(self.defaults.font, self.defaults.style, self.defaults.size)
end
]] --
function FC:InitializeAddonMenu()
	local panelData = {
		type = "panel",
		name = "FontChanger",
		displayName = "|c4B8BFEFont Changer|r",
		author = "|c4B8BFEFerrety|r, |cFF1493Antisenil|r, |c9966ffzetauma|r",
		version = self.version,
		slashCommand = "/fc",
		registerForRefresh = true,
		registerForDefaults = true
	}

	local fontChoices = FC.DEFAULT_FONT_CHOICES
	for _, v in ipairs(FC.CUSTOM_FONT_CHOICES) do
		table.insert(fontChoices, v)
	end

	local fontValues = FC.DEFAULT_FONT_VALUES
	for _, v in ipairs(FC.CUSTOM_FONT_VALUES) do
		table.insert(fontValues, v)
	end

	local optionsData = {}

	-- table.insert(optionsData, {
	-- 	type = "header",
	-- 	name = "Menu/UI"
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "UI Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes normal font, mostly used in descriptions (mouseover texts) and in the eso settings menu.",
	-- 	getFunc = function()
	-- 		return self.SV.menu_font
	-- 	end,
	-- 	setFunc = function(menu_font)
	-- 		self.SV.menu_font = menu_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_menu_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "UI Font Scale",
	-- 	choices = FC.FONT_SCALING_CHOICES,
	-- 	choicesValues = FC.FONT_SCALING_VALUES,
	-- 	tooltip = "Changes the size for normal font, mostly used in descriptions (mouseover texts) and in the eso settings menu.",
	-- 	getFunc = function()
	-- 		return self.SV.menu_font_scale
	-- 	end,
	-- 	setFunc = function(menu_font_scale)
	-- 		self.SV.menu_font_scale = menu_font_scale
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_menu_font_scale
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "UI Bold Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the bold font, most texts in ESO use this font.",
	-- 	getFunc = function()
	-- 		return self.SV.menu_bold_font
	-- 	end,
	-- 	setFunc = function(menu_bold_font)
	-- 		self.SV.menu_bold_font = menu_bold_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_menu_bold_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "UI Bold Font Scale",
	-- 	choices = FC.FONT_SCALING_CHOICES,
	-- 	choicesValues = FC.FONT_SCALING_VALUES,
	-- 	tooltip = "Changes the size for bold font, most texts in ESO use this font.",
	-- 	getFunc = function()
	-- 		return self.SV.menu_bold_font_scale
	-- 	end,
	-- 	setFunc = function(menu_bold_font_scale)
	-- 		self.SV.menu_bold_font_scale = menu_bold_font_scale
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_menu_bold_font_scale
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "header",
	-- 	name = "BOOKS / LETTERS / TABLETS"
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Book Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the text size of books etc",
	-- 	getFunc = function()
	-- 		return self.SV.book_font
	-- 	end,
	-- 	setFunc = function(book_font)
	-- 		self.SV.book_font = book_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_book_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Book Font Scale",
	-- 	choices = FC.FONT_SCALING_CHOICES,
	-- 	choicesValues = FC.FONT_SCALING_VALUES,
	-- 	tooltip = "Changes the text size of books etc",
	-- 	getFunc = function()
	-- 		return self.SV.book_font_scale
	-- 	end,
	-- 	setFunc = function(book_font_scale)
	-- 		self.SV.book_font_scale = book_font_scale
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_book_font_scale
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Letter Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the text size of letters or handwritten notes.",
	-- 	getFunc = function()
	-- 		return self.SV.letter_font
	-- 	end,
	-- 	setFunc = function(letter_font)
	-- 		self.SV.letter_font = letter_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_letter_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Letter Font Scale",
	-- 	choices = FC.FONT_SCALING_CHOICES,
	-- 	choicesValues = FC.FONT_SCALING_VALUES,
	-- 	tooltip = "Changes the text size of books etc",
	-- 	getFunc = function()
	-- 		return self.SV.letter_font_scale
	-- 	end,
	-- 	setFunc = function(letter_font_scale)
	-- 		self.SV.letter_font_scale = letter_font_scale
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_letter_font_scale
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Tablet Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the text size of stone tablets",
	-- 	getFunc = function()
	-- 		return self.SV.tablet_font
	-- 	end,
	-- 	setFunc = function(tablet_font)
	-- 		self.SV.tablet_font = tablet_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_tablet_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Tablet Font Scale",
	-- 	choices = FC.FONT_SCALING_CHOICES,
	-- 	choicesValues = FC.FONT_SCALING_VALUES,
	-- 	tooltip = "Changes the text size of stone tablets",
	-- 	getFunc = function()
	-- 		return self.SV.tablet_font_scale
	-- 	end,
	-- 	setFunc = function(tablet_font_scale)
	-- 		self.SV.tablet_font_scale = tablet_font_scale
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_tablet_font_scale
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "header",
	-- 	name = "Nameplates"
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Nameplate Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the font for all nameplates.",
	-- 	getFunc = function()
	-- 		return self.SV.nameplate_font
	-- 	end,
	-- 	setFunc = function(nameplate_font)
	-- 		self.SV.nameplate_font = nameplate_font
	-- 		self:SetUIFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:SetUIFonts()
	-- 		return self.defaults.default_nameplate_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Nameplate Font Size",
	-- 	choices = FC.FONTSIZE_CHOICES,
	-- 	choicesValues = FC.FONTSIZE_VALUES,
	-- 	tooltip = "Changes the size of all nameplates.",
	-- 	getFunc = function()
	-- 		return self.SV.nameplate_size
	-- 	end,
	-- 	setFunc = function(nameplate_size)
	-- 		self.SV.nameplate_size = nameplate_size
	-- 		self:SetNameplateFont(self.SV.nameplate_style, self.SV.nameplate_size)
	-- 	end,
	-- 	default = function()
	-- 		self:SetNameplateFont(self.defaults.default_nameplate_style, self.defaults.default_nameplate_size)
	-- 		return self.defaults.default_nameplate_size
	-- 	end,
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Nameplate Font Style",
	-- 	choices = FC.FONTSTYLE_CHOICES,
	-- 	choicesValues = FC.FONTSTYLE_VALUES,
	-- 	tooltip = "Changes the style of nameplates.",
	-- 	getFunc = function()
	-- 		return self.SV.nameplate_style
	-- 	end,
	-- 	setFunc = function(nameplate_style)
	-- 		self.SV.nameplate_style = nameplate_style
	-- 		self:SetNameplateFont(self.SV.nameplate_style, self.SV.nameplate_size)
	-- 	end,
	-- 	default = function()
	-- 		self:SetNameplateFont(self.defaults.default_nameplate_style, self.defaults.default_nameplate_size)
	-- 		return self.defaults.default_nameplate_style
	-- 	end,
	-- 	scrollable = false
	-- })

	table.insert(optionsData, {
		type = "header",
		name = "Scrolling Combat Text (SCT)"
	})

	table.insert(optionsData, {
		type = "dropdown",
		name = "SCT Font",
		choices = fontChoices,
		choicesValues = fontValues,
		tooltip = "Changes the font of scrolling combat text (SCT).",
		getFunc = function()
			return self.SV.sct_font
		end,
		setFunc = function(sct_font)
			self.SV.sct_font = sct_font
			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
		end,
		default = function()
			self:SetSCTFont(self.defaults.default_sct_style, self.defaults.default_sct_size)
			return self.defaults.default_sct_font
		end,
		scrollable = true
	})

	table.insert(optionsData, {
		type = "dropdown",
		name = "SCT Font Size",
		choices = FC.FONTSIZE_CHOICES,
		choicesValues = FC.FONTSIZE_VALUES,
		tooltip = "Changes the size of scrolling combat text(SCT).",
		getFunc = function()
			return self.SV.sct_size
		end,
		setFunc = function(sct_size)
			self.SV.sct_size = sct_size
			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
		end,
		default = function()
			self:SetSCTFont(self.defaults.default_sct_style, self.defaults.default_sct_size)
			return self.defaults.default_sct_size
		end,
		scrollable = true
	})

	table.insert(optionsData, {
		type = "dropdown",
		name = "SCT Font Style",
		choices = FC.FONTSTYLE_CHOICES,
		choicesValues = FC.FONTSTYLE_VALUES,
		tooltip = "Changes the style of SCT",
		getFunc = function()
			return self.SV.sct_style
		end,
		setFunc = function(sct_style)
			self.SV.sct_style = sct_style
			self:SetSCTFont(self.SV.sct_style, self.SV.sct_size)
		end,
		default = function()
			self:SetSCTFont(self.defaults.default_sct_style, self.defaults.default_sct_size)
			return self.defaults.default_sct_style
		end,
		scrollable = false
	})

	-- table.insert(optionsData, {
	-- 	type = "header",
	-- 	name = "Chat"
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Chat Font",
	-- 	choices = fontChoices,
	-- 	choicesValues = fontValues,
	-- 	tooltip = "Changes the font of the chat window.",
	-- 	getFunc = function()
	-- 		return self.SV.chat_font
	-- 	end,
	-- 	setFunc = function(chat_font)
	-- 		self.SV.chat_font = chat_font
	-- 		self:ChangeChatFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:ChangeChatFonts()
	-- 		return self.defaults.default_chat_font
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = true
	-- })

	-- table.insert(optionsData, {
	-- 	type = "dropdown",
	-- 	name = "Chat Font Style",
	-- 	choices = FC.FONTWEIGHT_CHOICES,
	-- 	choicesValues = FC.FONTWEIGHT_VALUES,
	-- 	tooltip = "Changes the style of chat font.",
	-- 	getFunc = function()
	-- 		return self.SV.chat_style
	-- 	end,
	-- 	setFunc = function(chat_style)
	-- 		self.SV.chat_style = chat_style
	-- 		self:ChangeChatFonts()
	-- 	end,
	-- 	default = function()
	-- 		self:ChangeChatFonts()
	-- 		return self.defaults.default_chat_style
	-- 	end,
	-- 	warning = "Reload UI Required.",
	-- 	scrollable = false
	-- })

	-- table.insert(optionsData, {
	-- 	type = "header",
	-- 	name = "Gamepad Mode"
	-- })

	-- table.insert(optionsData, {
	-- 	type = "checkbox",
	-- 	name = "Enable for Gamepad mode",
	-- 	tooltip = "Enables the font settings when in Gamepad mode.",
	-- 	default = true,
	-- 	getFunc = function()
	-- 		return self.SV.gamepad_fonts_enabled
	-- 	end,
	-- 	setFunc = function(gamepad_fonts_enabled)
	-- 		self.SV.gamepad_fonts_enabled = gamepad_fonts_enabled
	-- 	end,
	-- })

	LAM2:RegisterAddonPanel("FontChangerAddonOptions", panelData)
	LAM2:RegisterOptionControls("FontChangerAddonOptions", optionsData)
end
