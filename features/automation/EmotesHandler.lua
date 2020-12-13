local _, addonTable = ...

local UnitName, GetLogIndexForQuestID, DoEmote, pairs, smatch, print = UnitName, C_QuestLog.GetLogIndexForQuestID, DoEmote, pairs, string.match, print

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

local pendingEmote
function addonTable.QuestEmoteAutomation_OnPlayerTargetChanged()
    local targetName = UnitName("target")
    if targetName and targetWhitelist[targetName] and GetLogIndexForQuestID(targetWhitelist[targetName].questID) then
        DoEmote(targetWhitelist[targetName].emote)
    elseif pendingEmote and targetName == "Playful Trickster" then
        DoEmote(pendingEmote)
        pendingEmote = nil
    end
end

function addonTable.QuestEmoteAutomation_OnChatMsgMonsterSay(chatMessage, name)
    if name == "Playful Trickster" then
        for k, v in pairs(messageWhitelist) do
            if smatch(chatMessage, k) then
                if UnitName("target") ~= "Playful Trickster" then
                    print("|cFF5c8cc1PoliQuest:|r |cFFFF0000Make sure to target Playerful Trickster!|r")
                    pendingEmote = v
                    return
                end
                DoEmote(v)
            end
        end
        if pendingEmote and (smatch(chatMessage, "not right") or smatch(chatMessage, "Just disappointed") or smatch(chatMessage, "I told you the rules")) then
            pendingEmote = nil
        end
    end
end

local function initialize()
end

local function terminate()
end

local questEmoteAutomation = {}
questEmoteAutomation.name = "QuestEmoteAutomation"
questEmoteAutomation.events = {
    { "PLAYER_TARGET_CHANGED" },
    { "CHAT_MSG_MONSTER_SAY" }
}
questEmoteAutomation.initialize = initialize
questEmoteAutomation.terminate = terminate
addonTable[questEmoteAutomation.name] = questEmoteAutomation
