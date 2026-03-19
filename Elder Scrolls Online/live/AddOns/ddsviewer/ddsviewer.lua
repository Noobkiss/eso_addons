--------------------------------------------------------------------------------
-- House of Winters - Texture Viewer
--------------------------------------------------------------------------------
-- Exposes the following to the global scope:
--     ddsview               (addon namespace)
--     ddsviewer_ui_*          (addon controls)
--
-- Provides the following slash commands:
--     /texview
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Setup module global variable.
--------------------------------------------------------------------------------

ddsview = {
    name         = "ddsviewer",
    displayName  = "DDS Viewer",
    prefix       = "ddsviewer_ui",
    author       = "@evilwhistle",
    version      = "0.1",
    link         = "http://www.esoui.com/",
    command      = "/ddsview",
    debug        = false,
}

--------------------------------------------------------------------------------
-- Libraries, defaults and constants.
--------------------------------------------------------------------------------

local lam = LibStub:GetLibrary("LibAddonMenu-2.0")
local json = LibStub:GetLibrary("LibJSON-1.0")

--
-- Module defaults.
--
local defaults = {
    visible = false,
    faded = false,
    alpha = 65,
    anchor = {
        point = TOPLEFT,
        relativePoint = TOPLEFT,
        offsetX = 100,
        offsetY = 100,
    },
    colors = {
        header = "EECA2A",
        -- section = "FF9933",
        text = "FFE3A1",
        value = "F0F0F0",
        selected = "6699FF",
        -- unknown = "E0E0E0",
        -- active = "6699FF",
        -- complete = "208020",
        -- abandoned = "C00000",
    },
    dimension = {
        width = 1000,
        height = 592
        ,
    },
}

--
-- Supported fonts
--
local FONTS = {
   -- "ZoFontBookLetter",
   -- "ZoFontBookNote",
   -- "ZoFontBookPaper",
   -- "ZoFontBookRubbing",
   -- "ZoFontBookScroll",
   -- "ZoFontBookSkin",
   -- "ZoFontBookTablet",
   "ZoFontChat",
   "ZoFontGame",
   "ZoFontGameBold",
   "ZoFontGameLarge",
   "ZoFontGameLargeBold",
   "ZoFontGameLargeBoldShadow",
   "ZoFontGameMedium",
   "ZoFontGameOutline",
   "ZoFontGameShadow",
   "ZoFontGameSmall",
   -- "ZoFontWinT1",
   -- "ZoFontWinT2",
}

--------------------------------------------------------------------------------
-- Addon init and event/command handling functions.
--------------------------------------------------------------------------------


--- Event handler for EVENT_ADD_ON_LOADED.
-- @return void
function ddsview.AddOnLoaded(eventCode, addOnName)
    if addOnName ~= ddsview.name then return end

    -- Register the slash command handler.
    SLASH_COMMANDS[ddsview.command] = ddsview.CommandHandler

    -- Initialize addon.
    ddsview:Init()

    -- Add addon settings page.
    --ddsview.Settings()
end

--- Initialize ddsview.
-- @return void
function ddsview:Init()
    -- Load saved vars.
    ddsview.vars = ZO_SavedVars:New("ddsviewer_vars", 1, "TextureViewer", defaults)
    ddsview.textures = json.Deserialize(ddsview.texturesJSON)
    ddsview.directory = "/esoui/art/achievements"
    ddsview.filepath, ddsview.file = ddsview:GetFirstChild(ddsview.directory)

    -- Update control from vars.
    ddsviewer_ui:ClearAnchors()
    ddsview:SetAnchor(ddsview.vars.anchor)
    ddsview.SetAlpha(ddsview.vars.alpha)
    ddsview:SetDimensions(ddsview.vars.dimension)
    ddsview:SetFaded(ddsview.vars.faded)

    -- Show ddsview.
    if ddsview.vars.visible then
        ddsview:OpenWindow()
    end

    -- Bind event handlers.
    ZO_PreHookHandler(ZO_GameMenu_InGame, "OnShow", function()
        ddsview:HideIfVisible()
    end)
    ZO_PreHookHandler(ZO_GameMenu_InGame, "OnHide", function()
        ddsview:ShowIfVisible()
    end)
    ZO_PreHookHandler(ZO_InteractWindow, "OnShow", function()
        ddsview:HideIfVisible()
    end)
    ZO_PreHookHandler(ZO_InteractWindow, "OnHide", function()
        ddsview:ShowIfVisible()
    end)
    ZO_PreHookHandler(ZO_KeybindStripControl, "OnShow", function()
        ddsview:HideIfVisible()
    end)
    ZO_PreHookHandler(ZO_KeybindStripControl, "OnHide", function()
        ddsview:ShowIfVisible()
    end)
    ZO_PreHookHandler(ZO_MainMenuCategoryBar, "OnShow", function()
        ddsview:HideIfVisible()
    end)
    ZO_PreHookHandler(ZO_MainMenuCategoryBar, "OnHide", function()
        ddsview:ShowIfVisible()
    end)
