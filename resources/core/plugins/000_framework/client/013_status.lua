CreateThread(function()
    while not VFW.IsPlayerLoaded() or VFW.PlayerData == nil do
        Wait(100)
    end
    local thirstDecayRate = 1
    local thirstRunMultiplier = 2
    local hungerDecayRate = 1
    local hungerRunMultiplier = 2
    local criticalThresholds = {25, 20, 15, 10, 5}
    while true do
        Wait(5 * 60000)
        local playerData = VFW.PlayerData
        local ped = playerData.ped
        local metadata = playerData.metadata
        if metadata.thirst <= 0 or metadata.hunger <= 0 then
            while (metadata.thirst <= 0 or metadata.hunger <= 0) and GetEntityHealth(ped) > 0 do
                SetEntityHealth(ped, GetEntityHealth(ped) - 1)
                Wait(1000)
            end
        end
        if metadata.thirst > 0 then
            local thirstLoss = IsPedRunning(PlayerPedId()) and thirstDecayRate * thirstRunMultiplier or thirstDecayRate
            metadata.thirst = math.max(0, VFW.Math.Round(metadata.thirst - thirstLoss))
        end
        if metadata.hunger > 0 then
            local hungerLoss = IsPedRunning(PlayerPedId()) and hungerDecayRate * hungerRunMultiplier or hungerDecayRate
            metadata.hunger = math.max(0, VFW.Math.Round(metadata.hunger - hungerLoss))
        end
        for _, threshold in ipairs(criticalThresholds) do
            if metadata.hunger == threshold then
                VFW.ShowNotification({ type = 'JAUNE', content = "Votre personnage a ~c faim ~s !" })
            end
            if metadata.thirst == threshold then
                VFW.ShowNotification({ type = 'JAUNE', content = "Votre personnage a ~c soif ~s !" })
            end
        end
        console.debug("Mise à jour statut - Soif : " .. metadata.thirst .. " | Faim : " .. metadata.hunger)
        TriggerServerEvent("vfw:status:update", metadata.thirst, metadata.hunger)
    end
end)

RegisterNetEvent("vfw:eat", function(itemName)
    local propHash = GetHashKey(VFW.Items[itemName].data.prop) or 'prop_ld_flow_bottle'
    VFW.Streaming.RequestModel(propHash)

    local playerPos = GetEntityCoords(VFW.PlayerData.ped)
    local boneIndex = GetPedBoneIndex(VFW.PlayerData.ped, 18905)

    local prop = CreateObject(propHash, playerPos.x, playerPos.y, playerPos.z+.2, true, true, true)
    SetEntityCollision(prop, false, false)
    AttachEntityToEntity(prop, VFW.PlayerData.ped, boneIndex, 0.12, 0.008, 0.03, 72.0, 60.0, 160.0, true, false, false, true, 1, true)

    local animDict = "mp_player_intdrink"
    local animName = "loop_bottle"
    if VFW.Items[itemName].data.anim == "eat" then
        animDict = "mp_player_inteat@burger"
        animName = "mp_player_int_eat_burger"
    end
    VFW.Streaming.RequestAnimDict(animDict)
    TaskPlayAnim(VFW.PlayerData.ped, animDict, animName, 2.0, 2.0, 6000, 49, 0, 0, 0, 0)
    Wait((GetAnimDuration(animDict, animName) * 1000) + 2200)
    DeleteObject(prop)
    RemoveAnimDict(animDict)
    SetModelAsNoLongerNeeded(propHash)
end)