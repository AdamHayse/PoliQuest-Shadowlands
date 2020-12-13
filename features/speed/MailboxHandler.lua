local _, addonTable = ...

local GetInboxItem, GetInboxNumItems, TakeInboxItem = GetInboxItem, GetInboxNumItems, TakeInboxItem

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

function addonTable.MailboxAutomation_OnMailInboxUpdate()
    onMailboxShow()
end

function addonTable.MailboxAutomation_OnMailShow()
    if GetInboxNumItems() > 0 then
        onMailboxShow()
    end
end

local function initialize()
end

local function terminate()
end

local mailboxAutomation = {}
mailboxAutomation.name = "MailboxAutomation"
mailboxAutomation.events = {
    { "MAIL_INBOX_UPDATE" },
    { "MAIL_SHOW" }
}
mailboxAutomation.initialize = initialize
mailboxAutomation.terminate = terminate
addonTable[mailboxAutomation.name] = mailboxAutomation
