local _, addonTable = ...

local feature = {}

local DEBUG_QUEST_TRACKING_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_TRACKING_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_TRACKING_HANDLER
end
local print, debugPrint, uniquePrint = addonTable.util.getPrintFunction(feature)

feature.eventHandlers = {}

function feature.eventHandlers.onQuestAccepted(questID)
    local logIndex = C_QuestLog.GetLogIndexForQuestID(questID)
    if not logIndex then
        return 
    end
    local info = C_QuestLog.GetInfo(logIndex)
    local isCampaign = not not info.campaignID
    local isDaily = not not (info.frequency == 1)
    local isWeekly = not not (info.frequency == 2)
    local isLegendary = C_QuestLog.IsLegendaryQuest(questID)
    local isLowLevel = C_QuestLog.IsQuestTrivial(questID)
    debugPrint("isCampaign: " .. tostring(isCampaign))
    debugPrint("isDaily: " .. tostring(isDaily))
    debugPrint("isWeekly: " .. tostring(isWeekly))
    debugPrint("isLegendary: " .. tostring(isLegendary))
    debugPrint("isLowLevel: " .. tostring(isLowLevel))

    if TrackCampaign and isCampaign
    or TrackDaily and isDaily
    or TrackWeekly and isWeekly
    or TrackLegendary and isLegendary
    or TrackLowLevel and isLowLevel
    or TrackAllOthers and not (isCampaign or isDaily or isWeekly or isLegendary or isLowLevel) then
        debugPrint("Tracking quest " .. info.title)
        C_QuestLog.AddQuestWatch(questID, 1)
    end
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
function feature.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. tostring(value))
    if switchName == "TrackCampaign" then
        TrackCampaign = value
    elseif switchName == "TrackDaily" then
        TrackDaily = value
    elseif switchName == "TrackWeekly" then
        TrackWeekly = value
    elseif switchName == "TrackLegendary" then
        TrackLegendary = value
    elseif switchName == "TrackLowLevel" then
        TrackLowLevel = value
    elseif switchName == "TrackAllOthers" then
        TrackAllOthers = value
    end
end
addonTable.features = addonTable.features or {}
addonTable.features.AutoTrackQuests = feature