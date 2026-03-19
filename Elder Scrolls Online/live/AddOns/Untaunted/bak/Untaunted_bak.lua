
local em = GetEventManager()
local _
local db,lastanchor
local dx = 1/GetSetting(SETTING_TYPE_UI, UI_SETTING_CUSTOM_SCALE) --Get UI Scale to draw thin lines correctly
UNTAUNTED_UI_SCALE = dx
local TIMER_UPDATE_RATE = 200
local tauntlist = {}	-- holds all currently registered unitid/abilityid pairs
local tauntdata = {}	-- holds all endtimes of registered effects
local OnTauntEnd
local ActiveAbilityIdList = {}
local AbilityCopies = {}

local COLOR_GREEN = {0, 0.8, 0, 1}  -- 绿色 (72,200,137)
local COLOR_RED = {0.8, 0, 0, 1}    -- 红色 (177,34,35)
local COLOR_YELLOW = {1, 0.8, 0, 1}            -- 金黄色

-- Addon Namespace
Untaunted = Untaunted or {}
local Untaunted = Untaunted
Untaunted.name 		= "Untaunted"
Untaunted.version 	= "1.1.5"

local function Print(message, ...)
	if Untaunted.debug==false then return end
	df("[%s] %s", Untaunted.name, message:format(...))
end

local function SetBorderColor(item, color)
	if not item or not item.borders then return end
	
	local r, g, b, a = unpack(color)
	item.borders.top:SetCenterColor(r, g, b, a)
	item.borders.bottom:SetCenterColor(r, g, b, a)
	item.borders.left:SetCenterColor(r, g, b, a)
	item.borders.right:SetCenterColor(r, g, b, a)
end


local function SetBorderThickness(item, thickness)
	if not item or not item.borders then return end
	
	local width = item:GetNamedChild("Bg"):GetWidth()
	local height = item:GetNamedChild("Bg"):GetHeight()
	
	-- 先清除所有锚点
	item.borders.top:ClearAnchors()
	item.borders.bottom:ClearAnchors()
	item.borders.left:ClearAnchors()
	item.borders.right:ClearAnchors()
	
	-- 重新设置锚点和尺寸
	item.borders.top:SetAnchor(TOPLEFT, item:GetNamedChild("Bg"), TOPLEFT, -thickness, -thickness)
	item.borders.top:SetAnchor(TOPRIGHT, item:GetNamedChild("Bg"), TOPRIGHT, thickness, -thickness)
	item.borders.top:SetDimensions(width + thickness * 2, thickness)
	
	item.borders.bottom:SetAnchor(BOTTOMLEFT, item:GetNamedChild("Bg"), BOTTOMLEFT, -thickness, thickness)
	item.borders.bottom:SetAnchor(BOTTOMRIGHT, item:GetNamedChild("Bg"), BOTTOMRIGHT, thickness, thickness)
	item.borders.bottom:SetDimensions(width + thickness * 2, thickness)
	
	item.borders.left:SetAnchor(TOPLEFT, item:GetNamedChild("Bg"), TOPLEFT, -thickness, -thickness)
	item.borders.left:SetAnchor(BOTTOMLEFT, item:GetNamedChild("Bg"), BOTTOMLEFT, -thickness, thickness)
	item.borders.left:SetDimensions(thickness, height + thickness * 2)
	
	item.borders.right:SetAnchor(TOPRIGHT, item:GetNamedChild("Bg"), TOPRIGHT, thickness, -thickness)
	item.borders.right:SetAnchor(BOTTOMRIGHT, item:GetNamedChild("Bg"), BOTTOMRIGHT, thickness, thickness)
	item.borders.right:SetDimensions(thickness, height + thickness * 2)
	
	item.borderThickness = thickness
end

-- 更新边框颜色的函数
local function UpdateBorderColor(item, isSelected)
	if not item or not item.borders then return end
    
    local thickness = db.borderthickness or 1
    local defaultColor = db.bordercolor or {1, 0.8, 0, 1}
    local selectedColor = {1, 1, 1, 0.8}  -- RGB(109,161,164) 蓝绿色
    
    -- 获取背景控件
    local bg = item:GetNamedChild("Bg")
    
    if isSelected then
        -- 选中时：边框和背景的edge都设为蓝绿色
        SetBorderColor(item, selectedColor)
        bg:SetEdgeColor(unpack(selectedColor))
    else
        -- 未选中时：恢复默认颜色
        SetBorderColor(item, defaultColor)
        bg:SetEdgeColor(unpack(defaultColor))  -- 透明
    end
    
    -- 确保边框粗细不变
    SetBorderThickness(item, thickness)
    
    -- 确保背景色不变
    local bgColor = db.bgcolor or {0.1, 0.1, 0.1, 1}
    bg:SetCenterColor(unpack(bgColor))
end

