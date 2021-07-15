local _, addonTable = ...

local feature = {}

local DEBUG_MAILBOX_HANDLER
function feature.setDebug(enabled)
    DEBUG_MAILBOX_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_MAILBOX_HANDLER
end
local print, debugPrint, uniquePrint = addonTable.util.getPrintFunction(feature)

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
