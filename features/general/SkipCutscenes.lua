local _, addonTable = ...

local feature = {}

local DEBUG_SKIP_CUTSCENES
function feature.setDebug(enabled)
    DEBUG_SKIP_CUTSCENES = enabled
end
function feature.isDebug()
    return DEBUG_SKIP_CUTSCENES
end
local print, debugPrint, uniquePrint = addonTable.util.getPrintFunction(feature)

local featureEnabled
CinematicFrame:HookScript("OnShow", function()
    if featureEnabled then
        if CinematicFrame.isRealCinematic then
            StopCinematic()
        elseif CanCancelScene() then
            CancelScene()
        end
    end
end)

local oldPlayMovie = MovieFrame_PlayMovie
MovieFrame_PlayMovie = function(...)
    if featureEnabled then
        GameMovieFinished()
        return
    else
        return oldPlayMovie(...)
    end
end

feature.eventHandlers = {}

function feature.eventHandlers.onPlayMovie(movieID)
    debugPrint("Movie ID: " .. movieID)
    StopCinematic()
end

local function initialize()
    featureEnabled = true
end

local function terminate()
    featureEnabled = false
end

feature.initialize = initialize
feature.terminate = terminate
addonTable.features = addonTable.features or {}
addonTable.features.SkipCutscenes = feature
