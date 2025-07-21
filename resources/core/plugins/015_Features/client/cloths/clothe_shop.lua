local componentClotheData = {}
local componentVarClotheData = {}
local drawableClothes = {
    torso2 = 11,
    undershirt = 8,
    torso = 3,
    leg = 4,
    shoes = 6,
    bag = 5,
    accessory = 7
}
local drawableProps = {
    glasses = 1,
    hat = 0
}
local lastCategory = nil
local lastType = "Id"
local sex = "Homme"
local sexType = "male"
local dataId = {
    torso2 = 0,
    undershirt = 0,
    torso = 0,
    leg = 0,
    shoes = 0,
    hat = -1,
    glasses = -1,
    bag = 0,
    accessory = 0,
}
local dataType = {
    torso2 = 1,
    undershirt = 1,
    torso = 1,
    leg = 1,
    shoes = 1,
    hat = 2,
    glasses = 2,
    bag = 2,
    accessory = 2,
}
local cams = nil
local componentOutfitClotheData = {}
local lastCategoryOutfit = nil
local indexCategory = 0
local lastJob = false

local function clothesPreData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 3,
            bannerType = 1,
            gridType = 2,
            buyType = 0,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = cams.Title or "BINCO",
        },
        eventName = "clothePreShop",
        showStats = false,
        mouseEvents = false,
        nameContainer = { show = false },
        headCategory = { show = false },
        category = { show = false },
        cameras = { show = false },
        color = { show = false },
        items = {
            {
                label = 'CATALOGUE',
                model = 'catalogue',
                image = "assets/catalogues/binco/catalogue.png",
                style = "big",
            },
            --{
            --    label = 'FAVORIS',
            --    model = 'Favoris',
            --    image = "assets/catalogues/binco/Favoris.png",
            --    style = "normal",
            --},
            {
                label = 'PRET A PORTER',
                model = 'Pret_a_porter',
                image = "assets/catalogues/binco/Pret_a_porter.png",
                style = "big",
            },
            {
                label = 'CREE UNE TENUE',
                model = 'Cree_une_tenue',
                image = "assets/catalogues/binco/Cree_une_tenue.png",
                style = "big",
            },
            --{
            --    label = 'RETRAIT',
            --    model = 'Retrait',
            --    image = "assets/catalogues/binco/Retrait.png",
            --    style = "normal",
            --},
        }
    }

    return data
end

local function clothesData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 2,
            buyType = 0,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = cams.Title or "BINCO",
        },
        eventName = "clotheShop",
        showStats = false,
        mouseEvents = false,
        nameContainer = { show = false },
        headCategory = { show = false },
        category = { show = false },
        cameras = { show = false },
        color = { show = false },
        items = {
            {
                label = 'HAUTS',
                model = 'torso2',
                image = "assets/catalogues/binco/" .. sex .. "/torso2.webp",
                style = "big",
            },
            {
                label = 'BAS',
                model = 'leg',
                image = "assets/catalogues/binco/" .. sex .. "/leg.webp",
                style = "normal",
            },
            {
                label = 'CHAUSSURES',
                model = 'shoes',
                image = "assets/catalogues/binco/" .. sex .. "/shoes.webp",
                style = "normal",
            },
            {
                label = 'CHAPEAUX',
                model = 'hat',
                image = "assets/catalogues/binco/" .. sex .. "/hat.webp",
                style = "semi",
            },
            {
                label = 'LUNETTES',
                model = 'glasses',
                image = "assets/catalogues/binco/" .. sex .. "/glasses.webp",
                style = "semi",
            },
            {
                label = 'SACS',
                model = 'bag',
                image = "assets/catalogues/binco/" .. sex .. "/bag.webp",
                style = "semi",
            },
            {
                label = 'COU',
                model = 'accessory',
                image = "assets/catalogues/binco/" .. sex .. "/accessory.webp",
                style = "semi",
            },
        }
    }

    return data
end

