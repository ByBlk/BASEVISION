RegisterKeyMapping("conducteur", "Place Conducteur", "keyboard", "NUMPAD7")
RegisterKeyMapping("passager", "Place Passager", "keyboard", "NUMPAD9")
RegisterKeyMapping("arrieregauche", "Place Arrière Gauche", "keyboard", "NUMPAD1")
RegisterKeyMapping("arrieredroite", "Place Arrière Droite", "keyboard", "NUMPAD3")

RegisterCommand("conducteur", function()
    local plyPed = VFW.PlayerData.ped
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 3.6

    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, -1)
        end
    end
end)

RegisterCommand("passager", function()
    local plyPed = VFW.PlayerData.ped
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 3.6

    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 0)
        end
    end
end)

RegisterCommand("arrieregauche", function()
    local plyPed = VFW.PlayerData.ped
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 3.6

    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 1)
        end
    end
end)

RegisterCommand("arrieredroite", function()
    local plyPed = VFW.PlayerData.ped
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 3.6

    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 2)
        end
    end
end)
