local _names = {
    "torso_1", "torso_2", "bags_1", "tshirt_2", "shoes_1", "bproof_1", "chain_1", "decals_2", "chain_2",
    "arms_2", "arms", "shoes_2", "bags_2", "bproof_2", "pants_2", "tshirt_1", "decals_1", "pants_1",
    "helmet_1", "helmet_2", "glasses_1", "glasses_2", "ears_1", "ears_2", "mask_1", "mask_2",
    "bags_1", "bags_2", "bracelets_1", "bracelets_2", "watches_1", "watches_2", "gloves_1",
    "gloves_2"
}

local comp, i = {}, {}

local function GetData(restrict)
    TriggerEvent("skinchanger:getData", function(comp_, max)
        comp = {}
        local restrictSet = {}

        if restrict ~= nil then
            for _, name in ipairs(restrict) do
                restrictSet[name] = true
            end
        end

        for _, component in ipairs(comp_) do
            if restrict == nil or restrictSet[component.name] then
                table.insert(comp, component)
            end
        end

        for _, v in ipairs(comp) do
            i[v.name] = (v.value ~= 0) and (v.value + 1) or 1
            local max_value = max[v.name]
            if max_value then
                v.max = max_value
                v.table = {}
                for l = 0, max_value do
                    v.table[l + 1] = l
                end
            end
        end
    end)
end

local menu_gestionstock = ShUI.CreateMenu("", "Personnalisation personnage")
local menu_vetements = ShUI.CreateSubMenu(menu_gestionstock, "", "Personnalisation personnage")
local menu_skin = ShUI.CreateMenu("", "Personnalisation personnage")
local open = false

menu_gestionstock.Closed = function()
    open = false
    ShUI.Visible(menu_gestionstock, false)
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    TriggerEvent('skinchanger:loadSkin', skin or {})
end

menu_skin.Closed = function()
    open = false
    ShUI.Visible(menu_skin, false)
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    TriggerEvent('skinchanger:loadSkin', skin or {})
end

