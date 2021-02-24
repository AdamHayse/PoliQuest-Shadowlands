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

local function anchorFramesWithDFS(root, rootPoint, parent, currentDepth, currentCount)
    if not parent:GetUserData("children") then
        return currentCount
    else
        for i, child in ipairs(parent:GetUserData("children")) do
            local childFrame = child.frame
            childFrame:ClearAllPoints()
            childFrame:SetWidth(parent.frame:GetWidth() * (9-currentDepth)/(10-currentDepth))
            childFrame:SetPoint("TOPRIGHT", root, rootPoint, 0, -currentCount*40)
            currentCount = currentCount + 1
            currentCount = anchorFramesWithDFS(root, rootPoint, child, currentDepth + 1, currentCount)
        end
        return currentCount
    end
end

local function configLayout(parent, children)
    local leftColumnCount = 0
    local rightColumnCount = 0
    for i, child in ipairs(children) do
        local childFrame = child.frame
        if not child:GetUserData("child") then
            childFrame:ClearAllPoints()
            childFrame:SetWidth(.5 * 544)
            if leftColumnCount <= rightColumnCount then
                childFrame:SetPoint("TOPRIGHT", parent, "TOP", 0, -leftColumnCount*40)
                leftColumnCount = leftColumnCount + 1
                leftColumnCount = anchorFramesWithDFS(parent, "TOP", child, 1, leftColumnCount)
            else
                childFrame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -rightColumnCount*40)
                rightColumnCount = rightColumnCount + 1
                rightColumnCount = anchorFramesWithDFS(parent, "TOPRIGHT", child, 1, rightColumnCount)
            end
        end
    end
    safecall(parent.obj.LayoutFinished, parent.obj, nil, leftColumnCount >= rightColumnCount and leftColumnCount * 40 + children[1].frame:GetHeight() or rightColumnCount * 40 + children[1].frame:GetHeight())
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

local function updateCheckBoxEnabledStatus(container, childrenDisabled)
    local children = container.children or container:GetUserData("children") or {}
    for _, child in ipairs(children) do
        child:SetDisabled(childrenDisabled)
        if not child:GetValue() or childrenDisabled then
                updateCheckBoxEnabledStatus(child, true)
        end
    end
end

