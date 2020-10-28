local _, addonTable = ...

local C_GossipInfo, UnitLevel, UnitName = C_GossipInfo, UnitLevel, UnitName

local innWhitelist = addonTable.innWhitelist

local onConfirmBinder = function()
    if UnitLevel("player") < 60 then
        local targetName = UnitName("target")
        if GossipFrameNpcNameText:GetText() and innWhitelist[GossipFrameNpcNameText:GetText()]
        or targetName and innWhitelist[targetName] then
            StaticPopup1Button1:Click()
        end
    end
end

addonTable.HearthstoneAutomation_OnGossipShow = function()
    if innWhitelist[GossipFrameNpcNameText:GetText()] then
        local gossipOptions = C_GossipInfo.GetOptions()
        local numOptions = C_GossipInfo.GetNumOptions()
        for i=1, numOptions do
            if gossipOptions[i]["type"] == "binder" then
                C_GossipInfo.SelectOption(i)
                StaticPopup1Button1:Click("LeftButton")
            end
        end
    end
end

addonTable.HearthstoneAutomation_OnConfirmBinder = onConfirmBinder

addonTable.HearthstoneAutomation_OnGossipClosed = onConfirmBinder

local initialize = function()
end

local terminate = function()
end

local hearthstoneAutomation = {}
hearthstoneAutomation.name = "HearthstoneAutomation"
hearthstoneAutomation.events = {
    { "GOSSIP_SHOW" },
    { "CONFIRM_BINDER" },
    { "GOSSIP_CLOSED" }
}
hearthstoneAutomation.initialize = initialize
hearthstoneAutomation.terminate = terminate
addonTable[hearthstoneAutomation.name] = hearthstoneAutomation