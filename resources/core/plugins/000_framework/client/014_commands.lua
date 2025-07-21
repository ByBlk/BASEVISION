local idle = false

RegisterCommand('idle', function(source, args, showError)
    idle = not idle
    DisableIdleCamera(idle)
    VFW.ShowNotification({
        type = 'JAUNE',
        content = idle and 'Vous avez ~s désactivé ~c la caméra AFK' or 'Vous avez ~s activé ~c la caméra AFK'
    })
    while idle do
        Wait(5000)
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
    end
end)

RegisterCommand('nettoyer', function(source, args, showError)
    ClearPedBloodDamage(VFW.PlayerData.ped)
    ResetPedVisibleDamage(VFW.PlayerData.ped)
    ClearPedLastWeaponDamage(VFW.PlayerData.ped)
    ClearPedEnvDirt(VFW.PlayerData.ped)
    ClearPedWetness(VFW.PlayerData.ped)
end)

RegisterCommand('recruter', function(source, args, showError)
    if not VFW.PlayerData.job.perms[VFW.PlayerData.job.grade_name].recruit then
        return
    end

    local playerId = VFW.StartSelect(5.0, true)
    if playerId then
        TriggerServerEvent("vfw:recruter", GetPlayerServerId(playerId))
    end
end)
