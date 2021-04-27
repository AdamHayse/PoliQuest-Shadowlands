local _, addonTable = ...

local itemEquipLocToEquipSlot = addonTable.data.itemEquipLocToEquipSlot
local questIDBlacklist = addonTable.data.questIDBlacklist

local feature = {}

local DEBUG_QUEST_REWARD_SELECTION_HANDLER
function feature.setDebug(enabled)
    DEBUG_QUEST_REWARD_SELECTION_HANDLER = enabled
end
function feature.isDebug()
    return DEBUG_QUEST_REWARD_SELECTION_HANDLER
end

local function debugPrint(text)
    if DEBUG_QUEST_REWARD_SELECTION_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

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

local localizedPrimaryStat = {
    ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT,
    ITEM_MOD_AGILITY_SHORT = ITEM_MOD_AGILITY_SHORT,
    ITEM_MOD_INTELLECT_SHORT = ITEM_MOD_INTELLECT_SHORT
}

-- gets all stats (including inactive primary stat that might be relevant for the current loot spec)
local function collectItemStats(lootSpecPrimaryStatConstant, itemInfoArray)
    for _, info in ipairs(itemInfoArray) do
        GetItemStats(info.itemLink, info)
        if not info[lootSpecPrimaryStatConstant] then
            local scanningTooltip = addonTable.util.tooltip
            scanningTooltip:ClearLines()
            scanningTooltip:SetHyperlink(info.itemLink)
            for i=1, scanningTooltip:NumLines() do
                local line = _G["PoliScanningTooltipTextLeft" .. i]:GetText()
                if line:find(localizedPrimaryStat[lootSpecPrimaryStatConstant] .. "$") then
                    info[lootSpecPrimaryStatConstant] = tonumber(line:match("(+?-?%d+) ".. lootSpecPrimaryStatConstant .. "$"))
                end
            end
        end
    end
end