end

--- Event handler for OnMoveStop to reposition window per character.
-- @return void
function ddsview:OnMoveStop()
    local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = ddsviewer_ui:GetAnchor()
    if (isValidAnchor) then
        ddsview.vars.anchor.point = point
        ddsview.vars.anchor.relativePoint = relativePoint
        ddsview.vars.anchor.offsetX = offsetX
        ddsview.vars.anchor.offsetY = offsetY
    end
end

--- Event handler for OnResizeStop to resize window per character.
-- @return void
function ddsview:OnResizeStop()
    local width, height = ddsviewer_ui:GetDimensions()
    if width and height then
        ddsview.vars.dimension.width = width
        ddsview.vars.dimension.height = height
    end
    -- Resize might cause anchor change as well.
    ddsview:OnMoveStop()
end

--- Event handler for OnMouseWheel to scroll TextBuffer control.
-- @param delta int scroll up/down step value.
-- @return void
function ddsview:OnMouseWheel(_self, delta, ctrl, alt, shift, command)
    local visible = _self:GetNumVisibleLines()
    local lines = _self:GetNumHistoryLines()
    local scrollPosition = _self:GetScrollPosition()

    if ctrl then
        if _self:GetName() == "ddsviewer_ui_DirListTB" and ddsview.directory then
            local absdir, reldir
            if delta < 0 then
                absdir, reldir = ddsview:GetNextEntry(ddsview.directory)
            elseif delta > 0 then
                absdir, reldir = ddsview:GetPreviousEntry(ddsview.directory)
            end
            if absdir and not (reldir == "__orderedIndex") and not (ddsview:endswith(reldir, ".dds")) then
                ddsview.directory = absdir
                ddsview.filepath, ddsview.file = ddsview:GetFirstChild(ddsview.directory)
                if ddsview.filepath then
                    ddsview:PrintLocation(ddsview.filepath)
                    ddsview:PrintTexture(ddsview.filepath)
                else
                    ddsview:PrintLocation(ddsview.directory)
                    ddsviewer_ui_Texture:SetHidden(true)
                end
                ddsview:PrintDirectoryList(ddsview.textures, ddsview.directory, "", "", ddsviewer_ui_DirListTB:GetScrollPosition())
                ddsview:PrintFileList(ddsview.directory, ddsview.file)
            end
        elseif _self:GetName() == "ddsviewer_ui_FileListTB" and ddsview.filepath then
            local directory, file
            if delta < 0 then
                directory, file = ddsview:GetNextEntry(ddsview.filepath)
            elseif delta > 0 then
                directory, file = ddsview:GetPreviousEntry(ddsview.filepath)
            end
            if file and not (file == "__orderedIndex") and (ddsview:endswith(file, ".dds")) then
                ddsview.filepath = ddsview.directory..'/'..file
                ddsview:PrintLocation(ddsview.filepath)
                ddsview:PrintFileList(ddsview.directory, file, ddsviewer_ui_FileListTB:GetScrollPosition())
                ddsview:PrintTexture(ddsview.filepath)
            end
        end
    else
        if delta < 0 then
            _self:MoveScrollPosition(delta)
        elseif delta > 0 then
            _self:MoveScrollPosition(delta)
        end
    end
