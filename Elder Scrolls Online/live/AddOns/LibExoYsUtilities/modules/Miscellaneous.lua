LibExoYsUtilities = LibExoYsUtilities or {}
local LibExoY = LibExoYsUtilities


--[[ ------------------------- ]]
--[[ -- Check Variable Type -- ]]
--[[ ------------------------- ]]

function LibExoY.IsTable( t )
  return type(t) == "table"
end

function LibExoY.IsFunc( f )
  return type(f) == "function"
end

function LibExoY.IsString( s ) 
  return type(s) == "string"
end

function LibExoY.IsNumber( n ) 
  return type(n) == "number"
end

function LibExoY.IsBool( b ) 
  return type(b) == "boolean" 
end


--[[ ------------------------- ]]
--[[ -- Eso Specific Checks -- ]]
--[[ ------------------------- ]]

function LibExoY.IsAccount( s )
  if LibExoY.IsString(s) then 
    return string.find(s, "@") ~= nil
  else 
    LibExoY.Debug("code", nil, "LibExoY", "non-string account check")
    return
  end
end


--[[ ----------------------------- ]]
--[[ -- Custom Function Handler -- ]]
--[[ ----------------------------- ]]

function LibExoY.CallFunc( f, p ) 
  if LibExoY.IsFunc(f) then return f(p) end
end

function LibExoY.CallFuncWithTrigger(t,f, p) 
  if LibExoY.CheckTrigger( t ) then 
    LibExoY.CallFunc(f,p) 
  end
end 

function LibExoY.CheckTrigger( t )
  if LibExoY.IsFunc( t ) and LibExoY.IsBool( t() ) then return t() end
  if LibExoY.IsBool( t ) then return t end
  LibExoY.Debug("code", nil, "LibExoY", "invalid trigger check")
  return 
end


--[[ ---------------------- ]]
--[[ -- String Functions -- ]]
--[[ ---------------------- ]]

-- todo, check if string only consists of spaces 
function LibExoY.IsStringEmpty(s, allowSpaces) 
  if LibExoY.IsString(s) then 
    -- check if empty string
    if s == "" then return true 
    -- if not empty, but only spaces are ok
    elseif allowSpaces then return false 
    -- check if all are spaces 
    else  
      local nonSpacePosition = string.find(s, "%S")
      return not LibExoY.IsNumber(nonSpacePosition)
    end   
    
  else 
    LibExoY.Debug("code", nil, "LibExoY", "non-string empty check")
    return  
  end
end


function LibExoY.StartsWithSpace(s)
  if LibExoY.IsString(s) then 
    return string.sub(s,1,1) == " "
  else 
    LibExoY.Debug("code", nil, "LibExoY", "non-string space at start check")
    return
  end
end




--[[ -- String Functions -- ]]

-- todo, function to check if strings begins with a space 
function LibExoY.IsFirstCharacterSpace(s)
  if not Lib.IsString(s) then return end
  return string.sub(s,1,1) == " "
end
-- 

-- todo, check if string only consists of spaces 
function LibExoY.IsStringEmpty(s) 
  return s == ""
end




--[[ --------------------- ]]
--[[ -- Table Functions -- ]]
--[[ --------------------- ]]

-- /Media.lua/LibExoY.GetOutlineNumber()
-- /Media.lua/LibExoY.GetFontNumber()
-- /SavedVariables/PM:GetIdByName()


-- finds the key k, which has the entry e (unsure about table support) 
-- if value is not found then default value d is returned
function LibExoY.FindNumericKey(t, e, d) 
  for k,v in ipairs(t) do
    if e == v then 
      return k
    end
  end
  return d 
end 


function LibExoY.VerifyHashTable(t, e) 
  if not LibExoY.IsTable(t) then return false end 
  for _,ev in ipairs(e) do 
    if not t[ev] then return false end
  end
  return true
end

-- returns >true> if duplicate string is found in t
-- only applicable to tables containing strings 
-- if "cases" is true, than capitalization is considered
--  e.g.  cases = true  ->  "Dog" and "dog" are not! duplicates
--        cases = false ->  "Dog" and "dog" are duplicates 
function LibExoY.HasDuplicateString(t, s, cases) 
  local d = false
  for _,v in pairs(t) do 
    if cases then 
      if v == s then d = true break end
    else 
      if string.lower(v) == string.lower(s) then d = true break end
    end
  end
  return d 
end
-- /script d(LibExoYsUtilities.CheckDuplicateString({"Dog", "Cat"},"dog"))