local function componentIdData(category)
    local playerPed = VFW.PlayerData.ped
    if not playerPed then return componentClotheData end

    local drawableType = drawableClothes[category] or drawableProps[category]
    if not drawableType then return componentClotheData end

    local getVariations = drawableClothes[category] and GetNumberOfPedDrawableVariations or GetNumberOfPedPropDrawableVariations
    componentClotheData[category] = {}

    local name

    if category == "torso2" or category == "undershirt" or category == "torso" then
        name = "top"
    elseif category == "leg" then
        name = "bottom"
    elseif category == "shoes" then
        name = "shoe"
    elseif category == "accessory" then
        name = "necklace"
    else
        name = category
    end

    table.insert(componentClotheData[category], {
        label = "Aucun",
        model = "aucun",
        premium = false,
        image = drawableClothes[category] and "outfits_greenscreener/" .. sexType .. "/clothing/" .. category .. "/aucun.png" or
        "outfits_greenscreener/" .. sexType .. "/props/" .. category .. "/aucun.png",
    })

    if not lastJob then
        local bans = Config.ClothesBan[sex] or {}
        local dataBans = {
            torso2 = bans.BanTop,
            undershirt = bans.BanSous,
            torso = bans.BanArm,
            leg = bans.BanLeg,
            shoes = bans.BanShoes,
            hat = bans.BanHat,
            glasses = bans.BanGlases,
            bag = bans.BanBag,
            accessory = bans.BanCou,
        }

        for i = 0, getVariations(playerPed, drawableType) - 1 do
            if not VFW.Table.TableContains(dataBans[category], i) then
                local tempCatalogue = {
                    label = i,
                    model = i,
                    price = VFW.Math.GroupDigits(Config.ClothesPrice[sex][name]),
                    premium = false,
                    image = drawableClothes[category] and "outfits_greenscreener/" .. sexType .. "/clothing/" .. category .. "/" .. i .. ".webp" or
                            "outfits_greenscreener/" .. sexType .. "/props/" .. category .. "/" .. i .. ".webp",
                }

                table.insert(componentClotheData[category], tempCatalogue)
            end
        end
    else
        local listClothe = Config.ClothesFaction[sex] or {}
        local datalistClothe = {
            torso2 = listClothe.Top,
            undershirt = listClothe.Sous,
            torso = listClothe.Arm,
            leg = listClothe.Leg,
            shoes = listClothe.Shoes,
            hat = listClothe.Hat,
            glasses = listClothe.Glases,
            bag = listClothe.Bag,
            accessory = listClothe.Cou,
        }

        for i = 0, getVariations(playerPed, drawableType) - 1 do
            if VFW.Table.TableContains(datalistClothe[category], i) then
                local tempCatalogue = {
                    label = i,
                    model = i,
                    price = VFW.Math.GroupDigits(Config.ClothesPrice[sex][name]),
                    premium = false,
                    image = drawableClothes[category] and "outfits_greenscreener/" .. sexType .. "/clothing/" .. category .. "/" .. i .. ".webp" or
                            "outfits_greenscreener/" .. sexType .. "/props/" .. category .. "/" .. i .. ".webp",
                }

                table.insert(componentClotheData[category], tempCatalogue)
            end
        end
    end

    return componentClotheData[category]
end

local function clothesComponentId(category, indexCategory)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_binco.webp",
            buyTextType = false,
            buyText = "Selectionner",
        },
        eventName = "clotheComponentShop",
        showStats = false,
        mouseEvents = true,
        nameContainer = { show = false },
        headCategory = { show = false, items = {} },
        color = { show = false },
        category = {
            show = true,
            defaultIndex = indexCategory,
            items = {
                {id = "accessory", label = "Cou", image = "assets/catalogues/binco/cravate.png"},
                {id = "glasses", label = "Lunettes", image = "assets/catalogues/binco/lunettes_1.png"},
                {id = "bag", label = "Sacs", image = "assets/catalogues/binco/sac_2.png"},
                {id = "hat", label = "Chapeaux", image = "assets/catalogues/binco/chapeau_6.png"},
                {id = "shoes", label = "Chaussures", image = "assets/catalogues/binco/chaussure_8.png"},
                {id = "leg", label = "Bas", image = "assets/catalogues/binco/bas_5.png"},
                {id = "torso2", label = "Hauts", image = "assets/catalogues/binco/haut_7.png"},
            }
        },
        cameras = { show = false },
        items = componentIdData(category)
    }

    if category == "torso2" or category == "undershirt" or category == "torso" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Hauts", id = "torso2" },
            { label = "Sous-Hauts", id = "undershirt" },
            { label = "Bras", id = "torso" },
        }
    elseif category == "accessory" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Cou", id = nil }
        }
    elseif category == "glasses" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Lunettes", id = nil }
        }
    elseif category == "bag" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Sacs", id = nil }
        }
    elseif category == "hat" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Chapeaux", id = nil }
        }
    elseif category == "shoes" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Chaussures", id = nil }
        }
    elseif category == "leg" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Bas", id = nil }
        }
    end

    return data
end