end

function ddsview:endswith(s, send)
    return #s >= #send and s:find(send, #s-#send+1, true) and true or false
end

function ddsview:GetPreviousEntry(path)
    local strpos = string.find(path, "/[^/]*$")
    local parent = zo_strsub(path, 0 , strpos - 1)
    local child = zo_strsub(path, strpos + 1)
    local dirs = ddsview:GetFilesForPath(parent)
    local previous = nil
    if dirs then
        for k, v in orderedPairs(dirs) do
            if k == child then
                if not previous then
                    break
                end
                return parent..'/'..previous, previous
            end
            previous = k
        end
    end
    return nil, nil
end

function ddsview:GetNextEntry(path)
    local strpos = string.find(path, "/[^/]*$")
    local parent = zo_strsub(path, 0 , strpos - 1)
    local child = zo_strsub(path, strpos + 1)
    local dirs = ddsview:GetFilesForPath(parent)
    local next = false
    if dirs then
        for k, v in orderedPairs(dirs) do
            if next then
                return parent..'/'..k, k
            end
            if k == child then
                next = true
            end
        end
    end
    return nil, nil
end

function ddsview:GetFirstChild(path)
    local dirs = ddsview:GetFilesForPath(path)
    for k, v in orderedPairs(dirs) do
        if v.file then
            return v.path, k
        else
            break
        end
    end
    return nil, nil
end

--- Event handler for OnLinkClicked in TextBuffer control.
-- @param self
-- @param linkData string the link url:     url:SomeLinkTargetOrUrl[SomeLinkText]
-- @param linkText string the link text:    [SomeLinkText]
-- @param button int the mousebutton clicked, 1 = left, 2 = right, 3 = middle
-- @param ctrl bool true if ctrl was pressed during click.
-- @param alt bool true if alt was pressed during click.
-- @param shift bool true if shift was pressed during click.
-- @param command bool true if command (Mac I assume) was pressed during click.
-- @return void
function ddsview:OnLinkClicked(_self, linkData, linkText, button, ctrl, alt, shift, command)
    local linkStyle, linkType, arg1, arg2 = zo_strsplit(":", linkData)
    if linkType == "dir" then
        local path = arg1
        local directory = arg2
        if button == 1 then
            ddsview.directory = path
            ddsview.filepath, ddsview.file = ddsview:GetFirstChild(ddsview.directory)
            if ddsview.filepath then
                ddsview:PrintLocation(ddsview.filepath)
                ddsview:PrintTexture(ddsview.filepath)
            else
                ddsview:PrintLocation(ddsview.directory)
                ddsviewer_ui_Texture:SetHidden(true)
            end
            ddsview:PrintDirectoryList(ddsview.textures, ddsview.directory, "", "", ddsviewer_ui_DirListTB:GetScrollPosition())
            ddsview:PrintFileList(ddsview.directory, ddsview.file)
        end
    elseif linkType == "file" then
        local file = arg1
        local name = arg2
        if button == 1 then
            ddsview.file = file
            ddsview.filepath = ddsview.directory..'/'..file
            ddsview:PrintLocation(ddsview.filepath)
            ddsview:PrintFileList(ddsview.directory, file, ddsviewer_ui_FileListTB:GetScrollPosition())
            ddsview:PrintTexture(ddsview.filepath)
        end
    end
end

function ddsview:ScrollToFirstLine(_self)
    local visible = _self:GetNumVisibleLines()
    local lines = _self:GetNumHistoryLines()
    _self:SetScrollPosition(lines - (visible + 1))
end

--- Addon command handler.
-- @param text the command line argument (original case)
-- @return void
function ddsview.CommandHandler(text)
    local cmd = string.lower(text)

    if cmd == "show" then
        ddsview.OpenWindow()
    elseif cmd == "hide" then
        ddsview:CloseWindow()
    else
        d("----------------------------------------")
        d("|cEECA2A"..ddsview.displayName.."|r |c6699FF"..ddsview.version.."|r by |cFF9933"..ddsview.author.."|r")
        d("----------------------------------------")
        d("Commands:")
        d(ddsview.command.." show")
        d(ddsview.command.." hide")
        d("----------------------------------------")
    end
