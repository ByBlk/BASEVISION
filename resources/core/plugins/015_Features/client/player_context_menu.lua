VFW.ContextAddInfo("ped", "ID Joueur", function(ped)
    return IsPedAPlayer(ped)
end, function(ped)
    return Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state.id
end)

local isCursorActive = false
local isAdjustingAnimation = false

-- VFW.ContextAddButton("ped", "Ajuster l'animation", function(ped)
--     local isPlayer = NetworkGetPlayerIndexFromPed(ped)
--     local pId = GetPlayerServerId(isPlayer)
--     local source = GetPlayerServerId(PlayerId())
--     return IsPedAPlayer(ped) and (pId == source)
-- end, function(ped)
--     local function AdjustAnimationWithGizmo(targetPed)
--         if isAdjustingAnimation then
--             VFW.ShowNotification({
--                 type = 'error',
--                 content = "Un ajustement d'animation est déjà en cours"
--             })
--             return
--         end

--         local currentAnim = GetPlayingEmote()
--         if not currentAnim then
--             VFW.ShowNotification({
--                 type = 'error',
--                 content = "Aucune animation en cours à ajuster"
--             })
--             return
--         end

--         isAdjustingAnimation = true

--         VFW.ShowNotification({
--             type = 'info',
--             content = "Mode ajustement activé - Zone limitée visible~n~Distance max: 10m"
--         })

--         local MAX_DISTANCE = 5.0
--         local savedAnimDict = currentAnim.dict
--         local savedAnimName = currentAnim.anim
--         local initialCoords = GetEntityCoords(targetPed)
--         local playerHeading = GetEntityHeading(targetPed)
--         local playerModel = GetEntityModel(targetPed)

--         RequestModel(playerModel)
--         while not HasModelLoaded(playerModel) do
--             Wait(10)
--         end

--         local clonePed = CreatePed(4, playerModel, initialCoords.x, initialCoords.y, initialCoords.z, playerHeading,
--             false, true)
--         SetEntityAlpha(clonePed, 150)
--         SetEntityCollision(clonePed, false, false)
--         FreezeEntityPosition(clonePed, true)
--         SetEntityInvincible(clonePed, true)
--         SetBlockingOfNonTemporaryEvents(clonePed, true)

--         ClonePedToTarget(targetPed, clonePed)

--         if savedAnimDict and savedAnimName then
--             RequestAnimDict(savedAnimDict)
--             while not HasAnimDictLoaded(savedAnimDict) do
--                 Wait(10)
--             end
--             TaskPlayAnim(clonePed, savedAnimDict, savedAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)
--         end

--         local distanceCheckActive = true
--         local showMarker = true -- Variable pour contrôler l'affichage du marker

--         CreateThread(function()
--             while distanceCheckActive do
--                 Wait(0)

--                 if IsControlJustPressed(0, 38) then 
--                     showMarker = not showMarker
--                     VFW.ShowNotification({
--                         type = 'info',
--                         content = showMarker and "Zone de sécurité affichée" or "Zone de sécurité masquée"
--                     })
--                 end

--                 -- Dessiner la sphère de sécurité visible seulement si showMarker est true
--                 if showMarker then
--                     DrawMarker(28, initialCoords.x, initialCoords.y, initialCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
--                         MAX_DISTANCE * 2, MAX_DISTANCE * 2, MAX_DISTANCE * 2, 255, 0, 0, 50, false, true, 2, false, nil,
--                         nil, false)
--                 end

--                 if DoesEntityExist(clonePed) then
--                     local cloneCoords = GetEntityCoords(clonePed)

--                     local distance = #(initialCoords - cloneCoords)

--                     if distance > MAX_DISTANCE then
--                         local direction = (cloneCoords - initialCoords) / distance
--                         local maxCoords = initialCoords + (direction * MAX_DISTANCE)

--                         local groundZ, foundGround = GetGroundZFor_3dCoord(maxCoords.x, maxCoords.y, maxCoords.z + 10.0,
--                             false)
--                         if foundGround then
--                             maxCoords = vector3(maxCoords.x, maxCoords.y, groundZ)
--                         end

--                         SetEntityCoords(clonePed, maxCoords.x, maxCoords.y, maxCoords.z, false, false, false, true)
--                     end
--                 end
--             end
--         end)

--         if GetResourceState('object_gizmo') == 'started' then
--             SendNUIMessage({
--                 action = "nui:weather-time:visible",
--                 data = {
--                     visible = false
--                 }
--             })
--             local gizmoResult = exports['object_gizmo']:useGizmo(clonePed)
--             distanceCheckActive = false
--             if gizmoResult then
--                 TriggerEvent("VFW:Create:InfoKeys", false)
--                 local testZ = gizmoResult.position.z + 1.0 -- pour éviter faux positifs
--                 local hasGround, groundZ = GetGroundZFor_3dCoord(gizmoResult.position.x, gizmoResult.position.y, testZ,
--                     false)

--                 if not hasGround or gizmoResult.position.z < groundZ - 1.0 then
--                     VFW.ShowNotification({
--                         type = 'error',
--                         content = "Impossible de placer l'animation dans le vide."
--                     })
--                 else
--                     SetEntityCoordsNoOffset(targetPed, gizmoResult.position.x, gizmoResult.position.y,
--                         gizmoResult.position.z, false, false, false)
--                     SetEntityRotation(targetPed, gizmoResult.rotation.x, gizmoResult.rotation.y, gizmoResult.rotation.z,
--                         2, true)

--                     Wait(100)

--                     if savedAnimDict and savedAnimName then
--                         RequestAnimDict(savedAnimDict)
--                         while not HasAnimDictLoaded(savedAnimDict) do
--                             Wait(10)
--                         end
--                         TaskPlayAnim(targetPed, savedAnimDict, savedAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)
--                     end

--                     VFW.ShowNotification({
--                         type = 'success',
--                         content = "Position de l'animation ajustée avec succès"
--                     })
--                 end
--             end
--         else
--             distanceCheckActive = false
--             VFW.ShowNotification({
--                 type = 'error',
--                 content = "Le système de gizmo n'est pas disponible"
--             })
--         end

--         if DoesEntityExist(clonePed) then
--             DeleteEntity(clonePed)
--         end
--         SetModelAsNoLongerNeeded(playerModel)
--         isAdjustingAnimation = false
--     end

--     AdjustAnimationWithGizmo(ped)
-- end)

