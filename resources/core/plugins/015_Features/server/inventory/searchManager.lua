RegisterServerCallback("vfw:search:get", function(source, targetId)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local targetPlayer = VFW.GetPlayerFromId(targetId)
    if not targetPlayer then return end
    local inventory = targetPlayer.getInventory()
    if not inventory then return end

    targetPlayer.addSearch(source)

    return inventory
end)

local function TakeItem(player, target, position, quantity, typeItem)
    local targetInventory = target.getInventory()
    
    for i = 1, #targetInventory do
        local item = targetInventory[i]

        if position.x == item.position.x and position.y == item.position.y and typeItem == VFW.Items[item.name].type then
            local count = quantity

            if (not quantity) or (quantity and (item.count < quantity)) then
                count = item.count
            end

            if VFW.Items[item.name].type == "weapons" then
                local ped = GetPlayerPed(target.source)
                local hash = GetHashKey(item.name)
                local weapon = GetCurrentPedWeapon(ped)

                if weapon == hash then
                    RemoveWeaponFromPed(ped, hash)
                    SetPedAmmo(ped, hash, 0)

                    target.triggerEvent("vfw:weaponChange")
                end
            end
            player.addItem(item.name, count, item.meta)
            target.removeItem(item.name, count, item.meta or {})

            return
        end
    end
end

RegisterServerCallback("vfw:search:take-item", function(source, targetId, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    if not job then return end
    if not job.onDuty then return end
    if job.type ~= "faction" then return end
    local targetPlayer = VFW.GetPlayerFromId(targetId)
    if not targetPlayer then return end

    if info.position then
        TakeItem(xPlayer, targetPlayer, info.position, info.quantity, info.type)
    else
        for k, v in pairs(info) do
            TakeItem(xPlayer, targetPlayer, v.position, v.quantity, info.type)
        end
    end

    targetPlayer.updateInventory()
    TriggerClientEvent("vfw:search:update", source, targetPlayer.getInventory(), targetPlayer.getWeight())

    return xPlayer.inventory, xPlayer.weight
end)

RegisterNetEvent("vfw:search:close", function(targetId)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local targetPlayer = VFW.GetPlayerFromId(targetId)
    if not targetPlayer then return end

    targetPlayer.removeSearch(source)
end)
