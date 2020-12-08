local _, addonTable = ...

local ipairs, pairs, GetItemCount, GetItemInfo = ipairs, pairs, GetItemCount, GetItemInfo
local GetItemIcon, GetItemCooldown, CreateFrame = GetItemIcon, GetItemCooldown, CreateFrame
local UIParent, print, table, GetTime, select = UIParent, print, table, GetTime, select
local InCombatLockdown, GameTooltip, GameTooltip_SetDefaultAnchor = InCombatLockdown, GameTooltip, GameTooltip_SetDefaultAnchor

local questItems = addonTable.questItems

local currentItems, currentItemIndex

-- quest item button
local pqButton = CreateFrame("Button", "PQButton", UIParent, "SecureActionButtonTemplate")
pqButton.Texture = pqButton:CreateTexture("PoliQuestItemButtonTexture","BACKGROUND")
pqButton.Texture:SetAllPoints(pqButton)
pqButton:SetPoint("CENTER", UIParent, 0, 0)
pqButton:SetSize(64, 64)
pqButton:SetClampedToScreen(true)
pqButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
pqButton:SetAttribute("type", "item")
pqButton:SetScript("OnEnter", function()
    if currentItems[currentItemIndex] == nil then
        return
    end
    GameTooltip:ClearLines()
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:SetHyperlink(select(2, GetItemInfo(currentItems[currentItemIndex])))
    GameTooltip:Show()
end)
pqButton:SetScript("OnLeave", function()
    GameTooltip:ClearLines()
    GameTooltip:Hide()
end)
pqButton:RegisterForDrag("LeftButton")
pqButton:SetScript("OnDragStart", function(self) if self:IsMovable() then self:StartMoving() end end)
pqButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
pqButton.Cooldown = CreateFrame("Cooldown", "PoliQuestItemCooldown", pqButton, "CooldownFrameTemplate")
pqButton.Cooldown:SetAllPoints(pqButton)
pqButton.FontString = pqButton:CreateFontString("PoliQuestItemCount", "BACKGROUND")
pqButton.FontString:SetPoint("BOTTOMRIGHT", -4, 4)
pqButton.FontString:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE, MONOCHROME")

pqButton.unlock = function(self)
    if not self:IsVisible() then
        buttonTexture = self.Texture:GetTexture()
        self.Texture:SetTexture(134400)
        self.PrevButton:Disable()
        self.PrevButton:Show()
        self.NextButton:Disable()
        self.PrevButton:Show()
        self.PrevView.Texture:SetTexture(134400)
        self.PrevView:Disable()
        self.PrevView:Show()
        self.ViewNext.Texture:SetTexture(134400)
        self.ViewNext:Disable()
        self.ViewNext:Show()
        self:Show()
    end
    self.LockButton:Show()
    self:SetMovable(true)
end

pqButton.lock = function(self)
    if self:GetAttribute("item") == nil then
        self:Hide()
    end
    self.LockButton:Hide()
    self:SetMovable(false)
    print("|cFF5c8cc1PoliQuest:|r Button will show when you have a Shadowlands quest item in your bags.")
    print("|cFF5c8cc1/pq toggle:|r to show/move button again.")
end

