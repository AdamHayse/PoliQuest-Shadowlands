local _, addonTable = ...

local select, type, max, smatch, spplit, tonumber, pairs, ipairs, tinsert, slower, print = select, type, math.max, string.match, string.split, tonumber, pairs, ipairs, table.insert, string.lower, print
local GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink = GetItemInfo, GetInventoryItemLink, GetItemStatDelta, GetQuestItemLink
local GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization = GetDetailedItemLevelInfo, GetItemSpecInfo, GetNumQuestChoices, GetLootSpecialization
local GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization = C_Item.GetCurrentItemLevel, GetSpecializationInfo, GetSpecialization
local GetActiveQuests, SelectActiveQuest, GISelectActiveQuest, GetAvailableQuests, SelectAvailableQuest, GISelectAvailableQuest = C_GossipInfo.GetActiveQuests, SelectActiveQuest, C_GossipInfo.SelectActiveQuest, C_GossipInfo.GetAvailableQuests, SelectAvailableQuest, C_GossipInfo.SelectAvailableQuest
local GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo = GetNumActiveQuests, GetActiveTitle, GetNumAvailableQuests, GetAvailableQuestInfo
local AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp = AcceptQuest, IsQuestCompletable, CompleteQuest, GetQuestReward, GetNumAutoQuestPopUps, GetAutoQuestPopUp
local QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame = QuestInfoTitleHeader, QuestProgressTitleText, QuestFrame
local AutoQuestPopUpTracker_OnMouseUp, CAMPAIGN_QUEST_TRACKER_MODULE = AutoQuestPopUpTracker_OnMouseUp, CAMPAIGN_QUEST_TRACKER_MODULE

local questIDBlacklist = addonTable.data.questIDBlacklist
local questNameBlacklist = addonTable.data.questNameBlacklist

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

local Modifier
local function automationSuppressed()
    if Modifier == "Alt" then
        return IsAltKeyDown()
    elseif Modifier == "Ctrl" then
        return IsControlKeyDown()
    elseif Modifier == "Shift" then
        return IsShiftKeyDown()
    else
        debugPrint("Modifier switch not set.")
        return false
    end
end

local questNameBlacklist = {}

