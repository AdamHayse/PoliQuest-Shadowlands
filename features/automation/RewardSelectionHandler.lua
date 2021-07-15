local _, addonTable = ...

local questIDBlacklist = addonTable.data.questIDBlacklist

local util = addonTable.util

local feature = {}

local DEBUG_QUEST_REWARD_SELECTION_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_REWARD_SELECTION_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_REWARD_SELECTION_HANDLER
end
local print, debugPrint, uniquePrint = util.getPrintFunction(feature)

local Modifier
local function automationSuppressed()
    if Modifier == "Alt" then
        return IsAltKeyDown()
    elseif Modifier == "Ctrl" then
        return IsControlKeyDown()
    elseif Modifier == "Shift" then
        return IsShiftKeyDown()
    else
        debugPrint("Modifier switch not set.")
        return false
    end
end

local function calculatePotentialUpgradesSimple(questItemInfoList, lootSpecInfo)
    local highestClass
    local results = {}
    for _, itemInfo in ipairs(questItemInfoList) do
        local maxClass, maxScore
        if util.missingItem({itemInfo}) then
            maxClass, maxScore = util.getSimpleScore(itemInfo, lootSpecInfo)
            table.insert(results, {
                itemInfo = itemInfo,
                class = maxClass,
                score = maxScore
            })
        else
            for _, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
                local class, score = util.compareItemsSimple(itemInfo, equippedItemInfo, lootSpecInfo)
                if not maxClass or class > maxClass or class == maxClass and score > maxScore then
                    maxClass = class
                    maxScore = score
                end
            end
            table.insert(results, {
                itemInfo = itemInfo,
                class = maxClass,
                score = maxScore
            })
        end
        debugPrint("Simple Weights class and score result for quest reward at index " .. itemInfo.index .. ":\nClass: " .. maxClass .. "\nScore: " .. maxScore)
        if not highestClass or maxClass > highestClass then
            highestClass = maxClass
        end
    end
    debugPrint("Setting Simple Weights scores for class " .. highestClass)
    for _, result in ipairs(results) do
        if result.class == highestClass then
            result.itemInfo.score = result.score
        end
    end
end

local function calculatePotentialUpgradesPawn(questItemInfoList, lootSpecInfo)
    local scaleName = util.fetchScaleName(lootSpecInfo)
    for _, itemInfo in ipairs(questItemInfoList) do
        local maxPawnScore
        if util.missingItem({itemInfo}) then
            maxPawnScore = util.getPawnScore(itemInfo, scaleName)
        else
            for _, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
                local pawnScore = util.compareItemsPawn(itemInfo, equippedItemInfo, scaleName)
                if pawnScore == nil then
                    maxPawnScore = nil
                    break
                elseif not maxPawnScore or pawnScore > maxPawnScore then
                    maxPawnScore = pawnScore
                end
            end
        end
        if maxPawnScore == nil then
            debugPrint("Failed to calculate Pawn Weights score for quest reward at index " .. itemInfo.index .. ". Defaulting to Simple Weights selection logic.")
            return false
        else
            itemInfo.score = maxPawnScore
            debugPrint("Pawn Weights score result for quest reward at index " .. itemInfo.index .. ": " .. itemInfo.score)
        end
    end
    return true
end

local function calculatePotentialUpgradesItemLevel(questItemInfoList)
    debugPrint("Item Level score for quest rewards: " .. questItemInfoList[1].itemLevel)
    for _, itemInfo in ipairs(questItemInfoList) do
        local maxItemLevelScore
        if util.missingItem({itemInfo}) then
            maxItemLevelScore = itemInfo.itemLevel
        else
            for _, equippedItemInfo in pairs(itemInfo.itemsToCompare) do
                local itemLevelScore = util.compareItemsItemLevel(itemInfo, equippedItemInfo)
                if not maxItemLevelScore or itemLevelScore > maxItemLevelScore then
                    maxItemLevelScore = itemLevelScore
                end
            end
        end
        itemInfo.score = maxItemLevelScore
        debugPrint("Item Level score result for quest reward at index " .. itemInfo.index .. ": " .. itemInfo.score)
    end
end

local function addEquipSlotItems(questItemInfoList, lootSpecInfo)
    for _, itemInfo in ipairs(questItemInfoList) do
        util.addItemsToCompare(itemInfo, util.getEquipSlotItemLinks(itemInfo.itemEquipLoc), lootSpecInfo)
    end
end

local function upgradePostProcessing(questItemInfoList)
    local maxScore, maxScoreIndex
    for _, itemInfo in ipairs(questItemInfoList) do
        if not maxScore or itemInfo.score and itemInfo.score > maxScore then
            maxScore = itemInfo.score
            maxScoreIndex = itemInfo.index
        end
    end
    return maxScoreIndex
end

local function calculateMostValuableItemIndex(questItemInfoList)
    for _, itemInfo in ipairs(questItemInfoList) do
        itemInfo.score = itemInfo.vendorPrice
        debugPrint("Vendor score for reward at index " .. itemInfo.index .. ": " .. itemInfo.score)
    end
end

