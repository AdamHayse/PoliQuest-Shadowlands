local _, addonTable = ...

local C_GossipInfo, ipairs, C_QuestLog, GetNumActiveQuests = C_GossipInfo, ipairs, C_QuestLog, GetNumActiveQuests
local type, C_Item, ItemLocation, table, GetActiveTitle = type, C_Item, ItemLocation, table, GetActiveTitle
local string, GetInventoryItemLink, GetItemStatDelta = string, GetInventoryItemLink, GetItemStatDelta
local GetItemInfo, select, GetTime, SelectActiveQuest = GetItemInfo, select, GetTime, SelectActiveQuest
local GetNumAvailableQuests, GetAvailableQuestInfo, SelectActiveQuest, AcceptQuest = GetNumAvailableQuests, GetAvailableQuestInfo, SelectActiveQuest, AcceptQuest
local IsQuestCompletable, CompleteQuest, math, GetQuestItemLink = IsQuestCompletable, CompleteQuest, math, GetQuestItemLink
local GetDetailedItemLevelInfo, GetItemSpecInfo, pairs, GetNumQuestChoices = GetDetailedItemLevelInfo, GetItemSpecInfo, pairs, GetNumQuestChoices
local GetLootSpecialization, GetSpecializationInfo, GetSpecialization, GetQuestReward = GetLootSpecialization, GetSpecializationInfo, GetSpecialization, GetQuestReward
local GetNumAutoQuestPopUps, GetAutoQuestPopUp, CAMPAIGN_QUEST_TRACKER_MODULE = GetNumAutoQuestPopUps, GetAutoQuestPopUp, CAMPAIGN_QUEST_TRACKER_MODULE
local UIErrorsFrame, UnitLevel, UnitName, SelectAvailableQuest = UIErrorsFrame, UnitLevel, UnitName, SelectAvailableQuest
local AutoQuestPopUpTracker_OnMouseDown, GetQuestProgressBarPercent = AutoQuestPopUpTracker_OnMouseDown, GetQuestProgressBarPercent

local questNames = addonTable.questNames
local questIDToName = addonTable.questIDToName
local dialogWhitelist = addonTable.dialogWhitelist
local innWhitelist = addonTable.innWhitelist
local itemEquipLocToEquipSlot = addonTable.itemEquipLocToEquipSlot

local searchDialogOptions = function(questDialog)
    local gossipOptions = C_GossipInfo.GetOptions()
    local numOptions = C_GossipInfo.GetNumOptions()
    for i=1, numOptions do
        local gossip = gossipOptions[i]
        local dialog = questDialog["dialog"]
        if type(dialog) == "string" then
            if questDialog["dialog"] == gossip["name"] then
                C_GossipInfo.SelectOption(i)
                return true
            end
        else
            for _, v in ipairs(dialog) do
                if v == gossip["name"] then
                    C_GossipInfo.SelectOption(i)
                    return true
                end
            end
        end
    end
end

local calculateStatIncrease = function(itemLink)
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
                    return statDifferences["ITEM_MOD_STAMINA_SHORT"]
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
                return math.max(statDif1["ITEM_MOD_STAMINA_SHORT"] or 0, statDif2["ITEM_MOD_STAMINA_SHORT"] or 0)
            end
        end
    end
end

local getItemsDetails = function(numChoices)
    local itemDetails = {}
    for i=1, numChoices do
        local itemLink = GetQuestItemLink("choice", i)
        local itemEquipLoc, _, vendorPrice = select(9, GetItemInfo(itemLink))
        if itemEquipLoc == "" then
            return nil
        end
        table.insert(itemDetails, {
            ["choiceIndex"] = i,
            ["equipSlot"] = itemEquipLocToEquipSlot[itemEquipLoc],
            ["ilvl"] = GetDetailedItemLevelInfo(itemLink),
            ["specs"] = GetItemSpecInfo(itemLink) or {},
            ["statIncrease"] = calculateStatIncrease(itemLink),
            ["vendorPrice"] = vendorPrice
        })
    end
    return itemDetails
end

local calcIlvlDifference = function(itemDetails)
    local itemIlvl = itemDetails["ilvl"]
    local equipSlot = itemDetails["equipSlot"]
    if type(equipSlot) == "number" then
        return itemIlvl - C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot))
    else
        local ilvl1 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[1]))
        local ilvl2 = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(equipSlot[2]))
        return ilvl1 > ilvl2 and itemIlvl - ilvl2 or itemIlvl - ilvl1
    end
end

local missingItem = function(itemsDetails)
    for k, v in pairs(itemsDetails) do
        local equipSlot = v["equipSlot"]
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

local getLargestSpecUpgrade = function(itemsDetails, lootSpec)
    local specItemsDetails = {}
    for _, v in ipairs(itemsDetails) do
        local specs = v["specs"]
        if #specs == 0 then
            table.insert(specItemsDetails, v)
        else
            for i=1, #specs do
                if specs[i] == lootSpec then
                    table.insert(specItemsDetails, v)
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

