local vehicle = {}

MySQL.ready(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

    for _, v in pairs(result) do
        --vehicle[v.plate] = {
        --    owner = v.owner,
        --    plate = v.plate,
        --    model = v.vehicle,
        --    prop = json.decode(v.prop),
        --    state = v.state,
        --}

        VFW.LoadVehicle(v.plate, v.owner, v.vehicle, json.decode(v.prop), v.state)
    end
end)

function VFW.LoadVehicle(plate, owner, model, prop, state)
    vehicle[plate] = VFW.CreateVehicleClass(plate, owner, model, prop, state)
    return vehicle[plate]
end 

function VFW.CreateVehicle(owner, model, prop)
    local plate = VFW.CreatePlate()

    MySQL.insert.await('INSERT INTO `vehicles` (plate, owner, vehicle, prop, state) VALUES (?, ?, ?, ?, 0)', {
        plate, owner, model, json.encode(prop or {})
    })
    local weight = 10
    for k, v in pairs(BLK.Vehicule) do
        for i = 1, #v do
            if v[i].name == model then
                weight = v[i].weight
                break
            end
        end
    end
    VFW.CreateChest(("veh:%s"):format(plate), weight, "Coffre du véhicule")

    return VFW.LoadVehicle(plate, owner, model, prop or {}, 0)
end

function VFW.GetVehicleByPlate(plate)
    if not vehicle[plate] then
        local result = MySQL.single.await('SELECT * FROM vehicles WHERE plate = ?', { plate })
        if result then
            return VFW.LoadVehicle(plate, result.owner, result.vehicle, json.decode(result.prop), result.state)
        end
    end

    return vehicle[plate]
end

function VFW.GetCrewVehicles(crew)

    local crewFind = VFW.GetCrewByName(crew)
    if crewFind and crewFind.vehicles then
        return crewFind.vehicles
    end
    local vehs = {}
    for k, v in pairs(vehicle) do
        if v.owner == ("crew:%s"):format(crew) then
            vehs[#vehs + 1] = {
                plate = v.plate,
                vehName = v.model,
                pounded = v.state
            }
        end
    end

    if crewFind then crewFind.vehicles = vehs end
    return vehs
end

function VFW.GetVehiclesByOwner(owner)
    local vehs = {}
    for k, v in pairs(vehicle) do
        if v.owner == ("player:%s"):format(owner) then
            vehs[#vehs + 1] = {
                plate = v.plate,
                vehName = v.model,
                pounded = v.state
            }
        end
    end

    if crewFind then crewFind.vehicles = vehs end
    return vehs
end

function VFW.GetVehiclesByJob(job)
    local vehs = {}
    for k, v in pairs(vehicle) do
        if v.owner == ("job:%s"):format(job) then
            vehs[#vehs + 1] = {
                plate = v.plate,
                vehName = v.model,
                pounded = v.state
            }
        end
    end

    return vehs
end

VFW.RegisterUsableItem("keys", function(xPlayer, deleteCallback, metaData)
    local vehicle = VFW.GetVehicleByPlate(metaData.plate)
    if (not vehicle) or (not vehicle.vehicle) then
        return
    end

    local entity = NetworkGetEntityFromNetworkId(vehicle.vehicle)
    local dist = #(GetEntityCoords(entity) - GetEntityCoords(GetPlayerPed(xPlayer.source)))

    if dist < 10.0 then
        vehicle.changeLock(not vehicle.locked)
        xPlayer.triggerEvent("vfw:vehicle:anim", vehicle.vehicle)
    else
        --@todo: notify player
    end
end)

RegisterServerCallback("vfw:getVehicleInfo", function(_, plate)
    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        return nil
    end

    return vehicle.prop, vehicle.model
end)

function VFW.PlayerHaveKey(src, plate, manufacture)
    local xPlayer = VFW.GetPlayerFromId(src)
    
    if xPlayer.haveItem("keys", {
        plate = plate,
        manufacture = manufacture
    }) then
        return true
    end
    return false
end

