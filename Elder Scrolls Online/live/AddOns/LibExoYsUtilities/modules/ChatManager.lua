LibExoYsUtilities = LibExoYsUtilities or {}

local LibExoY = LibExoYsUtilities


--[[ ------------------ ]]
--[[ -- Debug Buffer -- ]]
--[[ ------------------ ]]

local chatInitialized = false 
-- buffer for debug output before chat is initialized 

local debugBuffer = {}
local function FlushInitMsgBuffer()
  for _,output in ipairs(debugBuffer) do
    d(output) 
  end
  if not ZO_IsTableEmpty(debugBuffer) then 
    d("--- LibExoY: debug buffer flushed ---")
  end
  chatInitialized = true 
  debugBuffer = nil 
end


--[[ ----------- ]]
--[[ -- Debug -- ]]
--[[ ----------- ]]

--- change function in TributesEnhancement.lua to new format

function LibExoY.DebugMsg(...)
  LibExoY.Debug("info", ...)
end


function LibExoY.Debug(option, trigger, addon, message, delim)
  color = {
    ["info"] = "00FF00", 
    ["warning"] = "ff8800", 
    ["error"] = "FF0000",
    ["code"] = "00FFFF",
  }

  -- use addon indepentent trigger for fundamental code problems
  if option == "code" then trigger = true end

  -- check trigger 
  if not LibExoY.CheckTrigger(trigger) then return end

  -- define output string 
  local time = LibExoY.GetTimeString(false) 
  local ms = tostring(GetGameTimeMilliseconds()):sub(-3) 
  local output = zo_strformat("[<<1>>.<<2>>-", time, ms )
  output = zo_strformat("<<1>><<2>><<3>> ", LibExoY.ColorString(output, "8F8F8F"), LibExoY.ColorString(addon, color[option]), LibExoY.ColorString("]","8F8F8F") )

  if LibExoY.IsTable( message ) then
    for k, v in ipairs(message) do
      local str = LibExoY.IsString(v) and v or tostring(v)
      output = string.format("%s%s", output, str)
      if delim[k] then
        output = string.format("%s%s", output, delim[k])
      end
    end
  else
   output = zo_strformat("<<1>><<2>>", output, message ) 
  end

  -- print final output in chat or save it to buffer if chat is not available yet
  if chatInitialized then 
    d( output )
  else 
    table.insert(debugBuffer, output) 
  end

end


--[[ -------------------------- ]]
--[[ -- Chat Message Handler -- ]]
--[[ -------------------------- ]]


local function ChatListener(event, channelType, senderName, message, isCustomerService, senderDisplayName)



end


--[[ --------------------------- ]]
--[[ -- Slash Command Handler -- ]]
--[[ --------------------------- ]]

-- *subCmdTable: key are cmd names, func and desc are entries 

function LibExoY.SlashCommand(cmd, func, info, subCmdTable, subCmdInfos) 

  local function DisplaySubCmdInfos() 
    d("-------")
    for subCmd, _ in pairs(subCmdTable) do
      if subCmdInfos then 
        if subCmdInfos[subCmd] then 
          d( zo_strformat("<<1>> <<2>> - <<3>>", cmd, subCmd, subCmdInfos[subCmd]) )
        else 
          d( zo_strformat("<<1>> <<2>>", cmd, subCmd ) )
        end
      end
    end
    d("-------")
  end

  local function SlashCmdErrorMsg() 
    LibExoY.Debug("code", nil, "LibExoY", "slash command invalid function" ) 
    return function() d("This command has been defined imcorrectly") end
  end

  --early out if no cmd string
  if not LibExoY.IsString(cmd) then 
    LibExoY.Debug("code", nil, "LibExoY", "slash command invalid format" )
    return 
  end

  cmd = "/"..string.lower(cmd)
  if SLASH_COMMANDS[cmd] then 
    LibExoY.Debug("code", nil, "LibExoY", zo_strformat("command <<1>> overwritten", LibExoY.ColorString(cmd, "00FFFF") ) )
  end

  -- check for subCmdTable 
  local hasSubCmds = LibExoY.IsTable(subCmdTable) 

  -- define root cmd function 
  if not LibExoY.IsFunc(func)  then 
    func = hasSubCmds and DisplaySubCmdInfos or SlashCmdErrorMsg
  end

  --[[ Define Slash Command ]]
  SLASH_COMMANDS[cmd] = function(input) 

    -- if no additional input is provided, execute the main function 
    -- shows the info list of the subCmdTable, if a subCmdTable existed and no main function was defined
    if LibExoY.IsStringEmpty(input) then 
      func()
      return
    end
    
    -- parsing the table with the inputs 
    input = string.lower(input) 
    local param={}
    for str in string.gmatch(input, "%S+") do
      table.insert(param, str)
    end

    -- hardcoded subcommand "help" to display cmd and subcommand infos
    if param[1] == 'help' then     
      d( zo_strformat("<<1>> - <<2>>", cmd, info) )
      if subCmdTable then DisplaySubCmdInfos(subCmdTable) end
      return
    end

    -- execute function, if no subcommands exists
    if not subCmdTable then 
      func(param) 
      return 
    end

    -- check if first parameter is a subcommand, 
    -- if yes, adjust the parameter table
    local subCmd 
    if subCmdTable[param[1]] then 
      subCmd = param[1]
      table.remove(param, 1)
    end

    if subCmd then 
      LibExoY.CallFunc(subCmdTable[subCmd] ,param)
    else 
      func(param) 
    end

  end

end


--[[ ---------------- ]]
--[[ -- Initialize -- ]]
--[[ ---------------- ]]

local function Initialize()
  local EM = GetEventManager()
  EM:RegisterForEvent( LibExoY.name.."Chat", EVENT_CHAT_MESSAGE_CHANNEL, ChatListener )

  LibExoY.RegisterForInitialPlayerActivated( FlushInitMsgBuffer ) 
end

LibExoY.ChatManager_InitFunc = Initialize

