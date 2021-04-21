local _, addonTable = ...

local questIDBlacklist = addonTable.data.questIDBlacklist

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

local ExcludeTrivial

local function onGossipShow()
    local actQuests = C_GossipInfo.GetActiveQuests() or {}
    debugPrint("numActiveQuests: " .. #actQuests)
    for i, v in ipairs(actQuests) do
        debugPrint("Quest ID: " .. v.questID)
        debugPrint("Quest Name: " .. v.title)
        debugPrint("Complete: " .. tostring(v.isComplete))
        if v.isComplete then
            if not questIDBlacklist[v.questID] then
                debugPrint("Selecting quest: " .. v.title)
                C_GossipInfo.SelectActiveQuest(i)
                return
            else
                print("|cFF5c8cc1PoliQuest:|r Active quest \"" .. v.title .. "\" not selected due to blacklisting.")
            end
        end
    end

    local availableQuests = C_GossipInfo.GetAvailableQuests() or {}
    debugPrint("numAvailableQuests: " .. #availableQuests)
    for i, v in ipairs(availableQuests) do
        debugPrint("Quest ID: " .. v.questID)
        debugPrint("Quest Name: " .. v.title)
        debugPrint("Low Level Quest: " .. tostring(v.isTrivial))
        if not questIDBlacklist[v.questID] then
            if not v.isTrivial or not ExcludeTrivial then
                debugPrint("Selecting quest: " .. v.title)
                C_GossipInfo.SelectAvailableQuest(i)
                return
            else
                debugPrint("Quest excluded from automation.")
            end
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
    else
        debugPrint("Automation manually suppressed.")
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
            local questID = GetActiveQuestID(i)
            debugPrint("Quest ID: " .. questID)
            debugPrint("Quest Name: " .. title)
            debugPrint("Complete: " .. tostring(isComplete))
            if isComplete then
                if not questIDBlacklist[questID] then
                    debugPrint("Selecting quest: " .. title)
                    SelectActiveQuest(i)
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
            local isTrivial, _, _, _, questID = GetAvailableQuestInfo(i)
            debugPrint("Quest ID: " .. questID)
            debugPrint("Quest Name: " .. title)
            debugPrint("Low Level Quest: " .. tostring(isTrivial))
            if not questIDBlacklist[questID] then
                if not isTrivial or not ExcludeTrivial then
                    debugPrint("Selecting quest: " .. title)
                    SelectAvailableQuest(i)
                    debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
                    return
                else
                    debugPrint("Quest excluded from automation.")
                end
            else
                print("|cFF5c8cc1PoliQuest:|r Available quest \"" .. title .. "\" not selected due to blacklisting.")
            end
        end
    else
        debugPrint("Automation manually suppressed.")
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestGreeting")
end

function feature.eventHandlers.onQuestDetail()
    debugPrint("QuestInteractionAutomation - Entering onQuestDetail")
    if not automationSuppressed() then
        local questID = GetQuestID()
        local title = GetTitleText()
        local isTrivial = C_QuestLog.IsQuestTrivial(questID)
        if not questIDBlacklist[questID] then
            if not isTrivial or not ExcludeTrivial then
                AcceptQuest()
            else
                debugPrint("Quest excluded from automation.")
            end
        else
            print("|cFF5c8cc1PoliQuest:|r Available quest \"" .. title .. "\" not selected due to blacklisting.")
        end
    else
        debugPrint("Automation manually suppressed.")
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestDetail")
end

function feature.eventHandlers.onQuestProgress()
    debugPrint("QuestInteractionAutomation - Entering onQuestProgress")
    if not automationSuppressed() then
        local questID = GetQuestID()
        local title = GetTitleText()
        debugPrint("Quest ID: " .. questID)
        debugPrint("Quest Name: " .. title)
        if not questIDBlacklist[questID] then
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
    else
        debugPrint("Automation manually suppressed.")
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestProgress")
end

function feature.eventHandlers.onQuestComplete()
    debugPrint("QuestInteractionAutomation - Entering onQuestComplete")
    if not automationSuppressed() then
        local questID = GetQuestID()
        local title = GetTitleText()
        debugPrint("Quest ID: " .. questID)
        debugPrint("Quest Name: " .. title)
        if not questIDBlacklist[questID] then
            local numQuestChoices = GetNumQuestChoices()
            debugPrint("numQuestChoices: " .. numQuestChoices)
            if numQuestChoices <= 1 then
                GetQuestReward(1)
            end
        else
            print("|cFF5c8cc1PoliQuest:|r Quest \"" .. title .. "\" not automated due to blacklisting.")
        end
    else
        debugPrint("Automation manually suppressed.")
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
                if not questIDBlacklist[questID] then
                    debugPrint("questID: " .. questID)
                    AutoQuestPopUpTracker_OnMouseUp(CAMPAIGN_QUEST_TRACKER_MODULE:GetBlock(questID), "LeftButton", true)
                else
                    print("|cFF5c8cc1PoliQuest:|r Quest \"" .. C_QuestLog.GetTitleForQuestID(questID)  .. "\" not automated due to blacklisting.")
                end
            end
            debugPrint("QuestInteractionAutomation - Exiting onQuestLogUpdate")
        end
    else
        debugPrint("Automation manually suppressed.")
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
    else
        debugPrint("Automation manually suppressed.")
    end
    debugPrint("QuestInteractionAutomation - Exiting onQuestAccepted")
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
function feature.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. tostring(value))
    if switchName == "Modifier" then
        Modifier = value == 1 and "Alt" or (value == 2 and "Ctrl" or (value == 3 and "Shift" or nil))
    elseif switchName == "ExcludeTrivial" then
        ExcludeTrivial = value
    end
end
addonTable.features = addonTable.features or {}
addonTable.features.QuestInteractionAutomation = feature