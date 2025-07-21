local pickups = {}

VFW.ContextAddButton("object", "Ouvrir", function(object)
    return (pickups[NetworkGetNetworkIdFromEntity(object)] ~= nil)
end, function(object)
    local pickupId = pickups[NetworkGetNetworkIdFromEntity(object)]
    local inventory, weight, maxWeight, name = TriggerServerCallback("vfw:pickup:get", pickupId)

    VFW.OpenInventory({
        pickupId = pickupId,
        inventory = inventory,
        name = name,
        maxWeight = maxWeight,
        weight = weight,
        search = false,
    })
end)

RegisterNetEvent("vfw:pickup:load", function(pickups)
    pickups = pickups
end)

RegisterNetEvent("vfw:pickup:register", function(networkId, chestId)
    pickups[networkId] = chestId
end)

RegisterNetEvent("vfw:pickup:changeProps", function(networkId, oldEntity)
    pickups[networkId] = pickups[oldEntity]
    pickups[oldEntity] = nil
end)

RegisterNetEvent("vfw:pickup:unregister", function(networkId)
    pickups[networkId] = nil
    
    if VFW.StateInventory() and VFW.PlayerData.target and VFW.PlayerData.target.pickupId == networkId then
        VFW.PlayerData.target = nil
        VFW.LoadInventory()
    end
end)