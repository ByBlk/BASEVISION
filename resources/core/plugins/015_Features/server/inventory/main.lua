RegisterServerCallback("vfw:moveItem", function(source, positionsStart, positionsEnd, itemType)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.moveItem(positionsStart, positionsEnd, itemType)
    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:useItem", function(source, itemName, metaData)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.useItem(itemName, metaData)
    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:giveItem", function(source, target, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    local targetPlayer = VFW.GetPlayerFromId(target)
    if not targetPlayer then
        return
    end

    if info.position then
        xPlayer.giveItem(targetPlayer, info.position, info.type, info.quantity)
    else
        for k, v in pairs(info) do
            xPlayer.giveItem(targetPlayer, v.position, v.type, v.quantity)
        end
    end

    targetPlayer.updateInventory()
    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:giveMoney", function(source, target, count)
    local xPlayer = VFW.GetPlayerFromId(source)
    local targetPlayer = VFW.GetPlayerFromId(target)
    if not targetPlayer then
        return
    end

    if xPlayer.getMoney() >= count then
        xPlayer.removeMoney(count)
        targetPlayer.addMoney(count)
    end
end)

RegisterServerCallback("vfw:splitItem", function(source, position, typeItem, count)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.splitItem(position, typeItem, count)
    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:renameItem", function(source, position, typeItem, name)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.renameItem(position, typeItem, name)
    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:chest:get", function(source, chestId)
    local chest = VFW.GetChest(chestId)
    chest.addLooking(source)
    return chest.inventory, chest.weight, chest.maxWeight, chest.name
end)

RegisterNetEvent("vfw:chest:moveItem", function(chestId, positionsStart, positionsEnd)
    local chest = VFW.GetChest(chestId)
    chest.moveItem(positionsStart, positionsEnd)
    chest.update()
end)

RegisterServerCallback("vfw:chest:put-item", function(source, chestId, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    local chest = VFW.GetChest(chestId)
    if info.position then
        chest.putItem(xPlayer, info.position, info.type, info.quantity)
    else
        for k, v in pairs(info) do
            chest.putItem(xPlayer, v.position, v.type, v.quantity)
        end
    end
    chest.update()
    return xPlayer.inventory, xPlayer.weight
end)

RegisterNetEvent("vfw:requestInventoryGive", function(targetID)
    local xPlayer = VFW.GetPlayerFromId(source)
    local targetPlayer = VFW.GetPlayerFromId(targetID)
    if not targetPlayer then
        return
    end

    console.debug("Inventory target", json.encode(targetPlayer.inventory))
    TriggerClientEvent("vfw:inventoryGive", xPlayer.source, targetPlayer)
end)

RegisterServerCallback("vfw:chest:take-item", function(source, chestId, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    local chest = VFW.GetChest(chestId)
    if info.position then
        chest.takeItem(xPlayer, info.position, info.quantity)
    else
        for k, v in pairs(info) do
            chest.takeItem(xPlayer, v.position, v.quantity)
        end
    end
    chest.update()
    return xPlayer.inventory, xPlayer.weight
end)

local lastWeapon = GetResourceKvpInt("vfw:weaponId")
if not lastWeapon then
    lastWeapon = 0
end
function VFW.WeaponID()
    lastWeapon = lastWeapon + 1
    SetResourceKvpInt("vfw:weaponId", lastWeapon)
    return "VFW-"  .. string.format("%06d", lastWeapon)
end