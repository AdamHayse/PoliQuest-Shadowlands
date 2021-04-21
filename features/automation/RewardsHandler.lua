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

local function isBoP(itemLink)
    local scanningTooltip = addonTable.util.tooltip
    scanningTooltip:ClearLines()
    scanningTooltip:SetHyperlink(itemLink)
    for i=1, scanningTooltip:NumLines() do
        if _G["PoliScanningTooltipTextLeft" .. i]:GetText() == "Binds when picked up" then
            return true
        end
    end
    return false
end

local function isSpecItem(itemLink)
    local specs = GetItemSpecInfo(itemLink) or {}
    if #specs == 0 then
        return true
    end
    local currentSpec = GetSpecializationInfo(GetSpecialization())
    for _, spec in pairs(specs) do
        if currentSpec == spec then
            return true
        end
    end
    return false
end

local function isBoPEquipableSpecItem(itemLink)
    local itemEquipLoc = select(9, GetItemInfo(itemLink))
    if itemEquipLoc ~= "" and itemEquipLocToEquipSlot[itemEquipLoc] then
        if isBoP(itemLink) and isSpecItem(itemLink) then
            return true
        end
    end
    return false
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

feature.eventHandlers = {}

local questLootReceivedTime, questLootItemLinks
function feature.eventHandlers.onQuestLootReceived(_, link)
    if isBoPEquipableSpecItem(link) then
        debugPrint("is BOP")
        questLootReceivedTime = GetTime()
        table.insert(questLootItemLinks, link)
    end
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
addonTable.features = addonTable.features or {}
addonTable.features.QuestRewardEquipAutomation = feature
