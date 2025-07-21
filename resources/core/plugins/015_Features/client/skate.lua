local skating = {}
local player = nil
local connected = false
local maxSpeedKmh = 40
local maxJumpHeigh = 5.0
local loseConnectionDistance = 2.0

RegisterNetEvent("astudios-skating:client:start", function() skating.Start() end)

skating.Start = function()
    if DoesEntityExist(skating.Entities) then return end skating.Spawn()
    while DoesEntityExist(skating.Entities) and DoesEntityExist(skating.Player) do Wait(5)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(skating.Entities), true) skating.HandleKeys(distance)
        if distance <= loseConnectionDistance then
            if not NetworkHasControlOfEntity(skating.Player) then
                NetworkRequestControlOfEntity(skating.Player)
            elseif not NetworkHasControlOfEntity(skating.Entities) then
                NetworkRequestControlOfEntity(skating.Entities)
            end
        else
            TaskVehicleTempAction(skating.Player, skating.Entities, 6, 2500)
        end
    end
end

skating.MustRagdoll = function()
    local x = GetEntityRotation(skating.Entities).x
    local y = GetEntityRotation(skating.Entities).y

    if ((-60.0 < x and x > 60.0)) and IsEntityInAir(skating.Entities) and skating.Speed < 5.0 then return true end
    if (HasEntityCollidedWithAnything(GetPlayerPed(-1)) and skating.Speed > 5.0) then return true end
    if IsPedDeadOrDying(player, false) then return true end return false
end

skating.HandleKeys = function(distance)
    local forward = IsControlPressed(0, 32)
    local backward = IsControlPressed(0, 33)
    local left = IsControlPressed(0, 34)
    local right = IsControlPressed(0, 35)

    VFW.ShowHelpNotification("Appuyez sur ~b~E~w~ pour supprimer | Appuyez sur ~b~G~w~ pour sauter dessus")

    if distance <= 1.5 and IsControlJustPressed(0, 38) then
        skating.Connect("pickupskateboard")
    elseif distance <= 1.5 and IsControlJustReleased(0, 113) then
        if connected then skating.ConnectPlayer(false)
        elseif not IsPedRagdoll(player) then Wait(200) skating.ConnectPlayer(true) end
    end

    if distance < loseConnectionDistance then
        local overSpeed = (GetEntitySpeed(skating.Entities)*3.6) > maxSpeedKmh

        TaskVehicleTempAction(skating.Player, skating.Entities, 1, 1)
        ForceVehicleEngineAudio(skating.Entities, 0)

        CreateThread(function()
            player = VFW.PlayerData.ped Wait(1)
            SetEntityInvincible(skating.Entities, true)
            StopCurrentPlayingAmbientSpeech(skating.Player)

            if connected then
                skating.Speed = GetEntitySpeed(skating.Entities) * 3.6
                if skating.MustRagdoll() then skating.ConnectPlayer(false) SetPedToRagdoll(player, 5000, 4000, 0, true, true, false) connected = false end
            end
        end)

        if forward and not backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 9, 1)
        end

        if IsControlPressed(0, 22) and connected then
            if not IsEntityInAir(skating.Entities) then
                local vel = GetEntityVelocity(skating.Entities)

                TaskPlayAnim(VFW.PlayerData.ped, "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)

                local duration = 0 local boosting = 0

                while IsControlPressed(0, 22) do Wait(10) duration = duration + 10.0 end

                boosting = maxJumpHeigh * duration / 250.0

                if boosting > maxJumpHeigh then boosting = maxJumpHeigh end

                StopAnimTask(VFW.PlayerData.ped, "move_crouch_proto", "idle_intro", 1.0)

                if(connected) then SetEntityVelocity(skating.Entities, vel.x, vel.y, vel.z + boosting)
                    TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 2.0, -1, 1, 1.0, false, false, false)
                end
            end
        end

        if IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 6, 2500)
        end

        if backward and not forward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 22, 1)
        end

        if left and backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 13, 1)
        end

        if right and backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 14, 1)
        end

        if forward and backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 30, 100)
        end

        if left and forward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 7, 1)
        end

        if right and forward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 8, 1)
        end

        if left and not forward and not backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 4, 1)
        end

        if right and not forward and not backward and not overSpeed then
            TaskVehicleTempAction(skating.Player, skating.Entities, 5, 1)
        end
    end
