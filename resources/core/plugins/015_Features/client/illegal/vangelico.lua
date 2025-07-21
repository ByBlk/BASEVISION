local hasAlreadyTaken = false
local vangelicoHeist = {
    ["globalObj"] = nil,
    ['globalItem'] = nil,
}
local alarmeOff = false
local insideLoop = false
local busy = false
local prevAnim = ''
local hasfondu = false
local blip = {}
local blip2 = {}
local VangelicoHeist2 = {
    ['startPeds'] = {},
    ['painting'] = {},
    ['gasMask'] = false,
    ['globalObject'] = nil,
    ['globalItem'] = nil,
}
local reward = nil
local glass = nil
local rewardDisp = nil
local glassConfig = vangelico_config["glassCutting"]
local HasBraqued = false
local hasLaptop = false
local looted = 0
local looted2 = 0
local hasGotAll = false
local allTableau = false
local allVitres = false
local sentone = false
local senttwo = false
local ArtHeist = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s',
        'w_me_switchblade'
    },
    ['animations'] = {
        {"top_left_enter", "top_left_enter_ch_prop_ch_sec_cabinet_02a", "top_left_enter_ch_prop_vault_painting_01a", "top_left_enter_hei_p_m_bag_var22_arm_s", "top_left_enter_w_me_switchblade"},
        {"cutting_top_left_idle", "cutting_top_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_idle_ch_prop_vault_painting_01a", "cutting_top_left_idle_hei_p_m_bag_var22_arm_s", "cutting_top_left_idle_w_me_switchblade"},
        {"cutting_top_left_to_right", "cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_to_right_ch_prop_vault_painting_01a", "cutting_top_left_to_right_hei_p_m_bag_var22_arm_s", "cutting_top_left_to_right_w_me_switchblade"},
        {"cutting_top_right_idle", "_cutting_top_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_right_idle_ch_prop_vault_painting_01a", "cutting_top_right_idle_hei_p_m_bag_var22_arm_s", "cutting_top_right_idle_w_me_switchblade"},
        {"cutting_right_top_to_bottom", "cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_right_top_to_bottom_ch_prop_vault_painting_01a", "cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_right_top_to_bottom_w_me_switchblade"},
        {"cutting_bottom_right_idle", "cutting_bottom_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_idle_ch_prop_vault_painting_01a", "cutting_bottom_right_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_idle_w_me_switchblade"},
        {"cutting_bottom_right_to_left", "cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_to_left_ch_prop_vault_painting_01a", "cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_to_left_w_me_switchblade"},
        {"cutting_bottom_left_idle", "cutting_bottom_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_left_idle_ch_prop_vault_painting_01a", "cutting_bottom_left_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_left_idle_w_me_switchblade"},
        {"cutting_left_top_to_bottom", "cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_left_top_to_bottom_ch_prop_vault_painting_01a", "cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_left_top_to_bottom_w_me_switchblade"},
        {"with_painting_exit", "with_painting_exit_ch_prop_ch_sec_cabinet_02a", "with_painting_exit_ch_prop_vault_painting_01a", "with_painting_exit_hei_p_m_bag_var22_arm_s", "with_painting_exit_w_me_switchblade"},
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}
local hasvolercaisse = false
local tableauPoints = {}
local stolenPaintings = {}
local fondreVitrePoint = nil
local briserVitrePoint = {}
local caissePoint = nil
local hasFondu = false

local function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(50)
    end
end

local function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Wait(50)
    end
end

