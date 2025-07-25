local creaPersoData = {
    catalogue = {},
    peds = {},
    pedsVariantes = {},
    recoverableCharacters = {}
}

local temporaryDatas = {
    playerType = "Homme",
    playerSex = "male"
}

local TypePed, lastName, firstName, dateOfBirthdayr, birthplace = nil, nil, nil, nil, nil, nil
local newP1, newP2, lastSkinValue, lastlookingValue = nil, nil, nil, nil 
local lastnoseX, lastnoseY = nil, nil 
local lastnosePointeX, lastnosePointeY = nil, nil
local lastnoseProfileX, lastnoseProfileY = nil, nil
local lastSourcilsX, lastSourcilsY = nil, nil
local lastpommettesX, lastpommettesY = nil, nil
local lastMentonX, lastMentonY = nil, nil
local lastMentonShapeX, lastMentonShapeY = nil, nil
local lastMachoireX, lastMachoireY = nil, nil
local lastCou, lastlevres, lastjoues, lastyeux = nil, nil, nil, nil
local oldHair, oldColor1, oldColor2 = nil,nil,nil
local oldBeard, oldColorbeard1, oldColorbeard2 = nil, nil, nil
local oldsourcils, oldColorsourcils1, oldColorsourcils2, oldColorsourcils3 = nil, nil, nil, nil
local oldpilosite, oldColorpilosite1, oldColorpilosite3 = nil, nil, nil
local ColorEyes = nil
local oldeyesmaquillage, oldColoreyesmaquillage1, oldColoreyesmaquillage2, oldColoreyesmaquillage3 = nil, nil, nil, nil
local oldfard, oldColorfard1, oldColorfard3 = nil, nil, nil 
local oldrougealevre, oldColorrougealevre1, oldColorrougealevre3 = nil, nil, nil
local oldOpacityTache, oldtaches  = nil, nil
local oldmarques, oldOpacityMarque = nil, nil
local oldacne, oldOpacityAcne = nil , nil
local oldteint, oldOpacityTeint = nil,nil 
local oldcicatrice, oldOpacityCicatrice = nil, nil
local oldrousseur, oldOpacityrousseur = nil, nil
local newPed, sexPed = nil, nil
local lastTattoos = {}
local lastOnglet = nil

local function LoadFaceFeatures()
    local playerPed = PlayerPedId()
    local baseURL = "https://cdn.eltrane.cloud/3838384859/"
    local playerType = temporaryDatas.playerType

    local function AddToCatalogue(id, labelPrefix, imgPath, category)
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {
            id = id,
            label = labelPrefix .. " N°" .. id,
            img = baseURL .. imgPath .. id .. ".webp",
            category = category,
        }
    end

    local function AddDefaultToCatalogue(id, category)
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {
            id = id,
            label = "Aucun",
            img = "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png",
            category = category,
        }
    end

    AddDefaultToCatalogue(0, "hair")
    for i = 1, GetNumberOfPedDrawableVariations(playerPed, 2) - 1 do
        if not VFW.Table.TableContains(Config.BarberBan[playerType].CoupesBan, i) then
            AddToCatalogue(i, "Coiffure", "assets/catalogues/barber/" .. playerType .. "/Coupes/", "hair")
        end
    end

    if playerType == "Homme" then
        AddDefaultToCatalogue(0, "beard")
        for i = 1, GetNumHeadOverlayValues(1)  do
            AddToCatalogue(i, "Barbe", "assets/catalogues/barber/" .. playerType .. "/Barbes/", "beard")
        end
    
        AddDefaultToCatalogue(-1, "pilosite")
        for i = 0, GetPedHeadOverlayNum(10)  do
            AddToCatalogue(i, "Pilosité", "assets/catalogues/shenails/" .. playerType .. "/PilositeTorse/", "pilosite")
        end

        AddDefaultToCatalogue(-1, "eyesmaquillage")
        for i = 0, GetPedHeadOverlayNum(4)  do
            AddToCatalogue(i, "Maquillage", "assets/catalogues/shenails/" .. playerType .. "/Maquillage/", "eyesmaquillage")
        end

        AddDefaultToCatalogue(-1, "rougealevre")
        for i = 0, GetPedHeadOverlayNum(8)  do
            AddToCatalogue(i, "Rouge à levres", "assets/catalogues/shenails/" .. playerType .. "/RougeLevre/", "rougealevre")
        end

        AddDefaultToCatalogue(-1, "sourcils")
        for i = 0, GetPedHeadOverlayNum(2)  do
            AddToCatalogue(i, "Sourcils", "assets/catalogues/shenails/" .. playerType .. "/Sourcils/", "sourcils")
        end
    end

    if playerType == "Femme" then
        AddDefaultToCatalogue(-1, "eye_makeup")
        for i = 0, GetPedHeadOverlayNum(4)  do
            AddToCatalogue(i, "Maquillage", "assets/catalogues/shenails/" .. playerType .. "/Maquillage/", "eye_makeup")
        end

        AddDefaultToCatalogue(-1, "lips_makeup")
        for i = 0, GetPedHeadOverlayNum(8)  do
            AddToCatalogue(i, "Rouge à levres", "assets/catalogues/shenails/" .. playerType .. "/RougeLevre/", "lips_makeup")
        end

        AddDefaultToCatalogue(-1, "eyebrows")
        for i = 0, GetPedHeadOverlayNum(2)  do
            AddToCatalogue(i, "Sourcils", "assets/catalogues/shenails/" .. playerType .. "/Sourcils/", "eyebrows")
        end
    end

    AddDefaultToCatalogue(-1, "fard")
    for i = 0, GetPedHeadOverlayNum(5)  do
        AddToCatalogue(i, "Fard à joue", "assets/catalogues/shenails/" .. playerType .. "/Blush/", "fard")
    end

    AddDefaultToCatalogue(-1, "taches")
    for i = 1, GetPedHeadOverlayNum(11)  do
        AddToCatalogue(i, "Tâche cutanée", "assets/catalogues/crea-perso/" .. playerType .. "/TacheCutanee/", "taches")
    end

    AddDefaultToCatalogue(-1, "marques")
    for i = 0, GetPedHeadOverlayNum(3)  do
        AddToCatalogue(i, "Marque de la peau", "assets/catalogues/crea-perso/" .. playerType .. "/MarquePeau/", "marques")
    end

    AddDefaultToCatalogue(-1, "acne")
    for i = 0, 24  do
        AddToCatalogue(i, "Acné", "assets/catalogues/crea-perso/" .. playerType .. "/Acne/", "acne")
    end

    AddDefaultToCatalogue(-1, "teint")
    for i = 0, GetPedHeadOverlayNum(6)  do
        AddToCatalogue(i, "Teint", "assets/catalogues/crea-perso/" .. playerType .. "/Teint/", "teint")
    end

    AddDefaultToCatalogue(-1, "cicatrice")
    for i = 0, GetPedHeadOverlayNum(7)  do
        AddToCatalogue(i, "Cicatrice", "assets/catalogues/crea-perso/" .. playerType .. "/Cicatrice/", "cicatrice")
    end

    AddDefaultToCatalogue(-1, "rousseur")
    for i = 0, GetNumHeadOverlayValues(9) do
        AddToCatalogue(i, "Tâche de rousseu", "assets/catalogues/crea-perso/" .. playerType .. "/Rousseur/", "rousseur")
    end