end

--------------------------------------------------------------------------------
-- Setup module control panel section.
--------------------------------------------------------------------------------

--- Addon settings.
-- @return void

--function ddsview.Settings()
--    local controlPanel = HoW_Settings

    -- Create HoW settings page.
    --if not controlPanel then
    --    controlPanel = lam:CreateControlPanel("HoW_Settings", "|cEECA2A|r")
    --end 

    -- Add module settings.
--    lam:AddHeader(controlPanel, ddsview.prefix.."SettingsHeader", ddsview.displayName)
--    lam:AddCheckbox(controlPanel, ddsview.prefix.."SettingsVisible", "Visible", "Toggle Texture Viewer visibility", ddsview.IsVisible, ddsview.SetVisible)
--    lam:AddDropdown(controlPanel, ddsview.prefix.."SettingsFont", "Font", "Change font family", FONTS, ddsview.GetFont, ddsview.SetFont)
--    lam:AddSlider(controlPanel, ddsview.prefix.."SettingsAlpha", "Alpha", "Change background transparency", 0, 100, 1, ddsview.GetAlpha, ddsview.SetAlpha)
--    lam:AddDescription(controlPanel, ddsview.prefix.."AboutDescription", "Chat command: |c66FF99"..ddsview.command.."|r\n\n|cEECA2A"..ddsview.displayName.."|r |c6699FF"..ddsview.version.."|r by |cFF9933"..ddsview.author.."|r")
--end

function ddsview.IsVisible()
    return ddsview.vars and ddsview.vars.visible
end

function ddsview.SetVisible(checkbox)
    ddsview.vars.visible = checkbox
end

function ddsview.GetFont()
    if ddsview.vars and ddsview.vars.font then
        return ddsview.vars.font
    else
        return "ZoFontGame"
    end
end

function ddsview.SetFont(font)
    ddsview.vars.font = font
    ddsviewer_ui_HeaderLabel:SetFont(font)
    ddsviewer_ui_TextLabel:SetFont(font)
    ddsviewer_ui_DirListTB:SetFont(font)
end

function ddsview.GetAlpha()
    if ddsview.vars and ddsview.vars.alpha then
        return ddsview.vars.alpha
    else
        return 65
    end
end

function ddsview.SetAlpha(alpha)
    ddsview.vars.alpha = alpha
    ddsviewer_ui_Backdrop:SetAlpha(alpha / 100)
    ddsviewer_ui_DirListTB_Backdrop:SetAlpha(alpha / 100)
    ddsviewer_ui_FileListTB_Backdrop:SetAlpha(alpha / 100)
end

--------------------------------------------------------------------------------
-- Show Texture Viewer window.
--------------------------------------------------------------------------------

--- Show TextureViewer window.
-- @param options table with options to show, types/character.
-- @return void
function ddsview.OpenWindow()
    -- Remember window state.
    ddsview.vars.visible = true

    -- Set font and scale on components
    local font = ddsview.GetFont()
    ddsviewer_ui_HeaderLabel:SetFont(font)
    ddsviewer_ui_DirListTB:SetFont(font)
    ddsviewer_ui_FileListTB:SetFont(font)

    ddsview:UpdateWindow(true)
    ddsviewer_ui:SetHidden(false)
end

--- Update window with info.
--- Called from xml without args and OpenWindow.
-- @param force trigger update without buffering when opening up window to show content directly.
-- @return void
function ddsview:UpdateWindow(force)
    if not force and not BufferReached("ddsview.OnUpdate", 1) then return end

    -- Header
    ddsview:PrintHeader()

    -- Address
    if ddsview.filepath then
        ddsview:PrintLocation(ddsview.filepath)
    else
        ddsview:PrintLocation(ddsview.directory)
    end

    -- Directory listing
    ddsview:PrintDirectoryList(ddsview.textures, ddsview.directory, "", "")

    -- File listing
    ddsview:PrintFileList(ddsview.directory, ddsview.file)

    -- Texture view
    if ddsview.filepath then
        ddsview:PrintTexture(ddsview.filepath)
    end
