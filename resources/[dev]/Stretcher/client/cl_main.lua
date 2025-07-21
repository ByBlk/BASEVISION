local stretchers = {}
canStretcherMenu = false
canStretcher = false
canDelStretcher =false
canMdStretcher = false

RegisterNetEvent('cl:SyncStretchers')
AddEventHandler('cl:SyncStretchers', function(updatedStretchers)
    stretchers = updatedStretchers
    for netId, data in pairs(stretchers) do
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " Moving: " .. tostring(data.moving))
            print("Stretcher ID: " .. netId .. " Moving: " .. tostring(data.sitting))
        end
    end
end)

RegisterNetEvent("cl:getIsAllowedRet")
AddEventHandler("cl:getIsAllowedRet", function(access,value)
    if access == "command.stretchermenu" then
        canStretcherMenu = value
    elseif access == "command.stretcher" then
        canStretcher = value
    elseif access == "command.delstretcher" then
        canDelStretcher = value
    elseif access == "command.mdstretcher" then
        canMdStretcher = value
    end
end)

RegisterNetEvent('cl:SyncMovingState')
AddEventHandler('cl:SyncMovingState', function(netId, bool)
    if stretchers[netId] then
        stretchers[netId].moving = bool
        if Config.Debug.messages then
            print("Moving bool for stretcher ID " .. netId .. " updated to " .. tostring(bool))
        end
    else
        stretchers[netId] = { moving = bool }
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " added with moving bool: " .. tostring(bool))
        end
    end
end)

RegisterNetEvent('cl:SyncSittingState')
AddEventHandler('cl:SyncSittingState', function(netId, bool)
    if stretchers[netId] then
        stretchers[netId].sitting = bool
        if Config.Debug.messages then
            print("Sitting bool for stretcher ID " .. netId .. " updated to " .. tostring(bool))
        end
    else
        stretchers[netId] = { moving = bool }
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " added with sitting bool: " .. tostring(bool))
        end    
    end
end)

RegisterNetEvent('cl:RemoveStretcherFromTable')
AddEventHandler('cl:RemoveStretcherFromTable', function(netId)
    if stretchers[netId] then
        stretchers[netId] = nil
        if Config.Debug.messages then
            print("Stretcher with network ID " .. netId .. " removed")
        end
    elseif Config.Debug.messages then
        print("Stretcher with network ID " .. netId .. " not found")
    end
end)

function AddStretcherId(netId)
    TriggerServerEvent('sv:AddStretcherToTable', netId)
end

function SetMovingState(netId, bool)
    TriggerServerEvent('sv:SetMovingState', netId, bool)
end

function SetSittingState(netId, bool)
    TriggerServerEvent('sv:SetSittingState', netId, bool)
end

function RemoveStretcherId(netId)
    TriggerServerEvent('sv:RemoveStretcherFromTable', netId)
end

function GetVehicleNetId(vehicle)
    local netId = VehToNet(vehicle)
    return netId
end

function GetPedNetId(playerPed)
    local netId = PedToNet(playerPed)
    return netId
end

function GetVehicleFromNetId(netId)
    local vehicle = NetToVeh(netId)
    return vehicle
end

function GetPedFromNetId(netId)
    local playerPed = NetToPed(netId)
    return playerPed
end

function CheckMovingState(netId)
    if stretchers[netId] then
        return stretchers[netId].moving
    else
        return nil
    end
end

function CheckSittingState(netId)
    if stretchers[netId] then
        return stretchers[netId].sitting
    else
        return nil
    end
end

Citizen.CreateThread(function()
    local activated = false
    while true do
        Wait(0)
        if IsControlPressed(0, Config.Keys.doors) and not IsPedInAnyVehicle(PlayerPedId()) then
            if not activated then
                local timer = 0 
                local hold = 700 
                activated = true
                while IsControlPressed(0, Config.Keys.doors) do
                    Wait(0)
                    timer = timer + GetFrameTime() * 1000
                    if timer >= hold then
                        ToggleVehicleDoors()
                        break
                    end
                end
            end
        else
            activated = false
        end
    end
end)

