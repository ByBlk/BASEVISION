local IsVehicleSeatFree <const> = IsVehicleSeatFree
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn
local HasAnimDictLoaded <const> = HasAnimDictLoaded
local vehicleThieft = nil

local function vehicleLoop()
    local ped = VFW.PlayerData.ped
    console.debug("vehicleThieft", vehicleThieft, DoesEntityExist(vehicleThieft))
    SetVehicleAlarm(vehicleThieft, true)
    TaskEnterVehicle(ped, vehicleThieft, -1, -1, 1.0, 1, 0)
    SetVehicleAlarm(vehicleThieft, true)
    SetVehicleAlarmTimeLeft(vehicleThieft, 50000)
    SetFollowPedCamViewMode(4)   
    CreateThread(function()
        local timer = GetGameTimer() + 15000
        local start = false
        local minigame = false
        while vehicleThieft ~= nil do
            Wait(0)
            local currentVeh = GetVehiclePedIsIn(ped, false)
            if (GetGameTimer() > timer) and (not IsPedInVehicle(ped, vehicleThieft, true)) then
                SetVehicleDoorsLocked(vehicleThieft, 2)
                vehicleThieft = nil
                return
            elseif IsPedInVehicle(ped, vehicleThieft) then
                if (not minigame) then 
                    SetFollowPedCamViewMode(4)   
                    TaskPlayAnim(ped, 'anim@amb@carmeet@checkout_car@male_a@idles', 'idle_b', 49)
                    minigame = true 
                    TriggerEvent("Mx::StartMinigameElectricCircuit", "50%", "90%", 1.0, "30vmin", "1.ogg", function()
                        start = true
                        ClearPedTasks(ped)
                        VFW.ShowNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = 'Vous avez volé le véhicule'
                        })
                        SetVehicleEngineOn(currentVeh, false, false, false)
                    end)
                end
                if IsVehicleEngineStarting(vehicleThieft) then
                    SetVehicleEngineOn(currentVeh, false, true, true)
                end
                if (not IsVehicleEngineStarting(vehicleThieft)) and start and currentVeh then
                    Wait(2000)
                    SetVehicleEngineOn(currentVeh, true, true, true)
                    SetFollowPedCamViewMode(2)
                    SetTimeout(10000, function()
                        SetVehicleUndriveable(vehicleThieft, false)
                        SetVehicleAlarmTimeLeft(vehicleThieft, 30000)
                    end)
                    start = false
                    -- stop the alarm after 30 seconds
                    SetTimeout(40000, function()
                        SetVehicleAlarm(vehicleThieft, false)
                    end)
                    vehicleThieft = nil
                    return
                end
            end
        end
    end)
end

local function hookVehicle()
    local closestVeh = VFW.Game.GetClosestVehicle()
    local random = math.random(0, 100)
    if closestVeh and closestVeh > 0 then 
        local seat = GetVehicleModelNumberOfSeats(GetEntityModel(closestVeh))
        for i = -1, seat - 2 do
            if (not IsVehicleSeatFree(closestVeh, i)) then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Il y a quelqu'un dans le vehicule"
                })
                return
            end
        end
        local vehicleClass = GetVehicleClass(closestVeh)
        if vehicleClass == 15 or vehicleClass == 16 or vehicleClass == 19 or vehicleClass == 17 then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Il est impossible de ~s crocheter ce véhicule"
            })
            return
        end
        RequestAnimDict('missheistfbisetup1')
        while not HasAnimDictLoaded('missheistfbisetup1') do
            Wait(1)
        end
        -- Remove item
        local ped = VFW.PlayerData.ped
        SetEntityAsMissionEntity(closestVeh, true, true)
        SetVehicleHasBeenOwnedByPlayer(closestVeh, true)
        TaskPlayAnim(ped, 'missheistfbisetup1' , 'hassle_intro_loop_f' ,8.0, -8.0, -1, 1, 0, false, false, false )
        RemoveAnimDict("missheistfbisetup1")
        local coords = GetEntityCoords(closestVeh)
        TriggerServerEvent('core:alert:makeCall', "lspd", coords, true, "Vol de véhicule", false, nil)
        TriggerServerEvent('core:alert:makeCall', "lssd", coords, true, "Vol de véhicule", false, nil)
        OpenStepCustom("Vol de véhicule", "Utilisez ZQSD ou les fleches pour deplacer la goupille")
        local result = exports['lockpick']:startLockpick()
        while result == nil do 
            Wait(1)
        end
        HideStep()
        if (not result) then 
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "~s Vous avez cassé votre crochet !"
            })
            ClearPedTasks(ped)
            return 
        end
        inHeist = false
        ClearPedTasks(ped)
        local closestVeh = VFW.Game.GetClosestVehicle()
        console.debug("closestVeh", closestVeh, DoesEntityExist(closestVeh))
        NetworkRequestControlOfEntity(closestVeh)
        while (not NetworkHasControlOfEntity(closestVeh)) do
            Wait(1)
        end
        SetVehicleDoorsLocked(closestVeh, 0)
        SetVehicleDoorsLockedForAllPlayers(closestVeh, false)
        local hookVariable = VFW.Variables.GetVariable("heist_hook")
        ActionInTerritoire(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), (tonumber(hookVariable.influence) or 5), 6, VFW.IsCoordsInSouth(GetEntityCoords(ped)))
        SetVehicleUndriveable(closestVeh, true)
        TriggerServerEvent("core:crew:updateXp", token, tonumber(hookVariable.xp), "add", VFW.PlayerData.faction.name, "hook")
        VFW.ShowNotification({
            type = 'VERT',
            content = "~s Vous avez crocheté le vehicule"
        })
        vehicleThieft = closestVeh
        vehicleLoop()
        -- TODO : LOG
    end
end

RegisterCommand("hook", hookVehicle)

RegisterNetEvent("core:illegal:hookVehicle", hookVehicle)