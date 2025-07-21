local function IsLookingAtCoords(x, y, z, tolerance)
    local camCoords = GetGameplayCamCoord()
    local direction = GetGameplayCamRot(2)
    local camForward = {
        x = -math.sin(math.rad(direction.z)) * math.abs(math.cos(math.rad(direction.x))),
        y = math.cos(math.rad(direction.z)) * math.abs(math.cos(math.rad(direction.x))),
        z = math.sin(math.rad(direction.x))
    }
    
    local targetVector = vector3(x - camCoords.x, y - camCoords.y, z - camCoords.z)
    local dotProduct = camForward.x * targetVector.x + camForward.y * targetVector.y + camForward.z * targetVector.z
    local targetMagnitude = math.sqrt(targetVector.x * targetVector.x + targetVector.y * targetVector.y + targetVector.z * targetVector.z)
    local camMagnitude = math.sqrt(camForward.x * camForward.x + camForward.y * camForward.y + camForward.z * camForward.z)
    
    local angle = math.acos(dotProduct / (targetMagnitude * camMagnitude)) * (180 / math.pi)
    
    if angle < tolerance then
        return true
    else
        return false
    end
end

CreateThread(function()
    local finished = false
    local sentNotif = false
    while (not VFW.PlayerData) do Wait(1000) end
    while true do
        Wait(500)
        if finished then Wait(7000) finished = false end
        if IsPedArmed(VFW.PlayerData.ped, 4) and (not finished) and IsPedOnFoot(VFW.PlayerData.ped) then
            local pool = GetGamePool("CVehicle")
            for i = 1, #pool do
                local veh = pool[i]
                local vehCoords = GetEntityCoords(veh)
                local distance = GetEntityCoords(VFW.PlayerData.ped) - vehCoords
                if #(distance) < 10 then
                    if (IsPlayerFreeAiming(PlayerId())) and IsLookingAtCoords(vehCoords.x, vehCoords.y, vehCoords.z, 30) and (GetPedInVehicleSeat(veh, -1) ~= 0) then
                        local ped = GetPedInVehicleSeat(veh, -1)
                        SetEntityAsMissionEntity(ped, true, true)
                        NetworkRequestControlOfEntity(ped)
                        local timer = 1
                        while (not NetworkHasControlOfEntity(ped)) and (timer < 150) do
                            Wait(1)
                            timer = timer + 1
                        end
                        SetEntityAsMissionEntity(ped, true, true)
                        local escapeChance = math.random(1, 3)
                        local hasPoliceJob = VFW.PlayerData.job.name == "lspd" or VFW.PlayerData.job.name == "lssd" or VFW.PlayerData.job.name == "usss"
                        if escapeChance <= 1 or (not hasPoliceJob) then
                            local coords = GetEntityCoords(veh)
                            if (not sentNotif) then
                                TriggerServerEvent('core:alert:makeCall', "lspd", coords, true, "Car-jacking à main armée", false, "illegal")
                                TriggerServerEvent('core:alert:makeCall', "lssd", coords, true, "Car-jacking à main armée", false, "illegal")
                                sentNotif = true
                            end
                            SetVehicleDoorsLocked(veh, 0)
                            SetVehicleDoorsLockedForAllPlayers(veh, false)
                            SetVehicleDoorsLockedForPlayer(veh, VFW.PlayerData.ped, false)
                            TaskLeaveVehicle(ped, veh, 1)
                            finished = true
                            Wait(50000)
                        else
                            Wait(3000)
                        end
                    end
                end
            end
        else
            Wait(5000)
        end
        sentNotif = false
    end
end)