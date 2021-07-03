local _, addonTable = ...

local GetTime, InCombatLockdown = GetTime, InCombatLockdown
local util = addonTable.util
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

local globalPrint = print

local function debugPrint(text)
    if DEBUG_REWARDS_HANDLER then
        globalPrint("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function print(text)
    globalPrint("|cFF5c8cc1PoliQuest:|r " .. text)
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
    for equipSlotID, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
        local itemLevelScore = util.compareItemsItemLevel(itemInfo, equippedItemInfo)
        debugPrint("Item Level score for item in equip slot " .. equipSlotID .. ": " .. (itemLevelScore or "nil"))
        if not maxItemLevelScore or itemLevelScore > maxItemLevelScore then
            maxItemLevelScore = itemLevelScore
            maxItemLevelScoreEquipSlotID = equipSlotID
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
    for equipSlotID, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
        local class, score = util.compareItemsSimple(itemInfo, equippedItemInfo, specInfo)
        debugPrint("Simple Weights class and score for item in equip slot " .. equipSlotID .. ": Class: " .. (class or "nil") .. " Score: " .. (score or "nil"))
        if score > 0 and (not maxClass or class > maxClass or class == maxClass and score > maxScore) then
            maxClass = class
            maxScore = score
            maxSimpleScoreEquipSlotID = equipSlotID
        end
    end
    if maxSimpleScoreEquipSlotID then
        return true, maxSimpleScoreEquipSlotID
    else
        return false
    end
end

local function getUpgradeEquipSlotIDPawn(itemInfo, specInfo)
    local scaleName = util.fetchScaleName(specInfo)
    local maxPawnScore, maxPawnScoreEquipSlotID
    for equipSlotID, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
        local pawnScore = util.compareItemsPawn(itemInfo, equippedItemInfo, scaleName)
        debugPrint("Pawn Weights score for item in equip slot " .. equipSlotID .. ": " .. (pawnScore or "nil"))
        if pawnScore == nil then
            debugPrint("Failed to calculate Pawn Weights score for quest reward")
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

local EquipLogic
local function executeEquipLogic(itemInfo, specInfo)
    local pawnSuccess
    if EquipLogic == "Pawn Weights" and specInfo.specIndex ~= 5 then
        local isUpgrade, slotID = getUpgradeEquipSlotIDPawn(itemInfo, specInfo)
        if isUpgrade ~= nil then
            return isUpgrade, slotID
        end
    end
    local itemIsTrinket = util.trinketExists({itemInfo})
    local itemIsWeapon = util.weaponExists({itemInfo})
    if not itemIsTrinket and not itemIsWeapon and (EquipLogic == "Simple Weights" or EquipLogic == "Pawn Weights") then
        return getUpgradeEquipSlotIDSimple(itemInfo, specInfo)
    end
    if EquipLogic == "Item Level" or itemIsTrinket or itemIsWeapon then
        return getUpgradeEquipSlotIDItemLevel(itemInfo)
    end
end

local DoNotEquipOverHeirlooms, DoNotEquipOverSpeedItems, UseItemLevelLogicForTrinkets

local function filterItemsToCompare(itemInfo)
    if DoNotEquipOverHeirlooms then
        util.filterHeirloomItems(itemInfo.itemsToCompare)
    end
    if DoNotEquipOverSpeedItems then
        util.filterSpeedItemItemLinks(itemInfo.itemsToCompare)
    end
end

local function shouldAbortEquipAutomation(itemInfo, specInfo)
    local itemInfoContainer = { itemInfo }
    local itemEquipLoc = itemInfo.itemEquipLoc

    if not util.allItemsAreEquippable(itemInfoContainer) then
        debugPrint("Quest reward equip automation aborted due to unequippable quest reward.")
        return true
    end

    if util.boeExists(itemInfoContainer) then
        print("Quest reward equip automation aborted due to BOE reward.")
        return true
    end
    
    if #util.filterSpecItems(itemInfoContainer, specInfo) == 0 and specInfo.specIndex ~= 5 then
        print("Quest reward equip automation aborted due to reward item not suitable for current specialization.")
        return true
    end

    local numEquipSlots = #itemEquipLocToEquipSlot[itemEquipLoc]
    if DoNotEquipOverHeirlooms and numEquipSlots == util.getNumHeirlooms(itemEquipLoc) then
        debugPrint("Quest reward equip automation aborted due to heirloom item in equip slot.")
        return true
    end

    if DoNotEquipOverSpeedItems and numEquipSlots == util.getNumSpeedItems(itemEquipLoc) then
        debugPrint("Quest reward equip automation aborted due to speed leveling item in equip slot.")
        return true
    end

    if not UseItemLevelLogicForTrinkets and util.trinketExists(itemInfoContainer) then
        print("Quest reward equip automation aborted due to trinket reward. Enable \"Use Item Level Logic for Trinkets\" to automate trinkets in the future.")
        return true
    end

    if util.weaponExists(itemInfoContainer) then
        if util.missingItem(itemInfoContainer) then
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

local function isUpgrade(itemLink)
    local specInfo = util.getCurrentSpecInfo()
    local itemInfo = util.getItemInfo(itemLink, specInfo)
    if shouldAbortEquipAutomation(itemInfo, specInfo) then
        return false
    else
        if util.missingItem({itemInfo}) then
            debugPrint("Item missing from item equip location " .. itemInfo.itemEquipLoc)
            return true, util.missingItemSlotID(itemInfo.itemEquipLoc)
        end
        local equipSlotItemLinks = util.getEquipSlotItemLinks(itemInfo.itemEquipLoc)
        util.addItemsToCompare(itemInfo, util.getEquipSlotItemLinks(itemInfo.itemEquipLoc), specInfo)
        filterItemsToCompare(itemInfo)
        if next(itemInfo.itemsToCompare) == nil then
            debugPrint("No items to compare against due to Quest Reward Equip Automation feature settings.")
            return false
        else
            debugPrint("Equip Logic: " .. (EquipLogic or "nil"))
            return executeEquipLogic(itemInfo, specInfo)
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
        debugPrint("Searching for quest reward...")
        local bagID, slotIndex = getBagAndSlot(GetItemInfo(questLootItemLinks[#questLootItemLinks]))
        -- Can only identify if it is an upgrade if it is found in bag
        if bagID and slotIndex then
            debugPrint("Quest reward found. Bag ID: " .. bagID .. "  Slot Index: " .. slotIndex)
            local mixin = ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
            local itemItemLink = C_Item.GetItemLink(mixin)
            local upgrade, slotID = isUpgrade(itemItemLink)
            if upgrade then
                debugPrint("Equipping over equip slot " .. slotID)
                EquipItemByName(questLootItemLinks[#questLootItemLinks], slotID)
            else
                debugPrint("Quest reward is not an upgrade")
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