local addonName, addonTable = ...

local AceGUI = LibStub("AceGUI-3.0")

local xpcall, ipairs, print = xpcall, ipairs, print
local InCombatLockdown, GameFontHighlightLarge, GameFontHighlight = InCombatLockdown, GameFontHighlightLarge, GameFontHighlight

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	if func then
		return xpcall(func, errorhandler, ...)
	end
end

--local prevLeftColumnElementType, 
-- need to remember the last element type in each column in order to do spacing properly (while DFS is going)
-- should remember the depth of the DFS in order to indent properly (indent is the same for each element type?)
-- elements will be anchored to the left of the previous elemnts

-- use 2 anchors to anchor menu elements?
  -- anchor left of menu elemnt to left of container (offset according to depth)
  -- anchor top of menu element to bottom of previous element or top of container (using spacing table to determne the offset)
  -- default height is fine

--[[
    User data:
    - child - used by the custom layout to start the DFS
    - children - used by DFS to nest menu elemnts
]]


local leftColumnHeight, rightColumnHeight
local indentLength = 30
local featureSpacing = 20
local function anchorFramesWithDFS(widget, relativeTo, relativePoint, depth, columnHeight)
    local frame = widget.frame
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", relativeTo, relativePoint, depth * indentLength, -columnHeight)
    if widget.type:find("CheckBox") then
        frame:SetWidth(relativeTo:GetWidth() / 2 - depth * indentLength)
    end
    columnHeight = columnHeight + frame:GetHeight()
    for _, child in ipairs(widget:GetUserData("children") or {}) do
        local childFrame = child.frame
        columnHeight = anchorFramesWithDFS(child, relativeTo, relativePoint, depth + 1, columnHeight)
    end
    return columnHeight
end

-- previous frame in each column needs to be remembered in order to anchor
local function configLayout(parent, children)
    local leftColumnHeight, rightColumnHeight = 0, 0
    for i, child in ipairs(children) do
        if child.type == "PoliFeatureCheckBox" then
            if leftColumnHeight <= rightColumnHeight then
                leftColumnHeight = anchorFramesWithDFS(child, parent, "TOPLEFT", 0, leftColumnHeight) + featureSpacing
            else
                rightColumnHeight = anchorFramesWithDFS(child, parent, "TOP", 0, rightColumnHeight) + featureSpacing
            end
        end
    end
    safecall(parent.obj.LayoutFinished, parent.obj, nil, leftColumnHeight >= rightColumnHeight and leftColumnHeight or rightColumnHeight)
end

AceGUI:RegisterLayout("PoliQuestConfig_Layout", configLayout)

local function menuLayout(parent, children)
    local tabGroupFrame = children[1].frame
    local toggleButtonFrame = children[2].frame
    tabGroupFrame:ClearAllPoints()
    toggleButtonFrame:ClearAllPoints()
    toggleButtonFrame:SetPoint("TOP", parent, "BOTTOM")
    tabGroupFrame:SetPoint("TOP", parent)
    tabGroupFrame:SetWidth(parent:GetWidth())
    tabGroupFrame:SetPoint("BOTTOM", toggleButtonFrame, "TOP")
    
    safecall(parent.obj.LayoutFinished, parent.obj, nil, tabGroupFrame:GetHeight() + toggleButtonFrame:GetHeight())
end

AceGUI:RegisterLayout("PoliQuestMenu_Layout", menuLayout)
--[[
local function shouldDisableWidget(widget)
    return widget.GetValue and not widget:GetValue() or widget.GetText and not widget:GetText()
    return widget.type:find("CheckBox") and widget:GetValue() == false
        or widget.type == "EditBox" and widget:GetText()
end
]]
-- perform DFS to update enabled/disabled status
local function updateCheckBoxEnabledStatus(container, childrenDisabled)
    local children = container.children or container:GetUserData("children") or {}
    for _, child in ipairs(children) do
        child:SetDisabled(childrenDisabled)
        if childrenDisabled or child.type:find("CheckBox") and child:GetValue() == false then
                updateCheckBoxEnabledStatus(child, true)
        end
    end
end

-- callback function should enable/disable children nested under this element as appropriate
local function createFeatureCheckBox(container, label, featureName)
    local featureTable = addonTable.features[featureName]
    local checkbox = AceGUI:Create("PoliFeatureCheckBox")
    checkbox:SetLabel(label)
    checkbox:SetTriState(true)
    local value
    if PoliSavedVars[featureName].enabled then
        if featureTable.isDebug() then
            value = nil
        else
            value = true  
        end
    else
        value = false
    end
    checkbox:SetValue(value)
    checkbox:SetCallback("OnValueChanged", function(widget, event, key)
        updateCheckBoxEnabledStatus(container, false)                       -- does this function work like i want it to?
        if key == false then
            featureTable.setDebug(false)
            print("|cFF5c8cc1PoliQuest:|r " .. label .. " disabled")
            addonTable.util.updateFeatureConfiguration(featureName, featureTable, false)
        else
            if key == true then
                featureTable.setDebug(false)
                print("|cFF5c8cc1PoliQuest:|r " .. label .. " enabled")
            else
                featureTable.setDebug(true)
                print("|cFF5c8cc1PoliQuest:|r " .. label .. " debug enabled")
            end
            addonTable.util.updateFeatureConfiguration(featureName, featureTable, true)
        end
    end)
    return checkbox
