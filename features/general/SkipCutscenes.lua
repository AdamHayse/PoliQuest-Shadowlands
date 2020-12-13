local _, addonTable = ...

local CinematicFrame, CinematicFrame_CancelCinematic, GameMovieFinished, StopCinematic = CinematicFrame, CinematicFrame_CancelCinematic, GameMovieFinished, StopCinematic

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

function addonTable.SkipCutscenes_OnPlayMovie()
    StopCinematic()
end

local function initialize()
    featureEnabled = true
end

local function terminate()
    featureEnabled = false
end

local skipCutscenes = {}
skipCutscenes.name = "SkipCutscenes"
skipCutscenes.events = {
    { "PLAY_MOVIE" }
}
skipCutscenes.initialize = initialize
skipCutscenes.terminate = terminate
addonTable[skipCutscenes.name] = skipCutscenes
