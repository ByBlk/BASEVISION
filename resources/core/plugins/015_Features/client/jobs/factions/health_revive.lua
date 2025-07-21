local function PlayAnim(dict, anim, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(1) end
    TaskPlayAnim(VFW.PlayerData.ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    RemoveAnimDict(dict)
end

RegisterNetEvent("core:jobs:client:HealthPlayer", function(health)
    SetEntityHealth(VFW.PlayerData.ped, health)
end)

RegisterNetEvent("core:jobs:client:reviveanimrevived", function(playerheading, coords, playerlocation , players)
    FreezeEntityPosition(VFW.PlayerData.ped, true)
    local x, y, z = table.unpack(coords + playerlocation * 1.0)
    SetEntityCoords(VFW.PlayerData.ped, x, y, z - 1.0)
    SetEntityHeading(VFW.PlayerData.ped, playerheading - 270.0)
    while not IsEntityPlayingAnim(VFW.PlayerData.ped, "mini@cpr@char_b@cpr_def", "cpr_intro", 1) do
        PlayAnim("mini@cpr@char_b@cpr_def", "cpr_intro", 1)
        Wait(100)
    end
    TriggerServerEvent("core:jobs:server:reviveanimreviver", players)
    Wait(15800 - 900)
    for i = 1, 15, 1 do
        Wait(900)
        PlayAnim("mini@cpr@char_b@cpr_str", "cpr_pumpchest", 1)
    end
    PlayAnim("mini@cpr@char_b@cpr_str", "cpr_success", 1)
    Citizen.Wait(30590)
    ClearPedTasks(VFW.PlayerData.ped)
    FreezeEntityPosition(VFW.PlayerData.ped, false)
end)

RegisterNetEvent("core:jobs:client:reviveanimreviver", function(players)
    TriggerServerEvent('core:jobs:server:RevivePlayer', players)
    Wait(150)
    PlayAnim("mini@cpr@char_a@cpr_def", "cpr_intro", 1)
    Wait(15800 - 900)
    for i = 1, 15, 1 do
        Wait(900)
        PlayAnim("mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1)
    end
    PlayAnim("mini@cpr@char_a@cpr_str", "cpr_success", 1)
    Citizen.Wait(30590)
    ClearPedTasks(VFW.PlayerData.ped)
end)