local function componentVarData(category)
    local playerPed = VFW.PlayerData.ped
    if not playerPed then return componentVarClotheData end

    local drawableType = drawableClothes[category] or drawableProps[category]
    if not drawableType then return componentVarClotheData end

    local getVariations = drawableClothes[category] and GetNumberOfPedTextureVariations or GetNumberOfPedPropTextureVariations
    componentVarClotheData[category] = {}

    local name

    if category == "torso2" or category == "undershirt" or category == "torso" then
        name = "top"
    elseif category == "leg" then
        name = "bottom"
    elseif category == "shoes" then
        name = "shoe"
    elseif category == "accessory" then
        name = "necklace"
    else
        name = category
    end

    for i = 0, getVariations(playerPed, drawableType, dataId[category]) - 1 do
        local imagePath

        if i ~= 0 then
            if drawableClothes[category] then
                imagePath = "outfits_greenscreener/" .. sexType .. "/clothing/" .. category .. "/" .. dataId[category] .. "_" .. i .. ".webp"
            else
                imagePath = "outfits_greenscreener/" .. sexType .. "/props/" .. category .. "/" .. dataId[category] .. "_" .. i .. ".webp"
            end
        else
            if drawableClothes[category] then
                imagePath = "outfits_greenscreener/" .. sexType .. "/clothing/" .. category .. "/" .. dataId[category] .. ".webp"
            else
                imagePath = "outfits_greenscreener/" .. sexType .. "/props/" .. category .. "/" .. dataId[category] .. ".webp"
            end
        end

        local tempCatalogue = {
            label = i,
            model = i,
            price = VFW.Math.GroupDigits(Config.ClothesPrice[sex][name]),
            premium = false,
            image = imagePath,
        }

        table.insert(componentVarClotheData[category], tempCatalogue)
    end

    return componentVarClotheData[category]
end

local function clothesComponentVar(category, indexCategory)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_binco.webp",
            buyTextType = false,
            buyText = "Acheter",
        },
        eventName = "clotheComponentShop",
        showStats = false,
        mouseEvents = true,
        nameContainer = { show = false },
        headCategory = { show = false },
        color = { show = false },
        category = {
            show = true,
            defaultIndex = indexCategory,
            items = {
                {id = "accessory", label = "Cou", image = "assets/catalogues/binco/cravate.png"},
                {id = "glasses", label = "Lunettes", image = "assets/catalogues/binco/lunettes_1.png"},
                {id = "bag", label = "Sacs", image = "assets/catalogues/binco/sac_2.png"},
                {id = "hat", label = "Chapeaux", image = "assets/catalogues/binco/chapeau_6.png"},
                {id = "shoes", label = "Chaussures", image = "assets/catalogues/binco/chaussure_8.png"},
                {id = "leg", label = "Bas", image = "assets/catalogues/binco/bas_5.png"},
                {id = "torso2", label = "Hauts", image = "assets/catalogues/binco/haut_7.png"},
            }
        },
        cameras = { show = false },
        items = componentVarData(category)
    }

    if category == "torso2" or category == "undershirt" or category == "torso" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Hauts", id = "torso2" },
            { label = "Sous-Hauts", id = "undershirt" },
            { label = "Bras", id = "torso" },
        }
    elseif category == "accessory" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Cou", id = nil }
        }
    elseif category == "glasses" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Lunettes", id = nil }
        }
    elseif category == "bag" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Sacs", id = nil }
        }
    elseif category == "hat" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Chapeaux", id = nil }
        }
    elseif category == "shoes" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Chaussures", id = nil }
        }
    elseif category == "leg" then
        data.headCategory.show = true
        data.headCategory.items = {
            { label = "Bas", id = nil }
        }
    end

    if category == "torso" then
        data.style.buyText = "Acheter"
    end

    return data
end

local function clothesOutfitData()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 2,
            buyType = 0,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = cams.Title or "BINCO",
        },
        eventName = "clotheOutfitShop",
        showStats = false,
        mouseEvents = false,
        nameContainer = { show = false },
        headCategory = { show = false },
        category = { show = false },
        cameras = { show = false },
        color = { show = false },
        items = {
            {
                label = 'METIERS',
                model = 'Metiers',
                image = "assets/catalogues/binco/Metiers.png",
                style = "normal",
            },
            {
                label = 'ACTIVITES',
                model = 'Activites',
                image = "assets/catalogues/binco/Activites.png",
                style = "normal",
            },
            {
                label = 'SPORTS',
                model = 'Sport',
                image = "assets/catalogues/binco/Sport.png",
                style = "normal",
            },
            {
                label = 'DECONTRACTES',
                model = 'Decontracte',
                image = "assets/catalogues/binco/Decontracte.png",
                style = "normal",
            },
            {
                label = 'CLASSES',
                model = 'Classe',
                image = "assets/catalogues/binco/Classe.png",
                style = "normal",
            },
            {
                label = 'GANGSTER',
                model = 'Gangster',
                image = "assets/catalogues/binco/Gangster.png",
                style = "normal",
            },
            {
                label = 'DEGUISEMENTS',
                model = 'Deguisements',
                image = "assets/catalogues/binco/Deguisements.png",
                style = "normal",
            },
        }
    }

    return data
