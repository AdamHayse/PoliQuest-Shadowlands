local _, addonTable = ...

addonTable.util = addonTable.util or {}

local itemEquipLocToEquipSlot = addonTable.data.itemEquipLocToEquipSlot
local speedItems = addonTable.data.speedItems

local util = addonTable.util

local statIndexToStatConstant = {
    [1] = "ITEM_MOD_STRENGTH_SHORT",
    [2] = "ITEM_MOD_AGILITY_SHORT",
    [4] = "ITEM_MOD_INTELLECT_SHORT"
}

-- Defaults to current spec if no loot spec selected
function util.getLootSpecInfo()
    local lootSpecID = GetLootSpecialization()
    if lootSpecID == 0 then
        return util.getCurrentSpecInfo()
    else
        local lootSpecInfo = {}
        lootSpecInfo.specID = lootSpecID
        lootSpecInfo.specIndex = lootSpecID  - GetSpecializationInfo(1) + 1
        lootSpecInfo.specPrimaryStatConstant = statIndexToStatConstant[select(6, GetSpecializationInfo(lootSpecInfo.specIndex))]
        return lootSpecInfo
    end
end

function util.getCurrentSpecInfo()
    local currentSpecInfo = {}
    currentSpecInfo.specID = GetSpecializationInfo(GetSpecialization())
    currentSpecInfo.specIndex = GetSpecialization()
    currentSpecInfo.specPrimaryStatConstant = statIndexToStatConstant[select(6, GetSpecializationInfo(currentSpecInfo.specIndex))]
    return currentSpecInfo
end

local localizedPrimaryStat = {
    ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT,
    ITEM_MOD_AGILITY_SHORT = ITEM_MOD_AGILITY_SHORT,
    ITEM_MOD_INTELLECT_SHORT = ITEM_MOD_INTELLECT_SHORT
}

-- gets all stats (including inactive primary stat that might be relevant for the current loot spec)
local function collectItemStats(itemLink, specInfo)
    local specPrimaryStatConstant = specInfo.specPrimaryStatConstant
    local stats = {}
    GetItemStats(itemLink, stats)
    if not stats[specPrimaryStatConstant] then
        local scanningTooltip = addonTable.util.tooltip
        scanningTooltip:ClearLines()
        scanningTooltip:SetHyperlink(itemLink)
        for i=1, scanningTooltip:NumLines() do
            local line = _G["PoliScanningTooltipTextLeft" .. i]:GetText()
            if line:find(localizedPrimaryStat[specPrimaryStatConstant] .. "$") then
                stats[specPrimaryStatConstant] = tonumber(line:match("(+?-?%d+) ".. specPrimaryStatConstant .. "$"))
            end
        end
    end
    return stats
end

function util.getItemInfo(itemLink, specInfo, index)
    local itemEquipLoc, _, vendorPrice = select(9, GetItemInfo(itemLink))
    return {
        index = index,
        itemLink = itemLink,
        itemEquipLoc = itemEquipLoc,
        itemLevel = GetDetailedItemLevelInfo(itemLink),
        vendorPrice = vendorPrice,
        stats = collectItemStats(itemLink, specInfo)
    }
end

