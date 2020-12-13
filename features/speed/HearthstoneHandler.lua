local _, addonTable = ...

local UnitLevel, UnitName, GetOptions, GetNumOptions, SelectOption = UnitLevel, UnitName, C_GossipInfo.GetOptions, C_GossipInfo.GetNumOptions, C_GossipInfo.SelectOption
local GossipFrameNpcNameText, StaticPopup1Button1 = GossipFrameNpcNameText, StaticPopup1Button1

local innWhitelist = addonTable.innWhitelist

local function onConfirmBinder()
    if UnitLevel("player") < 60 then
        local targetName = UnitName("target")
        if GossipFrameNpcNameText:GetText() and innWhitelist[GossipFrameNpcNameText:GetText()]
        or targetName and innWhitelist[targetName] then
            StaticPopup1Button1:Click()
        end
    end
end

function addonTable.HearthstoneAutomation_OnGossipShow()
    if innWhitelist[GossipFrameNpcNameText:GetText()] then
        local gossipOptions = GetOptions()
        local numOptions = GetNumOptions()
        for i=1, numOptions do
            if gossipOptions[i].type == "binder" then
                SelectOption(i)
                StaticPopup1Button1:Click("LeftButton")
            end
        end
    end
end

addonTable.HearthstoneAutomation_OnConfirmBinder = onConfirmBinder

addonTable.HearthstoneAutomation_OnGossipClosed = onConfirmBinder

local function initialize()
end

local function terminate()
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
