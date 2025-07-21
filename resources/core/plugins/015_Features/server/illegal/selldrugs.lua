local lockedPeds = {}
local SAFE_DRUG_ITEMS = {
    weed = true,
    fentanyl = true,
    coke = true,
    meth = true,
    ecstasy = true
}

RegisterServerCallback("vfw:sellDrugs:getNbOfDuty", function(_, jobName)
    local count = 0
    local players = VFW.GetPlayers()

    for i = 1, #players do
        local player = VFW.GetPlayerFromId(players[i])

        if player then
            local job = player.getJob()

            if job.name == jobName and job.onDuty then
                count = count + 1
            end
        end
    end

    return count
end)

RegisterNetEvent("vfw:sellDrugs:pedLock", function(ped, players)
    lockedPeds[#lockedPeds + 1] = ped
    VFW.TriggerClientEvents("vfw:sellDrugs:pedLock", players, ped)
end)

RegisterNetEvent("vfw:sellDrugs:Loaded", function()
    TriggerClientEvent("vfw:sellDrugs:loadPedLock", source, lockedPeds)
end)

RegisterNetEvent("vfw:sellDrugs:sell", function(drug, count, price)
    if not SAFE_DRUG_ITEMS[drug] then return end

    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.removeItem(drug, count, {})
    xPlayer.addMoney(price)

    local playerCrew = VFW.GetCrewByName(xPlayer.getFaction().name)
    if playerCrew then
        playerCrew.addXp(count)
        playerCrew.addActivity(xPlayer.identifier, "drugs_sell")
    end
end)

CreateThread(function()
    while true do
        Wait(2 * 60000)
        lockedPeds = {}
    end
end)