local IlvlThreshold
local function shouldAbortRewardAutomation(questItemInfoList, lootSpecInfo)
    debugPrint("SelectionLogic = " .. (SelectionLogic or "nil"))
    if not util.allItemsAreEquippable(questItemInfoList) then
        print("Quest reward selection automation aborted due to items that are not equippable.")
        return true
    end
    local questItemIlvl = util.getHighestItemLevel(questItemInfoList)
    if questItemIlvl > IlvlThreshold then
        print("Quest reward selection automation aborted due to items above ilvl threshold.")
        return true
    end
    if SelectionLogic ~= "Vendor Price" then
        local specQuestItemInfoList = util.filterSpecItems(questItemInfoList, lootSpecInfo)

        if #specQuestItemInfoList == 0 then
            if lootSpecInfo.specIndex == 5 then
                print("Quest reward selection automation aborted due to no class specialization.")
                if UnitLevel("player") < 10 then
                    print("Set loot specialization to remove this check while lower than level 10.")
                end
            else
                print("Quest reward selection automation aborted due to no items for your current loot specialization.")
            end
            return true
        elseif #specQuestItemInfoList == 1 then
            debugPrint("Only one spec item. Exiting shouldAbortRewardAutomation.")
            return false
        end

        -- WRONG ARMOR SPEC CHECK
        -- check if it's a boe
        if util.missingItem(specQuestItemInfoList) and questItemIlvl > 50 then
            print("Quest reward selection automation aborted due to item missing from equip slot.")
            return true
        end
        if util.socketExists(specQuestItemInfoList) then
            print("Quest reward selection automation aborted due to reward with socket.")
            return true
        end
        if util.trinketExists(specQuestItemInfoList) then
            print("Quest reward selection automation aborted due to trinket reward.")
            return true
        end
        if util.weaponExists(specQuestItemInfoList) then
            print("Quest reward selection automation aborted due to weapon reward.")
            return true
        end
    end

    if util.shirtExists(questItemInfoList) then
        print("Quest reward selection automation aborted due to shirt reward.")
        return true
    end
    if util.tabardExists(questItemInfoList) then
        print("Quest reward selection automation aborted due to tabard reward.")
        return true
    end
    return false
end

local function getQuestItemInfoList(lootSpecInfo)
    local questItemInfoList = {}
    for i=1, GetNumQuestChoices() do
        table.insert(questItemInfoList, util.getItemInfo(GetQuestItemLink("choice", i), lootSpecInfo, i))
    end
    return questItemInfoList
end

local function getQuestRewardChoice()
    local lootSpecInfo = util.getLootSpecInfo()
    local questItemInfoList = getQuestItemInfoList(lootSpecInfo)

    if shouldAbortRewardAutomation(questItemInfoList, lootSpecInfo) then
        return
    end
    
    if SelectionLogic == "Vendor Price" then
        debugPrint("Executing Vendor Price selection logic.")
        calculateMostValuableItemIndex(questItemInfoList)
        return upgradePostProcessing(questItemInfoList)
    else
        local specQuestItemInfoList = util.filterSpecItems(questItemInfoList, lootSpecInfo)
        if #specQuestItemInfoList == 1 then
            debugPrint("Only one spec item. Select reward at index " .. specQuestItemInfoList[1].index)
            return specQuestItemInfoList[1].index
        else
            addEquipSlotItems(specQuestItemInfoList, lootSpecInfo)
            if SelectionLogic == "Item Level" then
                debugPrint("Executing Item Level selection logic.")
                calculatePotentialUpgradesItemLevel(specQuestItemInfoList)
            end
            local pawnSuccess
            if SelectionLogic == "Pawn Weights" then
                debugPrint("Executing Pawn Weights selection logic.")
                pawnSuccess = calculatePotentialUpgradesPawn(specQuestItemInfoList, lootSpecInfo)
                util.emptyPawnScoresCache()
            end
            if SelectionLogic == "Simple Weights" or SelectionLogic == "Pawn Weights" and not pawnSuccess then
                debugPrint("Executing Simple Weights selection logic.")
                calculatePotentialUpgradesSimple(specQuestItemInfoList, lootSpecInfo)
            end
            return upgradePostProcessing(specQuestItemInfoList)
        end
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onQuestComplete()
    debugPrint("QuestRewardSelectionAutomation - Entering onQuestComplete")
    if not automationSuppressed() then
        local questID = GetQuestID()
        local title = GetTitleText()
        debugPrint("Quest ID: " .. questID)
        debugPrint("Quest Name: " .. title)
        if not questIDBlacklist[questID] then
            local numQuestChoices = GetNumQuestChoices()
            debugPrint("numQuestChoices: " .. numQuestChoices)
            if numQuestChoices > 1 then
                local questRewardIndex = getQuestRewardChoice()
                if questRewardIndex then
                    debugPrint("questRewardIndex: "..questRewardIndex)
                    GetQuestReward(questRewardIndex)
                end
            end
        else
            uniquePrint("Quest \"" .. title .. "\" not automated due to blacklisting.")
        end
    else
        debugPrint("Automation manually suppressed.")
    end
    debugPrint("QuestRewardSelectionAutomation - Exiting onQuestComplete")
end

local function initialize()
end

local function terminate()
end

feature.initialize = initialize
feature.terminate = terminate
function feature.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. tostring(value))
    if switchName == "IlvlThreshold" then
        IlvlThreshold = tonumber(value)
    elseif switchName == "SelectionLogic" then
        SelectionLogic = value == 1 and "Simple Weights" or (value == 2 and "Pawn Weights" or (value == 3 and "Item Level" or (value == 4 and "Vendor Price" or nil)))
    elseif switchName == "Modifier" then
        Modifier = value == 1 and "Alt" or (value == 2 and "Ctrl" or (value == 3 and "Shift" or nil))
    end
end
addonTable.features = addonTable.features or {}
addonTable.features.QuestRewardSelectionAutomation = feature
