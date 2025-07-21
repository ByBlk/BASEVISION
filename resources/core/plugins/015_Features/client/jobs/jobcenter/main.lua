local model = nil
local lastCategory = nil
local defaultCategory = "gopostal"
local defaultIndex = {
    ["gopostal"] = 0,
    ["lstransit"] = 1,
    ["train"] = 2,
    ["mineur"] = 3,
    ["livreur"] = 4,
    --["pompier"] = 5,
    ["eboueur"] = 5,
    --["pompiste"] = 7,
}

local jobConfigs = {
    ["gopostal"] = {
        vehicle = "boxville2",
        coords = vector3(64.29, 96.71, 77.79),
        heading = 156.8712615966797,
        cam = {
            coords = vector3(63.11104583740234, 89.74944305419922, 79.17884826660156),
            rot = vector3(0.05741782113909, 0.0, -3.75511837005615),
            fov = 51.0,
            coh = vector4(63.29001235961914, 90.75044250488281, 78.71688842773438, 156.8712615966797)
        }
    },
    ["lstransit"] = {
        animation = { anim = "_idle_a", dict = "random@shop_tattoo" },
        cam = {
            coords = vector3(-534.1869506835938, -677.8194580078125, 12.26866340637207),
            rot = vector3(-2.91802477836608, -0.0, -69.6031723022461),
            fov = 50.1,
            coh = vector4(-533.0807495117188, -677.5272827148438, 11.81414985656738, 107.08685302734375)
        }
    },
    ["train"] = {
        vehicle = "freight",
        coords = vector3(2611.94, 1722.15, 25.6),
        heading = 178.61,
        cam = {
            coords = vector3(2615.880859375, 1701.5390625, 28.03220176696777),
            rot = vector3(-2.0017249584198, 0.0, 37.03037643432617),
            fov = 40.1,
            coh = vector4(2615.060791015625, 1702.7872314453126, 27.59850120544433, 215.05941772460938)
        }
    },
    ["mineur"] = {
        vehicle = "bison",
        coords = vector3(2969.53, 2750.84, 41.75),
        heading = 215.43,
        cam = {
            coords = vector3(2964.239013671875, 2741.6396484375, 43.81752777099609),
            rot = vector3(-1.34665203094482, 0.0, -9.65744018554687),
            fov = 40.1,
            coh = vector4(2964.578857421875, 2743.06591796875, 43.40446853637695, 147.3030548095703)
        }
    },
    ["livreur"] = {
        vehicle = "foodbike",
        coords = vector3(796.8654174804688, -729.89794921875, 27.24362754821777),
        heading = 56.26859283447265,
        --animation = { anim = "idle", dict = "anim@heists@box_carry@" },
        cam = {
            coords = vector3(795.6405029296875,-724.8935546875, 28.26963233947754),
            rot = vector3(-5.65052700042724, -0.0, -151.4204559326172),
            fov = 50.1,
            coh = vector4(796.3269653320313, -726.2239990234375,27.90463066101074, 28.95268249511718),
        }
    },

    -- ["pompier"] = {
    --     vehicle = "dodo",
    --     coords = vector3(2140.078125, 4814.119140625, 42.46868515014648),
    --     heading = 114.9357681274414,
    --     cam = {
    --         coords = vector3(2126.1591796875, 4799.83349609375, 41.5215835571289),
    --         rot = vector3(-1.02682971954345, 0.0, -29.73242950439453),
    --         fov = 51.0,
    --         coh = vector4(2126.7890625, 4800.65869140625, 41.06969451904297, 139.2996368408203)
    --     }
    -- },
    ["eboueur"] = {
        cam = {
            coords = vector3(-592.6558227539063, -1658.5360107421876, 19.88378524780273),
            rot = vector3(-2.51355981826782, 0.0, -131.7525634765625),
            fov = 40.1,
            coh = vector4(-591.5087280273438, -1659.585205078125, 19.42291450500488, 50.2685317993164)
        }
    }
    -- ["pompiste"] = {
    --     vehicle = "brickadeta",
    --     coords = vector3(-2096.98, -335.61, 12.38),
    --     heading = 217.94,
    --     weapon = true,
    --     weapon_name = "weapon_petrolcan",
    --     animation = { anim = "fire", dict = "weapons@misc@jerrycan@" },
    --     cam = {
    --         coords = vector3(-2095.913330078125, -347.29510498046875, 13.12649345397949),
    --         rot = vector3(-1.33075547218322, 2.66804249804408768, 18.41157341003418),
    --         fov = 50.1,
    --         coh = vector4(-2096.35888671875, -345.79461669921875, 12.91105270385742, 205.34181213378906)
    --     }
    -- }
}

