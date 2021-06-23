local addonName, addonTable = ...

local print, ipairs, ssplit, supper, slower, pairs, select, unpack, tinsert, tremove = print, ipairs, string.split, string.upper, string.lower, pairs, select, unpack, table.insert, table.remove
local InCombatLockdown, CreateFrame, UIParent = InCombatLockdown, CreateFrame, UIParent

local function ternaryExpression(condition, a, b)
    if condition then
        return a
    else
        return b
    end
end

local function PoliQuest_OnAddonLoaded(addonName)
    if addonName == "PoliQuest" then
        addonTable.properties = addonTable.properties or {}
        local pawnLoaded = IsAddOnLoaded("Pawn")
        addonTable.properties.PawnLoaded = pawnLoaded

        PoliSavedVars = PoliSavedVars or {}
        local savedVars = {}

        if PoliSavedVars.QuestItemButton == nil then
            addonTable.features.QuestItemButton.Button:unlock()
        else
            addonTable.features.QuestItemButton.Button:lock()
        end
        PoliSavedVars.QuestItemButton = PoliSavedVars.QuestItemButton or {}
        savedVars.QuestItemButton = {}
        savedVars.QuestItemButton.enabled = ternaryExpression(type(PoliSavedVars.QuestItemButton.enabled) == "boolean", PoliSavedVars.QuestItemButton.enabled, true)
        savedVars.QuestItemButton.xOffset = ternaryExpression(type(PoliSavedVars.QuestItemButton.xOffset) == "number", PoliSavedVars.QuestItemButton.xOffset, 0)
        savedVars.QuestItemButton.yOffset = ternaryExpression(type(PoliSavedVars.QuestItemButton.yOffset) == "number", PoliSavedVars.QuestItemButton.yOffset, 0)
        savedVars.QuestItemButton.relPoint = ternaryExpression(type(PoliSavedVars.QuestItemButton.relPoint) == "string", PoliSavedVars.QuestItemButton.relPoint, "CENTER")

        PoliSavedVars.QuestInteractionAutomation = PoliSavedVars.QuestInteractionAutomation or {}
        savedVars.QuestInteractionAutomation = {}
        savedVars.QuestInteractionAutomation.enabled = ternaryExpression(type(PoliSavedVars.QuestInteractionAutomation.enabled) == "boolean", PoliSavedVars.QuestInteractionAutomation.enabled, true)
        PoliSavedVars.QuestInteractionAutomation.switches = PoliSavedVars.QuestInteractionAutomation.switches or {}
        savedVars.QuestInteractionAutomation.switches = {}
        savedVars.QuestInteractionAutomation.switches.Modifier = ternaryExpression(type(PoliSavedVars.QuestInteractionAutomation.switches.Modifier) == "number", PoliSavedVars.QuestInteractionAutomation.switches.Modifier, 1)
        savedVars.QuestInteractionAutomation.switches.ExcludeTrivial = ternaryExpression(type(PoliSavedVars.QuestInteractionAutomation.switches.ExcludeTrivial) == "boolean", PoliSavedVars.QuestInteractionAutomation.switches.ExcludeTrivial, true)

        PoliSavedVars.QuestRewardSelectionAutomation = PoliSavedVars.QuestRewardSelectionAutomation or {}
        savedVars.QuestRewardSelectionAutomation = {}
        savedVars.QuestRewardSelectionAutomation.enabled = ternaryExpression(type(PoliSavedVars.QuestRewardSelectionAutomation.enabled) == "boolean", PoliSavedVars.QuestRewardSelectionAutomation.enabled, true)
        PoliSavedVars.QuestRewardSelectionAutomation.switches = PoliSavedVars.QuestRewardSelectionAutomation.switches or {}
        savedVars.QuestRewardSelectionAutomation.switches = {}
        savedVars.QuestRewardSelectionAutomation.switches.IlvlThreshold = ternaryExpression(type(PoliSavedVars.QuestRewardSelectionAutomation.switches.IlvlThreshold) == "string", PoliSavedVars.QuestRewardSelectionAutomation.switches.IlvlThreshold, "171")
        savedVars.QuestRewardSelectionAutomation.switches.SelectionLogic = ternaryExpression(type(PoliSavedVars.QuestRewardSelectionAutomation.switches.SelectionLogic) == "number" and pawnLoaded, PoliSavedVars.QuestRewardSelectionAutomation.switches.SelectionLogic, 1)
        savedVars.QuestRewardSelectionAutomation.switches.Modifier = ternaryExpression(type(PoliSavedVars.QuestRewardSelectionAutomation.switches.Modifier) == "number", PoliSavedVars.QuestRewardSelectionAutomation.switches.Modifier, 1)

        PoliSavedVars.DialogInteractionAutomation = PoliSavedVars.DialogInteractionAutomation or {}
        savedVars.DialogInteractionAutomation = {}
        savedVars.DialogInteractionAutomation.enabled = ternaryExpression(type(PoliSavedVars.DialogInteractionAutomation.enabled) == "boolean", PoliSavedVars.DialogInteractionAutomation.enabled, true)

        PoliSavedVars.HearthstoneAutomation = PoliSavedVars.HearthstoneAutomation or {}
        savedVars.HearthstoneAutomation = {}
        savedVars.HearthstoneAutomation.enabled = ternaryExpression(type(PoliSavedVars.HearthstoneAutomation.enabled) == "boolean", PoliSavedVars.HearthstoneAutomation.enabled, false)

        PoliSavedVars.QuestRewardEquipAutomation = PoliSavedVars.QuestRewardEquipAutomation or {}
        savedVars.QuestRewardEquipAutomation = {}
        savedVars.QuestRewardEquipAutomation.enabled = ternaryExpression(type(PoliSavedVars.QuestRewardEquipAutomation.enabled) == "boolean", PoliSavedVars.QuestRewardEquipAutomation.enabled, true)
        PoliSavedVars.QuestRewardEquipAutomation.switches = PoliSavedVars.QuestRewardEquipAutomation.switches or {}
        savedVars.QuestRewardEquipAutomation.switches = {}
        
        savedVars.QuestRewardEquipAutomation.switches.EquipLogic = ternaryExpression(type(PoliSavedVars.QuestRewardEquipAutomation.switches.EquipLogic) == "number" and pawnLoaded, PoliSavedVars.QuestRewardEquipAutomation.switches.EquipLogic, 1)
        savedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverHeirlooms = ternaryExpression(type(PoliSavedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverHeirlooms) == "boolean", PoliSavedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverHeirlooms, true)
        savedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverSpeedItems = ternaryExpression(type(PoliSavedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverSpeedItems) == "boolean", PoliSavedVars.QuestRewardEquipAutomation.switches.DoNotEquipOverSpeedItems, false)
        savedVars.QuestRewardEquipAutomation.switches.UseItemLevelLogicForTrinkets = ternaryExpression(type(PoliSavedVars.QuestRewardEquipAutomation.switches.UseItemLevelLogicForTrinkets) == "boolean", PoliSavedVars.QuestRewardEquipAutomation.switches.UseItemLevelLogicForTrinkets, true)

        PoliSavedVars.QuestEmoteAutomation = PoliSavedVars.QuestEmoteAutomation or {}
        savedVars.QuestEmoteAutomation = {}
        savedVars.QuestEmoteAutomation.enabled = ternaryExpression(type(PoliSavedVars.QuestEmoteAutomation.enabled) == "boolean", PoliSavedVars.QuestEmoteAutomation.enabled, true)

        PoliSavedVars.SkipCutscenes = PoliSavedVars.SkipCutscenes or {}
        savedVars.SkipCutscenes = {}
        savedVars.SkipCutscenes.enabled = ternaryExpression(type(PoliSavedVars.SkipCutscenes.enabled) == "boolean", PoliSavedVars.SkipCutscenes.enabled, true)

        PoliSavedVars.MailboxAutomation = PoliSavedVars.MailboxAutomation or {}
        savedVars.MailboxAutomation = {}
        savedVars.MailboxAutomation.enabled = ternaryExpression(type(PoliSavedVars.MailboxAutomation.enabled) == "boolean", PoliSavedVars.MailboxAutomation.enabled, false)

        PoliSavedVars.QuestProgressTracker = PoliSavedVars.QuestProgressTracker or {}
        savedVars.QuestProgressTracker = {}
        savedVars.QuestProgressTracker.enabled = ternaryExpression(type(PoliSavedVars.QuestProgressTracker.enabled) == "boolean", PoliSavedVars.QuestProgressTracker.enabled, true)

        PoliSavedVars.AutoTrackQuests = PoliSavedVars.AutoTrackQuests or {}
        savedVars.AutoTrackQuests = {}
        savedVars.AutoTrackQuests.enabled = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.enabled) == "boolean", PoliSavedVars.AutoTrackQuests.enabled, true)
        PoliSavedVars.AutoTrackQuests.switches = PoliSavedVars.AutoTrackQuests.switches or {}
        savedVars.AutoTrackQuests.switches = {}
        savedVars.AutoTrackQuests.switches.TrackCampaign = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackCampaign) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackCampaign, true)
        savedVars.AutoTrackQuests.switches.TrackDaily = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackDaily) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackDaily, true)
        savedVars.AutoTrackQuests.switches.TrackWeekly = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackWeekly) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackWeekly, true)
        savedVars.AutoTrackQuests.switches.TrackLegendary = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackLegendary) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackLegendary, true)
        savedVars.AutoTrackQuests.switches.TrackLowLevel = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackLowLevel) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackLowLevel, false)
        savedVars.AutoTrackQuests.switches.TrackAllOthers = ternaryExpression(type(PoliSavedVars.AutoTrackQuests.switches.TrackAllOthers) == "boolean", PoliSavedVars.AutoTrackQuests.switches.TrackAllOthers, true)
        
        PoliSavedVars.QuestSharingAutomation = PoliSavedVars.QuestSharingAutomation or {}
        savedVars.QuestSharingAutomation = {}
        savedVars.QuestSharingAutomation.enabled = ternaryExpression(type(PoliSavedVars.QuestSharingAutomation.enabled) == "boolean", PoliSavedVars.QuestSharingAutomation.enabled, true)
        
        PoliSavedVars = savedVars

        for featureName, featureTable in pairs(addonTable.features) do
            addonTable.util.updateFeatureConfiguration(featureName, featureTable, PoliSavedVars[featureName].enabled)
            local switches = PoliSavedVars[featureName].switches
            if switches then
                for switchName, switchValue in pairs(switches) do
                    addonTable.util.updateFeatureSwitch(featureName, featureTable, switchName, switchValue)
                end
            end
        end
        addonTable.features.QuestItemButton.Button:ClearAllPoints()
        addonTable.features.QuestItemButton.Button:SetPoint(PoliSavedVars.QuestItemButton.relPoint, UIParent, PoliSavedVars.QuestItemButton.relPoint, PoliSavedVars.QuestItemButton.xOffset, PoliSavedVars.QuestItemButton.yOffset)
    end
