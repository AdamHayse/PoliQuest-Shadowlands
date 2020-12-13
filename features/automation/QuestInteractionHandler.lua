local _, addonTable = ...

local select, type, max, smatch, spplit, tonumber, pairs, ipairs, tinsert, slower, print = select, type, math.max, string.match, string.split, tonumber, pairs, ipairs, table.insert, string.lower, print
local GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink = GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink
local GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization = GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization
local GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization = C_Item.GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization
local GetActiveQuests, SelectActiveQuest, GetAvailableQuests, SelectAvailableQuest = C_GossipInfo.GetActiveQuests, C_GossipInfo.SelectActiveQuest, C_GossipInfo.GetAvailableQuests, C_GossipInfo.SelectAvailableQuest
local GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo = GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo
local AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp = AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp
local QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame = QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame
local AutoQuestPopUpTracker_OnMouseDown, CAMPAIGN_QUEST_TRACKER_MODULE, AutoQuestPopUpTracker_OnMouseDown, CAMPAIGN_QUEST_TRACKER_MODULE

local itemEquipLocToEquipSlot = addonTable.itemEquipLocToEquipSlot
local questNames = addonTable.questNames
local questIDToName = addonTable.questIDToName
local bonusToIlvl = addonTable.bonusToIlvl

local function debugPrint(text)
    if DEBUG_QUEST_INTERACTION_HANDLER then
        print("|cFF5c8cc1PoliQuest:|r " .. text)
    end
end

local function calculateStatIncrease(itemLink)
    local equipSlot = select(9, GetItemInfo(itemLink))
    local potentialDestSlots = itemEquipLocToEquipSlot[equipSlot]
    if potentialDestSlots then
        if type(potentialDestSlots) == "number" then
            local currentItemLink = GetInventoryItemLink("player", potentialDestSlots)
            if currentItemLink == nil then
                return nil
            else
                local statDifferences = GetItemStatDelta(itemLink, currentItemLink)
                if potentialDestSlots == 1 or potentialDestSlots == 2 or potentialDestSlots == 3 or potentialDestSlots == 5
                or potentialDestSlots == 6 or potentialDestSlots == 7 or potentialDestSlots == 8 or potentialDestSlots == 9
                or potentialDestSlots == 10 or potentialDestSlots == 15 or potentialDestSlots == 16 or potentialDestSlots == 17 then
                    return statDifferences.ITEM_MOD_STAMINA_SHORT
                end
            end
        else
            if potentialDestSlots[1] == 13 then
                return nil
            end
            local slot1Link = GetInventoryItemLink("player", potentialDestSlots[1])
            local slot2Link = GetInventoryItemLink("player", potentialDestSlots[2])
            if slot1Link == nil or slot2Link == nil then
                return nil
            else
                local statDif1 = GetItemStatDelta(itemLink, slot1Link)
                local statDif2 = GetItemStatDelta(itemLink, slot2Link)
                return max(statDif1.ITEM_MOD_STAMINA_SHORT or 0, statDif2.ITEM_MOD_STAMINA_SHORT or 0)
            end
        end
    end
end

local function getItemsDetails(numChoices)
    local itemDetails = {}
    for i=1, numChoices do
        local itemLink = GetQuestItemLink("choice", i)
        local itemEquipLoc, _, vendorPrice = select(9, GetItemInfo(itemLink))
        if itemEquipLoc == "" then
            return nil
        end
        table.insert(itemDetails, {
            choiceIndex = i,
            equipSlot = itemEquipLocToEquipSlot[itemEquipLoc],
            ilvl = GetDetailedItemLevelInfo(itemLink),
            specs = GetItemSpecInfo(itemLink) or {},
            statIncrease = calculateStatIncrease(itemLink),
            vendorPrice = vendorPrice
        })
    end
    return itemDetails
end

local function bonusIlvlEquivalent(itemLink)
    local itemName = GetItemInfo(itemLink)
    local bonus = 0
    if itemName:find("Bit Band") or itemName:find("Logic Loop") then
        bonus = 20
    end
    local itemString = smatch(itemLink, "item[%-?%d:]+")
    local _, _, gem1, gem2, gem3, gem4 = ssplit(":", itemString)
    if bonusToIlvl[tonumber(gem1)] then bonus = bonus + 7.1 end
    if bonusToIlvl[tonumber(gem2)] then bonus = bonus + 7.1 end
    if bonusToIlvl[tonumber(gem3)] then bonus = bonus + 7.1 end
    if bonusToIlvl[tonumber(gem4)] then bonus = bonus + 7.1 end
    return bonus
end

local function calcIlvlDifference(itemDetails)
    local itemIlvl = itemDetails.ilvl
    local equipSlot = itemDetails.equipSlot
    if type(equipSlot) == "number" then
        return itemIlvl - (GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot)) + bonusIlvlEquivalent(GetInventoryItemLink("player", equipSlot)))
    else
        local ilvl1 = GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[1])) + bonusIlvlEquivalent(GetInventoryItemLink("player", equipSlot[1]))
        local ilvl2 = GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[2])) + bonusIlvlEquivalent(GetInventoryItemLink("player", equipSlot[2]))
        return ilvl1 > ilvl2 and itemIlvl - ilvl2 or itemIlvl - ilvl1
    end
