local sex = "Homme"
local lastCategory = nil
local componentIdData = {}
local indexCategory = 0
local lastObject = nil
local open = false

local function BarberData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 2,
            buyType = 0,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = "BARBER",
        },
        eventName = "barberShop",
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        category = { show = false },
        cameras = { show = false },
        color = { show = false },
        items = {
            {
                label = 'COUPES',
                model = 'Coupe',
                image = "assets/catalogues/barber/cheveux.png",
                style = "big",
            },
            {
                label = 'DEGRADE',
                model = 'Degradé',
                image = "assets/catalogues/barber/degrader.png",
                style = "normal",
            },
            {
                label = 'YEUX',
                model = 'Yeux',
                image = "assets/catalogues/barber/yeux.png",
                style = "normal",
            },
            {
                label = 'SOURCILS',
                model = 'Sourcils',
                image = "assets/catalogues/barber/eyebrow.png",
                style = "normal",
            },
        }
    }

    if sex == "Homme" then
        table.insert(data.items, {label = "Barbe", model = "Barbe", image = "assets/catalogues/barber/barbe.png", style = "normal"})
    end

    return data
end

local function getComponentId(category)
    componentIdData[category] = {}

    if category == "Coupe" then
        table.insert(componentIdData[category], {
            label = "Aucun",
            model = 0,
            premium = false,
            image = "outfits_greenscreener/aucun.png"
        })

        for i = 1, GetNumberOfPedDrawableVariations(VFW.PlayerData.ped, 2) - 1 do
            if not VFW.Table.TableContains(Config.BarberBan[sex].CoupesBan, i) then
                local tempCatalogue = {
                    label = i,
                    model = i,
                    premium = false,
                    price = VFW.Math.GroupDigits(20),
                    image = "assets/catalogues/barber/" .. sex .. "/Coupes/" .. i .. ".webp"
                }

                table.insert(componentIdData[category], tempCatalogue)
            end
        end
    elseif category == "Yeux" then
        for i = 0, 31 do
            local tempCatalogue = {
                label = i,
                model = i,
                premium = false,
                price = VFW.Math.GroupDigits(20),
                image = "assets/catalogues/barber/" .. sex .. "/Yeux/" .. i .. ".webp"
            }

            table.insert(componentIdData[category], tempCatalogue)
        end
    elseif category == "Barbe" then
        table.insert(componentIdData[category], {
            label = "Aucun",
            model = -1,
            premium = false,
            image = "outfits_greenscreener/aucun.png"
        })

        for i = 0, GetNumHeadOverlayValues(1) do
            local tempCatalogue = {
                label = i,
                model = i,
                premium = false,
                price = VFW.Math.GroupDigits(20),
                image = "assets/catalogues/barber/" .. sex .. "/Barbes/" .. i .. ".webp"
            }

            table.insert(componentIdData[category], tempCatalogue)
        end
    elseif category == "Sourcils" then
        for i = 0, GetPedHeadOverlayNum(2) do
            local tempCatalogue = {
                label = i,
                model = i,
                premium = false,
                price = VFW.Math.GroupDigits(20),
                image = "assets/shenails/" .. sex .. "/Sourcils/" .. i .. ".webp"
            }

            table.insert(componentIdData[category], tempCatalogue)
        end
    elseif category == "Degradé" then
        table.insert(componentIdData[category], {
            label = "Aucun",
            model = -1,
            premium = false,
            image = "outfits_greenscreener/aucun.png"
        })

        local tattoos = GetDegrader()

        for i = 1, #tattoos do
            local tattoo = tattoos[i]

            if tattoos[i].Zone == "ZONE_HEAD" then
                local tempCatalogue = {
                    label = i,
                    model = i,
                    premium = false,
                    price = VFW.Math.GroupDigits(20),
                    image = "assets/catalogues/tattoo/tattooList/" .. tattoo.HashNameMale:gsub("_[MF]$", ""):lower() .. ".png"
                }

                table.insert(componentIdData[category], tempCatalogue)
            end
        end
    end

    return componentIdData[category]