end

local function componentOutfitData(category)
    local outfits = cloths_outfit[sex]
    if not outfits then return end
    local outfit = outfits[category]
    if not outfit then return end

    componentOutfitClotheData[category] = {}
    local image

    for k, v in ipairs(outfit) do
        if v.varHaut ~= 0 then
            image = "outfits_greenscreener/" .. sexType .. "/clothing/torso2/" .. v.haut .. "_".. v.varHaut..".webp"
        else
            image = "outfits_greenscreener/" .. sexType .. "/clothing/torso2/" .. v.haut .. ".webp"
        end

        local tempCatalogue = {
            label = v.name,
            model = v.id,
            price = VFW.Math.GroupDigits(Config.ClothesPrice[sex]["Creé une tenue"]),
            premium = false,
            image = image
        }

        table.insert(componentOutfitClotheData[category], tempCatalogue)
    end

    return componentOutfitClotheData[category]
end

local function clothesComponentOutfit(category)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_binco.webp",
            buyTextType = false,
            buyText = "Acheter"
        },
        eventName = "clotheComponentOutfitShop",
        showStats = false,
        mouseEvents = true,
        color = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false, items = {} },
        category = { show = false },
        cameras = { show = false },
        items = componentOutfitData(category)
    }
    return data
end

local function getOutfit()
    local outfitCatalog = {}

    TriggerEvent('skinchanger:getSkin', function(skin)
        local dataSkin = {
            torso2 = { skin.torso_1, skin.torso_2, skin.tshirt_1, skin.tshirt_2, skin.arms },
            leg = { skin.pants_1, skin.pants_2 },
            shoes = { skin.shoes_1, skin.shoes_2 },
            hat = { skin.helmet_1, skin.helmet_2 },
            glasses = { skin.glasses_1, skin.glasses_2 },
            bag = { skin.bags_1, skin.bags_2 },
            accessory = { skin.chain_1, skin.chain_2 }
        }

        for k, v in pairs(dataSkin) do
            if dataType[k] then
                if (k == "hat" or k == "glasses" or k == "bag" or k == "accessory") then
                    if (v[1] == 0 or v[1] == -1) then
                        console.debug("^3[INFO] Ignoré : " .. k .. " (index1: " .. v[1] .. ")^7")
                        goto continue
                    end
                end

                local index1 = v[1] or 0
                local index2 = v[2] and v[2] ~= 0 and ("_" .. v[2]) or ""
                local isProp = (k == "glasses" or k == "hat")
                local category = isProp and "props" or "clothing"
                local imagePath = "outfits_greenscreener/" .. sexType .. "/" .. category .. "/" .. k .. "/" .. index1 .. index2 .. ".webp"

                table.insert(outfitCatalog, {
                    label = "",
                    model = k,
                    image = imagePath,
                    type = dataType[k]
                })

                ::continue::
            end
        end
    end)

    return outfitCatalog
end

local function createOutfit()
    local data = {
        style = {
            menuStyle = "tenue",
            backgroundType = 1,
            bannerType = 1,
            gridType = 1,
            buyType = 1,
            lineColor = "linear-gradient(to right, rgba(139, 106, 34, .6) 0%, rgba(234, 215, 148, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = cams.Title or "BINCO",
            buyTextType = false,
            buyText = "Premium"
        },
        eventName = "createOutfit",
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false, items = {} },
        category = { show = false },
        cameras = { show = false },
        items = getOutfit()
    }

    if VFW.PlayerGlobalData.permissions["premium"] or VFW.PlayerGlobalData.permissions["premiumplus"] then
        data.style.buyText = "Acheter"
    end

    return data
end

function LoadPreBinco(data, job)
    cams = data
    lastJob = job

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 1 then
            sex = "Femme"
            sexType = "female"
        elseif skin.sex > 1 then
            sexType = "ped"
        end
    end)

    VFW.Cam:Create('cam_binco', cams[1])

    cEntity.Visual.HideAllEntities(true)
    cEntity.Visual.AddEntityToException(VFW.PlayerData.ped)
    cEntity.Visual.DisablePlayerCollisions(true)

    VFW.Nui.NewGrandMenu(true, clothesPreData())
end

local function closeUI()
    lastCategory = nil
    lastType = "Id"
    dataId = {
        torso2 = 0,
        undershirt = 0,
        torso = 0,
        leg = 0,
        shoes = 0,
        hat = -1,
        glasses = -1,
        bag = 0,
        accessory = 0,
    }
    sex = "Homme"
    sexType = "male"
    cams = nil
    lastCategoryOutfit = nil
    indexCategory = 0
    VFW.Nui.NewGrandMenu(false)
    cEntity.Visual.HideAllEntities(false)
    cEntity.Visual.DisablePlayerCollisions(false)
    VFW.Cam:Destroy('cam_binco')
