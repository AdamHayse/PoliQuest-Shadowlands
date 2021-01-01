local _, addonTable = ...

local IsInGroup, GetNumGroupMembers, IsPushableQuest, LE_PARTY_CATEGORY_HOME = IsInGroup, GetNumGroupMembers, C_QuestLog.IsPushableQuest, LE_PARTY_CATEGORY_HOME
local GetInfo, GetLogIndexForQuestID, SetSelectedQuest, QuestLogPushQuest = C_QuestLog.GetInfo, C_QuestLog.GetLogIndexForQuestID, C_QuestLog.SetSelectedQuest, QuestLogPushQuest
local GetZoneText, GetNumQuestLogEntries, IsInRaid, SendChatMessage = GetZoneText, C_QuestLog.GetNumQuestLogEntries, IsInRaid, SendChatMessage
local tinsert, tremove, GetTime = table.insert, table.remove, GetTime

local function debugPrint(text)
    if DEBUG_QUEST_SHARING_HANDLER then
        print("|cFF5c8cc1PoliQuest:|r " .. text)
    end
end

local pendingShare, awaitingResponses, autoShareInProgress, msgCheckBuffer, numPartyMembers, shareTime
local sharedWithCount, responseCount = 0, 0
local shareQueue
function addonTable.QuestSharingAutomation_OnQuestAccepted(questID)
    debugPrint("Accepted quest: "..questID)
    if IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 1 and IsPushableQuest(questID) then
        debugPrint("in party and have party members and quest is pushable")
        local questInfo = GetInfo(GetLogIndexForQuestID(questID))
        debugPrint("quest frequency: "..questInfo.frequency .. " quest level: "..questInfo.level)
        if questInfo.frequency == 1 and questInfo.level == 60 then
            tinsert(shareQueue, questID)
            debugPrint("quest inserted into share queue. size: " .. #shareQueue)
            pendingShare = true
        end
    else
        debugPrint("Not in party or no party members or quest is not pushable")
    end
end

local function abortAutoShare()
    debugPrint("aborted autoshare")
    shareQueue = {}
    pendingShare = nil
    awaitingResponses = nil
    autoShareInProgress = nil
    sharedWithCount = 0
    responseCount = 0
end

local function fetchZoneDailies()
    local playerZone = GetZoneText()
    debugPrint("player zone: " .. (playerZone or "nil"))
    local i, total = 1, GetNumQuestLogEntries()
    while i <= total do
        local questLogInfo = GetInfo(i)
        if questLogInfo.isHeader and questLogInfo.title == GetZoneText() then
            debugPrint("found quest header for current zone")
            i = i + 1
            local zoneDailies = {}
            while i <= total do
                questLogInfo = GetInfo(i)
                if questLogInfo.isHeader then
                    break
                end
                if questLogInfo.frequency == 1 and questLogInfo.level == 60 and IsPushableQuest(questLogInfo.questID) then
                    debugPrint("added quest to dailies list: " .. questLogInfo.title)
                    tinsert(zoneDailies, questLogInfo.questID)
                end
                i = i + 1
            end
            return zoneDailies
        end
        i = i + 1
    end
end

local function addZoneDailiesToQueue()
    local dailies = fetchZoneDailies()
    if dailies and #dailies > 0 then
        SendChatMessage("[PoliQuest] Sharing " .. GetZoneText() .. " dailies...", "PARTY")
        for i=1, #dailies do
            local j = 1
            local exists = false
            while j <= #shareQueue do
                if dailies[i] == shareQueue[j] then
                    debugPrint("daily already in queue: " .. dailies[i])
                    debugPrint("queue size: " .. #shareQueue)
                    exists = true
                    break
                end
                j = j + 1
            end
            if not exists then
                debugPrint("added quest to queue: " .. dailies[i])
                tinsert(shareQueue, dailies[i])
                debugPrint("queue size: " .. #shareQueue)
                pendingShare = true
            end
        end
    end
end

function addonTable.QuestSharingAutomation_OnGroupJoined()
    numPartyMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
    if IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) and numPartyMembers > 1 then
        addZoneDailiesToQueue()
    end
end

function addonTable.QuestSharingAutomation_OnGroupLeft()
    debugPrint("aborting from GroupLeft handler")
    abortAutoShare()
end

function addonTable.QuestSharingAutomation_OnGroupRosterUpdate()
    local currentNumPartyMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
    if (numPartyMembers or 0) < currentNumPartyMembers then 
        if IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) and currentNumPartyMembers > 1 then
            addZoneDailiesToQueue()
        end
    end
    numPartyMembers = currentNumPartyMembers
end

local function cleanUp()
    debugPrint("cleaning up feature flags")
    sharedWithCount = 0
    responseCount = 0
    autoShareInProgress = nil
    awaitingResponses = nil
    msgCheckBuffer = nil
    shareTime = nil
    if #shareQueue == 0 then
        debugPrint("auto share complete")
    end
end

function addonTable.QuestSharingAutomation_OnChatMsgSystem(msg)
    if msg:find("Sharing quest with") then
        if autoShareInProgress then
            debugPrint("aborting from ChatMsgSystem handler")
            abortAutoShare()
        end
        sharedWithCount = sharedWithCount + 1
        debugPrint("sharedWithCount: " .. sharedWithCount .. " responseCount: " .. responseCount)
    elseif msg:find("has accepted your quest") or msg:find("has declined your quest") then
        responseCount = responseCount + 1
        debugPrint("sharedWithCount: " .. sharedWithCount .. " responseCount: " .. responseCount)
        if not msgCheckBuffer and sharedWithCount == responseCount then
            debugPrint("cleaning up in OnChatMsgSystem handler")
            cleanUp()
        end
    end
end

local function onUpdate()
    if pendingShare and not awaitingResponses then
        debugPrint("pushing quest: " .. shareQueue[1])
        SetSelectedQuest(shareQueue[1])
        QuestLogPushQuest()
        tremove(shareQueue, 1)
        debugPrint("quest removed from share queue. size: " .. #shareQueue)
        pendingShare = #shareQueue ~= 0
        if not pendingShare then
            debugPrint("finished sharing dailies")
        end
        awaitingResponses = true
        shareTime = GetTime()
        msgCheckBuffer = true
    end
    if msgCheckBuffer and GetTime() > shareTime + 1 then
        debugPrint("check was buffered. " .. "sharedWithCount: " .. sharedWithCount .. " responseCount: " .. responseCount)
        if sharedWithCount == responseCount then
            debugPrint("cleaning up directly after message check buffer")
            cleanUp()
        else
            debugPrint("set msgCheckBuffer to nil")
            autoShareInProgress = true
        end
        msgCheckBuffer = nil
    end
    if awaitingResponses and GetTime() > shareTime + 10 then
        debugPrint("timed out")
        cleanUp()
    end
end

local function initialize()
    pendingShare, awaitingResponses, autoShareInProgress, msgCheckBuffer, numPartyMembers, shareTime = nil, nil, nil, nil, nil, nil
    sharedWithCount, responseCount = 0, 0
    shareQueue = {}
end

local function terminate()
    pendingShare, awaitingResponses, autoShareInProgress, msgCheckBuffer, numPartyMembers, shareTime = nil, nil, nil, nil, nil, nil
    sharedWithCount, responseCount = nil, nil
    shareQueue = nil
end

local questSharingAutomation = {}
questSharingAutomation.name = "QuestSharingAutomation"
questSharingAutomation.events = {
    { "QUEST_ACCEPTED" },
    { "GROUP_JOINED" },
    { "GROUP_LEFT" },
    { "GROUP_ROSTER_UPDATE" },
    { "CHAT_MSG_SYSTEM" }
}
questSharingAutomation.onUpdate = onUpdate
questSharingAutomation.initialize = initialize
questSharingAutomation.terminate = terminate
addonTable[questSharingAutomation.name] = questSharingAutomation