end

local function barberComponentId(category, indexCategory)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_barbershop.webp",
            buyTextType = false,
            buyText = "Acheter",
        },
        eventName = "barberShopId",
        category = {
            show = true,
            defaultIndex = indexCategory,
            items = {
                {id = "Sourcils", label = "Sourcils", image = "assets/catalogues/barber/eyebrow2.png"},
                {id = "Yeux", label = "Yeux", image = "assets/catalogues/barber/yeux2.png"},
                {id = "Degradé", label = "Degradé", image = "assets/catalogues/barber/degrader2.png"},
                {id = "Coupe", label = "Coupes", image = "assets/catalogues/barber/cheveux2.png"},
            }
        },
        cameras = {
            show = true,
            label = "Caméras",
            items = {
                {id = "profil", image = ""},
                {id = "face", image = ""},
                {id = "dos", image = ""}
            }
        },
        nameContainer = { show = false },
        headCategory = { show = false },
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        items = getComponentId(category)
    }

    if category == "Sourcils" or category == "Barbe" then
        data.color = {
            show = true,
            primary = true,
            primary_color = 0,
            secondary = true,
            secondary_color = 0,
            opacity = true,
            opacity_percent = 0
        }
    elseif category == "Coupe" then
        data.color = {
            show = true,
            primary = true,
            primary_color = 0,
            secondary = true,
            secondary_color = 0,
            opacity = false,
            opacity_percent = 0
        }
    end

    if sex == "Homme" then
        table.insert(data.category.items, {id = "Barbe", label = "Barbe", image = "assets/catalogues/barber/barbe2.png"})
    end

    if category == "Yeux" then
        data.cameras = { show = false }
    end

    return data
end

local function loadBarberAnimIn()
    local playerPed = VFW.PlayerData.ped
    local anim = "misshair_shop@hair_dressers"

    VFW.Streaming.RequestAnimDict(anim)

    local chairFound = nil
    chairFound = lastObject

    if chairFound then
        local px, py, pz = table.unpack(GetEntityCoords(chairFound))
        local chairHeading = GetEntityHeading(chairFound)
        local followCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        local camOffset = vector3(0.0, -1.5, 1.0)
        local camPos = GetOffsetFromEntityInWorldCoords(playerPed, camOffset.x, camOffset.y, camOffset.z)

        SetCamCoord(followCam, camPos.x, camPos.y, camPos.z)
        PointCamAtEntity(followCam, playerPed, 0.0, 0.0, 0.6, true)
        SetCamActive(followCam, true)
        RenderScriptCams(true, false, 0, true, true)

        local targetHeading = (chairHeading - 90.0) % 360.0

        TaskPlayAnimAdvanced(playerPed, anim, "player_enterchair", vector3(px, py, pz + 0.2), vector3(0.0, 0.0, targetHeading), 8.0, -8.0, -1, 5642, 0.0, 2, 1)

        while not HasEntityAnimFinished(playerPed, anim, "player_enterchair", 3) do
            local camPos = GetOffsetFromEntityInWorldCoords(playerPed, camOffset.x, camOffset.y, camOffset.z)
            SetCamCoord(followCam, camPos.x, camPos.y, camPos.z)
            Wait(0)
        end

        TaskPlayAnimAdvanced(playerPed, anim, "player_base", vector3(px, py, pz + 0.2), vector3(0.0, 0.0, targetHeading), 8.0, -8.0, -1, 5641, 0.0, 2, 1)

        DestroyCam(followCam)
        RenderScriptCams(false, false, 0, true, true)
        Wait(150)
        VFW.Cam:Create('cam_barber', Config.Features.Barber.Cam[1])
    end
end

