local state = false

local function Thread(vehicle, seat)
    CreateThread(function()
        while state and DoesEntityExist(vehicle) and GetVehicleClass(vehicle) ~= 14 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 15 do
            if vehicle ~= 0 and (seat == -1 or seat == 0) and GetIsVehicleEngineRunning(vehicle) then
                local speed = GetEntitySpeed(vehicle) * 3.6
                local fuelLevel = GetVehicleFuelLevel(vehicle)
                local consumptionRate = (Fuel.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] or 0.1) * (Fuel.Classes[GetVehicleClass(vehicle)] or 1.0) / 10

                for speedLimit, rate in pairs(Fuel.FuelUsage) do
                    if speed >= speedLimit * 100 then
                        consumptionRate = rate
                        break
                    end
                end

                if fuelLevel > 0 then
                    SetFuelConsumptionRateMultiplier(vehicle, consumptionRate)
                    SetFuelConsumptionState(vehicle, true)
                    SetVehicleFuelLevel(vehicle, fuelLevel - consumptionRate)
                else
                    SetFuelConsumptionState(vehicle, false)
                    SetVehicleEngineOn(vehicle, false, true, true)
                end
            end

            Wait(1000)
        end
    end)
end

AddEventHandler("vfw:enteredVehicle", function(vehicle, _, seat)
    if state then return end
    state = true
    Thread(vehicle, seat)
end)

AddEventHandler("vfw:exitedVehicle", function()
    state = false
end)

local isFueling, activePump, currentV, nozzle, rope, disableMovements = false, nil, nil, nil, nil, false

local function FindNearestFuelPump()
    local coords = GetEntityCoords(VFW.PlayerData.ped)
    local fuelPumps = {}
    local handle, object = FindFirstObject()
    local success

    repeat
        if Config.Features.Fuel.PumpModels[GetEntityModel(object)] then
            table.insert(fuelPumps, object)
        end

        success, object = FindNextObject(handle, object)
    until not success

    EndFindObject(handle)

    local pumpObject = 0
    local pumpDistance = 1000

    for _, fuelPumpObject in pairs(fuelPumps) do
        local dstcheck = #(coords - GetEntityCoords(fuelPumpObject))

        if dstcheck < pumpDistance then
            pumpDistance = dstcheck
            pumpObject = fuelPumpObject
        end
    end

    return pumpObject, pumpDistance
end

local function dropNozzle()
    if nozzle then
        DetachEntity(nozzle, true, true)
        DeleteEntity(nozzle)
        DeleteRope(rope)
        nozzle, rope = nil, nil
    end
end

local function SetFuel(vehicle)
    if DoesEntityExist(vehicle) then
        local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") or 65.0
        SetVehicleFuelLevel(vehicle, maxFuel)
        DecorSetFloat(vehicle, Fuel.FuelDecor, maxFuel)
    end
end

local function FinishProgressBar()
    SetFuel(currentV)
    dropNozzle()
    ClearPedTasks(VFW.PlayerData.ped)
    RemoveAnimDict("timetable@gardener@filling_can")
    isFueling, disableMovements = false, false
    VFW.ShowNotification({
        type = 'JAUNE',
        content = "Vous avez ~s fini ~c de mettre de l'essence."
    })
end

local function StartProgressBar()
    disableMovements = true
    CreateThread(function()
        while disableMovements do
            Wait(1)
            for _, control in ipairs({30, 31, 36, 21, 24, 25, 37, 47, 58, 140, 141, 142, 143, 263, 264, 257}) do
                DisableControlAction(0, control, true)
            end
            DisablePlayerFiring(PlayerId(), true)
        end
    end)

    local duration = VFW.Nui.ProgressBar("Plein d'essence...", Fuel.ProgressTime * 1000)

    if duration then
        FinishProgressBar()
    end
end

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
    end
end

