local chests = {}

function VFW.CreateChest(chestId, maxWeight, name)
    MySQL.Sync.insert("INSERT INTO chest (id, inventory, weight, maxWeight, name) VALUES (@id, @inventory, @weight, @maxWeight, @name)", { ["@id"] = chestId, ["@inventory"] = json.encode({}), ["@weight"] = 0, ["@maxWeight"] = maxWeight, ["@name"] = name })
    chests[chestId] = VFW.CreateChestClass({}, 0, maxWeight, name)
end

function VFW.LoadChest(chestId)
    local result = MySQL.single.await("SELECT inventory, weight, maxWeight, name FROM chest WHERE id = @id", { ["@id"] = chestId })

    if not result then
        return
    end

    chests[chestId] = VFW.CreateChestClass(json.decode(result.inventory), result.weight, result.maxWeight, result.name)
end

function VFW.TempChest(chestId, maxWeight, name)
    if chests[chestId] then
        return
    end
    chests[chestId] = VFW.CreateChestClass({}, 0, maxWeight, name)
    return chests[chestId]
end

function VFW.CreateOrGetChest(chestId, maxWeight, name)
    VFW.LoadChest(chestId)
    if chests[chestId] then
        return chests[chestId]
    end
    local result = MySQL.single.await("SELECT inventory, weight, maxWeight, name FROM chest WHERE id = @id", { ["@id"] = chestId })

    if not result then
        MySQL.Sync.insert("INSERT INTO chest (id, inventory, weight, maxWeight, name) VALUES (@id, @inventory, @weight, @maxWeight, @name)", { ["@id"] = chestId, ["@inventory"] = json.encode({}), ["@weight"] = 0, ["@maxWeight"] = maxWeight, ["@name"] = name })
        chests[chestId] = VFW.CreateChestClass({}, 0, maxWeight, name)
    else

    end

    return chests[chestId]
end

function VFW.GetChest(chestId)
    if not chests[chestId] then
        VFW.LoadChest(chestId)
    end
    return chests[chestId]
end

RegisterNetEvent("vfw:chest:close", function(chestId)
    if not chestId or not chests[chestId] then
        return
    end
    chests[chestId].removeLooking(source)
end)