end

local function createSwitchCheckBox(container, label, featureName, switchName)
    local featureTable = addonTable.features[featureName]
    local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetLabel(label)
    checkbox:SetValue(PoliSavedVars[featureName].switches[switchName])
    checkbox:SetCallback("OnValueChanged", function(widget, event, key)
        updateCheckBoxEnabledStatus(container, false)                       -- does this function work like i want it to?
        addonTable.util.updateFeatureSwitch(featureName, featureTable, switchName, key)
    end)
    return checkbox
end

local function createSwitchEditBox(container, label, featureName, switchName, width)
    local featureTable = addonTable.features[featureName]
    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel(label)
    editbox:SetWidth(width)
    editbox:SetText(PoliSavedVars[featureName].switches[switchName])
    editbox:SetCallback("OnEnterPressed", function(widget, event, key)
        updateCheckBoxEnabledStatus(container, false)                       -- does this function work like i want it to?
        addonTable.util.updateFeatureSwitch(featureName, featureTable, switchName, key)
    end)
    return editbox
end

local function createSwitchDropdown(container, label, featureName, switchName, values, width)
    local featureTable = addonTable.features[featureName]
    local dropdown = AceGUI:Create("Dropdown")
    dropdown:SetLabel(label)
    dropdown:SetWidth(width)
    dropdown:SetList(values)
    dropdown:SetValue(PoliSavedVars[featureName].switches[switchName])
    dropdown:SetCallback("OnValueChanged", function(widget, event, key)
        updateCheckBoxEnabledStatus(container, false)                       -- does this function work like i want it to?
        addonTable.util.updateFeatureSwitch(featureName, featureTable, switchName, key)
    end)
    return dropdown
end


local function drawGeneralTab(container)
    container:PauseLayout()

    local QuestItemButtonCheckButton = createFeatureCheckBox(container, "Quest Item Button", "QuestItemButton")
    container:AddChild(QuestItemButtonCheckButton)
    
    local SkipCutscenesCheckButton = createFeatureCheckBox(container, "Skip Cutscenes", "SkipCutscenes")
    container:AddChild(SkipCutscenesCheckButton)

    local QuestProgressTrackerCheckButton = createFeatureCheckBox(container, "Quest Progress Tracking", "QuestProgressTracker")
    container:AddChild(QuestProgressTrackerCheckButton)
    
    if InCombatLockdown() then
        updateCheckBoxEnabledStatus(container, true)
    else
        updateCheckBoxEnabledStatus(container, false)
    end
    
    container:ResumeLayout()
    container:DoLayout()
end