local function grabNozzleFromPump()
    local ped = VFW.PlayerData.ped
    local pumpObject, pumpDistance = FindNearestFuelPump()
    local pump = GetEntityCoords(pumpObject)

    LoadAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    Wait(300)
    nozzle = CreateObject('prop_cs_fuel_nozle', 0, 0, 0, true, true, true)
    AttachEntityToEntity(nozzle, ped, GetPedBoneIndex(ped, 0x49D9), 0.11, 0.02, 0.02, -80.0, -90.0, 15.0, true, true, false, true, 1, true)
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Wait(0)
    end
    RopeLoadTextures()
    while not pump do
        Wait(0)
    end
    rope = AddRope(pump.x, pump.y, pump.z, 0.0, 0.0, 0.0, 3.0, 1, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not rope do
        Wait(0)
    end
    ActivatePhysics(rope)
    Wait(50)
    local nozzlePos = GetEntityCoords(nozzle)
    nozzlePos = GetOffsetFromEntityInWorldCoords(nozzle, 0.0, -0.033, -0.195)
    AttachEntitiesToRope(rope, pumpObject, nozzle, pump.x, pump.y, pump.z + 1.45, nozzlePos.x, nozzlePos.y, nozzlePos.z, 5.0, false, false, nil, nil)
end

local function StartFueling()
    isFueling = true
    local ped = VFW.PlayerData.ped
    TaskTurnPedToFaceEntity(ped, currentV, 1000)
    Wait(1000)
    grabNozzleFromPump()
    LoadAnimDict("timetable@gardener@filling_can")
    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    StartProgressBar()
end

local function OpenMenuFuel()
    local quantity = 0.0

    if currentV ~= nil then
        local maxFuel = GetVehicleHandlingFloat(currentV, "CHandlingData", "fPetrolTankVolume")
        local currentFuel = GetVehicleFuelLevel(currentV)
        quantity = maxFuel - currentFuel
        if quantity < 0.1 then
            quantity = 0
        end
    else
        quantity = 10.0
    end

    VFW.Nui.FuelMenu(true, {
        price = 2.00,
        quantity = VFW.Math.Round(quantity, 1),
    })
end

RegisterNuiCallback("nui:menu-ltd:close", function()
    VFW.Nui.FuelMenu(false)
end)

RegisterNuiCallback("nui:menu-ltd:submit", function(data)
    if not data then return end
    local getMoney = TriggerServerCallback("core:server:getFuelMoney", data.payment, VFW.Math.Round(data.volume * 2.00))

    if data.action == "plein" or data.action == "manuel" then
        if getMoney then
            VFW.Nui.FuelMenu(false)
            StartFueling()
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
        end
    elseif data.action == "bidon" then
        if getMoney then
            TriggerServerEvent("vfw:addPetrolCan")
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
        end
    end
end)

local fuelPoints = {}

CreateThread(function()
    while true do
        for _, entity in pairs(GetGamePool("CObject")) do
            local model = GetEntityModel(entity)
            local objectPos = GetEntityCoords(entity)

            if not fuelPoints[objectPos] then
                if Config.Features.Fuel.PumpModels[model] then
                    fuelPoints[objectPos] = Worlds.Zone.Create(vector3(objectPos.x, objectPos.y, objectPos.z + 1.5), 2, false, function()
                        VFW.RegisterInteraction("barber", function()
                            local playerCoords = GetEntityCoords(VFW.PlayerData.ped)
                            local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 71)

                            if vehicle == 0 then
                                currentV = nil
                            else
                                currentV = vehicle
                            end
                            ClearPedTasks(VFW.PlayerData.ped)
                            OpenMenuFuel()
                            activePump = entity
                        end)
                    end, function()
                        VFW.RemoveInteraction("barber")
                    end, "Station essence", "E", "Essence")
                end
            end
        end

        Wait(5000)
    end
end)

RegisterNetEvent("vfw:usePetrolCan", function()
    local essence = false
    local petrolCanHash = GetHashKey("weapon_petrolcan")
    local animDict = "weapon@w_sp_jerrycan"
    local animName = "fire"
    local playerPed = PlayerPedId()

    LoadAnimDict(animDict)

    while true do
        Wait(0)
        local _, hash = GetCurrentPedWeapon(playerPed)
        local isInVeh = IsPedInAnyVehicle(playerPed, false)

        if hash == petrolCanHash and not isInVeh then
            local pCoords = GetEntityCoords(playerPed)
            local vehicle, dst = VFW.Game.GetClosestVehicle(pCoords)

            if dst <= 3.0 then
                local tankCapacity = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
                local currentFuel = GetVehicleFuelLevel(vehicle)

                if currentFuel < tankCapacity then
                    VFW.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour mettre de l'essence")

                    if IsControlJustReleased(0, 38) then
                        essence = true

                        while essence and not isInVeh do
                            Wait(0)
                            currentFuel = GetVehicleFuelLevel(vehicle)

                            if currentFuel >= tankCapacity then
                                essence = false
                                break
                            end

                            if not IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
                                TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)
                            end

                            local fuelPercent = math.round((currentFuel * 100 / tankCapacity), 1)
                            VFW.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour stopper\nNiveau: ~o~"..fuelPercent.."~s~%")

                            SetVehicleFuelLevel(vehicle, currentFuel + 0.02)
                            DecorSetFloat(vehicle, "FUEL_LEVEL", GetVehicleFuelLevel(vehicle))

                            if IsControlJustReleased(0, 38) then
                                essence = false
                            end
                        end

                        ClearPedTasks(playerPed)
                        RemoveWeaponFromPed(playerPed, petrolCanHash)
                        TriggerServerEvent("vfw:removePetrolCan")

                        if GetVehicleFuelLevel(vehicle) >= tankCapacity then
                            VFW.ShowNotification({type = 'JAUNE', content = "Véhicule plein !"})
                        end
                    end
                else
                    RemoveWeaponFromPed(playerPed, petrolCanHash)
                    VFW.ShowNotification({type = 'JAUNE', content = "Véhicule déjà plein !"})
                end
            end
        end
    end
end)
