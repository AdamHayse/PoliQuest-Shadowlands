local _, addonTable = ...

local GetTime, InCombatLockdown = GetTime, InCombatLockdown

local itemEquipLocToEquipSlot = addonTable.data.itemEquipLocToEquipSlot
local levelingItems = addonTable.data.levelingItems
local bonusToIlvl = addonTable.data.bonusToIlvl

local feature = {}

local DEBUG_REWARDS_HANDLER
function feature.setDebug(enabled)
    DEBUG_REWARDS_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_REWARDS_HANDLER
end

local function debugPrint(text)
    if DEBUG_REWARDS_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function getBagAndSlot(itemName)
    for bagID = 0, NUM_BAG_SLOTS do
        for slotIndex = 1, GetContainerNumSlots(bagID) do
            local containerItemLink = GetContainerItemLink(bagID, slotIndex)
            if containerItemLink and GetItemInfo(containerItemLink) == itemName then
                return bagID, slotIndex
            end
        end
    end
    return nil
end

--[[
local function bonusIlvlEquivalent(itemLink)
    local itemName = GetItemInfo(itemLink)
    for _, v in ipairs(levelingItems) do if itemName == v then return 1000 end end
    local bonus = 0
    if itemName:find("Bit Band") or itemName:find("Logic Loop") then
        bonus = 20
    end
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local _, enchant, gem1, gem2, gem3, gem4 = string.split(":", itemString)
    bonus = bonus + bonusToIlvl[tonumber(enchant)] + bonusToIlvl[tonumber(gem1)] + bonusToIlvl[tonumber(gem2)] + bonusToIlvl[tonumber(gem3)] + bonusToIlvl[tonumber(gem4)]
    return bonus
end

local function isUpgrade(bagID, slotIndex)
    local mixin = ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
    local itemItemLink = C_Item.GetItemLink(mixin)
    local itemIlvl = C_Item.GetCurrentItemLevel(mixin)
    local itemEquipLoc = select(9, GetItemInfo(itemItemLink))
    local equipSlots = itemEquipLocToEquipSlot[itemEquipLoc]
    if #equipSlots == 1 then
        local equipLink = GetInventoryItemLink("player", equipSlots[1])
        if equipLink == nil then
            return true, equipSlots[1]
        else
            local equipIlvl = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlots[1])) + bonusIlvlEquivalent(equipLink)
            if itemIlvl - equipIlvl > 0 then
                return true, equipSlots[1]
            end
        end
    else
        local equipLink1 = GetInventoryItemLink("player", equipSlots[1])
        local equipLink2 = GetInventoryItemLink("player", equipSlots[2])
        if equipLink1 == nil then
            return true, equipSlots[1]
        elseif equipLink2 == nil then
            return true, equipSlots[2]
        else
            local equipIlvl1 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlots[1])) + bonusIlvlEquivalent(equipLink1)
            local equipIlvl2 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlots[2])) + bonusIlvlEquivalent(equipLink2)
            if equipIlvl1 > equipIlvl2 then
                if itemIlvl - equipIlvl2 > 0 then
                    return true, equipSlots[2]
                end
            else
                if itemIlvl - equipIlvl1 > 0 then
                    return true, equipSlots[1]
                end
            end
        end
    end
    return false
end
]]

local function getUpgradeEquipSlotIDItemLevel(itemInfo)
    local maxItemLevelScore, maxItemLevelScoreEquipSlotID
    if util.missingItem({itemInfo}) then
        return true, util.missingItemSlotID(itemInfo.itemEquipLoc)
    else
        for equipSlotID, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
            local itemLevelScore = util.compareItemsItemLevel(itemInfo, equippedItemInfo)
            if not maxItemLevelScore or itemLevelScore > maxItemLevelScore then
                maxItemLevelScore = itemLevelScore
                maxItemLevelScoreEquipSlotID = equipSlotID
            end
        end
    end
    if maxItemLevelScore > 0 then
        return true, maxItemLevelScoreEquipSlotID
    else
        return false
    end
end

