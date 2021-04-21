local _, addonTable = ...

local innWhitelist = addonTable.data.innWhitelist

local feature = {}

local DEBUG_HEARTHSTONE_HANDLER
function feature.setDebug(enabled)
    DEBUG_HEARTHSTONE_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_HEARTHSTONE_HANDLER
end

local function debugPrint(text)
    if DEBUG_HEARTHSTONE_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function onConfirmBinder()
    if UnitLevel("player") < 60 then
        local targetName = UnitName("target")
        if GossipFrameNpcNameText:GetText() and innWhitelist[GossipFrameNpcNameText:GetText()]
        or targetName and innWhitelist[targetName] then
            StaticPopup1Button1:Click()
        end
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onGossipShow()
    if innWhitelist[GossipFrameNpcNameText:GetText()] then
        local gossipOptions = C_GossipInfo.GetOptions()
        local numOptions = C_GossipInfo.GetNumOptions()
        for i=1, numOptions do
            if gossipOptions[i].type == "binder" then
                C_GossipInfo.SelectOption(i)
                StaticPopup1Button1:Click("LeftButton")
            end
        end
    end
end

feature.eventHandlers.onConfirmBinder = onConfirmBinder

feature.eventHandlers.onGossipClosed = onConfirmBinder

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.HearthstoneAutomation = feature