local function onGossipShow()
    local actQuests = GetActiveQuests() or {}
    debugPrint("numActiveQuests: " .. #actQuests)
    for i, v in ipairs(actQuests) do
        if v.isComplete then
            if not questIDBlacklist[v.questID] then
                debugPrint("Selecting index " .. i)
                SelectActiveQuest(i)
                GISelectActiveQuest(i)
                return
            else
                print("|cFF5c8cc1PoliQuest:|r Active quest \"" .. v.title .. "\" not selected due to blacklisting.")
            end
        end
    end

    local availableQuests = GetAvailableQuests() or {}
    debugPrint("numAvailableQuests: " .. #availableQuests)
    for i, v in ipairs(availableQuests) do
        if not questIDBlacklist[v.questID] then
            debugPrint("Selecting index " .. i)
            SelectAvailableQuest(i)
            GISelectAvailableQuest(i)
            return
        else
            print("|cFF5c8cc1PoliQuest:|r Available quest \"" .. v.title .. "\" not selected due to blacklisting.")
        end
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onGossipShow()
    debugPrint("QuestInteractionAutomation - Entering onGossipShow")
    if not automationSuppressed() then
        onGossipShow()
    end
    debugPrint("QuestInteractionAutomation - Exiting onGossipShow")
end

function feature.eventHandlers.onQuestGreeting()
    debugPrint("QuestInteractionAutomation - Entering onQuestGreeting")
    if not automationSuppressed() then
        local numActiveQuests = GetNumActiveQuests()
        debugPrint("numActiveQuests: " .. numActiveQuests)
        for i=1, numActiveQuests do
            local title, isComplete = GetActiveTitle(i)
            if isComplete then
                if not questNameBlacklist[title] then
                    debugPrint("Selecting quest: " .. title)
                    SelectActiveQuest(i)
                    GISelectActiveQuest(i)
                    debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
                    return
                else
                    print("|cFF5c8cc1PoliQuest:|r Active quest \"" .. title .. "\" not selected due to blacklisting.")
                end
            end
        end

        local numAvailableQuests = GetNumAvailableQuests()
        debugPrint("numAvailableQuests: " .. numAvailableQuests)
        for i=1, numAvailableQuests do
            local title = GetAvailableTitle(i)
            if not questNameBlacklist[title] then
                debugPrint("Selecting quest: " .. title)
                SelectAvailableQuest(i)
                GISelectAvailableQuest(i)
                debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
                return
            else
                print("|cFF5c8cc1PoliQuest:|r Available quest \"" .. title .. "\" not selected due to blacklisting.")
            end
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
end

function feature.eventHandlers.onQuestDetail()
    debugPrint("QuestInteractionAutomation - Entering onQuestDetail")
    if not automationSuppressed() then
        debugPrint("QuestInfoTitleHeader shown: " .. tostring(not not QuestInfoTitleHeader))
        if QuestInfoTitleHeader then
            local title = QuestInfoTitleHeader:GetText()
            debugPrint("QuestInfoTitleHeader: ".. (title or "nil"))
            if title and title ~= "" then
                if not questNameBlacklist[title] then
                    AcceptQuest()
                else
                    print("|cFF5c8cc1PoliQuest:|r Available quest \"" .. title .. "\" not selected due to blacklisting.")
                end
            else
                debugPrint("Quest detail visible without title header text. Attempting close.")
                QuestFrame:Hide()
            end
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestDetail")
end

function feature.eventHandlers.onQuestProgress()
    debugPrint("QuestInteractionAutomation - Entering onQuestProgress")
    if not automationSuppressed() then
        debugPrint("QuestProgressTitleText shown: " .. tostring(not not QuestProgressTitleText))
        if QuestProgressTitleText then
            local title = QuestProgressTitleText:GetText()
            if not questNameBlacklist[title] then
                debugPrint("QuestProgressTitleText: " .. title)
                local questCompletable = IsQuestCompletable()
                debugPrint("IsQuestCompletable: " .. tostring(not not questCompletable))
                if questCompletable then
                    CompleteQuest()
                else
                    debugPrint("QuestFrame visible and nothing to do. Attempting close.")
                    QuestFrame:Hide()
                end
            else
                print("|cFF5c8cc1PoliQuest:|r Quest \"" .. title .. "\" not automated due to blacklisting.")
            end
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestProgress")
end

function feature.eventHandlers.onQuestComplete()
    debugPrint("QuestInteractionAutomation - Entering onQuestComplete")
    if not automationSuppressed() then
        debugPrint("QuestInfoTitleHeader shown: " .. tostring(not not QuestInfoTitleHeader))
        if QuestInfoTitleHeader then
            local title = QuestInfoTitleHeader:GetText()
            if not questNameBlacklist[title] then
                debugPrint("QuestInfoTitleHeader" .. title)
                local numQuestChoices = GetNumQuestChoices()
                debugPrint("numQuestChoices: " .. numQuestChoices)
                if numQuestChoices <= 1 then
                    GetQuestReward(1)
                end
            else
                print("|cFF5c8cc1PoliQuest:|r Quest \"" .. title .. "\" not automated due to blacklisting.")
            end
        end
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestComplete")
end

function feature.eventHandlers.onQuestLogUpdate()
    if not automationSuppressed() then
        local num = GetNumAutoQuestPopUps()
        if num > 0 then
            debugPrint("QuestInteractionAutomation - In onQuestLogUpdate")
            debugPrint("numAutoQuestPopUps "..num)
            for i=1,num do
                local questID = GetAutoQuestPopUp(i)
                debugPrint("questID: " .. questID)
                AutoQuestPopUpTracker_OnMouseUp(CAMPAIGN_QUEST_TRACKER_MODULE:GetBlock(questID), "LeftButton", true)
            end
            debugPrint("QuestInteractionAutomation - Exiting onQuestLogUpdate")
        end
    end
end

function feature.eventHandlers.onQuestAccepted()
    debugPrint("QuestInteractionAutomation - Entering onQuestAccepted")
    if not automationSuppressed() then
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
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestAccepted")
end

function feature.eventHandlers.onQuestDataLoadResult(questID, success)
    if questIDBlacklist[questID] then
        if success then
            questNameBlacklist[C_QuestLog.GetTitleForQuestID(questID)] = true
        else
            print("|cFF5c8cc1PoliQuest[WARNING]:|r Quest name for quest ID " .. questID .. " failed to load. Quest Interaction Automation for this quest may not be prevented.")
        end
    end
end

local function initialize()
    for questID in pairs(questIDBlacklist) do
        C_QuestLog.RequestLoadQuestByID(questID)
    end
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
function feature.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. value)
    if switchName == "Modifier" then
        Modifier = value == 1 and "Alt" or (value == 2 and "Ctrl" or (value == 3 and "Shift" or nil))
    end
end
addonTable.features = addonTable.features or {}
addonTable.features.QuestInteractionAutomation = feature