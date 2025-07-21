
local ProgrammedAnnounces = {}
local inTimeout = false


CreateThread(function()
    while true do
        Wait(30 * 1000)

        for k,v in pairs(ProgrammedAnnounces) do
            if v.time <= (os.time() * 1000) then
                if v.type == "weazelnews" then
                    TriggerClientEvent("core:weazel:sendAnnounceAll", -1, v.data)
                elseif v.type == "lifeinvader" then
                    TriggerClientEvent("lifeInvaderAnnonce:showAnnonce", -1, v.data)
                end

                table.remove(ProgrammedAnnounces, k)
            end
        end
    end
end)


RegisterNetEvent("core:weazel:sendAnnounce")
AddEventHandler("core:weazel:sendAnnounce", function(data)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)
    local xPlayers = VFW.GetPlayers()

    if not xPlayer then 
        return 
    end

    if xPlayer.job.name ~= "weazelnews" then
        return 
    end


    if not inTimeout then
        if data.programmations and #data.programmations > 0 then
            for k,v in pairs(data.programmations) do
                table.insert(ProgrammedAnnounces, {time = v, data = data, type = "weazelnews"})
            end
        else
            TriggerClientEvent("core:weazel:sendAnnounceAll", -1, data)
        end
    
        inTimeout = true

        SetTimeout(600000, function()
            inTimeout = false
        end)
    else
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Vous devez attendre 10 minutes avant de pouvoir envoyer une nouvelle annonce."
        })
    end
end)    