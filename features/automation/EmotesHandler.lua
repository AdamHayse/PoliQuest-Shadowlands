local _, addonTable = ...

local feature = {}

local DEBUG_EMOTES_HANDLER
function feature.setDebug(enabled)
    DEBUG_EMOTES_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_EMOTES_HANDLER
end
local print, debugPrint, uniquePrint = addonTable.util.getPrintFunction(feature)

local targetWhitelist = {
    ["Runestone of Rituals"] = {
        questID = 58621,
        emote = "kneel"
    },
    ["Runestone of Plague"] = {
        questID = 58621,
        emote = "bleed"
    },
    ["Runestone of Chosen"] = {
        questID = 58621,
        emote = "salute"
    },
    ["Runestone of Constucts"] = {
        questID = 58621,
        emote = "flex"
    },
    ["Runestone of Eyes"] = {
        questID = 58621,
        emote = "sneak"
    }
}

local messageWhitelist = {
    dance = "dance",
    Introductions = "introduce",
    praise = "praise",
    thank = "thank",
    cheering = "cheer",
    strong = "flex"
}

feature.eventHandlers = {}

local pendingEmote
function feature.eventHandlers.onPlayerTargetChanged()
    local targetName = UnitName("target")
    if targetName and targetWhitelist[targetName] and C_QuestLog.GetLogIndexForQuestID(targetWhitelist[targetName].questID) then
        DoEmote(targetWhitelist[targetName].emote)
    elseif pendingEmote and targetName == "Playful Trickster" then
        DoEmote(pendingEmote)
        pendingEmote = nil
    end
end

function feature.eventHandlers.onChatMsgMonsterSay(chatMessage, name)
    if name == "Playful Trickster" then
        for k, v in pairs(messageWhitelist) do
            if string.match(chatMessage, k) then
                if UnitName("target") ~= "Playful Trickster" then
                    print("|cFFFF0000Make sure to target Playerful Trickster!|r")
                    pendingEmote = v
                    return
                end
                DoEmote(v)
            end
        end
        if pendingEmote and (string.match(chatMessage, "not right") or string.match(chatMessage, "Just disappointed") or string.match(chatMessage, "I told you the rules")) then
            pendingEmote = nil
        end
    end
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.QuestEmoteAutomation = feature
