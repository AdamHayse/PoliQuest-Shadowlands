local addonName, addonTable = ...

local InCombatLockdown, ipairs, string, CreateFrame = InCombatLockdown, ipairs, string, CreateFrame
local print, select = print, select

_G["PoliQuest"] = addonTable

addonTable.debugPrint = function(text)
    if POLIQUEST_DEBUG_ENABLED then
        print("|cFF5c8cc1PoliQuest:|r " .. text)
    end
end

local featureNames = {
    "QuestItemButton",
    "QuestAndDialogAutomation",
    "HearthstoneAutomation",
    "QuestRewardEquipAutomation",
    "QuestEmoteAutomation",
    "SkipCutscenes",
    "MailboxAutomation",
    "QuestProgressTracker"
}

local PoliQuest_OnAddonLoaded = function(addonName)
    if addonName == "PoliQuest" then
        PoliSavedVars = PoliSavedVars or {}
        if PoliSavedVars.QuestItemButton == nil then
            PoliSavedVars.QuestItemButton = {
                enabled = true,
                xOffset = 0,
                yOffset = 0,
                relPoint = "CENTER",
            }
            addonTable.QuestItemButton.Button:unlock()
        end
        PoliSavedVars.QuestAndDialogAutomation = PoliSavedVars.QuestAndDialogAutomation or {
            enabled = true,
            switches = {
                QuestRewardSelectionAutomation = true,
                StrictAutomation = false,
            }
        }
        PoliSavedVars.HearthstoneAutomation = PoliSavedVars.HearthstoneAutomation or {
            enabled = false
        }
        PoliSavedVars.QuestRewardEquipAutomation = PoliSavedVars.QuestRewardEquipAutomation or {
            enabled = true
        }
        PoliSavedVars.QuestEmoteAutomation = PoliSavedVars.QuestEmoteAutomation or {
            enabled = true
        }
        PoliSavedVars.SkipCutscenes = PoliSavedVars.SkipCutscenes or {
            enabled = true
        }
        PoliSavedVars.MailboxAutomation = PoliSavedVars.MailboxAutomation or {
            enabled = true
        }
        PoliSavedVars.QuestProgressTracker = PoliSavedVars.QuestProgressTracker or {
            enabled = true
        }
        for _, featureName in ipairs(featureNames) do
            addonTable.updateFeatureConfiguration(featureName, PoliSavedVars[featureName].enabled)
            local switches = PoliSavedVars[featureName].switches
            if switches then
                for switch, isEnabled in pairs(switches) do
                    addonTable.updateFeatureSwitch(featureName, switch, isEnabled)
                end
            end
        end
        addonTable.QuestItemButton.Button:ClearAllPoints()
        addonTable.QuestItemButton.Button:SetPoint(PoliSavedVars.QuestItemButton.relPoint, UIParent, PoliSavedVars.QuestItemButton.xOffset, PoliSavedVars.QuestItemButton.yOffset)
    end
end

local PoliQuest_OnPlayerLogout = function()
    PoliSavedVars.QuestItemButton.relPoint, PoliSavedVars.QuestItemButton.xOffset, PoliSavedVars.QuestItemButton.yOffset = select(3, addonTable.QuestItemButton.Button:GetPoint(1))
end


