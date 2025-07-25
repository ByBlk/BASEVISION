local PlayersId, PlayersInJob = {}, {}
local veh, finished, blippos, advance, HoldingBox, addpos, blipBoites, delivered, FriendHasTakenColis, playerpos, near, stoped, maxBoites, recupedBoites, ColisObj = nil, true, nil, 0, false, vector3(0.0, 0.0, 0.0), nil, 0, nil, nil, false, false, 0, 0, {}
local goPostal = {
    [1] = {
        vector3(-718.45, -155.8, 36.984375),
        vector3(-154.95, -308.45, 38.46583),
        vector3(-351.74, -45.38, 49.0462207),
        vector3(-767.26, -154.66, 37.58),
        vector3(-1024.26, -255.76, 37.72),
        vector3(-1083.17, -262.22, 37.79),
        vector3(-697.84, 271.67, 83.11),
        vector3(-291.93, -101.4, 46.77),
        vector3(-418.52795410156, 1173.7421875, 324.82205200195),
        vector3(-634.09, -236.43, 38.01),
        vector3(-699.06, -187.26, 36.87),
    },
    [2] = {
        vector3(130.14, -208.67, 54.55),
        vector3(417.25, -809.41, 29.36),
        vector3(228.67, 217.58, 105.55),
        vector3(313.74, -274.59, 53.93),
        vector3(149.19, -1035.8, 29.34),
        vector3(378.12, 322.1, 103.4),
        vector3(322.51, 176.78, 103.54),
        vector3(160.39, -1119.78, 29.32),
        vector3(19.02, -1116.93, 29.79),
        vector3(433.49, -979.54, 30.71),
    },
    [3] = {
        vector3(-1455.75, -229.93, 49.28),
        vector3(-1492.5, -382.81, 40.13),
        vector3(-1857.3682861328, -348.5153503418, 50.618885040283),
        vector3(-1387.24, -584.52, 30.21),
        vector3(-1217.63, -326.54, 37.64),
        vector3(-2030.9714355469, -466.19049072266, 11.884587287903),
        vector3(-1608.36, -998.59, 13.02),
        vector3(-1817.05, -1192.26, 14.31),
    },
    [4] = {
        vector3(-1455.9, -230.03, 49.28),
        vector3(-1493.11, -383.32, 40.04),
        vector3(-1857.3682861328, -348.5153503418, 50.618885040283),
        vector3(-1387.24, -584.52, 30.21),
        vector3(-1217.63, -326.54, 37.64),
        vector3(-2030.9714355469, -466.19049072266, 11.884587287903),
        vector3(-1608.36, -998.59, 13.02),
        vector3(-1817.05, -1192.26, 14.31),
    },
    [5] = {
        vector3(-1204.21, -778.42, 16.33),
        vector3(-1225.79, -900.32, 12.339),
        vector3(-1089.74, -806.57, 19.26),
        vector3(-1291.19, -1115.54, 6.67),
        vector3(-1214.77, -1436.97, 4.38),
        vector3(-818.83, -1080.84, 10.13),
        vector3(-1253.9932861328, -1443.5252685547, 3.3738851547241),
        vector3(-1214.64, -1505.44, 4.34),
        vector3(-714.42, -917.82, 19.21646),
        vector3(-599.33, -926.95, 23.86),
        vector3(-202.76, -1308.55, 31.29),
        vector3(-56.5, -1755.41, 29.437750854),
        vector3(22.97, -1350.62, 29.33),
        vector3(84.87, -1396.62, 29.29),
        vector3(127.95, -1300.03, 29.23),
        vector3(130.12, -1712.13, 29.27),
    }
}

local spawnPlaces = {
    vector4(71.280143737793, 120.3359375, 78.070098876953, 157.0),
    vector4(66.152099609375, 120.35468292236, 78.034202575684, 157.0),
    vector4(61.115509033203, 121.84418487549, 78.066772460938, 157.0),
}

local activeInteractionPickup = false
local activeInteractionChest = false
local activeInteractionDelivery = false
local activeinteractionChestPickup = false