local function drawAutomationTab(container)
    container:PauseLayout()

    local QuestInterationAutomationExcludeTrivialCheckBox = createSwitchCheckBox(container, "Exclude Low Level Quests", "QuestInteractionAutomation", "ExcludeTrivial")
    container:AddChild(QuestInterationAutomationExcludeTrivialCheckBox)

    local QuestInterationAutomationModifierDropdown = createSwitchDropdown(container, "Suspend Automation Modifier", "QuestInteractionAutomation", "Modifier", {"Alt", "Ctrl", "Shift"}, 150)
    container:AddChild(QuestInterationAutomationModifierDropdown)

    local QuestInteractionAutomationCheckButton = createFeatureCheckBox(container, "Quest Interaction Automation", "QuestInteractionAutomation")
    QuestInteractionAutomationCheckButton:SetUserData("children", { QuestInterationAutomationExcludeTrivialCheckBox, QuestInterationAutomationModifierDropdown })
    container:AddChild(QuestInteractionAutomationCheckButton)

    local IlvlThreshHoldEditBox = createSwitchEditBox(container, "Item Level Threshold", "QuestRewardSelectionAutomation", "IlvlThreshold", 150)
    container:AddChild(IlvlThreshHoldEditBox)

    local RewardSelectionLogicDropdown = createSwitchDropdown(container, "Reward Selection Logic", "QuestRewardSelectionAutomation", "SelectionLogic", {"Simple Weights", "Pawn Weights", "Item Level", "Vendor Price"}, 150)
    RewardSelectionLogicDropdown:SetItemDisabled(2, not addonTable.properties.PawnLoaded)
    container:AddChild(RewardSelectionLogicDropdown)

    local RewardSelectionLogicModifierDropdown = createSwitchDropdown(container, "Suspend Automation Modifier", "QuestRewardSelectionAutomation", "Modifier", {"Alt", "Ctrl", "Shift"}, 150)
    container:AddChild(RewardSelectionLogicModifierDropdown)

    local QuestRewardSelectionAutomationCheckButton = createFeatureCheckBox(container, "Quest Reward Selection Automation", "QuestRewardSelectionAutomation")
    QuestRewardSelectionAutomationCheckButton:SetUserData("children", { IlvlThreshHoldEditBox, RewardSelectionLogicDropdown, RewardSelectionLogicModifierDropdown })
    container:AddChild(QuestRewardSelectionAutomationCheckButton)

    local AutoTrackQuestsCampaignCheckButton = createSwitchCheckBox(container, "Campaign", "AutoTrackQuests", "TrackCampaign")
    container:AddChild(AutoTrackQuestsCampaignCheckButton)
    
    local AutoTrackQuestsDailyCheckButton = createSwitchCheckBox(container, "Daily", "AutoTrackQuests", "TrackDaily")
    container:AddChild(AutoTrackQuestsDailyCheckButton)
    
    local AutoTrackQuestsWeeklyCheckButton = createSwitchCheckBox(container, "Weekly", "AutoTrackQuests", "TrackWeekly")
    container:AddChild(AutoTrackQuestsWeeklyCheckButton)
    
    local AutoTrackQuestsLegendaryCheckButton = createSwitchCheckBox(container, "Legendary", "AutoTrackQuests", "TrackLegendary")
    container:AddChild(AutoTrackQuestsLegendaryCheckButton)

    local AutoTrackQuestsLowLevelCheckButton = createSwitchCheckBox(container, "Low Level", "AutoTrackQuests", "TrackLowLevel")
    container:AddChild(AutoTrackQuestsLowLevelCheckButton)

    local AutoTrackQuestsAllOthersCheckButton = createSwitchCheckBox(container, "All Others", "AutoTrackQuests", "TrackAllOthers")
    container:AddChild(AutoTrackQuestsAllOthersCheckButton)

    local AutoTrackQuestsCheckButton = createFeatureCheckBox(container, "Quest Tracking Automation", "AutoTrackQuests")
    AutoTrackQuestsCheckButton:SetUserData("children", { AutoTrackQuestsCampaignCheckButton, AutoTrackQuestsDailyCheckButton, AutoTrackQuestsWeeklyCheckButton,
                                                        AutoTrackQuestsLegendaryCheckButton, AutoTrackQuestsLowLevelCheckButton, AutoTrackQuestsAllOthersCheckButton })
    container:AddChild(AutoTrackQuestsCheckButton)

    local DialogInteractionAutomationCheckButton = createFeatureCheckBox(container, "Dialog Interaction Automation", "DialogInteractionAutomation")
    container:AddChild(DialogInteractionAutomationCheckButton)

    local QuestRewardEquipAutomationCheckButton = createFeatureCheckBox(container, "Quest Reward Equip Automation", "QuestRewardEquipAutomation")
    container:AddChild(QuestRewardEquipAutomationCheckButton)

    local QuestEmoteAutomationCheckButton = createFeatureCheckBox(container, "Quest Emote Automation", "QuestEmoteAutomation")
    container:AddChild(QuestEmoteAutomationCheckButton)

    local QuestSharingAutomationCheckButton = createFeatureCheckBox(container, "Automatically Share Zone Dailies", "QuestSharingAutomation")
    container:AddChild(QuestSharingAutomationCheckButton)
    
    if InCombatLockdown() then
        updateCheckBoxEnabledStatus(container, true)
    else
        updateCheckBoxEnabledStatus(container, false)
    end
    
    container:ResumeLayout()
    container:DoLayout()
end

local function drawSpeedLevelingTab(container)
    container:PauseLayout()

    local HearthstoneAutomationCheckButton = createFeatureCheckBox(container, "Hearthstone Automation", "HearthstoneAutomation")
    container:AddChild(HearthstoneAutomationCheckButton)
    
    local MailboxAutomationCheckButton = createFeatureCheckBox(container, "Auto-retrieve Radinax Gems", "MailboxAutomation")
    container:AddChild(MailboxAutomationCheckButton)
    
    if InCombatLockdown() then
        updateCheckBoxEnabledStatus(container, true)
    else
        updateCheckBoxEnabledStatus(container, false)
    end
    
    container:ResumeLayout()
    container:DoLayout()
end