-- All events handled by feature handlers, and the orders in which they should execute with respect to each other
local constantEventHandlers = {
    ["PLAYER_REGEN_ENABLED"] = {
        addonTable.QuestItemButton_OnPlayerRegenEnabled
    },
    ["PLAYER_REGEN_DISABLED"] = {
        addonTable.QuestItemButton_OnPlayerRegenDisabled
    },
    ["BAG_UPDATE"] = {
        addonTable.QuestItemButton_OnBagUpdate
    },
    ["BAG_UPDATE_COOLDOWN"] = {
        addonTable.QuestItemButton_OnBagUpdateCooldown
    },
    ["UNIT_SPELLCAST_SUCCEEDED"] = {
        addonTable.QuestItemButton_OnUnitSpellcastSucceeded
    },
    ["GOSSIP_SHOW"] = {
        addonTable.QuestAndDialogAutomation_OnGossipShow,
        addonTable.HearthstoneAutomation_OnGossipShow
    },
    ["QUEST_GREETING"] = {
        addonTable.QuestAndDialogAutomation_OnQuestGreeting
    },
    ["QUEST_DETAIL"] = {
        addonTable.QuestAndDialogAutomation_OnQuestDetail
    },
    ["QUEST_PROGRESS"] = {
        addonTable.QuestAndDialogAutomation_OnQuestProgress
    },
    ["QUEST_COMPLETE"] = {
        addonTable.QuestAndDialogAutomation_OnQuestComplete
    },
    ["QUEST_LOG_UPDATE"] = {
        addonTable.QuestAndDialogAutomation_OnQuestLogUpdate,
        addonTable.QuestProgressTracker_OnQuestLogUpdate
    },
    ["QUEST_ACCEPTED"] = {
        addonTable.QuestAndDialogAutomation_OnQuestAccepted
    },
    ["QUEST_REMOVED"] = {
        addonTable.QuestProgressTracker_OnQuestRemoved
    },
    ["CONFIRM_BINDER"] = {
        addonTable.HearthstoneAutomation_OnConfirmBinder
    },
    ["GOSSIP_CLOSED"] = {
        addonTable.HearthstoneAutomation_OnGossipClosed
    },
    ["QUEST_LOOT_RECEIVED"] = {
        addonTable.QuestRewardEquipAutomation_OnQuestLootReceived
    },
    ["PLAYER_EQUIPMENT_CHANGED"] = {
        addonTable.QuestRewardEquipAutomation_OnPlayerEquipmentChanged
    },
    ["PLAYER_TARGET_CHANGED"] = {
        addonTable.QuestEmoteAutomation_OnPlayerTargetChanged
    },
    ["CHAT_MSG_MONSTER_SAY"] = {
        addonTable.QuestEmoteAutomation_OnChatMsgMonsterSay
    },
    ["PLAY_MOVIE"] = {
        addonTable.SkipCutscenes_OnPlayMovie
    },
    ["MAIL_INBOX_UPDATE"] = {
        addonTable.MailboxAutomation_OnMailInboxUpdate
    },
    ["MAIL_SHOW"] = {
        addonTable.MailboxAutomation_OnMailShow
    },
}

-- will be populated with events and corresponding handlers when addon is loaded
local eventHandlers = {
    ["ADDON_LOADED"] = { PoliQuest_OnAddonLoaded },
    ["PLAYER_LOGOUT"] = { PoliQuest_OnPlayerLogout }
}
local updateHandlers = {}

local addEventHandlers = function(featureName, events)
    for i, v in ipairs(events) do
        local event, unit = unpack(v)
        -- example: The strings QuestAndDialogAutomation and QUEST_REMOVED become the function QuestAndDialogAutomation_OnQuestRemoved
        local handlerName = featureName .. "_On" .. event:gsub("_", " "):lower():gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end):gsub(" ", "")
        local newEventHandler = addonTable[handlerName]
        local eventHandlerSet = eventHandlers[event]
        if not eventHandlerSet then
            eventHandlers[event] = { newEventHandler }
            if not unit then
                addonTable.EventHandler:RegisterEvent(event)
            else
                addonTable.EventHandler:RegisterUnitEvent(event, unit)
            end
        else
            local j = 1
            while eventHandlerSet[j] do
                -- if handler should be before the current one, then insert at this index
                if constantEventHandlers[event][j] == newEventHandler and eventHandlerSet[j] ~= newEventHandler then
                    table.insert(eventHandlerSet, j, newEventHandler)
                    break
                -- do nothing if handler is already inserted
                elseif eventHandlerSet[j] == newEventHandler then
                    break
                end
                j = j + 1
            end
            if j == #eventHandlerSet + 1 then
                table.insert(eventHandlerSet, newEventHandler)
            end
        end
    end