end

local function PoliQuest_OnPlayerLogout()
    PoliSavedVars.QuestItemButton.relPoint, PoliSavedVars.QuestItemButton.xOffset, PoliSavedVars.QuestItemButton.yOffset = select(3, addonTable.features.QuestItemButton.Button:GetPoint(1))
end


-- All events handled by feature handlers, and the orders in which they should execute with respect to each other
local features = addonTable.features
local constantEventHandlers = {
    PLAYER_REGEN_ENABLED = {
        features.QuestItemButton.eventHandlers.onPlayerRegenEnabled
    },
    PLAYER_REGEN_DISABLED = {
        features.QuestItemButton.eventHandlers.onPlayerRegenDisabled
    },
    BAG_UPDATE = {
        features.QuestItemButton.eventHandlers.onBagUpdate
    },
    BAG_UPDATE_COOLDOWN = {
        features.QuestItemButton.eventHandlers.onBagUpdateCooldown
    },
    UNIT_SPELLCAST_SUCCEEDED = {
        features.QuestItemButton.eventHandlers.onUnitSpellcastSucceeded_Player
    },
    GOSSIP_SHOW = {
        features.QuestInteractionAutomation.eventHandlers.onGossipShow,
        features.DialogInteractionAutomation.eventHandlers.onGossipShow,
        features.HearthstoneAutomation.eventHandlers.onGossipShow
    },
    QUEST_GREETING = {
        features.QuestInteractionAutomation.eventHandlers.onQuestGreeting
    },
    QUEST_DETAIL = {
        features.QuestInteractionAutomation.eventHandlers.onQuestDetail
    },
    QUEST_PROGRESS = {
        features.QuestInteractionAutomation.eventHandlers.onQuestProgress
    },
    QUEST_COMPLETE = {
        features.QuestInteractionAutomation.eventHandlers.onQuestComplete,
        features.QuestRewardSelectionAutomation.eventHandlers.onQuestComplete
    },
    QUEST_LOG_UPDATE = {
        features.QuestInteractionAutomation.eventHandlers.onQuestLogUpdate,
        features.QuestProgressTracker.eventHandlers.onQuestLogUpdate
    },
    QUEST_ACCEPTED = {
        features.AutoTrackQuests.eventHandlers.onQuestAccepted,
        features.DialogInteractionAutomation.eventHandlers.onQuestAccepted,
        features.QuestInteractionAutomation.eventHandlers.onQuestAccepted,
        features.QuestSharingAutomation.eventHandlers.onQuestAccepted
    },
    QUEST_REMOVED = {
        features.QuestProgressTracker.eventHandlers.onQuestRemoved
    },
    CONFIRM_BINDER = {
        features.HearthstoneAutomation.eventHandlers.onConfirmBinder
    },
    GOSSIP_CLOSED = {
        features.HearthstoneAutomation.eventHandlers.onGossipClosed
    },
    QUEST_LOOT_RECEIVED = {
        features.QuestRewardEquipAutomation.eventHandlers.onQuestLootReceived
    },
    PLAYER_EQUIPMENT_CHANGED = {
        features.QuestRewardEquipAutomation.eventHandlers.onPlayerEquipmentChanged
    },
    PLAYER_TARGET_CHANGED = {
        features.QuestEmoteAutomation.eventHandlers.onPlayerTargetChanged
    },
    CHAT_MSG_MONSTER_SAY = {
        features.QuestEmoteAutomation.eventHandlers.onChatMsgMonsterSay
    },
    PLAY_MOVIE = {
        features.SkipCutscenes.eventHandlers.onPlayMovie
    },
    MAIL_INBOX_UPDATE = {
        features.MailboxAutomation.eventHandlers.onMailInboxUpdate
    },
    MAIL_SHOW = {
        features.MailboxAutomation.eventHandlers.onMailShow
    },
    GROUP_JOINED = {
        features.QuestSharingAutomation.eventHandlers.onGroupJoined
    },
    GROUP_LEFT = {
        features.QuestSharingAutomation.eventHandlers.onGroupLeft
    },
    GROUP_ROSTER_UPDATE = {
        features.QuestSharingAutomation.eventHandlers.onGroupRosterUpdate
    },
    CHAT_MSG_SYSTEM = {
        features.QuestSharingAutomation.eventHandlers.onChatMsgSystem
    }
}

