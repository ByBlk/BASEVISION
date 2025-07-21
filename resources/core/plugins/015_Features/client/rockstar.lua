local rockstarActivate = false

VFW.RegisterInput("rockstar", "Rockstar Editor", "keyboard", "F3", function()
    if not rockstarActivate then
        rockstarActivate = true
        StartRecording(1)
    else
        rockstarActivate = false
        StopRecordingAndSaveClip()
    end
end)