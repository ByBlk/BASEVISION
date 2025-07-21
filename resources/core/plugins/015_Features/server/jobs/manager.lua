RegisterNetEvent("vfw:changeDuty", function(state)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local jobName = xPlayer.getJob().label
    local discord = VFW.GetIdentifier(source)

    xPlayer.job.onDuty = state

    if state then
        logs.society.startService(xPlayer.source)
    else
        logs.society.stopService(xPlayer.source)
    end
end)
