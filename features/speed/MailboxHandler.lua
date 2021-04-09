local _, addonTable = ...

local GetInboxItem, GetInboxNumItems, TakeInboxItem = GetInboxItem, GetInboxNumItems, TakeInboxItem

local feature = {}

local DEBUG_MAILBOX_HANDLER
function feature.setDebug(enabled)
    DEBUG_MAILBOX_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_MAILBOX_HANDLER
end

local function debugPrint(text)
    if DEBUG_MAILBOX_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local function onMailboxShow()
    for i=1, GetInboxNumItems() do
        for j=1, 12 do
            if GetInboxItem(i, j) == "Cracked Radinax Control Gem" then
                TakeInboxItem(i, j)
                return
            end
        end
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onMailInboxUpdate()
    onMailboxShow()
end

function feature.eventHandlers.onMailShow()
    if GetInboxNumItems() > 0 then
        onMailboxShow()
    end
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.MailboxAutomation = feature
