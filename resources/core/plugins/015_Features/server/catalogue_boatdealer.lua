RegisterNetEvent("vfw:boatdealer:buy", function(data, prop, coords, manufacture)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = 0
    local label = ""
    local vehicle = VFW.CreateVehicle("player:"..xPlayer.id, data, prop)
    for _, vehicles in pairs(VFW.Boatdealer.Vehicle) do
        if type(vehicles) == "table" then
            for _, vehicle in ipairs(vehicles) do
                console.debug(vehicle.model)
                if data == vehicle.model then
                    price = vehicle.price
                    label = vehicle.model
                    break
                end
            end
        end
    end
    console.debug(price, label)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        vehicle.spawnVehicle(vector4(coords.x, coords.y, coords.z + 1.5, coords.w))
        vehicle.addKey(xPlayer, manufacture)
        TriggerClientEvent("vfw:boatdealer:hasBuying", source)
        Wait(75)
        TaskWarpPedIntoVehicle(GetPlayerPed(xPlayer.source), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
        xPlayer.showNotification({
            type = 'VERT',
            content = "Vous avez acheté un " .. label .. " pour " .. price .. "$"
        })
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price.."$")
    end
end)