end

--- Print heading with addon name and optionally zonename.
-- @return void
function ddsview:PrintHeader()
    ddsviewer_ui_HeaderLabel:SetText(string.format(
        "|c%s%s",
        ddsview.vars.colors.header,
        ddsview.displayName
    ))
end

--- Update TextLabel with current location.
-- @param location string the current selected location.
-- @return void
function ddsview:PrintLocation(path)
    ddsviewer_ui_LocationEB:SetText(path)
end

--- Update TextBuffer with directory listing.
-- @param dirlist table with directory listing.
-- @param location string the current selected location.
-- @param parent the parent directory, used for the links.
-- @param prefix string prefix to add to print out.
-- @param scrollPos optional position to scroll back to.
-- @return void
function ddsview:PrintDirectoryList(dirlist, location, parent, prefix, scrollPos)
    if parent == "" then
        ddsviewer_ui_DirListTB:Clear()
    end
    if dirlist and type(dirlist) == "table" then
        for k, v in orderedPairs(dirlist) do
            if not v.file and not (k == "__orderedIndex") then
                local color = ddsview.vars.colors.value
                if location == parent..'/'..k then
                    color = ddsview.vars.colors.selected
                end

                ddsviewer_ui_DirListTB:AddMessage(string.format(
                    "|c%s%s |c%s|H%d:dir:%s/%s:|h%s|h |c%s(%d)",
                    ddsview.vars.colors.text,
                    prefix,
                    color,
                    LINK_STYLE_DEFAULT,
                    parent,
                    k,
                    k,
                    ddsview.vars.colors.text,
                    ddsview:tablelength(v)
                ), 1, 1, 1, 1);
                if v and type(v) == "table" then
                    ddsview:PrintDirectoryList(v, location, parent..'/'..k, prefix.."--")
                end
            end
        end
        if scrollPos then
            ddsviewer_ui_DirListTB:SetScrollPosition(scrollPos)
        else
            ddsview:ScrollToFirstLine(ddsviewer_ui_DirListTB)
        end
    end
end

--- Return file(s) for given path, supports 4 nested levels.
-- @param path the given path.
-- @return table with file(s) for given path.
function ddsview:GetFilesForPath(path)
    local arg1, arg2, arg3, arg4 = zo_strsplit("/", path)
    if arg1 and ddsview.textures[arg1] then
        if arg2 and ddsview.textures[arg1][arg2] then
            if arg3 and ddsview.textures[arg1][arg2][arg3] then
                if arg4 and ddsview.textures[arg1][arg2][arg3][arg4] then
                    return ddsview.textures[arg1][arg2][arg3][arg4]
                else
                    return ddsview.textures[arg1][arg2][arg3]
                end
            else
                return ddsview.textures[arg1][arg2]
            end
        else
            return ddsview.textures[arg1]
        end
    else
        return nil
    end
end

function ddsview:tablelength(table)
    local count = 0
    for k, v in pairs(table) do
        if not (k == "__orderedIndex") then
            count = count + 1
        end
    end
    return count
end

--- Update TextBuffer with texture files for given directory.
-- @param path the path to print textures for.
-- @param currentFile the currently selected file
-- @param scrollPos optional position to scroll back to.
-- @return void
function ddsview:PrintFileList(path, currentFile, scrollPos)
    ddsviewer_ui_FileListTB:Clear()
    local files = ddsview:GetFilesForPath(path)
    if files then
        local i = 0
        for k, v in orderedPairs(files) do
            if v.file then
                i = i + 1
                local name, _ = zo_strsplit(".", k)
                local color = ddsview.vars.colors.value
                if currentFile and currentFile == k then
                    color = ddsview.vars.colors.selected
                end
                if zo_strlen(name) > 50 then
                    name = zo_strsub(name, 0, 48)..'..'
                end
                ddsviewer_ui_FileListTB:AddMessage(string.format(
                    "|c%s%02d |c%s|H%d:file:%s:|h%s|h",
                    ddsview.vars.colors.text,
                    i,
                    color,
                    LINK_STYLE_DEFAULT,
                    k,
                    name
                ), 1, 1, 1, 1);
            end
        end
    end
    if scrollPos then
        ddsviewer_ui_FileListTB:SetScrollPosition(scrollPos)
    else
        ddsview:ScrollToFirstLine(ddsviewer_ui_FileListTB)
    end
