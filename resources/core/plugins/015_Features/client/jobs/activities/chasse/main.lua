local lockedAnimalList = {}
local isSkinning = false
local hunterservice = false
local missionStart = false
local sold = false
local isHunting = false
local blips = nil
local interactedAnimals = {}
local animalPoints = {}
local animalBlips = {}
vehicle = nil
local huntingAnimals = {
    { ped = "a_c_boar", meat = "viandesanglier", label = "Viande de sanglier" },
    { ped = "a_c_deer", meat = "viandebiche", label = "Viande de biche" },
    { ped = "a_c_rabbit_01", meat = "viandelapin", label = "Viande de lapin" },
    { ped = "a_c_mtlion", meat = "viandepuma", label = "Viande de puma" },
    { ped = "a_c_pigeon", meat = "viandeoiseau", label = "Viande de pigeon" },
    { ped = "a_c_seagull", meat = "viandeoiseau", label = "Viande d'oiseau" },
    { ped = "a_c_chickenhawk", meat = "viandeoiseau", label = "Viande d'aigle" },
}
local PlayersInJob = {}

CreateThread(function()
    local model = GetHashKey("s_m_m_linecook")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
    local ped = CreatePed(4, model, -1492.1900634766, 4977.7446289062, 62.553359985352, 35.446025848389, false, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

CreateThread(function()
    -- TODO: Change icon
    Worlds.Zone.Create(vector3(-1492.1900634766, 4977.7446289062, 62.553359985352 + 0.60), 1.75, false, function()
        console.debug("Entering hunting interaction zone ")

        VFW.RegisterInteraction("startHunting", function()
            TriggerServerEvent("core:activities:create", PlayersId, "chasse")
            startHunting(GetHashKey("komoda"))
        end)
    end, function()
        console.debug("Exiting hunting interaction zone ")

        VFW.RemoveInteraction("startHunting")
    end, "Chasser", "E", "Chasse")
end)

function changeSkin()
    -- TODO: Implement this function
end

RegisterCommand("startChasse", function()
    PlayersId = {}
    for k, v in pairs(PlayersInJob) do
        table.insert(PlayersId, v.id)
    end
    TriggerServerEvent("core:activities:create", PlayersId, "chasse")
    startHunting()
end)

local function SpawnChasseAnimals()
    CreateThread(function()
        for i = 1, 45, 1 do
            if not missionStart or not isHunting then
                break
            end
            math.randomseed(GetGameTimer())
            local animal = huntingAnimals[math.random(1, #huntingAnimals)]
            math.randomseed(GetGameTimer())
            local random = math.random(1, #Chasseur)
            RequestModel(animal.ped)
            while not HasModelLoaded(animal.ped) do
                Wait(500)
            end
            local animalPed = CreatePed(4, animal.ped, Chasseur[random], 0, true, true)
            SetModelAsNoLongerNeeded(animal.ped)
            SetEntityAsMissionEntity(animalPed, 0, 0)
            TaskWanderStandard(animalPed, 10.0, 10)

            local animalBlip = AddBlipForEntity(animalPed)
            SetBlipSprite(animalBlip, 898)
            SetBlipColour(animalBlip, 2)
            SetBlipAsShortRange(animalBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Animal Sauvage")
            EndTextCommandSetBlipName(animalBlip)

            table.insert(animalBlips, animalBlip)
            console.debug(json.encode(animalBlips))
            CreateThread(function()
                while true do
                    Wait(1000)
                    if IsEntityDead(animalPed) then
                        SetBlipSprite(animalBlip, 310)
                        SetBlipColour(animalBlip, 1)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Animal Mort")
                        EndTextCommandSetBlipName(animalBlip)
                        break
                    end
                end
            end)

            Wait(1500)
        end
    end)
end

function startHunting()
    if not isHunting then
        isHunting = true
        missionStart = true
        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous avez pris votre service."
        })

        CreateThread(function() -- Hunting area
            while missionStart do
                if blips ~= nil then
                    RemoveBlip(blips)
                end
                blips = AddBlipForRadius(-1073.3568, 4376.8896, 12.357, 600.0)
                SetBlipSprite(blips, 9)
                SetBlipColour(blips, 1)
                SetBlipAlpha(blips, 100)
                Wait(15 * 60000)
            end
        end)

        Wait(1000)
        vehicle = VFW.Game.SpawnVehicle(GetHashKey("sultan"), vector3(-1498.249, 4969.101, 63.471), 177.432, nil, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        SetCanAttackFriendly(PlayerPedId(), false, true);
        SpawnChasseAnimals();
        CreateThread(function()
            while missionStart do
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                random, animal = FindFirstPed()
                if GetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), true) then
                    console.debug("Has weapon")
                    SetPedAmmo(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), 999);
                end
                repeat
                    if not IsPedAPlayer(animal) and IsPedDeadOrDying(animal) then
                        local animalVelocity = GetEntityVelocity(animal)
                        if animalVelocity.x == 0.0 and animalVelocity.y == 0.0 and animalVelocity.z == 0.0 then
                            for k, v in pairs(huntingAnimals) do
                                if GetEntityModel(animal) == GetHashKey(v.ped) then
                                    local _animal = animal
                                    local animalId = NetworkGetNetworkIdFromEntity(animal)
                                    if not interactedAnimals[animalId] then
                                        interactedAnimals[animalId] = true
                                        local animalCoords = GetEntityCoords(animal)
                                        local interactionId = "depecage_" .. animalId
                                        animalPoints[animalId] = Worlds.Zone.Create(vector3(animalCoords.x, animalCoords.y, animalCoords.z), 1.75, false, function()
                                            VFW.RegisterInteraction(interactionId, function()
                                                if HasPedGotWeapon(playerPed, GetHashKey("WEAPON_KNIFE"), false) then
                                                    -- check if the player is not already skinning an animal
                                                    if not isSkinning then
                                                        isSkinning = true
                                                        Worlds.Zone.HideInteract(false)
                                                        -- load the skinning animation
                                                        RequestAnimDict("amb@world_human_gardener_plant@male@base")
                                                        while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do Wait(0) end
                                                        -- play the animation
                                                        TaskPlayAnim(playerPed, "amb@world_human_gardener_plant@male@base", "base", 1.0, 1.0, 0.7, 120, 0.2, 1, 1, 1)
                                                        Wait(5000)
                                                        StopAnimTask(pid, "amb@world_human_gardener_plant@male@base", "base", 1.0)
                                                        RemoveAnimDict("amb@world_human_gardener_plant@male@base")
                                                        -- give item depending on the animal
                                                        for _, animals in pairs(huntingAnimals) do
                                                            if GetEntityModel(_animal) == GetHashKey(animals.ped) then
                                                                console.debug("Animal: " .. animalId)
                                                                TriggerServerEvent("core:Hunting:depece", animalId, animals.meat)
                                                                VFW.ShowNotification({
                                                                    type = 'VERT',
                                                                    content = "Tu as récupéré " .. animals.label
                                                                })
                                                            end
                                                        end
                                                        -- can't skin the animal again
                                                        TriggerServerEvent("hunt:animalLock", NetworkGetNetworkIdFromEntity(animal))
                                                        SetEntityAsNoLongerNeeded(animal)
                                                        ClearPedTasksImmediately(playerPed)
                                                        isSkinning = false
                                                        Worlds.Zone.HideInteract(true)
                                                        Worlds.Zone.Remove(animalPoints[animalId])
                                                        VFW.RemoveInteraction(interactionId)
                                                        animalPoints[animalId] = nil
                                                    end
                                                else
                                                    VFW.ShowNotification({
                                                        type = 'ROUGE',
                                                        content = "Vous n'avez pas de couteau en main"
                                                    })
                                                end
                                            end)
                                        end, function()
                                            --Worlds.Zone.Remove(animalPoints[animalId])
                                            --VFW.RemoveInteraction(interactionId)
                                            --animalPoints[animalId] = nil
                                        end, "Dépecer", "E", "Depecer")
                                    end
                                end
                            end
                        end
                    end
                    success, animal = FindNextPed(random)
                until not success
                EndFindPed(random)
                Wait(500)
                if #(GetEntityCoords(PlayerPedId()) - vector3(-1073.3568, 4376.8896, 12.357)) > 1500.0 then
                    missionStart = false
                    RemoveBlip(blips)
                    stopHunting();
                    blips = nil
                    service = false
                    TriggerServerEvent("core:Hunting:removeWeapons");
                end
            end
        end)
    else
        SetCanAttackFriendly(PlayerPedId(), true, true);
        DeleteVehicle(vehicle);
        TriggerServerEvent("core:Hunting:removeWeapons");
        stopHunting();
    end
end

function stopHunting()
    if isHunting then
        isHunting = false
        missionStart = false
        RemoveBlip(blips)
        blips = nil
        service = false
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous avez quitté votre service."
        })

        for _, blip in ipairs(animalBlips) do
            RemoveBlip(blip)
        end
        animalBlips = {}
    end
end

RegisterNUICallback("MetierChasse", function(data)
    if data and data.button == "start" then
        local car = data.selected.name
        AddTenueChasse()
        PlayersId = {}
        for k, v in pairs(PlayersInJob) do
            table.insert(PlayersId, v.id)
        end
        TriggerServerEvent("core:activities:create", token, PlayersId, "chasse")
        closeUI() -- @TODO: Adapt with current NUI system
        StartHunting(car)
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "chasse", true)
        end
    elseif data.button == "stop" then
        hunterservice = false
        RemoveBlip(blips)
        missionStart = false
        blips = nil
        service = false

        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous avez ~s quitté votre service ~c de chasse"
        })
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
    end
end)

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "chasse" then
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "chasse" then
            AddTenueChasse()
            StartHunting(nil, true)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "chasse" then
        hunterservice = false
        RemoveBlip(blips)
        missionStart = false
        blips = nil
        service = false
        VFW.ShowNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté votre service ~c de chasse"
        })
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)