VFW.ContextAddButton("ped", "Faire une facture", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and isSamePlayer
end, function(ped)

end, {}, nil)

VFW.ContextAddButton("ped", "Copier l'emote", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    VFW.CopyAnimations(playerId)
end, {}, nil)

VFW.ContextAddButton("ped", "Partager l'emote", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    TriggerServerEvent("vfw:anim:sharedContext", playerId)
end, {}, nil)


local function IsPlayerHandsUp(ped)
    return IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3)
end

VFW.ContextAddButton("ped", "Fouiller", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    local hasFaction = VFW.PlayerData.faction and VFW.PlayerData.faction.name ~= "nocrew"
    local handsUp = IsPlayerHandsUp(ped)
    return IsPedAPlayer(ped) and isSamePlayer and hasFaction and handsUp
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    VFW.OpenShearch(playerId)
end, {}, nil)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {
            handle = iter,
            destructor = disposeFunc
        }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function GetEntity()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

VFW.ContextAddButton("ped", "Détacher l'objet", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId == source
    return IsPedAPlayer(ped) and isSamePlayer
end, function(ped)
    local playerPosition = GetEntityCoords(ped)

    for object in GetEntity() do
        if object and DoesEntityExist(object) and IsEntityAttached(object) and
            GetDistanceBetweenCoords(GetEntityCoords(object), playerPosition) <= 1.5 then
            DeleteEntity(object)
        end
    end

    local entity = GetEntityAttachedTo(VFW.PlayerData.ped)

    if entity ~= 0 then
        if IsEntityAttachedToAnyObject(VFW.PlayerData.ped) then
            DetachEntity(entity)
            DeleteEntity(entity)
        end
    end
end, {}, nil)

local melee = false

VFW.ContextAddButton("ped", "Désactiver le combat", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId == source
    return IsPedAPlayer(ped) and isSamePlayer
end, function(ped)
    melee = not melee
    if melee then
        VFW.ShowNotification({
            type = 'JAUNE',
            content = "Combat ~s désactivé"
        })
    else
        VFW.ShowNotification({
            type = 'JAUNE',
            content = "Combat ~s activé"
        })
    end
    while melee do
        Wait(0)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
    end
end, {}, nil)

RegisterNetEvent("VFW:Create:InfoKeys")
AddEventHandler("VFW:Create:InfoKeys", function(bool, data)
    VFW.InfoKey.Create(bool, data)
end)
