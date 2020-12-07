local _, addonTable = ...

addonTable.AutoTrackQuests_OnQuestAccepted = function(questID)
    C_QuestLog.AddQuestWatch(questID, 1)
end

local initialize = function()
end

local terminate = function()
end

local autoTrackQuests = {}
autoTrackQuests.name = "AutoTrackQuests"
autoTrackQuests.events = {
    { "QUEST_ACCEPTED" }
}
autoTrackQuests.initialize = initialize
autoTrackQuests.terminate = terminate
addonTable[autoTrackQuests.name] = autoTrackQuests