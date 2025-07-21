RegisterServerCallback("core:server:jobs:GetPatientIdentity", function(source, id)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xTarget = VFW.GetPlayerFromId(id)
    if not xTarget then return end
    return {
        prenom = xTarget.get("firstName") or "Aucun",
        nom = xTarget.get("lastName") or "Aucun",
        age = xTarget.get("dateofbirth") or "Aucun",
        sexe = xTarget.get("sex") or "Aucun",
    }
end)

RegisterNetEvent('handcuff:server:handcuff', function(target, wannacuff)
    local xPlayer = VFW.GetPlayerFromId(source)
    local xTarget = VFW.GetPlayerFromId(target)
    local job = xPlayer.getJob().name
    if job == "unemployed" or not xPlayer.job.onDuty then return end
    if not xTarget then return end
    local targetCuff = xTarget.getMeta().cuffState

    if wannacuff then
        if targetCuff and targetCuff.isCuffed then return end
        TriggerClientEvent('handcuff:client:arresting', xPlayer.source)
        TriggerClientEvent('handcuff:client:thecuff', target, true, xPlayer.source)
        xTarget.setMeta("cuffState", { isCuffed = true })
    elseif not wannacuff then
        if not targetCuff and targetCuff.isCuffed then return end
        TriggerClientEvent('handcuff:client:unarresting', xPlayer.source)
        TriggerClientEvent('handcuff:client:thecuff', target, false, xPlayer.source)
        xTarget.setMeta("cuffState", { isCuffed = false })
    end
end)

RegisterServerCallback("core:jobs:server:getVeh", function(src, plate)
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local veh = VFW.GetVehicleByPlate(plate)
    if not veh then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Aucun propriétaire trouvé"
        })
        return
    end
    local owner = veh.owner:gsub("player:", "")
    if not owner then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Aucun propriétaire trouvé"
        })
        return
    end
    local result = MySQL.single.await('SELECT firstname, lastname FROM users WHERE id = ?', { owner })
    if not result then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Aucun propriétaire trouvé"
        })
        return
    end
    return result.firstname, result.lastname
end)

local trafficZones = {}

RegisterNetEvent("core:jobs:traffic:add", function(zone)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    table.insert(trafficZones, zone)
    TriggerClientEvent("core:jobs:traffic:addclient", -1, zone)
end)

RegisterNetEvent("core:jobs:traffic:remove", function(id)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    for i, zone in ipairs(trafficZones) do
        if zone.zoneId == id then
            TriggerClientEvent("core:jobs:traffic:removeclient", -1, id)
            table.remove(trafficZones, i)
            break
        end
    end
end)

RegisterServerCallback("core:jobs:traffic:get", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    return trafficZones
end)

RegisterNetEvent('core:jobs:server:drag', function(target)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xPlayerTarget = VFW.GetPlayerFromId(target)
    if not xPlayerTarget then return end
    local meta = xPlayerTarget.getMeta().cuffState

    if meta and meta.isCuffed then
        TriggerClientEvent('core:jobs:client:drag', target, xPlayer.source)
    end
end)

RegisterNetEvent('core:jobs:server:putInVehicle', function(target)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xPlayerTarget = VFW.GetPlayerFromId(target)
    if not xPlayerTarget then return end
    local meta = xPlayerTarget.getMeta().cuffState

    if meta and meta.isCuffed then
        TriggerClientEvent('core:jobs:client:putInVehicle', target)
    end
end)

RegisterNetEvent('core:jobs:server:OutVehicle', function(target)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xPlayerTarget = VFW.GetPlayerFromId(target)
    if not xPlayerTarget then return end
    local meta = xPlayerTarget.getMeta().cuffState

    if meta and meta.isCuffed then
        TriggerClientEvent('core:jobs:client:OutVehicle', target)
    end
end)

RegisterNetEvent("core:jobs:server:HealthPlayer", function(player)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xPlayerTarget = VFW.GetPlayerFromId(player)
    if not xPlayerTarget then return end
    local ped = GetPlayerPed(player)
    if not ped then return end

    xPlayerTarget.setMeta("hunger", 100)
    xPlayerTarget.setMeta("thirst", 100)
    xPlayerTarget.setMeta("health", GetEntityMaxHealth(ped))
    xPlayerTarget.triggerEvent("core:jobs:client:HealthPlayer", GetEntityMaxHealth(ped))
end)

RegisterNetEvent("core:jobs:server:RevivePlayer", function(player)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    local xPlayerTarget = VFW.GetPlayerFromId(player)
    if not xPlayerTarget then return end
    local ped = GetPlayerPed(player)
    if not ped then return end

    xPlayerTarget.triggerEvent("vfw:revivePlayer")
    xPlayerTarget.setMeta("hunger", 100)
    xPlayerTarget.setMeta("thirst", 100)
    xPlayerTarget.setMeta("health", GetEntityMaxHealth(ped))
end)

