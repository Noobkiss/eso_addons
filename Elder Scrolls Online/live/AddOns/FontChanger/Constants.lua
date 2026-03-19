FontChanger = {}
local FC = FontChanger or {}

FC.DEFAULT_FONT_CHOICES = {
	"Univers57 (Vanilla UI)",
	"Univers67 (Vanilla UI Bold)",
	"Univers87 (Vanilla UI Bolder)",
	"ProseAntiquePSMT (Vanilla Book)",
	"Handwritten_Bold (Vanilla Letter)",
	"TrajanPro-Regular (Vanilla Stone Tablet)",
	"FTN47 (Vanilla Gamepad Light)",
	"FTN57 (Vanilla Gamepad Medium)",
	"FTN87 (Vanilla Gamepad Bold)",
}

FC.DEFAULT_FONT_VALUES = {
	"EsoUI/Common/Fonts/Univers57.slug",
	"EsoUI/Common/Fonts/Univers67.slug",
	"EsoUI/Common/Fonts/Univers87.slug",
	"EsoUI/Common/Fonts/ProseAntiquePSMT.slug",
	"EsoUI/Common/Fonts/Handwritten_Bold.slug",
	"EsoUI/Common/Fonts/TrajanPro-Regular.slug",
	"EsoUI/Common/Fonts/FTN47.slug",
	"EsoUI/Common/Fonts/FTN57.slug",
	"EsoUI/Common/Fonts/FTN87.slug",
}

FC.FONTSTYLE_VALUES =
{
	FONT_STYLE_NORMAL,
	FONT_STYLE_OUTLINE,
	FONT_STYLE_OUTLINE_THICK,
	FONT_STYLE_SHADOW,
	FONT_STYLE_SOFT_SHADOW_THICK,
	FONT_STYLE_SOFT_SHADOW_THIN,
}

FC.FONTSTYLE_CHOICES =
{
	"Normal",
	"Outline",
	"Outline Thick",
	"Shadow",
	"Soft Shadow Thick",
	"Soft Shadow Thin",
}

FC.FONTWEIGHT_CHOICES =
{
	"Thick Outline",
	"Shadow",
	"Soft Shadow Thick",
	"Soft Shadow Thin",
}
FC.FONTWEIGHT_VALUES =
{
	"thick-outline",
	"shadow",
	"soft-shadow-thick",
	"soft-shadow-thin",
}

FC.FONT_SCALING_CHOICES =
{
	"x 0.1",
	"x 0.2",
	"x 0.3",
	"x 0.4",
	"x 0.5",
	"x 0.6",
	"x 0.7",
	"x 0.8",
	"x 0.9",
	"x 1",
	"x 1.1",
	"x 1.2",
	"x 1.3",
	"x 1.4",
	"x 1.5",
	"x 1.6",
	"x 1.7",
	"x 1.8",
	"x 1.9",
	"x 2",
}

FC.FONT_SCALING_VALUES =
{
	"0.1",
	"0.2",
	"0.3",
	"0.4",
	"0.5",
	"0.6",
	"0.7",
	"0.8",
	"0.9",
	"1",
	"1.1",
	"1.2",
	"1.3",
	"1.4",
	"1.5",
	"1.6",
	"1.7",
	"1.8",
	"1.9",
	"2",
}

FC.FONTSIZE_CHOICES =
{
	"Size 8",
	"Size 10",
	"Size 12",
	"Size 14",
	"Size 16",
	"Size 18",
	"Size 20",
	"Size 22",
	"Size 24",
	"Size 26",
	"Size 28",
	"Size 30",
	"Size 32",
	"Size 34",
	"Size 36",
	"Size 38",
	"Size 40",
	"Size 42",
	"Size 48",
	"Size 52",
	"Size 58",
	"Size 62",
	"Size 68",
	"Size 72",
}

FC.FONTSIZE_VALUES =
{
	"8",
	"10",
	"12",
	"14",
	"16",
	"18",
	"20",
	"22",
	"24",
	"26",
	"28",
	"30",
	"32",
	"34",
	"36",
	"38",
	"40",
	"42",
	"48",
	"52",
	"58",
	"62",
	"68",
	"72",
}

FC.defaults =
{
	--fonts
	default_menu_font = "FontChanger/fonts/slugs/FCUI.slug",
	default_menu_bold_font = "FontChanger/fonts/slugs/FCUI_Bold.slug",
	default_chat_font = "FontChanger/fonts/slugs/FCChat.slug",
	default_sct_font = "FontChanger/fonts/slugs/FCUI.slug",
	default_nameplate_font = "FontChanger/fonts/slugs/FCUI.slug",
	default_book_font = "FontChanger/fonts/slugs/FCBook.slug",
	default_letter_font = "EsoUI/Common/Fonts/Handwritten_Bold.slug",
	default_tablet_font = "EsoUI/Common/Fonts/TrajanPro-Regular.slug",

	-- scales
	default_menu_font_scale = "1",
	default_menu_bold_font_scale = "1",
	default_book_font_scale = "1",
	default_letter_font_scale = "1",
	default_tablet_font_scale = "1",

	-- sizes
	default_nameplate_size = "28",
	default_sct_size = "32",
	
	-- styles
	default_nameplate_style = FONT_STYLE_SOFT_SHADOW_THIN,
	default_sct_style = FONT_STYLE_SOFT_SHADOW_THIN,
	default_chat_style = "thick-outline",

	-- misc
	default_gamepad_fonts_enabled = true,
}
