local locations = {}

local function endRental(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerId = xPlayer.identifier

    if not locations[playerId] then
        xPlayer.showNotification({ type = 'ROUGE', content = "Vous avez pas de voiture en location !" })
        return
    end

    local vehicle = locations[playerId].vehicle

    if vehicle and DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        VFW.RemoveKeyTemporaly(source, "auther", plate)
        DeleteEntity(vehicle)
    end

    xPlayer.showNotification({
        type = 'ILLEGAL',
        name = "LOCATION",
        label = "00H00",
        labelColor = "#350000",
        mainColor = 'rouge',
        logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
        mainMessage = "La période de location du véhicule est terminée.",
        duration = 10,
    })

    locations[playerId] = nil
end

local function startRental(source, vehicle)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerId = xPlayer.identifier
    local currentTime = os.time()

    if locations[playerId] then
        xPlayer.showNotification({ type = 'ROUGE', content = "Vous avez une location en cours." })
        return
    end

    locations[playerId] = {
        vehicle = vehicle,
        startTime = currentTime,
        expireTime = currentTime + 3600
    }

    xPlayer.showNotification({
        type = 'ILLEGAL',
        name = "LOCATION",
        label = "01H00",
        labelColor = "#00210A",
        mainColor = 'green',
        logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
        mainMessage = "Vous avez récupérer votre véhicule de location.",
        duration = 10,
    })

    Citizen.SetTimeout((3600 - 600) * 1000, function()
        if locations[playerId] and os.time() >= (locations[playerId].expireTime - 600) then
            xPlayer.showNotification({
                type = 'WARNING',
                name = "LOCATION",
                label = "00H10",
                labelColor = "#FBBD04",
                mainColor = 'yellow',
                logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
                mainMessage =  "Il vous reste 10 min de location sur votre véhicule.",
                duration = 10,
            })
        end
    end)

    Citizen.SetTimeout(3600 * 1000, function()
        if locations[playerId] and os.time() >= locations[playerId].expireTime then
            endRental(source)
        end
    end)
end

RegisterNetEvent("core:server:setLocation")
AddEventHandler("core:server:setLocation", function(model, category, coords, heading)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.getMoney() < BLK.Shop.Location.Vehicule[category][model].price then
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~" .. BLK.Shop.Location.Vehicule[category][model].price .. " $")
        return
    end

    local networkId = VFW.OneSync.SpawnVehicle(model, coords, heading, {})

    SetPedIntoVehicle(GetPlayerPed(source), NetworkGetEntityFromNetworkId(networkId), -1)
    local plate = GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(networkId))
    VFW.GiveKeyTemporaly(source, "auther", plate)
    startRental(source, networkId)
    xPlayer.removeMoney(BLK.Shop.Location.Vehicule[category][model].price)
end)

AddEventHandler("vfw:playerDropped", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerId = xPlayer.identifier

    if locations[playerId] then
        local timeLeft = locations[playerId].expireTime - os.time()

        locations[playerId].timeLeft = timeLeft

        Citizen.SetTimeout(locations[playerId].timeLeft * 1000, function()
            if locations[playerId] and os.time() >= locations[playerId].expireTime then
                endRental(source)
            end
        end)
    end
end)

RegisterNetEvent("core:server:loadedLocation")
AddEventHandler("core:server:loadedLocation", function()
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerId = xPlayer.identifier

    if locations[playerId] and locations[playerId].timeLeft then
        local remainingTime = locations[playerId].timeLeft

        locations[playerId].expireTime = os.time() + remainingTime
        locations[playerId].timeLeft = nil

        xPlayer.showNotification({
            type = 'ILLEGAL',
            name = "LOCATION",
            label = "00H"..math.floor(remainingTime / 60),
            labelColor = "#00210A",
            mainColor = 'green',
            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
            mainMessage = "Vous avez récupérer votre véhicule de location.",
            duration = 10,
        })

        Citizen.SetTimeout((remainingTime - 600) * 1000, function()
            if locations[playerId] and os.time() >= (locations[playerId].expireTime - 600) then
                xPlayer.showNotification({
                    type = 'WARNING',
                    name = "LOCATION",
                    label = "00H10",
                    labelColor = "#FBBD04",
                    mainColor = 'yellow',
                    logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
                    mainMessage =  "Il vous reste 10 min de location sur votre véhicule.",
                    duration = 10,
                })
            end
        end)

        Citizen.SetTimeout(remainingTime * 1000, function()
            if locations[playerId] and os.time() >= locations[playerId].expireTime then
                endRental(source)
            end
        end)
    end
end)

RegisterServerCallback("core:server:getLocation", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerId = xPlayer.identifier

    if locations[playerId] then
        return false
    end

    return true
end)