local interactionChest = nil
local interactionPickup = nil
local interactionDelivery = nil
local interactionChestPickup = nil
local currentDeliveryPos = nil

local finishPoint = nil

local function PlayAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(100) end
    TaskPlayAnim(VFW.PlayerData.ped, animDict, animName, 8.0, -8.0, duration, 0, 0, false, false, false)
    RemoveAnimDict(animDict)
    Wait(duration)
end

local function spawnVeh()
    for k,v in pairs(spawnPlaces) do 
        if VFW.Game.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then 
            if DoesEntityExist(vehs) then 
                DeleteEntity(vehs)
            end

            vehs = VFW.Game.SpawnVehicle(GetHashKey("boxville2"), vector3(70.59, 118.41, 78.05), 160.36, nil, true)

            return vehs 
        else
            VFW.ShowNotification({type = 'ROUGE', content = "Il n'y a pas de place pour le véhicule"})
        end
    end

    return nil
end

function endGoPostal()
    if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
        local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
        if veh then
            DeleteEntity(veh)
        end
    end

    price = 100 * recupedBoites
    

    console.debug("price", price)
    
    -- TODO : ADD MONEY TO PLAYER
    --TriggerServerEvent("core:addItemToInventory", token, "money", price, {})

    local nprice = price or 0 

    VFW.ShowNotification({type = 'VERT', content = "Vous avez gagné "..nprice..'$'})

    -- for k,v in pairs(ColisObj) do 
    --     if DoesEntityExist(k) then 
    --         DeleteEntity(k)
    --     end
    -- end

    for k,v in pairs(ColisObj) do
        if DoesEntityExist(v) then 
            DeleteEntity(v)
        end
    end


    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})

    if blippos then 
        RemoveBlip(blippos) 
    end

    blippos = nil
    maxBoites = 0
    recupedBoites = 0

    if finishblip then 
        RemoveBlip(finishblip) 
    end
    
    pos = {}
    advance = 0
    price = 0
    finished = true

    Worlds.Zone.Remove(finishPoint)
end