local function splitCSV(text)

	local fields = {}

	text:gsub("([^,]+)", function(result)

		result = tonumber(result)
		fields[#fields+1] = result and math.floor(result) or nil

	end)

	return fields

 end

local pool = ZO_ObjectPool:New(function(objectPool)

		return ZO_ObjectPool_CreateNamedControl("$(parent)UnitItem", "Untaunted_UnitItemTemplate", objectPool, Untaunted_TLW)

	end,
	function(olditem, objectPool)  -- Removes an item from the taunt list and redirect the anchors.

		local key = olditem.key
		if key == nil then return end

		olditem:SetHidden(true)

		local id, abilityId = olditem.id, olditem.abilityId

		local idkey = ZO_CachedStrFormat("<<1>>,<<2>>", id, abilityId)

		if id and abilityId then tauntlist[idkey] = nil end

		olditem.endTime = nil
		olditem.abilityId = nil
		olditem.id = nil

		OnTauntEnd(key)

		if olditem:GetNamedChild("Bar").timeline then olditem:GetNamedChild("Bar").timeline:PlayInstantlyToStart() end

		local _,point,rel,relpoint,x,y = olditem:GetAnchor(0)

		if olditem.anchored then

			olditem.anchored:ClearAnchors()
			olditem.anchored:SetAnchor(point,rel,relpoint,x,y)
			rel.anchored = olditem.anchored
			olditem.anchored = nil

		else

			rel.anchored = nil
			lastanchor = {point,rel,relpoint,x,y}

		end
	end)

local function SetBarAnimation(control, duration, sourceType) --This creates the bar animation (moving and color change)

	duration = duration or 15000

	local timeline = ANIMATION_MANAGER:CreateTimeline()

	timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)

	local _,_,rel,_,x,y = control:GetAnchor()
	
	-- 根据是否显示图标来设置不同的锚点
	local anchor
	if db.showicon then
		-- 显示图标时，进度条锚定到图标的右边
		anchor = {TOPLEFT,control:GetParent():GetNamedChild("Icon"),TOPRIGHT,UNTAUNTED_UI_SCALE,UNTAUNTED_UI_SCALE}
	else
		-- 隐藏图标时，进度条锚定到背景的左边
		anchor = {TOPLEFT,control:GetParent():GetNamedChild("Bg"),TOPLEFT,UNTAUNTED_UI_SCALE,UNTAUNTED_UI_SCALE}
	end

	if db.bardirection == true then 
		if db.showicon then
			anchor = {TOPRIGHT,control:GetParent():GetNamedChild("Bg"),TOPRIGHT,UNTAUNTED_UI_SCALE,UNTAUNTED_UI_SCALE}
		else
			anchor = {TOPRIGHT,control:GetParent():GetNamedChild("Bg"),TOPRIGHT,UNTAUNTED_UI_SCALE,UNTAUNTED_UI_SCALE}
		end
	end

	control:ClearAnchors()
	control:SetAnchor(unpack(anchor))

	local move = timeline:InsertAnimation(ANIMATION_SIZE, control)

	move:SetStartAndEndWidth(control:GetWidth(),0)
	move:SetStartAndEndHeight(control:GetHeight(),control:GetHeight())
	move:SetDuration(duration)

	 local color1 = timeline:InsertAnimation(ANIMATION_COLOR, control)
    
    -- 使用您提供的颜色方案
    if sourceType == 1 then
        -- 玩家来源：绿色 -> 黄色
        gradient1 = {COLOR_GREEN[1], COLOR_GREEN[2], COLOR_GREEN[3], COLOR_GREEN[4], 
                    COLOR_YELLOW[1], COLOR_YELLOW[2], COLOR_YELLOW[3], COLOR_YELLOW[4]}
    else
        -- 其他来源：黄色 -> 红色
        gradient1 = {COLOR_YELLOW[1], COLOR_YELLOW[2], COLOR_YELLOW[3], COLOR_YELLOW[4], 
                    COLOR_RED[1], COLOR_RED[2], COLOR_RED[3], COLOR_RED[4]}
    end
    
    color1:SetColorValues(unpack(gradient1))
    color1:SetDuration(duration/2)
    
    local color2 = timeline:InsertAnimation(ANIMATION_COLOR, control, duration/2)
    
    if sourceType == 1 then
        -- 玩家来源：黄色 -> 红色
        gradient2 = {COLOR_YELLOW[1], COLOR_YELLOW[2], COLOR_YELLOW[3], COLOR_YELLOW[4], 
                    COLOR_RED[1], COLOR_RED[2], COLOR_RED[3], COLOR_RED[4]}
    else
        -- 其他来源：红色 -> 深红
        gradient2 = {COLOR_RED[1], COLOR_RED[2], COLOR_RED[3], COLOR_RED[4], 
                    0.5, 0.1, 0.1, 1}  -- 深红色
    end

	color2:SetColorValues(unpack(gradient2))
	color2:SetDuration(duration/2)

	return timeline
end

local function GetGrowthAnchor(item)

	item = item or lastanchor[2].anchored

	local a1 = db.growthdirection and BOTTOMLEFT or TOPLEFT
	local a2 = db.growthdirection and TOPLEFT or BOTTOMLEFT

	local sp = db.growthdirection and zo_round(-4/dx)*dx or zo_round(4/dx)*dx

	local anchor = {a1, item, a2, 0, sp}

	local firstitem = Untaunted_TLW.anchored

	firstitem:ClearAnchors()
	firstitem:SetAnchor(a1, Untaunted_TLW, a1, zo_round(4/dx)*dx, sp)

	return anchor

end

