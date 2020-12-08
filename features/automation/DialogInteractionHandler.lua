local _, addonTable = ...

local dialogWhitelist = addonTable.dialogWhitelist

local searchDialogOptions = function(questDialog)
    local gossipOptions = C_GossipInfo.GetOptions()
    local numOptions = C_GossipInfo.GetNumOptions()
    for i=1, numOptions do
        local gossip = gossipOptions[i]
        local dialog = questDialog["dialog"]
        if type(dialog) == "string" then
            if questDialog["dialog"] == gossip["name"] then
                C_GossipInfo.SelectOption(i)
                return true
            end
        else
            for _, v in ipairs(dialog) do
                if v == gossip["name"] then
                    C_GossipInfo.SelectOption(i)
                    return true
                end
            end
        end
    end
end

local onGossipShow = function()
    local numQuests = C_QuestLog.GetNumQuestLogEntries() or 0
    addonTable.debugPrint("numQuests: "..numQuests)
    for i=1, numQuests do
        local questName = C_QuestLog.GetInfo(i).title
        local questDialog = dialogWhitelist[questName]
        if questDialog then
            addonTable.debugPrint("Selecting quest dialog")
            if type(questDialog["npc"]) == "string" then
                if questDialog["npc"] == GossipFrameNpcNameText:GetText() then
                    searchDialogOptions(questDialog)
                end
            else
                for j, v in ipairs(questDialog["npc"]) do
                    if questDialog["npc"][j] == GossipFrameNpcNameText:GetText() then
                        if searchDialogOptions(questDialog) then
                            return
                        end
                    end
                end
            end
        end
    end
end

addonTable.DialogInteractionAutomation_OnGossipShow = function()
    onGossipShow()
end

addonTable.DialogInteractionAutomation_OnQuestAccepted = function(questID)
    if GossipFrame:IsVisible() then
        onGossipShow()
    end
end

local initialize = function()
end

local terminate = function()
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