local function StartMission(isFriend)
    delivered = 0
    math.randomseed(GetGameTimer())
    local idToGo = math.random(1, #goPostal)
    maxBoites = isFriend and isFriend.maxBoites or #goPostal[idToGo]

    veh = isFriend and NetToVeh(isFriend.veh) or spawnVeh()


    
    advance = 0

    console.debug("veh", veh)


    if not isFriend then
        SetVehicleDoorOpen(veh, 3, false, false)
        SetVehicleDoorOpen(veh, 2, false, false)
    end


    if blipBoites then RemoveBlip(blipBoites) Wait(260) end
    blipBoites = AddBlipForCoord(vector3(75.878784179688, 123.76702880859, 79.211387634277))
    near = false
    local shown = false
    finished = false

    if not isFriend then
        TriggerServerEvent("core:activities:update", PlayersId, "gopostal", {maxBoites = maxBoites, veh = VehToNet(veh)})
    end

    while not finished do
        Wait(1)
        playerpos = GetEntityCoords(VFW.PlayerData.ped)

        if GetDistanceBetweenCoords(playerpos, addpos) < 50.0 then
            if not IsPedInAnyVehicle(VFW.PlayerData.ped) then
                if not HoldingBox or not IsEntityPlayingAnim(VFW.PlayerData.ped, "anim@heists@box_carry@", "idle", 3) or not IsEntityPlayingAnim(VFW.PlayerData.ped, "anim@mp_ferris_wheel", "idle_a_player_one", 3) then
                    if not FriendHasTakenColis and not shown then
                        shown = true
                    end
        
                    if not activeinteractionChestPickup and (currentDeliveryPos == nil or currentDeliveryPos ~= addpos) then
                        if activeinteractionChestPickup then 
                            VFW.RemoveInteraction("gopostal_chestpickup")
                        end

                        local vehBackPos = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 0.0) 
        
                        interactionChestPickup = Worlds.Zone.Create(vehBackPos, 1.75, false, function()
                            VFW.RegisterInteraction("gopostal_chestpickup", function()
                                TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {takencolis = true})
                                SetVehicleDoorOpen(veh, 3, false, false)
                                SetVehicleDoorOpen(veh, 2, false, false)
                                ExecuteCommand(math.random(1,3) ~= 3 and "e box" or "e pallet3")
                                HoldingBox = true
                                Wait(1000)
                                DeleteEntity(ColisObj[delivered+1])
                                SetVehicleDoorShut(veh, 3, false, false)
                                SetVehicleDoorShut(veh, 2, false, false)
        
                                currentDeliveryPos = addpos  
        
                                if interactionChestPickup then 
                                    Worlds.Zone.Remove(interactionChestPickup)
                                    interactionChestPickup = nil
                                end
        
                                if activeinteractionChestPickup then 
                                    VFW.RemoveInteraction("gopostal_chestpickup")
                                    activeinteractionChestPickup = false
                                end
                            end)
                        end, function()
                            VFW.RemoveInteraction("gopostal_chestpickup")
                        end, "Prendre", "E", "Stockage")
        
                        activeinteractionChestPickup = true
                    end
                end
            else
                shown = false
            end
        else
            shown = false
        end

        if GetDistanceBetweenCoords(playerpos, addpos) < 2 and (HoldingBox or IsEntityPlayingAnim(VFW.PlayerData.ped, "anim@heists@box_carry@", "idle", 3)) then
            near = true

            if not activeInteractionDelivery then 
                if activeInteractionDelivery then 
                    VFW.RemoveInteraction("gopostal_delivery")
                end

                interactionDelivery = Worlds.Zone.Create(addpos, 1.75, false, function()
                    VFW.RegisterInteraction("gopostal_delivery", function()
                        RemoveBlip(blippos)
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {finishcolis = true})
                        ExecuteCommand("e jpbox")
                        Wait(2500)
                        ExecuteCommand("e c")
                        HoldingBox = false
                        delivered += 1
        
                        if delivered == maxBoites then
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {finished = true})
                            finished = true
                        end
        
                        if goPostal[idToGo][delivered+1] then
                            if blippos then RemoveBlip(blippos) Wait(260) end
                            addpos = goPostal[idToGo][delivered+1]
                            blippos = AddBlipForCoord(addpos)
                            SetNewWaypoint(addpos.x, addpos.y)
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {addpos = addpos, delivered = delivered})
                        end
                    end)
                end, function()
                    VFW.RemoveInteraction("gopostal_delivery")
                end, "Livrer", "E", "Stockage")

                activeInteractionDelivery = true
            end
        else
            near = false

            if activeInteractionDelivery then 
                VFW.RemoveInteraction("gopostal_delivery")
                activeInteractionDelivery = false
            end
            
            if interactionDelivery then 
                Worlds.Zone.Remove(interactionDelivery)
                interactionDelivery = nil
            end
        end

        if GetDistanceBetweenCoords(playerpos, vector3(75.878784179688, 123.76702880859, 79.211387634277)) < 5.0 then
            if not activeInteractionPickup then 
                if activeInteractionPickup then 
                    VFW.RemoveInteraction("gopostal_pickup")
                end

                interactionPickup = Worlds.Zone.Create(vector3(76.89, 123.95, 78.22 + 0.60), 1.75, false, function()
                    VFW.RegisterInteraction("gopostal_pickup", function()
                        if recupedBoites < maxBoites then
                            if not IsEntityPlayingAnim(VFW.PlayerData.ped, "anim@heists@box_carry@", "idle", 3) then
                                recupedBoites += 1
                                ExecuteCommand("e box")
                            else
                                VFW.ShowNotification({type = 'ROUGE', content = "Allez d'abord déposer dans le coffre votre colis !"})
                            end
                        else
                            VFW.ShowNotification({type = 'ROUGE', content = "Vous avez déjà pris tous vos colis, vous pouvez commencer votre service !"})
                        end
                    end)
                end, function()
                    VFW.RemoveInteraction("gopostal_pickup")
                end, "Ramasser", "E", "Stockage")

                activeInteractionPickup = true
            end
        end

        if GetDistanceBetweenCoords(playerpos, vector3(67.031044006348, 124.18302154541, 78.166702270508)) < 50.0 and IsEntityPlayingAnim(VFW.PlayerData.ped, "anim@heists@box_carry@", "idle", 3) then
            if not activeInteractionChest then 
                if activeInteractionChest then 
                    VFW.RemoveInteraction("gopostal_chest")
                end

                console.debug("create interaction chest")

                interactionChest = Worlds.Zone.Create(GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")), 1.75, false, function()
                    VFW.RegisterInteraction("gopostal_chest", function()
                        if recupedBoites ~= maxBoites then
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {recupedBoites = recupedBoites})
                        end
                        PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(500)
                        ExecuteCommand("e c")
                        Wait(500)
                        ClearPedTasks(VFW.PlayerData.ped)
        
                        if recupedBoites == maxBoites then
                            if blippos then RemoveBlip(blippos) Wait(260) end
                            addpos = goPostal[idToGo][delivered+1]
                            blippos = AddBlipForCoord(addpos)
                            RemoveBlip(blipBoites)
                            SetNewWaypoint(addpos.x, addpos.y)

                            Worlds.Zone.Remove(interactionPickup)
                            Worlds.Zone.Remove(interactionChest)
                            interactionPickup = nil
                            interactionChest = nil

                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {recupedBoites = recupedBoites, addpos = addpos})
                            SetVehicleDoorShut(veh, 3, false, false)
                            SetVehicleDoorShut(veh, 2, false, false)
                        end
        
                        local PossiblePos = {
                            vector3(-0.2, 3.1, 0.2), vector3(0.2, 3.1, 0.2), vector3(-0.2, 2.6, 0.2),
                            vector3(0.2, 2.6, 0.2), vector3(-0.2, 2.1, 0.2), vector3(0.2, 2.1, 0.2),
                            vector3(-0.2, 1.5, 0.2), vector3(0.2, 1.5, 0.2), vector3(-0.2, 1.0, 0.2),
                            vector3(0.2, 1.0, 0.2), vector3(-0.2, 0.5, 0.2), vector3(0.2, 0.5, 0.2)
                        }
        
                        if PossiblePos[recupedBoites] then
                            ColisObj[recupedBoites] = CreateObject(GetHashKey("hei_prop_heist_box"), playerpos, true, false, true)
                            SetEntityAsMissionEntity(ColisObj[recupedBoites], true, true)
                            SetEntityCollision(ColisObj[recupedBoites], false, false)
                            AttachEntityToEntity(ColisObj[recupedBoites], veh, GetEntityBoneIndexByName(veh, "platelight"), PossiblePos[recupedBoites], 0.0, 0.0, 0.0, false, true, false, false, 1, true)
                        end
                    end)
                end, function()
                    VFW.RemoveInteraction("gopostal_chest")
                end, "Déposer", "E", "Stockage")


                console.debug("interactionChest", interactionChest)

                activeInteractionChest = true
            end
        end
    end

    RemoveBlip(blippos)
    advance = advance + 1
    if stoped then return end

    local finishblip = AddBlipForCoord(73.735473632813, 121.23113250732, 10.0)
    SetNewWaypoint(73.735473632813, 121.23113250732)

    if IsPedInAnyVehicle(VFW.PlayerData.ped) then
        VFW.ShowNotification({type = 'JAUNE', content = "Allez rendre le camion pour être payé"})
    end


    finishPoint = Worlds.Zone.Create(vector3(66.575218200684, 122.3657989502, 79.134414672852), 1.75, false, function()
        VFW.RegisterInteraction("gopostal_finish", function()
            RemoveBlip(finishblip)
            endGoPostal()
            TriggerServerEvent("core:activities:kickPlayers", PlayersInJob)
        end)
    end, function()
        VFW.RemoveInteraction("gopostal_finish")
    end, "Finir", "E", "Stockage")
