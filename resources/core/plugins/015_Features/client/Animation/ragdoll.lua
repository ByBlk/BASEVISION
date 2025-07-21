local isRagdolling = true
RegisterCommand('+ragdoll', function()
    if not IsPedOnFoot(VFW.PlayerData.ped) then return end

    isRagdolling = not isRagdolling

    while not isRagdolling do
        ped = PlayerPedId()
        SetPedRagdollForceFall(VFW.PlayerData.ped)
        ResetPedRagdollTimer(VFW.PlayerData.ped)
        SetPedToRagdoll(VFW.PlayerData.ped, 1000, 1000, 3, false, false, false)
        ResetPedRagdollTimer(VFW.PlayerData.ped)
        Wait(0)
    end
end, false)
RegisterKeyMapping('+ragdoll', "Ragdoll", 'keyboard', 'j')