local function documentationLayout(parent, children)
    local height = 0
    local width = parent.width or parent:GetWidth() or 0
    for i = 1, #children do
        local child = children[i]
        local frame = child.frame
        frame:ClearAllPoints()
        frame:Show()
        frame:SetWidth(width)
        if i == 1 then
            frame:SetPoint("TOPLEFT", parent)
        else
            frame:SetPoint("TOPLEFT", children[i-1].frame, "BOTTOMLEFT", 0, -10)
        end
        height = height + 10 + (frame.height or frame:GetHeight() or 0)
    end
    safecall(parent.obj.LayoutFinished, parent.obj, nil, height)
end

AceGUI:RegisterLayout("PoliQuestDocumentation_Layout", documentationLayout)

local function drawDocumentationTab(container)
    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("PoliQuestDocumentation_Layout")
    container:AddChild(scrollFrame)
    container:PauseLayout()
    scrollFrame:PauseLayout()

    local title = AceGUI:Create("Label")
    title:SetText("PoliQuest")
    title:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    title:SetFontObject(GameFontHighlightLarge)
    scrollFrame:AddChild(title)
    
    local text10 = AceGUI:Create("Label")
    text10:SetText([[This is my first addon. I'm still pretty new to making addons since I mostly only did WeakAuras stuff before.

If you have any questions or ideas for features, you can post them at the discord link below. I hope you like my first addon!

- Polihayse]])
    text10:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text10)
    
    local discordLink = AceGUI:Create("EditBox")
    discordLink:SetText("https://discord.gg/nc4ECEw")
    
    scrollFrame:AddChild(discordLink)
    
    local header7 = AceGUI:Create("Label")
    header7:SetText("More Info:")
    header7:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header7:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header7:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header7)
    
    local text10 = AceGUI:Create("Label")
    text10:SetText("You can find more information about this addon's individual features by visiting the curseforge page for this addon.")
    text10:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text10)
    
    local curseforgeLink = AceGUI:Create("EditBox")
    curseforgeLink:SetText("https://www.curseforge.com/wow/addons/poliquest-shadowlands")
    
    scrollFrame:AddChild(curseforgeLink)

    scrollFrame:ResumeLayout()
    container:ResumeLayout()
    
    scrollFrame:DoLayout()
    container:DoLayout()
end

local function selectGroup(container, group)
    if group == "tab1" then
        container:SetLayout("PoliQuestConfig_Layout")
        drawGeneralTab(container)
    elseif group == "tab2" then
        container:SetLayout("PoliQuestConfig_Layout")
        drawAutomationTab(container)
    elseif group == "tab3" then
        container:SetLayout("PoliQuestConfig_Layout")
        drawSpeedLevelingTab(container)
    elseif group == "tab4" then
        container:SetLayout("Fill")
        drawDocumentationTab(container)
    end
end

local configMenu, configTab
local function createMenu()
    configMenu = AceGUI:Create("Frame")
    configMenu:SetTitle("PoliQuest Configuration")
    configMenu.statustext:GetParent():Hide()
    configMenu:EnableResize(false)
    configMenu:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    configMenu:SetLayout("PoliQuestMenu_Layout")
    configMenu:SetWidth(600)
    configMenu:SetHeight(600)
    configMenu.frame:SetClampedToScreen(true)
    configMenu:PauseLayout()
    
    configTab = AceGUI:Create("TabGroup")
    configTab:SetTabs({{text="General", value="tab1"}, {text="Automation", value="tab2"}, {text="Speed Leveling", value="tab3"}, {text="Documentation", value="tab4"}})
    configTab:SetCallback("OnGroupSelected", function(self, event, group) self:ReleaseChildren() selectGroup(self, group) end)
    configMenu:AddChild(configTab)
    
    configMenu:ResumeLayout()
    
    local toggleButton = AceGUI:Create("Button")
    toggleButton:SetText("Toggle Button")
    toggleButton:SetCallback("OnClick", function()
        if InCombatLockdown() then
            print("Quest Item Button can only be locked/unlocked outside of combat.")
        elseif not addonTable.features.QuestItemButton.Button.LockButton:IsVisible() then
            addonTable.features.QuestItemButton.Button:unlock()
        else
            addonTable.features.QuestItemButton.Button:lock()
        end
    end)
    configMenu:AddChild(toggleButton)

    configTab:SelectTab("tab1")
    return configMenu
end

addonTable.util = addonTable.util or {}
addonTable.util.createMenu = createMenu

local menuLockdownFrame = CreateFrame("Frame")
menuLockdownFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
menuLockdownFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
menuLockdownFrame:SetScript("OnEvent", function(self, event)
    if configMenu and configMenu:IsVisible() and configTab.tabs and (configTab.tabs[1].selected or configTab.tabs[2].selected or configTab.tabs[2].selected) then
        if event == "PLAYER_REGEN_ENABLED" then
            updateCheckBoxEnabledStatus(configTab, false)
        else
            updateCheckBoxEnabledStatus(configTab, true)
        end
    end
end)