local function JobCenter(category)
    return {
        style = {
            menuStyle = "interim",
            backgroundType = 1,
            bannerType = 1,
            gridType = 1,
            buyType = 0,
            bannerImg = "assets/catalogues/headers/jobcenter.webp",
        },
        eventName = "interim",
        showStats = { show = false },
        category = {
            show = true,
            defaultIndex = defaultIndex[category] or 0,
            items = {
                { id ="gopostal", label ="Go Postal", image ="assets/catalogues/interim/GoPostal.png" },
                { id ="lstransit", label ="Chauffeur de Tramway", image ="assets/catalogues/interim/Bus.png" },
                { id ="train", label ="Chauffeur de train", image ="assets/catalogues/interim/Chasse.png" },
                { id ="mineur", label ="Mineur", image ="assets/catalogues/interim/mineur_2.png" },
                { id ="livreur", label ="Livreur de pizza", image ="assets/jobmenu/Pizzathis.png" },
                --{ id ="pompier", label ="Canadair", image ="assets/catalogues/interim/Pompier.png" },
                { id ="eboueur", label ="Éboueur", image ="assets/catalogues/interim/Eboueur.png" },
                --{ id ="pompiste", label ="Pompiste", image ="assets/jobmenu/Globeoil.webp" },
            }
        },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Métier d'intérim", id = 1 },
            }
        },
        color = { show = false },
        items = {},
        interim = VFW.Jobs.Catalogue.JobCenter[category],
    }
end

local clonePed = nil

local function loadOutfit(category)
    TriggerEvent("skinchanger:getSkin", function(skin)
        local uniformObject = skin.sex == 0
                and VFW.Jobs.Catalogue.JobCenter.Outfits[category].male
                or VFW.Jobs.Catalogue.JobCenter.Outfits[category].female

        if uniformObject then
            SetPedComponentVariation(clonePed, 8, uniformObject["tshirt_1"], uniformObject["tshirt_2"], 2) -- Tshirt
            SetPedComponentVariation(clonePed, 11, uniformObject["torso_1"], uniformObject["torso_2"], 2) -- torso parts
            SetPedComponentVariation(clonePed, 3, uniformObject["arms"], uniformObject["arms_2"], 2) -- Arms
            SetPedComponentVariation(clonePed, 10, uniformObject["decals_1"], uniformObject["decals_2"], 2) -- decals
            SetPedComponentVariation(clonePed, 4, uniformObject["pants_1"], uniformObject["pants_2"], 2) -- pants
            SetPedComponentVariation(clonePed, 6, uniformObject["shoes_1"], uniformObject["shoes_2"], 2) -- shoes
            SetPedComponentVariation(clonePed, 1, uniformObject["mask_1"], uniformObject["mask_2"], 2) -- mask
            SetPedComponentVariation(clonePed, 9, uniformObject["bproof_1"], uniformObject["bproof_2"], 2) -- bulletproof
            SetPedComponentVariation(clonePed, 7, uniformObject["chain_1"], uniformObject["chain_2"], 2) -- chain
            SetPedComponentVariation(clonePed, 5, uniformObject["bags_1"], uniformObject["bags_2"], 2) -- Bag
        end
    end)
end

