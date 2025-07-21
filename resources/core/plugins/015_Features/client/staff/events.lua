RegisterNetEvent("core:staff:gestion", function()
    VFW.Gestion()
end)

RegisterNetEvent("core:staff:noclip", function()
    VFW.ToggleNoclip()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= "core") then
        return
    end
    VFW.ToggleNoclip(false)
end)

RegisterNetEvent("core:StaffSpectate", function(coords, id, isSpectating)
    if isSpectating then
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(VFW.PlayerData.ped) do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            Wait(0)
        end
        SetEntityVisible(VFW.PlayerData.ped, false)
        SetEntityCollision(VFW.PlayerData.ped, false, true)
        SetEntityCoords(VFW.PlayerData.ped, coords.x, coords.y, coords.z)
        Wait(500)
        NetworkSetInSpectatorMode(true, GetPlayerPed(GetPlayerFromServerId(id)))
    else
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(VFW.PlayerData.ped) do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            Wait(0)
        end
        NetworkSetInSpectatorMode(false, GetPlayerPed(GetPlayerFromServerId(id)))
        SetEntityCoords(VFW.PlayerData.ped, coords.x, coords.y, coords.z)
        SetEntityCollision(VFW.PlayerData.ped, true, true)
        SetEntityVisible(VFW.PlayerData.ped, true)
    end
end)

RegisterNetEvent("core:FreezePlayer", function(staut)
    FreezeEntityPosition(VFW.PlayerData.ped, staut)
end)

RegisterNetEvent("core:client:setped", function(ped)
    RequestModel(ped)
    while not HasModelLoaded(ped) do Wait(1) end
    if IsModelInCdimage(ped) and IsModelValid(ped) then
        SetPlayerModel(PlayerId(), ped)
        SetPedDefaultComponentVariation(ped)
    end
    SetModelAsNoLongerNeeded(ped)
end)

RegisterNetEvent("core:client:unsetped", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    local ped = "mp_m_freemode_01"

    if skin.sex == 1 then
        ped = "mp_f_freemode_01"
    elseif skin.sex > 1 then
        ped = Config.PedsCharCreator[skin.sex - 1]
    end

    RequestModel(ped)
    while not HasModelLoaded(ped) do Wait(1) end
    if IsModelInCdimage(ped) and IsModelValid(ped) then
        SetPlayerModel(PlayerId(), ped)
        SetPedDefaultComponentVariation(ped)
    end
    SetModelAsNoLongerNeeded(ped)

    TriggerEvent('skinchanger:loadSkin', skin or {})
end)

RegisterNetEvent("vfw:staff:teleportToReport", function(targetCoords)

    if not targetCoords then return end

    local wasInNoclip = VFW.IsNoclipActive()
    
    if not wasInNoclip then
        VFW.ToggleNoclip()
        Wait(100)
    end
    SetEntityCoords(VFW.PlayerData.ped, targetCoords.x, targetCoords.y, targetCoords.z + 2.0)
end)
