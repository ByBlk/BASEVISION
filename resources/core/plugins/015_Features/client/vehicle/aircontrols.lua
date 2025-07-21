local VEHICLE_CLASS_DISABLE_CONTROL = {
    [0] = true,     -- compacts
    [1] = true,     -- sedans
    [2] = true,     -- SUVs
    [3] = true,     -- coupes
    [4] = true,     -- muscle
    [5] = true,     -- sport classic
    [6] = true,     -- sport 
    [7] = true,     -- super
    [8] = false,    -- motorcycle
    [9] = true,     -- offroad
    [10] = true,    -- industrial
    [11] = true,    -- utility
    [12] = true,    -- vans
    [13] = false,   -- bicycles
    [14] = false,   -- boats
    [15] = false,   -- helicopter
    [16] = false,   -- plane
    [17] = true,    -- service
    [18] = true,    -- emergency
    [19] = false    -- military
}

local ROAD_MATERIALS = {
    [0] = true, [1] = true, [3] = true, [4] = true,
    [5] = true, [7] = true, [12] = true, [13] = true,
    [15] = true, [56] = true, [64] = true, [70] = true
}

CreateThread(function()
    local timeInAir = 1
    
    while not VFW.IsPlayerLoaded() do Wait(100) end

    while true do
        Wait(1)
        local player = VFW.PlayerData.ped
        local vehicle = GetVehiclePedIsIn(player, false)

        if not vehicle then
            Wait(1000)
            local closestVehicle, distance = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped))

            if closestVehicle and distance < 3.5 then
                SetEntityAsMissionEntity(closestVehicle, true, true)
            end

            goto continue
        end

        local vehicleClass = GetVehicleClass(vehicle)

        if GetPedInVehicleSeat(vehicle, -1) ~= player or not VEHICLE_CLASS_DISABLE_CONTROL[vehicleClass] then
            Wait(1000)
            goto continue
        end

        if IsEntityInAir(vehicle) then
            DisableControlAction(2, 59) -- Left/right control
            DisableControlAction(2, 60) -- Up/down control
            timeInAir = timeInAir + 1
        else
            if timeInAir > 90 then
                Wait(200)

                if IsVehicleOnAllWheels(vehicle) then
                    local randomWheel = math.random(0, 1)
                    local materialId = GetVehicleWheelSurfaceMaterial(vehicle, randomWheel)

                    if ROAD_MATERIALS[materialId] then
                        if timeInAir > 120 or (timeInAir > 90 and math.random(0, 1) == 0) then
                            SetVehicleTyreBurst(vehicle, randomWheel, false, 1000.0)
                        end
                    end
                end
            end

            timeInAir = 1
            Wait(200)
        end

        ::continue::
    end
end)