-- will be populated with events and corresponding handlers when addon is loaded
local eventHandlers = {
    ADDON_LOADED = { PoliQuest_OnAddonLoaded },
    PLAYER_LOGOUT = { PoliQuest_OnPlayerLogout }
}
local updateHandlers = {}

local poliQuestEventHandler = CreateFrame("Frame", "PoliQuestEventHandler")

local function addEventHandlers(featureEventHandlers)
    for name, handler in pairs(featureEventHandlers) do
        local event, unit = ssplit(" ", ((name:gsub("%u","_%1"):sub(4):upper():gsub("__", " "))))
        local eventHandlerSet = eventHandlers[event]
        if not eventHandlerSet then
            eventHandlers[event] = { handler }
            if not unit then
                poliQuestEventHandler:RegisterEvent(event)
            else
                poliQuestEventHandler:RegisterUnitEvent(event, slower(unit))
            end
        else
            local j = 1
            while eventHandlerSet[j] do
                -- if handler should be before the current one, then insert at this index
                if constantEventHandlers[event][j] == handler and eventHandlerSet[j] ~= handler then
                    tinsert(eventHandlerSet, j, handler)
                    break
                -- do nothing if handler is already inserted
                elseif eventHandlerSet[j] == handler then
                    break
                end
                j = j + 1
            end
            if j == #eventHandlerSet + 1 then
                tinsert(eventHandlerSet, handler)
            end
        end
    end
