local _, addonTable = ...

local select, GetItemInfo, NUM_BAG_SLOTS, pairs, ipairs = select, GetItemInfo, NUM_BAG_SLOTS, pairs, ipairs
local ItemLocation, C_Item, GetInventoryItemLink = ItemLocation, C_Item, GetInventoryItemLink
local table, GetTime, type, GetSpecializationInfo, GetSpecialization = table, GetTime, type, GetSpecializationInfo, GetSpecialization
local GetContainerNumSlots, GetContainerItemLink, GetItemSpecInfo = GetContainerNumSlots, GetContainerItemLink, GetItemSpecInfo
local InCombatLockdown, EquipItemByName, _G, CreateFrame = InCombatLockdown, EquipItemByName, _G, CreateFrame

local itemEquipLocToEquipSlot = addonTable.itemEquipLocToEquipSlot
local levelingItems = addonTable.levelingItems
local bonusToIlvl = addonTable.bonusToIlvl


local scanningTooltip = CreateFrame("GameTooltip", "PoliScanningTooltip", nil, "GameTooltipTemplate")
scanningTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local isBoP = function(itemLink)
    scanningTooltip:ClearLines()
    scanningTooltip:SetHyperlink(itemLink)
    for i=1, scanningTooltip:NumLines() do
        if _G["PoliScanningTooltipTextLeft" .. i]:GetText() == "Binds when picked up" then
            return true
        end
    end
    return false
end

local isSpecItem = function(itemLink)
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

local isBoPEquipableSpecItem = function(itemLink)
    local itemEquipLoc = select(9, GetItemInfo(itemLink))
    if itemEquipLoc ~= "" and itemEquipLocToEquipSlot[itemEquipLoc] then
        if isBoP(itemLink) and isSpecItem(itemLink) then
            return true
        end
    end
    return false
end

local getBagAndSlot = function(itemName)
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

local bonusIlvlEquivalent = function(itemLink)
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

local isUpgrade = function(bagID, slotIndex)
    local mixin = ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
    local itemItemLink = C_Item.GetItemLink(mixin)
    local itemIlvl = C_Item.GetCurrentItemLevel(mixin)
    local itemEquipLoc = select(9, GetItemInfo(itemItemLink))
    local equipSlot = itemEquipLocToEquipSlot[itemEquipLoc]
    if type(equipSlot) == "number" then
        local equipLink = GetInventoryItemLink("player", equipSlot)
        if equipLink == nil then
            return true, equipSlot
        else
            local equipIlvl = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot)) + bonusIlvlEquivalent(equipLink)
            if itemIlvl - equipIlvl > 0 then
                return true, equipSlot
            end
        end
    else
        local equipLink1 = GetInventoryItemLink("player", equipSlot[1])
        local equipLink2 = GetInventoryItemLink("player", equipSlot[2])
        if equipLink1 == nil then
            return true, equipSlot[1]
        elseif equipLink2 == nil then
            return true, equipSlot[2]
        else
            local equipIlvl1 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[1])) + bonusIlvlEquivalent(equipLink1)
            local equipIlvl2 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[2])) + bonusIlvlEquivalent(equipLink2)
            if equipIlvl1 > equipIlvl2 then
                if itemIlvl - equipIlvl2 > 0 then
                    return true, equipSlot[2]
                end
            else
                if itemIlvl - equipIlvl1 > 0 then
                    return true, equipSlot[1]
                end
            end
        end
    end
    return false
end

local questLootReceivedTime, questLootItemLinks
addonTable.QuestRewardEquipAutomation_OnQuestLootReceived = function(_, link)
    if isBoPEquipableSpecItem(link) then
        addonTable.debugPrint("is BOP")
        questLootReceivedTime = GetTime()
        table.insert(questLootItemLinks, link)
    end
end

addonTable.QuestRewardEquipAutomation_OnPlayerEquipmentChanged = function(equipmentSlotIndex)
    if #questLootItemLinks > 0 then
        local itemLoc = ItemLocation:CreateFromEquipmentSlot(equipmentSlotIndex)
        if itemLoc:IsValid() then
            local equippedItemName = C_Item.GetItemName(ItemLocation:CreateFromEquipmentSlot(equipmentSlotIndex))
            addonTable.debugPrint(equippedItemName.." equipped") 
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

local onUpdate = function()
    if #questLootItemLinks > 0 and GetTime() - questLootReceivedTime > 1 and not InCombatLockdown() then
        questLootReceivedTime = GetTime()
        local bagID, slotIndex = getBagAndSlot(GetItemInfo(questLootItemLinks[#questLootItemLinks]))
        -- Can only identify if it is an upgrade if it is found in bag
        addonTable.debugPrint("looking for item")
        if bagID and slotIndex then
            local upgrade, slotID = isUpgrade(bagID, slotIndex)
            if upgrade then
                addonTable.debugPrint("is upgrade. attempting to equip.")
                EquipItemByName(questLootItemLinks[#questLootItemLinks], slotID)
            else
                addonTable.debugPrint("not an upgrade.")
                table.remove(questLootItemLinks)
                if #questLootItemLinks == 0 then
                    questLootReceivedTime = nil
                end
            end
        end
    end
end

local initialize = function()
    questLootItemLinks = {}
    questLootReceivedTime = nil
end

local terminate = function()
    questLootItemLinks = {}
    questLootReceivedTime = nil
end

local questRewardEquipAutomation = {}
questRewardEquipAutomation.name = "QuestRewardEquipAutomation"
questRewardEquipAutomation.events = {
    { "QUEST_LOOT_RECEIVED" },
    { "PLAYER_EQUIPMENT_CHANGED" }
}
questRewardEquipAutomation.onUpdate = onUpdate
questRewardEquipAutomation.initialize = initialize
questRewardEquipAutomation.terminate = terminate
addonTable[questRewardEquipAutomation.name] = questRewardEquipAutomation