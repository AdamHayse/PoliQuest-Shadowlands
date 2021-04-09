local _, addonTable = ...

local AddQuestWatch = C_QuestLog.AddQuestWatch

local feature = {}

local DEBUG_QUEST_TRACKING_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_TRACKING_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_TRACKING_HANDLER
end

local function debugPrint(text)
    if DEBUG_QUEST_TRACKING_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onQuestAccepted(questID)
    AddQuestWatch(questID, 1)
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.AutoTrackQuests = feature