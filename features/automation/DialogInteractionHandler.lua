local _, addonTable = ...

local dialogWhitelist = addonTable.data.dialogWhitelist

local feature = {}

local DEBUG_DIALOG_INTERACTION_HANDLER
function feature.setDebug(enabled)
    DEBUG_DIALOG_INTERACTION_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_DIALOG_INTERACTION_HANDLER
end

local function debugPrint(text)
    if DEBUG_DIALOG_INTERACTION_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function searchDialogOptions(questDialog)
    local gossipOptions = C_GossipInfo.GetOptions()
    local numOptions = C_GossipInfo.GetNumOptions()
    for i=1, numOptions do
        local gossip = gossipOptions[i]
        local dialog = questDialog.dialog
        if type(dialog) == "string" then
            if questDialog.dialog == gossip.name then
                C_GossipInfo.SelectOption(i)
                return true
            end
        else
            for _, v in ipairs(dialog) do
                if v == gossip.name then
                    C_GossipInfo.SelectOption(i)
                    return true
                end
            end
        end
    end
end

local function onGossipShow()
    local numQuests = C_QuestLog.GetNumQuestLogEntries() or 0
    debugPrint("numQuests: "..numQuests)
    for i=1, numQuests do
        local questName = C_QuestLog.GetInfo(i).title
        local questDialog = dialogWhitelist[questName]
        if questDialog then
            debugPrint("Selecting quest dialog")
            if type(questDialog.npc) == "string" then
                if questDialog.npc == GossipFrameNpcNameText:GetText() then
                    searchDialogOptions(questDialog)
                end
            else
                for j, v in ipairs(questDialog.npc) do
                    if questDialog.npc[j] == GossipFrameNpcNameText:GetText() then
                        if searchDialogOptions(questDialog) then
                            return
                        end
                    end
                end
            end
        end
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onGossipShow()
    debugPrint("DialogInteractionAutomation - Entering onGossipShow")
    onGossipShow()
    debugPrint("DialogInteractionAutomation - Exiting onGossipShow")
end

function feature.eventHandlers.onQuestAccepted(questID)
    debugPrint("DialogInteractionAutomation - Entering onQuestAccepted")
    if GossipFrame:IsVisible() then
        onGossipShow()
    end
    debugPrint("DialogInteractionAutomation - Exiting onQuestAccepted")
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.DialogInteractionAutomation = feature