VehicleDoorIndex = { FLD = 0, FRD = 1, BLD = 2, BRD = 3, HOOD = 4, TRUNK = 5, RLD = 6, RRD = 7 }

function ToggleVehicleDoors()
    local nearestVehicle, vehicleConfig = UTIL.GetClosestVehicleFromPedPos(PlayerPedId(), 20.0, 7.0, true, Config.Vehicles)
    if nearestVehicle and vehicleConfig then
        if Config.Debug.messages then
            print("The nearest vehicle matches a specified model: " .. vehicleConfig.modelHash)
            print("Doors: " .. table.concat(vehicleConfig.doors, ", "))
        end

        SetVehicleHasBeenOwnedByPlayer(nearestVehicle, true)
        SetEntityAsMissionEntity(nearestVehicle, true, true)

        local vehicleCoords = GetEntityCoords(nearestVehicle)
        local distanceToVehicle = #(GetEntityCoords(PlayerPedId()) - vehicleCoords)
        if distanceToVehicle > vehicleConfig.dist then
            if Config.Debug.messages then
                print("Player is not within the required distance to the vehicle.")
            end
            return
        end

        local fld, frd, bld, brd, hood, trunk, rld, rrd = false, false, false, false, false, false, false, false


        for _, door in ipairs(vehicleConfig.doors) do
            if door == "FLD" then fld = true end
            if door == "FRD" then frd = true end
            if door == "BLD" then bld = true end
            if door == "BRD" then brd = true end
            if door == "HOOD" then hood = true end
            if door == "TRUNK" then trunk = true end
            if door == "RLD" then rld = true end
            if door == "RRD" then rrd = true end
        end

        TriggerServerEvent('sv:ToggleVehicleDoors', GetVehicleNetId(nearestVehicle), fld, frd, bld, brd, hood, trunk, rld, rrd)
    end
end

