local _, addonTable = ...

local CinematicFrame, CinematicFrame_CancelCinematic, GameMovieFinished, StopCinematic = CinematicFrame, CinematicFrame_CancelCinematic, GameMovieFinished, StopCinematic

local feature = {}

local DEBUG_SKIP_CUTSCENES
function feature.setDebug(enabled)
    DEBUG_SKIP_CUTSCENES = enabled
end
function feature.isDebug()
    return DEBUG_SKIP_CUTSCENES
end

local function debugPrint(text)
    if DEBUG_SKIP_CUTSCENES then
        print("|cFF5c8cc1PoliQuest[DEBUG]:|r " .. text)
    end
end

local featureEnabled
CinematicFrame:HookScript("OnShow", function()
    if featureEnabled then
        CinematicFrame_CancelCinematic()
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

function feature.eventHandlers.onPlayMovie()
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
