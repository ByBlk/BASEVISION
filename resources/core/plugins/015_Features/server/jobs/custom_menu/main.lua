RegisterNetEvent("core:mecano:buyCustoms")
AddEventHandler("core:mecano:buyCustoms", function(target)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)
    local xTarget = VFW.GetPlayerFromId(target)


    if (type(target) ~= "number") then
        return
    end

    if not xPlayer then 
        return 
    end

    if not xTarget then
        xPlayer.showNotification({ type = 'ROUGE', content = "Le joueur n'est pas connecté."})
        return 
    end


    if xPlayer ~= nil and xTarget ~= nil then 
        xPlayer.triggerEvent("core:mechanic:receivePlayerBillsState", true)
    end
end)

RegisterNetEvent("core:mechanic:applyCustoms")
AddEventHandler("core:mechanic:applyCustoms", function(props, price)

    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)
    local price = tonumber(price)

    if not xPlayer then 
        return 
    end

    -- REMOVE MONEY TO ENTREPRISE 


    xPlayer.triggerEvent("core:mecano:installCustoms")
    xPlayer.showNotification({ type = 'VERT', content = "Les modifications ont été appliquées."})



    -- IF NOT MONEY THEN DELETE INSTALL

    xPlayer.triggerEvent("core:mecano:cancelCustoms")
end)

RegisterNetEvent("core:mechanic:refreshOwnedVehicle")
AddEventHandler("core:mechanic:refreshOwnedVehicle", function(vehicle)
    local source = source
	local xPlayer = VFW.GetPlayerFromId(source)

    -- TODO : VERIF SI IL A LE JOB 


    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE @plate = plate", {
        ["@plate"] = vehicle.plate
    }, function(result)
        if result[1] then
            local props = json.decode(result[1].props)

            if props.model == vehicle.model and props.plate == vehicle.plate then

                MySQL.Async.execute("UPDATE `owned_vehicles` SET `props` = @props WHERE `plate` = @plate",
                    {
                        ['@plate'] = vehicle.plate,
                        ['@props'] = json.encode(vehicle)
                    })

            else
				console.debug("Error : Vehicle not found")
			end
        end
    end)
end)