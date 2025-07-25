local lastZone, lastBlip, open = {}, {}, false
local lastVehicle = nil
local points = BLK.CustomVehiculePoints or {}

local xmenu = _G.xmenu
if not xmenu and VFW and VFW.xMenu then
    xmenu = VFW.xMenu
end


local paintCategories = BLK.paintCategories
local gtaColors = BLK.gtaColors

local wheelCategories = {
    {name = "Sport", id = 0},
    {name = "Muscle", id = 1},
    {name = "SUV", id = 2},
    {name = "Tout-terrain", id = 3},
    {name = "Tuner", id = 4},
    {name = "Motard", id = 5},
    {name = "Haut de gamme", id = 6},
}

local performanceMods = {
    { id = 11, label = "Moteur", max = 4 },
    { id = 12, label = "Freins", max = 3 },
    { id = 13, label = "Transmission", max = 3 },
    { id = 15, label = "Suspension", max = 3 },
}
local turboMod = { id = 18, label = "Turbo" }
local partsMods = {
    { id = 23, label = "Jantes", max = function(veh) return GetNumVehicleMods(veh, 23) end },
    { id = 14, label = "Klaxon", max = 50 },
}
local colorTypes = {
    { name = "Peinture principale", type = 0 },
    { name = "Peinture secondaire", type = 1 },
}
local windowTints = {
    "Aucune", "Pure Noir", "Fumée", "Fumée claire", "Vert", "Limo"
}
local extrasMax = 20

local prices = BLK.customVehiclePrices

local function getModLabel(modType, i)
    if modType == 23 then return "Type "..i end
    if modType == 14 then return "Klaxon "..i end
    return "Niveau "..i
end

local function getColorLabel(i)
    local r, g, b = GetVehicleCustomPrimaryColour(lastVehicle)
    return ("Couleur personnalisée (%d, %d, %d)"):format(r, g, b)
end

local function addBackButton(parent)
    addButton("← Retour", { rightIcon = "arrow-left" }, {}, parent)
end

local function createZone(name, position, radius, interactLabel, interactKey, interactIcons, action)
    local zone = Worlds.Zone.Create(position, radius, false, function()
        if action.onEnter then action.onEnter() end
        if action.onPress then VFW.RegisterInteraction(name, action.onPress) end
    end, function()
        VFW.RemoveInteraction(name)
        if action.onExit then action.onExit() end
    end, interactLabel, interactKey, interactIcons)
    return zone
end

local function filterColorsByCategory(category)
    local t = {}
    for _,c in ipairs(gtaColors) do
        if c.category == category then table.insert(t, c) end
    end
    return t
end

local initialState = nil
local validatedState = nil

local function getVehicleState(veh)
    local state = {}
    state.mods = {}
    for _, mod in ipairs(performanceMods) do
        state.mods[mod.id] = GetVehicleMod(veh, mod.id)
    end
    state.turbo = IsToggleModOn(veh, turboMod.id)
    state.wheelType = GetVehicleWheelType(veh)
    state.wheels = GetVehicleMod(veh, 23)
    state.klaxon = GetVehicleMod(veh, 14)
    state.colors = {GetVehicleColours(veh)}
    state.modColor1Type, state.modColor1, state.modColor1Pearl = GetVehicleModColor_1(veh)
    state.windowTint = GetVehicleWindowTint(veh)
    state.extras = {}
    for i=0, extrasMax do
        if DoesExtraExist(veh, i) then
            state.extras[i] = IsVehicleExtraTurnedOn(veh, i)
        end
    end
    return state
end

