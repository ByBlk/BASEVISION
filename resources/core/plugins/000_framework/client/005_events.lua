VFW.Items = {}

RegisterNetEvent("vfw:requestModel", function(model)
    VFW.Streaming.RequestModel(model)
end)

RegisterNetEvent("vfw:client:playerLoaded", function(xPlayer, isNew, skin)
    --VFW.PlayerData = xPlayer

    --if not Config.Multichar then
    --    VFW.SpawnPlayer(skin, VFW.PlayerData.coords, function()
    --        TriggerEvent("vfw:onPlayerLoaded")
    --        TriggerEvent("vfw:restoreLoadout")
    --        TriggerServerEvent("vfw:onPlayerLoaded")
    --        ShutdownLoadingScreen()
    --        ShutdownLoadingScreenNui()
    --    end)
    --
    --    if isNew then
    --        TriggerEvent("vfw:charCreator")
    --    end
    --end

    while not DoesEntityExist(VFW.PlayerData.ped) do
        Wait(20)
    end

    VFW.PlayerLoaded = true

    local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(VFW.PlayerData.ped) and
            (GetGameTimer() - timer) < 2000 do
        Wait(0)
    end

    Adjustments:Load()

    ClearPedTasksImmediately(VFW.PlayerData.ped)

    if not Config.Multichar then
        Core.FreezePlayer(false)
    end

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end

    Actions:Init()
    Worlds.Zone.StartLoop()
    --StartServerSyncLoops()
    NetworkSetLocalPlayerSyncLookAt(true)
    SetTimeout(500, function()
        TriggerEvent("LoadHud")
        TriggerServerEvent("core:server:loadedLocation")
        ClearPedDecorations(VFW.PlayerData.ped)
        for _, tattoo in pairs(VFW.PlayerData.tattoos) do
            ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(tattoo.Collection), GetHashKey(tattoo.Hash))
        end
        local walk = GetResourceKvpString("walkstyle")
        if walk ~= nil then
            RequestWalking(walk)
            SetPedMovementClipset(VFW.PlayerData.ped, walk, 0.2)
            RemoveAnimSet(walk)
        end
        local expression = GetResourceKvpString("expression")
        if expression ~= nil then
            SetFacialIdleAnimOverride(VFW.PlayerData.ped, expression, 0)
        end
        TriggerServerEvent("core:sync:onPlayerJoined")
        if VFW.PlayerData.metadata.cuffState then
            TriggerEvent("handcuff:client:setHandcuff", VFW.PlayerData.metadata.cuffState.isCuffed)
        end
        TriggerServerEvent("core:playerTimer:start")
        TriggerServerEvent("core:antitroll:load")
        TriggerServerEvent("jail:load")
        TriggerEvent("vfw:playerReady", VFW.PlayerData)
        TriggerServerEvent("vfw:sellDrugs:Loaded")
    end)

    console.debug("Player Loaded")
end)

local isFirstSpawn = true
RegisterNetEvent("vfw:onPlayerLogout", function()
    VFW.PlayerLoaded = false
    isFirstSpawn = true
end)

RegisterNetEvent("vfw:setMaxWeight", function(newMaxWeight)
    VFW.SetPlayerData("maxWeight", newMaxWeight)
end)

local function onPlayerSpawn()
    VFW.SetPlayerData("ped", PlayerPedId())
    VFW.SetPlayerData("dead", false)
end

AddEventHandler("playerSpawned", onPlayerSpawn)
AddEventHandler("vfw:onPlayerLoaded", function()
    onPlayerSpawn()

    if isFirstSpawn then
        isFirstSpawn = false

        if VFW.PlayerData.metadata.health and
                (VFW.PlayerData.metadata.health > 0 or Config.SaveDeathStatus) then
            SetEntityHealth(VFW.PlayerData.ped, VFW.PlayerData.metadata.health)
        end

        --if VFW.PlayerData.metadata.armor and VFW.PlayerData.metadata.armor > 0 then
        --    SetPedArmour(VFW.PlayerData.ped, VFW.PlayerData.metadata.armor)
        --end
    end
end)

AddEventHandler("vfw:onPlayerDeath", function()
    VFW.SetPlayerData("ped", PlayerPedId())
    VFW.SetPlayerData("dead", true)
end)

AddEventHandler("skinchanger:modelLoaded", function()
    while not VFW.PlayerLoaded do
        Wait(100)
    end
    TriggerEvent("vfw:restoreLoadout")
end)

AddEventHandler("vfw:restoreLoadout", function()
    VFW.SetPlayerData("ped", PlayerPedId())
end)