local updateButton = function(refresh)
    if #currentItems == 0 then
        currentItemIndex = nil
        pqButton:SetAttribute("item", nil) 
        pqButton:Hide()
    else
        if refresh then
            currentItemIndex = 1
        end
        local itemID = currentItems[currentItemIndex]
        local icon = GetItemIcon(itemID)
        pqButton.Texture:SetTexture(icon)
        pqButton:SetAttribute("item", "item:"..itemID)
        pqButton:Show()
        local startTime, duration = GetItemCooldown(itemID)
        if startTime ~= 0 and duration ~= 0 then
            pqButton.Cooldown:SetCooldown(startTime, duration)
        else
            pqButton.Cooldown:SetCooldown(0, 0)
        end
        if currentItemIndex then
            local itemCount = GetItemCount(currentItems[currentItemIndex])
            if itemCount > 1 then
                pqButton.FontString:SetText(itemCount)
            else
                pqButton.FontString:SetText("")
            end
        end
        if #currentItems == 1 then
            pqButton.PrevButton:Disable()
            pqButton.NextButton:Disable()
            pqButton.PrevView:Disable()
            pqButton.PrevView:Hide()
            pqButton.ViewNext:Disable()
            pqButton.ViewNext:Hide()
        elseif currentItemIndex == 1 then
            pqButton.PrevButton:Enable()
            pqButton.NextButton:Enable()
            pqButton.PrevView:Disable()
            pqButton.PrevView:Hide()
            pqButton.ViewNext.Texture:SetTexture(GetItemIcon(currentItems[2]))
            pqButton.ViewNext:Enable()
            pqButton.ViewNext:Show()
        elseif currentItemIndex == #currentItems then
            pqButton.PrevButton:Enable()
            pqButton.NextButton:Enable()
            pqButton.PrevView.Texture:SetTexture(GetItemIcon(currentItems[#currentItems-1]))
            pqButton.PrevView:Enable()
            pqButton.PrevView:Show()
            pqButton.ViewNext:Disable()
            pqButton.ViewNext:Hide()
        else
            pqButton.PrevButton:Enable()
            pqButton.NextButton:Enable()
            pqButton.PrevView.Texture:SetTexture(GetItemIcon(currentItems[currentItemIndex-1]))
            pqButton.PrevView:Enable()
            pqButton.PrevView:Show()
            pqButton.ViewNext.Texture:SetTexture(GetItemIcon(currentItems[currentItemIndex+1]))
            pqButton.ViewNext:Enable()
            pqButton.ViewNext:Show()
        end
        pqButton:Show()
    end
end

local prevItemButton_OnClick = function()
    currentItemIndex = (currentItemIndex - 2) % #currentItems + 1
    updateButton()
end

local nextItemButton_OnClick = function()
    currentItemIndex = currentItemIndex % #currentItems + 1
    updateButton()
end

-- left arrow button
local prevButton = CreateFrame("Button", "PQPrev", pqButton, "SecureActionButtonTemplate")
prevButton:SetPoint("BOTTOMRIGHT", "$parent", "TOP", 0, 0)
prevButton:SetSize(32, 32)
prevButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
prevButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
prevButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
prevButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
prevButton:SetScript("OnClick", prevItemButton_OnClick)
pqButton.PrevButton = prevButton

-- right arrow button
local nextButton = CreateFrame("Button", "PQNext", pqButton, "SecureActionButtonTemplate")
nextButton:SetPoint("BOTTOMLEFT", "$parent", "TOP", 0, 0)
nextButton:SetSize(32, 32)
nextButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
nextButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
nextButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
nextButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
nextButton:SetScript("OnClick", nextItemButton_OnClick)
pqButton.NextButton = nextButton

-- left item view
local prevView = CreateFrame("Button", "PoliPrevViewButton", pqButton, "SecureActionButtonTemplate")
prevView:SetPoint("RIGHT", "$parent", "LEFT", -4, 0)
prevView:SetSize(32, 32)
prevView:SetScript("OnClick", prevItemButton_OnClick)
prevView.Texture = prevView:CreateTexture("PoliPrevViewButtonTexture","BACKGROUND")
prevView.Texture:SetAllPoints(prevView)
pqButton.PrevView = prevView

-- right item view
local nextView = CreateFrame("Button", "PoliViewNextButton", pqButton, "SecureActionButtonTemplate")
nextView:SetPoint("LEFT", "$parent", "RIGHT", 4, 0)
nextView:SetSize(32, 32)
nextView:SetScript("OnClick", nextItemButton_OnClick)
nextView.Texture = nextView:CreateTexture("PoliViewNextButtonTexture","BACKGROUND")
nextView.Texture:SetAllPoints(nextView)
pqButton.ViewNext = nextView

-- lock button
local lockButton = CreateFrame("Button", "PoliLockButton", pqButton, "SecureActionButtonTemplate")
lockButton:SetPoint("TOPLEFT", "$parent", "BOTTOMRIGHT", 0, 0)
lockButton:SetSize(32, 32)
lockButton:SetNormalTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
lockButton:SetPushedTexture("Interface\\Buttons\\LockButton-Unlocked-Down")
lockButton:SetDisabledTexture("Interface\\Buttons\\CancelButton-Up")
lockButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
lockButton:SetScript("OnClick", function() pqButton:lock() end)
lockButton.FontString = lockButton:CreateFontString("PoliLockButtonText", "BACKGROUND")
lockButton.FontString:SetPoint("RIGHT", "$parent", "LEFT", 0, 0)
lockButton.FontString:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE, MONOCHROME")
lockButton.FontString:SetText("MOVE")
pqButton.LockButton = lockButton

local pendingUpdate
local throttleItemCheck

addonTable.QuestItemButton_OnPlayerRegenEnabled = function()
    if not pendingUpdate and #currentItems > 1 then
        pqButton.PrevButton:Enable()
        pqButton.NextButton:Enable()
        pqButton.PrevView:Enable()
        pqButton.ViewNext:Enable()
    end
end

addonTable.QuestItemButton_OnPlayerRegenDisabled = function()
    if #currentItems > 1 then
        pqButton.PrevButton:Disable()
        pqButton.NextButton:Disable()
        pqButton.PrevView:Disable()
        pqButton.ViewNext:Disable()
    end
end

local bagUpdateEventsHandler = function()
    if currentItemIndex then
        local itemCount = GetItemCount(currentItems[currentItemIndex])
        if itemCount > 1 then
            pqButton.FontString:SetText(itemCount)
        else
            pqButton.FontString:SetText("")
        end
    end
    throttleItemCheck = GetTime()
end

addonTable.QuestItemButton_OnBagUpdate = bagUpdateEventsHandler

addonTable.QuestItemButton_OnBagUpdateCooldown = bagUpdateEventsHandler

addonTable.QuestItemButton_OnUnitSpellcastSucceeded = function(...)
    if currentItemIndex and questItems[currentItems[currentItemIndex]] and questItems[currentItems[currentItemIndex]]["spellID"] == select(3, ...)
    and questItems[currentItems[currentItemIndex]]["cooldown"] then
        pqButton.Cooldown:SetCooldown(GetTime(), questItems[currentItems[currentItemIndex]]["cooldown"])
    end
end


local itemsChanged = function()
    -- questItems >= currentItems
    for itemID,_ in pairs(questItems) do
        local item = GetItemCount(itemID)
        if item > 0 then
            if #currentItems == 0 then
                return true
            end
            for i, v in ipairs(currentItems) do
                if v == itemID then
                    break
                elseif i == #currentItems then
                    return true
                end
            end
        end
    end
    -- questItems <= currentItems
    for i,v in ipairs(currentItems) do
        if GetItemCount(v) == 0 then
            return true
        end
    end
    -- questItems == currentItems
    return false
end

local updateCurrentItems = function()
    currentItems = {}
    for itemID, recordedItemInfo in pairs(questItems) do
        local count = GetItemCount(itemID)
        if count > 0 then
            table.insert(currentItems, itemID)
            questItems[itemID]["count"] = count
        else
            questItems[itemID]["count"] = 0
        end
    end
end

local onUpdate = function()
    if throttleItemCheck and GetTime() - throttleItemCheck > .1 then
        if itemsChanged() then
            updateCurrentItems()
            pendingUpdate = true
        end
        throttleItemCheck = nil
    end
    if pendingUpdate and not InCombatLockdown() then
        updateButton(true)
        pendingUpdate = false
    end
end

local initialize = function()
    throttleItemCheck = nil
    updateCurrentItems()
    pendingUpdate = true
end

local terminate = function()
    throttleItemCheck = nil
    pendingUpdate = false
    currentItems = nil
    currentItemIndex = nil
    pqButton:SetAttribute("item", nil) 
    pqButton:Hide()
end

local questItemButton = {}
questItemButton.name = "QuestItemButton"
questItemButton.events = {
    { "PLAYER_REGEN_ENABLED" },
    { "PLAYER_REGEN_DISABLED" },
    { "BAG_UPDATE" },
    { "BAG_UPDATE_COOLDOWN" },
    { "UNIT_SPELLCAST_SUCCEEDED", "player" }
}
questItemButton.onUpdate = onUpdate
questItemButton.initialize = initialize
questItemButton.terminate = terminate
questItemButton.Button = pqButton

addonTable[questItemButton.name] = questItemButton
