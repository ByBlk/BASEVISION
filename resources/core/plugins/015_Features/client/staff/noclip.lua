local speconmod = false
local targetped = nil
local targetid = nil
local inNoClip = false
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local _internal_camera = nil
local _internal_isFrozen = false
local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil
local settings = {
    --Camera
    fov = 45.0,
    -- Mouse
    mouseSensitivityX = 5,
    mouseSensitivityY = 5,
    -- Movement
    normalMoveMultiplier = 1,
    fastMoveMultiplier = 10,
    slowMoveMultiplier = 0.1,
    -- On enable/disable
    enableEasing = false,
    easingDuration = 1000
}
local showMarker = false

local function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

local function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)
    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)
    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end

local function SetNoClipAttributes(ped, veh, status)
    if status then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)

        if DoesEntityExist(veh) then
            SetEntityInvincible(veh, true)
            FreezeEntityPosition(veh, true)
            SetEntityCollision(veh, false, false)
            SetEntityVisible(veh, false, false)
        end
    else
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, true)

        if DoesEntityExist(veh) then
            SetEntityInvincible(veh, false)
            FreezeEntityPosition(veh, false)
            SetEntityCollision(veh, true, true)
            SetEntityVisible(veh, true, true)
        end
    end
end

local function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

local function RayCastGamePlayCamera(distance, ignoreEntity)
    if ignoreEntity == nil then ignoreEntity = -1 end
    local cameraRotation = GetCamRot(_internal_camera, 2)
    local cameraCoord = GetCamCoord(_internal_camera)
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, ignoreEntity, 1))
    return b, c, e
end

local function DrawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