local function GetNearbyVehicles(coords, radius)
    local vehicles = {}
    local allVehicles = GetAllVehicles()

    for _, vehicle in ipairs(allVehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(vehicleCoords - coords)

        if distance <= radius then
            table.insert(vehicles, {vehicle = vehicle, distance = distance})
        end
    end

    table.sort(vehicles, function(a, b) return a.distance < b.distance end)

    local sortedVehicles = {}
    for _, v in ipairs(vehicles) do
        table.insert(sortedVehicles, v.vehicle)
    end

    return sortedVehicles
end

local keyTemporarly = {}

RegisterNetEvent("vfw:vehicle:keyTemporarly:add", function(type, plate)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    if type == "auther" then
        if not keyTemporarly[source] then
            keyTemporarly[source] = {}
        end
        keyTemporarly[source][plate] = true
    elseif type == "job" then
        if not keyTemporarly[xPlayer.getJob().name] then
            keyTemporarly[xPlayer.getJob().name] = {}
        end
        keyTemporarly[xPlayer.getJob().name][plate] = true
    elseif type == "crew" then
        if keyTemporarly[xPlayer.getFaction().name] then
            keyTemporarly[xPlayer.getFaction().name] = {}
        end
        keyTemporarly[xPlayer.getFaction().name][plate] = true
    end
end)

RegisterNetEvent("vfw:vehicle:keyTemporarly:remove", function(type, plate)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    if type == nil then
        for k, v in pairs(keyTemporarly) do
            if v[plate] then
                v[plate] = nil
                if next(v) == nil then
                    keyTemporarly[k] = nil
                    break
                end
            end
        end
    elseif type == "auther" then
        if keyTemporarly[source] then
            keyTemporarly[source][plate] = nil
            keyTemporarly[source] = nil
        end
    elseif type == "job" then
        if keyTemporarly[xPlayer.getJob().name] then
            keyTemporarly[xPlayer.getJob().name][plate] = nil
            keyTemporarly[xPlayer.getJob().name] = nil
        end
    elseif type == "crew" then
        if keyTemporarly[xPlayer.getFaction().name] then
            keyTemporarly[xPlayer.getFaction().name][plate] = nil
            keyTemporarly[xPlayer.getFaction().name] = nil
        end
    end
end)

VFW.GiveKeyTemporaly = function(source, type, plate)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    if type == "auther" then
        if not keyTemporarly[source] then
            keyTemporarly[source] = {}
        end
        keyTemporarly[source][plate] = true
    elseif type == "job" then
        if not keyTemporarly[xPlayer.getJob().name] then
            keyTemporarly[xPlayer.getJob().name] = {}
        end
        keyTemporarly[xPlayer.getJob().name][plate] = true
    elseif type == "crew" then
        if keyTemporarly[xPlayer.getFaction().name] then
            keyTemporarly[xPlayer.getFaction().name] = {}
        end
        keyTemporarly[xPlayer.getFaction().name][plate] = true
    end
end

VFW.RemoveKeyTemporaly = function(source, type, plate)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    if type == nil then
        for k, v in pairs(keyTemporarly) do
            if v[plate] then
                v[plate] = nil
                if next(v) == nil then
                    keyTemporarly[k] = nil
                    break
                end
            end
        end
    elseif type == "auther" then
        if keyTemporarly[source] then
            keyTemporarly[source][plate] = nil
            keyTemporarly[source] = nil
        end
    elseif type == "job" then
        if keyTemporarly[xPlayer.getJob().name] then
            keyTemporarly[xPlayer.getJob().name][plate] = nil
            keyTemporarly[xPlayer.getJob().name] = nil
        end
    elseif type == "crew" then
        if keyTemporarly[xPlayer.getFaction().name] then
            keyTemporarly[xPlayer.getFaction().name][plate] = nil
            keyTemporarly[xPlayer.getFaction().name] = nil
        end
    end
end

local tempKeyStatut = false

RegisterNetEvent("vfw:vehicle:open", function()
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    local keyList = {}
    local keyTempList = {}
    local vehList = GetNearbyVehicles(GetEntityCoords(GetPlayerPed(xPlayer.source)), 5.0)

    for _, v in pairs(xPlayer.getInventory()) do
        if v.name == "keys" then
            keyList[v.meta.plate] = true
            break
        end
    end

    for i = 1, #vehList do
        local plate = GetVehicleNumberPlateText(vehList[i])

        if keyTemporarly[source] and keyTemporarly[source][plate] then
            keyTempList[plate] = true
        elseif keyTemporarly[xPlayer.getJob().name] and keyTemporarly[xPlayer.getJob().name][plate] then
            keyTempList[plate] = true
        elseif keyTemporarly[xPlayer.getFaction().name] and keyTemporarly[xPlayer.getFaction().name][plate] then
            keyTempList[plate] = true
        end

        if keyList[plate] then
            local vehicle = VFW.GetVehicleByPlate(plate)

            vehicle.changeLock(not vehicle.locked)
            xPlayer.triggerEvent("vfw:vehicle:anim")
            return
        elseif keyTempList[plate] then
            tempKeyStatut = not tempKeyStatut
            SetVehicleDoorsLocked(vehList[i], tempKeyStatut and 2 or 1)
            xPlayer.triggerEvent("vfw:vehicle:anim")
            return
        end
    end
end)

RegisterServerCallback('core:server:GetAllVehicle', function(source, target)
    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then return end
    local vehs = {
        ["owned"] = {},
        ["job"] = {},
        ["crew"] = {}
    }
    local id = xTarget.id
    local crewP = xTarget.getFaction().name
    local jobP = xTarget.getJob().name
    local owned = VFW.GetVehiclesByOwner(id)
    local job = VFW.GetVehiclesByJob(jobP)
    local crew = VFW.GetCrewVehicles(crewP)

    -- owned
    if owned then
        for k, v in pairs(owned) do
            table.insert(vehs.owned, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    end

    -- job
    if job then
        for k, v in pairs(job) do
            table.insert(vehs.job, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    end

    -- crew
    if crew then
        for k, v in pairs(crew) do
            table.insert(vehs.crew, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    end

    return vehs
end)

RegisterServerCallback('core:server:GetTypeVehicle', function(source, target, type)
    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then return end
    local vehs = {
        ["owned"] = {},
        ["job"] = {},
        ["crew"] = {}
    }

    if type == "owned" then
        local owned = VFW.GetVehiclesByOwner(xTarget.id)
        for k, v in pairs(owned) do
            table.insert(vehs.owned, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    elseif type == "job" then
        local job = VFW.GetVehiclesByJob(xTarget.getJob().name)
        for k, v in pairs(job) do
            table.insert(vehs.job, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    elseif type == "crew" then
        local crew = VFW.GetCrewVehicles(xTarget.getFaction().name)
        for k, v in pairs(crew) do
            table.insert(vehs.crew, { plate = v.plate, name = v.vehName, stored = v.pounded })
        end
    end

    return vehs
end)
