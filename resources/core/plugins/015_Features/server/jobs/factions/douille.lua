RegisterNetEvent("core:jobs:server:shootingcases", function(coords, weapon_category, weaponid)
    local weapon_types = {
        [416676503] = '9mm',
        [-957766203] = '9mm',
        [1159398588] = '9mm',
        [860033945] = '12 Gauge',
        [970310034] = '5.56x45mm Rifle',
        [3082541095] = '7.62x51mm Sniper',
        [-1212426201] = '7.62x51mm Sniper',
        [2725924767] = '12.7x99mm (.50 Cal)',
        [-1569042529] = 'Roquette'
    }

    local time = os.date('%H:%M:%S', os.time())
    local id = VFW.GetPlayersWithJobs({"lspd", "lssd", "usss"})

    VFW.TriggerClientEvents("core:jobs:client:shootingcases", id, {
        pos = coords,
        time = time,
        typeAmmo = weapon_types[weapon_category] or weapon_category,
        id = weaponid
    })
end)

RegisterNetEvent("core:jobs:server:addDouille", function(meta)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end

    local douille = {
        pos = meta.pos,
        time = meta.time,
        typeAmmo = meta.typeAmmo,
        id = meta.weaponId
    }

    xPlayer.addItem("douille", 1, douille)
    xPlayer.updateInventory()
end)
