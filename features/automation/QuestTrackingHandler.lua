local _, addonTable = ...

local AddQuestWatch = C_QuestLog.AddQuestWatch

function addonTable.AutoTrackQuests_OnQuestAccepted(questID)
    AddQuestWatch(questID, 1)
end

local function initialize()
end

local function terminate()
end

local autoTrackQuests = {}
autoTrackQuests.name = "AutoTrackQuests"
autoTrackQuests.events = {
    { "QUEST_ACCEPTED" }
}
autoTrackQuests.initialize = initialize
autoTrackQuests.terminate = terminate
addonTable[autoTrackQuests.name] = autoTrackQuests