local function PlayAnim(dict, anim, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(1) end
    TaskPlayAnim(VFW.PlayerData.ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    RemoveAnimDict(dict)
end

function StartVangelicoHeist()
    HasBraqued = false
    local playerLicenseKey = 'heistsLimitPerReboot_' .. VFW.PlayerData.identifier
    local goFastLimitPerReboot = (GlobalState[playerLicenseKey] and GlobalState[playerLicenseKey].vangelico) or nil

    if goFastLimitPerReboot == nil or goFastLimitPerReboot < 1 then
        VFW.RemoveInteraction("vangelicoHack")
        if VangelicoHack then
            Worlds.Zone.Remove(VangelicoHack)
            VangelicoHack = nil
        end

        local bool = HackAnimation()
        while bool == nil do
            Wait(1)
        end

        if bool == true then
            OpenStepCustom("Braquage Vangelico", "Brise les vitres, vole la caisse et les tableaux")
            SetTimeout(7500, function()
                HideStep()
            end)

            TriggerServerEvent("core:removeLaptop")

            TriggerServerEvent('core:alert:makeCall', "lspd", vector3(-633.33001708984, -238.84931945801, 38.069793701172), true, "Braquage de bijouterie")
            TriggerServerEvent('core:alert:makeCall', "lssd", vector3(-633.33001708984, -238.84931945801, 38.069793701172), true, "Braquage de bijouterie")
            alarmeOff = true
            -- TriggerServerEvent("core:crew:updateXp", tonumber(varVang.xp), "add", p:getCrew(), "vangelico heist")

            local randoeem = 1
            loadModel(glassConfig.rewards[randoeem].object.model)
            loadModel(glassConfig.rewards[randoeem].displayObj.model)
            loadModel('h4_prop_h4_glass_disp_01a')

            glass = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01a'), -617.4622, -227.4347, 37.057, 1, 1, 0)
            SetEntityHeading(glass, -53.06)
            for k, v in pairs(vangelico_config['painting']) do
                loadModel(v['object'])
                VangelicoHeist2['painting'][k] = CreateObjectNoOffset(GetHashKey(v['object']), v['objectPos'], 1, 0, 0)
                SetEntityRotation(VangelicoHeist2['painting'][k], 0, 0, v['objHeading'], 2, true)
            end
            reward = CreateObject(GetHashKey(glassConfig.rewards[randoeem].object.model), glassConfig.rewardPos.xy, glassConfig.rewardPos.z + 0.195, 1, 1, 0)
            SetEntityHeading(reward, glassConfig['rewards'][randoeem]['object']['rot'])
            rewardDisp = CreateObject(GetHashKey(glassConfig.rewards[randoeem].displayObj.model), glassConfig.rewardPos, 1, 1, 0)
            SetEntityRotation(rewardDisp, glassConfig.rewards[randoeem].displayObj.rot)
            TriggerServerEvent('core:globalObject', glassConfig.rewards[randoeem].object.model, randoeem)
            TriggerServerEvent('core:insideLoop')
        else
            VangelicoHack = VFW.CreateBlipAndPoint("vangelicoHack", vector3(-630.84014892578, -229.67807006836, 38.057033538818), 1, nil, nil, nil, nil,  "Hacker", "E", "Location",{
                onPress = function()
                    local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

                    if policeNumber and policeNumber >= 0 then
                        for i = 1, #VFW.PlayerData.inventory do
                            if VFW.PlayerData.inventory[i].name == "laptop" then
                                hasLaptop = true
                                break
                            end
                        end

                        if hasLaptop then
                            if not RemoveVangelicoBulle then
                                StartVangelicoHeist()

                                VFW.RemoveInteraction("vangelicoHack")
                                if VangelicoHack then
                                    Worlds.Zone.Remove(VangelicoHack)
                                    VangelicoHack = nil
                                end
                            end
                        end
                    end
                end
            })

            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas réussie a pirater le terminal"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s La boutique a deja été vandalisée !"
        })
    end
end

