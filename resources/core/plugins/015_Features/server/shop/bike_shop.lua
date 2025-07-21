RegisterNetEvent("vfw:bike:buy", function(model)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = 0
    local label = ""
    console.debug(source, model)

    for k,v in pairs(VFW.skateShop.Items) do
        if model == v.model then
            price = v.price
            label = v.label
            break
        end
    end

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.createItem(model, 1)
        xPlayer.updateInventory()
        TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~"..price.."$")
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price.."$")
    end
end)

RegisterNetEvent("core:server:pickupBike", function(typeBmx)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then 
        return 
    end

    xPlayer.addItem(typeBmx, 1, {})
    xPlayer.updateInventory()
end)

VFW.RegisterUsableItem("bmx", function(xPlayer)

    xPlayer.removeItem("bmx", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "bmx")
end)

VFW.RegisterUsableItem("fixter", function(xPlayer)

    xPlayer.removeItem("fixter", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "fixter")
end)

VFW.RegisterUsableItem("scorcher", function(xPlayer)

    xPlayer.removeItem("scorcher", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "scorcher")
end)

VFW.RegisterUsableItem("tribike", function(xPlayer)

    xPlayer.removeItem("tribike", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "tribike")
end)

VFW.RegisterUsableItem("tribike2", function(xPlayer)

    xPlayer.removeItem("tribike2", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "tribike2")
end)


VFW.RegisterUsableItem("tribike3", function(xPlayer)

    xPlayer.removeItem("tribike3", 1, {})

    TriggerClientEvent("core:client:UseBike", xPlayer.source, "tribike3")
end)

