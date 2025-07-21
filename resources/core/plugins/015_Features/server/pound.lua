RegisterServerCallback("vfw:getPound", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        console.debug("Player not found")
        return false
    end

    local fourriere = {
        Crew = {},
        Personnel = {},
        Business = {}
    }
    for k, v in pairs(xPlayer.getInventory()) do
        if v.name == "keys" then
            local plate = v.meta.plate
            local vehicle = VFW.GetVehicleByPlate(plate)
            if vehicle then
                if (vehicle.state == 0) and (not vehicle.exist()) then
                    if string.find(vehicle.owner, "job:") then
                        table.insert(fourriere.Business, {
                            id = plate,
                            model = vehicle.model,
                            prop = vehicle.prop
                        })
                    elseif string.find(vehicle.owner, "crew:") then
                        table.insert(fourriere.Crew, {
                            id = plate,
                            model = vehicle.model,
                            prop = vehicle.prop
                        })
                    else
                        table.insert(fourriere.Personnel, {
                            id = plate,
                            model = vehicle.model,
                            prop = vehicle.prop
                        })
                    end
                end
            end
        end
    end

    return fourriere
end)

RegisterServerCallback("vfw:pound:get", function(src, plate)
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        console.debug(("Vehicle %s not found"):format(plate))
        return
    end
    return vehicle.model, vehicle.prop
end)

RegisterNetEvent("vfw:pound:use", function(posData, plate, manufacture)
    local src = source
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        console.debug(("Vehicle %s not found"):format(plate))
        return
    end
    if not VFW.PlayerHaveKey(src, plate, manufacture) then
        console.debug(("Player %s don't have key for vehicle %s"):format(src, plate))
        return
    end
    if (vehicle.state ~= 0) or (vehicle.vehicle) then
        console.debug(("Vehicle %s is not in pound"):format(plate))
        return
    end

    local pos = VFW.GetEmptyPos(posData, 1.5)
    if not pos then
        console.debug(("No empty position found for vehicle %s"):format(plate))
        return
    end

    local xPlayer = VFW.GetPlayerFromId(src)

    if xPlayer.getMoney() < 200 then
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous n'avez pas assez d'argent"
        })
        return
    end

    TriggerClientEvent("vfw:showNotification", src, {
        type = 'VERT',
        content = "Vous avez payé ~s 200$"
    })
    xPlayer.removeMoney(200)

    vehicle.changeState(0)
    vehicle.spawnVehicle(pos)
    Wait(75)
    TaskWarpPedIntoVehicle(GetPlayerPed(src), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
end)