local function NewItem(unitname, unitId, abilityId)  -- Adds an item to the taunt list,

	local item,key = pool:AcquireObject()

	item.key = key
	item.id = unitId

	local height = db.window.height
	local width = db.window.width

	local fontsize = db.fontsize or 22
	local font = string.format("%s|%d|%s", GetString(SI_UNTAUNTED_FONT), fontsize, 'soft-shadow-thin')

	item:SetHidden(false)
	item:ClearAnchors()
	item:SetAnchor(unpack(lastanchor))

	local label = item:GetNamedChild("Label")
	label:SetText(zo_strformat("<<!aC:1>>",unitname))
	label:SetFont(font)

	local bg = item:GetNamedChild("Bg")
	bg:SetDimensions(width, height)
	bg:SetCenterColor(0, 0, 0, 0.6)  -- 深灰色背景

	-- 获取四个边框控件
	local borderTop = item:GetNamedChild("BorderTop")
	local borderBottom = item:GetNamedChild("BorderBottom")
	local borderLeft = item:GetNamedChild("BorderLeft")
	local borderRight = item:GetNamedChild("BorderRight")
	
	-- 设置边框粗细
	local thickness = db.borderthickness or 1
	local defaultColor = db.bordercolor or {1, 1, 0, 1}

	-- 先清除所有锚点
	borderTop:ClearAnchors()
	borderBottom:ClearAnchors()
	borderLeft:ClearAnchors()
	borderRight:ClearAnchors()

	-- 上边框：从左上到右上，向外绘制
	borderTop:SetAnchor(TOPLEFT, bg, TOPLEFT, -thickness, -thickness)
	borderTop:SetAnchor(TOPRIGHT, bg, TOPRIGHT, thickness, -thickness)
	borderTop:SetDimensions(width + thickness * 2, thickness)

	-- 下边框：从左下到右下，向外绘制
	borderBottom:SetAnchor(BOTTOMLEFT, bg, BOTTOMLEFT, -thickness, thickness)
	borderBottom:SetAnchor(BOTTOMRIGHT, bg, BOTTOMRIGHT, thickness, thickness)
	borderBottom:SetDimensions(width + thickness * 2, thickness)

	-- 左边框：从左上到左下，向外绘制（注意高度要包括上下边框）
	borderLeft:SetAnchor(TOPLEFT, bg, TOPLEFT, -thickness, -thickness)
	borderLeft:SetAnchor(BOTTOMLEFT, bg, BOTTOMLEFT, -thickness, thickness)
	borderLeft:SetDimensions(thickness, height + thickness * 2)

	-- 右边框：从右上到右下，向外绘制（注意高度要包括上下边框）
	borderRight:SetAnchor(TOPRIGHT, bg, TOPRIGHT, thickness, -thickness)
	borderRight:SetAnchor(BOTTOMRIGHT, bg, BOTTOMRIGHT, thickness, thickness)
	borderRight:SetDimensions(thickness, height + thickness * 2)

	-- 设置边框颜色
	borderTop:SetCenterColor(unpack(defaultColor))
	borderBottom:SetCenterColor(unpack(defaultColor))
	borderLeft:SetCenterColor(unpack(defaultColor))
	borderRight:SetCenterColor(unpack(defaultColor))

	-- 存储边框控件引用
	item.borders = {
		top = borderTop,
		bottom = borderBottom,
		left = borderLeft,
		right = borderRight
	}
	item.borderThickness = thickness

	-- 图标控制
	local icon = item:GetNamedChild("Icon")
	if db.showicon then
		icon:SetHidden(false)
		icon:SetDimensions(height, height)
		icon:SetTexture(GetAbilityIcon(abilityId))
	else
		icon:SetHidden(true)
	end

	local timer = item:GetNamedChild("Timer")
	timer:SetDimensions(height*1.4, height)
	timer:SetFont(font)
	timer:SetText("15.0")

	-- 进度条宽度调整
	local bar = item:GetNamedChild("Bar")
	if db.showicon then
		bar:SetDimensions(width - height - (zo_round(2/dx)*dx), height - (zo_round(2/dx)*dx))
	else
		bar:SetDimensions(width - (zo_round(2/dx)*dx), height - (zo_round(2/dx)*dx))
	end

	lastanchor[2].anchored = item
	lastanchor = GetGrowthAnchor(item)

	return key
end



local function OnTauntStart(key, endTime, abilityId, sourceType)  -- Prepare Animation, start it and set off the timer.

	if key==nil or endTime==nil then return end

	local duration = (endTime-GetGameTimeMilliseconds())
	local item = pool:GetExistingObject(key)
	local unitId = item.id

	item.endTime = endTime
	item.abilityId = abilityId

	-- 设置边框 - 使用设置的颜色
	local bg = item:GetNamedChild("Bg")
	local defaultColor = db.bordercolor or {1, 1, 0, 1}  -- 使用设置的颜色
	local thickness = db.borderthickness or 1
	
	-- 直接设置边框
	-- 设置边框粗细
	SetBorderThickness(item, thickness)
	
	-- 检查是否被选中
	local isSelected = false
	if activeitems then
		for _, v in pairs(activeitems) do
			if v == key then
				isSelected = true
				break
			end
		end
	end
	
	if isSelected then
		SetBorderColor(item, {1, 1, 1, 1})  -- 白色
	else
		SetBorderColor(item, defaultColor)  -- 设置的颜色
	end

	local bar = item:GetNamedChild("Bar")

	if bar.timeline then bar.timeline:PlayInstantlyToStart() end
	bar.timeline = SetBarAnimation(bar, duration, sourceType)
	bar.timeline:PlayFromStart()

	local timer = item:GetNamedChild("Timer")

	local function TimerUpdate()
		local duration = math.floor((endTime-GetGameTimeMilliseconds())/TIMER_UPDATE_RATE)/5

		if duration < -1 then
			pool:ReleaseObject(key)
			return
		end

		timer:SetText(string.format("%.1f",duration))
	end

	TimerUpdate()

	em:RegisterForUpdate("Undaunted_Timer"..key, TIMER_UPDATE_RATE, TimerUpdate)

	return key
