local FC = FontChanger or {}

-- PerfectPixel font override
function FC:OverridePPFonts()
	FC:Initialize()
	PP.f.u57 = self.SV.menu_font
	PP.f.u67 = self.SV.menu_bold_font
end
if PP then
	ZO_PreHook(PP, "Core", function (...) FC:OverridePPFonts() return false end)
end


-- Compatibility
function FC.Compatibility()
	if PerfectPixel then
		d("[FontChanger] PerfectPixel compatibility enabled")
		local sizecompass = 26 * FC.SV.menu_bold_font_scale
		local font = FC.SV.menu_bold_font .. "|" .. sizecompass .. "|soft-shadow-thick"
		COMPASS.container:SetCardinalDirection(GetString(SI_COMPASS_NORTH_ABBREVIATION),	font, CARDINAL_DIRECTION_NORTH)
		COMPASS.container:SetCardinalDirection(GetString(SI_COMPASS_EAST_ABBREVIATION),		font, CARDINAL_DIRECTION_EAST)
		COMPASS.container:SetCardinalDirection(GetString(SI_COMPASS_WEST_ABBREVIATION),		font, CARDINAL_DIRECTION_WEST)
		COMPASS.container:SetCardinalDirection(GetString(SI_COMPASS_SOUTH_ABBREVIATION),	font, CARDINAL_DIRECTION_SOUTH)

		local t = {KEYBIND_STRIP_STANDARD_STYLE, KEYBIND_STRIP_CHAMPION_KEYBOARD_STYLE}
		local sizekbsd = 25 * FC.SV.menu_bold_font_scale
		local sizekbsk = 20 * FC.SV.menu_font_scale
		for _, keybindStrip in ipairs(t) do
			keybindStrip.nameFont				= FC.SV.menu_bold_font .. "|" .. sizekbsd .. "|outline"
			keybindStrip.keyFont				= FC.SV.menu_font .. "|" .. sizekbsk
			keybindStrip.resizeToFitPadding		= 20
			keybindStrip.leftAnchorOffset		= 10
			keybindStrip.centerAnchorOffset		= 0
			keybindStrip.rightAnchorOffset		= -10
		end
	-- additional compatibility code here
	end
	EVENT_MANAGER:UnregisterForEvent(FC.name .. "Compatibility", EVENT_PLAYER_ACTIVATED)
end

EVENT_MANAGER:RegisterForEvent(FC.name .. "Compatibility", EVENT_PLAYER_ACTIVATED, FC.Compatibility)
