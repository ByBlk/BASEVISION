RegisterNetEvent('core:server:gestionstock:Outfit', function(meta)
    local xPlayer = VFW.GetPlayerFromId(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)

    if not playerGlobal.permissions["gestionstock"] then
        return
    end

    xPlayer.addItem("outfit", 1, meta)
    xPlayer.updateInventory()
end)

RegisterNetEvent('core:server:gestionstock:Clothe', function(name, meta)
    local xPlayer = VFW.GetPlayerFromId(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)

    if not playerGlobal.permissions["gestionstock"] then
        return
    end

    xPlayer.addItem(name, 1, meta)
    xPlayer.updateInventory()
end)