end

RegisterNuiCallback("nui:newgrandcatalogue:clothePreShop:selectGridType2", function(data)
    if data == "catalogue" then
        VFW.Cam:Update('cam_binco', cams[1])
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(clothesData())
    elseif data == "Pret_a_porter" then
        VFW.Cam:Update('cam_binco', cams[6])
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(clothesOutfitData())
    elseif data == "Cree_une_tenue" then
        VFW.Cam:Update('cam_binco', cams[6])
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(createOutfit())
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheShop:selectGridType2", function(data)
    lastCategory = data
    if lastCategory == "torso2" or lastCategory == "bag" or lastCategory == "accessory" then
        VFW.Cam:Update('cam_binco', cams[2])
        if lastCategory == "torso2" or lastCategory == "undershirt" or lastCategory == "torso" then
            indexCategory = 6
        elseif lastCategory == "bag" then
            indexCategory = 2
        elseif lastCategory == "accessory" then
            indexCategory = 0
        end
    elseif lastCategory == "leg" then
        VFW.Cam:Update('cam_binco', cams[3])
        indexCategory = 5
    elseif lastCategory == "shoes" then
        VFW.Cam:Update('cam_binco', cams[5])
        indexCategory = 4
    elseif lastCategory == "hat" or lastCategory == "glasses" then
        VFW.Cam:Update('cam_binco', cams[4])
        indexCategory = 3
    end

    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(clothesComponentId(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:selectGridType", function(data)
    if lastCategory == "torso2" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "torso_1", 15)
            TriggerEvent("skinchanger:change", "torso_2", 0)
            TriggerEvent("skinchanger:change", "tshirt_1", sex == "Femme" and 14 or 15)
            TriggerEvent("skinchanger:change", "tshirt_2", 0)
            TriggerEvent("skinchanger:change", "arms", 15)
            TriggerEvent("skinchanger:change", "arms_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "torso_1", data)
                TriggerEvent("skinchanger:change", "torso_2", 0)
                dataId.torso2 = data
                if Config.ClothsList[sex]["Haut"][tostring(data)] then
                    TriggerEvent("skinchanger:change", "arms", Config.ClothsList[sex]["Haut"][tostring(data)])
                    TriggerEvent("skinchanger:change", "arms_2", 0)
                end
                if sex == "Homme" then
                    TriggerEvent("skinchanger:change", "tshirt_1", 15)
                    TriggerEvent("skinchanger:change", "tshirt_2", 0)
                else
                    TriggerEvent("skinchanger:change", "tshirt_1", 14)
                    TriggerEvent("skinchanger:change", "tshirt_2", 0)
                end
            else
                TriggerEvent("skinchanger:change", "torso_1", dataId.torso2)
                TriggerEvent("skinchanger:change", "torso_2", data)
            end
        end
    elseif lastCategory == "undershirt" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "tshirt_1", sex == "Femme" and 14 or 15)
            TriggerEvent("skinchanger:change", "tshirt_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "tshirt_1", data)
                TriggerEvent("skinchanger:change", "tshirt_2", 0)
                dataId.undershirt = data
            else
                TriggerEvent("skinchanger:change", "tshirt_1", dataId.undershirt)
                TriggerEvent("skinchanger:change", "tshirt_2", data)
            end
        end
    elseif lastCategory == "torso" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "arms", 15)
            TriggerEvent("skinchanger:change", "arms_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "arms", data)
                TriggerEvent("skinchanger:change", "arms_2", 0)
                dataId.torso = data
            else
                TriggerEvent("skinchanger:change", "arms", dataId.torso)
                TriggerEvent("skinchanger:change", "arms_2", data)
            end
        end
    elseif lastCategory == "leg" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "pants_1", 15)
            TriggerEvent("skinchanger:change", "pants_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "pants_1", data)
                TriggerEvent("skinchanger:change", "pants_2", 0)
                dataId.leg = data
            else
                TriggerEvent("skinchanger:change", "pants_1", dataId.leg)
                TriggerEvent("skinchanger:change", "pants_2", data)
            end
        end
    elseif lastCategory == "shoes" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "shoes_1", sex == "Femme" and 35 or 34)
            TriggerEvent("skinchanger:change", "shoes_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "shoes_1", data)
                TriggerEvent("skinchanger:change", "shoes_2", 0)
                dataId.shoes = data
            else
                TriggerEvent("skinchanger:change", "shoes_1", dataId.shoes)
                TriggerEvent("skinchanger:change", "shoes_2", data)
            end
        end
    elseif lastCategory == "hat" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "helmet_1", -1)
            TriggerEvent("skinchanger:change", "helmet_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "helmet_1", data)
                TriggerEvent("skinchanger:change", "helmet_2", 0)
                dataId.hat = data
            else
                TriggerEvent("skinchanger:change", "helmet_1", dataId.hat)
                TriggerEvent("skinchanger:change", "helmet_2", data)
            end
        end
    elseif lastCategory == "glasses" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "glasses_1", -1)
            TriggerEvent("skinchanger:change", "glasses_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "glasses_1", data)
                TriggerEvent("skinchanger:change", "glasses_2", 0)
                dataId.glasses = data
            else
                TriggerEvent("skinchanger:change", "glasses_1", dataId.glasses)
                TriggerEvent("skinchanger:change", "glasses_2", data)
            end
        end
    elseif lastCategory == "bag" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "bags_1", 0)
            TriggerEvent("skinchanger:change", "bags_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "bags_1", data)
                TriggerEvent("skinchanger:change", "bags_2", 0)
                dataId.bag = data
            else
                TriggerEvent("skinchanger:change", "bags_1", dataId.bag)
                TriggerEvent("skinchanger:change", "bags_2", data)
            end
        end
    elseif lastCategory == "accessory" then
        if data == "aucun" then
            TriggerEvent("skinchanger:change", "chain_1", 0)
            TriggerEvent("skinchanger:change", "chain_2", 0)
        else
            if lastType == "Id" then
                TriggerEvent("skinchanger:change", "chain_1", data)
                TriggerEvent("skinchanger:change", "chain_2", 0)
                dataId.accessory = data
            else
                TriggerEvent("skinchanger:change", "chain_1", dataId.accessory)
                TriggerEvent("skinchanger:change", "chain_2", data)
            end
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:selectHeadCategory", function(data)
    if data == nil then return end
    lastCategory = data
    lastType = "Id"
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(clothesComponentId(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:selectBuy", function(data)
    if lastType == "Id" then
        lastType = "Variantions"
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(clothesComponentVar(lastCategory, indexCategory))
    else
        TriggerEvent('skinchanger:getSkin', function(skin)
            if lastCategory == "torso2" or lastCategory == "undershirt" or lastCategory == "torso" then
                TriggerServerEvent("core:server:buyClothe", "top", {
                    renamed = skin.torso_1,
                    sex = skin.sex == 1 and "w" or "m",
                    skin = {
                        ["tshirt_1"] = skin.tshirt_1,
                        ["tshirt_2"] = skin.tshirt_2,
                        ["torso_1"] = skin.torso_1,
                        ["torso_2"] = skin.torso_2,
                        ["arms"] = skin.arms,
                        ["arms_2"] = skin.arms_2,
                    }
                })
                EmoteCancel()
                Wait(100)
                EmoteCommandStart("tryclothes2")
            elseif lastCategory == "glasses" or lastCategory == "hat" or lastCategory == "bag" then
                if lastCategory == "glasses" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.glasses_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.glasses_1,
                        var = skin.glasses_2
                    })
                elseif lastCategory == "hat" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.helmet_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.helmet_1,
                        var = skin.helmet_2
                    })
                elseif lastCategory == "bag" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.bags_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.bags_1,
                        var = skin.bags_2
                    })
                end
            else
                if lastCategory == "leg" then
                    TriggerServerEvent("core:server:buyClothe", "bottom", {
                        renamed = skin.pants_1,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.pants_1,
                        var = skin.pants_2
                    })
                    EmoteCancel()
                    Wait(100)
                    EmoteCommandStart("tryclothes")
                elseif lastCategory == "shoes" then
                    TriggerServerEvent("core:server:buyClothe", "shoe", {
                        renamed = skin.shoes_1,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.shoes_1,
                        var = skin.shoes_2
                    })
                    EmoteCancel()
                    Wait(100)
                    EmoteCommandStart("tryclothes3")
                elseif lastCategory == "accessory" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.chain_1,
                        type = "necklace",
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.chain_1,
                        var = skin.chain_2
                    })
                end
            end
        end)

        lastType = "Id"
        VFW.Nui.UpdateNewGrandMenu(clothesComponentId(lastCategory))
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:mouseEvents", function(data)
    SetEntityHeading(VFW.PlayerData.ped, GetEntityHeading(VFW.PlayerData.ped) + (0.5 * data.x))
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:enter", function(data)
    if lastType == "Id" then
        lastType = "Variantions"
        Wait(50)
        VFW.Nui.UpdateNewGrandMenu(clothesComponentVar(lastCategory, indexCategory))
    else
        TriggerEvent('skinchanger:getSkin', function(skin)
            if lastCategory == "torso2" or lastCategory == "undershirt" or lastCategory == "torso" then
                TriggerServerEvent("core:server:buyClothe", "top", {
                    renamed = skin.torso_1,
                    sex = skin.sex == 1 and "w" or "m",
                    skin = {
                        ["tshirt_1"] = skin.tshirt_1,
                        ["tshirt_2"] = skin.tshirt_2,
                        ["torso_1"] = skin.torso_1,
                        ["torso_2"] = skin.torso_2,
                        ["arms"] = skin.arms,
                        ["arms_2"] = skin.arms_2,
                    }
                })
                EmoteCancel()
                Wait(100)
                EmoteCommandStart("tryclothes2")
            elseif lastCategory == "glasses" or lastCategory == "hat" or lastCategory == "bag" then
                if lastCategory == "glasses" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.glasses_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.glasses_1,
                        var = skin.glasses_2
                    })
                elseif lastCategory == "hat" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.helmet_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.helmet_1,
                        var = skin.helmet_2
                    })
                elseif lastCategory == "bag" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.bags_1,
                        type = lastCategory,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.bags_1,
                        var = skin.bags_2
                    })
                end
            else
                if lastCategory == "leg" then
                    TriggerServerEvent("core:server:buyClothe", "bottom", {
                        renamed = skin.pants_1,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.pants_1,
                        var = skin.pants_2
                    })
                    EmoteCancel()
                    Wait(100)
                    EmoteCommandStart("tryclothes")
                elseif lastCategory == "shoes" then
                    TriggerServerEvent("core:server:buyClothe", "shoe", {
                        renamed = skin.shoes_1,
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.shoes_1,
                        var = skin.shoes_2
                    })
                    EmoteCancel()
                    Wait(100)
                    EmoteCommandStart("tryclothes3")
                elseif lastCategory == "accessory" then
                    TriggerServerEvent("core:server:buyClothe", "accessory", {
                        renamed = skin.chain_1,
                        type = "necklace",
                        sex = skin.sex == 1 and "w" or "m",
                        id = skin.chain_1,
                        var = skin.chain_2
                    })
                end
            end
        end)

        lastType = "Id"
        VFW.Nui.UpdateNewGrandMenu(clothesComponentId(lastCategory))
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentShop:selectCategory", function(data)
    lastCategory = data
    lastType = "Id"
    if lastCategory == "torso2" or lastCategory == "bag" or lastCategory == "accessory" then
        VFW.Cam:Update('cam_binco', cams[2])
        if lastCategory == "torso2" or lastCategory == "undershirt" or lastCategory == "torso" then
            indexCategory = 6
        elseif lastCategory == "bag" then
            indexCategory = 2
        elseif lastCategory == "accessory" then
            indexCategory = 0
        end
    elseif lastCategory == "leg" then
        VFW.Cam:Update('cam_binco', cams[3])
        indexCategory = 5
    elseif lastCategory == "shoes" then
        VFW.Cam:Update('cam_binco', cams[5])
        indexCategory = 4
    elseif lastCategory == "hat" or lastCategory == "glasses" then
        VFW.Cam:Update('cam_binco', cams[4])
        indexCategory = 3
    end
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(clothesComponentId(lastCategory, indexCategory))
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheOutfitShop:selectGridType2", function(data)
    lastCategoryOutfit = data
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(clothesComponentOutfit(lastCategoryOutfit))
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentOutfitShop:selectGridType", function(data)
    local outfits = cloths_outfit[sex][lastCategoryOutfit]
    if not outfits then return end

    for _, v in ipairs(outfits) do
        if v.id == data then
            TriggerEvent('skinchanger:change', "shoes_1", v.chaussures)
            TriggerEvent('skinchanger:change', "shoes_2", v.varChaussures)
            TriggerEvent('skinchanger:change', "bags_1", v.sac)
            TriggerEvent('skinchanger:change', "bags_2", v.varSac)
            TriggerEvent('skinchanger:change', "decals_1", v.decals)
            TriggerEvent('skinchanger:change', "decals_2", v.varDecals)
            TriggerEvent('skinchanger:change', "pants_1", v.pantalon)
            TriggerEvent('skinchanger:change', "pants_2", v.varPantalon)
            TriggerEvent('skinchanger:change', "chain_1", v.chaine)
            TriggerEvent('skinchanger:change', "chain_2", v.varChaine)
            TriggerEvent('skinchanger:change', "torso_1", v.haut)
            TriggerEvent('skinchanger:change', "torso_2", v.varHaut)
            TriggerEvent('skinchanger:change', "tshirt_1", v.sousHaut)
            TriggerEvent('skinchanger:change', "tshirt_2", v.varSousHaut)
            TriggerEvent('skinchanger:change', "mask_1", v.mask)
            TriggerEvent('skinchanger:change', "mask_2", v.varMask)
            if v.gpb ~= 0 then
                TriggerEvent('skinchanger:change', "bproof_1", v.gpb)
                TriggerEvent('skinchanger:change', "bproof_2", v.varGpb)
            else
                TriggerEvent('skinchanger:change', "bproof_1", 0)
                TriggerEvent('skinchanger:change', "bproof_2", 0)
            end
            TriggerEvent('skinchanger:change', "arms", v.bras)
            TriggerEvent('skinchanger:change', "arms_2", v.varBras)
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentOutfitShop:selectBuy", function(data)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent("core:server:buyOutfit", {
            renamed = data or "Tenue",
            sex = skin.sex == 1 and "w" or "m",
            image = "",
            skin = {
                ["tshirt_1"] = skin.tshirt_1,
                ["tshirt_2"] = skin.tshirt_2,
                ["torso_1"] = skin.torso_1,
                ["torso_2"] = skin.torso_2,
                ["arms"] = skin.arms,
                ["arms_2"] = skin.arms_2,
                ["pants_1"] = skin.pants_1,
                ["pants_2"] = skin.pants_2,
                ["shoes_1"] = skin.shoes_1,
                ["shoes_2"] = skin.shoes_2,
                ["helmet1"] = skin.helmet1,
                ["helmet2"] = skin.helmet2,
                ["bags_1"] = skin.bags_1,
                ["bags_2"] = skin.bags_2,
                ["decals_1"] = skin.decals_1,
                ["decals_2"] = skin.decals_2,
                ["chain_1"] = skin.chain_1,
                ["chain_2"] = skin.chain_2,
                ["mask_1"] = skin.mask_1,
                ["mask_2"] = skin.mask_2,
                ["bproof_1"] = skin.bproof_1,
                ["bproof_2"] = skin.bproof_2
            }
        })
    end)
