local infoVeh, maxSpeed, limitateur, autoDrive, open = nil , 50, false, false, false

VFW.RegisterInput("limitateur", "Limitateur de vitesse", "keyboard", "M", function()
    if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(VFW.PlayerData.ped, false), -1) == VFW.PlayerData.ped then
            if limitateur then
                VFW.ShowNotification({
                    type = 'JAUNE',
                    content = "Limitateur ~s désactivé"
                })
                SetVehicleMaxSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), GetVehicleEstimatedMaxSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false)))
                limitateur = false
            else
                VFW.ShowNotification({
                    type = 'JAUNE',
                    content = "Limitateur ~s activé ~c à ~s" .. maxSpeed .. "km/h"
                })
                while GetEntitySpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false)) > maxSpeed / 3.6 do Wait(1) end
                SetVehicleMaxSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), maxSpeed / 3.6)
                limitateur = true
            end
        end
    end
end)

VFW.RegisterInput("openVehicleMenu", "Ouvrir le menu info du véhicule", "keyboard", "F11", function()
    if not open then
        if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
            local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)

            infoVeh = {
                fuel = Round(GetVehicleFuelLevel(veh)),
                status = math.floor(Round(GetVehicleEngineHealth(veh)) / 10),
                VehicleName = string.upper(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))),
                VehicleModel = GetMakeNameFromVehicleModel(GetEntityModel(veh)),
                speedLimit = maxSpeed
            }
            if GetPedInVehicleSeat(veh, -1) == VFW.PlayerData.ped then
                open = true
                VFW.Nui.VehiclesMenu(true, infoVeh)
                CreateThread(function()
                    while open do
                        Wait(0)
                        DisableControlAction(0, 24, true) -- disable attack
                        DisableControlAction(0, 25, true) -- disable aim
                        DisableControlAction(0, 1, true) -- LookLeftRight
                        DisableControlAction(0, 2, true) -- LookUpDown
                        DisableControlAction(0, 142, open)
                        DisableControlAction(0, 18, open)
                        DisableControlAction(0, 322, open)
                        DisableControlAction(0, 106, open)
                        DisableControlAction(0, 263, true) -- disable melee
                        DisableControlAction(0, 264, true) -- disable melee
                        DisableControlAction(0, 257, true) -- disable melee
                        DisableControlAction(0, 140, true) -- disable melee
                        DisableControlAction(0, 141, true) -- disable melee
                        DisableControlAction(0, 142, true) -- disable melee
                        DisableControlAction(0, 143, true) -- disable melee
                    end
                end)
            end
        end
    else
        open = false
        VFW.Nui.VehiclesMenu(false)
    end

    while open do
        if not IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
            open = false
            VFW.Nui.VehiclesMenu(false)
        end
        Wait(150)
    end
end)

local function StartAutoDrive()
    local coords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))

    if coords ~= nil and coords ~= 0 then
        TaskVehicleDriveToCoordLongrange(VFW.PlayerData.ped, GetVehiclePedIsIn(VFW.PlayerData.ped, false), coords.x, coords.y, coords.z, 50.0, 907, 20.0)
    end

    CreateThread(function()
        while autoDrive do
            if #(GetEntityCoords(VFW.PlayerData.ped) - coords) <= 20.0 then
                if autoDrive then
                    ClearPedTasks(VFW.PlayerData.ped)
                    SetVehicleForwardSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 19.0)
                    Wait(200)
                    SetVehicleForwardSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 15.0)
                    Wait(200)
                    SetVehicleForwardSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 11.0)
                    Wait(200)
                    SetVehicleForwardSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 6.0)
                    Wait(200)
                    SetVehicleForwardSpeed(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 0.0)
                    VFW.ShowNotification({
                        type = 'JAUNE',
                        content = "Vous êtes ~s arrivé ~c à destination"
                    })
                    autoDrive = false
                    return
                else
                    return
                end
            end
            Wait(1)
        end
    end)
end

RegisterNUICallback("nui:vehicleMenu", function(data)
    console.debug("nui:vehicleMenu", json.encode(data))

    for k, v in pairs(data) do
        if k == "engine" then
            if v then
                SetVehicleEngineOn(GetVehiclePedIsIn(VFW.PlayerData.ped, false), false, false, true)
                SetVehicleUndriveable(GetVehiclePedIsIn(VFW.PlayerData.ped, false), true)
            else
                SetVehicleEngineOn(GetVehiclePedIsIn(VFW.PlayerData.ped, false), true, false, true)
                SetVehicleUndriveable(GetVehiclePedIsIn(VFW.PlayerData.ped, false), false)
            end
            return
        elseif k == "frontLeft" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 0, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 0, false)
            end
            return
        elseif k == "frontRight" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 1, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 1, false)
            end
            return
        elseif k == "backLeft" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 2, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 2, false)
            end
            return
        elseif k == "backRight" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 3, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 3, false)
            end
            return
        elseif k == "hood" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 4, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 4, false)
            end
            return
        elseif k == "trunk" then
            if v then
                SetVehicleDoorOpen(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 5, false, false)
            else
                SetVehicleDoorShut(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 5, false)
            end
            return
        elseif k == "windowsFrontLeft" then
            if v then
                RollUpWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 0)
            else
                RollDownWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 0)
            end
            return
        elseif k == "windowsFrontRight" then
            if v then
                RollUpWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 1)
            else
                RollDownWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 1)
            end
            return
        elseif k == "windowsBackLeft" then
            if v then
                RollUpWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 2)
            else
                RollDownWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 2)
            end
            return
        elseif k == "windowsBackRight" then
            if v then
                RollUpWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 3)
            else
                RollDownWindow(GetVehiclePedIsIn(VFW.PlayerData.ped, false), 3)
            end
            return
        elseif k == "limitateurVitesse" then
            maxSpeed = v
            return
        elseif k == "autoDrive" then
            if not v then
                if IsWaypointActive() then
                    StartAutoDrive()
                    autoDrive = true
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Vous devez avoir un point d'arrivée pour lancer la conduite auto"
                    })
                end
            else
                ClearPedTasks(VFW.PlayerData.ped)
                autoDrive = false
            end
            return
        end
    end
end)

RegisterNUICallback("nui:vehicleMenu:close", function(data)
    open = false
    VFW.Nui.VehiclesMenu(false)
end)