end

local function removeEventHandlers(featureEventHandlers)
    for name, handler in pairs(featureEventHandlers) do
        local event = ssplit(" ", ((name:gsub("%u","_%1"):sub(4):upper():gsub("__", " "))))
        local eventHandlerSet = eventHandlers[event]
        if eventHandlerSet then
            for j, handlerFunction in ipairs(eventHandlerSet) do
                if handlerFunction == handler then
                    tremove(eventHandlerSet, j)
                end
            end
            if #eventHandlerSet == 0 then
                eventHandlers[event] = nil
                poliQuestEventHandler:UnregisterEvent(event)
            end
        end
    end
end

local function addUpdateHandler(newUpdateHandler)
    local handlerFound = false
    for _, updateHandler in ipairs(updateHandlers) do
        if updateHandler == newUpdateHandler then
            handlerFound = true
            break
        end
    end
    if not handlerFound then
        tinsert(updateHandlers, newUpdateHandler)
    end
end

local function removeUpdateHandler(updateHandlerToRemove)
    for i, updateHandler in ipairs(updateHandlers) do
        if updateHandler == updateHandlerToRemove then
            tremove(updateHandlers, i)
        end
    end
end

local function updateFeatureConfiguration(featureName, featureTable, isEnabled)
    local updateHandler = featureTable.updateHandler
    if isEnabled then
        addEventHandlers(featureTable.eventHandlers)
        featureTable.initialize()
        if updateHandler then
            addUpdateHandler(updateHandler)
        end
    else
        featureTable.terminate()
        if updateHandler then
            removeUpdateHandler(updateHandler)
        end
        removeEventHandlers(featureTable.eventHandlers)
    end
    PoliSavedVars[featureName].enabled = isEnabled