local function UpdateEntityLooking()
    local hit, pos, entity = RayCastGamePlayCamera(3000, VFW.PlayerData.ped)

    if hit then
        local pos = GetEntityCoords(entity)
        local entityType = GetEntityType(entity)
        local LiseretColor = { 3, 194, 252 }
        local baseX = 0.85 -- gauche / droite ( plus grand = droite )
        local baseY = 0.15 -- Hauteur ( Plus petit = plus haut )
        local baseWidth = 0.15 -- Longueur
        local baseHeight = 0.03 -- Epaisseur

        if showMarker then
            DrawMarker(0, pos.xyz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 50.0, 255, 255, 255, 200, 0, 1, 2, 0, nil, nil, 0)
            DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
            DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170) -- Bannière
        end


        if IsControlJustPressed(0, 47) then
            showMarker = not showMarker
        end

        if entityType == 0 then
            -- instructionalButtons[idInstructionalButtons[2]] = {}
            if showMarker then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Aucune / Non connue", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
            end
        else
            local model = GetEntityModel(entity)
            local entity = entity
            local haveDeleteEntity = false
            local heading = GetEntityHeading(entity)
            local entName = GetEntityArchetypeName(entity) or ""
            local coords = GetEntityCoords(entity)

            if entityType == 1 then
                if IsPedAPlayer(entity) then
                    -- instructionalButtons[idInstructionalButtons[2]] = {}
                    if showMarker then
                        DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Player", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    end
                else
                    if showMarker then
                        DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Ped", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    end
                    haveDeleteEntity = true
                end
            elseif entityType == 2 then
                if showMarker then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Vehicule", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                end
                haveDeleteEntity = true
            elseif entityType == 3 then
                if showMarker then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Object", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                end
                haveDeleteEntity = true
            end

            if haveDeleteEntity then
                -- instructionalButtons[idInstructionalButtons[2]] = {
                --    { control = 73, label = "Supprimer l'entité" },
                --    { control = 38, label = "Copier l'entité" }
                --}

                if showMarker then
                    DrawRect(baseX, baseY + 0.032, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.032 - 0.013, "Modele: " .. model .. " ("..entName..")", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level

                    DrawRect(baseX, baseY + 0.0635, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.0635 - 0.013, "Heading: " .. heading, true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level

                    DrawRect(baseX, baseY + 0.095, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.095 - 0.013, "Pos: " .. tostring(coords), true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level
                end

                if IsControlJustReleased(0, 73) then
                    NetworkRequestControlOfEntity(entity)
                    SetEntityAsMissionEntity(entity, true, true)
                    if IsEntityAVehicle(entity) then
                        --TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(entity)), VehToNet(entity))
                        --TriggerEvent('persistent-vehicles/forget-vehicle', entity)
                    end
                    if DoesEntityExist(entity) then
                        if IsEntityAnObject(entity) then
                            --TriggerServerEvent("DeleteEntity", token, { ObjToNet(entity) })
                        end
                        if IsEntityAVehicle(entity) then
                            --TriggerServerEvent("DeleteEntity", token, { VehToNet(entity) })
                        end
                        if IsEntityAPed(entity) then
                            --TriggerServerEvent("DeleteEntity", token, { PedToNet(entity) })
                        end
                    end
                    DeleteEntity(entity)
                    SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
                end

                if IsControlJustPressed(0, 38) then
                    TriggerEvent("addToCopy", "{hash = " .. model .. ", name = "..entName..", pos = vector4(" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ", " .. heading .. ")},")
                end
            end
        end
    end
end

local function IsFreecamFrozen()
    return _internal_isFrozen
end

local function GetFreecamPosition()
    return _internal_pos
end

local function SetFreecamPosition(x, y, z)
    local pos = vector3(x, y, z)

    SetCamCoord(_internal_camera, pos)

    _internal_pos = pos
end

local function GetFreecamRotation()
    return _internal_rot
end

local function SetFreecamRotation(x, y, z)
    local x = Clamp(x, -90.0, 90.0)
    local y = y % 360
    local z = z % 360
    local rot = vector3(x, y, z)
    local vecX, vecY, vecZ = EulerToMatrix(x, y, z)

    LockMinimapAngle(math.floor(z))
    SetCamRot(_internal_camera, rot)

    _internal_rot = rot
    _internal_vecX = vecX
    _internal_vecY = vecY
    _internal_vecZ = vecZ
end

local function SetFreecamFov(fov)
    local fov = Clamp(fov, 0.0, 90.0)

    SetCamFov(_internal_camera, fov)
    _internal_fov = fov
end

local function GetFreecamMatrix()
    return _internal_vecX, _internal_vecY, _internal_vecZ, _internal_pos
end

local function IsFreecamEnabled()
    return IsCamActive(_internal_camera) == 1
end

local controls = { 12, 13, 14, 15, 16, 17, 18, 19, 50, 85, 96, 97, 99, 115, 180, 181, 198, 261, 262 }

local function LockControls()
    for k, v in pairs(controls) do
        DisableControlAction(0, v, true)
    end

    EnableControlAction(0, 166, true)
end

local function SetFreecamEnabled(enable)
    if enable == IsFreecamEnabled() then
        return
    end

    if enable then
        local pos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot()

        _internal_camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetFreecamFov(settings.fov)
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)
    else
        DestroyCam(_internal_camera)
        ClearFocus()
        UnlockMinimapPosition()
        UnlockMinimapAngle()
    end

    RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

local function SetEnabled(enable)
    return SetFreecamEnabled(enable)
end

local function GetPlayerServerIdInDirection(range)
    local maxRange = range or 75.0
    local ped = VFW.PlayerData.ped
    local playerPos = GetEntityCoords(ped)
    local closestPlayer = nil
    local minDistance = maxRange

    for _, v in pairs(GetActivePlayers()) do
        local otherPed = GetPlayerPed(v)

        if otherPed ~= ped and IsEntityVisible(otherPed) then
            local otherPedPos = GetEntityCoords(otherPed)
            local distance = #(playerPos - otherPedPos)

            if distance <= maxRange then
                local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(otherPedPos.x, otherPedPos.y, otherPedPos.z)

                if onScreen then
                    local screenDistance = math.sqrt((screenX - 0.5) ^ 2 + (screenY - 0.5) ^ 2)

                    if screenDistance < 0.125 and distance < minDistance then
                        closestPlayer = v
                        minDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer ~= nil and GetPlayerServerId(closestPlayer) or nil
end

local NoClipSpeedCount = 1.0
local NoClipSpeed = 1.0