end)

RegisterNuiCallback("nui:newgrandcatalogue:createOutfit:selectBuy", function(data)
    if VFW.PlayerGlobalData.permissions["premium"] or VFW.PlayerGlobalData.permissions["premiumplus"] then
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent("core:server:buyOutfit", {
                renamed = data or "Tenue",
                sex = skin.sex == 1 and "w" or "m",
                image = "",
                skin = {
                    ["tshirt_1"] = skin.tshirt_1,
                    ["tshirt_2"] = skin.tshirt_2,
                    ["torso_1"] = skin.torso_1,
                    ["torso_2"] = skin.torso_2,
                    ["decals_1"] = skin.decals_1,
                    ["decals_2"] = skin.decals_2,
                    ["arms"] = skin.arms,
                    ["arms_2"] = skin.arms_2,
                    ["pants_1"] = skin.pants_1,
                    ["pants_2"] = skin.pants_2,
                    ["shoes_1"] = skin.shoes_1,
                    ["shoes_2"] = skin.shoes_2,
                    ["helmet1"] = skin.helmet1,
                    ["helmet2"] = skin.helmet2,
                    ["bags_1"] = skin.bags_1,
                    ["bags_2"] = skin.bags_2,
                    ["chain_1"] = skin.chain_1,
                    ["chain_2"] = skin.chain_2
                }
            })
        end)
        
        closeUI()
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:clotheComponentOutfitShop:mouseEvents", function(data)
    SetEntityHeading(VFW.PlayerData.ped, GetEntityHeading(VFW.PlayerData.ped) + (0.5 * data.x))
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheShop:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Nui.UpdateNewGrandMenu(clothesPreData())
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheComponentShop:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    lastType = "Id"
    VFW.Nui.UpdateNewGrandMenu(clothesData())
    EmoteCancel()
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheOutfitShop:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Nui.UpdateNewGrandMenu(clothesPreData())
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheComponentOutfitShop:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Nui.UpdateNewGrandMenu(clothesOutfitData())
end)

RegisterNUICallback("nui:newgrandcatalogue:createOutfit:backspace", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    VFW.Nui.UpdateNewGrandMenu(clothesPreData())
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheComponentShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheOutfitShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNUICallback("nui:newgrandcatalogue:clotheComponentOutfitShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNUICallback("nui:newgrandcatalogue:createOutfit:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNUICallback("nui:newgrandcatalogue:clothePreShop:close", function()
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', skin or {})
    closeUI()
end)

RegisterNetEvent("core:client:resetSkin", function(skin)
    TriggerEvent('skinchanger:loadSkin', skin or {})
end)