RegisterNetEvent('cl:SyncVehicleDoors')
AddEventHandler('cl:SyncVehicleDoors', function(netId, fld, frd, bld, brd, hood, trunk, rld, rrd)
    local doors = {fld, frd, bld, brd, hood, trunk, rld, rrd}
    local doorIndices = {0, 1, 2, 3, 4, 5, 6, 7} -- Adjusted to 0-based indices
    local vehicle = GetVehicleFromNetId(netId)
        if Config.Debug.messages then
            print(vehicle)
            print(doors)
        end
    if vehicle then
        local openCount = 0
        local closedCount = 0

        for i, isOpen in ipairs(doors) do
            if isOpen then
                local doorIndex = doorIndices[i]
                local doorState = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0
                if doorState then
                    openCount = openCount + 1
                else
                    closedCount = closedCount + 1
                end
            end
        end

        local allOpen = openCount == #doors
        local allClosed = closedCount == #doors

        for i, isOpen in ipairs(doors) do
            if isOpen then
                local doorIndex = doorIndices[i]
                if allClosed or (closedCount > openCount) then
                    SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                else
                    SetVehicleDoorShut(vehicle, doorIndex, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, Config.Keys.take) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local stretcherObject = GetClosestVehicle(playerCoords, 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
            if stretcherObject then
                TakeStretcher(stretcherObject)
            end
        end
    end
end)

function TakeStretcher(stretcherObject)
    if Config.Debug.messages then print("TakeStretcher function triggered") end
    if IsPedInAnyVehicle(PlayerPedId()) then 
        if Config.Debug.messages then
        print("You can't take the stretcher while in a vehicle!") 
        end
        return 
    end
    if PreventTakingStretcherWhileSeated then 
        if Config.Debug.messages then
            print("You can't take the stretcher while seated on it!") 
        end
        return 
    end

    if not stretcherObject or not DoesEntityExist(stretcherObject) then return end

    -- Vérifier et corriger l'état moving si nécessaire
    local netId = GetVehicleNetId(stretcherObject)
    if CheckMovingState(netId) then
        SetMovingState(netId, false)
        Wait(100) -- Attendre la synchronisation
    end

    UTIL.LoadAnimDict("anim@heists@box_carry@")

    NetworkRequestControlOfEntity(stretcherObject)
    while not NetworkHasControlOfEntity(stretcherObject) do
        Wait(0)
    end

    if Config.Debug.messages then print("about to attach") end
    AttachEntityToEntity(stretcherObject, PlayerPedId(), PlayerPedId(), -0.05, 1.375, -0.3450 , 180.0, 180.0, 180.0, 0.0, false, false, false, false, 2, true)
    SetVehicleExtra(stretcherObject, 1, 0)
    SetVehicleExtra(stretcherObject, 2, 1)
    SetMovingState((GetVehicleNetId(stretcherObject)), true)

    while IsEntityAttachedToEntity(stretcherObject, PlayerPedId()) do
        Wait(0)

        HideHudComponentThisFrame(19) -- Hide weapon wheel
        DisableControlAction(0, 37, true) -- Disable Weapon Wheel (tab)
        DisableControlAction(0, 22, true) -- Disable the jump/climb action (space bar)
        DisableControlAction(0, 44, true) -- Disable the take cover action (q)
        DisableControlAction(0, 24, true) -- INPUT_ATTACK (left mouse)
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE (left mouse)
        DisableControlAction(0, 25, true) -- INPUT_AIM (right mouse)
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2 (right mouse)
        DisableControlAction(0, 45, true) -- INPUT_RELOAD (r)
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_HEAVY (r)

        if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        if IsPedDeadOrDying(PlayerPedId()) or IsPedRagdoll(PlayerPedId()) then
            ClearPedTasksImmediately(PlayerPedId())
            SetVehicleExtra(stretcherObject, 1, 1)
            SetVehicleExtra(stretcherObject, 2, 0)
            DetachEntity(stretcherObject, true, true)
            SetVehicleOnGroundProperly(stretcherObject)

            SetMovingState((GetVehicleNetId(stretcherObject)), false)
        end

        if IsControlJustPressed(0, Config.Keys.load) then -- Load Stretcher
            ClearPedTasksImmediately(PlayerPedId())
            AttachToAmbulance(stretcherObject)
        end

        if IsControlJustPressed(0, Config.Keys.take) then -- Drop Stretcher
            ClearPedTasksImmediately(PlayerPedId())
            SetVehicleExtra(stretcherObject, 1, 1)
            SetVehicleExtra(stretcherObject, 2, 0)
            DetachEntity(stretcherObject, true, false)
            SetVehicleOnGroundProperly(stretcherObject)

            -- Corrects offset when setting the stretcher down
            local playerPed = PlayerPedId()
            local OffsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.127, 1.375, -0.030)
            SetEntityCoords(stretcherObject, OffsetCoords.x, OffsetCoords.y, OffsetCoords.z)

            SetMovingState((GetVehicleNetId(stretcherObject)), false)
        end
    end
end

function AttachToAmbulance(stretcherObject)
    local nearestVehicle, vehicleConfig = UTIL.GetClosestVehicleFromPedPos(PlayerPedId(), 20.0, 7.0, true, Config.Vehicles)
    
    if nearestVehicle and vehicleConfig then
        local vehicleCoords = GetEntityCoords(nearestVehicle)
        local distanceToVehicle = #(GetEntityCoords(PlayerPedId()) - vehicleCoords)
        if distanceToVehicle > vehicleConfig.dist then
            if Config.Debug.messages then
                print("Player is not within the required distance to the vehicle.")
            end
            return
        end
        
        NetworkRequestControlOfEntity(nearestVehicle)
        
        local vehicleBone = -1

        if vehicleConfig.powerload then
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bonnet")
            if vehicleBone == -1 then
                if Config.Debug.messages then
                    print("This vehicle does not support powerload.")
                end
                return
            end
        else
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis_dummy")
            if Config.Debug.messages then
                print("Vehicle bone detected: chassis dummy")
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis")
                if Config.Debug.messages then
                    print("Vehicle bone detected: chassis")
                end
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bodyshell")
                if Config.Debug.messages then
                    print("Vehicle bone detected: bodyshell")
                end
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "seat_dside_f")
                if Config.Debug.messages then
                    print("Vehicle bone detected: driver seat")
                end
            end
        
            if vehicleBone == -1 then
                if Config.Debug.messages then
                    print("Bone index not found.")
                end
                return
            end
        end

        if vehicleBone ~= -1 then
        SetVehicleHasBeenOwnedByPlayer(nearestVehicle, true)
        SetEntityAsMissionEntity(nearestVehicle, true, true)
        
        SetVehicleExtra(stretcherObject, 1, 1)
        SetVehicleExtra(stretcherObject, 2, 0)
        
        AttachEntityToEntity(stretcherObject, nearestVehicle, vehicleBone, vehicleConfig.xOffset, vehicleConfig.yOffset, vehicleConfig.zOffset, 0.0, 0.0, vehicleConfig.rotOffset, false, false, true, false, 2, true)
        SetMovingState((GetVehicleNetId(stretcherObject)), true)
        end

        if Config.Debug.messages then print("Stretcher attached to ambulance.") end

    elseif Config.Debug.messages then
        print("Vehicle not found or no matching configuration.")
    end
