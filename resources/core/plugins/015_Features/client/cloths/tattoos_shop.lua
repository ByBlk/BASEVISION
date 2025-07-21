local tattooZone = {
    ZONE_HEAD = {},
    ZONE_LEFT_ARM = {},
    ZONE_RIGHT_ARM = {},
    ZONE_LEFT_LEG = {},
    ZONE_RIGHT_LEG = {},
    ZONE_TORSO = {},
}
local cams = nil
local currentTattoos
local lastCategory = nil
local componentData = {}
local indexCategory = 0
local sex = "Homme"

local function TattooData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 2,
            buyType = 0,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = "TATTOO SHOP",
        },
        eventName = "TattooShop",
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        category = { show = false },
        cameras = { show = false },
        items = {
            {
                label = 'TORSE',
                model = 'Torse',
                image = "assets/catalogues/tattoo/" .. sex .. "/Torse.webp",
                style = "big",
            },
            {
                label = 'DOS',
                model = 'Dos',
                image = "assets/catalogues/tattoo/" .. sex .. "/Dos.webp",
                style = "normal",
            },
            {
                label = 'VISAGE',
                model = 'Visage',
                image = "assets/catalogues/tattoo/" .. sex .. "/Visage.webp",
                style = "normal",
            },
            {
                label = 'BRAS GAUCHE',
                model = 'Bras gauche',
                image = "assets/catalogues/tattoo/" .. sex .. "/Torse.webp",
                style = "semi",
            },
            {
                label = 'BRAS DROIT',
                model = 'Bras droit',
                image = "assets/catalogues/tattoo/" .. sex .. "/BrasDroit.webp",
                style = "semi",
            },
            {
                label = 'JAMBE GAUCHE',
                model = 'Jambe gauche',
                image = "assets/catalogues/tattoo/" .. sex .. "/BrasGauche.webp",
                style = "semi",
            },
            {
                label = 'JAMBE DROITE',
                model = 'Jambe droite',
                image = "assets/catalogues/tattoo/" .. sex .. "/JambeDroite.webp",
                style = "semi",
            },
            {
                label = 'LAZER',
                model = 'Lazer',
                image = "assets/catalogues/tattoo/Lazer.png",
                style = "normal",
            },
        }
    }

    return data
end

local function getComponent(category)
    componentData[category] = {}

    local tattoos = GetTattoos()
    local zones = {
        ZONE_HEAD = { label = "Visage" },
        ZONE_LEFT_ARM = { label = "Bras gauche" },
        ZONE_RIGHT_ARM = { label = "Bras droit" },
        ZONE_LEFT_LEG = { label = "Jambe gauche" },
        ZONE_RIGHT_LEG = { label = "Jambe droite" },
        ZONE_TORSO = { label = "Torse", extraLabel = "Dos" }
    }

    if category == "Torse" or category == "Dos" or category == "Visage" or category == "Bras gauche" or category == "Bras droit"
            or category == "Jambe gauche" or category == "Jambe droite" then
        for _, tattoo in ipairs(tattoos) do
            local zone = tattoo.Zone
            local hashName = tattoo.HashNameMale

            if hashName and hashName ~= "" and tattooZone[zone] then
                table.insert(tattooZone[zone], tattoo)

                local zoneData = zones[zone]
                local categories = { zoneData.label }

                if zoneData.extraLabel then
                    table.insert(categories, zoneData.extraLabel)
                end

                for _, v in ipairs(categories) do
                    if v == category then
                        local tempCatalogue = {
                            label = tattoo.LocalizedName,
                            model = tattoo,
                            premium = false,
                            price = VFW.Math.GroupDigits(tattoo.Price),
                            image = "assets/catalogues/tattoo/tattooList/" .. string.lower(tattoo.Img) .. ".png"
                        }

                        table.insert(componentData[v], tempCatalogue)
                    end
                end
            end
        end
    else
        for _, v in ipairs(currentTattoos) do
            for _, tattoo in ipairs(tattoos) do
                if tattoo.Collection == v.Collection then
                    local hashTattoo = tattoo.HashNameMale

                    if v.Hash == hashTattoo then
                        local tempCatalogue = {
                            label = tattoo.LocalizedName,
                            model = tattoo,
                            premium = false,
                            price = VFW.Math.GroupDigits(tattoo.Price),
                            image = "assets/catalogues/tattoo/tattooList/" .. string.lower(tattoo.Img) .. ".png"
                        }

                        table.insert(componentData[category], tempCatalogue)
                    end
                end
            end
        end
    end

    return componentData[category]
