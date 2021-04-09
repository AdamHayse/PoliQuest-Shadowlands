local _, addonTable = ...

local select, type, max, smatch, spplit, tonumber, pairs, ipairs, tinsert, slower, print = select, type, math.max, string.match, string.split, tonumber, pairs, ipairs, table.insert, string.lower, print
local GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink = GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink
local GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization = GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization
local GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization = C_Item.GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization
local GetActiveQuests, SelectActiveQuest, GISelectActiveQuest, GetAvailableQuests, SelectAvailableQuest, GISelectAvailableQuest = C_GossipInfo.GetActiveQuests, SelectActiveQuest, C_GossipInfo.SelectActiveQuest, C_GossipInfo.GetAvailableQuests, SelectAvailableQuest, C_GossipInfo.SelectAvailableQuest
local GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo = GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo
local AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp = AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp
local QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame = QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame
local AutoQuestPopUpTracker_OnMouseDown, CAMPAIGN_QUEST_TRACKER_MODULE = AutoQuestPopUpTracker_OnMouseDown, CAMPAIGN_QUEST_TRACKER_MODULE

local itemEquipLocToEquipSlot = addonTable.itemEquipLocToEquipSlot

local feature = {}

local DEBUG_QUEST_INTERACTION_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_INTERACTION_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_INTERACTION_HANDLER
end

local function debugPrint(text)
    if DEBUG_QUEST_INTERACTION_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function onGossipShow()
    local actQuests = GetActiveQuests() or {}
    debugPrint("numActiveQuests: " .. #actQuests)
    for i, v in ipairs(actQuests) do
        if v.isComplete then
            debugPrint("Selecting index " .. i)
            SelectActiveQuest(i)
            GISelectActiveQuest(i)
            return
        end
    end

    local availableQuests = GetAvailableQuests() or {}
    debugPrint("numAvailableQuests: " .. #availableQuests)
    for i, v in ipairs(availableQuests) do
        debugPrint("Selecting index " .. i)
        SelectAvailableQuest(i)
        GISelectAvailableQuest(i)
        return
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onGossipShow()
    debugPrint("QuestInteractionAutomation - Entering onGossipShow")
    onGossipShow()
    debugPrint("QuestInteractionAutomation - Exiting onGossipShow")
end

function feature.eventHandlers.onQuestGreeting()
    debugPrint("QuestInteractionAutomation - Entering onQuestGreeting")
    local numActiveQuests = GetNumActiveQuests()
    debugPrint("numActiveQuests: " .. numActiveQuests)
    for i=1, numActiveQuests do
        local _, isComplete = GetActiveTitle(i)
        if isComplete then
            debugPrint("Selecting index " .. i)
            SelectActiveQuest(i)
            GISelectActiveQuest(i)
            debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
            return
        end
    end

    local numAvailableQuests = GetNumAvailableQuests()
    debugPrint("numAvailableQuests: " .. numAvailableQuests)
    for i=1, numAvailableQuests do
        debugPrint("Selecting index " .. i)
        SelectAvailableQuest(i)
        GISelectAvailableQuest(i)
        debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
        return
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
end

function feature.eventHandlers.onQuestDetail()
    debugPrint("QuestInteractionAutomation - Entering onQuestDetail")
    debugPrint("QuestInfoTitleHeader shown: " .. tostring(not not QuestInfoTitleHeader))
    if QuestInfoTitleHeader then
        debugPrint("QuestInfoTitleHeader: ".. (QuestInfoTitleHeader:GetText() or "nil"))
        if QuestInfoTitleHeader:GetText() and QuestInfoTitleHeader:GetText() ~= "" then
            AcceptQuest()
        else
            debugPrint("Quest detail visible without title header text. Attempting close.")
            QuestFrame:Hide()
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestDetail")
end

function feature.eventHandlers.onQuestProgress()
    debugPrint("QuestInteractionAutomation - Entering onQuestProgress")
    debugPrint("QuestProgressTitleText shown: " .. tostring(not not QuestProgressTitleText))
    if QuestProgressTitleText then
        debugPrint("QuestProgressTitleText: " .. QuestProgressTitleText:GetText())
        local questCompletable = IsQuestCompletable()
        debugPrint("IsQuestCompletable: " .. tostring(not not questCompletable))
        if questCompletable then
            CompleteQuest()
        else
            debugPrint("QuestFrame visible and nothing to do. Attempting close.")
            QuestFrame:Hide()
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestProgress")
end

function feature.eventHandlers.onQuestComplete()
    debugPrint("QuestInteractionAutomation - Entering onQuestComplete")
    debugPrint("QuestInfoTitleHeader shown: " .. tostring(not not QuestInfoTitleHeader))
    if QuestInfoTitleHeader then
        debugPrint("QuestInfoTitleHeader" .. QuestInfoTitleHeader:GetText())
        local numQuestChoices = GetNumQuestChoices()
        debugPrint("numQuestChoices: " .. numQuestChoices)
        if numQuestChoices <= 1 then
            GetQuestReward(1)
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestComplete")
end

function feature.eventHandlers.onQuestLogUpdate()
    local num = GetNumAutoQuestPopUps()
    if num > 0 then
        debugPrint("QuestInteractionAutomation - In onQuestLogUpdate")
        debugPrint("numAutoQuestPopUps "..num)
        for i=1,num do
            local questID = GetAutoQuestPopUp(i)
            debugPrint(i .. " " .. questIDToName[questID])
            AutoQuestPopUpTracker_OnMouseDown(CAMPAIGN_QUEST_TRACKER_MODULE:GetBlock(questID))
        end
        debugPrint("QuestInteractionAutomation - Exiting onQuestLogUpdate")
    end
end

function feature.eventHandlers.onQuestAccepted()
    debugPrint("QuestInteractionAutomation - Entering onQuestAccepted")
    local gossipFrameVisible = GossipFrame:IsVisible()
    debugPrint("GossipFrame visible: " .. tostring(not not gossipFrameVisible))
    if GossipFrame:IsVisible() then
        onGossipShow()
    end
    local questFrameVisible = QuestFrame:IsVisible()
    debugPrint("QuestFrame visible: " .. tostring(not not questFrameVisible))
    if questFrameVisible then
        debugPrint("Hiding QuestFrame")
        QuestFrame:Hide()
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestAccepted")
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.QuestInteractionAutomation = feature