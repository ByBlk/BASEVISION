local staffSubmenu = VFW.ContextAddSubmenu("vehicle", "Action Staff", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end , {  color = {255, 64, 64}}, nil)

VFW.ContextAddInfo("vehicle", "Nom", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(vehicle)
    return GetEntityArchetypeName(vehicle)
end, {}, staffSubmenu)

local submenuEnter = VFW.ContextAddSubmenu("vehicle", "Entrer dans un siège", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end , {}, staffSubmenu)

for i = -1, GetVehicleMaxNumberOfPassengers(hitEntity), 1 do
    VFW.ContextAddButton("vehicle", "Siège " .. i, function(vehicle)
        return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
    end, function(vehicle)
        if IsVehicleSeatFree(vehicle, i) then
            TaskWarpPedIntoVehicle(VFW.PlayerData.ped, vehicle, i)
        end
    end, {}, submenuEnter)
end

VFW.ContextAddButton("vehicle", "Vérrouiller", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(vehicle)
    if GetVehicleDoorLockStatus(vehicle) <= 1 then
        NetworkRequestControlOfEntity(vehicle)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
        SetVehicleUndriveable(vehicle, false)
    else
        NetworkRequestControlOfEntity(vehicle)
        SetVehicleDoorsLocked(vehicle, 0)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        SetVehicleUndriveable(vehicle, true)
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("vehicle", "Réparer", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(vehicle)
    SetVehicleFixed(vehicle)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
end, {}, staffSubmenu)

VFW.ContextAddButton("vehicle", "Upgrade", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(vehicle)
    SetVehicleModKit(vehicle, 0)
    for i = 0, 49 do
        if i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 and i ~= 15 and i ~= 18 and i ~= 22 and i ~= 23 and i ~= 24 then
            local max = GetNumVehicleMods(vehicle, i) - 1
            if max > 0 then
                SetVehicleMod(vehicle, i, math.random(0, max), true)
            end
        end
    end
    for i = 11, 15 do
        local max = GetNumVehicleMods(vehicle, i) - 1
        SetVehicleMod(vehicle, i, max, true)
    end
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 22, true)
end, {}, staffSubmenu)

VFW.ContextAddButton("vehicle", "Supprimer l'entité", function(vehicle)
    return DoesEntityExist(vehicle) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(vehicle)
    DeleteEntity(vehicle)
end, {}, staffSubmenu)
