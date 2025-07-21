local typeSex = "male"
local sex = "Homme"
local cams = nil
local componentIdData = nil
local componentVarData = nil
local dataId = nil

local function getComponentId()
    local playerPed = VFW.PlayerData.ped
    local bans = Config.ClothesBan[sex] or {}
    componentIdData = {}

    table.insert(componentIdData, {
        label = "Aucun",
        model = "aucun",
        premium = false,
        image = "outfits_greenscreener/aucun.png"
    })

    for i = 1, GetNumberOfPedDrawableVariations(playerPed, 1) - 1 do
        if not VFW.Table.TableContains(bans.BanMasque, i) then
            local tempCatalogue = {
                label = i,
                model = i,
                premium = false,
                price = VFW.Math.GroupDigits(Config.ClothesPrice[sex]["mask"] or 0),
                image = "outfits_greenscreener/"..typeSex.."/clothing/mask/"..i..".webp"
            }

            table.insert(componentIdData, tempCatalogue)
        end
    end

    return componentIdData
end

local function getComponentIdData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_mask.png",
            buyTextType = false,
            buyText = "Selectionner",
        },
        eventName = "masqueId",
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        color = { show = false },
        showStats = false,
        mouseEvents = false,
        items = getComponentId()
    }

    return data
end

local function getComponentVar()
    local playerPed = VFW.PlayerData.ped
    componentVarData = {}
    local image

    for i = 0, GetNumberOfPedTextureVariations(playerPed, 1, dataId) - 1 do
        if i ~= 0 then
            image = "outfits_greenscreener/"..typeSex.."/clothing/mask/"..dataId.."_"..i..".webp"
        else
            image = "outfits_greenscreener/"..typeSex.."/clothing/mask/"..dataId..".webp"
        end

        local tempCatalogue = {
            label = i,
            model = i,
            premium = false,
            price = VFW.Math.GroupDigits(Config.ClothesPrice[sex]["mask"] or 0),
            image = image
        }

        table.insert(componentVarData, tempCatalogue)
    end

    return componentVarData
end

local function getComponentVarData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_mask.png",
            buyTextType = false,
            buyText = "Acheter",
        },
        eventName = "masqueVar",
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        items = getComponentVar()
    }

    return data
end

function LoadMask(data)
    cams = data

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 1 then
            typeSex = "female"
            sex = "Femme"
        end
    end)

    cEntity.Visual.HideAllEntities(true)
    cEntity.Visual.AddEntityToException(VFW.PlayerData.ped)
    cEntity.Visual.DisablePlayerCollisions(true)

    VFW.Cam:Create('cam_masque', data[1])

    VFW.Nui.NewGrandMenu(true, getComponentIdData())
end

local function closeUI()
    typeSex = "male"
    sex = "Homme"
    cams = nil
    componentIdData = nil
    componentVarData = nil
    dataId = nil
    cEntity.Visual.HideAllEntities(false)
    VFW.Cam:Destroy('cam_masque')
    VFW.Nui.NewGrandMenu(false)
    cEntity.Visual.DisablePlayerCollisions(false)
end

RegisterNuiCallback("nui:newgrandcatalogue:masqueId:selectGridType", function(data)
    if not data then return end
    if data == "aucun" then
        TriggerEvent("skinchanger:change", "mask_1", 0)
        TriggerEvent("skinchanger:change", "mask_2", 0)
    else
        TriggerEvent("skinchanger:change", "mask_1", data)
        TriggerEvent("skinchanger:change", "mask_2", 0)
        dataId = data
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueVar:selectGridType", function(data)
    if not data then return end
    TriggerEvent("skinchanger:change", "mask_1", dataId)
    TriggerEvent("skinchanger:change", "mask_2", data)
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueId:selectBuy", function()
    if not dataId then return end
    VFW.Nui.UpdateNewGrandMenu(getComponentVarData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueId:enter", function()
    if not dataId then return end
    VFW.Nui.UpdateNewGrandMenu(getComponentVarData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueVar:selectBuy", function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent("core:server:buyClothe", "accessory", {
            renamed = skin.mask_1,
            type = "mask",
            sex = skin.sex == 1 and "w" or "m",
            id = skin.mask_1,
            var = skin.mask_2
        })
    end)

    VFW.Nui.UpdateNewGrandMenu(getComponentIdData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueVar:enter", function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent("core:server:buyClothe", "accessory", {
            renamed = skin.mask_1,
            type = "mask",
            sex = skin.sex == 1 and "w" or "m",
            id = skin.mask_1,
            var = skin.mask_2
        })
    end)

    VFW.Nui.UpdateNewGrandMenu(getComponentIdData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueVar:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Nui.UpdateNewGrandMenu(getComponentIdData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:masqueId:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)