end

local insert = false

function OpenMenuGoPostal()
    if not insert then 
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
        insert = true
    end
    Wait(50)

    VFW.Nui.JobMenu(true, {
        headerBanner = "https://cdn.eltrane.cloud/3838384859/old_a_trier/Discord/10493763812109926601206612952321495100bannieregopostal1.webp",
        choice = {
            label = "Camions",
            isOptional = false,
            choices = {{id = 1, label = 'Boxville', name = 'boxville2', img= "https://cdn.eltrane.cloud/3838384859/old_a_trier/Discord/12015580604732580841202581456879230976image2removebgpreview.webp"}},
        },
        participants = PlayersInJob,
        participantsNumber = 2,
        callbackName = "MetierGoPostal",
    })
end

RegisterNUICallback("MetierGoPostal", function(data)
    if not data then return end

    if data.button == "start" then
        PlayersId = {}
        for _, v in pairs(PlayersInJob) do
            table.insert(PlayersId, v.id)
        end
        TriggerServerEvent("core:activities:create", PlayersId, "gopostal")
        VFW.Nui.JobMenu(false)
        Wait(50)
        StartMission()
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "gopostal")
        for k,v in pairs(PlayersInJob) do
            if v.id == playerSe then table.remove(PlayersInJob, k) end
        end
        if PlayersId then
            for k,v in pairs(PlayersId) do
                if v == playerSe then table.remove(PlayersId, k) end
            end
        end
        Wait(50)
        OpenMenuGoPostal()
    elseif data.button == "addPlayer" and data.selected ~= 0 then
        VFW.Nui.JobMenu(false)
        local closestPlayer = VFW.StartSelect(5.0, true)
        if closestPlayer then
            TriggerServerEvent("core:activities:askJob", GetPlayerServerId(closestPlayer), "gopostal")
        end
        Wait(50)
        OpenMenuGoPostal()
    elseif data.button == "stop" then
        stoped = true
        advance = 5
        maxBoites = 0
        local playerSkin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', playerSkin or {})
        recupedBoites = 0

        if blipBoites then 
            RemoveBlip(blipBoites) 
            blipBoites = nil
        end

        if veh then 
            DeleteEntity(veh) 
            veh = nil
        end

        for k,v in pairs(ColisObj) do
            if DoesEntityExist(v) then 
                DeleteEntity(v)
            end
        end
    end
