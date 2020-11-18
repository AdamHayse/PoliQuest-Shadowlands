local _, addonTable = ...

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

addonTable.SkipCutscenes_OnPlayMovie = function()
    StopCinematic()
end

local initialize = function()
    featureEnabled = true
end

local terminate = function()
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
