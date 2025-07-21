local inTimeout = {} 

RegisterNetEvent("core:server:announceEntreprise:sendData")
AddEventHandler("core:server:announceEntreprise:sendData", function(data)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)
    local xPlayers = VFW.GetPlayers()

    if not xPlayer then 
        return 
    end
    
    if not inTimeout[xPlayer.job.name] then 
        for i = 1, #xPlayers do
            local xPlayer = VFW.GetPlayerFromId(xPlayers[i])
            if xPlayer then
                xPlayer.showNotification({
                    type = "JOB",
                    name = data.name_entreprise_notif,
                    logo = data.logo_entreprise_notif,
                    content = data.message_notif,
                    phone = data.telephone_notif,
                    typeannonce = data.choiceType_notif,
                    duration = 10,
                })
            end
        end

        inTimeout[xPlayer.job.name] = true

        SetTimeout(600000, function()
            inTimeout[xPlayer.job.name] = false
        end)
    else
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Vous devez attendre 10 minutes avant de pouvoir envoyer une nouvelle annonce."
        })
    end
end)