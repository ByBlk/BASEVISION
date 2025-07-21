function HackAnimation(ignoreminigame)
    local HasReceivedResponse = nil
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local animDict = "anim@heists@ornate_bank@hack"
    local props = "hei_prop_hst_laptop"

    RequestAnimDict(animDict)
    RequestModel(props)

    while not HasAnimDictLoaded(animDict) or not HasModelLoaded(props) do
        Citizen.Wait(10)
    end

    local targetPosition, targetRotation = vec3(plyPos.x, plyPos.y, plyPos.z+0.8), GetEntityRotation(plyPed)
    local laptop = CreateObject(GetHashKey(props), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)

    local netScene = NetworkCreateSynchronisedScene(targetPosition - vector3(0.0, 0.0, 0.4), targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(plyPed, netScene, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(netScene)

    Wait(5000)

    if not ignoreminigame then
        TriggerEvent("datacrack:start", 4.5, function(output)
            if output == true then
                HasReceivedResponse = true
            else
                returHasReceivedResponse = false
            end
            setUsingComputer(false)
            NetworkStopSynchronisedScene(netScene)
        end)
    else
        HasReceivedResponse = true
    end

    DeleteEntity(laptop)

    while HasReceivedResponse == nil do
        Wait(1)
    end

    return HasReceivedResponse
end