local function drawGeneralTab(container)
    container:PauseLayout()
    local QuestItemButtonCheckButton = AceGUI:Create("CheckBox")
    QuestItemButtonCheckButton:SetLabel("Quest Item Button")
    QuestItemButtonCheckButton:SetValue(PoliSavedVars.QuestItemButton.enabled)
    QuestItemButtonCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestItemButton", key) end)
    container:AddChild(QuestItemButtonCheckButton)
    
    local SkipCutscenesCheckButton = AceGUI:Create("CheckBox")
    SkipCutscenesCheckButton:SetLabel("Skip Cutscenes")
    SkipCutscenesCheckButton:SetValue(PoliSavedVars.SkipCutscenes.enabled)
    SkipCutscenesCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("SkipCutscenes", key) end)
    container:AddChild(SkipCutscenesCheckButton)

    local QuestProgressTrackerCheckButton = AceGUI:Create("CheckBox")
    QuestProgressTrackerCheckButton:SetLabel("Quest Progress Tracking")
    QuestProgressTrackerCheckButton:SetValue(PoliSavedVars.QuestProgressTracker.enabled)
    QuestProgressTrackerCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestProgressTracker", key) end)
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
    local StrictAutomationCheckButton = AceGUI:Create("CheckBox")
    StrictAutomationCheckButton:SetLabel("Strict Automation")
    StrictAutomationCheckButton:SetValue(PoliSavedVars.QuestInteractionAutomation.switches.StrictAutomation)
    StrictAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureSwitch("QuestInteractionAutomation", "StrictAutomation", key) end)
    StrictAutomationCheckButton:SetUserData("child", true)
    container:AddChild(StrictAutomationCheckButton)

    local QuestRewardSelectionAutomationCheckButton = AceGUI:Create("CheckBox")
    QuestRewardSelectionAutomationCheckButton:SetLabel("Quest Reward Selection Automation")
    QuestRewardSelectionAutomationCheckButton:SetValue(PoliSavedVars.QuestInteractionAutomation.switches.QuestRewardSelectionAutomation)
    QuestRewardSelectionAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureSwitch("QuestInteractionAutomation", "QuestRewardSelectionAutomation", key) end)
    QuestRewardSelectionAutomationCheckButton:SetUserData("children", { StrictAutomationCheckButton })
    QuestRewardSelectionAutomationCheckButton:SetUserData("child", true)
    container:AddChild(QuestRewardSelectionAutomationCheckButton)

    local QuestInteractionAutomationCheckButton = AceGUI:Create("CheckBox")
    QuestInteractionAutomationCheckButton:SetLabel("Quest Interaction Automation")
    QuestInteractionAutomationCheckButton:SetValue(PoliSavedVars.QuestInteractionAutomation.enabled)
    QuestInteractionAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestInteractionAutomation", key) end)
    QuestInteractionAutomationCheckButton:SetUserData("children", { QuestRewardSelectionAutomationCheckButton })
    container:AddChild(QuestInteractionAutomationCheckButton)

    local DialogInteractionAutomationCheckButton = AceGUI:Create("CheckBox")
    DialogInteractionAutomationCheckButton:SetLabel("Dialog Interaction Automation")
    DialogInteractionAutomationCheckButton:SetValue(PoliSavedVars.DialogInteractionAutomation.enabled)
    DialogInteractionAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("DialogInteractionAutomation", key) end)
    container:AddChild(DialogInteractionAutomationCheckButton)

    local QuestRewardEquipAutomationCheckButton = AceGUI:Create("CheckBox")
    QuestRewardEquipAutomationCheckButton:SetLabel("Quest Reward Equip Automation")
    QuestRewardEquipAutomationCheckButton:SetValue(PoliSavedVars.QuestRewardEquipAutomation.enabled)
    QuestRewardEquipAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestRewardEquipAutomation", key) end)
    container:AddChild(QuestRewardEquipAutomationCheckButton)

    local QuestEmoteAutomationCheckButton = AceGUI:Create("CheckBox")
    QuestEmoteAutomationCheckButton:SetLabel("Quest Emote Automation")
    QuestEmoteAutomationCheckButton:SetValue(PoliSavedVars.QuestEmoteAutomation.enabled)
    QuestEmoteAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestEmoteAutomation", key) end)
    container:AddChild(QuestEmoteAutomationCheckButton)

    local AutoTrackQuestsCheckButton = AceGUI:Create("CheckBox")
    AutoTrackQuestsCheckButton:SetLabel("Automatically Track Quests")
    AutoTrackQuestsCheckButton:SetValue(PoliSavedVars.AutoTrackQuests.enabled)
    AutoTrackQuestsCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("AutoTrackQuests", key) end)
    container:AddChild(AutoTrackQuestsCheckButton)

    local QuestSharingAutomationCheckButton = AceGUI:Create("CheckBox")
    QuestSharingAutomationCheckButton:SetLabel("Automatically Share Zone Dailies")
    QuestSharingAutomationCheckButton:SetValue(PoliSavedVars.QuestSharingAutomation.enabled)
    QuestSharingAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("QuestSharingAutomation", key) end)
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
    local HearthstoneAutomationCheckButton = AceGUI:Create("CheckBox")
    HearthstoneAutomationCheckButton:SetLabel("Hearthstone Automation")
    HearthstoneAutomationCheckButton:SetValue(PoliSavedVars.HearthstoneAutomation.enabled)
    HearthstoneAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("HearthstoneAutomation", key) end)
    container:AddChild(HearthstoneAutomationCheckButton)
    
    local MailboxAutomationCheckButton = AceGUI:Create("CheckBox")
    MailboxAutomationCheckButton:SetLabel("Auto-retrieve Radinax Gems")
    MailboxAutomationCheckButton:SetValue(PoliSavedVars.MailboxAutomation.enabled)
    MailboxAutomationCheckButton:SetCallback("OnValueChanged", function(widget, event, key) updateCheckBoxEnabledStatus(container, false) addonTable.updateFeatureConfiguration("MailboxAutomation", key) end)
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
    
    local header1 = AceGUI:Create("Label")
    header1:SetText("Purpose:")
    header1:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header1:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header1:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header1)
    
    local text1 = AceGUI:Create("Label")
    text1:SetText("PoliQuest is a Shadowlands questing addon that makes leveling less cumbersome by providing tools that reduce mouse button clicks and automating quest interactions.")
    text1:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text1)
    
    local header2 = AceGUI:Create("Label")
    header2:SetText("Features:")
    header2:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header2:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header2:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header2)
    
    local text2 = AceGUI:Create("Label")
    text2:SetText([[The following tasks are automated for level 50-59 Shadowlands questing:
    
    - PQButton that automatically binds Shadowlands quest items to it
    - Quest emote automation
    - Automatically accept and complete quests (level 50-59 quests only)
    - Automatically select correct quest dialog (level 50-59 quests only)
    - Automatically track quests when accepted (all quests)
    - Track quest progress percent in quest info display (all quests)
    - Quest reward automation (level 50-59 quests only)
    - Automatically equip quest loot upgrades (all quests. non-BOE items only)
    - Automatically set hearthstone (less than level 60 only)]])
    text2:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text2)
    
    local header3 = AceGUI:Create("Label")
    header3:SetText("Keybinding the quest item button:")
    header3:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header3:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header3:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header3)
    
    local text3 = AceGUI:Create("Label")
    text3:SetText("Put the following in a macro to keybind the button:")
    text3:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text3)
    
    local text4 = AceGUI:Create("Label")
    text4:SetText("/click PQButton")
    text4:SetColor(0.66666667, 0.66666667, 0.66666667)
    text4:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text4)
    
    local text5 = AceGUI:Create("Label")
    text5:SetText("PQNext and PQPrev can also be keybound to cycle through multiple quest items in your inventory while out of combat.  I use the following")
    text5:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text5)
    
    local text6 = AceGUI:Create("Label")
    text6:SetText("/click [nomod]PQButton;[mod:alt]PQNext")
    text6:SetColor(0.66666667, 0.66666667, 0.66666667)
    text6:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text6)
    
    local text7 = AceGUI:Create("Label")
    text7:SetText("I don't keybind PQPrev since cycling through multiple quest items can be achieved by clicking one of these buttons alone.  However, the option to keybind both is there if you want it.")
    text7:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text7)
    
    local header4 = AceGUI:Create("Label")
    header4:SetText("More info about the PQButton:")
    header4:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header4:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header4:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header4)
    
    local text8 = AceGUI:Create("Label")
    text8:SetText([[The PQButton can only be updated out of combat. For example, if you obtain a quest with a quest item in combat, the addon will wait for combat to end before updating the PQButton.  Also, if you have multiple quest items, you will not be able to swap them on the PQButton unless you are out of combat.

The PQButton can also be clicked with the mouse cursor if desired. You can also mouse over it to get the quest item info. The PQButton should only show when it is unlocked for moving, or you have one or multiple quest items.]])
    text8:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text8)
    
    local header5 = AceGUI:Create("Label")
    header5:SetText("Quest Loot Automation Algorithm:")
    header5:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header5:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header5:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header5)
    
    local text9 = AceGUI:Create("Label")
    text9:SetText([[1. If there is only 1 quest item reward, then select that one.
    Stop automation if:
        The "Automatically select quest rewards" switch is disabled.
        Any of the quest rewards is not equippable.

2. Get the player's current loot spec, or current spec if they don't have one.
    Stop automation if:
        Item is missing from the equip slot for one of the quest loot items.
        None of the items are for your preferred spec.

3. Find the largest potential ilvl upgrade for this spec based on your equipped gear (factoring in sockets and considering that warforge is possible).

4. If there is only one largest spec upgrade, then select that one.
    Stop automation if:
        The "Strict Quest Reward Automation" switch is enabled.
        One of the largest upgrades is a trinket.

5. Find the item that yields the largest increase in stats and choose that one. (For example, legs have more stats than gloves at equal ilvl, so legs get chosen.)]])
    text9:SetWidth(scrollFrame.frame:GetWidth() - 20)
    scrollFrame:AddChild(text9)
    
    local header6 = AceGUI:Create("Label")
    header6:SetText("Author's Note:")
    header6:SetWidth(scrollFrame.frame:GetWidth() - 20)
    header6:SetColor(0.36078431372549, 0.549019607843, 0.756862745098)
    header6:SetFontObject(GameFontHighlight)
    scrollFrame:AddChild(header6)
    
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
function addonTable.createMenu()
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
        elseif not addonTable.QuestItemButton.Button.LockButton:IsVisible() then
            addonTable.QuestItemButton.Button:unlock()
        else
            addonTable.QuestItemButton.Button:lock()
        end
    end)
    configMenu:AddChild(toggleButton)

    configTab:SelectTab("tab1")
    return configMenu
end


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