local OpenMenuGestionStock = function()
    if not open then
        open = true
        ShUI.Visible(menu_gestionstock, true)
        CreateThread(function()
            while open do
                ShUI.IsVisible(menu_gestionstock, function()
                    ShUI.Button("Vêtements", nil, {}, true, {
                        onSelected = function()
                            GetData(_names)
                        end
                    }, menu_vetements)

                    ShUI.Button("Crée une tenue", nil, {}, true, {
                        onSelected = function()
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent("core:server:gestionstock:Outfit", {
                                    renamed = skin['torso_1'],
                                    sex = skin.sex == 1 and "w" or "m",
                                    image = "",
                                    skin = {
                                        torso_2 = skin['torso_2'],
                                        bags_1 = skin['bags_1'],
                                        tshirt_2 = skin['tshirt_2'],
                                        shoes_1 = skin['shoes_1'],
                                        bproof_1 = skin['bproof_1'],
                                        chain_1 = skin['chain_1'],
                                        torso_1 = skin['torso_1'],
                                        decals_2 = skin['decals_2'],
                                        chain_2 = skin['chain_2'],
                                        arms_2 = skin['arms_2'],
                                        arms = skin['arms'],
                                        shoes_2 = skin['shoes_2'],
                                        bags_2 = skin['bags_2'],
                                        bproof_2 = skin['bproof_2'],
                                        pants_2 = skin['pants_2'],
                                        tshirt_1 = skin['tshirt_1'],
                                        decals_1 = skin['decals_1'],
                                        pants_1 = skin['pants_1'],
                                        helmet_1 = skin['helmet_1'],
                                        helmet_2 = skin['helmet_2'],
                                    }
                                })
                            end)
                        end
                    })

                    ShUI.Button("Copier le code la tenue", nil, {}, true, {
                        onSelected = function()
                            local name = VFW.Nui.KeyboardInput(true, "Nom de la tenue")
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                local tenueData = {
                                    id = name,
                                    varHaut = skin['torso_2'],
                                    sac = skin['bags_1'],
                                    varSousHaut = skin['tshirt_2'],
                                    chaussures = skin['shoes_1'],
                                    gpb = skin['bproof_1'],
                                    chaine = skin['chain_1'],
                                    haut = skin['torso_1'],
                                    varDecals = skin['decals_2'],
                                    varChaine = skin['chain_2'],
                                    varBras = skin['arms_2'],
                                    bras = skin['arms'],
                                    varChaussures = skin['shoes_2'],
                                    varSac = skin['bags_2'],
                                    varGpb = skin['bproof_2'],
                                    varPantalon = skin['pants_2'],
                                    sousHaut = skin['tshirt_1'],
                                    decals = skin['decals_1'],
                                    pantalon = skin['pants_1'],
                                }
                                TriggerEvent("addToCopy", '{ id = "'..tenueData.id..'", haut = '..tenueData.haut..', chaine = '..tenueData.chaine..', varDecals = '..tenueData.varDecals..', varHaut = '..tenueData.varHaut..', varGpb = '..tenueData.varGpb..', sac = '..tenueData.sac..', bras = '..tenueData.bras..', varChaussures = '..tenueData.varChaussures..', gpb = '..tenueData.gpb..', decals = '..tenueData.decals..', pantalon = '..tenueData.pantalon..', sousHaut = '..tenueData.sousHaut..', varChaine = '..tenueData.varChaine..', varSac = '..tenueData.varSac..', varSousHaut = '..tenueData.varSousHaut..', varBras = '..tenueData.varBras..', varPantalon = '..tenueData.varPantalon..', chaussures = '..tenueData.chaussures..' }')
                            end)
                        end
                    })
                end)

                ShUI.IsVisible(menu_vetements, function()
                    for k, v in pairs(comp) do
                        if v.table[1] ~= nil then
                            local label = v.label .. " (" .. v.max .. ")"

                            ShUI.List(label, v.table, i[v.name], nil, {}, true, {
                                onListChange = function(Index, item)
                                    if Index ~= nil then
                                        i[v.name] = Index
                                        TriggerEvent("skinchanger:change", v.name, Index - 1)
                                        GetData(_names)
                                    end
                                end,
                                onSelected = function()
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        if v.name == "torso_2" then
                                            TriggerServerEvent("core:server:gestionstock:Clothe", "top", {
                                                renamed = skin.torso_1,
                                                sex = skin.sex == 1 and "w" or "m",
                                                skin = {
                                                    ["tshirt_1"] = skin.tshirt_1,
                                                    ["tshirt_2"] = skin.tshirt_2,
                                                    ["torso_1"] = skin.torso_1,
                                                    ["torso_2"] = skin.torso_2,
                                                    ["arms"] = skin.arms,
                                                }
                                            })
                                        elseif v.name == "glasses_2" or v.name == "helmet_2" or v.name == "bags_2" or v.name == "mask_2" or v.name == "watches_2" or v.name == "bracelets_2" or v.name == "ears_2" then
                                            if v.name == "glasses_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.glasses_1,
                                                    type = "glasses",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.glasses_1,
                                                    var = skin.glasses_2
                                                })
                                            elseif v.name == "helmet_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.helmet_1,
                                                    type = "hat",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.helmet_1,
                                                    var = skin.helmet_2
                                                })
                                            elseif v.name == "bags_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.bags_1,
                                                    type = "bag",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.bags_1,
                                                    var = skin.bags_2
                                                })
                                            elseif v.name == "mask_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.mask_1,
                                                    type = "mask",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.mask_1,
                                                    var = skin.mask_2
                                                })
                                            elseif v.name == "watches_2" then
                                                TriggerServerEvent("ore:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.watches_1,
                                                    type = "watch",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.watches_1,
                                                    var = skin.watches_2
                                                })
                                            elseif v.name == "bracelets_2" then
                                                TriggerServerEvent("ore:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.bracelets_1,
                                                    type = "bracelet",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.bracelets_1,
                                                    var = skin.bracelets_2
                                                })
                                            elseif v.name == "ears_2" then
                                                TriggerServerEvent("ore:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.ears_1,
                                                    type = "earring",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.ears_1,
                                                    var = skin.ears_2
                                                })
                                            end
                                        else
                                            if v.name == "pants_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "bottom", {
                                                    renamed = skin.pants_1,
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.pants_1,
                                                    var = skin.pants_2
                                                })
                                            elseif v.name == "shoes_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "shoe", {
                                                    renamed = skin.shoes_1,
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.shoes_1,
                                                    var = skin.shoes_2
                                                })
                                            elseif v.name == "chain_2" then
                                                TriggerServerEvent("core:server:gestionstock:Clothe", "accessory", {
                                                    renamed = skin.chain_1,
                                                    type = "necklace",
                                                    sex = skin.sex == 1 and "w" or "m",
                                                    id = skin.chain_1,
                                                    var = skin.chain_2
                                                })
                                            end
                                        end
                                    end)
                                end
                            })
                        end
                    end
                end)
                Wait(1)
            end
        end)
    else
        open = false
        ShUI.Visible(menu_gestionstock, false)
    end
end

local OpenMenuSkin = function()
    if not open then
        open = true
        ShUI.Visible(menu_skin, true)
        CreateThread(function()
            while open do
                ShUI.IsVisible(menu_skin, function()
                    for k, v in pairs(comp) do
                        if v.table[1] ~= nil then
                            local label = v.label .. " (" .. v.max .. ")"

                            ShUI.List(label, v.table, i[v.name], nil, {}, true, {
                                onListChange = function(Index, item)
                                    if Index ~= nil then
                                        i[v.name] = Index
                                        TriggerEvent("skinchanger:change", v.name, Index - 1)
                                        GetData()
                                    end
                                end,
                                onSelected = function()
                                    TriggerEvent("skinchanger:getSkin", function(skin)
                                        TriggerServerEvent("vfw:skin:save", skin)
                                        TriggerEvent('skinchanger:loadSkin', skin or {})
                                    end)
                                end
                            })
                        end
                    end
                end)

                Wait(1)
            end
        end)
    else
        open = false
        ShUI.Visible(menu_skin, false)
    end
end

RegisterNetEvent("open:gestionstock", function()
    OpenMenuGestionStock()
end)

RegisterNetEvent("open:skin", function()
    GetData()
    OpenMenuSkin()
end)