end

function OnTauntEnd(key)

	if key == nil then return end

	em:UnregisterForUpdate("Undaunted_Timer"..key)

	local item = pool:GetExistingObject(key)

	if item == nil then return end

	-- 修复：使用用户设置的边框颜色和粗细，而不是设为透明
	local bg = item:GetNamedChild("Bg")
	local defaultColor = db.bordercolor
	local thickness = db.borderthickness or 1
	
	-- 保持边框可见，但使用默认颜色
	bg:SetEdgeColor(unpack(defaultColor))
	-- 确保边框粗细不变
	bg:SetEdgeTexture("", 1, 1, 1, thickness)
	
	item:GetNamedChild("Timer"):SetText("")
end

local activeitems  -- 存储当前选中的项

local function OnTargetChange()

-- 如果没有目标，清空activeitems并返回
	if not DoesUnitExist("reticleover") then
		-- 将之前选中的项恢复为默认颜色
		if activeitems then
			for _,v in pairs(activeitems) do
				local item = pool:GetExistingObject(v)
				if item ~= nil then 
					UpdateBorderColor(item, false)
				end
			end
		end
		activeitems = {}
		return
	end

	-- 获取当前目标上的新效果
	local endTime, abilityId
	local newActiveItems = {}

	-- 首先将所有之前选中的项恢复为默认颜色
	if activeitems then
		for _,v in pairs(activeitems) do
			local item = pool:GetExistingObject(v)
			if item ~= nil then 
				UpdateBorderColor(item, false)
			end
		end
	end

	for i = 1, GetNumBuffs("reticleover") do
		_, _, endTime, _, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("reticleover", i)

		if tauntdata[endTime] ~= nil and ActiveAbilityIdList[abilityId] then
			local key = tauntdata[endTime]
			table.insert(newActiveItems, key)

			local item = pool:GetExistingObject(key)
			if item ~= nil then
				-- 高亮显示选中目标为白色
				UpdateBorderColor(item, true)
			end
		end
	end

	-- 更新activeitems为新的选中项
	activeitems = newActiveItems
end

