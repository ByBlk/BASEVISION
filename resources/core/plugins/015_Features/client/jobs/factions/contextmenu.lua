local controlList = {
    140, 141, 142, 25, 24, 257, 288, 47, 21, 73, 263, 264, 45, 44, 22, 37, 157, 158, 160, 164, 165
}
local cuffedN = false
local cuffeddict = 'mp_arresting'
local cuffedanim = 'crook_p2_back_left'
local cuffdict = 'mp_arrest_paired'
local cuffanim = 'cop_p2_back_left'
local uncuffdict = 'mp_arresting'
local uncuffanim = 'a_uncuff'
local lastInVehicle = false

RegisterNetEvent('handcuff:client:thecuff', function(wannamove, cufferSource)
    local plyPed = VFW.PlayerData.ped
    local targetPed = GetPlayerPed(GetPlayerFromServerId(cufferSource))

    if wannamove then
        cuffedN = true
        CreateThread(function()
            while cuffedN do
                Wait(10)
                for i = 1, #controlList do
                    DisableControlAction(0, controlList[i], true)
                end
            end
        end)

        VFW.Streaming.RequestAnimDict(cuffdict)
        VFW.Streaming.RequestAnimDict(cuffeddict)
        AttachEntityToEntity(plyPed, targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(plyPed, cuffdict, cuffedanim, 8.0, -8.0, 4300, 33, 0.0, false, false, false)
        RemoveAnimDict(cuffdict)
        Wait(2000)
        DetachEntity(plyPed, true, false)
        Wait(2300)
        SetEnableHandcuffs(plyPed, true)
        TaskPlayAnim(plyPed, cuffeddict, 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        RemoveAnimDict(cuffeddict)
    elseif not wannamove then
        AttachEntityToEntity(plyPed, targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        ClearPedTasks(plyPed)
        SetEnableHandcuffs(plyPed, false)
        UncuffPed(plyPed)
        cuffedN = false
        Wait(2200)
        DetachEntity(plyPed, true, false)
    end
end)

RegisterNetEvent('handcuff:client:arresting', function()
    VFW.Streaming.RequestAnimDict(cuffdict)

    local plyPed = VFW.PlayerData.ped

    TaskPlayAnim(plyPed, cuffdict, cuffanim, 8.0, -8.0, 4300, 33, 0.0, false, false, false)
    RemoveAnimDict(cuffdict)
end)

RegisterNetEvent('handcuff:client:unarresting', function()
    VFW.Streaming.RequestAnimDict(uncuffdict)

    local plyPed = VFW.PlayerData.ped

    TaskPlayAnim(plyPed, uncuffdict, uncuffanim, 8.0, -8.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict(uncuffdict)
    Wait(2200)
    ClearPedTasksImmediately(plyPed)
end)

RegisterNetEvent('handcuff:client:setHandcuff', function(wannamove)
    local plyPed = VFW.PlayerData.ped

    if wannamove then
        cuffedN = true
        CreateThread(function()
            while cuffedN do
                Wait(10)
                for i = 1, #controlList do
                    DisableControlAction(0, controlList[i], true)
                end
            end
        end)

        VFW.Streaming.RequestAnimDict(cuffeddict)
        SetEnableHandcuffs(plyPed, true)
        TaskPlayAnim(plyPed, cuffeddict, 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        RemoveAnimDict(cuffeddict)
    elseif not wannamove then
        ClearPedTasks(plyPed)
        SetEnableHandcuffs(plyPed, false)
        UncuffPed(plyPed)
        cuffedN = false
    end
end)

function VFW.Jobs.Cuff(targetPed, wannacuff)
    TriggerServerEvent('handcuff:server:handcuff', GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed)), wannacuff)
end

function VFW.Jobs.GetPatientIdentityCard(entity)
    if entity then
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        local identity = TriggerServerCallback('core:server:jobs:GetPatientIdentity', sID)
        if not identity then return end
        return VFW.ShowNotification({
            type = 'JAUNE',
            duration = 10,
            content = "Nom : " .. identity.prenom .. "\nPrénom : " .. identity.nom .. "\nAge : " .. identity.age .. "\nSexe: " .. identity.sexe
        })
    end

    VFW.ShowNotification({ type = 'ROUGE', content = "~s Aucun joueur à proximité" })
end

local vehicleThieft = nil

function VFW.Jobs.HookVehicle(vehicle)
    CreateThread(function()
        vehicleThieft = nil
        local seat = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

        for i = -1, seat - 2 do
            if not IsVehicleSeatFree(vehicle, i) then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Il y a quelqu'un dans le vehicule"
                })
                return
            end
        end

        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        RequestAnimDict('missheistfbisetup1')

        while not HasAnimDictLoaded('missheistfbisetup1') do
            Wait(0)
        end

        TaskPlayAnim(PlayerPedId(), 'missheistfbisetup1' , 'hassle_intro_loop_f' ,8.0, -8.0, -1, 1, 0, false, false, false)

        local duration = VFW.Nui.ProgressBar("Crochetage en cours...", 10 * 1000)

        RemoveAnimDict("missheistfbisetup1")
        if duration then
            ClearPedTasks(VFW.PlayerData.ped)
            NetworkRequestControlOfEntity(vehicle)
            SetVehicleDoorsLocked(vehicle, 0)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            SetVehicleUndriveable(vehicle, true)
            VFW.ShowNotification({
                type = 'VERT',
                content = "~s Vous avez crocheté le vehicule"
            })
        end
    end)
end

function VFW.Jobs.InfoVeh(vehicle)
    return VFW.ShowNotification({
        type = 'JAUNE',
        duration = 8,
        content = "Véhicule : ~s".. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~c\n"
                .. "Plaque : ~s".. VFW.Game.GetPlate(vehicle) .. "~c\n"
                .. "Carrosserie : ~s".. math.round(GetVehicleBodyHealth(vehicle) / 10, 2) .."~c%\n"
                .. "État moteur : ~s".. math.round(GetVehicleEngineHealth(vehicle) / 10, 2) .."~c%\n"
                .. "Essence : ~s".. math.round(GetVehicleFuelLevel(vehicle), 2) .."~c%"
    })
end

function VFW.Jobs.GetVehiclePlate(vehicle)
    local plate = VFW.Game.GetPlate(vehicle)
    if not plate then return end
    local firstname, lastname = TriggerServerCallback('core:jobs:server:getVeh', plate)
    if not firstname or not lastname then return end
    return VFW.ShowNotification({
        type = 'JAUNE',
        duration = 8,
        content = "Propriétaire : ~s" .. firstname .. " " .. lastname
    })
end

function VFW.Jobs.SetVehicleInFourriere(vehicle)
    TaskStartScenarioInPlace(VFW.PlayerData.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

    local duration = VFW.Nui.ProgressBar("Mise en fourrière...", 7 * 1000)

    if duration then
        TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", nil, VFW.Math.Trim(GetVehicleNumberPlateText(vehicle)))
        DeleteEntity(vehicle)
        ClearPedTasks(VFW.PlayerData.ped)
    end
end

local DragStatus = {}
DragStatus.isDragged = false
DragStatus.dragger = nil

RegisterNetEvent('core:jobs:client:drag', function(draggerId)
    DragStatus.isDragged = not DragStatus.isDragged
    DragStatus.dragger = tonumber(draggerId)

    if not DragStatus.isDragged then
        DetachEntity(VFW.PlayerData.ped, true, false)
        return
    end

    local target = GetPlayerFromServerId(DragStatus.dragger)
    local targetPed = GetPlayerPed(target)
    NetworkRequestControlOfEntity(targetPed)

    CreateThread(function()
        while DragStatus.isDragged do
            Wait(0)
            if target ~= PlayerId() and target > 0 then
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(VFW.PlayerData.ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DragStatus.isDragged = false
                    DetachEntity(VFW.PlayerData.ped, true, false)
                end
            else
                Wait(500)
            end
        end
    end)
end)

local lastPlayer = nil

RegisterNetEvent('core:jobs:client:putInVehicle', function()
    local coords = GetEntityCoords(VFW.PlayerData.ped, false)

    if IsAnyVehicleNearPoint(coords, 5.0) then
        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

        if DoesEntityExist(vehicle) then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil

            for i = maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                end
            end

            if freeSeat ~= nil then
                DragStatus.isDragged = false
                DetachEntity(VFW.PlayerData.ped, true, false)
                TaskWarpPedIntoVehicle(VFW.PlayerData.ped, vehicle, freeSeat)
                lastInVehicle = true
            end
        end
    end
end)

RegisterNetEvent('core:jobs:client:OutVehicle', function()
    if not IsPedSittingInAnyVehicle(VFW.PlayerData.ped) then
        return
    end

    DragStatus.isDragged = false
    DetachEntity(VFW.PlayerData.ped, true, false)
    local vehicle = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
    TaskLeaveVehicle(VFW.PlayerData.ped, vehicle, 16)
    lastInVehicle = false
end)

function VFW.Jobs.Escort(player)
    if not lastPlayer then
        lastPlayer = player
        lastInVehicle = IsPedSittingInAnyVehicle(player)
        TriggerServerEvent('core:jobs:server:drag', GetPlayerServerId(NetworkGetPlayerIndexFromPed(player)))
    else
        TriggerServerEvent('core:jobs:server:drag', GetPlayerServerId(NetworkGetPlayerIndexFromPed(lastPlayer)))
        lastPlayer = nil
        lastInVehicle = false 
    end
end

function VFW.Jobs.InVehicle()
    if not lastPlayer then return end
    TriggerServerEvent('core:jobs:server:putInVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(lastPlayer)))
end

function VFW.Jobs.OutVehicle()
    if not lastPlayer then return end
    TriggerServerEvent('core:jobs:server:OutVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(lastPlayer)))
end

function VFW.Jobs.GetEscort()
    return lastPlayer
end

function VFW.Jobs.GetInVehicle()
    return lastInVehicle
end

local function PlayAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(VFW.PlayerData.ped, animDict, animName, 8.0, -8.0, duration, 0, 0, false, false, false)
    Wait(duration)
    RemoveAnimDict(animDict)
end

function VFW.Jobs.HealthPatient(closestPlayer)
    local globalTarget =  GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPlayer))
    local health = GetEntityHealth(closestPlayer)
    local haveKitHealth = TriggerServerCallback("core:jobs:server:haveKit", "health")

    if health > 0 then
        if haveKitHealth then
            PlayAnim("amb@medic@standing@kneel@base", "base", 5000)
            ClearPedTasks(VFW.PlayerData.ped)
            TriggerServerEvent('core:jobs:server:HealthPlayer', globalTarget)
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "~s Vous n'avez pas de kit de soin"
            })
        end
    end
end

function VFW.Jobs.RevivePatient(closestPlayer)
    local players = NetworkGetPlayerIndexFromPed(closestPlayer)
    local playerheading = GetEntityHeading(VFW.PlayerData.ped)
    local coords = GetEntityCoords(VFW.PlayerData.ped)
    local playerlocation = GetEntityForwardVector(VFW.PlayerData.ped)
    local haveKitRevive = TriggerServerCallback("core:jobs:server:haveKit", "revive")

    if haveKitRevive then
        TriggerServerEvent('core:jobs:server:RevivePlayer', GetPlayerServerId(players))
        TriggerServerEvent("core:jobs:server:reviveanimrevived", GetPlayerServerId(players), playerheading, coords, playerlocation)
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Vous n'avez pas de kit de réanimation"
        })
    end