local function getUpgradeEquipSlotIDSimple(itemInfo, specInfo)
    local maxClass, maxScore, maxSimpleScoreEquipSlotID
    if util.missingItem({itemInfo}) then
        return true, util.missingItemSlotID(itemInfo.itemEquipLoc)
    else
        util.addItemsToCompare(itemInfo, util.getEquipSlotItemLinks(itemInfo.itemEquipLoc), specInfo)
        for equipSlotID, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
            local class, score = util.compareItemsSimple(itemInfo, equippedItemInfo, specInfo)
            if score > 0 and (not maxClass or class > maxClass or class == maxClass and score > maxScore) then
                maxClass = class
                maxScore = score
                maxSimpleScoreEquipSlotID = equipSlotID
            end
        end
    end
    if maxSimpleScoreEquipSlotID then
        return true, maxSimpleScoreEquipSlotID
    else
        return false
    end
end

local function getUpgradeEquipSlotIDPawnWeapon(itemInfo, scaleName)
    local equipSlotItemLinks = util.getValidEquipSlotItemLinks(itemInfo.itemEquipLoc)
    util.addItemsToCompare(itemInfo, equipSlotItemLinks, specInfo)
    if DoNotEquipOverHeirlooms then
        util.filterHeirloomItems(itemInfo.itemsToCompare)
    end
    if DoNotEquipOverSpeedItems then
        util.filterSpeedItemItemLinks(itemInfo.itemsToCompare)
    end
    if #itemInfo.itemsToCompare == 0 then
        return false
    else
        local maxPawnScore, maxPawnScoreEquipSlotID
        for equipSlotID, equippedItemInfo in ipairs(itemInfo.itemsToCompare) do
            local pawnScore = util.compareItemsPawn(itemInfo, equippedItemInfo, scaleName)
            if pawnScore == nil then
                return nil
            elseif not maxPawnScore or pawnScore > maxPawnScore then
                maxPawnScore = pawnScore
                maxPawnScoreEquipSlotID = equipSlotID
            end
        end
        if maxPawnScore > 0 then
            return true, maxPawnScoreEquipSlotID
        else
            return false
        end
    end
end

local function getUpgradeEquipSlotIDPawn(itemInfo, specInfo)
    local scaleName = util.fetchScaleName(specInfo)
    -- if item is a weapon, return special weapon function
    if util.weaponExists({itemInfo}) then
        return getUpgradeEquipSlotIDPawnWeapon(itemInfo, scaleName)
    else
        local maxPawnScore, maxPawnScoreEquipSlotID
        if util.missingItem({itemInfo}) then
            return true, util.missingItemSlotID(itemInfo.itemEquipLoc)
        else
            util.addItemsToCompare(itemInfo, util.getEquipSlotItemLinks(itemInfo.itemEquipLoc), specInfo)
            for equipSlotID, equippedItemInfo in ipairs(itemInfo.itemsToCompare) do
                local pawnScore = util.compareItemsPawn(itemInfo, equippedItemInfo, scaleName)
                if pawnScore == nil then
                    return nil
                elseif not maxPawnScore or pawnScore > maxPawnScore then
                    maxPawnScore = pawnScore
                    maxPawnScoreEquipSlotID = equipSlotID
                end
            end
        end
        if maxPawnScore > 0 then
            return true, maxPawnScoreEquipSlotID
        else
            return false
        end
    end
end

local DoNotEquipOverHeirlooms, DoNotEquipOverSpeedItems, UseItemLevelLogicForTrinkets

local function shouldAbortEquipAutomation(itemInfo, specInfo)
    local itemInfoContainer = { itemInfo }
    local itemEquipLoc = itemInfo.itemEquipLoc

    if not util.allItemsAreEquippable(itemInfoContainer) then
        return true
    end

    if util.boeExists(itemInfoContainer) then
        print("|cFF5c8cc1PoliQuest:|r Quest reward equip automation aborted due to BOE reward.")
        return true
    end
    
    if #util.filterSpecItems(itemInfoContainer, specInfo) == 0 and specInfo.specIndex ~= 5 then
        print("|cFF5c8cc1PoliQuest:|r Quest reward equip automation aborted due to reward item not suitable for current specialization.")
        return true
    end

    if #itemEquipLocToEquipSlot[itemEquipLoc] == util.getNumHeirlooms(itemEquipLoc) and DoNotEquipOverHeirlooms then
        debugPrint("Quest reward equip automation aborted due to heirloom item in equip slot.")
        return true
    end

    if #itemEquipLocToEquipSlot[itemEquipLoc] == util.getNumSpeedItems(itemEquipLoc) and DoNotEquipOverSpeedItems then
        debugPrint("Quest reward equip automation aborted due to speed leveling item in equip slot.")
        return true
    end

    if util.trinketExists(itemInfoContainer) and not UseItemLevelLogicForTrinkets then
        print("|cFF5c8cc1PoliQuest:|r Quest reward equip automation aborted due to trinket reward. Enable \"Use Item Level Logic for Trinkets\" to automate trinkets in the future.")
        return true
    end

    if util.weaponExists(itemInfoContainer) then
        if util.missingWeapon(itemEquipLoc) then
            print("Quest reward equip automation aborted due to item missing from equip slot.")
            return true
        end
        if util.weaponDiscrepancy(itemEquipLoc) then
            print("Quest reward equip automation aborted due to discrepancy between reward item type and equipped item type.")
            return true
        end
    end

    return false