local function setVehicleState(veh, state)
    SetVehicleModKit(veh, 0)
    for id, v in pairs(state.mods) do
        SetVehicleMod(veh, id, v or -1, false)
    end
    ToggleVehicleMod(veh, turboMod.id, state.turbo)
    SetVehicleWheelType(veh, state.wheelType)
    SetVehicleMod(veh, 23, state.wheels or -1, false)
    SetVehicleMod(veh, 14, state.klaxon or -1, false)
    SetVehicleColours(veh, state.colors[1], state.colors[2])
    SetVehicleModColor_1(veh, state.modColor1Type, state.modColor1, state.modColor1Pearl)
    SetVehicleWindowTint(veh, state.windowTint)
    for i=0, extrasMax do
        if state.extras[i] ~= nil then
            SetVehicleExtra(veh, i, state.extras[i] and 0 or 1)
        end
    end
end

local pendingChanges = {
    mods = {},
    turbo = nil,
    wheelType = nil,
    wheels = nil,
    klaxon = nil,
    colors = {},
    modColor1Type = nil,
    modColor1 = nil,
    modColor1Pearl = nil,
    windowTint = nil,
    extras = {},
    total = 0
}

local function resetPendingChanges()
    pendingChanges = {
        mods = {},
        turbo = nil,
        wheelType = nil,
        wheels = nil,
        klaxon = nil,
        colors = {},
        modColor1Type = nil,
        modColor1 = nil,
        modColor1Pearl = nil,
        windowTint = nil,
        extras = {},
        total = 0
    }
end

local function updateTotal()
    local total = 0
    for k,v in pairs(pendingChanges.mods) do 
        if v.price then total = total + v.price end 
    end
    if pendingChanges.turbo and pendingChanges.turbo.price then total = total + pendingChanges.turbo.price end
    if pendingChanges.wheels and pendingChanges.wheels.price then total = total + pendingChanges.wheels.price end
    if pendingChanges.klaxon and pendingChanges.klaxon.price then total = total + pendingChanges.klaxon.price end
    if pendingChanges.colors[1] and pendingChanges.colors[1].price then total = total + pendingChanges.colors[1].price end
    if pendingChanges.windowTint and pendingChanges.windowTint.price then total = total + pendingChanges.windowTint.price end
    for _,v in pairs(pendingChanges.extras) do 
        if v.price then total = total + v.price end 
    end
    pendingChanges.total = total
end

local function applyPendingChanges(veh)
    SetVehicleModKit(veh, 0)
    
    -- Appliquer les mods de performance
    for id, data in pairs(pendingChanges.mods) do
        if data.value then
            SetVehicleMod(veh, id, data.value, false)
        end
    end
    
    -- Appliquer le turbo
    if pendingChanges.turbo and pendingChanges.turbo.value ~= nil then
        ToggleVehicleMod(veh, turboMod.id, pendingChanges.turbo.value)
    end
    
    -- Appliquer les jantes
    if pendingChanges.wheelType and pendingChanges.wheelType.value then
        SetVehicleWheelType(veh, pendingChanges.wheelType.value)
    end
    if pendingChanges.wheels and pendingChanges.wheels.value then
        SetVehicleMod(veh, 23, pendingChanges.wheels.value, false)
    end
    
    -- Appliquer le klaxon
    if pendingChanges.klaxon and pendingChanges.klaxon.value then
        SetVehicleMod(veh, 14, pendingChanges.klaxon.value, false)
    end
    
    -- Appliquer les couleurs
    if pendingChanges.colors[1] and pendingChanges.colors[1].value then
        local currentColor2 = select(2, GetVehicleColours(veh))
        SetVehicleColours(veh, pendingChanges.colors[1].value, currentColor2)
    end
    if pendingChanges.modColor1Type and pendingChanges.modColor1Type.value and pendingChanges.modColor1 and pendingChanges.modColor1.value then
        SetVehicleModColor_1(veh, pendingChanges.modColor1Type.value, pendingChanges.modColor1.value, pendingChanges.modColor1Pearl and pendingChanges.modColor1Pearl.value or 0)
    end
    
    -- Appliquer les vitres
    if pendingChanges.windowTint and pendingChanges.windowTint.value then
        SetVehicleWindowTint(veh, pendingChanges.windowTint.value)
    end
    
    -- Appliquer les extras
    for i, data in pairs(pendingChanges.extras) do
        if data.value ~= nil then
            SetVehicleExtra(veh, i, data.value and 0 or 1)
        end
    end