-- EVENT_EFFECT_CHANGED (eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
local function onTaunt( _,  changeType,  _,  _,  _, beginTime, endTime,  _,  _,  _,  effectType, _,  _,  unitName, unitId, abilityId, sourceType)

	if (changeType~=EFFECT_RESULT_GAINED and changeType~=EFFECT_RESULT_FADED and changeType~=EFFECT_RESULT_UPDATED and effectType~=BUFF_EFFECT_TYPE_DEBUFF and effectType~=BUFF_EFFECT_TYPE_BUFF) or (sourceType~=COMBAT_UNIT_TYPE_PLAYER and sourceType ~=COMBAT_UNIT_TYPE_PLAYER_PET and sourceType~=COMBAT_UNIT_TYPE_GROUP and abilityId~=134599 and abilityId~=120014 and abilityId~=88401) then return end
	if changeType == 1 and abilityId == 88401 then return end

	local idkey = ZO_CachedStrFormat("<<1>>,<<2>>", unitId, abilityId)

	local key = tauntlist[idkey]

	if changeType==EFFECT_RESULT_GAINED or changeType==EFFECT_RESULT_UPDATED then

		if pool:GetActiveObjectCount() >= db.maxbars then return end

		if key == nil then
			key = NewItem(unitName, unitId, abilityId)
			tauntlist[idkey] = key
		end

		tauntdata[endTime] = key

		endTime = math.floor(endTime*1000)

		OnTauntStart(key, endTime, abilityId, sourceType)

		OnTargetChange()

	elseif changeType==EFFECT_RESULT_FADED and key ~= nil then

		tauntdata[endTime] = nil

		if Untaunted.inCombat == false then
			pool:ReleaseObject(key)
		else
			OnTauntEnd(key)
		end
	end
end

--(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)

local function OnUnitDeath(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)

	for i, data in pairs(db.trackedabilities) do

		local id = data[1]

		local idkey = ZO_CachedStrFormat("<<1>>,<<2>>", targetUnitId, id)

		local key = tauntlist[idkey]

		if key ~= nil then
			pool:ReleaseObject(key)
		end
	end

	for i, id in pairs(db.customabilities) do

		local idkey = ZO_CachedStrFormat("<<1>>,<<2>>", targetUnitId, id)

		local key = tauntlist[idkey]

		if key ~= nil then
			pool:ReleaseObject(key)
		end
	end
end

local function Cleanup()

	if Untaunted.inCombat == false then

		Untaunted.ClearItems()
		em:UnregisterForUpdate("Untaunted_Cleanup")
		return

	end

	local validIds = {}

	local ActiveObjects = pool:GetActiveObjects()

	for key, item in pairs(ActiveObjects) do

		local unitId = item.id or 0
		local endTime = item.endTime or 0

		local now = GetGameTimeMilliseconds()

		if endTime - now > -5000 then validIds[unitId] = true end

	end

	for key, item in pairs(ActiveObjects) do

		local unitId = item.id
		local abilityId = item.abilityId

		if not validIds[unitId] then
			pool:ReleaseObject(key)
		end
	end
end

local function OnCombatState(event, inCombat)  -- called by Event

  if inCombat ~= Untaunted.inCombat then     -- Check if player state changed

	Untaunted.inCombat = inCombat

    if inCombat == true then em:RegisterForUpdate("Untaunted_Cleanup", 500, Cleanup) end

  end
end

local function MoveFrames()
	SCENE_MANAGER:Toggle("UNTAUNTED_MOVE_SCENE")
end

local function SavePosition(control)

	local x, y1 = control:GetScreenRect()
	local y2 = control:GetBottom() - GuiRoot:GetBottom()

	local upwards = db.growthdirection

	local y = upwards and y2 or y1

	x = zo_round(x/dx)*dx
	y = zo_round(y/dx)*dx

	local anchorside = upwards and BOTTOMLEFT or TOPLEFT

	db.window.x=x
	db.window.y=y

	control:ClearAnchors()
	control:SetAnchor(anchorside, GuiRoot, anchorside, x, y)

	lastanchor = {anchorside, control, anchorside, zo_round(4/dx)*dx, zo_round(4/dx)*dx}

end

local function RegisterAbilities()

	local name = Untaunted.name

	for i, data in pairs(db.trackedabilities) do

		local id = data[1]

		em:UnregisterForEvent(name.."_ability_"..id)

		if AbilityCopies[id] then

			for _,id2 in pairs(AbilityCopies[id]) do

				local idstring = name.."_ability_"..id2

				em:UnregisterForEvent(name.."_ability_"..id2)

			end
		end
	end

	ActiveAbilityIdList = {}

	for i, data in pairs(db.trackedabilities) do

		local id, active = unpack(data)

		if active == true then

			local idstring = name.."_ability_"..id

			em:RegisterForEvent(idstring, EVENT_EFFECT_CHANGED, onTaunt)

			ActiveAbilityIdList[id] = true

			local addfilter = {}

			if db.trackonlyplayer and id ~= 134599 and id ~= 39100 and id ~= 52788 then	-- Off Balance Immunity / Minor Magickasteal / Taunt Immune

				table.insert(addfilter, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE)
				table.insert(addfilter, COMBAT_UNIT_TYPE_PLAYER)

			end

			if id==40224 then

				table.insert(addfilter, REGISTER_FILTER_UNIT_TAG)
				table.insert(addfilter, "player")

			end

			em:AddFilterForEvent(idstring, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id, REGISTER_FILTER_IS_ERROR, false, unpack(addfilter))

			if AbilityCopies[id] then

				for _,id2 in pairs(AbilityCopies[id]) do

					local idstring = name.."_ability_"..id2

					ActiveAbilityIdList[id2] = true

					if id2 == 120014 or id2 == 88401 then addfilter = {} end --  Off Balance of Trial Dummy

					em:RegisterForEvent(idstring, EVENT_EFFECT_CHANGED, onTaunt)
					em:AddFilterForEvent(idstring, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id2, REGISTER_FILTER_IS_ERROR, false, unpack(addfilter))

				end
			end
		end
	end

	for i, id in pairs(db.customabilities) do

		em:UnregisterForEvent(name.."_ability_"..id)

	end

	for i, id in pairs(db.customabilities) do

		local idstring = name.."_ability_"..id

		em:RegisterForEvent(idstring, EVENT_EFFECT_CHANGED, onTaunt)

		local addfilter = {}

		if db.trackonlyplayer and id~=134599 then	-- Off Balance Immunity

			table.insert(addfilter, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE)
			table.insert(addfilter, COMBAT_UNIT_TYPE_PLAYER)

		end

		em:AddFilterForEvent(idstring, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id, REGISTER_FILTER_IS_ERROR, false, unpack(addfilter))

		ActiveAbilityIdList[id] = true

	end

	Untaunted.activeIds = ActiveAbilityIdList -- debug exposure
end

local defaults = {

	["window"] 				= {x=150*dx,y=150*dx,height=zo_round(25/dx)*dx,width=zo_round(300/dx)*dx},
	["showmarker"] 			= false,
	["markersize"] 			= 26,
	["growthdirection"] 	= false, --false=down
	["maxbars"] 			= 15, --false=down
	["bardirection"] 		= false, --false=to the left
	["accountwide"] 		= true,
	["trackonlyplayer"]		= true,
	["fontsize"]			= 22,		-- 默认字体大小
	["borderthickness"] 	= 4,		-- 默认边框粗细
	["bordercolor"] 		= {148/255, 143/255, 115/255, 1}, -- 默认边框颜色（黄色）
	["trackedabilities"] 	= {

		{38541, true}, 	-- Taunt
		{52788, true}, 	-- Taunt Immunity
		{17906, false}, 	-- Crusher
		{68588, false}, 	-- Minor Breach (PotL)
		{62787, false}, 	-- Major Breach
		{80020, false}, 	-- Minor Lifesteal
		{39100, false}, 	-- Minor Magickasteal
		{81519, false}, 	-- Minor Vulnerability
		{122389, false}, 	-- Major Vulnerability
		{62988, false}, 	-- Off Balance
		{134599, false}, 	-- Off Balance Immunity
		{17945, false}, 	-- Weakening
		{40224, false}, 	-- Aggresive Horn
		{21763, false}, 	-- Power of the Light
		{44373, false}, 	-- Burning Embers
		{127070, false}, 	-- Way of Martial Knowledge
		{126597, false}, 	-- Touch of Z'en
	},
	["customabilities"] 	= {}

}

AbilityCopies = {

	-- Minor Vulnerability
	[81519] = {51434, 61782, 68359, 79715, 79717, 79720, 79723, 79726, 79843, 79844, 79845, 79846, 117025, 118613, 120030, 124803, 124804, 124806, 130155, 130168, 130173, 130809},
	-- Minor Lifesteal
	[80020] = {86304, 86305, 86307, 88565, 88575, 88606, 92653, 121634, 148043},
	-- Minor Fracture
	[64144] = {79090, 79091, 79309, 79311, 60416, 84358},
	-- Minor Breach
	[68588] = {38688, 61742, 83031, 84358, 108825, 120019, 126685, 146908},
	-- Off Balance
	[62988] = {62968, 39077, 130145, 130129, 130139, 45902, 25256, 34733, 34737, 23808, 20806, 34117, 125750, 131562, 45834, 137257, 137312, 120014},
	-- Major Breach
	[62787] = {28307, 33363, 34386, 36972, 36980, 40254, 48946, 53881, 61743, 62474, 62485, 62775, 78609, 85362, 91175, 91200, 100988, 108951, 111788, 117818, 118438, 120010},
	-- Major Vulnerability
	[122389] = {106754, 106755, 106758, 106760, 106762, 122177, 122397},
	-- Minor Magickasteal
	[39100] = {26220, 26809, 88401, 88402, 88576, 125316, 148044},
	-- Taunt
	[38541] = {38254},

}

local function SetMarker(size)

	if db.showmarker ~= true then return end

	SetFloatingMarkerInfo(MAP_PIN_TYPE_AGGRO, size, "Untaunted/textures/redarrow.dds")
	SetFloatingMarkerGlobalAlpha(1)

end

function Untaunted.ToggleMarkerSize()

	local isEnabled = not db.markerSizeToggleEnabled

	db.markerSizeToggleEnabled = isEnabled
	local newsize = (isEnabled and 2.5 or 1) * db.markersize

	SetMarker(newsize)

end

local function OnPlayerActivated()

	SetMarker(db.markersize)
end

local addonpanel

local function MakeMenu()
    -- load the settings->addons menu library
	local menu = LibAddonMenu2
	if not LibAddonMenu2 then return end
	local def = defaults

    -- the panel for the addons menu
	local panel = {
		type = "panel",
		name = "Untaunted",
		displayName = "Untaunted",
		author = "Solinur",
        version = Untaunted.version or "",
		registerForRefresh = false,
	}

	addonpanel = menu:RegisterAddonPanel("Untaunted_Options", panel)

    --this adds entries in the addon menu
	local options = {
		{
			type = "checkbox",
			name = GetString(SI_UNTAUNTED_MENU_AW_NAME),
			tooltip = GetString(SI_UNTAUNTED_MENU_AW_TOOLTIP),
			default = def.accountwide,
			getFunc = function() return Untaunted_Save.Default[GetDisplayName()]['$AccountWide']["accountwide"] end,
			setFunc = function(value) Untaunted_Save.Default[GetDisplayName()]['$AccountWide']["accountwide"] = value end,
			requiresReload = true,
		},
		{
			type = "button",
			name = GetString(SI_UNTAUNTED_MENU_MOVE_BUTTON),
			tooltip = GetString(SI_UNTAUNTED_MENU_MOVE_BUTTON_TOOLTIP),
			func = MoveFrames,
		},
		{
			type = "slider",
			name = GetString(SI_UNTAUNTED_MENU_WINDOW_WIDTH),
			tooltip = GetString(SI_UNTAUNTED_MENU_WINDOW_WIDTH_TOOLTIP),
			min = 100,
			max = 500,
			step = 10,
			default = def.window.width,
			getFunc = function() return zo_round(db.window.width) end,
			setFunc = function(value)
						db.window.width = zo_round(value/dx)*dx
						Untaunted.ShowItems(addonpanel)
					  end,
		},
		{
			type = "slider",
			name = GetString(SI_UNTAUNTED_MENU_WINDOW_HEIGHT),
			tooltip = GetString(SI_UNTAUNTED_MENU_WINDOW_HEIGHT_TOOLTIP),
			min = 15,
			max = 40,
			step = 1,
			default = def.window.height,
			getFunc = function() return zo_round(db.window.height) end,
			setFunc = function(value)
						db.window.height = zo_round(value/dx)*dx
						Untaunted.ShowItems(addonpanel)
					  end,
		},
		{
			type = "slider",
			name = GetString(SI_UNTAUNTED_MENU_MAX_BARS),
			tooltip = GetString(SI_UNTAUNTED_MENU_MAX_BARS_TOOLTIP),
			min = 5,
			max = 25,
			step = 1,
			default = def.maxbars,
			getFunc = function() return zo_round(db.maxbars) end,
			setFunc = function(value)
						db.maxbars = value
						Untaunted.ShowItems(addonpanel)
					  end,
		},
		-- 字体大小选项
		{
			type = "slider",
			name = "字体大小",
			tooltip = "设置显示文字的字体大小",
			min = 12,
			max = 36,
			step = 1,
			default = def.fontsize,
			getFunc = function() return db.fontsize end,
			setFunc = function(value)
				db.fontsize = value
				Untaunted.ShowItems(addonpanel)
			end,
		},
		-- 边框粗细选项
		{
			type = "slider",
			name = "边框粗细",
			tooltip = "设置边框的粗细（像素）",
			min = 1,
			max = 10,
			step = 1,
			default = def.borderthickness,
			getFunc = function() return db.borderthickness or 1 end,
			setFunc = function(value)
				db.borderthickness = value
				Untaunted.ShowItems(addonpanel)
			end,
		},
		-- 边框颜色选项
		{
			type = "colorpicker",
			name = "边框颜色",
			tooltip = "设置边框的颜色（未选中目标时的颜色）",
			default = def.bordercolor,  -- 默认黄色
			getFunc = function() 
				local color = db.bordercolor or {1, 1, 0, 1}
				return color[1], color[2], color[3], color[4]
			end,
			setFunc = function(r, g, b, a)
				db.bordercolor = {r, g, b, a or 1}
				Untaunted.ShowItems(addonpanel)
			end,
		},
		{
			type = "checkbox",
			name = GetString(SI_UNTAUNTED_MENU_GROWTH_DIRECTION),
			tooltip = GetString(SI_UNTAUNTED_MENU_GROWTH_DIRECTION_TOOLTIP),
			default = def.growthdirection,
			getFunc = function() return db.growthdirection end,
			setFunc = function(value)
				db.growthdirection = value;
				GetGrowthAnchor()
				Untaunted.ShowItems(addonpanel)
				SavePosition(Untaunted_TLW)
			end,
		},
		{
			type = "checkbox",
			name = GetString(SI_UNTAUNTED_MENU_BAR_DIRECTION),
			tooltip = GetString(SI_UNTAUNTED_MENU_BAR_DIRECTION_TOOLTIP),
			default = def.bardirection,
			getFunc = function() return db.bardirection end,
			setFunc = function(value) db.bardirection = value end,
		},
		{
			type = "checkbox",
			name = GetString(SI_UNTAUNTED_MENU_SHOWMARKER),
			tooltip = GetString(SI_UNTAUNTED_MENU_SHOWMARKER_TOOLTIP),
			default = def.showmarker,
			getFunc = function() return db.showmarker end,
			setFunc = function(value) db.showmarker = value end,
			requiresReload = true,
		},
		{
			type = "slider",
			name = GetString(SI_UNTAUNTED_MENU_MARKERSIZE),
			tooltip = GetString(SI_UNTAUNTED_MENU_MARKERSIZE_TOOLTIP),
			min = 16,
			max = 60,
			step = 2,
			default = def.markersize,
			getFunc = function() return db.markersize end,
			setFunc = function(value)

				db.markersize = value
				SetMarker(value)

			end,
		},
		{
			type = "checkbox",
			name = GetString(SI_UNTAUNTED_MENU_TRACKONLYPLAYER),
			tooltip = GetString(SI_UNTAUNTED_MENU_TRACKONLYPLAYER_TOOLTIP),
			default = def.trackonlyplayer,
			getFunc = function() return db.trackonlyplayer end,
			setFunc = function(value)
						db.trackonlyplayer = value
						RegisterAbilities()
					  end,
		},
	}

	for i, data in ipairs(db.trackedabilities) do

		local id = data[1]

		local name = GetAbilityName(id)

		local entry = {

			type = "checkbox",
			name = string.format(GetString(SI_UNTAUNTED_MENU_TRACK), zo_strformat(SI_ABILITY_NAME, name)),
			tooltip = string.format(GetString(SI_UNTAUNTED_MENU_TRACK_TOOLTIP), zo_strformat(SI_ABILITY_NAME, name)),
			default = def.trackedabilities[i][2],
			getFunc = function() return data[2] end,
			setFunc = function(value)
				data[2] = value
				RegisterAbilities()
			end,

		}

		table.insert(options, entry)

	end

	options[#options+1] = {

		type = "editbox",
		name = GetString(SI_UNTAUNTED_MENU_CUSTOM),
		tooltip = GetString(SI_UNTAUNTED_MENU_CUSTOM_TOOLTIP),
		getFunc = function() return table.concat(db.customabilities, ",") end,
		setFunc = function(text)
			db.customabilities = splitCSV(text)
			RegisterAbilities()
		end,
		isMultiline = true,
		isExtraWide = true,
		maxChars = 3000,
		textType = TEXT_TYPE_ALL,
		width = "full",
		default = table.concat(def.customabilities, ","),
	}

	menu:RegisterOptionControls("Untaunted_Options", options)

	function Untaunted.ClearItems()

		if Untaunted.inCombat or SCENE_MANAGER:IsShowingNext("UNTAUNTED_MOVE_SCENE") then return end

		pool:ReleaseAllObjects()

		tauntlist = {}
		tauntdata = {}
	end

	function Untaunted.ShowItems(currentpanel)

		if currentpanel ~= addonpanel and (not SCENE_MANAGER:IsShowing("UNTAUNTED_MOVE_SCENE")) then return end

		Untaunted_TLW:SetHidden(false)
		Untaunted.ClearItems()

		for i=1,db.maxbars do
			NewItem("Unit"..i, i, 38254)
		end
	end

	function Untaunted.SceneEnd(oldstate, newstate)

		if newstate == "hidden" then

			menu:OpenToPanel(addonpanel)
			Untaunted_TLW:SetMovable( false )
			Untaunted_TLW:SetMouseEnabled( false )

		elseif newstate == "shown" then

			Untaunted_TLW:SetMovable( true )
			Untaunted_TLW:SetMouseEnabled( true )

		end
	end

	CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", Untaunted.ShowItems )
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", Untaunted.ClearItems )

	return menu
end

local function UpdateAbilityTable()

	if db.trackedabilities[38541] then	-- convert to new format

		for i = 1, #db.trackedabilities do

			local data = db.trackedabilities[i]

			local oldId = data[1]

			data[2] = db.trackedabilities[oldId]

		end

		for id, _ in pairs(db.trackedabilities) do

			if id > #db.trackedabilities then

				db.trackedabilities[id] = nil

			end
		end

		db.showmarker2 = nil
		db.APIversion = nil
	end

	local newList = {} -- Rebuid ability table if set of abilities has changed

	ZO_DeepTableCopy(defaults.trackedabilities, newList)

	for i = 1, #newList do

		local id = newList[i][1]

		for j = 1, #db.trackedabilities do

			if id == db.trackedabilities[j][1] then

				newList[i][2] = db.trackedabilities[j][2]
				break

			end
		end
	end

	db.trackedabilities = newList

	db.lastversion = Untaunted.version

end

-- Initialization
function Untaunted:Initialize(event, addon)

	local name = self.name

	if addon ~= name then return end --Only run if this addon has been loaded

	-- load saved variables

	local SaveIdString = self.name.."_Save"

	db = ZO_SavedVars:NewAccountWide(SaveIdString, 7, nil, defaults)

	if db.accountwide == false then
		db = ZO_SavedVars:NewCharacterIdSettings(SaveIdString, 7, nil, defaults)
		db.accountwide = false
	end

	if db.lastversion ~= Untaunted.version then UpdateAbilityTable() end

	Untaunted.debug = false
	Untaunted.db = db

	RegisterAbilities()

	--register Events
	em:UnregisterForEvent(name.."_load", EVENT_ADD_ON_LOADED)

	em:RegisterForEvent(name.."_unit", EVENT_COMBAT_EVENT, OnUnitDeath)
	em:AddFilterForEvent(name.."_unit", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, 2260, REGISTER_FILTER_IS_ERROR, false) -- not needed?

	em:RegisterForEvent(name.."_unit2", EVENT_COMBAT_EVENT, OnUnitDeath)
	em:AddFilterForEvent(name.."_unit2", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, 2262, REGISTER_FILTER_IS_ERROR, false)

	em:RegisterForEvent(name.."_combat", EVENT_PLAYER_COMBAT_STATE, OnCombatState)
	em:RegisterForEvent(name.."_target", EVENT_RETICLE_TARGET_CHANGED , OnTargetChange)

	em:RegisterForEvent(name.."active", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

	self.playername = zo_strformat("<<!aC:1>>",GetUnitName("player"))
	self.inCombat = IsUnitInCombat("player")

	MakeMenu()

	local window = Untaunted_TLW

	local anchorside = db.growthdirection and BOTTOMLEFT or TOPLEFT

	if (db.window) then
		window:ClearAnchors()
		window:SetAnchor(anchorside, GuiRoot, anchorside, db.window.x, db.window.y)
	end

	window:SetHandler("OnMoveStop", SavePosition)

	SavePosition(window)

	local fragment = ZO_SimpleSceneFragment:New(window)
	HUD_SCENE:AddFragment(fragment)
	HUD_UI_SCENE:AddFragment(fragment)

	local scene = ZO_Scene:New("UNTAUNTED_MOVE_SCENE", SCENE_MANAGER)
	scene:AddFragment(fragment)
	scene:RegisterCallback("StateChange", Untaunted.SceneEnd)

	Untaunted.ShowItems(addonpanel)
	zo_callLater(Untaunted.ClearItems, 1)
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
em:RegisterForEvent(Untaunted.name.."_load", EVENT_ADD_ON_LOADED, function(...) Untaunted:Initialize(...) end)