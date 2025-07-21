local timeout = {}

RegisterNetEvent("society:sonnette:sonne", function(job)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not timeout[source] then
        timeout[source] = false
    end
    if timeout[source] then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Vous devez attendre avant de sonner à nouveau."
        })
    elseif not timeout[source] then
        SetTimeout(15000, function()
            timeout[source] = false
        end)
        for k, v in pairs(VFW.GetPlayers()) do
            local tPlayer = VFW.GetPlayerFromId(v)
            if tPlayer.job.name == job then
                tPlayer.showNotification({
                    type = 'VERT',
                    content = "Quelqu'un a sonné à vôtre entreprise."
                })
            end
        end
        timeout[source] = true
    end
end)
