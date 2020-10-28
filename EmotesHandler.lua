local _, addonTable = ...

local UnitName, C_QuestLog, DoEmote, pairs, string, print, string = UnitName, C_QuestLog, DoEmote, pairs, string, print, string

local targetWhitelist = {
    ["Runestone of Rituals"] = {
        ["questID"] = 58621,
        ["emote"] = "kneel"
    },
    ["Runestone of Plague"] = {
        ["questID"] = 58621,
        ["emote"] = "bleed"
    },
    ["Runestone of Chosen"] = {
        ["questID"] = 58621,
        ["emote"] = "salute"
    },
    ["Runestone of Constucts"] = {
        ["questID"] = 58621,
        ["emote"] = "flex"
    },
    ["Runestone of Eyes"] = {
        ["questID"] = 58621,
        ["emote"] = "sneak"
    }
}

local messageWhitelist = {
    ["dance"] = "dance",
    ["Introductions"] = "introduce",
    ["praise"] = "praise",
    ["thank"] = "thank",
    ["cheering"] = "cheer",
    ["strong"] = "flex"
}

local pendingEmote
addonTable.QuestEmoteAutomation_OnPlayerTargetChanged = function()
    local targetName = UnitName("target")
    if targetName and targetWhitelist[targetName] and C_QuestLog.GetLogIndexForQuestID(targetWhitelist[targetName]["questID"]) then
        DoEmote(targetWhitelist[targetName]["emote"])
    elseif pendingEmote and targetName == "Playful Trickster" then
        DoEmote(pendingEmote)
        pendingEmote = nil
    end
end

addonTable.QuestEmoteAutomation_OnChatMsgMonsterSay = function(chatMessage, name)
    if name == "Playful Trickster" then
        for k, v in pairs(messageWhitelist) do
            if string.match(chatMessage, k) then
                if UnitName("target") ~= "Playful Trickster" then
                    print("|cFF5c8cc1PoliQuest:|r |cFFFF0000Make sure to target Playerful Trickster!|r")
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

local initialize = function()
end

local terminate = function()
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