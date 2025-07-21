local pickupList = {}

function VFW.CreatePickup(bucket, pos, drop)
    local entity = CreateObject((drop and GetHashKey(drop) or 'v_serv_abox_02'), pos.x, pos.y, (pos.z-0.98), true, true, false)
    while not DoesEntityExist(entity) do
        Wait(50)
    end
    SetEntityRoutingBucket(entity, bucket)
    pickupList[#pickupList+1] = { bucket = bucket, entity = NetworkGetNetworkIdFromEntity(entity), chest = VFW.CreateChestClass({}, 0, 1000, "Sol")}
    TriggerClientEvent("vfw:pickup:register", -1, pickupList[#pickupList].entity, #pickupList)
    return pickupList[#pickupList]
end

function VFW.GetPickup(id)
    return pickupList[id]
end

function VFW.GetPickupFromPos(bucket, pos)
    for i = 1, #pickupList do
        if bucket == pickupList[i].bucket and #(pos - GetEntityCoords(NetworkGetEntityFromNetworkId(pickupList[i].entity))) < 3.0 then
            return pickupList[i]
        end
    end
    return false
end

function VFW.DropItem(bucket, pos, item)
    local pickup = VFW.GetPickupFromPos(bucket, pos)
    if not pickup then
        pickup = VFW.CreatePickup(bucket, pos, VFW.Items[item.name].data.prop)
    else
        local oldId = pickup.entity
        local oldEntity = NetworkGetEntityFromNetworkId(pickup.entity)
        if GetEntityModel(oldEntity) ~= 'v_serv_abox_02' then
            local pos = GetEntityCoords(oldEntity)
            local heading = GetEntityHeading(oldEntity)
            DeleteEntity(oldEntity)
            local entity = CreateObject('v_serv_abox_02', pos.x, pos.y, pos.z, true, true, false)
            while not DoesEntityExist(entity) do
                Wait(50)
            end
            SetEntityHeading(entity, heading)

            pickup.entity = NetworkGetNetworkIdFromEntity(entity)
            TriggerClientEvent("vfw:pickup:changeProps", -1, pickup.entity, oldId)
        end
    end
    
    pickup.chest.addItem(item.name, item.count, item.meta)
end


local function DropItem(xPlayer, typeItem, position, count)
    for i = 1, #xPlayer.inventory do
        if VFW.Items[xPlayer.inventory[i].name].type == typeItem and position.x == xPlayer.inventory[i].position.x and position.y == xPlayer.inventory[i].position.y then
            if count > xPlayer.inventory[i].count then
                count = xPlayer.inventory[i].count
            end

            local item = {
                name = xPlayer.inventory[i].name,
                count = count,
                meta = xPlayer.inventory[i].meta
            }
            xPlayer.inventory[i].count -= count
            xPlayer.weight = xPlayer.weight - (VFW.Items[xPlayer.inventory[i].name].weight * count)
            if xPlayer.inventory[i].count == 0 then
                table.remove(xPlayer.inventory, i)
            end
            
            VFW.DropItem(GetPlayerRoutingBucket(xPlayer.playerId), GetEntityCoords(GetPlayerPed(xPlayer.playerId)), item)
            break
        end
    end
end

RegisterServerCallback("vfw:dropItem", function(source, info)
    local xPlayer = VFW.GetPlayerFromId(source)

    if info.position then
        DropItem(xPlayer, info.type, info.position, info.quantity)
    else
        for k, v in pairs(info) do
            DropItem(xPlayer, v.type, v.position, v.quantity)
        end
    end

    return xPlayer.inventory, xPlayer.weight
end)

RegisterServerCallback("vfw:pickup:get", function(source, pickupId)
    local chest = VFW.GetPickup(pickupId).chest
    chest.addLooking(source)
    return chest.inventory, chest.weight, chest.maxWeight, chest.name
end)

RegisterNetEvent("vfw:pickup:close", function(pickupId)
    local pickup = VFW.GetPickup(pickupId)
    if not pickup then return end
    pickup.chest.removeLooking(source)
end)

RegisterNetEvent("vfw:pickup:moveItem", function(pickupId, positionsStart, positionsEnd)
    local chest = VFW.GetPickup(pickupId).chest
    chest.moveItem(positionsStart, positionsEnd)
    chest.update()
end)

RegisterServerCallback("vfw:pickup:put-item", function(source, pickupId, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    local chest = VFW.GetPickup(pickupId).chest
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

RegisterServerCallback("vfw:pickup:take-item", function(source, pickupId, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    local pickup = VFW.GetPickup(pickupId)
    local chest = pickup.chest
    if info.position then
        chest.takeItem(xPlayer, info.position, info.quantity)
    else
        for k, v in pairs(info) do
            chest.takeItem(xPlayer, v.position, v.quantity)
        end
    end
    if #chest.inventory == 0 then
        DeleteEntity(NetworkGetEntityFromNetworkId(pickup.entity))
        pickupList[pickupId] = nil
        TriggerClientEvent("vfw:pickup:unregister", -1, pickupId)
    else
        chest.update()
    end
    return xPlayer.inventory, xPlayer.weight
end)