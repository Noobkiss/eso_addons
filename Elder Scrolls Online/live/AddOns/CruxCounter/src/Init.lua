-- -----------------------------------------------------------------------------
-- Init.lua
-- -----------------------------------------------------------------------------

local CC     = CruxCounter
local EM     = EVENT_MANAGER

--- @type string Namespace for addon init event
local initNs = CC.Addon.name .. "_Init"

--- Unregister the addon
--- @see EVENT_ADD_ON_LOADED
--- @return nil
local function unregister()
    EM:UnregisterForEvent(initNs, EVENT_ADD_ON_LOADED)
end

--- Initialize the addon
--- @param addonName string Name of the addon loaded
--- @return nil
local function init(_, addonName)
    -- Remove class restriction: no longer check for Arcanist class

    -- Skip addons that aren't this one
    if addonName ~= CC.Addon.name then return end

    -- Ready to go
    unregister()

    CC.Language:Setup()
    CC.Settings:Setup()
    CC.Events:RegisterEvents()

    -- FIX: Ensure display is initialized before applying settings
    if CruxCounter_Display then
        CruxCounter_Display:ApplySettings()
    else
        CC.Debug:Trace(1, "Warning: CruxCounter_Display not available during init")
        -- Try again later if display isn't ready
        zo_callLater(function()
            if CruxCounter_Display then
                CruxCounter_Display:ApplySettings()
            else
                CC.Debug:Trace(0, "Error: CruxCounter_Display still not available after delay")
            end
        end, 100)
    end
end

-- Make the magic happen
EM:RegisterForEvent(initNs, EVENT_ADD_ON_LOADED, init)