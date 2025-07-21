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

local function GetCameraDestination(cam)
    local cameraRotation = GetCamRot(cam)
    local cameraCoord = GetCamCoord(cam)
    local direction = RotationToDirection(cameraRotation)

    return {
        x = cameraCoord.x + direction.x * 5.0,
        y = cameraCoord.y + direction.y * 5.0,
        z = cameraCoord.z + direction.z * 5.0
    }
end

CameraSettingsCopy = {
    camera = nil,
    Fov = 45.0,
    Dof = false,
    Freeze = false,
    DofStrength = 0.0
}
local cameraSettingsTemp = {
    freeze = false,
    insideCam = false
}
local list = {
    indexFlou = 1,
    indexTransition = 1,
    indexEffet = 1,
    indexAmplitude = 1,
    indexFOV = 1,
    indexCamEffet = 1,
    valueFlou = {"0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0"},
    valueTransition = {"0.0", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0", "10.0", "15.0", "20.0", "30.0", "40.0", "50.0", "60.0"},
    valueEffet = {"Aucun", "DEATH_FAIL_IN_EFFECT_SHAKE", "DRUNK_SHAKE", "FAMILY5_DRUG_TRIP_SHAKE", "HAND_SHAKE", "JOLT_SHAKE", "LARGE_EXPLOSION_SHAKE", "MEDIUM_EXPLOSION_SHAKE", "SMALL_EXPLOSION_SHAKE", "ROAD_VIBRATION_SHAKE", "SKY_DIVING_SHAKE", "VIBRATE_SHAKE"},
    valueamPlitude = {"0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0"},
    valueFov = {"1","2","3","4","5","6","7","8", "9", "10", "20", "30", "40", "50", "60", "70", "80", "90"},
    valueCamEffet = {"0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0"},
}

function StaffMenu.BuildCameraMenu()
    xmenu.items(StaffMenu.camera, function()
        addButton("COLLER UNE CONFIGURATION CAMÉRA", { rightIcon = "chevron" }, {
            onSelected = function()
                local copy = VFW.Nui.KeyboardInput(true,"Copier la configuration de la caméra")
                if copy and copy:len() > 0 then
                    local data = json.decode(copy)
                    CameraSettingsCopy = data
                    console.debug("Copie de la configuration de la caméra", json.encode(CameraSettingsCopy))
                    -- exemple : {"COH":{"x":-426.2574157714844,"y":-613.9692993164063,"z":29.8827953338623,"w":327.56024169921877},"CamRot":{"x":-2.35205030441284,"y":-0.0,"z":149.8805389404297},"DofStrength":1.0,"Dof":true,"Fov":31.0}
                    -- now create the preview camera
                    local pedCoords = GetEntityCoords(VFW.PlayerData.ped)
                    local camRot = CameraSettingsCopy.CamRot
                    local camCoord = CameraSettingsCopy.CamCoords
                    local coh = CameraSettingsCopy.COH
                    local fov = CameraSettingsCopy.Fov
                    local dof = CameraSettingsCopy.Dof
                    local transition = CameraSettingsCopy.Transition
                    local dofStrength = CameraSettingsCopy.DofStrength or 1.0
                    SetEntityVisible(VFW.PlayerData.ped, CameraSettingsCopy.Invisible == false and false or true)
                    SetEntityCoords(VFW.PlayerData.ped, coh.x, coh.y, coh.z - 0.9)
                    SetEntityHeading(VFW.PlayerData.ped, coh.w)
                    console.debug("Transition", transition)
                    if CameraSettingsCopy.Animation then
                        console.debug(CameraSettingsCopy.Animation, CameraSettingsCopy.Animation.dict, CameraSettingsCopy.Animation.anim)
                        RequestAnimDict(CameraSettingsCopy.Animation.dict)
                        local timer = 1
                        while (not HasAnimDictLoaded(CameraSettingsCopy.Animation.dict)) and timer < 200 do
                            Wait(0)
                            timer += 1
                            console.debug("requesting animation")
                        end
                        TaskPlayAnim(VFW.PlayerData.ped, CameraSettingsCopy.Animation.dict, CameraSettingsCopy.Animation.anim, 8.0, 8.0, -1, 1, 0, false, false, false)
                        RemoveAnimDict(CameraSettingsCopy.Animation.dict)
                    end
                    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoord.x, camCoord.y, camCoord.z, camRot.x, camRot.y, camRot.z, fov, true, 0)
                    SetCamActive(cam, true)
                    SetCamRot(cam, camRot.x, camRot.y, camRot.z, 2)
                    SetCamFov(cam, fov)
                    SetCamUseShallowDofMode(cam, true) -- Sets the camera to use shallow dof mode
                    SetCamNearDof(cam, 0.6) -- Sets the camera's near dof to the value set in the config file
                    SetCamFarDof(cam, 4.0) -- Sets the camera's far dof to the value set in the config file
                    SetCamDofStrength(cam, dofStrength)
                    console.debug("Does cam exists", DoesCamExist(cam), cam)
                    CreateThread(function()
                        while DoesCamExist(cam) do
                            Wait(0)
                            if IsControlJustPressed(0, 194) or IsDisabledControlJustPressed(0, 194) then
                                SetCamActive(cam, false)
                                ClearPedTasks(VFW.PlayerData.ped)
                                DestroyCam(cam)
                                RenderScriptCams(false, false, 0, true, true)
                            end
                            SetUseHiDof() -- Sets the camera to use high dof
                        end
                    end)
                    console.debug(true, (transition and true or false), math.floor((transition and transition*1000 or 0)))
                    RenderScriptCams(true, (transition and true or false), math.floor((transition and transition*1000 or 0)))
                end
            end,
        })

        addSeparator("CRÉATION DE CAMÉRA")

        addCheckbox("PERSONNAGE INVISIBLE", CameraSettingsCopy.Invisible, {}, {
            onChange = function(checked)
                CameraSettingsCopy.Invisible = checked
                SetEntityVisible(VFW.PlayerData.ped, not checked)
            end
        })

        addCheckbox("ACTIVER LE FLOU", CameraSettingsCopy.Dof, {}, {
            onChange = function(checked)
                CameraSettingsCopy.Dof = checked
            end
        })

        addCheckbox("FREEZE LA CAMÉRA", cameraSettingsTemp.freeze, {}, {
            onChange = function(checked)
                cameraSettingsTemp.freeze = checked
                AdminFreecam.SetFreecamFrozen(checked)
            end
        })

        addList("INTENSITÉ DE FLOU", list.valueFlou, list.indexFlou, {}, {
            onChange = function(value)
                list.indexFlou = value
                if tonumber(list.valueFlou[list.indexFlou]) ~= 0 then
                    SetCamUseShallowDofMode(AdminFreecam._internal_camera, true) -- Sets the camera to use shallow dof mode
                    SetCamNearDof(AdminFreecam._internal_camera, 0.6) -- Sets the camera's near dof to the value set in the config file
                    SetCamFarDof(AdminFreecam._internal_camera, 4.0) -- Sets the camera's far dof to the value set in the config file
                    SetCamDofStrength(AdminFreecam._internal_camera, (tonumber(list.valueFlou[list.indexFlou])))
                    CameraSettingsCopy.DofStrength = (tonumber(list.valueFlou[list.indexFlou]))
                else
                    SetCamUseShallowDofMode(AdminFreecam._internal_camera, false)
                end
            end
        })

        addList("TRANSITION EN SECONDES", list.valueTransition, list.indexTransition, {}, {
            onChange = function(value)
                list.indexTransition = value
                CameraSettingsCopy.Transition = (tonumber(list.valueTransition[list.indexTransition]))
            end
        })

        addList("EFFETS CAMÉRA", list.valueEffet, list.indexEffet, {}, {
            onChange = function(value)
                list.indexEffet = value
                if list.indexEffet == O then
                    ShakeCam(AdminFreecam._internal_camera, "DRUNK_SHAKE", 0.0)
                    CameraSettingsCopy.CamEffects = nil
                else
                    ShakeCam(AdminFreecam._internal_camera, list.valueEffet[list.indexEffet], CameraSettingsCopy.CamEffectsAmplitude or 0.5)
                end
                CameraSettingsCopy.CamEffects = list.valueEffet[list.indexEffet]
            end
        })

        addList("AMPLITUDE DES EFFETS", list.valueCamEffet, list.indexCamEffet, {}, {
            onChange = function(value)
                list.indexCamEffet = value
                if CameraSettingsCopy.CamEffects then
                    ShakeCam(AdminFreecam._internal_camera, CameraSettingsCopy.CamEffects, tonumber(list.valueCamEffet[list.indexCamEffet]))
                end
                CameraSettingsCopy.CamEffectsAmplitude = tonumber(list.valueCamEffet[list.indexCamEffet])
            end
        })

        addList("FOV", list.valueFov, list.indexFOV, {}, {
            onChange = function(value)
                list.indexFOV = value
                SetCamFov(AdminFreecam._internal_camera, tonumber(list.valueFov[list.indexFOV] + 0.1))
                CameraSettingsCopy.Fov = tonumber(list.valueFov[list.indexFOV] + 0.1)
            end
        })

        addCheckbox("PRÉVISUALISATION LA CAMÉRA", cameraSettingsTemp.insideCam, {}, {
            onChange = function(checked)
                cameraSettingsTemp.insideCam = checked
                AdminFreecam.SetFreecamActive(cameraSettingsTemp.insideCam)
            end
        })

        addButton("COPIER LA CONFIGURATION CAMÉRA", { rightIcon = "chevron" }, {
            onSelected = function()
                local pedCoords = GetEntityCoords(VFW.PlayerData.ped)
                CameraSettingsCopy.CamRot = GetCamRot(AdminFreecam._internal_camera)
                CameraSettingsCopy.CamCoords = GetCamCoord(AdminFreecam._internal_camera)
                CameraSettingsCopy.OffsetPlayer = GetOffsetFromEntityGivenWorldCoords(VFW.PlayerData.ped, CameraSettingsCopy.CamCoords.x, CameraSettingsCopy.CamCoords.y, CameraSettingsCopy.CamCoords.z)
                local destination = GetCameraDestination(AdminFreecam._internal_camera)
                CameraSettingsCopy.OffsetLook = GetOffsetFromEntityGivenWorldCoords(VFW.PlayerData.ped, destination.x, destination.y, destination.z)
                CameraSettingsCopy.COH = vector4(pedCoords.x, pedCoords.y, pedCoords.z, GetEntityHeading(VFW.PlayerData.ped))
                if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                    local coords = GetEntityCoords(GetVehiclePedIsIn(VFW.PlayerData.ped, false))
                    CameraSettingsCopy.COH = vector4(coords.x, coords.y, coords.z, GetEntityHeading(GetVehiclePedIsIn(VFW.PlayerData.ped, false)))
                    CameraSettingsCopy.Vehicle = GetEntityModel(GetVehiclePedIsIn(VFW.PlayerData.ped, false))
                end
                local animationData = VFW.GetPedAnimationIsPlaying()
                if animationData then
                    CameraSettingsCopy.Animation = { anim = animationData[2], dict = animationData[1] }
                end
                VFW.ShowNotification({
                    type = 'VERT',
                    content = "Configuration de la caméra copiée dans votre presse-papier."
                })
                TriggerEvent("addToCopy", json.encode(CameraSettingsCopy))
            end,
        })
    end)
end