local function OverHeatScene()
    local reusite = math.random(0, 100)
    busy = true
    TriggerServerEvent("core:sync:vangelicoheat")

    Worlds.Zone.Hide(fondreVitrePoint, false)

    local animDict = 'anim@scripted@heist@ig16_glass_cut@male@'
    sceneObject = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    scenePos = GetEntityCoords(sceneObject)
    sceneRot = GetEntityRotation(sceneObject)
    globalObj = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 5.0, GetHashKey(vangelicoHeist['globalObj']), 0, 0, 0)

    loadAnimDict(animDict)

    RequestScriptAudioBank('DLC_HEI4/DLCHEI4_GENERIC_01', -1)
    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    for k, v in pairs(vangelico_config.Overheat['objects']) do
        loadModel(v)
        vangelico_config.Overheat['sceneObjects'][k] = CreateObject(GetHashKey(v), GetEntityCoords(VFW.PlayerData.ped), 1, 1, 0)
    end

    local newObj = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01b'), GetEntityCoords(sceneObject), 1, 1, 0)
    SetEntityHeading(newObj, GetEntityHeading(sceneObject))

    for i = 1, #vangelico_config.Overheat['animations'] do
        vangelico_config.Overheat['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(VFW.PlayerData.ped, vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(vangelico_config.Overheat['sceneObjects'][1], vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][2], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(vangelico_config.Overheat['sceneObjects'][2], vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][3], 1.0, -1.0, 1148846080)
        if i ~= 5 then
            NetworkAddEntityToSynchronisedScene(sceneObject, vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        else
            NetworkAddEntityToSynchronisedScene(newObj, vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        end
    end

    local sound1 = GetSoundId()
    local sound2 = GetSoundId()

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][1])
    PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'enter') * 1000 - 1000)

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][2])
    PlayCamAnim(cam, 'idle_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'idle') * 1000 - 1500)

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][3])
    PlaySoundFromEntity(sound1, "StartCutting", vangelico_config.Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    loadPtfxAsset('scr_ih_fin')
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire1 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', vangelico_config.Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0, 1065353216, 1065353216, 1065353216, 0)
    PlayCamAnim(cam, 'cutting_loop_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'cutting_loop') * 1000)
    StopSound(sound1)
    StopParticleFxLooped(fire1)

    if reusite < 60 then
        VFW.ShowNotification({
            type = 'JAUNE',
            content = "Vous avez ~s récupéré le diamant !"
        })

        TriggerServerEvent('core:lootSync', 'glassCutting')
        DeleteObject(sceneObject)
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][5])
        Wait(2000)
        DeleteObject(globalObj)
        PlayCamAnim(cam, 'success_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'success') * 1000 - 2000)
        DeleteObject(vangelico_config.Overheat['sceneObjects'][1])
        DeleteObject(vangelico_config.Overheat['sceneObjects'][2])
        ClearPedTasks(VFW.PlayerData.ped)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        TriggerServerEvent("core:addItemToInventory", "diamond", 1)
        busy = false
        TriggerServerEvent('core:vangelico_removeBlips', blip[21])
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous avez ~s échoué,~c prenez la fuite !"
        })

        vangelico_config['glassCutting'].loot = true
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][4])
        PlaySoundFromEntity(sound2, "Overheated", vangelico_config.Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
        UseParticleFxAssetNextCall('scr_ih_fin')
        fire2 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_overheat', vangelico_config.Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0)
        PlayCamAnim(cam, 'overheat_react_01_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'overheat_react_01') * 1000)
        StopSound(sound2)
        StopParticleFxLooped(fire2)

        DeleteObject(sceneObject)
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][6])
        DeleteObject(globalObj)
        PlayCamAnim(cam, 'exit_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'exit') * 1000)
        DeleteObject(vangelico_config.Overheat['sceneObjects'][1])
        DeleteObject(vangelico_config.Overheat['sceneObjects'][2])
        ClearPedTasks(VFW.PlayerData.ped)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        busy = false
    end
    hasfondu = true
    Worlds.Zone.Hide(fondreVitrePoint, true)
end

local function Outside()
    insideLoop = false
    for i = 1, #blip, 1 do
        if DoesBlipExist(blip[i]) then
            RemoveBlip(blip[i])
        end
    end

    for i = 1, #blip2, 1 do
        if DoesBlipExist(blip2[i]) then
            RemoveBlip(blip2[i])
        end
    end

    blip = {}
    blip2 = {}

    RemoveVangelicoBulle = false

    for k, v in pairs(vangelico_config['smashScenes']) do
        v.loot = false
    end

    if not senttwo then
        senttwo = true
        local tablee = {}

        for k, v in pairs(GetActivePlayers()) do
            table.insert(tablee, GetPlayerServerId(v))
        end

        TriggerServerEvent("core:startAlarm", "vangelico", false, tablee)
    end

    vangelico_config['glassCutting'].loot = false
    local glassObjectDel = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    local glassObjectDel2 = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01b'), 0, 0, 0)
    SetModelAsNoLongerNeeded(GetHashKey('h4_prop_h4_glass_disp_01a'))
    SetModelAsNoLongerNeeded(GetHashKey('h4_prop_h4_glass_disp_01b'))
    SetModelAsNoLongerNeeded(GetHashKey(glassConfig.rewards[1].object.model))
    SetModelAsNoLongerNeeded(GetHashKey(glassConfig.rewards[1].displayObj.model))
    DeleteObject(glassObjectDel)
    DeleteObject(glassObjectDel2)
    
    HideStep()

    VangelicoHack = VFW.CreateBlipAndPoint("vangelicoHack", vector3(-630.84014892578, -229.67807006836, 38.057033538818), 1, nil, nil, nil, nil,  "Hacker", "E", "Location",{
        onPress = function()
            local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

            if policeNumber and policeNumber >= 0 then
                for i = 1, #VFW.PlayerData.inventory do
                    if VFW.PlayerData.inventory[i].name == "laptop" then
                        hasLaptop = true
                        break
                    end
                end

                if hasLaptop then
                    if not RemoveVangelicoBulle then
                        StartVangelicoHeist()

                        VFW.RemoveInteraction("vangelicoHack")
                        if VangelicoHack then
                            Worlds.Zone.Remove(VangelicoHack)
                            VangelicoHack = nil
                        end
                    end
                end
            end
        end
    })

    VFW.RemoveInteraction("FondreVitre")
    if fondreVitrePoint then
        Worlds.Zone.Remove(fondreVitrePoint)
        fondreVitrePoint = nil
    end

    VFW.RemoveInteraction("volerCaisse")
    if caissePoint then
        Worlds.Zone.Remove(caissePoint)
        caissePoint = nil
    end

    VFW.RemoveInteraction("volerTableau")
    for i = 1, #tableauPoints, 1 do
        if tableauPoints[i] then
            Worlds.Zone.Remove(tableauPoints[i])
            tableauPoints[i] = nil
        end
    end

    VFW.RemoveInteraction("briserVitre")
    for i = 1, #briserVitrePoint, 1 do
        if briserVitrePoint[i] then
            Worlds.Zone.Remove(briserVitrePoint[i])
            briserVitrePoint[i] = nil
        end
    end

    DeleteObject(glass)
    DeleteObject(reward)
    DeleteObject(rewardDisp)
end

local function SmashScene(index)
    busy = true
    TriggerServerEvent('core:lootSync', 'smashScenes', index)

    local animDict = 'missheist_jewel'
    local ptfxAsset = "scr_jewelheist"
    local particleFx = "scr_jewel_cab_smash"

    loadAnimDict(animDict)
    loadPtfxAsset(ptfxAsset)

    local sceneCfg = vangelico_config['smashScenes'][index]
    SetEntityCoords(VFW.PlayerData.ped, sceneCfg.scenePos)

    local anims = {
        { 'smash_case_necklace', 300 },
        { 'smash_case_d', 300 },
        { 'smash_case_e', 300 },
        { 'smash_case_f', 300 }
    }

    local selected = ""

    repeat
        selected = anims[math.random(1, #anims)]
    until selected ~= prevAnim

    prevAnim = selected

    if index == 4 or index == 10 or index == 14 or index == 8 then
        selected = { 'smash_case_necklace_skull', 300 }
    end

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 0, 0, 0)

    scene = NetworkCreateSynchronisedScene(sceneCfg['scenePos'], sceneCfg['sceneRot'], 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(VFW.PlayerData.ped, scene, animDict, selected[1], 2.0, 4.0, 1, 0, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)

    PlayCamAnim(cam, 'cam_' .. selected[1], animDict, sceneCfg['scenePos'], sceneCfg['sceneRot'], 0, 2)

    Wait(300)

    TriggerServerEvent('core:smashSync', sceneCfg)

    for i = 1, 5 do
        PlaySoundFromCoord(-1, "Glass_Smash", sceneCfg['objPos'], 0, 0, 0)
    end

    SetPtfxAssetNextCall(ptfxAsset)
    StartNetworkedParticleFxNonLoopedAtCoord(particleFx, sceneCfg['objPos'], 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
    Wait(GetAnimDuration(animDict, selected[1]) * 1000 - 1000)

    ClearPedTasks(VFW.PlayerData.ped)

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent('core:vangelico_removeBlips', blip[index])
    TriggerServerEvent("core:addItemToInventory", "jewel", 1)

    VFW.ShowNotification({
        type = 'JAUNE',
        content = 'Vous avez récupéré un bijou.'
    })
    busy = false
end

local function PaintingScene(sceneId)
    local ped = VFW.PlayerData.ped
    local weapon = GetSelectedPedWeapon(ped)

    if weapon == GetHashKey('WEAPON_SWITCHBLADE') or weapon == GetHashKey('weapon_dagger') or weapon == GetHashKey('WEAPON_KNIFE') then
        TriggerServerEvent('vangelicoheist:server:lootSync', 'painting', sceneId)
        busy = true
        local pedCo = GetEntityCoords(ped)
        local scenes = {false, false, false, false}
        local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
        scene = vangelico_config['painting'][sceneId]
        sceneObject = GetClosestObjectOfType(scene['objectPos'], 1.0, GetHashKey(scene['object']), 0, 0, 0)
        scenePos = scene['scenePos']
        sceneRot = scene['sceneRot']
        loadAnimDict(animDict)

        for k, v in pairs(ArtHeist['objects']) do
            loadModel(v)
            ArtHeist['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
        end

        for i = 1, 10 do
            ArtHeist['scenes'][i] = NetworkCreateSynchronisedScene(scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 2, true, false, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(ped, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(sceneObject, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][3], 1.0, -1.0, 1148846080)
            NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][1], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][4], 1.0, -1.0, 1148846080)
            NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][2], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][5], 1.0, -1.0, 1148846080)
        end

        cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, 0, 3000, 1, 0)

        ArtHeist['cuting'] = true
        FreezeEntityPosition(ped, true)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][1])
        PlayCamAnim(cam, 'ver_01_top_left_enter_cam_ble', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)

        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][2])
        PlayCamAnim(cam, 'ver_01_cutting_top_left_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][3])
        PlayCamAnim(cam, 'ver_01_cutting_top_left_to_right_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)

        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][4])
        PlayCamAnim(cam, 'ver_01_cutting_top_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][5])
        PlayCamAnim(cam, 'ver_01_cutting_right_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)

        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][6])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][7])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_to_left_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)

        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][9])
        PlayCamAnim(cam, 'ver_01_cutting_left_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)

        Wait(1500)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][10])
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        Wait(7500)

        local mathran = math.random(1,3)
        if mathran == 1 then
            TriggerServerEvent("core:addItemToInventory", "tabc", 1)
        elseif mathran == 2 then
            TriggerServerEvent("core:addItemToInventory", "tabpc", 1)
        else
            TriggerServerEvent("core:addItemToInventory", "tabr", 1)
        end

        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)

        RemoveAnimDict(animDict)
        for k, v in pairs(ArtHeist['sceneObjects']) do
            DeleteObject(v)
        end

        DeleteObject(sceneObject)
        DeleteEntity(sceneObject)

        ArtHeist['sceneObjects'] = {}
        ArtHeist['scenes'] = {}
        scenes = {false, false, false, false}
        busy = false
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Tu as ~s besoin d'un couteau en main ~c pour voler le tableau"
        })
        return
    end
