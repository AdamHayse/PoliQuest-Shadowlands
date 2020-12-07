local _, addonTable = ...

local reportQuestProgressRefreshPending
addonTable.QuestProgressTracker_OnQuestLogUpdate = function()
    reportQuestProgressRefreshPending = true
end

local questProgresses
addonTable.QuestProgressTracker_OnQuestRemoved = function(questID)
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