end

local function LoadPedsFeatures()
    local pedsMale = Config.PedsJustForCrea.homme
    local pedsFemale = Config.PedsJustForCrea.femme

    for i = 1, #pedsMale do
        local v = pedsMale[i]
        if IsModelInCdimage(joaat(v)) then
            creaPersoData.peds[#creaPersoData.peds + 1] = {
                category = 'man',
                label = v,
                id = i
            }
        end
    end

    for i = 1, #pedsFemale do
        local v = pedsFemale[i]
        if IsModelInCdimage(joaat(v)) then
            creaPersoData.peds[#creaPersoData.peds + 1] = {
                category = 'woman',
                label = v,
                id = #pedsMale + i
            }
        end
    end
end

local function LoadButtonsCreaPerso()
    local baseURL = 'https://cdn.eltrane.cloud/3838384859/assets/catalogues/binco/'
    local defaultType = temporaryDatas.playerType

    local function CreateButton(name, width, imagePath, price, progressBar)
        return {
            name = name,
            width = width,
            image = imagePath,
            type = 'coverBackground',
            hoverStyle = 'fill-black stroke-black',
            price = price,
            progressBar = progressBar
        }
    end

    local images = {
        Hauts = baseURL .. defaultType .. '/torso2.webp',
        Bas = baseURL .. defaultType .. '/leg.webp',
        Chaussures = baseURL .. defaultType .. '/shoes.webp',
        Chapeaux = baseURL .. defaultType .. '/hat.webp',
        Lunettes = baseURL .. defaultType .. '/glasses.webp',
        Sacs = baseURL .. defaultType .. '/bag.webp',
        Cou = 'https://cdn.eltrane.cloud/3838384859/old_a_trier/Discord/4985290747179171951144393442533838939image.webp'
    }

    local progressBars = {
        { name = 'Variations' }
    }

    creaPersoData.buttons = {
        CreateButton('Hauts', 'full', images.Hauts, 100, { { name = 'Hauts' }, table.unpack(progressBars) }),
        CreateButton('Bas', 'full', images.Bas, 120, { { name = 'Bas' }, table.unpack(progressBars) }),
        CreateButton('Chaussures', 'full', images.Chaussures, 110, { { name = 'Chaussures' }, table.unpack(progressBars) }),
        CreateButton('Chapeaux', 'full', images.Chapeaux, 80, { { name = 'Chapeaux' }, table.unpack(progressBars) }),
        CreateButton('Lunettes', 'half', images.Lunettes, 50, { { name = 'Lunettes' }, table.unpack(progressBars) }),
        CreateButton('Sacs', 'half', images.Sacs, 25, { { name = 'Sacs' }, table.unpack(progressBars) }),
        CreateButton('Cou', 'half', images.Cou, 20, { { name = 'Cou' }, table.unpack(progressBars) })
    }
end