end

RegisterNetEvent("core:playerInsideLoop")
AddEventHandler("core:playerInsideLoop", function()
    RemoveVangelicoBulle = true

    VFW.RemoveInteraction("vangelicoHack")
    if VangelicoHack then
        Worlds.Zone.Remove(VangelicoHack)
        VangelicoHack = nil
    end

    loadAnimDict('missheist_jewel')
    loadAnimDict('anim@scripted@heist@ig16_glass_cut@male@')
    loadPtfxAsset('scr_ih_fin')
    insideLoop = true

    for k, v in pairs(vangelico_config['smashScenes']) do
        if not DoesBlipExist(blip[k]) then
            blip[k] = AddBlipForCoord(v.objPos)
            SetBlipScale(blip[k], 0.2)
            SetBlipColour(blip[k], 3)
        end
    end

    for k, v in pairs(vangelico_config['painting']) do
        if not DoesBlipExist(blip2[k]) then
            blip2[k] = AddBlipForCoord(v.objectPos)
            SetBlipScale(blip2[k], 0.2)
            SetBlipColour(blip2[k], 5)
        end
    end

    blip[21] = AddBlipForCoord(vector3(-617.4622, -227.4347, 37.057))
    SetBlipScale(blip[21], 0.2)
    SetBlipColour(blip[21], 3)

    Citizen.CreateThread(function()
        while insideLoop do
            local dst = #(GetEntityCoords(VFW.PlayerData.ped) - vector3(-617.4622, -227.4347, 37.057))

            if not busy and not vangelico_config["glassCutting"].loot then
                if not hasFondu then
                    if not fondreVitrePoint then
                        fondreVitrePoint = Worlds.Zone.Create(vector3(-617.4622, -227.4347, 38.52), 1.5, false, function()
                            VFW.RegisterInteraction("FondreVitre", function()
                                if not hasAlreadyTaken then
                                    HideStep()

                                    VFW.ShowNotification({
                                        type = 'JAUNE',
                                        content = "L'alarme a été déclanchée, fais vite !"
                                    })

                                    if not sentone then
                                        local tablee = {}

                                        for k, v in pairs(GetActivePlayers()) do
                                            table.insert(tablee, GetPlayerServerId(v))
                                        end

                                        TriggerServerEvent("core:startAlarm", "vangelico", true, tablee)
                                        sentone = true
                                    end

                                    OverHeatScene()

                                    hasFondu = true

                                    VFW.RemoveInteraction("FondreVitre")
                                    if fondreVitrePoint then
                                        Worlds.Zone.Remove(fondreVitrePoint)
                                        fondreVitrePoint = nil
                                    end
                                end
                            end)
                        end, function()
                            VFW.RemoveInteraction("FondreVitre")
                        end, "Fondre", "E", "Barber")
                    end
                end
            end

            if allTableau and allVitres and not hasGotAll then
                hasGotAll = true
                if not hasfondu then 
                    OpenStepCustom("Braquage Vangelico", "Vous pouvez désormais fondre la vitre et récupérez le diamant")
                    SetTimeout(7500, function()
                        HideStep()
                    end)
                end
            end

            if not busy and not hasvolercaisse then
                if not caissePoint then
                    caissePoint = Worlds.Zone.Create(vector3(-621.78, -229.59, 37.99), 1.5, false, function()
                        VFW.RegisterInteraction("volerCaisse", function()
                            busy = true
                            hasvolercaisse = true

                            VFW.RemoveInteraction("volerCaisse")
                            if caissePoint then
                                Worlds.Zone.Remove(caissePoint)
                                caissePoint = nil
                            end

                            SetEntityCoords(VFW.PlayerData.ped, -622.25360107422, -229.94079589844, 37.057006835938)
                            SetCurrentPedWeapon(VFW.PlayerData.ped, "weapon_unarmed", true)
                            SetEntityHeading(VFW.PlayerData.ped, 303.90)

                            local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                            RequestModel(moneyprop)
                            while not HasModelLoaded(moneyprop) do Wait(1) end

                            local moneyProps = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                            local bone = GetPedBoneIndex(VFW.PlayerData.ped, 28422)
                            AttachEntityToEntity(moneyProps, VFW.PlayerData.ped, bone, 0.0, 0.0, 90.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                            PlayAnim('oddjobs@shop_robbery@rob_till','loop',1)

                            Wait(10000)

                            busy = false
                            DeleteEntity(moneyProps)
                            ClearPedTasks(VFW.PlayerData.ped)

                            local rand = math.random(100, 500)
                            TriggerServerEvent("core:addItemToInventory", "money", rand)

                            VFW.ShowNotification({
                                type = 'JAUNE',
                                content = "Vous avez récupéré " .. rand .. "$"
                            })
                        end)
                    end, function()
                        VFW.RemoveInteraction("volerCaisse")
                    end, "Voler", "E", "Barber")
                end
            end

            for k, v in pairs(vangelico_config['painting']) do
                if not tableauPoints[k] and not stolenPaintings["volerTableau:"..k] then
                    tableauPoints[k] = Worlds.Zone.Create(v['objectPos'], 1.5, false, function()
                        VFW.RegisterInteraction("volerTableau", function()
                            HasBraqued = true
                            looted2 += 1
                            if looted2 == #vangelico_config['painting'] then
                                allTableau = true
                            end
                            
                            HideStep()

                            VFW.RemoveInteraction("volerTableau")
                            if tableauPoints[k] then
                                Worlds.Zone.Remove(tableauPoints[k])
                                tableauPoints[k] = nil
                            end

                            stolenPaintings["volerTableau:"..k] = true

                            PaintingScene(k)
                        end)
                    end, function()
                        VFW.RemoveInteraction("volerTableau")
                    end, "Voler", "E", "Barber")
                end
            end

            if dst >= 40.0 then
                hasfondu = false
                HasBraqued = false
                Outside()
                break
            end
            
            for k, v in pairs(vangelico_config["smashScenes"]) do
                if not v.loot and not busy then
                    if not briserVitrePoint[k] and not stolenPaintings["briserVitre:"..k] then
                        briserVitrePoint[k] = Worlds.Zone.Create(v.objPos + vector3(0.0, 0.0, 0.25), 1.0, false, function()
                            VFW.RegisterInteraction("briserVitre", function()
                                if IsPedArmed(VFW.PlayerData.ped, 4) then
                                    looted += 1

                                    if looted == #vangelico_config["smashScenes"] then
                                        allVitres = true
                                    end

                                    VFW.RemoveInteraction("briserVitre")
                                    if briserVitrePoint[k] then
                                        Worlds.Zone.Remove(briserVitrePoint[k])
                                        briserVitrePoint[k] = nil
                                    end

                                    stolenPaintings["briserVitre:"..k] = true

                                    SmashScene(k)

                                    if looted == 4 then
                                        OpenStepCustom("Braquage Vangelico", "Lorsque vous avez fini de casser toutes les vitres, utilisez votre couteau pour voler les oeuvres d'arts")
                                        SetTimeout(7500, function()
                                            HideStep()
                                        end)
                                    end
                                else
                                    VFW.ShowNotification({
                                        type = 'ROUGE',
                                        content = "Tu as ~s besoin d'une arme ~c pour casser la vitre"
                                    })
                                end
                            end)
                        end, function()
                            VFW.RemoveInteraction("briserVitre")
                        end, "Briser", "E", "Barber")
                    end
                end
            end

            Wait(1)
        end
    end)
end)

RegisterNetEvent("core:globalObjectStock")
AddEventHandler("core:globalObjectStock", function(obj, random)
    vangelicoHeist['globalObj'] = obj
    vangelicoHeist['globalItem'] = vangelico_config["glassCutting"].rewards[random].item
end)

RegisterNetEvent("core:sync:vangelicoheat", function()
    hasAlreadyTaken = true
end)

RegisterNetEvent('vangelicoheist:client:lootSync')
AddEventHandler('vangelicoheist:client:lootSync', function(_type, _index)
    if _index then
        vangelico_config[_type][_index].loot = true
    else
        vangelico_config[_type].loot = true
    end

    VFW.RemoveInteraction("volerTableau")
    if tableauPoints[_index] then
        Worlds.Zone.Remove(tableauPoints[_index])
        tableauPoints[_index] = nil
    end
end)

RegisterNetEvent("core:lootSyncObj")
AddEventHandler("core:lootSyncObj", function(_type, index)
    if index then
        vangelico_config[_type][index].loot = true
    else
        vangelico_config[_type].loot = true
    end
end)

RegisterNetEvent("core:smashSyncObj")
AddEventHandler("core:smashSyncObj", function(sceneCfg)
    CreateModelSwap(sceneCfg.objPos, 0.3, GetHashKey(sceneCfg['oldModel']), GetHashKey('newModel'), 1)
end)

RegisterNetEvent("core:playerVangelico_removeBlips")
AddEventHandler("core:playerVangelico_removeBlips", function(blip)
    RemoveBlip(blip)
    blip = nil
end)

RegisterNetEvent("core:startAlarm", function(typee, bool, tablee)
    PrepareAlarm("JEWEL_STORE_HEIST_ALARMS")
    while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do
        Wait(1)
    end

    if bool then
        StartAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
    else
        StopAllAlarms(true)
        StopAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
    end
end)
