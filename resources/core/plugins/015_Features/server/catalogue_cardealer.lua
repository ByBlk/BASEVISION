RegisterNetEvent("vfw:cardealer:buy", function(data, prop, manufacture)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = 0
    local label = ""
    local vehicle = VFW.CreateVehicle("player:"..xPlayer.id, data, prop)
    for _, vehicles in pairs(BLK.Vehicule) do
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
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        vehicle.spawnVehicle(vector4(-12.434639930725, -1091.7203369141, 26.640502929688, 159.30097961426))
        vehicle.addKey(xPlayer, manufacture)
        TriggerClientEvent("vfw:cardealer:hasBuying", source)
        Wait(75)
        TaskWarpPedIntoVehicle(GetPlayerPed(xPlayer.source), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
        xPlayer.showNotification({
            type = 'VERT',
            content = "Vous avez acheté un " .. label .. " pour " .. price .. "$"
        })


        local owner = VFW.GetIdentifier(source)
        local params = {
            plate = prop.plate,
            model = manufacture,
        }
        
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price.."$")
    end
end)