end

local removeEventHandlers = function(featureName, events)
    for i, v in ipairs(events) do
        local event = unpack(v)
        -- example: The strings QuestAndDialogAutomation and QUEST_REMOVED become the function QuestAndDialogAutomation_OnQuestRemoved
        local eventHandlerToRemove = addonTable[featureName .. "_On" .. event:gsub("_", " "):lower():gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end):gsub(" ", "")]
        local eventHandlerSet = eventHandlers[event]
        if eventHandlerSet then
            for j, handlerFunction in ipairs(eventHandlerSet) do
                if eventHandlerSet[j] == eventHandlerToRemove then
                    table.remove(eventHandlerSet, j)
                end
            end
            if #eventHandlerSet == 0 then
                eventHandlers[event] = nil
                addonTable.EventHandler:UnregisterEvent(event)
            end
        end
    end
end

local addUpdateHandler = function(featureName)
    local newUpdateHandler = addonTable[featureName].onUpdate
    local handlerFound = false
    for _, updateHandler in ipairs(updateHandlers) do
        if updateHandler == newUpdateHandler then
            handlerFound = true
            break
        end
    end
    if not handlerFound then
        table.insert(updateHandlers, newUpdateHandler)
    end
end

local removeUpdateHandler = function(featureName)
    local updateHandlerToRemove = addonTable[featureName].onUpdate
    for i, updateHandler in ipairs(updateHandlers) do
        if updateHandler == updateHandlerToRemove then
            table.remove(updateHandlers, i)
        end
    end
end

addonTable.updateFeatureConfiguration = function(featureName, isEnabled)
    if isEnabled then
        addEventHandlers(featureName, addonTable[featureName].events)
        addonTable[featureName].initialize()
        if addonTable[featureName].onUpdate then
            addUpdateHandler(featureName)
        end
    else
        addonTable[featureName].terminate()
        if addonTable[featureName].onUpdate then
            removeUpdateHandler(featureName)
        end
        removeEventHandlers(featureName, addonTable[featureName].events)
    end
    PoliSavedVars[featureName].enabled = isEnabled
end

addonTable.updateFeatureSwitch = function(featureName, switchName, isEnabled)
    addonTable[featureName].setSwitch(switchName, isEnabled)
    PoliSavedVars[featureName].switches[switchName] = isEnabled
end

local PoliQuest_OnEvent = function(self, event, ...)
    local eventHandlerSet = eventHandlers[event]
    for _, eventHandler in ipairs(eventHandlerSet) do
        eventHandler(...)
    end
end

local PoliQuest_OnUpdate = function()
    for _, updateHandler in ipairs(updateHandlers) do
        updateHandler()
    end
end

local poliQuestEventHandler = CreateFrame("Frame", "PoliQuestEventHandler")
poliQuestEventHandler:SetScript("OnEvent", PoliQuest_OnEvent)
poliQuestEventHandler:SetScript("OnUpdate", PoliQuest_OnUpdate)
poliQuestEventHandler:RegisterEvent("ADDON_LOADED")
poliQuestEventHandler:RegisterEvent("PLAYER_LOGOUT")
addonTable.EventHandler = poliQuestEventHandler

SLASH_PoliQuest1 = "/poliquest"
SLASH_PoliQuest2 = "/pq"

SlashCmdList["PoliQuest"] = function(msg)
    local cmd, arg = string.split(" ", msg)
    if cmd == "" then
        if addonTable.configMenu and addonTable.configMenu:IsVisible() then
            addonTable.configMenu.frame:SetClampedToScreen(false)
            addonTable.configMenu:Hide()
        else
            addonTable.createMenu()
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
