RegisterServerCallback("vfw:getProperty", function(src, id)
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then
        console.debug("vfw:getProperty: xPlayer not found")
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end
    
    local name, face = property.getOwnerInfo()
    return {
        boiteWeight = 0, --@todo
        isLocked = not property.canAccess(src),
        name = property.name,
        canPerqui = false, --@todo
        owner = name,
        playerFace = face,
        hideIdentity = property.hide,
        garage = (property.type == "Garage")
    }
end)

RegisterNetEvent("vfw:property:giveAccess", function(targetId, propertyId)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then
        return
    end
    local property = VFW.GetProperty(propertyId)
    if not property then
        return
    end

    if not property.isOwner(src) then
        return
    end

    local target = VFW.GetPlayerFromId(targetId)
    if not target then
        return
    end

    property.addAccess("player:"..target.id)
    property.save()
    target.showNotification({
        type = "JAUNE",
        content = "Vous avez recu le double des cléf"
    })


end)

RegisterNetEvent("vfw:property:bell", function(propertyId)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    local property = VFW.GetProperty(propertyId)
    if not property then
        console.debug(("Property %s not found"):format(propertyId))
        return
    end

    local ownerName,ownerFace,ownerId = property.getOwnerInfo()
    if not ownerId then
        xPlayer.showNotification({
            type = "ROUGE",
            content = "Propriété appartenant a un groupe "
        })
        return
    end

    local targetPropertyOwner = VFW.GetPlayerFromIdentifier(ownerId)
    if not targetPropertyOwner then
        xPlayer.showNotification({
            type = "JAUNE",
            content = "Vous avez sonné"

        })
        return
    end

    TriggerClientEvent("vfw:property:bell", targetPropertyOwner.source, propertyId, src)

end)


RegisterNetEvent("vfw:property:accept", function(askId, propertyId)
    local src = source
    local property = VFW.GetProperty(propertyId)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end

    local data
    if property.type == "Garage" then
        data = {
            type = "Véhicule",
            name = property.name,
            advancedPerm = property.isOwner(src),
            access = true,
            maxPlaces = property.data.maxPlaces,
            garageList = property.data.vehicles
        }
    else
        data = property.data.nameProperty
        property.enterProperty(askId)
    end

    TriggerClientEvent("vfw:property:accept", askId, data)
end)

RegisterNetEvent("vfw:property:reject", function(askId)
    local target = VFW.GetPlayerFromId(askId)
    if not target then
        return
    end

    TriggerClientEvent("vfw:property:reject", askId)

end)

RegisterServerCallback("vfw:property:enter", function(src, id)
    local property = VFW.GetProperty(id)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end
    if not property.canAccess(src) then
        console.debug(("Player %s can't access property %s"):format(src, id))
        return
    end

    local data
    if property.type == "Garage" then
        data = {
            type = "Véhicule",
            name = property.name,
            advancedPerm = property.isOwner(src),
            access = property.state, 
            maxPlaces = property.data.maxPlaces,
            garageList = property.data.vehicles
        }
    else
        data = property.data.nameProperty
        property.enterProperty(src)
    end

    return data
end)

RegisterNetEvent("vfw:property:edit", function(id, data)
    local src = source
    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    if property.isOwner(src) then
        if data.rename then
            property.name = data.rename
            MySQL.update.await('UPDATE property SET name = ? WHERE id = ?', {
                property.name, id
            })
        end
        if data.access then
            property.state = data.access
        end
        --@todo: update other ???
    end
end)

RegisterNetEvent("vfw:property:useVehicle", function(id, plate)
    local src = source
    local property = VFW.GetProperty(id)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end
    if not property.canAccess(src) then
        console.debug(("Player %s can't access property %s"):format(src, id))
        return
    end
    if not property.data.vehicles[plate] then
        console.debug(("Vehicle %s not found in property %s"):format(plate, id))
        return
    end
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        console.debug(("Vehicle %s not found"):format(plate))
        return
    end
    property.removeVehicle(plate)
    local pos = vec4(property.pos.x, property.pos.y, property.pos.z, 0.0)
    vehicle.spawnVehicle(pos)
    Wait(1000)
    TaskWarpPedIntoVehicle(GetPlayerPed(src), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
end)

RegisterServerCallback("vfw:enterVehicle", function(src, id, plate, manufacture)
    local property = VFW.GetProperty(id)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end
    if not property.canAccess(src) then
        console.debug(("Player %s can't access property %s"):format(src, id))
        return
    end
    if not property.data.maxPlaces then
        console.debug(("Property %s is not a garage"):format(id))
        return
    end
    
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        console.debug(("Vehicle %s not found"):format(plate))
        return
    end

    if not VFW.PlayerHaveKey(src, plate, manufacture) then
        console.debug(("Player %s don't have key for vehicle %s"):format(src, plate))
        return
    end

    if not property.canAccess(src) then
        return
    end

    local data = {
        type = "Véhicule",
        name = property.name,
        advancedPerm = property.isOwner(src),
        access = property.state, 
        maxPlaces = property.data.maxPlaces,
        garageList = property.data.vehicles
    }

    vehicle.dispawnVehicle()
    property.addVehicle(plate)
    return true, data
end)

RegisterNetEvent("vfw:leaveProperty", function(id)
    local src = source
    local property = VFW.GetProperty(id)
    if not property then
        console.debug(("Property %s not found"):format(id))
        return
    end

    property.leaveProperty(src)
end)

VFW.GetJobProperty = function(job)
    local properties = {}
    for k, v in pairs(VFW.GetProperties()) do
        if v.owner == ("job:%s"):format(job) then
            properties[#properties + 1] = {address = v.name, type = v.type, id = v.id, maxPlaces = v.data.maxPlaces and v.data.maxPlaces or nil, vehicles = v.data.vehicles or {}}
        end
    end

    return properties
end


function VFW.GetCrewProperty(id)

    local properties = {}
    for k, v in pairs(VFW.GetProperties()) do
        if v.owner == ("crew:%s"):format(id) then
            properties[#properties + 1] = {address = v.name, type = v.type, id = v.id, maxPlaces = v.data.maxPlaces and v.data.maxPlaces or nil, vehicles = v.data.vehicles or {}}
        end
    end

    local crew = VFW.GetCrewByName(id)
    if not crew then
        return
    end

    local labo = GetLabo(crew.laboratoryId)
    if labo then
        table.insert(properties, {
            id = labo.id,
            type = "Laboratoire",
            address = "Laboratoire de " .. labo.laboType,
        })
    end

    return properties
end

RegisterServerCallback("vfw:property:get", function(src, property)
    local property = VFW.GetProperty(property)
    if not property then
        return
    end

    if not property.isOwner(src) then
        return
    end
    
    return {
        name = property.name,
        access = property.state,
        coOwnerList = property.getAccessInfo(),
        nameProperty = property.data.nameProperty,
        rental = math.floor((property.rental - os.time())/86400),
    }
end)

RegisterNetEvent("vfw:property:save", function(property, data)
    local src = source
    local property = VFW.GetProperty(property)
    if not property then
        return
    end

    if not property.isOwner(src) then
        return
    end

    for k, v in pairs(data.deletedOwner) do
        property.removeAccess(v)
    end

    property.state = data.access
    property.name = data.name

    property.save()
end)