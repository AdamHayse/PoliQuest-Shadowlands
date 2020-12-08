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


addonTable.MailboxAutomation_OnMailInboxUpdate = function()
    onMailboxShow()
end

addonTable.MailboxAutomation_OnMailShow = function()
    if GetInboxNumItems() > 0 then
        onMailboxShow()
    end
end

local initialize = function()
end

local terminate = function()
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
