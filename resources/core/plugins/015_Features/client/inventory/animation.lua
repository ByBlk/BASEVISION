local special = {
    ["lspd"] = true,
    ["lssd"] = true,
}

LastWeaponId = nil

function VFW.WeaponAnim(id)
    local weapon = GetSelectedPedWeapon(VFW.PlayerData.ped)
    CreateThread(function()
        local timer = GetGameTimer() + 3500
        while GetGameTimer() < timer do
            DisablePlayerFiring(VFW.PlayerData.ped, true)
            Wait(0)
        end
    end)

    if weapon ~= `weapon_unarmed` then
        if special[VFW.PlayerData.job.name] and VFW.PlayerData.metadata.jobDuty then
            VFW.Streaming.RequestAnimDict("rcmjosh4")
            TaskPlayAnim(VFW.PlayerData.ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(VFW.PlayerData.ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
            Wait(60)
            ClearPedTasks(VFW.PlayerData.ped)
            RemoveAnimDict("rcmjosh4")
        else
            VFW.Streaming.RequestAnimDict("reaction@intimidation@1h")
            TaskPlayAnim(VFW.PlayerData.ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0)
            Wait(1500)
            ClearPedTasks(VFW.PlayerData.ped)
            RemoveAnimDict("reaction@intimidation@1h")
        end
    else
        if special[VFW.PlayerData.job.name] and VFW.PlayerData.metadata.jobDuty then
            VFW.Streaming.RequestAnimDict("rcmjosh4")
            VFW.Streaming.RequestAnimDict("reaction@intimidation@cop@unarmed")
            TaskPlayAnim(VFW.PlayerData.ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
            Wait(100)
            TaskPlayAnim(VFW.PlayerData.ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
            Wait(400)
            ClearPedTasks(VFW.PlayerData.ped)
            RemoveAnimDict("rcmjosh4")
            RemoveAnimDict("reaction@intimidation@cop@unarmed")
        else
            VFW.Streaming.RequestAnimDict("reaction@intimidation@1h")
            TaskPlayAnim(VFW.PlayerData.ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0)
            Wait(1250)
            ClearPedTasks(VFW.PlayerData.ped)
            RemoveAnimDict("reaction@intimidation@1h")
        end
    end

    if IsPedArmed(VFW.PlayerData.ped, 4) then
        LastWeaponId = id
    else
        LastWeaponId = nil
    end
end

RegisterNetEvent("vfw:weaponChange", VFW.WeaponAnim)