local function LoadClothesForCreator(baseURL)
    local playerPed = PlayerPedId()
    local bans = Config.ClothesBan[temporaryDatas.playerType] or {}

    local function AddToCatalogue(id, label, image, category, subCategory, idVariation, targetId)
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {
            id = id,
            label = label,
            image = image,
            category = category,
            subCategory = subCategory,
            idVariation = idVariation,
            targetId = targetId
        }
    end

    local function ProcessClothing(drawableType, banList, category, subCategory, prefix)
        for i = 0, GetNumberOfPedDrawableVariations(playerPed, drawableType) - 1 do
            if not VFW.Table.TableContains(banList, i) then
                local drawableURL = string.format("%s/clothing/%s/%d.webp", baseURL, prefix, i)
                AddToCatalogue(i, string.format("%s N°%d", category, i), drawableURL, category, subCategory, i)

                for z = 0, GetNumberOfPedTextureVariations(playerPed, drawableType, i) - 1 do
                    local imageURL = z == 0 and drawableURL or string.format("%s_%d.webp", drawableURL:sub(1, -6), z)
                    AddToCatalogue(z, string.format("Variation N°%d", z), imageURL, category, "Variations", nil, i)
                end
            end
        end
    end

    local function ProcessProps(propType, banList, category, prefix)
        for i = 0, GetNumberOfPedPropDrawableVariations(playerPed, propType) - 1 do
            if not VFW.Table.TableContains(banList, i) then
                local drawableURL = string.format("%s/props/%s/%d.webp", baseURL, prefix, i)
                AddToCatalogue(i, string.format("%s N°%d", category, i), drawableURL, category, category, i)

                for z = 0, GetNumberOfPedPropTextureVariations(playerPed, propType, i) - 1 do
                    local imageURL = z == 0 and drawableURL or string.format("%s_%d.webp", drawableURL:sub(1, -6), z)
                    AddToCatalogue(z, string.format("Variation N°%d", z), imageURL, category, "Variations", nil, i)
                end
            end
        end
    end

    ProcessClothing(4, bans.BanLeg, "Bas", "Bas", "leg")

    ProcessClothing(6, bans.BanShoes, "Chaussures", "Chaussures", "shoes")

    AddToCatalogue(15, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Hauts", "Hauts", 15)
    ProcessClothing(11, bans.BanTop, "Hauts", "Hauts", "torso2")

    local defaultId = temporaryDatas.playerType == "Homme" and 0 or 17
    AddToCatalogue(defaultId, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Hauts", "Sous-haut", defaultId)
    ProcessClothing(8, bans.BanSous, "Hauts", "Sous-haut", "undershirt")

    ProcessClothing(3, bans.BanArm, "Hauts", "Bras", "arms")

    AddToCatalogue(-1, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Chapeaux", "Chapeaux", -1)
    ProcessProps(0, bans.BanHat, "Chapeaux", "hat")

    local glassesDefaultId = temporaryDatas.playerType == "Homme" and 0 or -1
    AddToCatalogue(glassesDefaultId, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Lunettes", "Lunettes", glassesDefaultId)
    ProcessProps(1, bans.BanGlases, "Lunettes", "glasses")

    AddToCatalogue(0, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Sacs", "Sacs", 0)
    ProcessClothing(5, bans.BanBag, "Sacs", "Sacs", "bag")

    AddToCatalogue(0, "Aucun", "https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", "Cou", "Cou", 0)
    ProcessClothing(7, bans.BanCou, "Cou", "Cou", "accessory")
end

local function LoadDataForCreator(sex)
    creaPersoData.catalogue = {}
    creaPersoData.peds = {}
    temporaryDatas.playerType = sex == 1 and "Femme" or "Homme"
	
	if temporaryDatas.playerType == "Homme" then
		temporaryDatas.playerSex = "male"
	elseif temporaryDatas.playerType == "Femme" then
		temporaryDatas.playerSex = "female"
	else 
		temporaryDatas.playerSex = "ped"
	end

    console.debug(sex, temporaryDatas.playerType)

    local baseURL = "https://cdn.eltrane.cloud/3838384859/outfits_greenscreener/" .. temporaryDatas.playerSex

    creaPersoData.hideItemList = {'Bras','Variations 3'}

    if temporaryDatas.playerType == "Homme" then
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {id = 61, label="Aucun", image="https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", category="Bas", subCategory="Bas", idVariation=61}
    else
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {id = 17, label="Aucun", image="https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", category="Bas", subCategory="Bas", idVariation=17}
    end

    if temporaryDatas.playerType == "Homme" then
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {id = 34, label="Aucun", image="https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", category="Chaussures", subCategory="Chaussures", idVariation=34}
    else
        creaPersoData.catalogue[#creaPersoData.catalogue + 1] = {id = 35, label="Aucun", image="https://cdn.eltrane.cloud/3838384859/assets/creation-personnage/croix-resize.png", category="Chaussures", subCategory="Chaussures", idVariation=35}
    end

    LoadFaceFeatures()
    LoadPedsFeatures()
    LoadButtonsCreaPerso()
    LoadClothesForCreator(baseURL)

    Wait(250)

    VFW.Nui.Creator(true, creaPersoData)
end

function LoadNewCharCreator()
    while VFW.PlayerGlobalData == nil do Wait(1000) end
    
    local p = promise.new()

    VFW.Nui.HudVisible(false)

    TriggerEvent("skinchanger:loadSkin", { sex = 0 }, function()
        p:resolve()
    end)
    

    Citizen.Await(p)

    TriggerServerEvent("core:server:instanceCreator", true)

    SetEntityCoords(PlayerPedId(), Config.CharCreator[1].COH.x, Config.CharCreator[1].COH.y, Config.CharCreator[1].COH.z - 1)
    SetEntityHeading(PlayerPedId(), Config.CharCreator[1].COH.w)
    SetEntityAsMissionEntity(PlayerPedId(), true, true)

    Wait(500)

    creaPersoData.premium = VFW.PlayerGlobalData.permissions["premium"]

    if creaPersoData.premium then
        local characters = TriggerServerCallback('core:server:characterCreator')

        if characters and #characters > 0 then
            for i = 1, #characters do
                local v = characters[i]
                creaPersoData.recoverableCharacters[#creaPersoData.recoverableCharacters + 1] = {
                    name = v.firstname .. " " .. v.lastname,
                    data = {
                        identity = {
                            firstName = v.lastname,
                            lastName = v.firstname,
                            dateOfBirthdayr = v.age,
                            birthplace = v.birthplaces,
                            sex = (v.sex == "F") and 1 or (v.sex == "M") and 0 or nil,
                        },
                        skin = v.skin
                    }
                }
            end
        end
    end

    VFW.Cam:Create("cam_creator", Config.CharCreator[1])

    NetworkOverrideClockTime(03, 0, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
    
    LoadDataForCreator(0)
end

local function LoadVariationForPed(sex)
    local playerPed = PlayerPedId()

    creaPersoData.pedsVariantes = {}
    local categories = {
        { component = 0, category = "visage" },
        { component = 3, category = "haut" },
        { component = 4, category = "bas" },
        { component = 6, category = "chaussure" }
    }

    for i = 1, #categories do
        local valeur = categories[i]
        local component = valeur.component
        local category = valeur.category

        for ii = 0, GetNumberOfPedDrawableVariations(playerPed, component) - 1 do
            creaPersoData.pedsVariantes[#creaPersoData.pedsVariantes + 1] = {
                category = category,
                subCategory = sex,
                id = ii,
                idVariante = ii
            }

            for z = 0, GetNumberOfPedTextureVariations(playerPed, component, ii) - 1 do
                creaPersoData.pedsVariantes[#creaPersoData.pedsVariantes + 1] = {
                    category = category,
                    subCategory = sex,
                    id = z,
                    targetId = ii
                }
            end
        end
    end

    VFW.Nui.Creator(true, creaPersoData)
end

local function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

local function ClearScreen()
    SetCloudsAlpha(0.01)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

local function SpawnPlayerCharCreator(spawnPoint)
    local playerPed = PlayerPedId()

    ToggleSound(true)

    if not IsPlayerSwitchInProgress() then
        SwitchToMultiFirstpart(playerPed, 0, 1)
    end

    while GetPlayerSwitchState() ~= 5 do
        Wait(0)
        ClearScreen()
    end

    ShutdownLoadingScreen()
    DoScreenFadeIn(100)

    if spawnPoint == "vespucci" then
        SetEntityCoords(playerPed, -1369.9084472656, -527.89978027344, 30.308320999146-1)
        SetEntityHeading(playerPed, 147.28375244141)
    elseif spawnPoint == "cubes" then
        SetEntityCoords(playerPed, 195.41, -929.99, 29.69-1)
        SetEntityHeading(playerPed, 197.24)
    elseif spawnPoint == "gouvernement" then
        SetEntityCoords(playerPed, -245.26113891602, -338.5627746582, 29.078057861328-1)
        SetEntityHeading(playerPed,  99.247352600098)
    elseif spawnPoint == "sandyshore" then
        SetEntityCoords(playerPed, 1510.7041015625, 3739.6594238281, 34.482025146484-1)
        SetEntityHeading(playerPed, 219.03)
    elseif spawnPoint == "paletobay" then
        SetEntityCoords(playerPed, 103.81511688232, 6457.9428710938, 31.399099349976-1)
        SetEntityHeading(playerPed, 45.8)
    elseif spawnPoint == "aeroport" then
        SetEntityCoords(playerPed, 4432.6, -4488.25, 3.24-1)
        SetEntityHeading(playerPed,  197.43)
    end

    FreezeEntityPosition(playerPed, true)

    while not IsScreenFadedIn() do
        Wait(0)
        ClearScreen()
    end

    local TIMER <const> = GetGameTimer()

    ToggleSound(false)

    while GetGameTimer() - TIMER <= 1000 do
        Wait(0)
    end

    SwitchToMultiSecondpart(playerPed)

    while GetPlayerSwitchState() ~= 12 do
        Wait(0)
        ClearScreen()
    end

    ClearDrawOrigin()
    VFW.Nui.HudVisible(true)
    FreezeEntityPosition(playerPed, false)
    SetEntityInvincible(playerPed, false)
    -- OpenTutorialForm()
end

RegisterNuiCallback("CreationPersonnageSetCamera", function(data)
    if data.newCamera == "full" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[1])
    elseif data.newCamera == "face" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[2])
    elseif data.newCamera == "chest" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[3])
    end
end)

RegisterNuiCallback("CreationPersonnageClickHabit", function(data)
    if (data == nil) or (data.category == nil) then return end

    if data.category == "Hauts" then 
        if data.subCategory == "Hauts" then
            TriggerEvent("skinchanger:change", "torso_1",data.id)
            TriggerEvent("skinchanger:change", "torso_2", 0)
            if Config.ClothsList[temporaryDatas.playerType]["Haut"][tostring(data.id)] then 
               TriggerEvent("skinchanger:change", "arms", Config.ClothsList[temporaryDatas.playerType]["Haut"][tostring(data.id)])
               TriggerEvent("skinchanger:change", "arms_2", 0)
            end
            if temporaryDatas.playerType == "Homme" then
                TriggerEvent("skinchanger:change", "tshirt_1",15)
                TriggerEvent("skinchanger:change", "tshirt_2", 0)
            else
                TriggerEvent("skinchanger:change", "tshirt_1",14)
                TriggerEvent("skinchanger:change", "tshirt_2", 0)
            end
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "torso_2",data.id)
        end
    elseif data.category == "Bas" then
        if data.subCategory == "Bas" then
            TriggerEvent("skinchanger:change", "pants_1",data.id)
            TriggerEvent("skinchanger:change", "pants_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "pants_2",data.id)
        end
    elseif data.category == "Chaussures" then
        if data.subCategory == "Chaussures" then
            TriggerEvent("skinchanger:change", "shoes_1",data.id)
            TriggerEvent("skinchanger:change", "shoes_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "shoes_2",data.id)
        end
    elseif data.category == "Chapeaux" then
        if data.subCategory == "Chapeaux" then
            TriggerEvent("skinchanger:change", "helmet_1",data.id)
            TriggerEvent("skinchanger:change", "helmet_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "helmet_2",data.id)
        end
    elseif data.category == "Lunettes" then
        if data.subCategory == "Lunettes" then
            TriggerEvent("skinchanger:change", "glasses_1",data.id)
            TriggerEvent("skinchanger:change", "glasses_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "glasses_2",data.id)
        end
    elseif data.category == "Sacs" then
        if data.subCategory == "Sacs" then
            TriggerEvent("skinchanger:change", "bags_1",data.id)
            TriggerEvent("skinchanger:change", "bags_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "bags_2",data.id)
        end
    elseif data.category == "Cou" then
        if data.subCategory == "Cou" then
            TriggerEvent("skinchanger:change", "chain_1",data.id)
            TriggerEvent("skinchanger:change", "chain_2", 0)
        elseif data.subCategory == "Variations" then
            TriggerEvent("skinchanger:change", "chain_2",data.id)
        end
    end
end)

RegisterNuiCallback("CreationPersonnageBackToMain", function(data)
    if lastOnglet ~= "vetements" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[1])
    else
        VFW.Cam:Update("cam_creator", Config.CharCreator[6])
    end
end)

RegisterNuiCallback("CreationPersonnageClickBouton", function(data)
    if data == "Hauts" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[6])
    elseif data == "Bas" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[7])
    elseif data == "Chaussures" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[8])
    elseif data == "Chapeaux" or data == "Lunettes" or data == "Cou" then
        VFW.Cam:Update("cam_creator", Config.CharCreator[9])
    elseif data == "Sacs" then
        SetEntityHeading(PlayerPedId(), Config.CharCreator[10].COH.w)
        VFW.Cam:Update("cam_creator", Config.CharCreator[10])
    end
end)

RegisterNuiCallback("CreationPersonnageMouseMove", function(data)
    local playerPed = PlayerPedId()

    if data.moveCamera == 1 then
        SetEntityHeading(playerPed, GetEntityHeading(playerPed) + 3.0)
    else
        SetEntityHeading(playerPed, GetEntityHeading(playerPed) - 3.0)
    end
end)

RegisterNuiCallback("nui:char-creator:identity", function(data)
    local dataIdentity = data.newData

    if dataIdentity and dataIdentity ~= nil then
        if dataIdentity.characterChoice == "men" then
            TypePed = 0
            TriggerEvent('skinchanger:loadSkin', {
                sex       = 0,
                tshirt_1  = 15,
                tshirt_2  = 0,
                torso_1   = 15,
                torso_2   = 0,
                arms      = 15,
                arms_2    = 0,
                pants_1   = 21,
                pants_2   = 0,
                shoes_1   = 34,
                shoes_2   = 0,
                chain_1   = 0,
                chain_2   = 0,
                helmet_1  = -1,
                helmet_2  = 0,
                ears_1    = -1,
                ears_2    = 0,
                glasses_1 = 0,
                glasses_2 = 0,
                mask_1    = 0,
                mask_2    = 0,
                bproof_1  = 0,
                bproof_2  = 0,
                bags_1    = 0,
                bags_2    = 0,
                decals_1  = 0,
                decals_2  = 0,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                face      = 0,
                skin      = 0,
                age_1     = 0,
                age_2     = 0,
                beard_1   = 0,
                beard_2   = 0,
                beard_3   = 0,
                beard_4   = 0,
                hair_1    = 0,
                hair_2    = 0,
                hair_color_1 = 0,
                hair_color_2 = 0,
                eye_color = 0,
                eyebrows_1 = 0,
                eyebrows_2 = 0,
                eyebrows_3 = 0,
                eyebrows_4 = 0,
                makeup_1  = 0,
                makeup_2  = 0,
                makeup_3  = 0,
                makeup_4  = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                chest_1   = 0,
                chest_2   = 0,
                chest_3   = 0,
                chest_4   = 0,
                bodyb_1   = 0,
                bodyb_2   = 0
            })
            LoadDataForCreator(0)
        elseif dataIdentity.characterChoice == "women" then
            TypePed = 1
            TriggerEvent('skinchanger:loadSkin', {
                sex       = 1,
                tshirt_1  = 14,
                tshirt_2  = 0,
                torso_1   = 15,
                torso_2   = 0,
                arms      = 15,
                arms_2    = 0,
                pants_1   = 15,
                pants_2   = 0,
                shoes_1   = 35,
                shoes_2   = 0,
                chain_1   = 0,
                chain_2   = 0,
                helmet_1  = -1,
                helmet_2  = 0,
                ears_1    = -1,
                ears_2    = 0,
                glasses_1 = -1,
                glasses_2 = 0,
                mask_1    = 0,
                mask_2    = 0,
                bproof_1  = 0,
                bproof_2  = 0,
                bags_1    = 0,
                bags_2    = 0,
                decals_1  = 0,
                decals_2  = 0,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                face      = 0,
                skin      = 0,
                age_1     = 0,
                age_2     = 0,
                beard_1   = 0,
                beard_2   = 0,
                beard_3   = 0,
                beard_4   = 0,
                hair_1    = 0,
                hair_2    = 0,
                hair_color_1 = 0,
                hair_color_2 = 0,
                eye_color = 0,
                eyebrows_1 = 0,
                eyebrows_2 = 0,
                eyebrows_3 = 0,
                eyebrows_4 = 0,
                makeup_1  = 0,
                makeup_2  = 0,
                makeup_3  = 0,
                makeup_4  = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                chest_1   = 0,
                chest_2   = 0,
                chest_3   = 0,
                chest_4   = 0,
                bodyb_1   = 0,
                bodyb_2   = 0
            })
            LoadDataForCreator(1)
        elseif dataIdentity.characterChoice == "custom" then
            TypePed = 2
            TriggerEvent("skinchanger:loadSkin", { sex = 2 })
            LoadVariationForPed(2)
        end

        firstName = dataIdentity.firstName
        lastName = dataIdentity.lastName
        dateOfBirthdayr = dataIdentity.birthDate
        sex = dataIdentity.sex
        birthplace = dataIdentity.birthplace
    end
end)

local function handleSkinChange(key, value, lastValue, scale)
    if value ~= nil and value ~= lastValue then
        TriggerEvent("skinchanger:change", key, scale and (value * scale) or (value - 1))
        return value
    end
    return lastValue
end

RegisterNuiCallback("nui:char-creator:character", function(data)
    if data.newData then
        local character = data.newData

        newP1 = handleSkinChange("mom", character.parent1, newP1)
        newP2 = handleSkinChange("dad", character.parent2, newP2)
        lastSkinValue = handleSkinChange("skin_md_weight", character.skinValue, lastSkinValue, 100)
        lastlookingValue = handleSkinChange("face_md_weight", character.lookingValue, lastlookingValue, 100)
    end
end)

local function handleVisageChange(key, value, lastValue, scale)
    if value ~= nil and value ~= lastValue then
        TriggerEvent("skinchanger:change", key, scale and (value * scale) or (value / 10))
        return value * scale
    end
    return lastValue
end

RegisterNuiCallback("nui:char-creator:visage", function(data)
    if data.newData then
        local visage = data.newData

        lastnoseX = handleVisageChange("nose_1", visage.nose and visage.nose.x, lastnoseX, 10)
        lastnoseY = handleVisageChange("nose_2", visage.nose and visage.nose.y, lastnoseY, 10)

        local nosePointeX = visage.nosePointe and visage.nosePointe.x
        local nosePointeY = visage.nosePointe and visage.nosePointe.y
        if nosePointeX then
            nosePointeX = -nosePointeX
        end
        lastnosePointeX = handleVisageChange("nose_5", nosePointeX, lastnosePointeX, 10)
        lastnosePointeY = handleVisageChange("nose_6", nosePointeY, lastnosePointeY, 10)

        local noseProfileX = visage.noseProfile and visage.noseProfile.x
        local noseProfileY = visage.noseProfile and visage.noseProfile.y
        if noseProfileX then
            noseProfileX = -noseProfileX
        end
        lastnoseProfileX = handleVisageChange("nose_3", noseProfileX, lastnoseProfileX, 10)
        lastnoseProfileY = handleVisageChange("nose_4", noseProfileY, lastnoseProfileY, 10)

        local sourcilsX = visage.sourcils and visage.sourcils.x
        local sourcilsY = visage.sourcils and visage.sourcils.y
        lastSourcilsX = handleVisageChange("eyebrows_5", sourcilsY, lastSourcilsY, 10)
        lastSourcilsY = handleVisageChange("eyebrows_6", sourcilsX, lastSourcilsX, 10)

        local pommettesX = visage.pommettes and visage.pommettes.y  -- Y devient X
        local pommettesY = visage.pommettes and visage.pommettes.x  -- X devient Y
        if pommettesY then
            pommettesY = -pommettesY
        end
        lastpommettesX = handleVisageChange("cheeks_1", pommettesX, lastpommettesX, 10)
        lastpommettesY = handleVisageChange("cheeks_2", pommettesY, lastpommettesY, 10)

        local mentonX = visage.menton and visage.menton.x
        local mentonY = visage.menton and visage.menton.y
        lastMentonX = handleVisageChange("chin_1", mentonY, lastMentonY, 10)
        lastMentonY = handleVisageChange("chin_2", mentonX, lastMentonX, 10)

        local mentonShapeX = visage.mentonShape and visage.mentonShape.x
        local mentonShapeY = visage.mentonShape and visage.mentonShape.y
        if mentonShapeY then
            mentonShapeY = -mentonShapeY
        end
        if mentonShapeX then
            mentonShapeX = -mentonShapeX
        end
        lastMentonShapeX = handleVisageChange("chin_3", mentonShapeX, lastMentonShapeX, 10)
        lastMentonShapeY = handleVisageChange("chin_4", mentonShapeY, lastMentonShapeY, 10)

        local machoireX = visage.machoire and visage.machoire.x
        if machoireX then
            machoireX = -machoireX
        end
        lastMachoireX = handleVisageChange("jaw_1", machoireX, lastMachoireX, 10)
        lastMachoireY = handleVisageChange("jaw_2", visage.machoire and visage.machoire.y, lastMachoireY, 10)

        lastCou = handleVisageChange("neck_thickness", visage.cou, lastCou, 0.1)
        lastlevres = handleVisageChange("lip_thickness", visage.levres, lastlevres, 0.1)
        lastjoues = handleVisageChange("cheeks_3", visage.joues, lastjoues, 0.1)
        lastyeux = handleVisageChange("eye_squint", visage.yeux, lastyeux, 0.1)
    end
end)

local function applyChange(field, value, oldValue, itemIdAdjust)
    if value ~= nil and value ~= oldValue then
        TriggerEvent("skinchanger:change", field, value - (itemIdAdjust or 0))
        return value
    end
    return oldValue
end

local function applyColorChange(field, value, oldValue, opacityAdjust)
    if value ~= nil and value ~= oldValue then
        local adjustedValue = (opacityAdjust and opacityAdjust ~= 0) and (value / opacityAdjust) or value
        TriggerEvent("skinchanger:change", field, adjustedValue)
        return value
    end
    return oldValue
end

RegisterNuiCallback("nui:char-creator:apparence", function(data)
    if data.newData ~= nil then
        local apparence = data.newData
        local playerType = temporaryDatas.playerType

        if apparence.hair ~= nil then
            oldHair = applyChange("hair_1", apparence.hair.item.id, oldHair)
            oldColor1 = applyColorChange("hair_color_1", apparence.hair.color1, oldColor1)
            oldColor2 = applyColorChange("hair_color_2", apparence.hair.color2, oldColor2)
        end

        if apparence.beard ~= nil and playerType == "Homme" then
            oldBeard = applyChange("beard_1", apparence.beard.item.id, oldBeard, 1)
            oldColorbeard1 = applyColorChange("beard_3", apparence.beard.color1, oldColorbeard1)
            if oldColorbeard2 == nil then
                TriggerEvent('skinchanger:change', "beard_2", 10)
            end
            
            oldColorbeard2 = applyColorChange("beard_2", apparence.beard.opacity, oldColorbeard2, 10)
        end

        if apparence.sourcils ~= nil then
            oldsourcils = applyChange("eyebrows_1", apparence.sourcils.item.id, oldsourcils)
            oldColorsourcils1 = applyColorChange("eyebrows_3", apparence.sourcils.color1, oldColorsourcils1)
            oldColorsourcils2 = applyColorChange("eyebrows_4", apparence.sourcils.color2, oldColorsourcils2)
            if oldColorsourcils3 == nil then
                TriggerEvent('skinchanger:change', "eyebrows_2", 10)
            end

            oldColorsourcils3 = applyColorChange("eyebrows_2", apparence.sourcils.opacity, oldColorsourcils3, 10)
        end

        if apparence.eyebrows ~= nil then
            oldsourcils = applyChange("eyebrows_1", apparence.eyebrows.item.id, oldsourcils)
            oldColorsourcils1 = applyColorChange("eyebrows_3", apparence.eyebrows.color1, oldColorsourcils1)
            oldColorsourcils2 = applyColorChange("eyebrows_4", apparence.eyebrows.color2, oldColorsourcils2)
            if oldColorsourcils3 == nil then
                TriggerEvent('skinchanger:change', "eyebrows_2", 10)
            end

            oldColorsourcils3 = applyColorChange("eyebrows_2", apparence.eyebrows.opacity, oldColorsourcils3, 10)
        end

        if apparence.pilosite ~= nil and playerType == "Homme" then
            oldpilosite = applyChange("chest_1", apparence.pilosite.item.id, oldpilosite)
            oldColorpilosite1 = applyColorChange("chest_3", apparence.pilosite.color1, oldColorpilosite1)
            if oldColorpilosite3 == nil then
                TriggerEvent('skinchanger:change', "chest_2", 10)
            end

            oldColorpilosite3 = applyColorChange("chest_2", apparence.pilosite.opacity, oldColorpilosite3, 10)
        end

        if apparence.eyes ~= nil then
            ColorEyes = applyChange("eye_color", apparence.eyes.color1, ColorEyes)
        end

        if apparence.eyesmaquillage ~= nil then
            oldeyesmaquillage = applyChange("makeup_1", apparence.eyesmaquillage.item.id, oldeyesmaquillage, 1)
            oldColoreyesmaquillage1 = applyColorChange("makeup_3", apparence.eyesmaquillage.color1, oldColoreyesmaquillage1)
            oldColoreyesmaquillage2 = applyColorChange("makeup_4", apparence.eyesmaquillage.color2, oldColoreyesmaquillage2)
            if oldColoreyesmaquillage3 == nil then
                TriggerEvent('skinchanger:change', "makeup_2", 10)
            end
            
            oldColoreyesmaquillage3 = applyColorChange("makeup_2", apparence.eyesmaquillage.opacity, oldColoreyesmaquillage3, 10)
        end

        if apparence.eye_makeup ~= nil then
            oldeyesmaquillage = applyChange("makeup_1", apparence.eye_makeup.item.id, oldeyesmaquillage, 1)
            oldColoreyesmaquillage1 = applyColorChange("makeup_3", apparence.eye_makeup.color1, oldColoreyesmaquillage1)
            oldColoreyesmaquillage2 = applyColorChange("makeup_4", apparence.eye_makeup.color2, oldColoreyesmaquillage2)
            if oldColoreyesmaquillage3 == nil then
                TriggerEvent('skinchanger:change', "makeup_2", 10)
            end
            
            oldColoreyesmaquillage3 = applyColorChange("makeup_2", apparence.eye_makeup.opacity, oldColoreyesmaquillage3, 10)
        end

        if apparence.fard ~= nil then
            oldfard = applyChange("blush_1", apparence.fard.item.id, oldfard, 1)
            oldColorfard1 = applyColorChange("blush_3", apparence.fard.color1, oldColorfard1)
            if oldColorfard3 == nil then
                TriggerEvent('skinchanger:change', "blush_2", 10)
            end
            
            oldColorfard3 = applyColorChange("blush_2", apparence.fard.opacity, oldColorfard3, 10)
        end

        if apparence.rougealevre ~= nil then
            oldrougealevre = applyChange("lipstick_1", apparence.rougealevre.item.id, oldrougealevre, 1)
            oldColorrougealevre1 = applyColorChange("lipstick_3", apparence.rougealevre.color1, oldColorrougealevre1)
            if oldColorrougealevre3 == nil then
                TriggerEvent('skinchanger:change', "lipstick_2", 10)
            end
            
            oldColorrougealevre3 = applyColorChange("lipstick_2", apparence.rougealevre.opacity, oldColorrougealevre3, 10)
        end
        
        if apparence.lips_makeup ~= nil then
            oldrougealevre = applyChange("lipstick_1", apparence.lips_makeup.item.id, oldrougealevre, 1)
            oldColorrougealevre1 = applyColorChange("lipstick_3", apparence.lips_makeup.color1, oldColorrougealevre1)
            if oldColorrougealevre3 == nil then
                TriggerEvent('skinchanger:change', "lipstick_2", 10)
            end
            
            oldColorrougealevre3 = applyColorChange("lipstick_2", apparence.lips_makeup.opacity, oldColorrougealevre3, 10)
        end

        if apparence.taches ~= nil then
            oldtaches = applyChange("bodyb_1", apparence.taches.item.id, oldtaches)
            if oldOpacityTache == nil then
                TriggerEvent('skinchanger:change', "bodyb_2", 10)
            end
            
            oldOpacityTache = applyColorChange("bodyb_2", apparence.taches.opacity, oldOpacityTache, 10)
        end

        if apparence.marques ~= nil then
            oldmarques = applyChange("age_1", apparence.marques.item.id, oldmarques)
            if oldOpacityMarque == nil then
                TriggerEvent('skinchanger:change', "age_2", 10)
            end
            
            oldOpacityMarque = applyColorChange("age_2", apparence.marques.opacity, oldOpacityMarque, 10)
        end

        if apparence.acne ~= nil then
            oldacne = applyChange("blemishes_1", apparence.acne.item.id, oldacne)
            if oldOpacityAcne == nil then
                TriggerEvent('skinchanger:change', "blemishes_2", 10)
            end
            
            oldOpacityAcne = applyColorChange("blemishes_2", apparence.acne.opacity, oldOpacityAcne, 10)
        end

        if apparence.rousseur ~= nil then
            oldrousseur = applyChange("moles_1", apparence.rousseur.item.id, oldrousseur)
            if oldOpacityrousseur == nil then
                TriggerEvent('skinchanger:change', "moles_2", 10)
            end
            
            oldOpacityrousseur = applyColorChange("moles_2", apparence.rousseur.opacity, oldOpacityrousseur, 10)
        end

        if apparence.teint ~= nil then
            oldteint = applyChange("complexion_1", apparence.teint.item.id, oldteint)
            if oldOpacityTeint == nil then
                TriggerEvent('skinchanger:change', "complexion_2", 10)
            end
            
            oldOpacityTeint = applyColorChange("complexion_2", apparence.teint.opacity, oldOpacityTeint, 10)
        end

        if apparence.cicatrice ~= nil then
            oldcicatrice = applyChange("sun_1", apparence.cicatrice.item.id, oldcicatrice)
            if oldOpacityCicatrice == nil then
                TriggerEvent('skinchanger:change', "sun_2", 10)
            end
            
            oldOpacityCicatrice = applyColorChange("sun_2", apparence.cicatrice.opacity, oldOpacityCicatrice, 10)
        end
    end
end)

RegisterNuiCallback("nui:char-creator:ped", function(data)
    local dataPed = data.newData and data.newData.selectedPled
    local playerPed = PlayerPedId()

    if dataPed and dataPed.id then
        TriggerEvent("skinchanger:change", "sex", dataPed.id + 1)
        LoadVariationForPed(dataPed.id + 1)
    end

    if data.newData and data.newData.ped and data.newData.ped.physique then
        local physique = data.newData.ped.physique

        if physique.visage  ~= nil then
            if physique.visage.type.category == "visage"  then
                SetPedComponentVariation(playerPed, 0, physique.visage.type.id, physique.visage.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "head", physique.visage.type.id)
            end
            if physique.visage.color.category == "visage"  then
                SetPedComponentVariation(playerPed, 0, physique.visage.type.id, physique.visage.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "mask_1", physique.visage.color.id)
            end
        end
        if physique.haut  ~= nil then
            if physique.haut.type.category == "haut"  then
                SetPedComponentVariation(playerPed, 3, physique.haut.type.id, physique.haut.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "arms", physique.haut.type.id)
            end
            if physique.visage.color.category == "haut"  then
                SetPedComponentVariation(playerPed, 3, physique.haut.type.id, physique.haut.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "arms_2", physique.haut.color.id)
            end
        end
        if physique.bas  ~= nil then
            if physique.bas.type.category == "bas"  then
                SetPedComponentVariation(playerPed, 4, physique.bas.type.id, physique.bas.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "pants_1", physique.bas.type.id)
            end
            if physique.bas.color.category == "bas"  then
                SetPedComponentVariation(playerPed, 4, physique.bas.type.id , physique.bas.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "pants_2", physique.bas.color.id)
            end
        end
        if physique.chaussure  ~= nil then
            if physique.chaussure.type.category == "chaussure"  then
                SetPedComponentVariation(playerPed, 6, physique.chaussure.type.id, physique.chaussure.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "shoes_1", physique.chaussure.type.id)
            end
            if physique.chaussure.color.category == "chaussure"  then
                SetPedComponentVariation(playerPed, 6, physique.chaussure.type.id, physique.chaussure.color.id)
                TriggerEvent("skinchanger:changeNoEffect", "shoes_2", physique.chaussure.color.id)
            end
        end
    end
end)

RegisterNuiCallback("nui:char-creator:back-to-outfit", function(data)
    if not data.origin then return end

    local animations = {
        Hauts = { emote = "tryclothes2" },
        Bas = { emote = "tryclothes" },
        Chaussures = { emote = "tryclothes3" }
    }

    local animData = animations[data.origin]

    if animData then
        EmoteCancel()
        Wait(100)
        EmoteCommandStart(animData.emote)
    end
end)

RegisterNuiCallback("CreationPersonnage", function(data)
    local onglet = data.onglet

    if not onglet then return end

    local cam_positions = {
        vetements = 6,
        ["identité"] = 1,
        personnage = 1,
        visage = 1,
        apparence = 1,
        lieuapparition = 5
    }

    local animations = {
        ["identité"] = "idle",
        personnage = "idle5",
        visage = "idle5",
        apparence = "idle5",
        vetements = "idle6",
        lieuapparition = "airportbag"
    }

    lastOnglet = onglet

    if cam_positions[onglet] then
        local cam_name = (onglet == "lieuapparition") and "cam_creator_lieuapparition" or "cam_creator"

        if VFW.Cam:Get(cam_name) then
            VFW.Cam:Destroy(cam_name)
        end

        VFW.Cam:Create(cam_name, Config.CharCreator[cam_positions[onglet]])

        local pos = Config.CharCreator[cam_positions[onglet]].COH
        SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z - 1)
        SetEntityHeading(PlayerPedId(), pos.w)

        if onglet == "lieuapparition" then
            Wait(250)
        end
    end

    if animations[onglet] then
        EmoteCancel()
        Wait(100)
        EmoteCommandStart(animations[onglet])
    end
end)

RegisterNuiCallback("nui:char-creator:update-all", function(data)
    if not data then
        console.debug("Erreur : Données du personnage manquantes ou invalides.")
        return
    end 

    local characters = TriggerServerCallback('core:server:characterCreator')

    if not characters or #characters == 0 then
        console.debug("Aucun personnage trouvé sur le serveur.")
        return
    end

    local found = false

    for i = 1, #characters do
        local character = characters[i]
        if character.firstname == data.lastName and character.lastname == data.firstName then
            local skin = character.skin
            TriggerEvent("skinchanger:loadSkin", {
                sex = skin.sex,
                mom = skin.mom,
                dad = skin.dad,
                face_md_weight = skin.face_md_weight,
                skin_md_weight = skin.skin_md_weight,
                nose_1 = skin.nose_1,
                nose_2 = skin.nose_2,
                nose_3 = skin.nose_3,
                nose_4 = skin.nose_4,
                nose_5 = skin.nose_5,
                nose_6 = skin.nose_6,
                cheeks_1 = skin.cheeks_1,
                cheeks_2 = skin.cheeks_2,
                cheeks_3 = skin.cheeks_3,
                lip_thickness = skin.lip_thickness,
                jaw_1 = skin.jaw_1,
                jaw_2 = skin.jaw_2,
                chin_1 = skin.chin_1,
                chin_2 = skin.chin_2,
                chin_3 = skin.chin_3,
                chin_4 = skin.chin_4,
                neck_thickness = skin.neck_thickness,
                age_1 = skin.age_1,
                age_2 = skin.age_2,
                beard_1 = skin.beard_1,
                beard_2 = skin.beard_2,
                beard_3 = skin.beard_3,
                beard_4 = skin.beard_4,
                hair_1 = skin.hair_1,
                hair_2 = skin.hair_2,
                hair_color_1 = skin.hair_color_1,
                hair_color_2 = skin.hair_color_2,
                eye_color = skin.eye_color,
                eye_squint = skin.eye_squint,
                eyebrows_1 = skin.eyebrows_1,
                eyebrows_2 = skin.eyebrows_2,
                eyebrows_3 = skin.eyebrows_3,
                eyebrows_4 = skin.eyebrows_4,
                eyebrows_5 = skin.eyebrows_5,
                eyebrows_6 = skin.eyebrows_6,
                makeup_1 = skin.makeup_1,
                makeup_2 = skin.makeup_2,
                makeup_3 = skin.makeup_3,
                makeup_4 = skin.makeup_4,
                lipstick_1 = skin.lipstick_1,
                lipstick_2 = skin.lipstick_2,
                lipstick_3 = skin.lipstick_3,
                lipstick_4 = skin.lipstick_4,
                blemishes_1 = skin.blemishes_1,
                blemishes_2 = skin.blemishes_2,
                blush_1 = skin.blush_1,
                blush_2 = skin.blush_2,
                blush_3 = skin.blush_3,
                complexion_1 = skin.complexion_1,
                complexion_2 = skin.complexion_2,
                sun_1 = skin.sun_1,
                sun_2 = skin.sun_2,
                moles_1 = skin.moles_1,
                moles_2 = skin.moles_2,
                chest_1 = skin.chest_1,
                chest_2 = skin.chest_2,
                chest_3 = skin.chest_3,
                bodyb_1 = skin.bodyb_1,
                bodyb_2 = skin.bodyb_2,
                bodyb_3 = skin.bodyb_3,
                bodyb_4 = skin.bodyb_4,

                tshirt_1  = skin.sex == 0 and 15 or 14,
                tshirt_2  = 0,
                torso_1   = 15,
                torso_2   = 0,
                arms      = 15,
                arms_2    = 0,
                pants_1   = 21,
                pants_2   = 0,
                shoes_1   = skin.sex == 0 and 35 or 34,
                shoes_2   = 0,
                chain_1   = 0,
                chain_2   = 0,
                helmet_1  = -1,
                helmet_2  = 0,
                ears_1    = -1,
                ears_2    = 0,
                glasses_1 = -1,
                glasses_2 = 0,
                mask_1    = 0,
                mask_2    = 0,
                bproof_1  = 0,
                bproof_2  = 0,
                bags_1    = 0,
                bags_2    = 0,
                decals_1  = 0,
                decals_2  = 0,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
            })

            ClearPedDecorations(PlayerPedId())

            TypePed = skin.sex
            LoadDataForCreator(skin.sex)

            lastTattoos = {}

            for _, tattoo in pairs(character.tattoos) do
                ApplyPedOverlay(PlayerPedId(), GetHashKey(tattoo.Collection), GetHashKey(tattoo.HashName))
                table.insert(lastTattoos, {
                    Collection = tattoo.Collection,
                    Hash = tattoo.HashName
                })
            end

            local emotesList = {"idle", "idle2", "idle6"}
            local emote = emotesList[VFW.Math.Random(1, #emotesList)]
            EmoteCancel()
            Wait(100)
            EmoteCommandStart(emote)
            found = true
            break
        end
    end

    if not found then
        console.debug("Aucun personnage correspondant trouvé pour :", data.firstName, data.lastName)
    end
end)

local blockControls = true
local spawnPoint = nil

local function Thread(state)
    blockControls = state

    if blockControls then
        CreateThread(function()
            while blockControls do
                Wait(0)
                DisableAllControlActions(0)
            end
        end)
    end
end

local function LoadingPrompt(loadingText, spinnerType)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end
    EndTextCommandBusyString(spinnerType)
end

local function screenShot()
    NetworkOverrideClockTime(17, 0, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')

    SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
    ClearPedProp(PlayerPedId(), 0)
    ClearPedProp(PlayerPedId(), 1)

    Thread(true)

    TriggerEvent("skinchanger:getSkin", function(skin)
        if skin.sex == 1 then
            SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
        else
            SetPedComponentVariation(PlayerPedId(), 6, 35, 0, 2)
        end
    end)

    LoadingPrompt("Mugshot en cours...", 2)

    Wait(5000)

    exports['screenshot-basic']:requestScreenshot(function(data)
        SendNUIMessage({
            action = "nui:uploadMugshot",
            data = data
        })
    end)
end

local redoMugshot = {
    active = false,
    limit = 1,
    coords = nil
}

local redoCloneOffline = {
    active      = false,
    charId      = nil,
    origCoords  = nil,
    origSkin    = nil,
    origTattoos = nil
}

RegisterCommand('mugshot', function()
    if redoMugshot.limit < 1 and (VFW.PlayerData and VFW.PlayerGlobalData.permissions and not VFW.PlayerGlobalData.permissions["staff_menu"]) then
        print("Vous avez déjà refait votre mugshot vous ne pouvez pas le refaire !")
        return
    end

    redoMugshot.active = true
    redoMugshot.limit = redoMugshot.limit - 1
    redoMugshot.coords = GetEntityCoords(PlayerPedId())

    SetEntityCoords(PlayerPedId(), Config.CharCreator[4].COH.x, Config.CharCreator[4].COH.y, Config.CharCreator[4].COH.z - 1)
    SetEntityHeading(PlayerPedId(), Config.CharCreator[4].COH.w)

    VFW.Cam:Create('cam_mugshot', Config.CharCreator[4])

    Wait(250)

    screenShot()
end, false)

TriggerEvent('chat:addSuggestion', '/mugshot', 'Refait et réactualise votre mugshot en jeu')

function takeMugshotScreenShot(charId)
    if not VFW.PlayerData or not VFW.PlayerGlobalData.permissions or not VFW.PlayerGlobalData.permissions["staff_menu"] then
        print("Vous n'avez pas la permission.")
        return
    end

    local charId = tonumber(charId)
    if not charId then
        print("ID de personnage invalide.")
        return
    end

    local skin, tattoos = TriggerServerCallback("vfw:server:getSkinByCharId", charId)
    if not skin then
        print("Personnage introuvable en base.")
        return
    end

    TriggerEvent("skinchanger:getSkin", function(origSkin)
        redoCloneOffline.origSkin    = origSkin
        redoCloneOffline.origTattoos = lastTattoos or {}
    end)
    redoCloneOffline.charId     = charId
    redoCloneOffline.origCoords = GetEntityCoords(PlayerPedId())

    TriggerEvent('skinchanger:loadSkin', skin)
    ClearPedDecorations(PlayerPedId())
    for _, tat in ipairs(tattoos or {}) do
        ApplyPedOverlay(PlayerPedId(), GetHashKey(tat.Collection), GetHashKey(tat.HashName))
    end

    SetEntityCoords(PlayerPedId(),
        Config.CharCreator[4].COH.x,
        Config.CharCreator[4].COH.y,
        Config.CharCreator[4].COH.z - 1
    )
    SetEntityHeading(PlayerPedId(), Config.CharCreator[4].COH.w)
    VFW.Cam:Create('cam_mugshot', Config.CharCreator[4])
    Wait(250)

    redoCloneOffline.active = true
    screenShot()
end

RegisterCommand('clonemugshot', function(_, args)
    local charId = tonumber(args[1])
    if not charId then
        print("Usage: /clonemugshot [charId]")
        return
    end

    takeMugshotScreenShot(charId)
end, false)

TriggerEvent('chat:addSuggestion', '/clonemugshot', 'Prend le mugshot d’un personnage offline', {
    { name="charId", help="ID de perso (offline)" }
})

RegisterNuiCallback("nui:mugshotUploaded", function(data)
    Wait(1000)
    VFW.Cam:Destroy('cam_mugshot')
    if redoCloneOffline.active then
        TriggerServerEvent("vfw:server:setMugshotForChar", redoCloneOffline.charId, data.url)

        TriggerEvent('skinchanger:loadSkin', redoCloneOffline.origSkin)
        ClearPedDecorations(PlayerPedId())
        for _, tat in ipairs(redoCloneOffline.origTattoos) do
            ApplyPedOverlay(PlayerPedId(), GetHashKey(tat.Collection), GetHashKey(tat.HashName))
        end

        SetEntityCoords(
            PlayerPedId(),
            redoCloneOffline.origCoords.x,
            redoCloneOffline.origCoords.y,
            redoCloneOffline.origCoords.z
        )

        redoCloneOffline = { active=false, charId=nil, origCoords=nil, origSkin=nil, origTattoos=nil }
        if BusyspinnerIsOn() then BusyspinnerOff() end
        EmoteCancel()
        Thread(false)
        return
    end

    if redoMugshot.active then
        TriggerServerEvent("vfw:server:setMugshot", data.url)
        SetEntityCoords(PlayerPedId(), redoMugshot.coords.x, redoMugshot.coords.y, redoMugshot.coords.z - 1)
        redoMugshot.active = false
        redoMugshot.coords = nil

        if BusyspinnerIsOn() then
            BusyspinnerOff()
        end
        EmoteCancel()
        Thread(false)
        return
    end

    local sex = nil

    if TypePed == 1 or sexPed == "women" then
        sex = "f"
    else
        sex = "m"
    end

    TriggerEvent("skinchanger:getSkin", function(skin)
        local identityData = {
            firstname = firstName,
            lastname = lastName,
            dateofbirth = dateOfBirthdayr,
            sex = sex,
            birthplace = birthplace,
            skin = skin,
            mugshot = data.url,
            tattoos = lastTattoos or {}
        }

        TriggerEvent('skinchanger:loadSkin', skin or {})
        EmoteCancel()
        Thread(false)
        SpawnPlayerCharCreator(spawnPoint)
        TriggerServerEvent("core:server:instanceCreator", false)
        TriggerServerEvent("core:server:createIdentity", identityData)
    end)
end)

RegisterNuiCallback("nui:char-creator:spawnpoint", function(data)
    if data.spawnPoint ~= nil then
        EmoteCancel()
        VFW.Cam:Destroy("cam_creator_lieuapparition")
        VFW.Nui.Creator(false)

        spawnPoint = data.spawnPoint.id

        Wait(250)

        SetEntityCoords(PlayerPedId(), Config.CharCreator[4].COH.x, Config.CharCreator[4].COH.y, Config.CharCreator[4].COH.z - 1)
        SetEntityHeading(PlayerPedId(), Config.CharCreator[4].COH.w)

        VFW.Cam:Create('cam_mugshot', Config.CharCreator[4])

        Wait(250)

        screenShot()

        temporaryDatas = {
            playerType = (sex == "F") and "Femme" or "Homme"
        }
    end
end)

RegisterNetEvent("core:client:spawnCharCreator", LoadNewCharCreator)
