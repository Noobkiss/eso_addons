local LCCC = LibCodesCommonCode

if (LibCombatAlerts) then return end
local Public = { }
LibCombatAlerts = Public


--------------------------------------------------------------------------------
-- Internal Components
--------------------------------------------------------------------------------

local Internal = {
	name = "LibCombatAlerts",
}
LibCombatAlertsInternal = Internal

do
	local cachedPath = nil

	local function GetRootPath( )
		if (not IsConsoleUI()) then
			local am = GetAddOnManager()
			for i = 1, am:GetNumAddOns() do
				if (am:GetAddOnInfo(i) == Internal.name) then
					local path = zo_strsub(am:GetAddOnRootDirectoryPath(i), 13, -1)
					if (zo_strsub(path, 1, 1) == "/") then
						return path
					end
				end
			end
		end
		return string.format("/%s/", Internal.name)
	end

	function Internal.GetRootPath( )
		if (not cachedPath) then
			cachedPath = GetRootPath()
		end
		return cachedPath
	end
end


--------------------------------------------------------------------------------
-- Base Object for Controls
-- Even though it is "Public", it should only be used internally by LCA controls
--------------------------------------------------------------------------------

do
	local BaseControlObject = ZO_Object:Subclass()
	local nextUniqueId = 1

	function BaseControlObject:New( prefix )
		local obj = ZO_Object.New(self)
		obj.ID = string.format("%s_%d", prefix, nextUniqueId)
		nextUniqueId = nextUniqueId + 1
		return obj
	end

	function BaseControlObject:GetId( )
		return self.ID
	end

	Public.BaseControlObject = BaseControlObject
end
