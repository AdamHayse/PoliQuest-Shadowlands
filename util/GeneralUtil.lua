local _, addonTable = ...

addonTable.util = addonTable.util or {}

local util = addonTable.util

local print = print

local lastPrintedMessage
function util.printUniqueMessage(text)
    if lastPrintedMessage ~= text then
        print("|cFF5c8cc1PoliQuest:|r " .. text)
        lastPrintedMessage = text
    end
end

function util.printMessage(text)
    print("|cFF5c8cc1PoliQuest:|r " .. text)
end

function util.printDebugMessage(text, isDebug)
    if isDebug then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

function util.getPrintFunction(feature)
    return util.printMessage, function(text) return util.printDebugMessage(text, feature.isDebug()) end, util.printUniqueMessage 
end