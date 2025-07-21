local lastJob = nil
local open = false
local objetSpawn = {}

local function loadObjet()
    while not VFW.Jobs or not VFW.Jobs.Catalogue or not VFW.Jobs.Catalogue.Objets do
        Wait(100)
    end

    while not next(VFW.Jobs.Catalogue.Objets) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Catalogue.Objets[lastJob] then return end

    local objetsData = {}
    local config = VFW.Jobs.Catalogue.Objets[lastJob]

    local function getObjetsCategory(category)
        objetsData[category] = {}

        if config.Objets[category] then
            for i = 1, #config.Objets[category] do
                local objet = config.Objets[category][i]
                local tempCatalogue = {
                    label = objet.label,
                    model = objet.prop,
                    image = objet.image,
                }

                table.insert(objetsData[category], tempCatalogue)
            end
        end

        return objetsData[category]
    end

    local function getObjetsData(category)
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
            eventName = ("objet_%s"):format(lastJob),
            category = { show = false },
            cameras = { show = false },
            nameContainer = { show = false },
            headCategory = {
                show = true,
                items = {{ label = category, id = nil }}
            },
            showStats = { show = false },
            mouseEvents = false,
            color = { show = false },
            items = getObjetsCategory(category)
        }

        return data
    end

    local function menuObjetsData()
        local data = {
            style = {
                menuStyle = "custom",
                backgroundType = 1,
                bannerType = 2,
                gridType = 2,
                buyType = 0,
                bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(lastJob),
                buyTextType = false,
                buyText = "Sélectionner",
            },
            eventName = ("objetMain_%s"):format(lastJob),
            showStats = false,
            mouseEvents = false,
            color = { show = false },
            nameContainer = { show = false },
            headCategory = {
                show = true,
                items = {{ label = "Objets", id = nil }}
            },
            category = { show = false },
            cameras = { show = false },
            items = config.Nui.items
        }

        return data
    end

    function MenuJobsObjet(category)
        if RadialOpen then
            VFW.Nui.Radial(nil, false)
            RadialOpen = false
        end
        open = true
        if category == nil then
            VFW.Nui.NewGrandMenu(true, menuObjetsData())
        else
            VFW.Nui.NewGrandMenu(true, getObjetsData(category))
        end
        SetNuiFocusKeepInput(true)
        CreateThread(function()
            while open do
                Wait(0)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 142, open)
                DisableControlAction(0, 18, open)
                DisableControlAction(0, 322, open)
                DisableControlAction(0, 106, open)
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
    end

    local function closeUI()
        open = false
        VFW.Nui.NewGrandMenu(false)
        SetNuiFocusKeepInput(false)
    end

    local function SpawnProps(category, obj)
        local playerPed = VFW.PlayerData.ped
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objCoords = coords + forward * 2.5
        local heading = GetEntityHeading(playerPed)
        local placed = false
        local objS = CreateObject(GetHashKey(obj), objCoords.x, objCoords.y, objCoords.z, true, true, true)

        SetEntityHeading(objS, heading)
        PlaceObjectOnGroundProperly(objS)
        SetEntityAlpha(objS, 170, false)
        SetEntityCollision(objS, false, true)

        while not placed do
            coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
            objCoords = coords + forward * 2.5
            SetEntityCoords(objS, objCoords.x, objCoords.y, objCoords.z, false, false, false, true)
            PlaceObjectOnGroundProperly(objS)

            if IsControlPressed(0, 190) then
                heading = heading + 0.5
            elseif IsControlPressed(0, 189) then
                heading = heading - 0.5
            end

            SetEntityHeading(objS, heading)

            VFW.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")

            if IsControlJustPressed(0, 38) then
                placed = true
            end

            DisableControlAction(0, 22, true)

            Wait(0)
        end

        ResetEntityAlpha(objS)
        SetEntityCollision(objS, true, true)
        FreezeEntityPosition(objS, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(objS), true)
        table.insert(objetSpawn, objS)
        MenuJobsObjet(category)
    end

    RegisterNuiCallback(("nui:newgrandcatalogue:objetMain_%s:selectGridType2"):format(lastJob), function(data)
        config.Nui.lastCategory = data
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(getObjetsData(config.Nui.lastCategory))
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:objet_%s:selectGridType"):format(lastJob), function(data)
        closeUI()
        Wait(50)
        for i = 1, #config.Objets[config.Nui.lastCategory] do
            local objet = config.Objets[config.Nui.lastCategory][i]

            if objet.prop == data then
                SpawnProps(config.Nui.lastCategory, data)
                break
            end
        end
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:objet_%s:backspace"):format(lastJob), function()
        config.Nui.lastCategory = config.Nui.defaultCategory
        VFW.Nui.UpdateNewGrandMenu(menuObjetsData())
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:objetMain_%s:close"):format(lastJob), function()
        closeUI()
    end)

    RegisterNuiCallback(("nui:newgrandcatalogue:objet_%s:close"):format(lastJob), function()
        closeUI()
    end)

    console.debug(("^3[%s]: ^7Objet ^3loaded"):format(VFW.PlayerData.job.label))
end

VFW.ContextAddButton("object", "Ramasser", function(object)
    for _, ent in pairs(objetSpawn) do
        if ent and DoesEntityExist(ent) then
            local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(ent), true)
            if distance < 2.75 then
                return true
            end
        end
    end
    return false
end, function(object)
    for i = #objetSpawn, 1, -1 do
        if objetSpawn[i] and DoesEntityExist(objetSpawn[i]) and objetSpawn[i] == object then
            DeleteEntity(objetSpawn[i])
            table.remove(objetSpawn, i)
        end
    end
end)

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(500)
    loadObjet()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadObjet()
end)