-- returns hashmap of equipslots and corresponding itemLinks (nil for ones that don't exist)
function util.getEquipSlotItemLinks(itemEquipLoc)
    local equipSlotIDs = itemEquipLocToEquipSlot[itemEquipLoc]
    local itemLinks = {}
    for _, slotID in ipairs(equipSlotIDs) do
        itemLinks[slotID] = GetInventoryItemLink("player", slotID)
    end
    return itemLinks
end

-- The second part of the conditional in this function accounts for currency rewards that the game says are equippable even though they aren't
function util.allItemsAreEquippable(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        if itemInfo.itemEquipLoc == "" or itemInfo.index and GetQuestItemInfoLootType("choice", itemInfo.index) == 1 then
            return false
        end
    end
    return true
end

function util.getHighestItemLevel(itemInfoList)
    local highestItemLevel
    for _, itemInfo in ipairs(itemInfoList) do
        if itemInfo.itemLevel > (highestItemLevel or 0) then
            highestItemLevel = itemInfo.itemLevel
        end
    end
    return highestItemLevel
end

-- No side effects on itemInfoList
function util.filterSpecItems(itemInfoList, specInfo)
    local specItemInfoList = {}
    local specID = specInfo.specID
    for _, itemInfo in ipairs(itemInfoList) do
        local specTable = GetItemSpecInfo(itemInfo.itemLink) or {}
        local containsLootSpec = false
        for _, v in ipairs(specTable) do
            if v == specID then
                containsLootSpec = true
                break
            end
        end
        if #specTable == 0 or containsLootSpec then
            table.insert(specItemInfoList, itemInfo)
        end
    end
    return specItemInfoList
end

function util.missingItem(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        local equipSlotIDs = itemEquipLocToEquipSlot[itemInfo.itemEquipLoc]
        local equipSlotItemLinks = util.getEquipSlotItemLinks(itemInfo.itemEquipLoc)
        for _, equipSlotID in ipairs(equipSlotIDs) do
            if not equipSlotItemLinks[equipSlotID] then
                return true
            end
        end
    end
    return false
end

function util.socketExists(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        local stats = itemInfo.stats
        for stat in pairs(stats) do
            if stat:find("SOCKET") then
                return true
            end
        end
    end
    return false
end

function util.trinketExists(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        if itemInfo.itemEquipLoc == "INVTYPE_TRINKET" then
            return true
        end
    end
    return false
end

function util.weaponExists(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        local itemEquipLoc = itemInfo.itemEquipLoc
        if itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_SHIELD"
        or itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_2HWEAPON"
        or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND"
        or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_THROWN" then
            return true
        end
    end
    return false
end

function util.shirtExists(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        if itemInfo.itemEquipLoc == "INVTYPE_BODY" then
            return true
        end
    end
    return false
end

function util.tabardExists(itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        if itemInfo.itemEquipLoc == "INVTYPE_TABARD" then
            return true
        end
    end
    return false
end

function util.boeExists(itemInfoList)
    local boeText = _G["ITEM_BIND_ON_EQUIP"]
    local scanningTooltip = addonTable.util.tooltip
    for _, itemInfo in ipairs(itemInfoList) do
        scanningTooltip:ClearLines()
        scanningTooltip:SetHyperlink(itemInfo.itemLink)
        for i=1, scanningTooltip:NumLines() do
            if _G["PoliScanningTooltipTextLeft" .. i]:GetText() == boeText then
                return true
            end
        end
    end
    return false
end

function util.getNumHeirlooms(itemEquipLoc)
    local count = 0
    for _, equipSlotID in ipairs(itemEquipLocToEquipSlot[itemEquipLoc]) do
        local itemLink = GetInventoryItemLink("player", equipSlotID)
        if select(3, GetItemInfo(itemLink)) == 7 then
            count = count + 1
        end
    end
    return count
end

function util.getNumSpeedItems(itemEquipLoc)
    local count = 0
    for _, equipSlotID in ipairs(itemEquipLocToEquipSlot[itemEquipLoc]) do
        local itemLink = GetInventoryItemLink("player", equipSlotID)
        if itemLink then
            local itemID = tonumber(itemLink:match("item:(%d+)"))
            if speedItems[itemID] then
                count = count + 1
            end
        end
    end
    return count
end

function util.missingWeapon(itemEquipLoc)
    if itemEquipLoc == "INVTYPE_WEAPON" then
        return GetInventoryItemLink("player", 16) == nil or GetInventoryItemLink("player", 17) == nil and CanDualWield()
    elseif itemEquipLoc == "INVTYPE_SHIELD" then
        return GetInventoryItemLink("player", 17) == nil
    elseif itemEquipLoc == "INVTYPE_2HWEAPON" then
        return GetInventoryItemLink("player", 16) == nil or GetInventoryItemLink("player", 17) == nil and IsSpellKnown(46917)
    elseif itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
        return GetInventoryItemLink("player", 16) == nil
    elseif itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then
        return GetInventoryItemLink("player", 17) == nil
    elseif itemEquipLoc == "INVTYPE_HOLDABLE" then
        return GetInventoryItemLink("player", 17) == nil
    elseif itemEquipLoc == "INVTYPE_RANGED" then
        return GetInventoryItemLink("player", 16) == nil
    end
end

function util.weaponDiscrepancy(itemEquipLoc)
    local slot16Link, slot17Link = GetInventoryItemLink("player", 16), GetInventoryItemLink("player", 17)
    local itemEquipLoc16 = slot16Link and select(9, GetItemInfo(slot16Link))
    local itemEquipLoc17 = slot17Link and select(9, GetItemInfo(slot17Link))
    if itemEquipLoc == "INVTYPE_WEAPON" then
        return itemEquipLoc16 ~= "INVTYPE_WEAPON" and itemEquipLoc16 ~= "INVTYPE_WEAPONMAINHAND"
        or CanDualWield() and itemEquipLoc17 ~= "INVTYPE_WEAPON" and itemEquipLoc17 ~= "INVTYPE_WEAPONOFFHAND"
    elseif itemEquipLoc == "INVTYPE_SHIELD" then
        return itemEquipLoc17 ~= "INVTYPE_SHIELD"
    elseif itemEquipLoc == "INVTYPE_2HWEAPON" then
        return itemEquipLoc16 ~= "INVTYPE_2HWEAPON" or IsSpellKnown(46917) and itemEquipLoc17 ~= "INVTYPE_2HWEAPON"
    elseif itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
        return itemEquipLoc16 ~= "INVTYPE_WEAPONMAINHAND" and itemEquipLoc16 ~= "INVTYPE_WEAPON"
    elseif itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then
        return itemEquipLoc17 ~= "INVTYPE_WEAPONOFFHAND" and itemEquipLoc17 ~= "INVTYPE_WEAPON"
    elseif itemEquipLoc == "INVTYPE_HOLDABLE" then
        return itemEquipLoc17 ~= "INVTYPE_HOLDABLE"
    elseif itemEquipLoc == "INVTYPE_RANGED" then
        return itemEquipLoc17 ~= "INVTYPE_RANGED"
    end
end

function util.addItemsToCompare(itemInfo, itemLinks, specInfo)
    local itemsToCompare = {}
    for equipSlotID, itemLink in pairs(itemLinks) do
        itemsToCompare[equipSlotID] = util.getItemInfo(itemLink, specInfo)
    end
    itemInfo.itemsToCompare = itemsToCompare
end

function util.compareItemsItemLevel(itemInfo1, itemInfo2)
    return itemInfo1.itemLevel - itemInfo2.itemLevel
end

util.cachedPawnScores = {}

function util.emptyPawnScoresCache()
    wipe(util.cachedPawnScores)
end

function util.fetchScaleName(specInfo)
    local classID = select(3, UnitClass("player"))
    for ScaleName, Scale in pairs(PawnCommon.Scales) do
        if Scale.ClassID == classID and Scale.SpecID == specInfo.specIndex and Scale.Provider ~= nil then
            return ScaleName
        end
    end
end

function util.getPawnScore(itemInfo, scaleName)
    local cachedScore = util.cachedPawnScores[itemInfo.itemLink]
    if cachedScore then
        return cachedScore
    else
        local pawnScore = PawnGetSingleValueFromItem(PawnGetItemData(itemInfo.itemLink), scaleName)
        util.cachedPawnScores[itemInfo.itemLink] = pawnScore
        return pawnScore
    end
end

-- return nil if comparison fails
function util.compareItemsPawn(itemInfo1, itemInfo2, scaleName)
    local score1 = util.getPawnScore(itemInfo1, scaleName)
    local score2 = util.getPawnScore(itemInfo2, scaleName)
    if score1 == nil or score2 == nil then
        return nil
    else
        return score1 - score2
    end
end

local function calculateStatScore(itemStats, specInfo)
    local primary = itemStats[specInfo.specPrimaryStatConstant] or 0
    local crit = itemStats.ITEM_MOD_CRIT_RATING_SHORT or 0
    local mastery = itemStats.ITEM_MOD_MASTERY_RATING_SHORT or 0
    local versatility = itemStats.ITEM_MOD_VERSATILITY or 0
    local haste = itemStats.ITEM_MOD_HASTE_RATING_SHORT or 0
    return 2 * primary + crit + mastery + versatility + haste
end

function util.getSimpleScore(itemInfo, specInfo)
    local stats = itemInfo.stats
    local statScore = calculateStatScore(stats, specInfo)
    if statScore ~= 0 then
        return 9, statScore
    end
    local stamScore = stats.ITEM_MOD_STAMINA_SHORT or 0
    if stamScore ~= 0 then
        return 8, stamScore
    end
    local armorScore = stats.RESISTANCE0_NAME or 0
    if armorScore ~= 0 then
        return 7, armorScore
    end
end

function util.compareItemsSimple(itemInfo1, itemInfo2, specInfo)
    local class1, score1 = util.getSimpleScore(itemInfo1, specInfo)
    local class2, score2 = util.getSimpleScore(itemInfo2, specInfo)

    if class1 == 9 then
        if class2 < 9 then
            return 9, score1
        else
            local score = score1 - score2
            if score > 0 then
                return 9, score
            else
                return 6, score
            end
        end
    elseif class1 == 8 then
        if class2 == 7 then
            return 8, score1
        elseif class2 == 8 then
            local score = score1 - score2
            if score > 0 then
                return 8, score
            else
                return 5, score
            end
        else
            return 3, score1
        end
    else
        if class2 == 7 then
            local score = score1 - score2
            if score > 0 then
                return 7, score
            else
                return 4, score
            end
        elseif class2 == 8 then
            return 2, score1
        else
            return 1, score1
        end
    end
end

-- Returns the first equipSlotID for itemEquipLoc where no item is equipped
function util.missingItemSlotID(itemEquipLoc)
    local equipSlotIDs = itemEquipLocToEquipSlot[itemEquipLoc]
    for _, equipSlotID in ipairs(equipSlotIDs) do
        if GetInventoryItemLink("player", equipSlotID) == nil then
            return equipSlotID
        end
    end
end

function util.getValidEquipSlotItemLinks(itemEquipLoc)
    local equipSlotIDs = itemEquipLocToEquipSlot[itemEquipLoc]
    if itemEquipLoc == "INVTYPE_2HWEAPON" and IsSpellKnown(46917) then
        table.insert(equipSlotIDs, 17)
    end
    if itemEquipLoc == "INVTYPE_WEAPON" and not CanDualWield() then
        table.remove(equipSlotIDs)
    end
    local itemLinks = {}
    for _, equipSlotID in ipairs(equipSlotIDs) do
        itemLinks[equipSlotID] = GetInventoryItemLink("player", equipSlotID)
    end
    return itemLinks
end

function util.filterHeirloomItems(itemsToCompare)
    for equipSlotID, itemInfo in pairs(itemsToCompare) do
        if select(3, GetItemInfo(itemInfo.itemLink)) == 7 then
            itemsToCompare[equipSlotID] = nil
        end
    end
end

function util.filterSpeedItems(itemsToCompare)
    for equipSlotID, itemInfo in pairs(itemsToCompare) do
        local itemID = tonumber(itemLink:match("item:(%d+)"))
        if speedItems[itemID] then
            itemsToCompare[equipSlotID] = nil
        end
    end
end