end

local function missingItem(itemsDetails)
    for k, v in pairs(itemsDetails) do
        local equipSlot = v.equipSlot
        if type(equipSlot) == "number" then
            if GetInventoryItemLink("player", equipSlot) == nil then
                return true
            end
        else
            if GetInventoryItemLink("player", equipSlot[1]) == nil or GetInventoryItemLink("player", equipSlot[2]) == nil then
                return true
            end
        end
    end
    return false
end

local function getLargestSpecUpgrade(itemsDetails, lootSpec)
    local specItemsDetails = {}
    for _, v in ipairs(itemsDetails) do
        local specs = v.specs
        if #specs == 0 then
            tinsert(specItemsDetails, v)
        else
            for i=1, #specs do
                if specs[i] == lootSpec then
                    tinsert(specItemsDetails, v)
                    break
                end
            end
        end
    end
    if #specItemsDetails == 0 then
        return nil
    elseif #specItemsDetails == 1 then
        return specItemsDetails
    elseif missingItem(specItemsDetails) then
        return nil
    else
        local largest = { specItemsDetails[1] }
        local largestDifference = calcIlvlDifference(specItemsDetails[1])
        for i=2, #specItemsDetails do
            local difference = calcIlvlDifference(specItemsDetails[i])
            if difference > largestDifference then
                largest = { specItemsDetails[i] }
                largestDifference = difference
            elseif difference == largestDifference then
                table.insert(largest, specItemsDetails[i])
            end
        end
        return largest
    end
end

local function getMaxStatGrowthItems(itemsDetails)
    for _, v in ipairs(itemsDetails) do
        if v.statIncrease == nil then
            return nil  -- return nil if item can't be compared
        end
    end
    
    local largestGrowthItems = { itemsDetails[1] }
    local largestGrowth = itemsDetails[1].statIncrease
    for i=2, #itemsDetails do
        local growth = itemsDetails[i].statIncrease
        if growth > largestGrowth then
            largest = { itemsDetails[i] }
            largestGrowth = growth
        elseif growth == largestGrowth then
            tinsert(largestGrowthItems, itemsDetails[i])
        end
    end
    return largestGrowthItems
end

local function getMaxVendorIndex(itemsDetails)
    local maxVendorPrice = itemsDetails[1].vendorPrice
    local maxVendorPriceIndex = 1
    for i=2, #itemsDetails do
        local vendorPrice = itemsDetails[i].vendorPrice
        if vendorPrice > maxVendorPrice then
            maxVendorPriceIndex = i
            maxVendorPrice = vendorPrice
        end
    end
    return itemsDetails[maxVendorPriceIndex].choiceIndex
end

local PoliQuestLootAutomationEnabled, PoliQuestStrictAutomation
local function getQuestRewardChoice()
    local numChoices = GetNumQuestChoices()
    if numChoices <= 1 then
        return 1
    elseif not PoliQuestLootAutomationEnabled then
        return
    else
        local lootSpec = GetLootSpecialization()
        if lootSpec == 0 then
            lootSpec = GetSpecializationInfo(GetSpecialization())
        end
        local itemsDetails = getItemsDetails(numChoices)
        if itemsDetails == nil then
            return  -- quest loot has choice that isn't equippable. let player choose.
        end
        local largestSpecUpgrade = getLargestSpecUpgrade(itemsDetails, lootSpec)
        if largestSpecUpgrade == nil then
            return  -- no spec upgrades or missing equipped item. let player choose.
        elseif #largestSpecUpgrade == 1 then
            return largestSpecUpgrade[1].choiceIndex
        elseif PoliQuestStrictAutomation then
            return
        else
            local maxStatGrowthItems = getMaxStatGrowthItems(largestSpecUpgrade)
            if maxStatGrowthItems == nil then
                return  -- items can't be compared. let player choose.
            else
                return getMaxVendorIndex(maxStatGrowthItems)
            end
        end
    end
end