end

function VFW.Jobs.IdentificationComa(entity)
    local exist, lastBone = GetPedLastDamageBone(entity)
    local cause, what_cause = GetPedCauseOfDeath(entity), GetPedSourceOfDeath(entity)

    if IsEntityAPed(what_cause) then
        what_cause = "avoir des traces de combat"
    elseif IsEntityAVehicle(what_cause) then
        what_cause = "être écrasé par un véhicule"
    elseif IsEntityAnObject(what_cause) then
        what_cause = "s'être pris un objet"
    end

    what_cause = type(what_cause) == "string" and what_cause or "Non-Identifiée"

    local weaponInfo = ""

    if IsWeaponValid(cause) then
        local weaponHash = cause
        cause = Death.GetDeathType[GetWeaponDamageType(cause)] or "Non-Identifiée"

        if Death.deatCause[weaponHash] then
            local deathType, weaponName = Death.deatCause[weaponHash][1], Death.deatCause[weaponHash][2]
            weaponInfo = string.format(" (arme: %s - type: %s)", weaponName, deathType)
        else
            weaponInfo = " (arme non identifiée)"
        end
    elseif IsModelInCdimage(cause) then
        cause = "Véhicule"
        weaponInfo = " (cause: collision avec véhicule)"
    end

    cause = type(cause) == "string" and cause or "Mêlée"
    local boneName = "Dos"

    if exist and lastBone then
        for k, v in pairs(Death.GetBonesType) do
            if Death:GetValueWithTable(v, lastBone) then
                boneName = k
                break
            end
        end
    end

    VFW.ShowNotification({
        type = 'VERT',
        duration = 15,
        content = string.format("L'individu semble %s au niveau du %s part %s", what_cause, string.lower(boneName), weaponInfo),
    })
end