local getMaxStatGrowthItems = function(itemsDetails)
    for _, v in ipairs(itemsDetails) do
        if v["statIncrease"] == nil then
            return nil  -- return nil if item can't be compared
        end
    end
    
    local largestGrowthItems = { itemsDetails[1] }
    local largestGrowth = itemsDetails[1]["statIncrease"]
    for i=2, #itemsDetails do
        local growth = itemsDetails[i]["statIncrease"]
        if growth > largestGrowth then
            largest = { itemsDetails[i] }
            largestGrowth = growth
        elseif growth == largestGrowth then
            table.insert(largestGrowthItems, itemsDetails[i])
        end
    end
    return largestGrowthItems
end

local getMaxVendorIndex = function(itemsDetails)
    local maxVendorPrice = itemsDetails[1]["vendorPrice"]
    local maxVendorPriceIndex = 1
    for i=2, #itemsDetails do
        local vendorPrice = itemsDetails[i]["vendorPrice"]
        if vendorPrice > maxVendorPrice then
            maxVendorPriceIndex = i
            maxVendorPrice = vendorPrice
        end
    end
    return itemsDetails[maxVendorPriceIndex]["choiceIndex"]
end

local PoliQuestLootAutomationEnabled, PoliQuestStrictAutomation
local getQuestRewardChoice = function()
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
            return largestSpecUpgrade[1]["choiceIndex"]
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

