local lastJob = nil
local lastPed = {}
local lastZone = {}
local lastBlip = {}

local function createZone(name, positions, interactLabel, interactKey, interactIcons, action, colors)
    local zone = Worlds.Zone.Create(positions, 2, false, function()
        if action.onEnter then
            action.onEnter()
        end
        if action.onPress then
            VFW.RegisterInteraction(name, action.onPress)
        end
    end, function()
        VFW.RemoveInteraction(name)
        if action.onExit then
            action.onExit()
        end
    end, interactLabel, interactKey, interactIcons, colors)

    return zone
end

local function createBlip(coords, sprite, color, scale, name)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)

    return blip
end

local function loadGarage()
    while not VFW.Jobs or not VFW.Jobs.Catalogue or not VFW.Jobs.Catalogue.GarageHel do
        Wait(100)
    end

    while not next(VFW.Jobs.Catalogue.GarageHel) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Catalogue.GarageHel[lastJob] then return end
    console.debug("loaded garage")
    local garageData = {}
    local lastEntity = false
    local lastModel = false
    local config = VFW.Jobs.Catalogue.GarageHel[lastJob]

    local function getGarageCategory(category)
        garageData[category] = {}

        if config.Vehicle[category] then
            for i = 1, #config.Vehicle[category] do
                local vehicle = config.Vehicle[category][i]
                local tempCatalogue = {
                    label = vehicle.label or vehicle.name,
                    model = vehicle.name,
                    image = ("vehicules/%s.webp"):format(vehicle.name),
                }

                table.insert(garageData[category], tempCatalogue)
            end
        end

        return garageData[category]
    end

    local function getGarageData(category, firstLabel, secondLabel)
        local data = {
            style = {
                menuStyle = "custom",
                backgroundType = 1,
                bannerType = 2,
                gridType = 1,
                buyType = 2,
                bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(lastJob),
                buyTextType = false,
                buyText = "Selectionner",
            },
            eventName = ("garage_hel_%s"):format(lastJob),
            category = { show = false },
            cameras = { show = false },
            nameContainer = { show = false },
            headCategory = config.Nui.headCategory,
            showStats = { show = false },
            mouseEvents = false,
            color = { show = false },
            items = getGarageCategory(category)
        }

        if firstLabel and secondLabel then
            data.nameContainer = {
                show = true,
                top = false,
                firstLabel = firstLabel,
                secondLabel = secondLabel
            }
        end

        return data
    end

    local function deleteCar()
        if lastEntity and DoesEntityExist(lastEntity) then
            SetEntityAsMissionEntity(lastEntity, true, true)
            SetEntityAsNoLongerNeeded(lastEntity)
            DeleteEntity(lastEntity)
            lastEntity = false
            console.debug("Entity successfully deleted when closing.")
        else
            console.debug("No entity to delete or entity already deleted when closing.")
        end
    end

    local function applyVehicleConfig(vehs, data)
        local configVeh = config.VehConfigs[config.Nui.lastCategory] and config.VehConfigs[config.Nui.lastCategory][data] or false

        if configVeh then
            if configVeh.livery then
                SetVehicleLivery(vehs, configVeh.livery)
            end

            if configVeh.extras then
                for _, extra in ipairs(configVeh.extras) do
                    SetVehicleExtra(vehs, extra[1], extra[2])
                end
            end

            if configVeh.mods then
                for _, mod in ipairs(configVeh.mods) do
                    SetVehicleMod(vehs, mod[1], mod[2])
                end
            end

            if configVeh.colours then
                SetVehicleColours(vehs, configVeh.colours[1], configVeh.colours[2])
            end
        end
    end

    function VFW.Jobs.Catalogue.GarageHel.MenuGarage()

        if type(config.Cam) == "table" then
            local closestDistance = math.huge

            for _, camConfig in ipairs(config.Cam) do
                local distance = #(GetEntityCoords(PlayerPedId()) - vector3(camConfig.CamCoords.x, camConfig.CamCoords.y, camConfig.CamCoords.z))

                if distance < closestDistance then
                    closestDistance = distance
                    VFW.Cam:Create(("garage_%s"):format(lastJob), camConfig)
                end
            end
        end


        VFW.Nui.NewGrandMenu(true, getGarageData(config.Nui.lastCategory))
        cEntity.Visual.HideAllEntities(true)
    end

    RegisterNuiCallback(("nui:newgrandcatalogue:garage_hel_%s:selectHeadCategory"):format(lastJob), function(data)
        if data == nil then return end
        config.Nui.lastCategory = data
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(getGarageData(config.Nui.lastCategory))
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:garage_hel_%s:close"):format(lastJob), function()
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.NewGrandMenu(false)
        cEntity.Visual.HideAllEntities(false)
        deleteCar()
        VFW.Cam:Destroy(("garage_hel_%s"):format(lastJob))
        lastModel = nil
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:garage_hel_%s:selectGridType"):format(lastJob), function(data)
        local model = data
        console.debug("Model model model", model)

        if model then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            console.debug("Last model", lastModel)

            if lastModel ~= model then
                if lastEntity and DoesEntityExist(lastEntity) then
                    SetEntityAsMissionEntity(lastEntity, true, true)
                    SetEntityAsNoLongerNeeded(lastEntity)
                    DeleteEntity(lastEntity)
                    console.debug(lastEntity and "Failed to delete entity." or "Entity successfully deleted.")
                    lastEntity = nil
                    lastModel = nil
                end

                local playerCoords = GetEntityCoords(PlayerPedId())
                local closestSpawn = nil
                local closestDistance = math.huge

                for _, spawn in ipairs(config.Cam) do

                    local cam = spawn.COH

                    local distance = #(playerCoords - vector3(cam.x, cam.y, cam.z))
                    if distance < closestDistance then
                        closestDistance = distance
                        closestSpawn = cam
                    end
                end

                if closestSpawn then
                    lastEntity = CreateVehicle(model, closestSpawn.x, closestSpawn.y, closestSpawn.z, closestSpawn.w, false, false)

                    if lastEntity then
                        FreezeEntityPosition(lastEntity, true)
                        SetEntityAsMissionEntity(lastEntity, true, true)
                        SetVehicleOnGroundProperly(lastEntity)
                        SetVehicleDoorsLocked(lastEntity, 2)
                        SetVehicleEngineOn(lastEntity, true, true, true)
                        SetVehicleLights(lastEntity, 2)
                        cEntity.Visual.AddEntityToException(lastEntity)

                        for i = 1, #config.Vehicle[config.Nui.lastCategory] do
                            local vehicle = config.Vehicle[config.Nui.lastCategory][i]

                            if vehicle.name == model then
                                VFW.Nui.UpdateNewGrandMenu(getGarageData(config.Nui.lastCategory, vehicle.marque, vehicle.label))
                                applyVehicleConfig(lastEntity, vehicle.label)
                                break
                            end
                        end

                        if lastModel then
                            SetModelAsNoLongerNeeded(lastModel)
                        end

                        lastModel = model
                    else
                        console.debug("Erreur : Impossible de créer le véhicule.")
                    end
                else
                    console.debug("Erreur : Aucun point de spawn trouvé.")
                end
            end
        end

    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:garage_hel_%s:selectBuy"):format(lastJob), function(data)
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.NewGrandMenu(false)
        cEntity.Visual.HideAllEntities(false)

        local vehicleModel = data

        deleteCar()

        VFW.Cam:Destroy(("garage_hel_%s"):format(lastJob))

        Wait(150)

        local vehicleSpawned = false
        local closestSpawn = nil
        local closestDistance = math.huge

        for _, spawn in ipairs(config.Vehicle.Spawn) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - vector3(spawn.x, spawn.y, spawn.z))

            if distance < closestDistance then
                closestDistance = distance
                closestSpawn = spawn
            end
        end

        if closestSpawn then
            if VFW.Game.IsSpawnPointClear(vector3(closestSpawn.x, closestSpawn.y, closestSpawn.z), 2.5) then
                for _, veh in pairs(config.Vehicle[config.Nui.lastCategory]) do
                    if veh.name == vehicleModel then
                        local vehicle = CreateVehicle(vehicleModel, closestSpawn.x, closestSpawn.y, closestSpawn.z, closestSpawn.w, true, false)

                        TriggerServerEvent("vfw:vehicle:keyTemporarly:add", "job", VFW.Math.Trim(GetVehicleNumberPlateText(vehicle)))
                        SetVehicleOnGroundProperly(vehicle)
                        SetVehicleMod(vehicle, 11, 2, false)
                        SetVehicleMod(vehicle, 12, 2, false)
                        SetVehicleMod(vehicle, 13, 2, false)
                        applyVehicleConfig(vehicle, veh.label)
                        SetModelAsNoLongerNeeded(vehicle)
                        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, vehicle, -1)
                        vehicleSpawned = true
                        lastModel = nil
                        break
                    end
                end
            else
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "L'emplacement est occupé, veuillez réessayer plus tard."
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Aucun point de spawn disponible."
            })
        end

        VFW.Nui.HudVisible(true)
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:garage_hel_%s:close"):format(lastJob), function()
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.NewGrandMenu(false)
        cEntity.Visual.HideAllEntities(false)
        deleteCar()
        VFW.Cam:Destroy(("garage_hel_%s"):format(lastJob))
        VFW.Nui.HudVisible(true)
    end)

    lastPed = {}
    lastZone = {}
    lastBlip = {}

    for i, pedData in ipairs(config.Point.Ped) do
        lastPed[i] = VFW.CreatePed(pedData.coords, pedData.pedModel)

        local zones = {
            {
                name = pedData.zone.name,
                coords = vector3(pedData.coords.x, pedData.coords.y, pedData.coords.z + 1.25),
                label = pedData.zone.interactLabel,
                key = pedData.zone.interactKey,
                icons = pedData.zone.interactIcons,
                onPress = pedData.zone.onPress
            }
        }

        for _, despawnZone in ipairs(config.Point.Despawn) do
            table.insert(zones, {
                name = despawnZone.zone.name,
                coords = vector3(despawnZone.coords.x, despawnZone.coords.y, despawnZone.coords.z - 0.5),
                label = despawnZone.zone.interactLabel,
                key = despawnZone.zone.interactKey,
                icons = despawnZone.zone.interactIcons,
                onPress = despawnZone.zone.onPress
            })
        end

        local blips = {
            {
                coords = vector3(pedData.coords.x, pedData.coords.y, pedData.coords.z + 1.25),
                sprite = pedData.blip.sprite,
                color = pedData.blip.color,
                scale = pedData.blip.scale,
                label = pedData.blip.label
            }
        }

        for _, despawnBlip in ipairs(config.Point.Despawn) do
            table.insert(blips, {
                coords = vector3(despawnBlip.coords.x, despawnBlip.coords.y, despawnBlip.coords.z + 1.25),
                sprite = despawnBlip.blip.sprite,
                color = despawnBlip.blip.color,
                scale = despawnBlip.blip.scale,
                label = despawnBlip.blip.label
            })
        end

        for _, zoneData in ipairs(zones) do
            lastZone[#lastZone + 1] = createZone(zoneData.name, zoneData.coords, zoneData.label, zoneData.key, zoneData.icons, { onPress = zoneData.onPress })
            Wait(25)
        end

        for _, blipData in ipairs(blips) do
            lastBlip[#lastBlip + 1] = createBlip(blipData.coords, blipData.sprite, blipData.color, blipData.scale, blipData.label)
            Wait(25)
        end
    end

    console.debug(("^3[%s]: ^7Garages Hélicoptère ^3loaded"):format(VFW.PlayerData.job.label))
end

local function deletingZone()
    for i, zone in ipairs(lastZone) do
        if zone then
            Worlds.Zone.Remove(zone)
            lastZone[i] = nil
        end
    end

    VFW.RemoveInteraction(("garage_hel_%s"):format(lastJob))
    VFW.RemoveInteraction(("garageDespawn_hel_%s"):format(lastJob))

    lastZone = {}
end

local function deletingPeds()
    for i, ped in ipairs(lastPed) do
        if ped and DoesEntityExist(ped) then
            DeleteEntity(ped)
            lastPed[i] = nil
        end
    end

    lastPed = {}
end

local function deletingBlip()
    for i, blip in ipairs(lastBlip) do
        if blip then
            RemoveBlip(blip)
            lastBlip[i] = nil
        end
    end

    lastBlip = {}
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    deletingZone()
    deletingPeds()
    deletingBlip()
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(1000)
    loadGarage()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        deletingZone()
        deletingPeds()
        deletingBlip()
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadGarage()
end)
