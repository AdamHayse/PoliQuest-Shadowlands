local _, addonTable = ...

local GetTime = GetTime

local feature = {}

local DEBUG_QUEST_PROGRESS_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_PROGRESS_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_PROGRESS_HANDLER
end
local print, debugPrint, uniquePrint = addonTable.util.getPrintFunction(feature)

feature.eventHandlers = {}

local reportQuestProgressRefreshPending
function feature.eventHandlers.onQuestLogUpdate()
    reportQuestProgressRefreshPending = true
end

local questProgresses
function feature.eventHandlers.onQuestRemoved(questID)
    questProgresses[questID] = nil
end

local reportQuestProgressLastRun
local function onUpdate()
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

local function initialize()
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

local function terminate()
    reportQuestProgressRefreshPending = nil
    reportQuestProgressLastRun = nil
    questProgresses = nil
end

feature.updateHandler = onUpdate
feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.QuestProgressTracker = feature