RegisterNetEvent("core:jobs:server:reviveanimrevived", function(players, playerheading, coords, playerlocation)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end

    TriggerClientEvent("core:jobs:client:reviveanimrevived", players, playerheading, coords, playerlocation, source)
end)

RegisterNetEvent("core:jobs:server:reviveanimreviver", function(players)
    TriggerClientEvent("core:jobs:client:reviveanimreviver", players)
end)

RegisterServerCallback("core:jobs:server:haveKit", function(source, type)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    xPlayer.updateInventory()

    local name = type == "health" and "band" or type == "revive" and "medikit"
    local hasItem = xPlayer.haveItem(name)

    if hasItem then
        xPlayer.removeItem(name, 1, {})
        xPlayer.updateInventory()
        return hasItem
    end

    return hasItem
end)

VFW.RegisterUsableItem("bequille", function(xPlayer)
    TriggerClientEvent("core:UseBequille", xPlayer.source)
end)

VFW.RegisterUsableItem("froulant", function(xPlayer, deleteCallback)
    TriggerClientEvent("core:SpawnWheelChair", xPlayer.source)
    deleteCallback()
end)

RegisterNetEvent("core:recupWheelChair", function()
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.createItem("froulant", 1)
    xPlayer.updateInventory()
end)

VFW.RegisterUsableItem("shield", function(xPlayer)
    TriggerClientEvent("shield:TogglePoliceShield", xPlayer.source)
end)

VFW.RegisterUsableItem("lssdshield", function(xPlayer)
    TriggerClientEvent("shield:ToggleLSSDShield", xPlayer.source)
end)

VFW.RegisterUsableItem("band", function(xPlayer)
    TriggerClientEvent("core:UseItemsMedic1", xPlayer.source, 25)
end)

VFW.RegisterUsableItem("pad", function(xPlayer)
    TriggerClientEvent("core:UseItemsMedic2", xPlayer.source, 15)
end)

VFW.RegisterUsableItem("medikit", function(xPlayer)
    TriggerClientEvent("core:UseItemsMedic3", xPlayer.source, 45)
end)

VFW.RegisterUsableItem("medic", function(xPlayer)
    TriggerClientEvent("core:UseItemsMedic4", xPlayer.source, 10)
end)

VFW.RegisterUsableItem("pad2", function(xPlayer)
    TriggerClientEvent("core:UseItemsMedic5", xPlayer.source, 15)
end)

VFW.RegisterUsableItem("badge_lspd", function(xPlayer, deleteCallback, metaData)
    TriggerClientEvent("core:useBadge", xPlayer.source, metaData)
end)

VFW.RegisterUsableItem("badge_lssd", function(xPlayer, deleteCallback, metaData)
    TriggerClientEvent("core:useBadge", xPlayer.source, metaData)
end)

VFW.RegisterUsableItem("badge_usss", function(xPlayer, deleteCallback, metaData)
    TriggerClientEvent("core:useBadge", xPlayer.source, metaData)
end)

VFW.RegisterUsableItem("pad3", function(xPlayer)
    TriggerClientEvent("core:useItemBadge", xPlayer.source, 15)
end)

local safeItems = {
    ["band"] = true,
    ["pad"] = true,
    ["medikit"] = true,
    ["medic"] = true,
    ["pad2"] = true,
    ["pad3"] = true,
}

RegisterNetEvent("core:removeItems", function(item, count)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    if not safeItems[item] then return end

    xPlayer.removeItem(item, count, {})
    xPlayer.updateInventory()
end)

local AllPoudres = {}

local function StartTimerResetPoudre(src)
    CreateThread(function()
        Wait(1 * 2700000)
        AllPoudres[src] = nil
    end)
end

RegisterNetEvent("core:testPoudre", function()
    local src = source
    if GetPlayerRoutingBucket(src) ~= 0 then return end

    if AllPoudres[src] then
        if AllPoudres[src] == 75 then
            AllPoudres[src] = 90
        elseif AllPoudres[src] == 90 then
            AllPoudres[src] = 100
        end
    else
        AllPoudres[src] = 75
        StartTimerResetPoudre(src)
    end
end)

RegisterServerCallback("core:getTestPoudre",function(source, id)
    return AllPoudres[id]
end)

VFW.RegisterUsableItem("poudre", function(xPlayer, deleteCallback)
    TriggerClientEvent("core:useTestPoudre", xPlayer.source)
    deleteCallback()
end)