local function CameraLoop()
    if (not IsFreecamEnabled() and not speconmod) or IsPauseMenuActive() then
        return
    end

    if not IsFreecamFrozen() then
        if not speconmod then
            local vecX, vecY = GetFreecamMatrix()
            local vecZ = vector3(0, 0, 1)
            local pos = GetFreecamPosition()
            local rot = GetFreecamRotation()
            -- Get mouse input
            local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
            local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)
            -- Calculate new rotation.
            local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
            local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
            local rotY = 0.0

            if #(pos - GetEntityCoords(VFW.PlayerData.ped)) > 20.0 then
                pos = GetEntityCoords(VFW.PlayerData.ped)
            end

            if IsControlPressed(1, 241) then
                if NoClipSpeed < 1 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.1, 1)
                elseif NoClipSpeed < 5 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.5, 5)
                elseif NoClipSpeed < 10 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.75, 10)
                elseif NoClipSpeed < 20 then
                    NoClipSpeed = math.min(NoClipSpeed + 1.0, 20)
                else
                    NoClipSpeed = math.min(NoClipSpeed + 1.25, 40)
                end
                NoClipSpeedCount = NoClipSpeed
            end

            if IsControlPressed(1, 242) then
                if NoClipSpeed > 20 then
                    NoClipSpeed = math.max(NoClipSpeed - 1.25, 20)
                elseif NoClipSpeed > 10 then
                    NoClipSpeed = math.max(NoClipSpeed - 1.0, 5)
                elseif NoClipSpeed > 5 then
                    NoClipSpeed = math.max(NoClipSpeed - 0.75, 1)
                elseif NoClipSpeed > 1 then
                    NoClipSpeed = math.max(NoClipSpeed - 0.5, 0.5)
                else
                    NoClipSpeed = math.max(NoClipSpeed - 0.1, 0.1)
                end
                NoClipSpeedCount = NoClipSpeed
            end

            if IsControlPressed(1, 132) then
                NoClipSpeed = 0.1
            end

            if IsControlPressed(1, 131) then
                NoClipSpeed = 45.0
            end

            if IsControlJustReleased(1, 132) then
                NoClipSpeed = NoClipSpeedCount
            end

            if IsControlJustReleased(1, 131) then
                NoClipSpeed = NoClipSpeedCount
            end

            if IsControlPressed(1, 44) then
                pos = pos + (vecZ * NoClipSpeed)
            end

            if IsControlPressed(1, 20) then
                pos = pos - (vecZ * NoClipSpeed)
            end

            if IsControlPressed(1, 31) then
                pos = pos - (vecY * NoClipSpeed)
            end

            if IsControlPressed(1, 32) then
                pos = pos + (vecY * NoClipSpeed)
            end

            if IsControlPressed(1, 34) then
                pos = pos - (vecX * NoClipSpeed)
            end

            if IsControlPressed(1, 35) then
                pos = pos + (vecX * NoClipSpeed)
            end

            -- Adjust new rotation
            rot = vector3(rotX, rotY, rotZ)
            -- Update camera

            if StaffMenu.isInDevMode and StaffMenu.PrintPropsAndEntities then
                UpdateEntityLooking()
            end

            if StaffMenu.isInDevMode and showMarker then
                -- instructionalButtons[idInstructionalButtons[1]] = {
                --    { control = 25, label = "Ouvrir le profil du joueur" },
                --    { control = 24, label = "Lock le joueur" },
                --    { control = 47, label = "Masquer le marker" }
                --}
            elseif StaffMenu.isInDevMode then
                -- instructionalButtons[idInstructionalButtons[1]] = {
                --    { control = 25, label = "Ouvrir le profil du joueur" },
                --    { control = 24, label = "Lock le joueur" },
                --    { control = 47, label = "Afficher le marker" }
                --}
            else
                -- instructionalButtons[idInstructionalButtons[1]] = {
                --    { control = 25, label = "Ouvrir le profil du joueur"},
                --    { control = 24, label = "Lock le joueur" }
                --}
            end

            SetFreecamPosition(pos.x, pos.y, pos.z)
            SetFreecamRotation(rot.x, rot.y, rot.z)
            LockControls()
            SetPedCoordsKeepVehicle(VFW.PlayerData.ped, pos.x, pos.y, pos.z)

            if IsControlJustReleased(0,24) then
                targetid = GetPlayerServerIdInDirection()
                targetped = GetPlayerPed(GetPlayerFromServerId(targetid))
                if targetid ~= nil and targetped ~= VFW.PlayerData.ped and targetped ~= nil and IsPedAPlayer(targetped) then
                    NetworkSetInSpectatorMode(true, targetped)
                    AttachEntityToEntity(VFW.PlayerData.ped, targetped, 31086, 0.0, 0, 50.0, 0, 0, 0, true, true, false, true, 1, false)
                    SetEnabled(false)
                    speconmod = true
                end
            end

            if IsControlJustReleased(0,25) then
                targetid = GetPlayerServerIdInDirection()
                if targetid ~= nil then
                    ExecuteCommand("openplayer "..targetid)
                end
            end
        else
            -- instructionalButtons[idInstructionalButtons[2]] = {}
            -- instructionalButtons[idInstructionalButtons[1]] = {
            --    { control = 24, label = "Unlock le joueur" },
            --    { control = 38, label = "Ouvrir le profil du joueur" }
            --}

            if targetid == nil or targetped == nil or not IsPedAPlayer(targetped) then
                local postion = GetEntityCoords(VFW.PlayerData.ped)
                NetworkSetInSpectatorMode(false, targetped)
                SetEntityNoCollisionEntity(VFW.PlayerData.ped, targetped, true)
                DetachEntity(VFW.PlayerData.ped, true, true)
                SetEntityCoords(VFW.PlayerData.ped, postion.x + 0.5, postion.y + 0.5, postion.z + 0.5)
                targetped = nil
                targetid = nil
                SetEnabled(true)
                speconmod = false
                return
            end

            if IsControlJustReleased(0, 38) or IsControlJustReleased(0, 25) then
                ExecuteCommand("openplayer "..targetid)
            end

            if IsControlJustReleased(0, 24) then
                if IsEntityAttached(VFW.PlayerData.ped) then
                    local targetPosition = GetEntityCoords(targetped)
                    NetworkSetInSpectatorMode(false, targetped)
                    SetEntityNoCollisionEntity(VFW.PlayerData.ped, targetped, true)
                    DetachEntity(VFW.PlayerData.ped, true, true)
                    SetEntityCoords(VFW.PlayerData.ped, targetPosition.x + 0.5, targetPosition.y + 0.5, targetPosition.z + 0.5)
                    targetped = nil
                    targetid = nil
                    SetEnabled(true)
                    speconmod = false
                end
            end
        end
    end