---@diagnostic disable-next-line: param-type-mismatch
AddStateBagChangeHandler("VehicleProperties", nil, function(bagName, _, value)
    if not value then
        return
    end

    bagName = bagName:gsub("entity:", "")
    local netId = tonumber(bagName)
    if not netId then
        error("Tried to set vehicle properties with invalid netId")
        return
    end

    local vehicle = NetToVeh(netId)

    local tries = 0
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        Wait(200)
        tries = tries + 1
        if tries > 20 then
            return error(("Invalid entity - ^3%s^7!"):format(netId))
        end
    end

    if NetworkGetEntityOwner(vehicle) ~= VFW.playerId then
        return
    end

    VFW.Game.SetVehicleProperties(vehicle, value)
end)

RegisterNetEvent("vfw:setAccountMoney", function(account)
    for i = 1, #VFW.PlayerData.accounts do
        if VFW.PlayerData.accounts[i].name == account.name then
            VFW.PlayerData.accounts[i] = account
            break
        end
    end

    VFW.SetPlayerData("accounts", VFW.PlayerData.accounts)
end)

RegisterNetEvent("vfw:addInventoryItem", function(item, count, showNotification)
    for k, v in ipairs(VFW.PlayerData.inventory) do
        if v.name == item then
            VFW.PlayerData.inventory[k].count = count
            break
        end
    end
end)

RegisterNetEvent("vfw:removeInventoryItem", function(item, count, showNotification)
    for i = 1, #VFW.PlayerData.inventory do
        if VFW.PlayerData.inventory[i].name == item then
            VFW.PlayerData.inventory[i].count = count
            break
        end
    end
end)

RegisterNetEvent("vfw:addWeapon", function()
    error("event ^3'vfw:addWeapon'^1 Has Been Removed. Please use ^3xPlayer.addWeapon^1 Instead!")
end)

RegisterNetEvent("vfw:addWeaponComponent", function()
    error("event ^3'vfw:addWeaponComponent'^1 Has Been Removed. Please use ^3xPlayer.addWeaponComponent^1 Instead!")
end)

RegisterNetEvent("vfw:setWeaponAmmo", function()
    error("event ^3'vfw:setWeaponAmmo'^1 Has Been Removed. Please use ^3xPlayer.addWeaponAmmo^1 Instead!")
end)

RegisterNetEvent("vfw:setWeaponTint", function(weapon, weaponTintIndex)
    SetPedWeaponTintIndex(VFW.PlayerData.ped, weapon, weaponTintIndex)
end)

RegisterNetEvent("vfw:removeWeapon", function()
    error("event ^3'vfw:removeWeapon'^1 Has Been Removed. Please use ^3xPlayer.removeWeapon^1 Instead!")
end)

RegisterNetEvent("vfw:removeWeaponComponent", function(weapon, weaponComponent)
    local componentHash = VFW.GetWeaponComponent(weapon, weaponComponent).hash
    RemoveWeaponComponentFromPed(VFW.PlayerData.ped, joaat(weapon), componentHash)
end)

RegisterNetEvent("vfw:setFaction", function(Faction)
    VFW.SetPlayerData("faction", Faction)
end)

RegisterNetEvent("vfw:setGroup", function(group)
    VFW.SetPlayerData("group", group)
end)

RegisterNetEvent("vfw:loadItems", function(items)
    VFW.Items = items
end)

RegisterNetEvent("vfw:items:update", function(items)
    for k, v in pairs(items) do
        VFW.Items[k] = v
    end
end)

-- function StartServerSyncLoops()
--     if Config.CustomInventory then return end

--     local currentWeapon = {
--         ---@type number
--         ---@diagnostic disable-next-line: assign-type-mismatch
--         hash = WEAPON_UNARMED,
--         ammo = 0
--     }

--     local function updateCurrentWeaponAmmo(weaponName)
--         local newAmmo = GetAmmoInPedWeapon(VFW.PlayerData.ped,
--                                            currentWeapon.hash)

--         if newAmmo ~= currentWeapon.ammo then
--             currentWeapon.ammo = newAmmo
--             TriggerServerEvent("vfw:updateWeaponAmmo", weaponName, newAmmo)
--         end
--     end