end

local EquipLogic
local function isUpgrade(itemLink)
    local specInfo = util.getCurrentSpecInfo()
    local itemInfo = util.getItemInfo(itemLink, specInfo)
    if shouldAbortEquipAutomation(itemInfo, specInfo) then
        return false
    else
        local pawnSuccess
        if EquipLogic == "Pawn" then
            local isUpgrade, slotID = getUpgradeEquipSlotIDPawn(itemInfo, specInfo)
            if isUpgrade ~= nil then
                return isUpgrade, slotID
            end
        end
        local itemIsTrinket, itemIsWeapon = util.trinketExists({itemInfo}), util.weaponExists({itemInfo})
        if not itemIsTrinket and not itemIsWeapon and (EquipLogic == "Simple" or EquipLogic == "Pawn") then
            return getUpgradeEquipSlotIDSimple(itemInfo, specInfo)
        end
        if EquipLogic == "ItemLevel" or itemIsTrinket or itemIsWeapon then
            return getUpgradeEquipSlotIDItemLevel(itemInfo)
        end
    end
end

feature.eventHandlers = {}

local questLootReceivedTime, questLootItemLinks
function feature.eventHandlers.onQuestLootReceived(_, link)
    questLootReceivedTime = GetTime()
    table.insert(questLootItemLinks, link)
end

function feature.eventHandlers.onPlayerEquipmentChanged(equipmentSlotIndex)
    if #questLootItemLinks > 0 then
        local itemLoc = ItemLocation:CreateFromEquipmentSlot(equipmentSlotIndex)
        if itemLoc:IsValid() then
            local equippedItemName = C_Item.GetItemName(ItemLocation:CreateFromEquipmentSlot(equipmentSlotIndex))
            debugPrint(equippedItemName.." equipped") 
            for i, v in ipairs(questLootItemLinks) do
                if equippedItemName == GetItemInfo(v) then
                    table.remove(questLootItemLinks, i)
                end
            end
            if #questLootItemLinks == 0 then
                questLootReceivedTime = nil
            end
        end
    end
end

local function onUpdate()
    if #questLootItemLinks > 0 and GetTime() - questLootReceivedTime > 1 and not InCombatLockdown() then
        questLootReceivedTime = GetTime()
        local bagID, slotIndex = getBagAndSlot(GetItemInfo(questLootItemLinks[#questLootItemLinks]))
        -- Can only identify if it is an upgrade if it is found in bag
        debugPrint("looking for item")
        if bagID and slotIndex then
            local upgrade, slotID = isUpgrade(bagID, slotIndex)
            if upgrade then
                debugPrint("is upgrade. attempting to equip.")
                EquipItemByName(questLootItemLinks[#questLootItemLinks], slotID)
            else
                debugPrint("not an upgrade.")
                table.remove(questLootItemLinks)
                if #questLootItemLinks == 0 then
                    questLootReceivedTime = nil
                end
            end
        end
    end
end

local function initialize()
    questLootItemLinks = {}
    questLootReceivedTime = nil
end

local function terminate()
    questLootItemLinks = {}
    questLootReceivedTime = nil
end

feature.updateHandler = onUpdate
feature.initialize = initialize
feature.terminate = terminate
function feature.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. tostring(value))
    if switchName == "EquipLogic" then
        EquipLogic = value == 1 and "Simple Weights" or (value == 2 and "Pawn Weights" or (value == 3 and "Item Level" or nil))
    elseif switchName == "DoNotEquipOverHeirlooms" then
        DoNotEquipOverHeirlooms = value
    elseif switchName == "DoNotEquipOverSpeedItems" then
        DoNotEquipOverSpeedItems = value
    elseif switchName == "UseItemLevelLogicForTrinkets" then
        UseItemLevelLogicForTrinkets = value
    end
end
addonTable.features = addonTable.features or {}
addonTable.features.QuestRewardEquipAutomation = feature