end

skating.Spawn = function()
    skating.LoadModels({ GetHashKey("bmx"), 68070371, GetHashKey("p_defilied_ragdoll_01_s"), "pickup_object", "move_strafe@stealth", "move_crouch_proto"})

    local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

    skating.Entities = CreateVehicle(GetHashKey("bmx"), spawnCoords, spawnHeading, true)
    skating.Board = CreateObject(GetHashKey("p_defilied_ragdoll_01_s"), 0.0, 0.0, 0.0, true, true, true)

    while not DoesEntityExist(skating.Entities) do Wait(5) end
    while not DoesEntityExist(skating.Board) do Wait(5) end

    SetEntityNoCollisionEntity(skating.Entities, player, false)
    SetEntityCollision(skating.Entities, false, true)
    SetEntityVisible(skating.Entities, false)
    AttachEntityToEntity(skating.Board, skating.Entities, GetPedBoneIndex(VFW.PlayerData.ped, 28422), 0.0, 0.0, -0.40, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

    skating.Player = CreatePed(12	, 68070371, spawnCoords, spawnHeading, true, true)

    SetEnableHandcuffs(skating.Player, true)
    SetEntityInvincible(skating.Player, true)
    SetEntityVisible(skating.Player, false)
    FreezeEntityPosition(skating.Player, true)
    TaskWarpPedIntoVehicle(skating.Player, skating.Entities, -1)

    while not IsPedInVehicle(skating.Player, skating.Entities) do Wait(0) end skating.Connect("placeskateboard")
end

skating.Connect = function(param)
    if not DoesEntityExist(skating.Entities) then return end

    if param == "placeskateboard" then
        AttachEntityToEntity(skating.Entities, VFW.PlayerData.ped, GetPedBoneIndex(VFW.PlayerData.ped,  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
        TaskPlayAnim(VFW.PlayerData.ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false) Wait(800)
        DetachEntity(skating.Entities, false, true)
        PlaceObjectOnGroundProperly(skating.Entities)
    elseif param == "pickupskateboard" then
        TriggerServerEvent("core:server:buySkate", "skate")
        TaskPlayAnim(VFW.PlayerData.ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false) Wait(600)
        AttachEntityToEntity(skating.Entities, VFW.PlayerData.ped, GetPedBoneIndex(VFW.PlayerData.ped,  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
        Wait(900) skating.Clear()
    end
end

skating.Clear = function()
    DetachEntity(skating.Entities)
    DeleteEntity(skating.Board)
    DeleteVehicle(skating.Entities)
    DeleteEntity(skating.Player)
    skating.UnloadModels()
    Attach = false
    connected  = false
    SetPedRagdollOnCollision(player, false)
end

skating.LoadModels = function(models)
    for modelIndex = 1, #models do
        local model = models[modelIndex]

        if not skating.Models then skating.Models = {} end

        table.insert(skating.Models, model)

        if IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(10) end
        else
            RequestAnimDict(model)
            while not HasAnimDictLoaded(model) do Wait(10) end
        end
    end
end

skating.UnloadModels = function()
    for modelIndex = 1, #skating.Models do
        local model = skating.Models[modelIndex]

        if IsModelValid(model) then
            SetModelAsNoLongerNeeded(model)
        else
            RemoveAnimDict(model)
        end
    end
end

skating.ConnectPlayer = function(toggle)
    if toggle then
        TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 8.0, -1, 1, 1.0, false, false, false)
        AttachEntityToEntity(player, skating.Entities, 20, 0.0, 0, 0.7, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
        SetEntityCollision(player, true, true)
    elseif not toggle then
        DetachEntity(player, false, false)
        StopAnimTask(player, "move_strafe@stealth", "idle", 1.0)
        StopAnimTask(VFW.PlayerData.ped, "move_crouch_proto", "idle_intro", 1.0)
        TaskVehicleTempAction(skating.Player, skating.Entities, 3, 1)
    end
    connected = toggle
end
