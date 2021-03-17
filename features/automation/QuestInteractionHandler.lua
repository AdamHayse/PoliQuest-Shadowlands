local _, addonTable = ...

local select, type, max, smatch, spplit, tonumber, pairs, ipairs, tinsert, slower, print = select, type, math.max, string.match, string.split, tonumber, pairs, ipairs, table.insert, string.lower, print
local GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink = GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink
local GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization = GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization
local GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization = C_Item.GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization
local GetActiveQuests, SelectActiveQuest, GISelectActiveQuest, GetAvailableQuests, SelectAvailableQuest, GISelectAvailableQuest = C_GossipInfo.GetActiveQuests, SelectActiveQuest, C_GossipInfo.SelectActiveQuest, C_GossipInfo.GetAvailableQuests, SelectAvailableQuest, C_GossipInfo.SelectAvailableQuest
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

local function onGossipShow()
    local actQuests = GetActiveQuests() or {}
    debugPrint("numActiveQuests: "..#actQuests)
    for i, v in ipairs(actQuests) do
        if questIDToName[v.questID] and v.isComplete then
            debugPrint("Selecting index "..i)
            SelectActiveQuest(i)
            GISelectActiveQuest(i)
            return
        end
    end

    local availableQuests = GetAvailableQuests() or {}
    debugPrint("numAvailableQuests: "..#availableQuests)
    for i, v in ipairs(availableQuests) do
        if questIDToName[v.questID] then
            debugPrint("Selecting index "..i)
            SelectAvailableQuest(i)
            GISelectAvailableQuest(i)
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
            GISelectActiveQuest(i)
            return
        end
    end

    debugPrint("numAvailableQuests: "..GetNumAvailableQuests())
    for i=1, GetNumAvailableQuests() do
        local questID = select(5, GetAvailableQuestInfo(i))
        debugPrint(i.." "..questID)
        if questIDToName[questID] then
            SelectAvailableQuest(i)
            GISelectAvailableQuest(i)
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
            if GetNumQuestChoices() <= 1 then
                GetQuestReward(1)
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
addonTable[questInteractionAutomation.name] = questInteractionAutomation
