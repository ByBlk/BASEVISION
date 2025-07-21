local lastJob = nil
local lastPed = {}
local lastZone = {}
local lastBlip = {}
local sex = "male"

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
    local blips = AddBlipForCoord(coords)
    SetBlipSprite(blips, sprite)
    SetBlipScale(blips, scale)
    SetBlipColour(blips, color)
    SetBlipAsShortRange(blips, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blips)
    return blips
end

local function loadVestiaire()
    while not VFW.Jobs or not VFW.Jobs.Catalogue or not VFW.Jobs.Catalogue.Vestiaire do
        Wait(100)
    end

    while not next(VFW.Jobs.Catalogue.Vestiaire) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Catalogue.Vestiaire[lastJob] then return end

    local vestiaireData = {}
    local config = VFW.Jobs.Catalogue.Vestiaire[lastJob]

    local function getVestiaireCategory(category, category2)
        vestiaireData[category2] = {}
        local configOutfit = config.Outfit[VFW.PlayerData.skin.sex][category] or {}

        if configOutfit[category2] then
            local orderedKeys = {}

            for name, outfit in pairs(configOutfit[category2]) do
                table.insert(orderedKeys, { name = name, id = outfit.id })
            end

            table.sort(orderedKeys, function(a, b)
                return a.id < b.id
            end)

            for _, entry in ipairs(orderedKeys) do
                local name = entry.name
                local outfit = configOutfit[category2][name]

                local tempCatalogue = {
                    label = name,
                    model = name,
                    image = outfit.varHaut == 0 and "outfits_greenscreener/" .. sex .. "/clothing/torso2/" .. outfit.haut .. ".webp"
                            or "outfits_greenscreener/" .. sex .. "/clothing/torso2/" .. outfit.haut .. "_" .. outfit.varHaut .. ".webp",
                }

                table.insert(vestiaireData[category2], tempCatalogue)
            end
        end

        return vestiaireData[category2]
    end

    local function getVestiaireData(category, category2)
        local data = {
            style = {
                menuStyle = "custom",
                backgroundType = 1,
                bannerType = 2,
                gridType = 1,
                buyType = 2,
                bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(lastJob),
                buyTextType = false,
                buyText = "Récupérer",
            },
            eventName = ("vestiaire_%s"):format(lastJob),
            category = {
                show = config.Nui.category[category].show,
                defaultIndex = config.Nui.category[category].defaultIndex[category2],
                items = config.Nui.category[category].items
            },
            cameras = { show = false },
            nameContainer = { show = false },
            headCategory = config.Nui.headCategory,
            showStats = { show = false },
            mouseEvents = false,
            color = { show = false },
            items = getVestiaireCategory(category, category2)
        }

        return data
    end

    function VFW.Jobs.Catalogue.MenuVestiaire()
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 1 then
                sex = "female"
            end
        end)

        if type(config.Cam) == "table" then
            local closestDistance = 5.5

            for _, camConfig in ipairs(config.Cam) do
                local distance = #(GetEntityCoords(PlayerPedId()) - vector3(camConfig.CamCoords.x, camConfig.CamCoords.y, camConfig.CamCoords.z))

                if distance < closestDistance then
                    closestDistance = distance
                    SetEntityCoords(VFW.PlayerData.ped, camConfig.COH.x, camConfig.COH.y, camConfig.COH.z - 1)
                    SetEntityHeading(VFW.PlayerData.ped, camConfig.COH.w)
                    VFW.Cam:Create(("vestiaire_%s"):format(lastJob), camConfig)
                    break
                end
            end
        end

        VFW.Nui.NewGrandMenu(true, getVestiaireData(config.Nui.defaultHeadCategory, config.Nui.defaultCategory[config.Nui.defaultHeadCategory]))
        cEntity.Visual.HideAllEntities(true)
        cEntity.Visual.AddEntityToException(VFW.PlayerData.ped)
    end

    local function closeUI()
        config.Nui.lastHeadCategory = config.Nui.defaultHeadCategory
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.NewGrandMenu(false)
        cEntity.Visual.HideAllEntities(false)
        VFW.Cam:Destroy(("vestiaire_%s"):format(lastJob))
    end

    RegisterNuiCallback(("nui:newgrandcatalogue:vestiaire_%s:selectHeadCategory"):format(lastJob), function(data)
        if data == nil then return end
        config.Nui.lastHeadCategory = data
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(getVestiaireData(config.Nui.lastHeadCategory, config.Nui.lastCategory[config.Nui.lastHeadCategory]))
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:vestiaire_%s:selectCategory"):format(lastJob), function(data)
        if data == nil then return end
        config.Nui.lastCategory[config.Nui.lastHeadCategory] = data
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(getVestiaireData(config.Nui.lastHeadCategory, config.Nui.lastCategory[config.Nui.lastHeadCategory]))
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:vestiaire_%s:selectGridType"):format(lastJob), function(data)
        if data == nil then return end
        local outfitData = config.Outfit[VFW.PlayerData.skin.sex]
        if not outfitData then return end
        local gradeOutfit = outfitData[config.Nui.lastHeadCategory][config.Nui.lastCategory[config.Nui.lastHeadCategory]]
        if not gradeOutfit then return end
        local outfit = gradeOutfit[data]
        if not outfit then return end

        TriggerEvent('skinchanger:change', "shoes_1", outfit.chaussures)
        TriggerEvent('skinchanger:change', "shoes_2", outfit.varChaussures)
        TriggerEvent('skinchanger:change', "bags_1", outfit.sac)
        TriggerEvent('skinchanger:change', "bags_2", outfit.varSac)
        TriggerEvent('skinchanger:change', "decals_1", outfit.decals)
        TriggerEvent('skinchanger:change', "decals_2", outfit.varDecals)
        TriggerEvent('skinchanger:change', "pants_1", outfit.pantalon)
        TriggerEvent('skinchanger:change', "pants_2", outfit.varPantalon)
        TriggerEvent('skinchanger:change', "chain_1", outfit.chaine)
        TriggerEvent('skinchanger:change', "chain_2", outfit.varChaine)
        TriggerEvent('skinchanger:change', "torso_1", outfit.haut)
        TriggerEvent('skinchanger:change', "torso_2", outfit.varHaut)
        TriggerEvent('skinchanger:change', "tshirt_1", outfit.sousHaut)
        TriggerEvent('skinchanger:change', "tshirt_2", outfit.varSousHaut)
        TriggerEvent('skinchanger:change', "mask_1", outfit.mask)
        TriggerEvent('skinchanger:change', "mask_2", outfit.varMask)
        if outfit.gpb ~= 0 then
            TriggerEvent('skinchanger:change', "bproof_1", outfit.gpb)
            TriggerEvent('skinchanger:change', "bproof_2", outfit.varGpb)
        else
            TriggerEvent('skinchanger:change', "bproof_1", 0)
            TriggerEvent('skinchanger:change', "bproof_2", 0)
        end
        TriggerEvent('skinchanger:change', "arms", outfit.bras)
        TriggerEvent('skinchanger:change', "arms_2", outfit.varBras)
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:vestiaire_%s:selectBuy"):format(lastJob), function(data)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent("core:server:jobs:vestiaireOutfit", {
                renamed = data,
                sex = skin.sex == 1 and "w" or "m",
                image = "",
                skin = {
                    ['tshirt_1'] = skin["tshirt_1"],
                    ['tshirt_2'] = skin["tshirt_2"],
                    ['torso_1'] = skin["torso_1"],
                    ['torso_2'] = skin["torso_2"],
                    ['decals_1'] = skin["decals_1"],
                    ['decals_2'] = skin["decals_2"],
                    ['arms'] = skin["arms"],
                    ['arms_2'] = skin["arms_2"],
                    ['pants_1'] = skin["pants_1"],
                    ['pants_2'] = skin["pants_2"],
                    ['shoes_1'] = skin["shoes_1"],
                    ['shoes_2'] = skin["shoes_2"],
                    ['bags_1'] = skin['bags_1'],
                    ['bags_2'] = skin['bags_2'],
                    ['chain_1'] = skin['chain_1'],
                    ['chain_2'] = skin['chain_2'],
                    ['helmet_1'] = skin['helmet_1'],
                    ['helmet_2'] = skin['helmet_2'],
                    ['ears_1'] = skin['ears_1'],
                    ['ears_2'] = skin['ears_2'],
                    ['mask_1'] = skin['mask_1'],
                    ['mask_2'] = skin['mask_2'],
                    ['glasses_1'] = skin['glasses_1'],
                    ['glasses_2'] = skin['glasses_2'],
                    ['bproof_1'] = skin['bproof_1'],
                    ['bproof_2'] = skin['bproof_2'],
                }
            })
            closeUI()
        end)
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:vestiaire_%s:close"):format(lastJob), function()
        closeUI()
        local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', skin or {})
    end)

    lastPed = {}
    lastZone = {}
    lastBlip = {}

    for _, pedData in ipairs(config.Point.Ped) do
        for _, coord in ipairs(pedData.coords) do
            local coords = vector(coord.x, coord.y, coord.z + 1.25)
            lastBlip[#lastBlip + 1] = createBlip(coords, pedData.blip.sprite, pedData.blip.color, pedData.blip.scale, pedData.blip.label)
            lastPed[#lastPed + 1] = VFW.CreatePed(coord, pedData.pedModel)
            lastZone[#lastZone + 1] = createZone(
                    pedData.zone.name,
                    coords,
                    pedData.zone.interactLabel,
                    pedData.zone.interactKey,
                    pedData.zone.interactIcons,
                    { onPress = pedData.zone.onPress }
            )
            Wait(25)
        end
    end

    console.debug(("^3[%s]: ^7Vestiaires ^3loaded"):format(VFW.PlayerData.job.label))
end

local function deletingZone()
    for i, zone in ipairs(lastZone) do
        if zone then
            Worlds.Zone.Remove(zone)
            lastZone[i] = nil
        end
    end

    VFW.RemoveInteraction(("vestiaire_%s"):format(lastJob))

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
    loadVestiaire()
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
    loadVestiaire()
end)
