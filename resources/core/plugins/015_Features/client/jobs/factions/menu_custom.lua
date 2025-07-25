local lastJob = nil
local lastZone = {}
local lastBlip = {}
local lastVehicle = nil

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

local function loadMenuCustom()
    while not VFW.Jobs or not VFW.Jobs.Menu or not VFW.Jobs.Menu.CustomFaction do
        Wait(100)
    end

    while not next(VFW.Jobs.Menu.CustomFaction) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Menu.CustomFaction[lastJob] then return end

    local config = VFW.Jobs.Menu.CustomFaction[lastJob]

    local main_custom_menu = xmenu.create({ subtitle = "Custom", banner = ("https://cdn.eltrane.cloud/3838384859/assets/catalogues/headers/header_%s.webp"):format(lastJob) })
    local liveries_custom_menu = xmenu.createSub(main_custom_menu, { subtitle = "Motif" })
    local stickers_custom_menu = xmenu.createSub(main_custom_menu, { subtitle = "Stickers" })
    local extra_custom_menu = xmenu.createSub(main_custom_menu, { subtitle = "extra" })
    local color_custom_menu = xmenu.createSub(main_custom_menu, { subtitle = "Couleur" })
    local open = false

    local function OpenCustomMenu()
        if open then
            open = false
            xmenu.render(false)
        else
            open = true
            CreateThread(function()
                xmenu.render(main_custom_menu)

                while open do
                    xmenu.items(main_custom_menu, function()
                        addButton("Motif", { rightIcon = "chevron" }, {}, liveries_custom_menu)
                        addButton("Stickers", { rightIcon = "chevron" }, {}, stickers_custom_menu)
                        addButton("extra", { rightIcon = "chevron" }, {}, extra_custom_menu)
                        addButton("Couleur", { rightIcon = "chevron" }, {}, color_custom_menu)

                        onClose(function()
                            open = false
                            xmenu.render(false)
                        end)
                    end)

                    xmenu.items(liveries_custom_menu, function()
                        if GetNumVehicleMods(lastVehicle, 48) == 0 then
                            addSeparator("Pas de modification disponible")
                        else
                            for i = 1, GetNumVehicleMods(lastVehicle, 48) do
                                local name = GetLabelText(GetModTextLabel(lastVehicle, 48, i))
                                if name == "NULL" then
                                    name = "Original"
                                end

                                addButton(name, { rightIcon = "chevron" }, {
                                    onActive = function()
                                        SetVehicleMod(lastVehicle, 48, i, 0)
                                    end,
                                    onSelected = function()
                                        SetVehicleMod(lastVehicle, 48, i, 0)
                                    end
                                })
                            end
                        end
                    end)

                    xmenu.items(stickers_custom_menu, function()
                        if GetVehicleLiveryCount(lastVehicle) == -1 then
                            addSeparator("Pas de modification disponible")
                        else
                            for i = 1, GetVehicleLiveryCount(lastVehicle) do
                                local name = GetLabelText(GetLiveryName(lastVehicle, i))
                                if name == "NULL" then
                                    name = "Original"
                                end

                                addButton(name, { rightIcon = "chevron" }, {
                                    onActive = function()
                                        SetVehicleLivery(lastVehicle, i)
                                    end,
                                    onSelected = function()
                                        SetVehicleLivery(lastVehicle, i)
                                    end
                                })
                            end
                        end
                    end)

                    xmenu.items(extra_custom_menu, function()
                        local availableExtras = {}
                        extrasExist = false
                        for extra = 0, 20 do
                            if DoesExtraExist(lastVehicle, extra) then
                                availableExtras[extra] = extra
                                extrasExist = true
                            end
                        end

                        if not extrasExist then
                            addSeparator("Pas de modification disponible")
                        else
                            for i in pairs(availableExtras) do
                                addButton("EXTRA : " .. i, { rightIcon = "chevron" }, {
                                    onSelected = function()
                                        if IsVehicleExtraTurnedOn(lastVehicle, i) then
                                            SetVehicleExtra(lastVehicle, i, 1)
                                        else
                                            SetVehicleExtra(lastVehicle, i, 0)
                                        end
                                    end
                                })
                            end
                        end
                    end)

                    xmenu.items(color_custom_menu, function()
                        local colorOptions = {
                            { name = "Noir",         color = 0 },
                            { name = "Blanc",        color = 111 },
                            { name = "Violet",       color = 149 },
                            { name = "Jaune",        color = 42 },
                            { name = "Argent Ombré", color = 7 },
                            { name = "Rouge",        color = 27 },
                            { name = "Bleu",         color = 75 },
                            { name = "Vert",         color = 49 },
                            { name = "Brun clair",   color = 98 },
                        }

                        for _, colorData in pairs(colorOptions) do
                            local name = colorData.name
                            local color = colorData.color

                           addButton(name, { rightIcon = "chevron" }, {
                                onSelected = function()
                                    SetVehicleColours(lastVehicle, color, color)
                                end
                           })
                        end
                    end)

                    Wait(500)
                end
            end)
        end
    end

    function VFW.Jobs.Menu.MenuCustom(veh)
        lastVehicle = veh
        OpenCustomMenu()
    end

    lastZone = {}
    lastBlip = {}

    for _, pedData in ipairs(config.Point.Ped) do
        for _, coord in ipairs(pedData.coords) do
            local coords = vector(coord.x, coord.y, coord.z + 1.25)
            lastBlip[#lastBlip + 1] = createBlip(coords, pedData.blip.sprite, pedData.blip.color, pedData.blip.scale, pedData.blip.label)
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

    console.debug(("^3[%s]: ^7Menu Custom Faction ^3loaded"):format(VFW.PlayerData.job.label))
end

local function deletingZone()
    for i, zone in ipairs(lastZone) do
        if zone then
            Worlds.Zone.Remove(zone)
            lastZone[i] = nil
        end
    end

    VFW.RemoveInteraction(("menu_custom_%s"):format(lastJob))

    lastZone = {}
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
    deletingBlip()
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(1000)
    loadMenuCustom()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        deletingZone()
        deletingBlip()
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadMenuCustom()
end)
