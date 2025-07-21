local typeList = {
    ["Habitations"] = 1,
    ["Garage"] = 2,
    ["Entrepot"] = 3
}

local function GetPropertyByName(name)
    for k, v in pairs(Property) do
        for i = 1, #v.data do
            if v.data[i].name == name then
                return v.data[i] 
            end
        end
    end
    return false
end

RegisterNetEvent("vfw:job:dynasty:createProperty", function(data)
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end
    
    local property = GetPropertyByName(data.items)
    if not property then
        return
    end

    local info = {}
    if data.type == "Garage" then
        info = {
            maxPlaces = property.maxPlaces,
            vehicles = {}
        }
    else
        info = {
            nameProperty = property.name
        }
    end

    local name = ((data.name == "") and property.name or data.name)
    local propertyClass = VFW.CreateProperty(typeList[data.type], "", name, {}, data.pos, info, os.time()+(data.duration * 86400))

    if data.type ~= "Garage" then
        local maxWeight = tonumber(data.weight) and tonumber(data.weight) or 0
        VFW.CreateChest("property:"..propertyClass.id, maxWeight, "Coffre de la propriété")
    end
end)

RegisterServerCallback("vfw:job:dynasty:getProperty", function(src, id)
    local xPlayer = VFW.GetPlayerFromId(src)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    return {
        name = property.name,
        state = property.state,
        owner = property.owner
    }
end)

RegisterServerCallback("vfw:job:dynasty:propertyUpdate", function(src, id, data)
    local xPlayer = VFW.GetPlayerFromId(src)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    property.state = data.access

    if data.duration > 0 then
        if property.rental < os.time() then
            property.rental = os.time()+(data.duration * 86400)
        else
            property.rental = property.rental+(data.duration * 86400)
        end
        xPlayer.showNotification({
            type = 'SUCCESS',
            content = "La location de la propriété a été prolongée. Elle se terminera le "..os.date("%d/%m/%Y", property.rental)
        })
        MySQL.update.await('UPDATE property SET rental = ? WHERE id = ?', {
            property.rental, property.id
        })
    end

    if property.name ~= data.name then
        property.name = data.name
        MySQL.update.await('UPDATE property SET name = ? WHERE id = ?', {
            data.name, property.id
        })
    end

    if not string.find(property.owner, data.ownerType) then
        if string.find(property.owner, "player:") then
            local id = string.gsub(property.owner, "player:", "")
            local result = MySQL.single.await('SELECT job, faction FROM users WHERE id = ?', {
                id
            })
            property.owner = data.ownerType..":"..(data.ownerType == "job" and result.job or result.faction)
            property.ownerName = nil
            MySQL.update.await('UPDATE property SET owner = ? WHERE id = ?', {
                property.owner, property.id
            })
        else
            xPlayer.showNotification({
                type = 'ROUGE',
                content = "Pour changer le type de propriété vous devez d'abord la donner a un joueur."
            })
        end
    end
end)

RegisterNetEvent("vfw:job:dynasty:deleteProperty", function(id)
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    VFW.DeleteProperty(id)
end)

RegisterNetEvent("vfw:job:dynasty:transfert", function(id, target)
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        console.debug("Player not found "..target)
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    if property.owner == "player:"..xTarget.id then
        return
    end

    property.owner = "player:"..xTarget.id
    property.ownerName = nil
    console.debug("Transfering property "..property.id.." to "..property.owner)
    MySQL.update.await('UPDATE property SET owner = ? WHERE id = ?', {
        property.owner, property.id
    })
end)

RegisterNetEvent("vfw:job:dynasty:giveKey", function(id, target)
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end
    
    for k, v in pairs(property.accessList) do
        if v == "player:"..xTarget.id then
            return
        end
    end

    table.insert(property.accessList, "player:"..xTarget.id)
    MySQL.update.await('UPDATE property SET access = ? WHERE id = ?', {
        json.encode(property.accessList), property.id
    })
end)

RegisterServerCallback("vfw:job:dynasty:coowner", function(src, id)
    local xPlayer = VFW.GetPlayerFromId(src)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    return {
        coOwnerList = property.getAccessInfo(),
        coOwner = property.owner
    }
end)

RegisterNetEvent("vfw:job:dynasty:save", function(id, coOwner)
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "dynasty" then
        console.debug("Player is not a real estate agent")
        return
    end

    local property = VFW.GetProperty(id)
    if not property then
        return
    end

    property.removeAccess(coOwner)
    MySQL.update.await('UPDATE property SET access = ? WHERE id = ?', {
        json.encode(property.accessList), property.id
    })
end)