end

AddEventHandler('ToggleHeadrest', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local stretcherObject = GetClosestVehicle(playerCoords, 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
    if IsVehicleExtraTurnedOn(stretcherObject, 11) then
        SetVehicleExtra(stretcherObject, 11, 1)
        SetVehicleExtra(stretcherObject, 12, 0)
    elseif IsVehicleExtraTurnedOn(stretcherObject, 12) then
        SetVehicleExtra(stretcherObject, 11, 0)
        SetVehicleExtra(stretcherObject, 12, 1)
    end
end)

AddEventHandler('ToggleBackboard', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 3)
end)

AddEventHandler('ToggleMonitor', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 5)
end)

AddEventHandler('ToggleRedBag', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 6)
end)

AddEventHandler('ToggleBlueBag', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 7)
end)

local EventHandlers = {
    ["StretcherReceiveCPR"] = { "mini@cpr@char_b@cpr_str", "cpr_pumpchest", {0, 0.0, 0.2, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitRight"] = { "amb@prop_human_seat_chair_food@male@base", "base", {0, 0.0, -0.2, 0.55, 0.0, 0.0, -90.0, false, false, false, false, 2, true} },
    ["StretcherSitLeft"] = { "amb@prop_human_seat_chair_food@male@base", "base", {0, 0.0, -0.2, 0.55, 0.0, 0.0, 90.0, false, false, false, false, 2, true} },
    ["StretcherSitEnd"] = { "anim@heists@fleeca_bank@hostages@intro", "intro_loop_ped_a", {0, 0.0, -1.1, 1.05, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUpright"] = { "amb@world_human_stupor@male@base", "base", {0, -0.05, 0.1, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUprightLegsCrossed"] = { "switch@michael@tv_w_kids", "001520_02_mics3_14_tv_w_kids_exit_trc", {0, 0.0, -0.075, 1.6, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUprightKneesTucked"] = { "anim@amb@casino@out_of_money@ped_male@02b@base", "base", {0, 0.0, 0.1, 1.52, 0.0, 0.0, 184.0, false, false, false, false, 2, true} },
    ["StretcherLieBack"] = { "savecouch@", "t_sleep_loop_couch", {0, 0.0, 0.2, 1.1, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherLieLeft"] = { "amb@lo_res_idles@", "world_human_bum_slumped_right_lo_res_base", {0, 0.2, 0.1, 1.55, 0.0, 0.0, 100.0, false, false, false, false, 2, true} },
    ["StretcherLieUpright"] = { "amb@world_human_stupor@male_looking_left@base", "base", {0, 0.0, 0.3, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherLieProne"] = { "amb@world_human_sunbathe@male@front@base", "base", {0, 0.0, 0.2, 1.5, 0.0, 0.0, 0.0, false, false, false, false, 2, true} },

}

for event, data in pairs(EventHandlers) do
    AddEventHandler(event, function()
        UTIL.PlayAnimation(PlayerPedId(), data[1], data[2], data[3])
    end)
end

AddEventHandler('StretcherGetUp', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local stretcherHash = GetHashKey(Config.Stretcher.modelHash)
    local stretcherObject = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, stretcherHash, 70)

    if not stretcherObject then return end
    if not GetEntityModel(stretcherObject) == stretcherHash then return end

    -- Vérifier si le joueur est attaché au brancard
    if not IsEntityAttachedToEntity(playerPed, stretcherObject) then
        return
    end

    -- Détacher le joueur du brancard
    DetachEntity(playerPed, true, true)
    
    -- Positionner le joueur à côté du brancard
    local stretcherCoords = GetEntityCoords(stretcherObject)
    local x, y, z = table.unpack(stretcherCoords + GetEntityForwardVector(stretcherObject) * -1.5)
    SetEntityCoords(playerPed, x, y, z)
    
    -- Arrêter l'animation
    ClearPedTasksImmediately(playerPed)
    
    -- Mettre à jour l'état du brancard
    SetSittingState(GetVehicleNetId(stretcherObject), false)
    
    -- Supprimer le brancard en utilisant la fonction existante
    UTIL.DeleteStretcher(Config.Stretcher.modelHash)
    
    PreventTakingStretcherWhileSeated = false
end)

-- ===== MENU CONTEXTUEL BRANCARD =====

-- Fonction pour vérifier si c'est un brancard
local function IsStretcher(entity)
    return GetEntityModel(entity) == GetHashKey(Config.Stretcher.modelHash)
end

-- Fonction pour attacher le brancard à un véhicule
local function AttachStretcherToVehicle(stretcherObject)
    -- Vérifier si le brancard est déjà attaché à un véhicule
    if IsEntityAttachedToAnyVehicle(stretcherObject) then
        UTIL.Notify("~r~Le brancard est déjà attaché à un véhicule!")
        return
    end
    
    local nearestVehicle, vehicleConfig = UTIL.GetClosestVehicleFromPedPos(PlayerPedId(), 20.0, 7.0, true, Config.Vehicles)
    
    if not nearestVehicle or not vehicleConfig then
        UTIL.Notify("~r~Aucun véhicule compatible à proximité!")
        return
    end
    
    local vehicleCoords = GetEntityCoords(nearestVehicle)
    local distanceToVehicle = #(GetEntityCoords(PlayerPedId()) - vehicleCoords)
    
    if distanceToVehicle > vehicleConfig.dist then
        UTIL.Notify("~r~Vous êtes trop loin du véhicule!")
        return
    end
    
    NetworkRequestControlOfEntity(nearestVehicle)
    NetworkRequestControlOfEntity(stretcherObject)
    
    while not NetworkHasControlOfEntity(nearestVehicle) or not NetworkHasControlOfEntity(stretcherObject) do
        Wait(0)
    end
    
    local vehicleBone = -1
    
    if vehicleConfig.powerload then
        vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bonnet")
    else
        vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis_dummy")
        if vehicleBone == -1 then
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis")
        end
        if vehicleBone == -1 then
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bodyshell")
        end
        if vehicleBone == -1 then
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "seat_dside_f")
        end
    end
    
    if vehicleBone == -1 then
        UTIL.Notify("~r~Impossible d'attacher le brancard à ce véhicule!")
        return
    end
    
    SetVehicleHasBeenOwnedByPlayer(nearestVehicle, true)
    SetEntityAsMissionEntity(nearestVehicle, true, true)
    
    SetVehicleExtra(stretcherObject, 1, 1)
    SetVehicleExtra(stretcherObject, 2, 0)
    
    -- Vérifier s'il y a un joueur sur le brancard
    local players = GetActivePlayers()
    local playerOnStretcher = nil
    
    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if IsEntityAttachedToEntity(targetPed, stretcherObject) then
            playerOnStretcher = targetPed
            break
        end
    end
    
    -- Attacher le brancard au véhicule
    AttachEntityToEntity(stretcherObject, nearestVehicle, vehicleBone, vehicleConfig.xOffset, vehicleConfig.yOffset, vehicleConfig.zOffset, 0.0, 0.0, vehicleConfig.rotOffset, false, false, true, false, 2, true)
    SetMovingState(GetVehicleNetId(stretcherObject), true)
    
    -- Si un joueur était sur le brancard, le réattacher
    if playerOnStretcher then
        -- Détacher temporairement le joueur
        DetachEntity(playerOnStretcher, true, true)
        
        -- Réattacher le joueur au brancard (qui est maintenant attaché au véhicule)
        AttachEntityToEntity(playerOnStretcher, stretcherObject, 0, 0.0, 0.2, 1.1, 0.0, 0.0, 180.0, false, false, false, false, 2, true)
        
        -- Remettre l'animation
        UTIL.LoadAnimDict("savecouch@")
        TaskPlayAnim(playerOnStretcher, "savecouch@", "t_sleep_loop_couch", 8.0, -8.0, -1, 1, 0, false, false, false)
        
        UTIL.Notify("~g~Brancard et joueur attachés au véhicule!")
    else
        UTIL.Notify("~g~Brancard attaché au véhicule!")
    end
end

-- Fonction pour s'allonger sur le brancard
local function LieOnStretcher(stretcherObject)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local stretcherCoords = GetEntityCoords(stretcherObject)
    
    -- Vérifier que le joueur est près du brancard
    if #(playerCoords - stretcherCoords) > 3.0 then
        UTIL.Notify("~r~Vous devez être plus près du brancard!")
        return
    end
    
    -- Vérifier que le brancard n'est pas déjà occupé
    if CheckSittingState(GetVehicleNetId(stretcherObject)) then
        UTIL.Notify("~r~Quelqu'un est déjà sur ce brancard!")
        return
    end
    
    -- S'allonger sur le brancard
    NetworkRequestControlOfEntity(stretcherObject)
    while not NetworkHasControlOfEntity(stretcherObject) do
        Wait(0)
    end
    
    -- Attacher le joueur au brancard en position allongée
    AttachEntityToEntity(playerPed, stretcherObject, 0, 0.0, 0.2, 1.1, 0.0, 0.0, 180.0, false, false, false, false, 2, true)
    
    -- Jouer l'animation d'allongement
    UTIL.LoadAnimDict("savecouch@")
    TaskPlayAnim(playerPed, "savecouch@", "t_sleep_loop_couch", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    SetSittingState(GetVehicleNetId(stretcherObject), true)
    
    UTIL.Notify("~g~Vous vous êtes allongé sur le brancard!")
end

-- Fonction pour se lever du brancard
local function GetUpFromStretcher(stretcherObject)
    local playerPed = PlayerPedId()
    
    -- Vérifier si le joueur est attaché au brancard
    if not IsEntityAttachedToEntity(playerPed, stretcherObject) then
        UTIL.Notify("~r~Vous n'êtes pas sur ce brancard!")
        return
    end
    
    -- Détacher le joueur du brancard
    DetachEntity(playerPed, true, true)
    
    -- Positionner le joueur à côté du brancard
    local stretcherCoords = GetEntityCoords(stretcherObject)
    local x, y, z = table.unpack(stretcherCoords + GetEntityForwardVector(stretcherObject) * -1.5)
    SetEntityCoords(playerPed, x, y, z)
    
    -- Arrêter l'animation
    ClearPedTasksImmediately(playerPed)
    
    -- Mettre à jour l'état du brancard
    SetSittingState(GetVehicleNetId(stretcherObject), false)
    
    -- Supprimer le brancard en utilisant la fonction existante
    UTIL.DeleteStretcher(Config.Stretcher.modelHash)
    
    UTIL.Notify("~g~Vous vous êtes levé du brancard!")
end

-- Fonction pour détacher le brancard du véhicule
local function DetachStretcherFromVehicle(stretcherObject)
    -- Vérifier si le brancard est attaché à un véhicule
    if not IsEntityAttachedToAnyVehicle(stretcherObject) then
        UTIL.Notify("~r~Le brancard n'est pas attaché à un véhicule!")
        return
    end
    
    NetworkRequestControlOfEntity(stretcherObject)
    while not NetworkHasControlOfEntity(stretcherObject) do
        Wait(0)
    end
    
    -- Vérifier s'il y a un joueur sur le brancard
    local players = GetActivePlayers()
    local playerOnStretcher = nil
    
    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if IsEntityAttachedToEntity(targetPed, stretcherObject) then
            playerOnStretcher = targetPed
            break
        end
    end
    
    -- Détacher le brancard du véhicule
    DetachEntity(stretcherObject, true, false)
    SetVehicleOnGroundProperly(stretcherObject)
    
    -- Corriger la position
    local playerPed = PlayerPedId()
    local OffsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.127, 1.375, -0.030)
    SetEntityCoords(stretcherObject, OffsetCoords.x, OffsetCoords.y, OffsetCoords.z)
    
    -- Si un joueur était sur le brancard, le réattacher
    if playerOnStretcher then
        -- Détacher temporairement le joueur
        DetachEntity(playerOnStretcher, true, true)
        
        -- Réattacher le joueur au brancard (qui est maintenant au sol)
        AttachEntityToEntity(playerOnStretcher, stretcherObject, 0, 0.0, 0.2, 1.1, 0.0, 0.0, 180.0, false, false, false, false, 2, true)
        
        -- Remettre l'animation
        UTIL.LoadAnimDict("savecouch@")
        TaskPlayAnim(playerOnStretcher, "savecouch@", "t_sleep_loop_couch", 8.0, -8.0, -1, 1, 0, false, false, false)
        
        UTIL.Notify("~g~Brancard et joueur détachés du véhicule!")
    else
        UTIL.Notify("~g~Brancard détaché du véhicule!")
    end
    
    SetMovingState(GetVehicleNetId(stretcherObject), false)
    
    -- S'assurer que l'état est bien synchronisé
    Wait(100)
    if CheckMovingState(GetVehicleNetId(stretcherObject)) then
        SetMovingState(GetVehicleNetId(stretcherObject), false)
    end
end

-- Ajout des options au menu contextuel
Citizen.CreateThread(function()
    Wait(3000) -- Attendre plus longtemps que le framework soit complètement chargé
    
    print("Système de brancard chargé avec succès!")
end)

-- Système de touches directes pour le brancard
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local stretcherObject = GetClosestVehicle(playerCoords, 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
        
        if stretcherObject and IsStretcher(stretcherObject) then
            -- Touche F1 pour mettre le brancard dans un véhicule
            if IsControlJustPressed(0, 288) then -- F1
                AttachStretcherToVehicle(stretcherObject)
            end
            
            -- Touche F4 pour se lever du brancard
            if IsControlJustPressed(0, 166) then -- F4
                if IsEntityAttachedToEntity(playerPed, stretcherObject) then
                    GetUpFromStretcher(stretcherObject)
                else
                    UTIL.Notify("~r~Vous n'êtes pas sur le brancard!")
                end
            end
            
            -- Touche F5 pour retirer le brancard du véhicule
            if IsControlJustPressed(0, 167) then -- F5
                if IsEntityAttachedToAnyVehicle(stretcherObject) then
                    DetachStretcherFromVehicle(stretcherObject)
                else
                    UTIL.Notify("~r~Le brancard n'est pas attaché à un véhicule!")
                end
            end
            
            -- Afficher les instructions en bas de l'écran
            DrawStretcherInstructions()
        end
    end
end)

-- Fonction pour afficher les instructions en bas de l'écran
function DrawStretcherInstructions()
    local screenW, screenH = GetActiveScreenResolution()
    local y = screenH * 0.85
    local x = screenW * 0.5
    
    -- Fond semi-transparent
    DrawRect(x, y, 600, 80, 0, 0, 0, 150)
    
    -- Bordure
    DrawRect(x, y - 40, 600, 2, 255, 255, 255, 255)
    DrawRect(x, y + 40, 600, 2, 255, 255, 255, 255)
    
    -- Titre
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("=== CONTROLES BRANCARD ===")
    DrawText(x - 280, y - 30)
    
    -- Instructions des touches
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("F1: Attacher au véhicule | F4: Se lever | F5: Détacher")
    DrawText(x - 280, y - 10)
    
    -- Description
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.3, 0.3)
    SetTextColour(200, 200, 200, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("Le brancard et le joueur seront attachés au véhicule")
    DrawText(x - 280, y + 10)
end