local function onGossipShow()
    local actQuests = GetActiveQuests() or {}
    debugPrint("numActiveQuests: "..#actQuests)
    for i, v in ipairs(actQuests) do
        if questIDToName[v.questID] and v.isComplete then
            debugPrint("Selecting index "..i)
            SelectActiveQuest(i)
            return
        end
    end

    local availableQuests = GetAvailableQuests() or {}
    debugPrint("numAvailableQuests: "..#availableQuests)
    for i, v in ipairs(availableQuests) do
        if questIDToName[v.questID] then
            debugPrint("Selecting index "..i)
            SelectAvailableQuest(i)
            return
        end
    end
end

function addonTable.QuestInteractionAutomation_OnGossipShow()
    onGossipShow()
end

function addonTable.QuestInteractionAutomation_OnQuestGreeting()
    debugPrint("numActiveQuests: "..GetNumActiveQuests())
    for i=1, GetNumActiveQuests() do
        local questName, isComplete = GetActiveTitle(i)
        debugPrint("questName: "..questName)
        if isComplete then
            debugPrint("isComplete: true")
        else
            debugPrint("isComplete: false")
        end
        if questNames[slower(questName)] and isComplete then
            SelectActiveQuest(i)
            return
        end
    end

    debugPrint("numAvailableQuests: "..GetNumAvailableQuests())
    for i=1, GetNumAvailableQuests() do
        local questID = select(5, GetAvailableQuestInfo(i))
        debugPrint(i.." "..questID)
        if questIDToName[questID] then
            SelectAvailableQuest(i)
            return
        end
    end
end

function addonTable.QuestInteractionAutomation_OnQuestDetail()
    if QuestInfoTitleHeader ~= nil then
        debugPrint("QuestInfoTitleHeader shown: true")
    else
        debugPrint("QuestInfoTitleHeader shown: false")
    end
    if QuestInfoTitleHeader then
        if QuestInfoTitleHeader:GetText() ~= nil then
            debugPrint("QuestInfoTitleHeader: "..QuestInfoTitleHeader:GetText())
        else
            debugPrint("QuestInfoTitleHeader: nil")
        end
        if QuestInfoTitleHeader:GetText() and QuestInfoTitleHeader:GetText() ~= "" then
            if questNames[slower(QuestInfoTitleHeader:GetText())] then
                AcceptQuest()
            elseif slower(QuestInfoTitleHeader:GetText()) == "blinded by the light" then
                print("|cFF5c8cc1PoliQuest:|r |cFFFF0000Quests that require level 60 are not automated in order to prevent automation of important quest-related decisions.|r")
            end
        else
            debugPrint("Quest detail visible without title header text. Attempting close.")
            QuestFrame:Hide()
        end
    end
end

function addonTable.QuestInteractionAutomation_OnQuestProgress()
    if QuestProgressTitleText ~= nil then
        debugPrint("QuestProgressTitleText shown: true")
    else
        debugPrint("QuestProgressTitleText shown: false")
    end
    if QuestProgressTitleText then
        debugPrint("QuestProgressTitleText: "..QuestProgressTitleText:GetText())
        if IsQuestCompletable() then
            debugPrint("IsQuestCompletable: true")
        else
            debugPrint("IsQuestCompletable: false")
        end
        if questNames[slower(QuestProgressTitleText:GetText())] then
            if IsQuestCompletable() then
                CompleteQuest()
            else
                debugPrint("QuestFrame visible and nothing to do. Attempting close.")
                QuestFrame:Hide()
            end
        end
    end
end

function addonTable.QuestInteractionAutomation_OnQuestComplete()
    if QuestInfoTitleHeader ~= nil then
        debugPrint("QuestInfoTitleHeader shown: true")
    else
        debugPrint("QuestInfoTitleHeader shown: false")
    end
    if QuestInfoTitleHeader then
        debugPrint(QuestInfoTitleHeader:GetText())
        if questNames[slower(QuestInfoTitleHeader:GetText())] then
            local questRewardIndex = getQuestRewardChoice()
            debugPrint("questRewardIndex: "..questRewardIndex)
            if questRewardIndex then
                GetQuestReward(questRewardIndex)
            end
        end
    end
end

function addonTable.QuestInteractionAutomation_OnQuestLogUpdate()
    local num = GetNumAutoQuestPopUps()
    debugPrint("numAutoQuestPopUps "..num)
    if num > 0 then
        for i=1,num do
            local questID = GetAutoQuestPopUp(i)
            if questIDToName[questID] then
                debugPrint(i.." "..questIDToName[questID])
                AutoQuestPopUpTracker_OnMouseDown(CAMPAIGN_QUEST_TRACKER_MODULE:GetBlock(questID))
            end
        end
    end
end

function addonTable.QuestInteractionAutomation_OnQuestAccepted()
    if GossipFrame:IsVisible() then
        onGossipShow()
    end
    QuestFrame:Hide()
end

local function initialize()
end

local function terminate()
end

local questInteractionAutomation = {}
questInteractionAutomation.name = "QuestInteractionAutomation"
questInteractionAutomation.events = {
    { "GOSSIP_SHOW" },
    { "QUEST_GREETING" },
    { "QUEST_DETAIL" },
    { "QUEST_PROGRESS" },
    { "QUEST_COMPLETE" },
    { "QUEST_LOG_UPDATE" },
    { "QUEST_ACCEPTED" }
}
questInteractionAutomation.initialize = initialize
questInteractionAutomation.terminate = terminate
function questInteractionAutomation.setSwitch(switchName, isEnabled)
    if switchName == "QuestRewardSelectionAutomation" then
        PoliQuestLootAutomationEnabled = isEnabled
    elseif switchName == "StrictAutomation" then
        PoliQuestStrictAutomation = isEnabled
    end
end
addonTable[questInteractionAutomation.name] = questInteractionAutomation