local function loadBarberAnimOut()
    local playerPed = VFW.PlayerData.ped
    local animDict = "misshair_shop@hair_dressers"

    VFW.Streaming.RequestAnimDict(animDict)

    local chairFound = lastObject

    if chairFound then
        local px, py, pz = table.unpack(GetEntityCoords(chairFound))
        local chairHeading = GetEntityHeading(chairFound)
        local targetHeading = (chairHeading - 90.0) % 360.0

        TaskPlayAnimAdvanced(playerPed, animDict, "exitchair_female", vector3(px, py, pz + 0.2), vector3(0.0, 0.0, targetHeading), 8.0, -8.0, -1, 5642, 0.2, 2, 1)

        local animDuration = (GetAnimDuration(animDict, "exitchair_female") * 1000) - 3000
        Wait(animDuration)

        RemoveAnimDict("misshair_shop@barbers")
        RemoveAnimDict(animDict)

        Wait(1500)
        ClearPedTasks(playerPed)
        Wait(1000)
    end
end

local function LoadBarber()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 or skin.sex == 1 then
            open = true
            if skin.sex == 1 then
                sex = "Femme"
            end

            cEntity.Visual.HideAllEntities(true)
            cEntity.Visual.AddEntityToException(VFW.PlayerData.ped)

            loadBarberAnimIn()

            VFW.Nui.NewGrandMenu(true, BarberData())
        else
            VFW.ShowNotification({
                type = "ROUGE",
                content = "Les peds ne peuvent pas utiliser le salon de coiffure.",
            })
        end
    end)
end

local function closeUI()
    cEntity.Visual.HideAllEntities(false)
    VFW.Cam:Destroy('cam_barber')
    VFW.Nui.NewGrandMenu(false)
    loadBarberAnimOut()
    sex = "Homme"
    lastCategory = nil
    indexCategory = 0
    componentIdData = {}
    lastObject = nil
    open = false
end

