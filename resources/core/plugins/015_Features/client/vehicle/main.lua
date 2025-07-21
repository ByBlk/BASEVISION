local function lightAnimation(vehicle)
    for _ = 1, 2 do
        SetVehicleLights(vehicle, 2)
        Wait(150)
        SetVehicleLights(vehicle, 0)
        Wait(150)
    end
end

local animationDict = 'anim@mp_player_intmenu@key_fob@'
local modelHash = 'lr_prop_carkey_fob'
local function keyAnimation()
    TaskPlayAnim(VFW.PlayerData.ped, animationDict, 'fob_click', 3.0, 3.0, -1, 48, 0.0, false, false, false)

    local playerCoords = GetEntityCoords(VFW.PlayerData.ped)
    local prop = CreateObject(modelHash, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(prop, VFW.PlayerData.ped, GetPedBoneIndex(VFW.PlayerData.ped, 57005), 0.14, 0.03, -0.01, 24.0, -152.0, 164.0, true, true, false, false, 1, true)

    Wait(1000)
    DeleteObject(prop)
    ClearPedTasks(VFW.PlayerData.ped)
end

RegisterNetEvent("vfw:vehicle:anim", function()
    local veh = VFW.Game.GetClosestVehicle()
    CreateThread(keyAnimation)
    lightAnimation(veh)
    PlayVehicleDoorCloseSound(veh, 1)
end)

local antiSpam = false

RegisterKeyMapping("+vehicleKey", "Ouvrir véhicule", "keyboard", "U")
RegisterCommand("+vehicleKey", function()
    if antiSpam then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Attendez 2 secondes !"
        })
    else
        antiSpam = true
        TriggerServerEvent("vfw:vehicle:open")
        SetTimeout(2000, function()
            antiSpam = false
        end)
    end
end)