local function calculateMostValuableItemIndex(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        info.score = select(11, GetItemInfo(info.itemLink))
        debugPrint("Vendor score for reward at index " .. info.index .. ": " .. info.score)
    end
end

local function calculatePotentialUpgradesItemLevel(questRewardInfo)
    local questRewardItemLevel = GetDetailedItemLevelInfo(questRewardInfo[1].itemLink)
    debugPrint("Item Level score for quest rewards: " .. questRewardItemLevel)
    for _, info in ipairs(questRewardInfo) do
        local equipSlotItemLevel
        if #equipSlotLocItemInfo == 1 then
            equipSlotItemLevel = GetDetailedItemLevelInfo(info.equipSlotLocItemInfo[1].itemLink) or 0
        else
            local score1 = GetDetailedItemLevelInfo(info.equipSlotLocItemInfo[1].itemLink) or 0
            local score2 = GetDetailedItemLevelInfo(info.equipSlotLocItemInfo[2].itemLink) or 0
            equipSlotItemLevel =  score1 < score2 and score1 or score2
        end
        debugPrint("Item Level score for weakest piece of type ".. info.itemEquipLoc .. ": ".. equipSlotItemLevel)
        info.score = questRewardItemLevel - equipSlotItemLevel
        debugPrint("Item Level score result for quest reward at index " .. info.index .. ": " .. info.score)
    end
end

local function calculateStatScore(lootSpecPrimaryStatConstant, info)
    if info == nil then
        return 0
    end
    local primary = info[lootSpecPrimaryStatConstant] or 0
    local crit = info.ITEM_MOD_CRIT_RATING_SHORT or 0
    local mastery = info.ITEM_MOD_MASTERY_RATING_SHORT or 0
    local versatility = info.ITEM_MOD_VERSATILITY or 0
    local haste = info.ITEM_MOD_HASTE_RATING_SHORT or 0
    return 2 * primary + crit + mastery + versatility + haste
end

local function calculateWeakestPieceStatScore(lootSpecPrimaryStatConstant, equipSlotLocItemInfo)
    collectItemStats(lootSpecPrimaryStatConstant, equipSlotLocItemInfo)
    if #equipSlotLocItemInfo == 1 then
        return calculateStatScore(lootSpecPrimaryStatConstant, equipSlotLocItemInfo[1])
    else
        local score1 = calculateStatScore(lootSpecPrimaryStatConstant, equipSlotLocItemInfo[1])
        local score2 = calculateStatScore(lootSpecPrimaryStatConstant, equipSlotLocItemInfo[2])
        return score1 < score2 and score1 or score2
    end
end

local function calculateStatScoreDifferences(questRewardInfo)
    local statsExist = false
    local lootSpecPrimaryStatConstant = questRewardInfo.lootSpecPrimaryStatConstant
    for _, info in ipairs(questRewardInfo) do
        local rewardScore = calculateStatScore(lootSpecPrimaryStatConstant, info)
        debugPrint("Simple Weights stat score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceStatScore = calculateWeakestPieceStatScore(lootSpecPrimaryStatConstant, info.equipSlotLocItemInfo)
            debugPrint("Simple Weights stat score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceStatScore)
            info.score = rewardScore - weakestPieceStatScore
            debugPrint("Simple Weights stat score result for quest reward at index " .. info.index .. ": " .. info.score)
            statsExist = true
        end
    end
    return statsExist
end

local function calculateStamScore(info)
    return info.ITEM_MOD_STAMINA_SHORT or 0
end

local function calculateWeakestPieceStamScore(equipSlotLocItemInfo)
    if #equipSlotLocItemInfo == 1 then
        return calculateStamScore(equipSlotLocItemInfo[1])
    else
        local score1 = calculateStamScore(equipSlotLocItemInfo[1])
        local score2 = calculateStamScore(equipSlotLocItemInfo[2])
        return score1 < score2 and score1 or score2
    end
end

local function calculateStamScoreDifferences(questRewardInfo)
    local stamExists = false
    for _, info in ipairs(questRewardInfo) do
        local rewardScore = calculateStamScore(info)
        debugPrint("Simple Weights stam score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceStamScore = calculateWeakestPieceStamScore(info.equipSlotLocItemInfo)
            debugPrint("Simple Weights stam score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceStamScore)
            info.score = rewardScore - weakestPieceStamScore
            debugPrint("Simple Weights stam score result for quest reward at index " .. info.index .. ": " .. info.score)
            stamExists = true
        end
    end
    return stamExists
end

local function calculateArmorScore(info)
    return info.RESISTANCE0_NAME or 0
end

local function calculateWeakestPieceArmorScore(equipSlotLocItemInfo)
    if #equipSlotLocItemInfo == 1 then
        return calculateArmorScore(equipSlotLocItemInfo[1])
    else
        local score1 = calculateArmorScore(equipSlotLocItemInfo[1])
        local score2 = calculateArmorScore(equipSlotLocItemInfo[2])
        return score1 < score2 and score1 or score2
    end
end

local function calculateArmorScoreDifferences(questRewardInfo)
    local armorExists = false
    for _, info in ipairs(questRewardInfo) do
        local rewardScore = calculateArmorScore(info)
        debugPrint("Simple Weights armor score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceArmorScore = calculateWeakestPieceArmorScore(info.equipSlotLocItemInfo)
            debugPrint("Simple Weights armor score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceArmorScore)
            info.score = rewardScore - weakestPieceArmorScore
            debugPrint("Simple Weights armor score result for quest reward at index " .. info.index .. ": " .. info.score)
            armorExists = true
        end
    end
    return armorExists
end

local function calculatePotentialUpgradesDumb(questRewardInfo)
    local statsExist = calculateStatScoreDifferences(questRewardInfo)
    if not statsExist then
        local stamExists = calculateStamScoreDifferences(questRewardInfo)
        if not stamExists then
            calculateArmorScoreDifferences(questRewardInfo)
        end
    end
end

local function collectQuestRewardInfo()
    local questRewardInfo = {}
    for i=1, GetNumQuestChoices() do
        table.insert(questRewardInfo, {
            index = i,
            itemLink = GetQuestItemLink("choice", i),
            equipSlotLocItemInfo = {}
        })
    end
    return questRewardInfo
end

local function allQuestItemsAreEquippable(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        local itemEquipLoc = select(9, GetItemInfo(info.itemLink))
        if itemEquipLoc == "" or GetQuestItemInfoLootType("choice", info.index) == 1 then
            return false
        else
            info.itemEquipLoc = itemEquipLoc
        end
    end
    return true
end

local function getQuestItemIlvl(questRewardInfo)
    return GetDetailedItemLevelInfo(questRewardInfo[1].itemLink) -- Assumes all quest rewards are same ilvl.
end

local statIndexToStatConstant = {
    [1] = "ITEM_MOD_STRENGTH_SHORT",
    [2] = "ITEM_MOD_AGILITY_SHORT",
    [4] = "ITEM_MOD_INTELLECT_SHORT"
}

local function setLootSpecInfo(questRewardInfo)
    local lootSpecID = GetLootSpecialization()
    if lootSpecID == 0 then
        questRewardInfo.lootSpecID = GetSpecializationInfo(GetSpecialization())
        questRewardInfo.lootSpecIndex = GetSpecialization()
    else
        questRewardInfo.lootSpecID = lootSpecID
        questRewardInfo.lootSpecIndex = lootSpecID  - GetSpecializationInfo(1) + 1
    end
    questRewardInfo.lootSpecPrimaryStatConstant = statIndexToStatConstant[select(6, GetSpecializationInfo(questRewardInfo.lootSpecIndex))]
    questRewardInfo.lootSpecPrimaryStat = localizedPrimaryStat[questRewardInfo.lootSpecPrimaryStatConstant]
end

local function filterSpecItems(questRewardInfo)
    local lootSpecID = questRewardInfo.lootSpecID
    for i=#questRewardInfo, 1, -1 do
        local specTable = GetItemSpecInfo(questRewardInfo[i].itemLink) or {}
        local containsLootSpec = false
        for _, v in ipairs(specTable) do
            if v == lootSpecID then
                containsLootSpec = true
            end
        end
        if #specTable ~= 0 and not containsLootSpec then
            tremove(questRewardInfo, i)
        end
    end
end

local function missingItem(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        info.equipSlotLocItemLinks = {}
        local equipSlotIDs = itemEquipLocToEquipSlot[info.itemEquipLoc]
        for _, v in ipairs(equipSlotIDs) do
            local equipSlotItemLink = GetInventoryItemLink("player", v)
            if equipSlotItemLink == nil then
                return true
            else

                table.insert(info.equipSlotLocItemInfo, {
                    itemLink = equipSlotItemLink
                })
            end
        end
    end
    return false
end

local function socketExists(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        for k in pairs(info) do
            if k:find("SOCKET") then
                return true
            end
        end
    end
    return false
end

local function trinketExists(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        if info.itemEquipLoc == "INVTYPE_TRINKET" then
            return true
        end
    end
    return false
end

local function weaponExists(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        local itemEquipLoc = info.itemEquipLoc
        if itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_SHIELD"
        or itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_2HWEAPON"
        or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND"
        or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_THROWN"
        or itemEquipLoc == "INVTYPE_RANGEDRIGHT" then
            return true
        end
    end
    return false
end

local function shirtExists(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        if info.itemEquipLoc == "INVTYPE_BODY" then
            return true
        end
    end
    return false
end

local function tabardExists(questRewardInfo)
    for _, info in ipairs(questRewardInfo) do
        if info.itemEquipLoc == "INVTYPE_TABARD" then
            return true
        end
    end
    return false
end

local IlvlThreshold
local function shouldAbortRewardAutomation(questRewardInfo)
    debugPrint("SelectionLogic = " .. (SelectionLogic or "nil"))
    if SelectionLogic ~= "Vendor Price" then
        if not allQuestItemsAreEquippable(questRewardInfo) then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to items that are not equippable.")
            return true
        end
        local questItemIlvl = getQuestItemIlvl(questRewardInfo)
        if questItemIlvl > IlvlThreshold then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to items above ilvl threshold.")
            return true
        end

        setLootSpecInfo(questRewardInfo)
        filterSpecItems(questRewardInfo)

        if #questRewardInfo == 0 then
            if GetSpecialization() == 5 then
                print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to no class specialization. Set loot specialization to remove this check while lower than level 10.")
            else
                print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to no items for your current loot specialization.")
            end
            return true
        elseif #questRewardInfo == 1 then
            debugPrint("Only one spec item. Exiting shouldAbortRewardAutomation.")
            return false
        end

        collectItemStats(questRewardInfo.lootSpecPrimaryStatConstant, questRewardInfo)

        -- WRONG ARMOR SPEC CHECK
        -- check if it's a boe
        if missingItem(questRewardInfo) and questItemIlvl > 50 then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to item missing from equip slot.")
            return true
        end
        if socketExists(questRewardInfo) then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to reward with socket.")
            return true
        end
        if trinketExists(questRewardInfo) then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to trinket reward.")
            return true
        end
        if weaponExists(questRewardInfo) then
            print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to weapon reward.")
            return true
        end
    end

    if shirtExists(questRewardInfo) then
        print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to shirt reward.")
        return true
    end
    if tabardExists(questRewardInfo) then
        print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to tabard reward.")
        return true
    end
    return false
end

--[[
    questRewardInfo associative array
    - lootSpecID
    - lootSpecIndex
    - lootSpecPrimaryStatConstant
    - lootSpecPrimaryStat

    questRewardInfo array element associative array
    - index
    - itemLink
    - itemEquipLoc
    - equipSlotLocItemInfo = { [1] = { itemLink = ""}, [2] = { itemLink = ""}}
    - ITEM_MOD_AGILITY_SHORT
    - ITEM_MOD_MASTERY_RATING_SHORT
    - ITEM_MOD_CRIT_RATING_SHORT
    - ITEM_MOD_HASTE_RATING_SHORT
    - ITEM_MOD_VERSATILITY
    - ITEM_MOD_STAMINA_SHORT
    - RESISTANCE0_NAME
]]


local function getLargestSpecUpgradePawn(lootSpec)
    if foundScaleName then
        for i=1, GetNumQuestChoices() do
            local itemLink = GetQuestItemLink("choice", i)
            local itemEquipLoc = select(9, GetItemInfo(itemLink))
            local slots = itemEquipLocToEquipSlot[itemEquipLoc]
            PawnGetSingleValueFromItem(PawnGetItemData(itemLink), ScaleName)
        end
    end
end

local function fetchScaleName(lootSpecIndex)
    local classID = select(3, UnitClass("player"))
    for ScaleName, Scale in pairs(PawnCommon.Scales) do
        if Scale.ClassID == classID and Scale.SpecID == lootSpecIndex and Scale.Provider ~= nil then
            return ScaleName
        end
    end
end

local function calculateWeakestPiecePawnScore(equipSlotLocItemInfo, scaleName)
    if #equipSlotLocItemInfo == 1 then
        return PawnGetSingleValueFromItem(PawnGetItemData(equipSlotLocItemInfo[1].itemLink), scaleName)
    else
        local score1 = PawnGetSingleValueFromItem(PawnGetItemData(equipSlotLocItemInfo[1].itemLink), scaleName)
        local score2 = PawnGetSingleValueFromItem(PawnGetItemData(equipSlotLocItemInfo[2].itemLink), scaleName)
        return score1 < score2 and score1 or score2
    end

end

local function calculatePotentialUpgradesPawn(questRewardInfo)
    -- fails if pawn can't calculate an item value for reward or equip
    local scaleName = fetchScaleName(questRewardInfo.lootSpecIndex)
    if scaleName then
        local lootSpecPrimaryStatConstant = questRewardInfo.lootSpecPrimaryStatConstant
        for _, info in ipairs(questRewardInfo) do
            local rewardScore = PawnGetSingleValueFromItem(PawnGetItemData(info.itemLink), scaleName)
            debugPrint("Pawn Weights score for reward at index ".. info.index .. ": ".. rewardScore)
            if rewardScore and rewardScore ~= 0 then
                if #info.equipSlotLocItemInfo == 0 or #info.equipSlotLocItemInfo ~= 2 and info.itemEquipLoc == "INVTYPE_FINGER" then 
                    debugPrint("Missing piece of type ".. info.itemEquipLoc)
                    info.score = rewardScore
                else
                    local weakestPiecePawnScore = calculateWeakestPiecePawnScore(info.equipSlotLocItemInfo, scaleName)
                    debugPrint("Pawn Weights score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPiecePawnScore)
                    info.score = rewardScore - weakestPiecePawnScore
                end
                debugPrint("Pawn Weights score result for quest reward at index " .. info.index .. ": " .. info.score)
            else
                debugPrint("Pawn failed to calculate item value for quest reward at index " .. info.index)
                return false
            end
        end
        return true
    end
end

local function upgradePostProcessing(questRewardInfo)
    local maxScore = questRewardInfo[1].score
    local maxScoreIndex = questRewardInfo[1].index
    for i=2,#questRewardInfo do
        if questRewardInfo[i].score > maxScore then
            maxScore = questRewardInfo[i].score
            maxScoreIndex = questRewardInfo[i].index
        end
    end
    return maxScoreIndex
end

local function getQuestRewardChoice()
    local questRewardInfo = collectQuestRewardInfo()
    if shouldAbortRewardAutomation(questRewardInfo) then
        return
    end
    
    if SelectionLogic == "Vendor Price" then
        debugPrint("Executing Vendor Price selection logic.")
        calculateMostValuableItemIndex(questRewardInfo)
    elseif #questRewardInfo == 1 then
        debugPrint("Only one spec item. Select reward at index " .. questRewardInfo[1].index)
        return questRewardInfo[1].index
    else
        if SelectionLogic == "Item Level" then
            debugPrint("Executing Item Level selection logic.")
            calculatePotentialUpgradesItemLevel(questRewardInfo)
        end
        local pawnSuccess
        if SelectionLogic == "Pawn Weights" then
            debugPrint("Executing Pawn Weights selection logic.")
            pawnSuccess = calculatePotentialUpgradesPawn(questRewardInfo)
        end
        if SelectionLogic == "Simple Weights" or SelectionLogic == "Pawn Weights" and not pawnSuccess then
            debugPrint("Executing Simple Weights selection logic.")
            calculatePotentialUpgradesDumb(questRewardInfo)
        end
    end
    return upgradePostProcessing(questRewardInfo)
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
            print("|cFF5c8cc1PoliQuest:|r Quest \"" .. title .. "\" not automated due to blacklisting.")
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
    debugPrint(switchName .. " set to " .. value)
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
