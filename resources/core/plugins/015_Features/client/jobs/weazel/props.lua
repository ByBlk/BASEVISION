
local isHoldingMic = false 
local isHoldingBmic = false 
local isHoldingCam = false

local bigMicroNetwork
local camNetwork

function ToggleMicrophoneWeazel()
    if VFW.PlayerData.job.onDuty then
        if not isHoldingMic then 
            isHoldingMic = true

            ExecuteCommand("e microck")
        else
            isHoldingMic = false
            ClearPedTasksImmediately(VFW.PlayerData.ped)
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end

    CreateThread(function()
        local currentEmote = "microck"

        while isHoldingMic do 
            VFW.ShowHelpNotification("Appuyez sur ~INPUT_FRONTEND_RIGHT~ pour changer de posture")

            if IsControlJustPressed(0, 190) then
                if currentEmote == "microck" then
                    ExecuteCommand("e microcki")
                    currentEmote = "microcki"
                else
                    ExecuteCommand("e microck")
                    currentEmote = "microck"
                end
            end
            Wait(0)
        end
    end)
end

function ToggleBigMicroWeazel()
    if VFW.PlayerData.job.onDuty then
        if not isHoldingBmic then
            local model = "prop_v_bmike_01"
            local anim, lib = "mcs2_crew_idle_m_boom", "missfra1"

            RequestModel(model)

            while not HasModelLoaded(model) do 
                Wait(0) 
            end

            RequestAnimDict(lib)

            while not HasAnimDictLoaded(lib) do 
                Wait(0) 
            end

            local coords = GetOffsetFromEntityInWorldCoords(VFW.PlayerData.ped, 0.0, 0.0, -5.0)
            local bigCam = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, true, true, true)
            Wait(1000)
            local networkId = ObjToNet(bigCam)
            SetNetworkIdExistsOnAllMachines(networkId, true)
            NetworkSetNetworkIdDynamic(networkId, true)
            SetNetworkIdCanMigrate(networkId, false)
            AttachEntityToEntity(bigCam, VFW.PlayerData.ped, GetPedBoneIndex(VFW.PlayerData.ped, 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            TaskPlayAnim(VFW.PlayerData.ped, lib, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
            bigMicroNetwork = networkId
            isHoldingBmic = true
        else
            ClearPedSecondaryTask(VFW.PlayerData.ped)
            SetModelAsNoLongerNeeded(model)
            DeleteEntity(NetToObj(bigMicroNetwork))
            bigMicroNetwork = nil
            isHoldingBmic = false
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end

local isInCameraFov = false
local cameraActive = false
local hideHud = false
local cameraHandle = nil
local fov = 50.0
local fov_min = 1.0
local fov_max = 100.0
local zoomLevel = 50.0



function ToggleCamWeazel()
    if VFW.PlayerData.job.onDuty then 
        if not isHoldingCam then 
            local model = "prop_v_cam_01"
            local anim, lib = "fin_c2_mcs_1_camman", "missfinale_c2mcs_1"

            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            
            RequestAnimDict(lib)
            while not HasAnimDictLoaded(lib) do Wait(0) end
            
            local coords = GetOffsetFromEntityInWorldCoords(VFW.PlayerData.ped, 0.0, 0.0, -5.0)
            local cam = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, true, true, true)
            Wait(1000)
            local networkId = ObjToNet(cam)
            SetNetworkIdExistsOnAllMachines(networkId, true)
            NetworkSetNetworkIdDynamic(networkId, true)
            SetNetworkIdCanMigrate(networkId, false)
            AttachEntityToEntity(cam, VFW.PlayerData.ped, GetPedBoneIndex(VFW.PlayerData.ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            TaskPlayAnim(VFW.PlayerData.ped, lib, anim, 1.0, -1, -1, 50, 0, 0, 0, 0)
            camNetwork = networkId
            isHoldingCam = true

            
        else
            ClearPedSecondaryTask(VFW.PlayerData.ped)
            SetModelAsNoLongerNeeded(model)
            DeleteEntity(NetToObj(camNetwork))
            camNetwork = nil
            isHoldingCam = false
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end

    CreateThread(function()
        while isHoldingCam do 
            DisablePlayerFiring(VFW.PlayerData.ped, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(1, 45, true) 
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            SetCurrentPedWeapon(VFW.PlayerData.ped, GetHashKey("WEAPON_UNARMED"), true)

            if not isInCameraFov then 
                VFW.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour activer/désactiver la caméra")
            end

            if IsControlJustPressed(0, 38) then
                cameraActive = not cameraActive
                if cameraActive then

                    isInCameraFov = true

                    local playerPed = PlayerPedId()
                    cameraHandle = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                    AttachCamToEntity(cameraHandle, playerPed, 0.0, 0.0, 1.0, true)
                    SetCamRot(cameraHandle, GetEntityRotation(playerPed, 2), 2)
                    SetCamFov(cameraHandle, fov)
                    SetCamActive(cameraHandle, true)
                    RenderScriptCams(true, false, 0, true, true)
                    SetTimecycleModifier("default")
                    SetTimecycleModifierStrength(0.3)
                else
                    if DoesCamExist(cameraHandle) then
                        DestroyCam(cameraHandle, false)
                        RenderScriptCams(false, false, 0, true, true)
                        cameraHandle = nil
                        ClearTimecycleModifier()
                        isInCameraFov = false
                    end
                end
            end
            
            if cameraActive then
                --instructionalButtons[idInstructionalButtons[1]] = {
                --    { control = 38, label = "Activer la caméra" },
                --    { control = 245, label = "Éditer le titre"},
                --    { control = 101, label = "Cacher le HUD"},
                --    { control = 241, label = "Zoomer" },
                --    { control = 242, label = "Dézoomer" },
                --}

                if IsControlPressed(0, 241) then 
                    fov = math.max(fov_min, fov - 1.0)
                elseif IsControlPressed(0, 242) then 
                    fov = math.min(fov_max, fov + 1.0)
                end

                if IsControlJustPressed(0, 101) then 
                    hideHud = not hideHud

                    if hideHud then
                        VFW.Nui.HudVisible(true)
                        DisplayRadar(true)
                    else
                        VFW.Nui.HudVisible(false)
                        DisplayRadar(false)
                    end
                end

                if IsControlJustPressed(0, 245) then 
                    local input = VFW.Nui.KeyboardInput(true, "Texte du scaleform ?", nil)

                    if not input then 
                        return VFW.ShowNotification({ type = 'ROUGE', content = "Vous devez entrer un texte valide."})
                    end

                    -- TODO : MAKE SCALEFORM FOR WEAZEL
                end
                
                if DoesCamExist(cameraHandle) then
                    SetCamFov(cameraHandle, fov)
                end
                

                local xMagnitude = GetDisabledControlNormal(0, 1)
                local yMagnitude = GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(cameraHandle, 2)
                
                camRot = vector3(camRot.x - yMagnitude * 5.0, 0.0, camRot.z - xMagnitude * 5.0)
                SetCamRot(cameraHandle, camRot, 2)

                if IsControlJustPressed(0, 177) then
                    cameraActive = false
                    DestroyCam(cameraHandle, false)
                    RenderScriptCams(false, false, 0, true, true)
                    cameraHandle = nil
                    ClearTimecycleModifier()
                end
            else
                --instructionalButtons[idInstructionalButtons[1]] = {}
            end
            Wait(0) 
        end
    end)
end


-- RegisterCommand("testWeazel", function()
--     VFW.Scaleform.ShowBreakingNews("Gamingo", "Gamingo est mort", "cc", 1000)
-- end)
