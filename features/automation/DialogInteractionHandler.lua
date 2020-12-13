local _, addonTable = ...

local GetOptions, GetNumOptions, SelectOption, GetNumQuestLogEntries, GetInfo = C_GossipInfo.GetOptions, C_GossipInfo.GetNumOptions, C_GossipInfo.SelectOption, C_QuestLog.GetNumQuestLogEntries, C_QuestLog.GetInfo
local ipairs, type = ipairs, type
local GossipFrameNpcNameText, GossipFrame = GossipFrameNpcNameText, GossipFrame
local dialogWhitelist = addonTable.dialogWhitelist

local function debugPrint(text)
    if DEBUG_DIALOG_INTERACTION_HANDLER then
        print("|cFF5c8cc1PoliQuest:|r " .. text)
    end
end


local function searchDialogOptions(questDialog)
    local gossipOptions = GetOptions()
    local numOptions = GetNumOptions()
    for i=1, numOptions do
        local gossip = gossipOptions[i]
        local dialog = questDialog.dialog
        if type(dialog) == "string" then
            if questDialog.dialog == gossip.name then
                SelectOption(i)
                return true
            end
        else
            for _, v in ipairs(dialog) do
                if v == gossip.name then
                    SelectOption(i)
                    return true
                end
            end
        end
    end
end

local function onGossipShow()
    local numQuests = GetNumQuestLogEntries() or 0
    debugPrint("numQuests: "..numQuests)
    for i=1, numQuests do
        local questName = GetInfo(i).title
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

function addonTable.DialogInteractionAutomation_OnGossipShow()
    onGossipShow()
end

function addonTable.DialogInteractionAutomation_OnQuestAccepted(questID)
    if GossipFrame:IsVisible() then
        onGossipShow()
    end
end

local function initialize()
end

local function terminate()
end

local dialogInteractionAutomation = {}
dialogInteractionAutomation.name = "DialogInteractionAutomation"
dialogInteractionAutomation.events = {
    { "GOSSIP_SHOW" },
    { "QUEST_ACCEPTED" }
}
dialogInteractionAutomation.initialize = initialize
dialogInteractionAutomation.terminate = terminate
addonTable[dialogInteractionAutomation.name] = dialogInteractionAutomation