end

local function getModPrice(modType, level)
    if modType == 18 then -- Turbo
        return prices.performance[18]
    elseif prices.performance[modType] and prices.performance[modType][level] then
        return prices.performance[modType][level]
    end
    return 1000 -- Prix par défaut
end

local function getWheelPrice(wheelType)
    return prices.wheels[wheelType] or 1000
end

local function getColorPrice(category)
    return prices.colors[category] or 1000
end

local function getWindowPrice(level)
    return prices.windows[level] or 1000
end

local function getExtraPrice()
    return prices.extras
end

local function getKlaxonPrice()
    return prices.klaxon
end

local function OpenCustomVehMenu(veh)
    if open then open = false xmenu.render(false) return end
    open = true
    lastVehicle = veh
    SetVehicleModKit(lastVehicle, 0)
    initialState = getVehicleState(lastVehicle)
    validatedState = getVehicleState(lastVehicle)

    local main = xmenu.create({ subtitle = "MENU CUSTOM", banner = "https://cdn.eltrane.cloud/3838384859/assets/xmenu/headers/admin.png" })

    local perfMenu = xmenu.createSub(main, { subtitle = "Performance" })
    local partsMenu = xmenu.createSub(main, { subtitle = "Pièces" })
    local colorsMenu = xmenu.createSub(main, { subtitle = "Couleurs" })
    local windowsMenu = xmenu.createSub(main, { subtitle = "Vitres teintées" })
    local extrasMenu = xmenu.createSub(main, { subtitle = "Extras" })

    local perfSubs = {}
    for _, mod in ipairs(performanceMods) do
        local sub = xmenu.createSub(perfMenu, { subtitle = mod.label })
        perfSubs[mod.label] = sub
        xmenu.items(sub, function()
            for i = 0, mod.max do
                local price = getModPrice(mod.id, i)
                addButton(getModLabel(mod.id, i).." ("..price.."$)", {}, {
                    onActive = function()
                        SetVehicleModKit(lastVehicle, 0)
                        SetVehicleMod(lastVehicle, mod.id, i, false)
                    end,
                    onSelected = function()
                        pendingChanges.mods[mod.id] = { value = i, price = price }
                        updateTotal()
                        VFW.ShowNotification({type='VERT',content=mod.label.." ajouté au panier : "..i.." ("..price.."$)"})
                    end
                })
            end
        end)
    end
    local turboSub = xmenu.createSub(perfMenu, { subtitle = turboMod.label })
    local turboPrice = getModPrice(turboMod.id, 0)
    xmenu.items(turboSub, function()
        addButton("Activer/Désactiver Turbo ("..turboPrice.."$)", {}, {
            onActive = function() end,
            onSelected = function()
                local newState = not IsToggleModOn(lastVehicle, turboMod.id)
                pendingChanges.turbo = { value = newState, price = turboPrice }
                updateTotal()
                VFW.ShowNotification({type='VERT',content="Turbo "..(newState and "activé" or "désactivé").." ajouté au panier ("..turboPrice.."$)"})
            end
        })
    end)
    xmenu.items(perfMenu, function()
        for _, mod in ipairs(performanceMods) do
            addButton(mod.label, {}, {}, perfSubs[mod.label])
        end
        addButton("Turbo", {}, {}, turboSub)
    end)

    local jantesCatSubs = {}
    for _,cat in ipairs(wheelCategories) do
        local sub = xmenu.createSub(partsMenu, { subtitle = cat.name })
        jantesCatSubs[cat.name] = sub
        xmenu.items(sub, function()
            SetVehicleModKit(lastVehicle, 0)
            SetVehicleWheelType(lastVehicle, cat.id)
            local max = GetNumVehicleMods(lastVehicle, 23)
            local wheelPrice = getWheelPrice(cat.id)
            for i = 0, max-1 do
                local label = GetModTextLabel(lastVehicle, 23, i)
                if label and label ~= "" then
                    addButton((label:sub(1,1):upper()..label:sub(2):lower()).." ("..wheelPrice.."$)", {}, {
                        onActive = function()
                            SetVehicleModKit(lastVehicle, 0)
                            SetVehicleWheelType(lastVehicle, cat.id)
                            SetVehicleMod(lastVehicle, 23, i, false)
                        end,
                        onSelected = function()
                            pendingChanges.wheelType = { value = cat.id, price = wheelPrice }
                            pendingChanges.wheels = { value = i, price = wheelPrice }
                            updateTotal()
                            VFW.ShowNotification({type='VERT',content="Jante ajoutée au panier : "..label.." ("..cat.name..") ("..wheelPrice.."$)"})
                        end
                    })
                end
            end
        end)
    end
    local jantesMenu = xmenu.createSub(partsMenu, { subtitle = "Catégories de jantes" })
    xmenu.items(jantesMenu, function()
        for _,cat in ipairs(wheelCategories) do
            addButton(cat.name, {}, {}, jantesCatSubs[cat.name])
        end
    end)
    local klaxonSub = xmenu.createSub(partsMenu, { subtitle = "Klaxons" })
    xmenu.items(klaxonSub, function()
        for i = 0, partsMods[2].max do
            local klaxonPrice = getKlaxonPrice()
            addButton(getModLabel(partsMods[2].id, i).." ("..klaxonPrice.."$)", {}, {
                onActive = function()
                    SetVehicleModKit(lastVehicle, 0)
                    SetVehicleMod(lastVehicle, partsMods[2].id, i, false)
                end,
                onSelected = function()
                    pendingChanges.klaxon = { value = i, price = klaxonPrice }
                    updateTotal()
                    VFW.ShowNotification({type='VERT',content="Klaxon ajouté au panier : "..i.." ("..klaxonPrice.."$)"})
                end
            })
        end
    end)
    xmenu.items(partsMenu, function()
        addButton("Jantes", {}, {}, jantesMenu)
        addButton("Klaxons", {}, {}, klaxonSub)
    end)

    local colorCatSubs = {}
    for _,cat in ipairs(paintCategories) do
        local sub = xmenu.createSub(colorsMenu, { subtitle = cat.name })
        colorCatSubs[cat.name] = sub
        xmenu.items(sub, function()
            local filtered = filterColorsByCategory(cat.name)
            local colorPrice = getColorPrice(cat.name)
            for _,col in ipairs(filtered) do
                addButton(col.name.." ("..colorPrice.."$)", {}, {
                    onActive = function()
                        SetVehicleModKit(lastVehicle, 0)
                        SetVehicleColours(lastVehicle, col.id, select(2, GetVehicleColours(lastVehicle)))
                        SetVehicleModColor_1(lastVehicle, cat.type, col.id, 0)
                    end,
                    onSelected = function()
                        pendingChanges.colors[1] = { value = col.id, price = colorPrice }
                        pendingChanges.modColor1Type = { value = cat.type, price = 0 }
                        pendingChanges.modColor1 = { value = col.id, price = 0 }
                        pendingChanges.modColor1Pearl = { value = 0, price = 0 }
                        updateTotal()
                        VFW.ShowNotification({type='VERT',content="Couleur ajoutée au panier : "..col.name.." ("..colorPrice.."$)"})
                    end
                })
            end
        end)
    end
    xmenu.items(colorsMenu, function()
        for _,cat in ipairs(paintCategories) do
            addButton(cat.name, {}, {}, colorCatSubs[cat.name])
        end
    end)

    xmenu.items(windowsMenu, function()
        for i, label in ipairs(windowTints) do
            local windowPrice = getWindowPrice(i-1)
            addButton(label.." ("..windowPrice.."$)", {}, {
                onActive = function()
                    SetVehicleModKit(lastVehicle, 0)
                    SetVehicleWindowTint(lastVehicle, i-1)
                end,
                onSelected = function()
                    pendingChanges.windowTint = { value = i-1, price = windowPrice }
                    updateTotal()
                    VFW.ShowNotification({type='VERT',content="Teinte ajoutée au panier : "..label.." ("..windowPrice.."$)"})
                end
            })
        end
    end)

    xmenu.items(extrasMenu, function()
        for i = 0, extrasMax do
            if DoesExtraExist(lastVehicle, i) then
                local extraPrice = getExtraPrice()
                addButton("EXTRA : "..i.." ("..extraPrice.."$)", {}, {
                    onActive = function()
                        SetVehicleModKit(lastVehicle, 0)
                    end,
                    onSelected = function()
                        local newState = not IsVehicleExtraTurnedOn(lastVehicle, i)
                        pendingChanges.extras[i] = { value = newState, price = extraPrice }
                        updateTotal()
                        VFW.ShowNotification({type='VERT',content="Extra "..i..(newState and " activé" or " désactivé").." ajouté au panier ("..extraPrice.."$)"})
                    end
                })
            end
        end
    end)

    CreateThread(function()
        xmenu.render(main)
        while open do
            xmenu.items(main, function()
                addButton("Performance", {}, {}, perfMenu)
                addButton("Pièces", {}, {}, partsMenu)
                addButton("Couleurs", {}, {}, colorsMenu)
                addButton("Vitres teintées", {}, {}, windowsMenu)
                addButton("Extras", {}, {}, extrasMenu)
                addButton("Valider et payer ("..pendingChanges.total.."$)", { rightIcon = "chevron" }, {
                    onSelected = function()
                        if pendingChanges.total <= 0 then
                            VFW.ShowNotification({type='ROUGE',content="Aucune modification à valider !"})
                            return
                        end
                        local paid = TriggerServerCallback("core:server:customveh:pay", pendingChanges.total)
                        if paid then
                            -- Appliquer toutes les modifs définitivement
                            applyPendingChanges(lastVehicle)
                            validatedState = getVehicleState(lastVehicle)
                            VFW.ShowNotification({type='VERT',content="Customisation appliquée ! ("..pendingChanges.total.."$)"})
                            resetPendingChanges()
                            open = false
                            xmenu.render(false)
                        else
                            setVehicleState(lastVehicle, initialState)
                            VFW.ShowNotification({type='ROUGE',content="Pas assez d'argent !"})
                            resetPendingChanges()
                            open = false
                            xmenu.render(false)
                        end
                    end
                })
                onClose(function()
                    open = false
                    setVehicleState(lastVehicle, validatedState or initialState)
                    resetPendingChanges()
                    xmenu.render(false)
                end)
            end)
            Wait(500)
        end
        if not open then
            setVehicleState(lastVehicle, validatedState or initialState)
        end
    end)
end

CreateThread(function()
    for i,point in ipairs(points) do
        lastZone[#lastZone+1] = createZone(
            "customveh_"..i,
            point.coords,
            point.radius or 2.5,
            point.label,
            "E",
            "Vehicule",
            {
                onPress = function()
                    if not IsPedInAnyVehicle(VFW.PlayerData.ped, false) then VFW.ShowNotification({type='ROUGE',content='Vous devez être dans un véhicule !'}) return end
                    local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                    local job = VFW.PlayerData.job.name
                    local allowed = false
                    for _,j in ipairs(point.jobs) do if j==job then allowed=true break end end
                    if not allowed then VFW.ShowNotification({type='ROUGE',content='Accès réservé à ce métier !'}) return end
                    OpenCustomVehMenu(veh)
                end
            }
        )
        Wait(25)
    end
end)