end

local function updateFeatureSwitch(featureName, featureTable, switchName, switchValue)
    featureTable.setSwitch(switchName, switchValue)
    PoliSavedVars[featureName].switches[switchName] = switchValue
end

local function PoliQuest_OnEvent(self, event, ...)
    local eventHandlerSet = eventHandlers[event]
    for _, eventHandler in ipairs(eventHandlerSet) do
        eventHandler(...)
    end
end

local function PoliQuest_OnUpdate()
    for _, updateHandler in ipairs(updateHandlers) do
        updateHandler()
    end
end

poliQuestEventHandler:SetScript("OnEvent", PoliQuest_OnEvent)
poliQuestEventHandler:SetScript("OnUpdate", PoliQuest_OnUpdate)
poliQuestEventHandler:RegisterEvent("ADDON_LOADED")
poliQuestEventHandler:RegisterEvent("PLAYER_LOGOUT")

SLASH_PoliQuest1 = "/poliquest"
SLASH_PoliQuest2 = "/pq"

addonTable.util = addonTable.util or {}
addonTable.util.updateFeatureConfiguration = updateFeatureConfiguration
addonTable.util.updateFeatureSwitch = updateFeatureSwitch

addonTable.util.tooltip = CreateFrame("GameTooltip", "PoliScanningTooltip", nil, "GameTooltipTemplate")
addonTable.util.tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local configMenu
SlashCmdList["PoliQuest"] = function(msg)
    local cmd, arg = ssplit(" ", msg)
    if cmd == "" then
        if configMenu and configMenu:IsVisible() then
            configMenu.frame:SetClampedToScreen(false)
            configMenu:Hide()
        else
            configMenu = addonTable.util.createMenu()
        end
    elseif cmd == "toggle" then
        if InCombatLockdown() then
            print("Quest Item Button can only be locked/unlocked outside of combat.")
        elseif not addonTable.QuestItemButton.Button.LockButton:IsVisible() then
            addonTable.QuestItemButton.Button:unlock()
        else
            addonTable.QuestItemButton.Button:lock()
        end
    else
        print("|cFF5c8cc1/pq:|r feature control")
        print("|cFF5c8cc1/pq toggle:|r edit button position")
    end
end