local function pedClone(ped, config)
    clonePed = ClonePed(ped, false, false)
    SetEntityAsMissionEntity(clonePed, true, true)
    SetEntityVisible(clonePed, false, false)
    SetBlockingOfNonTemporaryEvents(clonePed, true)
    SetFocusPosAndVel(config.cam.coh.x, config.cam.coh.y, config.cam.coh.z - 1.0)
    SetEntityCoords(clonePed, config.cam.coh.x, config.cam.coh.y, config.cam.coh.z)
    Wait(100)
    SetEntityVisible(clonePed, true, false)
    SetEntityHeading(clonePed, config.cam.coh.w)
    SetEntityCoords(clonePed, config.cam.coh.x, config.cam.coh.y, config.cam.coh.z - 1.0)
    loadOutfit(config.category)

    if config.weapon and config.weapon_name then
        GiveWeaponToPed(clonePed, GetHashKey(config.weapon_name), 250, false, true)
        SetCurrentPedWeapon(clonePed, GetHashKey(config.weapon_name), true)
    end


    VFW.Cam:Create("cam_interim", {
        CamCoords = {x = config.cam.coords.x, y = config.cam.coords.y, z = config.cam.coords.z},
        Fov = config.cam.fov,
        CamRot = {x = config.cam.rot.x, y = config.cam.rot.y, z = config.cam.rot.z},
        Freeze = config.freeze or false,
        Dof = true,
        COH = {x = config.cam.coh.x, y = config.cam.coh.y, z = config.cam.coh.z, w = config.cam.coh.w},
        DofStrength = config.dofStrength or 0.9,
        Animation = config.animation or { anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a" },
        Transition = 0,
    }, clonePed)

    DoScreenFadeIn(1000)
end

local function pedDestroy()
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    VFW.Cam:Destroy("cam_interim")
    if DoesEntityExist(clonePed) then
        DeleteEntity(clonePed)
    end
    ClearFocus()
    DoScreenFadeIn(1000)
end

local function setupWorld()
    NetworkOverrideClockTime(12, 0, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
end

local function selectCategoryAccept(data)
    if data == "LIVREUR" then 
        SetNewWaypoint(60.89, 129.03)
    elseif data == "CHAUFFEUR" then 
        SetNewWaypoint(-534.34, -675.08)
    elseif data == "MINEUR" then
        SetNewWaypoint(2829.0295, 2810.6799)
    elseif data == "TRAIN" then
        SetNewWaypoint(-138.76, 6146.6)
    elseif data == "LIVREUR PIZZA" then 
        SetNewWaypoint(287.75, -963.21)
    -- elseif data == "POMPIER" then 
    --     SetNewWaypoint(2140.078125, 4814.119140625)
    elseif data == "ÉBOUEUR" then
        SetNewWaypoint(-321.47, -1545.54)
    -- elseif data == "POMPISTE" then
    --     SetNewWaypoint(-2096.98, -335.61)
    end
end

local vehicle = nil

local function createCamOnMenuOpen()
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    setupWorld()

    if vehicle then
        if DoesEntityExist(vehicle) then
            VFW.Game.DeleteVehicle(vehicle)
        end
    end

    local config = jobConfigs[defaultCategory]
    if config.vehicle then
        VFW.Streaming.RequestModel(GetHashKey(config.vehicle))
        vehicle = CreateVehicle(
                GetHashKey(config.vehicle),
                config.coords.x, config.coords.y, config.coords.z - 1.0,
                config.heading,
                false, false
        )
        SetVehicleDoorsLocked(vehicle, 2)
        cEntity.Visual.AddEntityToException(vehicle)
        model = vehicle
    end
    

    pedClone(VFW.PlayerData.ped, {
        cam = config.cam,
        animation = { anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a" },
        category = defaultCategory,
    })

    TriggerServerEvent("core:server:instanceJobCenter", true)
end

RegisterNUICallback("nui:newgrandcatalogue:interim:close", function()
    VFW.Nui.NewGrandMenu(false)
    pedDestroy()
    if model and DoesEntityExist(model) then
        VFW.Game.DeleteVehicle(model)
    end
    TriggerServerEvent("core:server:instanceJobCenter", false)
end)

RegisterNUICallback("nui:newgrandcatalogue:interim:selectBuy", function(data)
    if not data then return end

    VFW.Nui.NewGrandMenu(false)
    pedDestroy()
    if model and DoesEntityExist(model) then
        VFW.Game.DeleteVehicle(model)
    end
    TriggerServerEvent("core:server:instanceJobCenter", false)
    selectCategoryAccept(data)
end)

RegisterNUICallback("nui:newgrandcatalogue:interim:selectCategory", function(data)
    if not data then return end

    SetNuiFocus(false, false)

    lastCategory = data
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(JobCenter(lastCategory))

    if model and DoesEntityExist(model) then
        VFW.Game.DeleteVehicle(model)
        model = nil
    end

    local config = jobConfigs[lastCategory]
    if not config then
        canSelectCategory = true
        return
    end

    if config.vehicle then
        VFW.Streaming.RequestModel(GetHashKey(config.vehicle))
        vehicle = CreateVehicle(
                GetHashKey(config.vehicle),
                config.coords.x, config.coords.y, config.coords.z - 1.0,
                config.heading,
                false, false
        )
        SetVehicleDoorsLocked(vehicle, 2)
        cEntity.Visual.AddEntityToException(vehicle)
        model = vehicle
    end

    pedDestroy()
    pedClone(VFW.PlayerData.ped, {
        cam = config.cam,
        animation = config.animation,
        freeze = lastCategory == "pompier",
        dofStrength = (lastCategory == "eboueur" or lastCategory == "pompiste") and 1.0 or 0.9,
        category = lastCategory,
        weapon = config.weapon,
        weapon_name = config.weapon_name,
    })

    SetNuiFocus(true, true)
end)

function OpenJobCenter()
    createCamOnMenuOpen()
    VFW.Nui.NewGrandMenu(true, JobCenter(defaultCategory))
end