RegisterNuiCallback("nui:newgrandcatalogue:barberShop:selectGridType2", function(data)
    if not data then return end
    lastCategory = data
    if lastCategory == "Yeux" or lastCategory == "Sourcils" then
        if lastCategory == "Yeux" then
            indexCategory = 1
        else
            indexCategory = 0
        end
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[4])
    else
        if lastCategory == "Coupe" then
            indexCategory = 3
        elseif lastCategory == "Barbe" then
            indexCategory = 4
        elseif lastCategory == "Degradé" then
            indexCategory = 2
        end
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[1])
    end
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(barberComponentId(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:selectGridType", function(data)
    if not data then return end
    if lastCategory == "Degradé" then
        local tattoos = GetDegrader()
        ClearPedDecorations(VFW.PlayerData.ped)
        if data ~= -1 then
            TriggerEvent("skinchanger:change", "degrade_collection", joaat(tattoos[data].Collection))
            TriggerEvent("skinchanger:change", "degrade_hashname", joaat(tattoos[data].HashNameMale))
        else
            TriggerEvent("skinchanger:change", "degrade_collection", data)
            TriggerEvent("skinchanger:change", "degrade_hashname", data)
        end
    elseif lastCategory == "Barbe" then
        TriggerEvent("skinchanger:change", "beard_1", data)
        TriggerEvent("skinchanger:change", "beard_2", 10)
    elseif lastCategory == "Sourcils" then
        TriggerEvent("skinchanger:change", "eyebrows_1", data)
        TriggerEvent("skinchanger:change", "eyebrows_2", 10)
    elseif lastCategory == "Coupe" then
        TriggerEvent("skinchanger:change", "hair_1", data)
    elseif lastCategory == "Yeux" then
        TriggerEvent("skinchanger:change", "eye_color", data)
    end
    for _, tattoo in ipairs(VFW.PlayerData.tattoos) do
        AddPedDecorationFromHashes(VFW.PlayerData.ped, tattoo.Collection, tattoo.Hash)
    end
    ClearPedProp(VFW.PlayerData.ped, 0)
    ClearPedProp(VFW.PlayerData.ped, 1)
    SetPedComponentVariation(VFW.PlayerData.ped, 1, 0, 0, 2)
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:selectBuy", function()
    local getMoney = TriggerServerCallback("core:server:getClothesMoney", "sheNails")

    if getMoney then
        TriggerEvent("skinchanger:getSkin", function(skin)
            TriggerServerEvent("vfw:skin:save", skin)
            TriggerEvent('skinchanger:loadSkin', skin or {})
        end)
    else
        local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', skin or {})
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:enter", function()
    local getMoney = TriggerServerCallback("core:server:getClothesMoney", "sheNails")

    if getMoney then
        TriggerEvent("skinchanger:getSkin", function(skin)
            TriggerServerEvent("vfw:skin:save", skin)
            TriggerEvent('skinchanger:loadSkin', skin or {})
        end)
    else
        local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', skin or {})
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:changeColor1", function(data)
    if not data then return end
    if lastCategory == "Coupe" then
        TriggerEvent("skinchanger:change", "hair_color_1", data)
    elseif lastCategory == "Barbe" then
        TriggerEvent("skinchanger:change", "beard_3", data)
    elseif lastCategory == "Sourcils" then
        TriggerEvent("skinchanger:change", "eyebrows_3", data)
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:changeColor2", function(data)
    if not data then return end
    if lastCategory == "Coupe" then
        TriggerEvent("skinchanger:change", "hair_color_2", data)
    elseif lastCategory == "Barbe" then
        TriggerEvent("skinchanger:change", "beard_4", data)
    elseif lastCategory == "Sourcils" then
        TriggerEvent("skinchanger:change", "eyebrows_4", data)
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:changeOpacity", function(data)
    if not data then return end
    if lastCategory == "Sourcils" then
        TriggerEvent("skinchanger:change", "eyebrows_2", data / 10)
    elseif lastCategory == "Barbe" then
        TriggerEvent("skinchanger:change", "beard_2", data / 10)
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:selectCategory", function(data)
    if not data then return end
    lastCategory = data
    if lastCategory == "Yeux" or lastCategory == "Sourcils" then
        if lastCategory == "Yeux" then
            indexCategory = 1
        else
            indexCategory = 0
        end
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[4])
    else
        if lastCategory == "Coupe" then
            indexCategory = 3
        elseif lastCategory == "Barbe" then
            indexCategory = 4
        elseif lastCategory == "Degradé" then
            indexCategory = 2
        end
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[1])
    end
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(barberComponentId(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:selectCamera", function(data)
    if data == "profil" then
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[1])
    elseif data == "face" then
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[2])
    elseif data == "dos" then
        VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[3])
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Cam:Update('cam_barber', Config.Features.Barber.Cam[1])
    VFW.Nui.UpdateNewGrandMenu(BarberData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShopId:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNuiCallback("nui:newgrandcatalogue:barberShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

local models = {
    [joaat("gabz_barber_barberchair")] = true,
    [joaat("v_ilev_hd_chair")] = true,
}

CreateThread(function()
    while not VFW.PlayerLoaded do
        Wait(100)
    end

    for _, v in ipairs(Config.Features.Barber.Pos) do
        VFW.CreateBlipInternal(vector3(v.x, v.y, v.z), 71, 47, 0.8, "Barber")
    end
end)

local barberPoints = {}

CreateThread(function()
    while true do
        for _, entity in pairs(GetGamePool("CObject")) do
            local model = GetEntityModel(entity)
            local objectPos = GetEntityCoords(entity)
            
            if not barberPoints[objectPos] then
                if models[model] then
                    barberPoints[objectPos] = Worlds.Zone.Create(vector3(objectPos.x, objectPos.y, objectPos.z + 1.0), 2, false, function()
                        VFW.RegisterInteraction("barber", function()
                            lastObject = entity
                            ClearPedProp(VFW.PlayerData.ped, 0)
                            ClearPedProp(VFW.PlayerData.ped, 1)
                            SetPedComponentVariation(VFW.PlayerData.ped, 1, 0, 0, 2)
                            LoadBarber()
                        end)
                    end, function()
                        VFW.RemoveInteraction("barber")
                    end, "Coiffeur", "E", "Barber")
                end
            end
        end

        Wait(5000)
    end
end)
