function LibHyper.getTableKeys(t)
    local keys = {}
    for key,_ in pairs(t) do
        table.insert(keys, key)
    end
    return keys
end

function LibHyper.getTableValues(t)
    local values = {}
    for _,value in pairs(t) do
        table.insert(values, value)
    end
    return values
end

function LibHyper.removeGenderIndicator(name) --removes ^n, ^M, ^F etc from string
    local b = string.find(name,"%^")
    if b then
        name = string.sub(name,1,b-1)
    end
    return name
end

function LibHyper.processTimer(time) --adds .0 so that number goes 3.1 -> 3.0 -> 2.9 instead of 3.1 -> 3 -> 2.9
    time = math.floor((time) * 10) / 10
    if time%1 == 0 then
        return time..".0"
    end
    return time
end

function LibHyper.checkIfSkillsSlotted(skillIDTable)
    for _,skillID in pairs(skillIDTable) do
        for i = 3, 8 do
            local slot1 = GetSlotBoundId(i, HOTBAR_CATEGORY_PRIMARY)
            local slot2 = GetSlotBoundId(i, HOTBAR_CATEGORY_BACKUP)
            if skillID == slot1 or skillID == slot2 then
                return true,skillID
            end
        end
    end
    return false,0
end

function LibHyper.deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[LibHyper.deepcopy(orig_key, copies)] = LibHyper.deepcopy(orig_value, copies)
            end
            setmetatable(copy, LibHyper.deepcopy(getmetatable(orig), copies))
        end
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function LibHyper.inArray (array, val)
    for _, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end

function LibHyper.removeFromArray(array, val)
    for i, value in ipairs(array) do
        if value == val then
            table.remove(array, i)
            return
        end
    end
end

--INPUT: Table of itemLinks
--OUTPUT: True if any of the item sets in the table is active, False if none of them is active
function LibHyper.checkIfItemSetsEquipped(itemSetTable)
    if next(itemSetTable) == nil then
        --If input table is empty return true
        return true
    end
    for _, itemSet in pairs(itemSetTable) do
        local numOfItems = 0
        local perfectedNumOfItems= 0
        local setName, maxEquipped
        _, setName, _, numOfItems, maxEquipped,_,perfectedNumOfItems = GetItemLinkSetInfo(itemSet, true) --This function instantly gets number of pieces worn but it ignores offbar
        numOfItems = numOfItems + perfectedNumOfItems

        --Check other bar's gear and add them if the set matches
        local additonalBarToCheck = { EQUIP_SLOT_BACKUP_MAIN, EQUIP_SLOT_BACKUP_OFF } --By default check backbar
        if GetActiveWeaponPairInfo() == ACTIVE_WEAPON_PAIR_BACKUP then
            --If currently on backbar, check frontbar instead
            additonalBarToCheck = { EQUIP_SLOT_MAIN_HAND, EQUIP_SLOT_OFF_HAND }
        end
        for _, v in pairs(additonalBarToCheck) do
            local currentlyCheckedItemSetName
            local incrementBy = 1
            _, currentlyCheckedItemSetName = GetItemLinkSetInfo(GetItemLink(BAG_WORN, v), true)
            if GetItemEquipType(BAG_WORN, additonalBarToCheck[1]) == EQUIP_TYPE_TWO_HAND then
                incrementBy = 2
            end --If item is a two-handed weapon count it twice
            if currentlyCheckedItemSetName == setName then
                numOfItems = numOfItems + incrementBy
            end
        end
        if numOfItems >= maxEquipped then
            return true
        end
    end
    return false
end

function LibHyper.getUnitTagFromCharacterName(characterName)
    characterName = LibHyper.removeGenderIndicator(characterName)
    for i = 1, 12 do
        local unitTag = "group" .. i
        if GetUnitName(unitTag) == characterName then
            return unitTag
        end
    end
end
