local _, addonTable = ...


local GetTime, GetNumQuestLogEntries, GetQuestIDForLogIndex = GetTime, C_QuestLog.GetNumQuestLogEntries, C_QuestLog.GetQuestIDForLogIndex
local GetQuestProgressBarPercent, UIErrorsFrame, GetInfo, sformat = GetQuestProgressBarPercent, UIErrorsFrame, C_QuestLog.GetInfo, string.format

local reportQuestProgressRefreshPending
function addonTable.QuestProgressTracker_OnQuestLogUpdate()
    reportQuestProgressRefreshPending = true
end

local questProgresses
function addonTable.QuestProgressTracker_OnQuestRemoved(questID)
    questProgresses[questID] = nil
end

local reportQuestProgressLastRun
local function onUpdate()
    if reportQuestProgressRefreshPending and (reportQuestProgressLastRun or 0) + .1 < GetTime() then
        for i=1, GetNumQuestLogEntries() do
            local questID = GetQuestIDForLogIndex(i)
            local progress  = GetQuestProgressBarPercent(questID)
            if progress > 0 and (not questProgresses[questID] or questProgresses[questID] ~= progress) then
                local oldProgress = questProgresses[questID] or 0
                questProgresses[questID] = progress
                UIErrorsFrame:AddMessage(GetInfo(i).title .. ": " .. progress .. "% (" .. sformat("%+.1f", progress-oldProgress) .. "%)" , 1, 1, 0, 1)
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
    for i=1, GetNumQuestLogEntries() do
        local questInfo = GetInfo(i)
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

local questProgressTracker = {}
questProgressTracker.name = "QuestProgressTracker"
questProgressTracker.events = {
    { "QUEST_LOG_UPDATE" },
    { "QUEST_REMOVED" }
}
questProgressTracker.onUpdate = onUpdate
questProgressTracker.initialize = initialize
questProgressTracker.terminate = terminate

addonTable[questProgressTracker.name] = questProgressTracker