end

function VFW.ToggleNoclip()
    if not StaffMenu.adminChecked then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour utiliser cette commande"
        })
        return
    end

    if inNoClip then
        local pPed = VFW.PlayerData.ped
        local pCoords = GetEntityCoords(pPed)
        local pVeh = GetVehiclePedIsIn(pPed, false)

        if IsEntityAttached(pPed) and speconmod then
            local postion = GetEntityCoords(pPed)

            NetworkSetInSpectatorMode(false, targetped)
            SetEntityNoCollisionEntity(pPed, targetped, true)
            DetachEntity(pPed, true, true)
            SetEntityCoords(pPed, postion.x + 0.5, postion.y + 0.5, postion.z + 0.5)
            speconmod, targetped, targetid = false, nil, nil
        end

        inNoClip = false
        SetEnabled(false)
        SetNoClipAttributes(pPed, pVeh, false)
        -- instructionalButtons[idInstructionalButtons[1]] = {}
        -- instructionalButtons[idInstructionalButtons[2]] = {}

        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)

        if get then
            if pVeh ~= 0 then
                SetEntityCoordsNoOffset(pVeh, pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
            else
                SetEntityCoordsNoOffset(pPed, pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
            end
        end

        return
    else
        inNoClip = true
        SetEnabled(true)

        CreateThread(function()
            while inNoClip do
                local ped = VFW.PlayerData.ped

                CameraLoop()
                SetNoClipAttributes(ped, GetVehiclePedIsIn(ped, false), true)
                Wait(0)
            end
        end)
    end
end

function VFW.IsNoclipActive()
    return inNoClip
end