end

local function tattooComponent(category, indexCategory)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_tattooshop.webp",
            buyTextType = false,
            buyText = "Selectionner",
        },
        eventName = "TattooShopId",
        category = {
            show = true,
            defaultIndex = indexCategory,
            items = {
                {id = "Jambe droite", label = "Jambe droite", image = "assets/catalogues/tattoo/JAMBE_DROITE.png"},
                {id = "Jambe gauche", label = "Jambe gauche", image = "assets/catalogues/tattoo/JAMBE_GAUCHE.png"},
                {id = "Bras droit", label = "Bras droit", image = "assets/catalogues/tattoo/BRAS_GAUCHE.png"},
                {id = "Bras gauche", label = "Bras gauche", image = "assets/catalogues/tattoo/BRAS_DROIT.png"},
                {id = "Visage", label = "Visage", image = "assets/catalogues/tattoo/VISAGE.png"},
                {id = "Dos", label = "Dos", image = "assets/catalogues/tattoo/DOS.png"},
                {id = "Torse", label = "Torse", image = "assets/catalogues/tattoo/TORSO.png"},
            }
        },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        showStats = false,
        mouseEvents = true,
        color = { show = false },
        items = getComponent(category)
    }

    return data
end

function LoadTattoo(data)
    cams = data
    currentTattoos = TriggerServerCallback("core:server:getTattoo")

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 1 then
            sex = "Femme"
            TriggerEvent('skinchanger:loadSkin', {
                sex       = 1,
                tshirt_1  = 15, tshirt_2  = 0,
                torso_1   = 15, torso_2   = 0,
                arms      = 15, arms_2    = 0,
                pants_1   = 21, pants_2   = 0,
                shoes_1   = 34, shoes_2   = 0,
                chain_1   = 0, chain_2   = 0,
                helmet_1  = -1, helmet_2  = 0,
                ears_1    = -1, ears_2    = 0,
                glasses_1 = 0, glasses_2 = 0,
                mask_1    = 0, mask_2    = 0,
                bproof_1  = 0, bproof_2  = 0,
                bags_1    = 0, bags_2    = 0,
                decals_1  = 0, decals_2  = 0,
                watches_1 = -1, watches_2 = 0,
                bracelets_1 = -1, bracelets_2 = 0,
            })
        else
            TriggerEvent('skinchanger:loadSkin', {
                sex       = 0,
                tshirt_1  = 15, tshirt_2  = 0,
                torso_1   = 15, torso_2   = 0,
                arms      = 15, arms_2    = 0,
                pants_1   = 21, pants_2   = 0,
                shoes_1   = 34, shoes_2   = 0,
                chain_1   = 0, chain_2   = 0,
                helmet_1  = -1, helmet_2  = 0,
                ears_1    = -1, ears_2    = 0,
                glasses_1 = 0, glasses_2 = 0,
                mask_1    = 0, mask_2    = 0,
                bproof_1  = 0, bproof_2  = 0,
                bags_1    = 0, bags_2    = 0,
                decals_1  = 0, decals_2  = 0,
                watches_1 = -1, watches_2 = 0,
                bracelets_1 = -1, bracelets_2 = 0,
            })
        end
    end)

    cEntity.Visual.HideAllEntities(true)
    cEntity.Visual.AddEntityToException(VFW.PlayerData.ped)
    cEntity.Visual.DisablePlayerCollisions(true)
    VFW.Cam:Create("cam_tattoo", cams[1])

    VFW.Nui.NewGrandMenu(true, TattooData())
