RegisterServerCallback("vfw:vehicleGaragePublic", function(source, plate, propriperites)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal then
        return false
    end
    
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        xPlayer.showNotification({
            type = 'ILLEGAL',
            name = "GARAGE",
            label = "REFUSÉ",
            labelColor = "#5A0606",
            mainColor = 'rouge',
            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
            mainMessage = "Vous n'êtes pas le propriétaire du véhicule.",
            duration = 10,
        })
        return false
    end
    
    local haveKey = false
    local count = 0
    for k, v in pairs(xPlayer.getInventory()) do
        if v.name == "keys" then
            local vehicle = VFW.GetVehicleByPlate(v.meta.plate)
            if plate == v.meta.plate then
                haveKey = true
            end
            if vehicle and vehicle.state == -1 then
                count = count + 1
            end
        end
    end

    if not haveKey then
        xPlayer.showNotification({
            type = 'ILLEGAL',
            name = "GARAGE",
            label = "REFUSÉ",
            labelColor = "#5A0606",
            mainColor = 'rouge',
            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
            mainMessage = "Vous n'êtes pas le propriétaire du véhicule.",
            duration = 10,
        })
        return false
    end

    if (count >= 3) or (count >= 2 and not playerGlobal.permissions["premiumplus"]) or (count >= 1 and not playerGlobal.permissions["premium"]) then
        xPlayer.showNotification({
            type = 'ILLEGAL',
            name = "GARAGE",
            label = "COMPLET",
            labelColor = "#5A0606",
            mainColor = 'rouge',
            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
            mainMessage = "Vous avez atteint la limite de véhicule dans le garage public.",
            duration = 10,
        })
        return false
    end

    vehicle.changeProp(propriperites)
    vehicle.dispawnVehicle()
    vehicle.changeState(-1)
    return true
end)

RegisterServerCallback("vfw:getGaragePublic", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        console.debug("Player not found")
        return false
    end

    local fourriere = {}
    local vehicleList = {}
    for k, v in pairs(xPlayer.getInventory()) do
        if v.name == "keys" then
            local plate = v.meta.plate
            local vehicle = VFW.GetVehicleByPlate(plate)
            if vehicle then
                if vehicle.state == -1 then
                    table.insert(vehicleList, {
                        id = plate,
                        name = vehicle.model,
                        img = vehicle.model..".webp", --@todo change image for vehicle
                        prop = vehicle.prop
                    })
                elseif (vehicle.state == 0) and (not vehicle.vehicle) then
                    table.insert(fourriere, {
                        id = plate,
                        name = vehicle.model,
                        img = vehicle.model..".webp", --@todo change image for vehicle
                    })
                end
            end
        end
    end
    
    local playerGlobal = VFW.GetPlayerGlobalFromId(xPlayer.source)
    for i = 1, #vehicleList do
        if i > 1 then
            if (i > 3) or ((not playerGlobal.permissions["premiumplus"]) and ((i == 2) and not playerGlobal.permissions["premium"])) then
                local vehicle = VFW.GetVehicleByPlate(vehicleList[i].id)
                vehicle.changeState(0)
                vehicleList[i] = nil
            end
        end
    end

    return vehicleList, fourriere
end)

RegisterServerCallback("vfw:garagePublic:get", function(src, plate)
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        console.debug(("Vehicle %s not found"):format(plate))
        return
    end
    return vehicle.model, vehicle.prop
end)

RegisterNetEvent("vfw:garagePublic:use", function(posData, plate, manufacture)
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
    if vehicle.state ~= -1 then
        console.debug(("Vehicle %s is not in garage public"):format(plate))
        return
    end

    local pos = VFW.GetEmptyPos(posData, 1.5)
    if not pos then
        console.debug(("No empty position found for vehicle %s"):format(plate))
        return
    end

    vehicle.changeState(0)
    vehicle.spawnVehicle(pos)
    Wait(250)
    TaskWarpPedIntoVehicle(GetPlayerPed(src), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
end)