RegisterNetEvent('core:server:buyOutfit', function(meta)
    local xPlayer = VFW.GetPlayerFromId(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    local price = tonumber(VFW.Math.GroupDigits(Config.ClothesPrice[xPlayer.skin.sex == 0 and "Homme" or "Femme"]["Creé une tenue"]))

    if not playerGlobal.permissions["premium"] then
        console.debug("Try to buy outfit without premium")
        return
    end

    if xPlayer.getMoney() < price then
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~" .. price .. " $")
        TriggerClientEvent("core:client:resetSkin", source, xPlayer.skin)
        return
    end

    TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~" .. price .. " $")
    xPlayer.addItem("outfit", 1, meta)
    xPlayer.removeMoney(price)
end)

local safeItem = {
    ["hat"] = true,
    ["top"] = true,
    ["accessory"] = true,
    ["bottom"] = true,
    ["shoe"] = true,
}

RegisterNetEvent('core:server:buyClothe', function(name, meta)
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = tonumber(Config.ClothesPrice[xPlayer.skin.sex == 0 and "Homme" or "Femme"][meta.type or name])

    if not safeItem[name] then
        console.debug("Try to give not safe item")
        return
    end

    if xPlayer.getMoney() < price then
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~" .. price .. " $")
        TriggerClientEvent("core:client:resetSkin", source, xPlayer.skin)
        return
    end

    TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~" .. price .. " $")
    xPlayer.addItem(name, 1, meta)
    xPlayer.removeMoney(price)
end)

RegisterServerCallback("core:server:getClothesMoney", function(source, type)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.getMoney() >= 20 then
        xPlayer.removeMoney(20)
        TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~" .. "20" .. " $")
        return true
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~" .. "20" .. " $")
    end

    return false
end)