end

--- Update TextBuffer with given texture path
-- @param path the path to print textures for.
-- @return void
function ddsview:PrintTexture(path)
    local file = ddsview:GetFilesForPath(path)
    -- d(file)
    ddsviewer_ui_Texture:SetTexture(path)
    ddsviewer_ui_Texture:SetHidden(false)
    local width, height = ddsviewer_ui_Texture:GetDimensions()
    if file.width and file.height and file.size then
        ddsviewer_ui_FileInfoL:SetText(string.format(
            "|c%sDimensions: |c%s%d x %d |c%spixels\nFilesize: |c%s%d |c%sBytes|r",
            ddsview.vars.colors.text,
            ddsview.vars.colors.value,
            file.width,
            file.height,
            ddsview.vars.colors.text,
            ddsview.vars.colors.value,
            file.size,
            ddsview.vars.colors.text
        ))
    elseif width and height then
        ddsviewer_ui_FileInfoL:SetText(string.format(
            "|c%sDimensions: |c%s%d x %d |c%spixels|r",
            ddsview.vars.colors.text,
            ddsview.vars.colors.value,
            width,
            height,
            ddsview.vars.colors.text
        ))
    end
    -- Print out any empty textures when in debug mode.
    if ddsview.debug then
        if (width == 0) or (height == 0) then
            d(string.format("%s (%dx%d)", path, width, height))
        end
    end
end

--------------------------------------------------------------------------------
-- Update xml control functions.
--------------------------------------------------------------------------------

--- Set window anchor position.
-- @param anchor table with point, relativePoint, offsetX and offsetY.
-- @return void
function ddsview:SetAnchor(anchor)
    ddsviewer_ui:SetAnchor(anchor.point, GuiRoot, anchor.relativePoint, anchor.offsetX, anchor.offsetY)
end

--- Set window size.
-- @param dimension table with width and height
-- @return void
function ddsview:SetDimensions(dimension)
    ddsviewer_ui:SetDimensions(dimension.width, dimension.height)
end

--- Set window faded.
-- @param faded boolean faded state
-- @return void
function ddsview:SetFaded(faded)
    ddsviewer_ui_Backdrop:SetHidden(faded)
end


--- Fade window backdrop.
-- @return void
function ddsview:FadeWindow()
    -- Remember window faded state.
    ddsview.vars.faded = not ddsviewer_ui_Backdrop:IsHidden()
    ddsview:SetFaded(ddsview.vars.faded)
end

--- Refresh window with current zone.
-- @return void
function ddsview:RefreshWindow()
    ddsview:UpdateWindow(true)
end

--- Close the Texture Viewer window.
-- @return void
function ddsview:CloseWindow()
    -- Remember window state.
    ddsview.vars.visible = false
    ddsviewer_ui:SetHidden(true)
end

--- Hide the window if visible and screen state changed to some dialogue/menu interface.
-- @return void
function ddsview:HideIfVisible()
    if ddsview.vars.visible then
        ddsviewer_ui:SetHidden(true)
    end
end

--- Show the window if visible and screen state returned to normal.
-- @return void
function ddsview:ShowIfVisible()
    if ddsview.vars.visible then
        ddsviewer_ui:SetHidden(false)
    end
end

--------------------------------------------------------------------------------

-- Initialize addon.
EVENT_MANAGER:RegisterForEvent(ddsview.name, EVENT_ADD_ON_LOADED, ddsview.AddOnLoaded)
