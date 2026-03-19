local LCCC = LibCodesCommonCode
local LUP = LibUndauntedPledges
local RCR = Raidificator


--------------------------------------------------------------------------------
-- RaidificatorPledges
--------------------------------------------------------------------------------

local RaidificatorPledges = ZO_Object:Subclass()

function RaidificatorPledges:New( )
	local obj = ZO_Object.New(self)
	local window = RaidificatorPledgesTopLevel
	obj.window = window

	local PADDING = 12
	local HEADER = 94
	local LINE = 2
	local WIDTH = 880
	local HEIGHT = 24

	local divider = window:GetNamedChild("DividerH")
	divider:SetEdgeColor(0, 0, 0, 0)
	divider:SetCenterColor(LCCC.Int32ToRGBA(RCR.COLOR_DIVIDER))

	local header = window:GetNamedChild("Header")
	header:GetNamedChild("Base1"):SetText(LUP.GetPledgeGiverName(LUP.BASE1))
	header:GetNamedChild("Base2"):SetText(LUP.GetPledgeGiverName(LUP.BASE2))
	header:GetNamedChild("Dlc1"):SetText(LUP.GetPledgeGiverName(LUP.DLC1))

	obj.rowCount = LUP.GetPledgeCount(LUP.DLC1)
	obj.rows = { [0] = window:GetNamedChild("Header") }
	for i = 1, obj.rowCount do
		local row = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)Row" .. i, window, "RaidificatorPledgesEntry")
		row:SetAnchor(TOPLEFT, obj.rows[i - 1], BOTTOMLEFT)
		row:GetNamedChild("BG"):SetHidden(i % 2 == 0)
		obj.rows[i] = row
	end

	window:SetDimensions(
		WIDTH + PADDING * 2 + 4,
		HEIGHT * obj.rowCount + PADDING * 2 + HEADER
	)
	window:ClearAnchors()
	window:SetAnchor(CENTER, GuiRoot, CENTER)

	return obj
end

function RaidificatorPledges:Toggle( offset )
	offset = tonumber(offset) or 0

	if (self.window:IsHidden() or self.prevOffset ~= offset) then
		self.prevOffset = offset

		local SetCell = function( control, name, text, color )
			local cell = control:GetNamedChild(name)
			cell:SetText(text)
			cell:SetColor(color:UnpackRGB())
		end

		for i = 1, self.rowCount do
			local pledge = LUP.GetPledges(i - 1 + offset)
			local row = self.rows[i]
			local color = (pledge.date.wday == 7 or pledge.date.wday == 1) and ZO_HIGHLIGHT_TEXT or ZO_DEFAULT_TEXT
			SetCell(row, "Date", string.format("%04d-%02d-%02d – %s", pledge.date.year, pledge.date.month, pledge.date.day, pledge.date.wdayShort), color)
			SetCell(row, "Base1", pledge[LUP.BASE1].name, color)
			SetCell(row, "Base2", pledge[LUP.BASE2].name, color)
			SetCell(row, "Dlc1", pledge[LUP.DLC1].name, color)
		end

		self.window:SetHidden(false)
	else
		self.window:SetHidden(true)
	end
end


--------------------------------------------------------------------------------
-- Entry points
--------------------------------------------------------------------------------

function RCR.PledgesEnabled( )
	return type(LUP) == "table"
end

function RCR.InitializePledges( )
	if (RCR.PledgesEnabled()) then
		LCCC.RegisterString("SI_BINDING_NAME_RCR_PLEDGES", string.format("%s: %s", GetString(SI_RCR_TITLE), GetString(SI_RCR_PLEDGES)))
		LCCC.RegisterSlashCommands(RCR.Pledges, "/pledgecal")
	end
end

function RCR.GetPledgesButton( )
	return {
		name = GetString(SI_RCR_PLEDGES),
		keybind = "RCR_PLEDGES",
		callback = RCR.Pledges,
	}
end

local Pledges = nil

function RCR.Pledges( ... )
	if (RCR.PledgesEnabled()) then
		if (not Pledges) then
			Pledges = RaidificatorPledges:New()
		end
		Pledges:Toggle(...)
	end
end
