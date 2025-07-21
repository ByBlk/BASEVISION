RegisterNetEvent("core:server:setTattoo", function(tattoo, price)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    if xPlayer.getMoney() < tonumber(price) then
        --@todo: notif
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price)
        TriggerClientEvent("core:client:setTattoo", source, xPlayer.tattoos)
        return
    end

    TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~"..price)
    table.insert(xPlayer.tattoos, tattoo)
    xPlayer.removeMoney(tonumber(price))
end)

RegisterNetEvent("core:server:removeTattoo", function(collection, hash)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    if xPlayer.getMoney() < 200 then
        --@todo: notif
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~200$")
        TriggerClientEvent("core:client:setTattoo", source, xPlayer.tattoos)
        return
    end

    for i, tattoo in ipairs(xPlayer.tattoos) do
        if tattoo.Collection == collection and tattoo.Hash == hash then
            table.remove(xPlayer.tattoos, i)
            break
        end
    end

    TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~200$")
    TriggerClientEvent("core:client:setTattoo", source, xPlayer.tattoos)
    xPlayer.removeMoney(200)
end)

RegisterServerCallback("core:server:getTattoo", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    return xPlayer.tattoos
end)