end)

RegisterNuiCallback("nui:job-menu:close", function() VFW.Nui.JobMenu(false) end)

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "gopostal" then
        PlayersId = players
    end
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) and typejob == "gopostal" then
        StartMission(data)
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "gopostal" then
        PlayersInJob = {{name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId())}}
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
    Wait(50)
end)

RegisterNetEvent("core:activities:liveupdate", function(typejob, data, src)
    if typejob == "gopostal" then
        if data.addpos then
            if blippos then RemoveBlip(blippos) end
            addpos = data.addpos
            blippos = AddBlipForCoord(addpos)
            SetNewWaypoint(addpos.x, addpos.y)
        end
        if data.recupedBoites then
            if tonumber(src) ~= tonumber(GetPlayerServerId(PlayerId())) then
                recupedBoites = data.recupedBoites
                if recupedBoites == maxBoites then
                    Worlds.Zone.Remove(interactionPickup)
                    Worlds.Zone.Remove(interactionChest)
                    interactionPickup = nil
                    interactionChest = nil

                    math.randomseed(GetGameTimer())
                    addpos = data.addpos
                    blippos = AddBlipForCoord(addpos)
                    RemoveBlip(blipBoites)
                    SetNewWaypoint(addpos.x, addpos.y)
                    SetVehicleDoorShut(veh, 3, false, false)
                    SetVehicleDoorShut(veh, 2, false, false)
                end
            end
        end
        if data.finished then
            finished = data.finished
        end
        if data.delivered then
            delivered = data.delivered
        end
        if data.takencolis then
            FriendHasTakenColis = true
        end
        if data.finishcolis then
            FriendHasTakenColis = false
        end
    end
end)