addonTable.QuestAndDialogAutomation_OnGossipShow = function()
    local actQuests = C_GossipInfo.GetActiveQuests() or {}
    addonTable.debugPrint("numActiveQuests: "..#actQuests)
    for i, v in ipairs(actQuests) do
        if questIDToName[v.questID] and v.isComplete then
            addonTable.debugPrint("Selecting index "..i)
            C_GossipInfo.SelectActiveQuest(i)
            return
        end
    end

    local availableQuests = C_GossipInfo.GetAvailableQuests() or {}
    addonTable.debugPrint("numAvailableQuests: "..#availableQuests)
    for i, v in ipairs(availableQuests) do
        if questIDToName[v.questID] then
            addonTable.debugPrint("Selecting index "..i)
            C_GossipInfo.SelectAvailableQuest(i)
            return
        end
    end

    local numQuests = C_QuestLog.GetNumQuestLogEntries() or 0
    addonTable.debugPrint("numQuests: "..numQuests)
    for i=1, numQuests do
        local questName = C_QuestLog.GetInfo(i).title
        local questDialog = dialogWhitelist[questName]
        if questDialog then
            addonTable.debugPrint("Selecting quest dialog")
            if type(questDialog["npc"]) == "string" then
                if questDialog["npc"] == GossipFrameNpcNameText:GetText() then
                    searchDialogOptions(questDialog)
                end
            else
                for j, v in ipairs(questDialog["npc"]) do
                    if questDialog["npc"][j] == GossipFrameNpcNameText:GetText() then
                        if searchDialogOptions(questDialog) then
                            return
                        end
                    end
                end
            end
        end
    end
end

addonTable.QuestAndDialogAutomation_OnQuestGreeting = function()
    addonTable.debugPrint("numActiveQuests: "..GetNumActiveQuests())
    for i=1, GetNumActiveQuests() do
        local questName, isComplete = GetActiveTitle(i)
        addonTable.debugPrint("questName: "..questName)
        if isComplete then
            addonTable.debugPrint("isComplete: true")
        else
            addonTable.debugPrint("isComplete: false")
        end
        if questNames[string.lower(questName)] and isComplete then
            SelectActiveQuest(i)
            return
        end
    end

    addonTable.debugPrint("numAvailableQuests: "..GetNumAvailableQuests())
    for i=1, GetNumAvailableQuests() do
        local questID = select(5, GetAvailableQuestInfo(i))
        addonTable.debugPrint(i.." "..questID)
        if questIDToName[questID] then
            SelectAvailableQuest(i)
            return
        end
    end
end

addonTable.QuestAndDialogAutomation_OnQuestDetail = function()
    if QuestInfoTitleHeader ~= nil then
        addonTable.debugPrint("QuestInfoTitleHeader shown: true")
    else
        addonTable.debugPrint("QuestInfoTitleHeader shown: false")
    end
    if QuestInfoTitleHeader then
        if QuestInfoTitleHeader:GetText() ~= nil then
            addonTable.debugPrint("QuestInfoTitleHeader: "..QuestInfoTitleHeader:GetText())
        else
            addonTable.debugPrint("QuestInfoTitleHeader: nil")
        end
        if QuestInfoTitleHeader:GetText() and QuestInfoTitleHeader:GetText() ~= "" then
            if questNames[string.lower(QuestInfoTitleHeader:GetText())] then
                AcceptQuest()
            end
        else
            addonTable.debugPrint("Quest detail visible without title header text. Attempting close.")
            QuestFrame:Hide()
        end
    end
end

addonTable.QuestAndDialogAutomation_OnQuestProgress = function()
    if QuestProgressTitleText ~= nil then
        addonTable.debugPrint("QuestProgressTitleText shown: true")
    else
        addonTable.debugPrint("QuestProgressTitleText shown: false")
    end
    if QuestProgressTitleText then
        addonTable.debugPrint("QuestProgressTitleText: "..QuestProgressTitleText:GetText())
        if IsQuestCompletable() then
            addonTable.debugPrint("IsQuestCompletable: true")
        else
            addonTable.debugPrint("IsQuestCompletable: false")
        end
        if questNames[string.lower(QuestProgressTitleText:GetText())] then
            if IsQuestCompletable() then
                CompleteQuest()
            else
                addonTable.debugPrint("QuestFrame visible and nothing to do. Attempting close.")
                QuestFrame:Hide()
            end
        end
    end
end

addonTable.QuestAndDialogAutomation_OnQuestComplete = function()
    if QuestInfoTitleHeader ~= nil then
        addonTable.debugPrint("QuestInfoTitleHeader shown: true")
    else
        addonTable.debugPrint("QuestInfoTitleHeader shown: false")
    end
    if QuestInfoTitleHeader then
        addonTable.debugPrint(QuestInfoTitleHeader:GetText())
        if questNames[string.lower(QuestInfoTitleHeader:GetText())] then
            local questRewardIndex = getQuestRewardChoice()
            addonTable.debugPrint("questRewardIndex: "..questRewardIndex)
            if questRewardIndex then
                GetQuestReward(questRewardIndex)
            end
        end
    end
end

local reportQuestProgressRefreshPending
addonTable.QuestAndDialogAutomation_OnQuestLogUpdate = function()
    local num = GetNumAutoQuestPopUps()
    addonTable.debugPrint("numAutoQuestPopUps "..num)
    if num > 0 then
        for i=1,num do
            local questID = GetAutoQuestPopUp(i)
            if questIDToName[questID] then
                addonTable.debugPrint(i.." "..questIDToName[questID])
                AutoQuestPopUpTracker_OnMouseDown(CAMPAIGN_QUEST_TRACKER_MODULE:GetBlock(questID))
            end
        end
    end
    reportQuestProgressRefreshPending = true
end

addonTable.QuestAndDialogAutomation_OnQuestAccepted = function(questID)
    C_QuestLog.AddQuestWatch(questID, 1)
    if GossipFrame:IsVisible() then
        onGossipShow_questGossip()
    end
    QuestFrame:Hide()
end

local questProgresses
addonTable.QuestAndDialogAutomation_OnQuestRemoved = function(questID)
    questProgresses[questID] = nil
end

local reportQuestProgressLastRun
local onUpdate = function()
    if reportQuestProgressRefreshPending and (reportQuestProgressLastRun or 0) + .1 < GetTime() then
        for i=1, C_QuestLog.GetNumQuestLogEntries() do
            local questID = C_QuestLog.GetQuestIDForLogIndex(i)
            local progress  = GetQuestProgressBarPercent(questID)
            if progress > 0 and (not questProgresses[questID] or questProgresses[questID] ~= progress) then
                local oldProgress = questProgresses[questID] or 0
                questProgresses[questID] = progress
                UIErrorsFrame:AddMessage(C_QuestLog.GetInfo(i).title .. ": " .. progress .. "% (" .. string.format("%+.1f", progress-oldProgress) .. "%)" , 1, 1, 0, 1)
            end
        end
        reportQuestProgressLastRun = GetTime()
        reportQuestProgressRefreshPending = false
    end
end

local initialize = function()
    reportQuestProgressRefreshPending = nil
    reportQuestProgressLastRun = nil
    questProgresses = {}
    for i=1, C_QuestLog.GetNumQuestLogEntries() do
        local questInfo = C_QuestLog.GetInfo(i)
        if not questInfo.isHidden then
            local questID = questInfo.questID
            if questID > 0 then
                questProgresses[questID] = GetQuestProgressBarPercent(questID)
            end
        end
    end
end

local terminate = function()
    reportQuestProgressRefreshPending = nil
    reportQuestProgressLastRun = nil
    questProgresses = nil
end

local questAndDialogAutomation = {}
questAndDialogAutomation.name = "QuestAndDialogAutomation"
questAndDialogAutomation.events = {
    { "GOSSIP_SHOW" },
    { "QUEST_GREETING" },
    { "QUEST_DETAIL" },
    { "QUEST_PROGRESS" },
    { "QUEST_COMPLETE" },
    { "QUEST_LOG_UPDATE" },
    { "QUEST_ACCEPTED" },
    { "QUEST_REMOVED" }
}
questAndDialogAutomation.onUpdate = onUpdate
questAndDialogAutomation.initialize = initialize
questAndDialogAutomation.terminate = terminate
questAndDialogAutomation.setSwitch = function(switchName, isEnabled)
    if switchName == "QuestRewardSelectionAutomation" then
        PoliQuestLootAutomationEnabled = isEnabled
    elseif switchName == "StrictAutomation" then
        PoliQuestStrictAutomation = isEnabled
    end
end
addonTable[questAndDialogAutomation.name] = questAndDialogAutomation