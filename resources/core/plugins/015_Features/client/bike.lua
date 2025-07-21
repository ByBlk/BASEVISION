RegisterNetEvent("core:client:UseBike")
AddEventHandler("core:client:UseBike", function(props)
    VFW.Game.SpawnVehicle(GetHashKey(props), vector3(GetEntityCoords(VFW.PlayerData.ped)), GetEntityHeading(VFW.PlayerData.ped), function(vehicle)
        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, vehicle, -1)
    end)
end)

local function taskTakeBike(target)
    local ped = VFW.PlayerData.ped

    if IsPedOnFoot(ped) then
        local vehicleHash = GetEntityModel(target)

        if IsThisModelABike(vehicleHash) then
            local playerCoords = GetEntityCoords(ped)
            local vehicleCoords = GetEntityCoords(target)
            local distance = #(playerCoords - vehicleCoords)

            if distance <= 5.0 then
                VFW.Streaming.RequestAnimDict("pickup_object")

                if AreAnyVehicleSeatsFree(target) and GetPedInVehicleSeat(target, -1) == 0 then
                    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)

                    TriggerServerEvent("core:server:buySkate", "bike", {
                        renamed = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(target))),
                        name = GetDisplayNameFromVehicleModel(GetEntityModel(target))
                    })
                    
                    TriggerServerEvent("core:server:pickupBike", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(target))))

                    RemoveAnimDict("pickup_object")
                    DeleteEntity(target)
                end
            end
        else
            console.debug("action impossible, tu peux avoir que un seul vélo")
        end
    else
        console.debug("impossible de prendre le vélo car tu est déjà sur un vélo")
    end
end

local allowedModels = {
    [joaat("cruiser")] = true,
    [joaat("bmx")] = true,
    [joaat("fixter")] = true,
    [joaat("scorcher")] = true,
    [joaat("tribike")] = true,
    [joaat("tribike2")] = true,
    [joaat("tribike3")] = true
}

VFW.ContextAddButton("vehicle", "Prendre le vélo", function(vehicle)
    return allowedModels[GetEntityModel(vehicle)]
end, function(vehicle)
    taskTakeBike(vehicle)
end)