--     CreateThread(function()
--         while VFW.PlayerLoaded do
--             currentWeapon.hash = GetSelectedPedWeapon(VFW.PlayerData.ped)

--             if currentWeapon.hash ~= WEAPON_UNARMED then
--                 local weaponConfig = VFW.GetWeaponFromHash(currentWeapon.hash)

--                 if weaponConfig then
--                     currentWeapon.ammo =
--                         GetAmmoInPedWeapon(VFW.PlayerData.ped,
--                                            currentWeapon.hash)

--                     while GetSelectedPedWeapon(VFW.PlayerData.ped) ==
--                         currentWeapon.hash do
--                         updateCurrentWeaponAmmo(weaponConfig.name)
--                         Wait(1000)
--                     end

--                     updateCurrentWeaponAmmo(weaponConfig.name)
--                 end
--             end
--             Wait(250)
--         end
--     end)

--     CreateThread(function()
--         local PARACHUTE_OPENING<const> = 1
--         local PARACHUTE_OPEN<const> = 2

--         while VFW.PlayerLoaded do
--             local parachuteState = GetPedParachuteState(VFW.PlayerData.ped)

--             if parachuteState == PARACHUTE_OPENING or parachuteState ==
--                 PARACHUTE_OPEN then
--                 TriggerServerEvent("vfw:updateWeaponAmmo", "GADGET_PARACHUTE", 0)

--                 while GetPedParachuteState(VFW.PlayerData.ped) ~= -1 do
--                     Wait(1000)
--                 end
--             end
--             Wait(500)
--         end
--     end)
-- end

RegisterNetEvent("vfw:tpm", function()
    local GetEntityCoords = GetEntityCoords
    local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
    local GetFirstBlipInfoId = GetFirstBlipInfoId
    local DoesBlipExist = DoesBlipExist
    local DoScreenFadeOut = DoScreenFadeOut
    local GetBlipInfoIdCoord = GetBlipInfoIdCoord
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local blipMarker = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blipMarker) then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Aucun point n'est défini sur la carte"
        })
        return "marker"
    end

    -- Fade screen to hide how clients get teleported.
    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped, coords = VFW.PlayerData.ped, GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords = GetEntityCoords(ped)

    -- Unpack coords instead of having to unpack them while iterating.
    -- 825.0 seems to be the max a player can reach while 0.0 being the lowest.
    local x, y, groundZ, Z_START = coords["x"], coords["y"], 850.0, 950.0
    local found = false
    FreezeEntityPosition(vehicle > 0 and vehicle or ped, true)

    for i = Z_START, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = Z_START - i
        end

        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() do
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end
        NewLoadSceneStop()
        SetPedCoordsKeepVehicle(ped, x, y, z)

        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end

        -- Get ground coord. As mentioned in the natives, this only works if the client is in render distance.
        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
        if found then
            Wait(0)
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end
        Wait(0)
    end

    -- Remove black screen once the loop has ended.
    DoScreenFadeIn(650)
    FreezeEntityPosition(vehicle > 0 and vehicle or ped, false)

    if not found then
        -- If we can't find the coords, set the coords to the old ones.
        -- We don't unpack them before since they aren't in a loop and only called once.
        SetPedCoordsKeepVehicle(ped, oldCoords["x"], oldCoords["y"],
                oldCoords["z"] - 1.0)
        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous avez bien été téléporté"
        })
    end

    -- If Z coord was found, set coords in found coords.
    SetPedCoordsKeepVehicle(ped, x, y, groundZ)
    VFW.ShowNotification({
        type = 'VERT',
        content = "Vous avez bien été téléporté"
    })
end)

RegisterNetEvent("vfw:killPlayer", function()
    SetEntityHealth(VFW.PlayerData.ped, 0)
end)

RegisterNetEvent("vfw:repairPedVehicle", function()
    local ped = VFW.PlayerData.ped
    local vehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0)
end)

RegisterClientCallback("vfw:GetVehicleType", function(model)
    return VFW.GetVehicleTypeClient(model)
end)

RegisterNetEvent('vfw:updatePlayerData', function(key, val)
    VFW.SetPlayerData(key, val)
end)

AddEventHandler("onResourceStop", function(resource)
    if Core.Events[resource] then
        for i = 1, #Core.Events[resource] do
            RemoveEventHandler(Core.Events[resource][i])
        end
    end
end)

RegisterNetEvent('vfw:updatePlayerGlobalData', function(data)
    VFW.PlayerGlobalData = data
end)

RegisterNetEvent('vfw:upgrade', function()
    local ped = VFW.PlayerData.ped
    local vehicle = GetVehiclePedIsIn(ped, false)

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
end)

RegisterNetEvent('vfw:setcarcolor', function(color_1, color_2)
    local ped = VFW.PlayerData.ped
    local vehicle = GetVehiclePedIsIn(ped, false)

    SetVehicleModKit(vehicle, 0)
    SetVehicleColours(vehicle, tonumber(color_1), tonumber(color_2))
end)
