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

local function loadItems()
    while not VFW.Jobs or not VFW.Jobs.Catalogue or not VFW.Jobs.Catalogue.Items do
        Wait(100)
    end

    while not next(VFW.Jobs.Catalogue.Items) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Catalogue.Items[lastJob] then return end

    local itemsData = {}
    local config = VFW.Jobs.Catalogue.Items[lastJob]

    local function getItemsCategory(category)
        itemsData[category] = {}

        if config.Items[category] then
            for i = 1, #config.Items[category] do
                local item = config.Items[category][i]
                
                local canAccess = true
                if item.minGrade then
                    local playerGrade = VFW.PlayerData.job.grade_name
                    local gradeOrder = {
                        ["novice"] = 0,
                        ["exp"] = 1,
                        ["drh"] = 2,
                        ["copatron"] = 3,
                        ["boss"] = 4
                    }
                    
                    local playerGradeLevel = gradeOrder[playerGrade] or 0
                    local requiredGradeLevel = gradeOrder[item.minGrade] or 0
                    
                    canAccess = playerGradeLevel >= requiredGradeLevel
                end

                if canAccess then
                    local tempCatalogue = {
                        label = item.label,
                        model = item.name,
                        image = ("items/%s.webp"):format(item.name),
                    }

                    table.insert(itemsData[category], tempCatalogue)
                end
            end
        end

        return itemsData[category]
    end

    local function getItemsData(category)
        local data = {
            style = {
                menuStyle = "custom",
                backgroundType = 1,
                bannerType = 2,
                gridType = 5,
                buyType = 2,
                bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(lastJob),
                buyTextType = false,
                buyText = "Récupérer",
            },
            eventName = ("items_%s"):format(lastJob),
            category = { show = false },
            cameras = { show = false },
            nameContainer = { show = false },
            headCategory = config.Nui.headCategory,
            showStats = { show = false },
            mouseEvents = false,
            color = { show = false },
            items = getItemsCategory(category)
        }

        return data
    end

    function VFW.Jobs.Catalogue.MenuItems()
        VFW.Nui.NewGrandMenu(true, getItemsData(config.Nui.defaultCategory))
    end

    local function closeUI()
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.NewGrandMenu(false)
    end

    RegisterNuiCallback(("nui:newgrandcatalogue:items_%s:selectHeadCategory"):format(lastJob), function(data)
        if data == nil then return end
        config.Nui.lastCategory = data
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(getItemsData(config.Nui.lastCategory))
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:items_%s:selectBuy"):format(lastJob), function(data)
        if data == nil then return end
        for i = 1, #config.Items[config.Nui.lastCategory] do
            local item = config.Items[config.Nui.lastCategory][i]

            if type(data) == "table" then
                for i = 1, #data do
                    if item.name == data[i] then
                        TriggerServerEvent("core:server:jobs:items", data[i])
                        break
                    end
                end
            else
                if item.name == data then
                    TriggerServerEvent("core:server:jobs:items", data)
                    break
                end
            end
        end
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:items_%s:close"):format(lastJob), function()
        closeUI()
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

    console.debug(("^3[%s]: ^7Items ^3loaded"):format(VFW.PlayerData.job.label))
end

local function deletingZone()
    for i, zone in ipairs(lastZone) do
        if zone then
            Worlds.Zone.Remove(zone)
            lastZone[i] = nil
        end
    end

    VFW.RemoveInteraction(("items_%s"):format(lastJob))

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
    loadItems()
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
    loadItems()
end)
