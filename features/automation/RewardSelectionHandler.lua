local _, addonTable = ...

local slower, tinsert = string.lower, table.insert

local function debugPrint(text)
    if DEBUG_QUEST_REWARD_SELECTION_HANDLER then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local questNames = addonTable.questNames
local itemEquipLocToEquipSlot = addonTable.itemEquipLocToEquipSlot

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
            local scanningTooltip = addonTable.tooltip
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

local function calculateStatScore(lootSpecPrimaryStatConstant, info)
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
        debugPrint("Stat score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceStatScore = calculateWeakestPieceStatScore(lootSpecPrimaryStatConstant, info.equipSlotLocItemInfo)
            debugPrint("Stat score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceStatScore)
            info.score = rewardScore - weakestPieceStatScore
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
        debugPrint("Stam score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceStamScore = calculateWeakestPieceStamScore(info.equipSlotLocItemInfo)
            debugPrint("Stam score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceStamScore)
            info.score = rewardScore - weakestPieceStamScore
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
        debugPrint("Armor score for reward at index ".. info.index .. ": ".. rewardScore)
        if rewardScore ~= 0 then
            local weakestPieceArmorScore = calculateWeakestPieceArmorScore(info.equipSlotLocItemInfo)
            debugPrint("Armor score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPieceArmorScore)
            info.score = rewardScore - weakestPieceArmorScore
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
        tinsert(questRewardInfo, {
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
        if itemEquipLoc == "" then
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

                tinsert(info.equipSlotLocItemInfo, {
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
    if not allQuestItemsAreEquippable(questRewardInfo) then
        print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to items that are not equippable.")
        return true
    end
    if getQuestItemIlvl(questRewardInfo) > IlvlThreshold then
        print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to items above ilvl threshold.")
        return true
    end

    setLootSpecInfo(questRewardInfo)
    filterSpecItems(questRewardInfo)

    if #questRewardInfo == 0 then
        print("|cFF5c8cc1PoliQuest:|r Quest reward automation aborted due to no items for your current loot specialization.")
        return true
    elseif #questRewardInfo == 1 then
        debugPrint("Only one spec item. Exiting shouldAbortRewardAutomation.")
        return false
    end

    collectItemStats(questRewardInfo.lootSpecPrimaryStatConstant, questRewardInfo)

    -- WRONG ARMOR SPEC CHECK
    -- check if it's a boe
    if missingItem(questRewardInfo) then
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
            debugPrint("Pawn score for reward at index ".. info.index .. ": ".. rewardScore)
            if rewardScore and rewardScore ~= 0 then
                local weakestPiecePawnScore = calculateWeakestPiecePawnScore(info.equipSlotLocItemInfo, scaleName)
                debugPrint("Pawn score for weakest piece of type ".. info.itemEquipLoc .. ": ".. weakestPiecePawnScore)
                info.score = rewardScore - weakestPiecePawnScore
            else
                debugPrint("Pawn failed to calculate item value for quest reward at index " .. info.index)
                return
            end
        end
    end
end

local function upgradePostProcessing(questRewardInfo)
    local maxScore, maxScoreIndex
    for _, info in ipairs(questRewardInfo) do
        if info.score > (maxScore or 0) then
            maxScore = info.score
            maxScoreIndex = info.index
        end
    end
    return maxScoreIndex
end

local function getQuestRewardChoice()
    local questRewardInfo = collectQuestRewardInfo()
    if shouldAbortRewardAutomation(questRewardInfo) then
        return
    end
    
    if #questRewardInfo == 1 then
        debugPrint("Only one spec item. Select reward at index " .. questRewardInfo[1].index)
        return questRewardInfo[1].index
    else
        local pawnSuccess
        if SelectionLogic == "Pawn" then
            debugPrint("Executing selection logic with Pawn weights.")
            pawnSuccess = calculatePotentialUpgradesPawn(questRewardInfo)
        end
        if SelectionLogic == "Dumb" or not pawnSuccess then
            debugPrint("Executing selection logic with dumb weights.")
            calculatePotentialUpgradesDumb(questRewardInfo)
        end
        return upgradePostProcessing(questRewardInfo)
    end
end

function addonTable.QuestRewardSelectionAutomation_OnQuestComplete()
    if QuestInfoTitleHeader ~= nil then
        debugPrint("QuestInfoTitleHeader shown: true")
    else
        debugPrint("QuestInfoTitleHeader shown: false")
    end
    if QuestInfoTitleHeader then
        debugPrint(QuestInfoTitleHeader:GetText())
        if questNames[slower(QuestInfoTitleHeader:GetText())] then
            if GetNumQuestChoices() > 1 then
                local questRewardIndex = getQuestRewardChoice()
                if questRewardIndex then
                    debugPrint("questRewardIndex: "..questRewardIndex)
                    GetQuestReward(questRewardIndex)
                end
            end
        end
    end
end

local function initialize()
end

local function terminate()
end

local questRewardSelectionAutomation = {}
questRewardSelectionAutomation.name = "QuestRewardSelectionAutomation"
questRewardSelectionAutomation.events = {
    { "QUEST_COMPLETE" }
}

questRewardSelectionAutomation.initialize = initialize
questRewardSelectionAutomation.terminate = terminate
function questRewardSelectionAutomation.setSwitch(switchName, value)
    debugPrint(switchName .. " set to " .. value)
    if switchName == "IlvlThreshold" then
        IlvlThreshold = tonumber(value)
    elseif switchName == "SelectionLogic" then
        SelectionLogic = value
    end
end
addonTable[questRewardSelectionAutomation.name] = questRewardSelectionAutomation