end

local function closeUI()
    tattooZone = {
        ZONE_HEAD = {},
        ZONE_LEFT_ARM = {},
        ZONE_RIGHT_ARM = {},
        ZONE_LEFT_LEG = {},
        ZONE_RIGHT_LEG = {},
        ZONE_TORSO = {},
    }
    cams = nil
    lastCategory = nil
    componentData = {}
    indexCategory = 0
    cEntity.Visual.HideAllEntities(false)
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy("cam_tattoo")
    cEntity.Visual.DisablePlayerCollisions(false)
end

RegisterNuiCallback("nui:newgrandcatalogue:TattooShop:selectGridType2", function(data)
    if not data then return end
    lastCategory = data
    if lastCategory == "Torse" or lastCategory == "Bras gauche" or lastCategory == "Bras droit" then
        if lastCategory == "Torse" then
            indexCategory = 6
            VFW.Cam:Update("cam_tattoo", cams[1])
        elseif lastCategory == "Bras gauche" then
            indexCategory = 3
            VFW.Cam:Update("cam_tattoo", cams[4])
        elseif lastCategory == "Bras droit" then
            indexCategory = 2
            VFW.Cam:Update("cam_tattoo", cams[6])
        end
    elseif lastCategory == "Jambe gauche" or lastCategory == "Jambe droite" then
        if lastCategory == "Jambe gauche" then
            indexCategory = 1
            VFW.Cam:Update("cam_tattoo", cams[5])
        elseif lastCategory == "Jambe droite" then
            indexCategory = 0
            VFW.Cam:Update("cam_tattoo", cams[7])
        end
    elseif lastCategory == "Visage" then
        VFW.Cam:Update("cam_tattoo", cams[3])
        indexCategory = 4
    elseif lastCategory == "Dos" then
        VFW.Cam:Update("cam_tattoo", cams[2])
        indexCategory = 5
    elseif lastCategory == "Lazer" then
        VFW.Cam:Update("cam_tattoo", cams[1])
    end
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(tattooComponent(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:selectCategory", function(data)
    if not data then return end
    lastCategory = data
    if lastCategory == "Torse" or lastCategory == "Bras gauche" or lastCategory == "Bras droit" then
        if lastCategory == "Torse" then
            indexCategory = 6
            VFW.Cam:Update("cam_tattoo", cams[1])
        elseif lastCategory == "Bras gauche" then
            indexCategory = 3
            VFW.Cam:Update("cam_tattoo", cams[4])
        elseif lastCategory == "Bras droit" then
            indexCategory = 2
            VFW.Cam:Update("cam_tattoo", cams[6])
        end
    elseif lastCategory == "Jambe gauche" or lastCategory == "Jambe droite" then
        if lastCategory == "Jambe gauche" then
            indexCategory = 1
            VFW.Cam:Update("cam_tattoo", cams[5])
        elseif lastCategory == "Jambe droite" then
            indexCategory = 0
            VFW.Cam:Update("cam_tattoo", cams[7])
        end
    elseif lastCategory == "Visage" then
        VFW.Cam:Update("cam_tattoo", cams[3])
        indexCategory = 4
    elseif lastCategory == "Dos" then
        VFW.Cam:Update("cam_tattoo", cams[2])
        indexCategory = 5
    elseif lastCategory == "Lazer" then
        VFW.Cam:Update("cam_tattoo", cams[1])
    end
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(tattooComponent(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:mouseEvents", function(data)
    SetEntityHeading(VFW.PlayerData.ped, GetEntityHeading(VFW.PlayerData.ped) + (0.5 * data.x))
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:selectGridType", function(data)
    if not data then return end
    local playerPed = VFW.PlayerData.ped

    if lastCategory ~= "Lazer" then
        ClearPedDecorations(playerPed)

        for _, tattoo in ipairs(currentTattoos) do
            AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.Hash)
        end

        local Hash = data.HashNameMale

        for _, existingTattoo in ipairs(currentTattoos) do
            if existingTattoo.Collection == data.Collection and existingTattoo.Hash == data.Hash then
                return
            end
        end

        AddPedDecorationFromHashes(playerPed, data.Collection, Hash)
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:selectBuy", function(data)
    if not data then return end

    if lastCategory ~= "Lazer" and data and data.Collection then
        local Hash = data.HashNameMale
        local dataTattoo = { Collection = data.Collection, Hash = Hash }

        for _, existingTattoo in ipairs(currentTattoos) do
            if existingTattoo.Collection == data.Collection and existingTattoo.Hash == Hash then
                return
            end
        end

        TriggerServerEvent("core:server:setTattoo", dataTattoo, data.Price)

        table.insert(currentTattoos, dataTattoo)
    elseif lastCategory == "Lazer" then
        if data and data and data.Collection then
            local Hash = data.HashNameMale

            for i, existingTattoo in ipairs(currentTattoos) do
                if existingTattoo.Collection == data.Collection and existingTattoo.Hash == Hash then
                    table.remove(currentTattoos, i)
                    TriggerServerEvent("core:server:removeTattoo", data.Collection, Hash)
                    break
                end
            end
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:enter", function(data)
    if not data then return end

    if lastCategory ~= "Lazer" and data and data.Collection then
        local Hash = data.HashNameMale
        local dataTattoo = { Collection = data.Collection, Hash = Hash }

        for _, existingTattoo in ipairs(currentTattoos) do
            if existingTattoo.Collection == data.Collection and existingTattoo.Hash == Hash then
                return
            end
        end

        TriggerServerEvent("core:server:setTattoo", dataTattoo, data.Price)

        table.insert(currentTattoos, dataTattoo)
    elseif lastCategory == "Lazer" then
        if data and data and data.Collection then
            local Hash = data.HashNameMale

            for i, existingTattoo in ipairs(currentTattoos) do
                if existingTattoo.Collection == data.Collection and existingTattoo.Hash == Hash then
                    table.remove(currentTattoos, i)
                    TriggerServerEvent("core:server:removeTattoo", data.Collection, Hash)
                    break
                end
            end
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:backspace", function()
    ClearPedDecorations(VFW.PlayerData.ped)

    local tattoos = TriggerServerCallback("core:server:getTattoo")

    for _, tattoo in pairs(tattoos) do
        ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(tattoo.Collection), GetHashKey(tattoo.Hash))
    end
    VFW.Cam:Update("cam_tattoo", cams[1])
    VFW.Nui.UpdateNewGrandMenu(TattooData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShopId:close", function()
    closeUI()

    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    ClearPedDecorations(VFW.PlayerData.ped)

    local tattoos = TriggerServerCallback("core:server:getTattoo")

    for _, tattoo in pairs(tattoos) do
        ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(tattoo.Collection), GetHashKey(tattoo.Hash))
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:TattooShop:close", function()
    closeUI()

    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    ClearPedDecorations(VFW.PlayerData.ped)

    local tattoos = TriggerServerCallback("core:server:getTattoo")

    for _, tattoo in pairs(tattoos) do
        ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(tattoo.Collection), GetHashKey(tattoo.Hash))
    end
end)

RegisterNetEvent("core:client:setTattoo", function(tattoos)
    ClearPedDecorations(VFW.PlayerData.ped)

    for _, tattoo in pairs(tattoos) do
        ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(tattoo.Collection), GetHashKey(tattoo.Hash))
    end
end)

AddEventHandler('skinchanger:modelLoaded', function()
    local tattoos = TriggerServerCallback("core:server:getTattoo")

    if tattoos then
        for _, v in pairs(tattoos) do
            ApplyPedOverlay(VFW.PlayerData.ped, GetHashKey(v.Collection), GetHashKey(v.Hash))
        end
    end
end)
