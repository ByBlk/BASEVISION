local territoireSud = {}
local territoireNord = {}
local TerritoriesNeedSave = {}

VFW.Territories = {}
VFW.Territories.Cache = {
    Territories = {},
    Crews = {}
}

NotifImageIA = { -- Will be used in multiple files
    {name = "Howard", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719711790727268image.webp"},
    {name = "Shawn", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719763242254376image.webp"},
    {name = "Denise", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719811581628517image.webp"},
    {name = "Miguel", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719857416962099image.webp"},
    {name = "Allison", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719913427714168image.webp"},
    {name = "Jerry", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720076607098911image.webp"},
    {name = "Lester", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719957442744320image.webp"},
    --{name = "Bruce", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720455784763454image.webp"},
    {name = "Emma", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720160707084380image.webp"},
    {name = "Bonnie", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720276474073248image.webp"},
    {name = "Kenji", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720365225545800image.webp"},
    {name = "Franck", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720396473126943image.webp"},
    {name = "Andrew", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720455784763454image.webp"},
    {name = "Ricky", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720545312198726image.webp"},
    {name = "Jimmy", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720600668610681image.webp"},
    {name = "Crystal", lien = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187720700258164756image.webp"},
}

local function InsertTerritoireInTable(name, zone)
    if zone.inSouth == true then
        territoireSud[name] = zone
    else
        territoireNord[name] = zone
    end
end

local function DeleteTerritoireInTable(name)
    if territoireSud[name] ~= nil then
        territoireSud[name] = nil
    else
        territoireNord[name] = nil
    end
end

---@field public
function VFW.Territories.GetZoneByName(name)
    if (not name) then return end
    local foundzone
    if territoireSud[name] or territoireNord[name] then
        if TerritoriesNeedSave[name] then
            TerritoriesNeedSave[name] = nil
            foundzone = TriggerServerCallback("core:territories:getTerritory", name)
            if foundzone.inSouth then
                foundzone = territoireSud[name]
            else
                foundzone = territoireNord[name]
            end
        else
            if territoireSud[name] then
                foundzone = territoireSud[name]
            elseif territoireNord[name] then
                foundzone = territoireNord[name]
            end
        end
    else
        foundzone = TriggerServerCallback("core:territories:getTerritory", name)
        if foundzone.inSouth then
            territoireSud[name] = foundzone
        else
            territoireNord[name] = foundzone
        end
    end
    return foundzone
end

---@public field
function VFW.Territories.GetZoneByPlayer()
    if not VFW.PlayerData or not VFW.PlayerData.ped then
        console.debug("Error: PlayerData or ped not available")
        return nil
    end

    local coords = GetEntityCoords(VFW.PlayerData.ped, true)
    if not coords then
        console.debug("Error: Could not get player coordinates")
        return nil
    end

    local pX, pY, z = table.unpack(coords)
    local foundzone = TriggerServerCallback("core:territories:findZone", pX, pY)
    return foundzone
end

-- OLD but if we want it
-- function DrawWall(x1, y1, z1, x2, y2, z2, r, g, b, a)
--     local color = {r, g, b, a}
--     local a = {x = x1, y = y1, z = z1}
--     local b = {x = x1, y = y1, z = z1+50.0}
--     local c = {x = x2, y = y2, z = z2}
--     local d = {x = x2, y = y2, z = z2+50.0}
--     DrawPoly(a.x, a.y, a.z,
--              b.x, b.y, b.z,
--              c.x, c.y, c.z,
--              color[1], color[2], color[3], color[4])
--     DrawPoly(c.x, c.y, c.z,
--              b.x, b.y, b.z,
--              a.x, a.y, a.z,
--              color[1], color[2], color[3], color[4])
--     DrawPoly(b.x, b.y, b.z,
--              c.x, c.y, c.z,
--              d.x, d.y, d.z,
--              color[1], color[2], color[3], color[4])
--     DrawPoly(d.x, d.y, d.z,
--              c.x, c.y, c.z,
--              b.x, b.y, b.z,
--              color[1], color[2], color[3], color[4])
-- end

RegisterNetEvent("core:territories:updateTerritory", function(oldName, newName, data)
    Wait(500)
    VFW.Territories.Cache.Territories = {}
    if (not oldName) then return end

    if not territoireNord[oldName] and not territoireSud[oldName] then
        territoireNord[newName] = data
        territoireSud[newName] = data
    end
    console.debug("A Staff member has updated the territory " .. oldName)
end)

RegisterNetEvent("core:territories:addTerritory", function(name, zone)
    InsertTerritoireInTable(name, zone)
end)

RegisterNetEvent("core:territories:deleteTerritory", function(name)
    VFW.Territories.Cache.Territories = {}
    DeleteTerritoireInTable(name)
end)

local function addInfluenceInTerritoireClient(crew, zone, influence, south, color)
    local shouldgo = true
    if not territoireSud[zone] and not territoireNord[zone] then
        local territoire = TriggerServerCallback("core:territories:getTerritory", zone)
        if territoire then
            if territoire.inSouth then
                territoireSud[zone] = territoire
            else
                territoireSud[zone] = territoire
            end
        else
            shouldgo = false
            return
        end
    end
    if not shouldgo then return end
    local tableExistG, tableExistW, tableExistM = false, false, false
    if south then
        if territoireSud[zone] ~= nil then
            for i = 1, #territoireSud[zone].global do
                local v = territoireSud[zone].global[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistG = true
                end
            end
            for i = 1, #territoireSud[zone].week do
                local v = territoireSud[zone].week[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistW = true
                end
            end
            for i = 1, #territoireSud[zone].month do
                local v = territoireSud[zone].month[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistM = true
                end
            end
            if not tableExistG then
                territoireSud[zone].global[#territoireSud[zone].global + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
            if not tableExistW then
                territoireSud[zone].week[#territoireSud[zone].week + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
            if not tableExistM then
                territoireSud[zone].month[#territoireSud[zone].month + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
        end
    else
        if territoireNord[zone] ~= nil then
            for i = 1, #territoireNord[zone].global do
                local v = territoireNord[zone].global[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistG = true
                end
            end
            for i = 1, #territoireNord[zone].week do
                local v = territoireNord[zone].week[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistW = true
                end
            end
            for i = 1, #territoireNord[zone].month do
                local v = territoireNord[zone].month[i]
                if v.leader == crew then
                    v.influence = v.influence + influence
                    tableExistM = true
                end
            end
            if not tableExistG then
                territoireNord[zone].global[#territoireNord[zone].global + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
            if not tableExistW then
                territoireNord[zone].week[#territoireNord[zone].week + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
            if not tableExistM then
                territoireNord[zone].month[#territoireNord[zone].month + 1] = {
                    leader = crew,
                    influence = influence,
                    color = color
                }
            end
        end
    end
end

RegisterNetEvent("core:territories:update", function(crew, zone, influence, south, color)
    TerritoriesNeedSave[zone] = true
    console.debug("updateTerritory", crew, zone, influence, south, color)
    addInfluenceInTerritoireClient(crew, zone, influence, south, color)
end)

local function resetInfluenceInTerritoireClient(zone, south)
    if not territoireSud[zone] and not territoireNord[zone] then
        territoire = TriggerServerCallback("core:territories:getTerritory", zone)
        if territoire then
            if territoire.inSouth then
                territoireSud[zone] = territoire
            else
                territoireSud[zone] = territoire
            end
        else
            return
        end
    end
    if south then
        if territoireSud[zone] ~= nil then
            for i = 1, #territoireSud[zone].global do
                territoireSud[zone].global[i].influence = 0
            end
            for i = 1, #territoireSud[zone].week do
                territoireSud[zone].week[i].influence = 0
            end
            for i = 1, #territoireSud[zone].month do
                territoireSud[zone].month[i].influence = 0
            end
        else
            if territoireNord[zone] ~= nil then
                for i = 1, #territoireNord[zone].global do
                    territoireNord[zone].global[i].influence = 0
                end
                for i = 1, #territoireNord[zone].week do
                    territoireNord[zone].week[i].influence = 0
                end
                for i = 1, #territoireNord[zone].month do
                    territoireNord[zone].month[i].influence = 0
                end
            end
        end
    else
        if territoireNord[zone] ~= nil then
            for i = 1, #territoireNord[zone].global do
                territoireNord[zone].global[i].influence = 0
            end
            for i = 1, #territoireNord[zone].week do
                territoireNord[zone].week[i].influence = 0
            end
            for i = 1, #territoireNord[zone].month do
                territoireNord[zone].month[i].influence = 0
            end
        end
    end
end

RegisterNetEvent("core:territories:resetInfluence", function(name, south)
    TerritoriesNeedSave[zone] = true
    resetInfluenceInTerritoireClient(name, south)
end)

local function getFirstZone(zone)
    local result = {}

    if not zone then return end

    table.sort(zone, function(a,b)
        if not a or not b then return end
        return a.influence>b.influence
    end)

    for i = 1, 1 do
        if zone[i] then
            table.insert(result, zone[i])
        else
            table.insert(result, { leader= "Aucun", influence = 0, color = "#a2a2a3"})
        end
    end

    return result
end

function ActionInTerritoire(crew, zone, influence, action, south)
    if crew == "nocrew" then
        print("ActionInTerritoire: crew is nocrew, skipping")
        return
    end

    if not zone then
        print("ActionInTerritoire: zone is nil, skipping")
        return
    end

    print("ActionInTerritoire called:", crew, zone, influence, action, south)

    local territoire
    if not territoireSud[zone] and not territoireNord[zone] then
        territoire = TriggerServerCallback("core:territories:getTerritory", zone)
        print("Retrieved territory from server:", json.encode(territoire), zone)
        if territoire then
            if territoire.inSouth then
                territoireSud[zone] = territoire
            else
                territoireNord[zone] = territoire  -- ✅ FIXED: Correct assignment
            end
        else
            print("Territory not found on server:", zone)
            return
        end
    end

    -- Use cached territory if available
    territoire = territoire or territoireSud[zone] or territoireNord[zone]

    if territoire then
        print("Triggering server update for territory:", zone)
        TriggerServerEvent("core:territories:update", crew, zone, tonumber(influence), south)

        local zoneSelect = nil
        if south then
            console.debug("Go check sud")
            if territoireSud[zone] then
                zoneSelect = territoireSud[zone].global
            end
        else
            console.debug("Go check north")
            if territoireNord[zone] then
                zoneSelect = territoireNord[zone].global
            end
        end
        console.debug("Good checks")
        console.debug("zoneSelect", zoneSelect, json.encode(zoneSelect))
        local first = getFirstZone(zoneSelect)
        console.debug("Check first")
        if first and first[1] then
            if first[1].leader ~= "Aucun" then
                console.debug("first[1].leader et ton crew", first[1].leader, crew)
                if first[1].leader ~= crew then
                    console.debug("Envoi notif au leader")
                    TriggerServerEvent("core:territories:notification", first[1].leader, action, zone, GetEntityCoords(VFW.PlayerData.ped))
                end
            end
        end
    end
end

local blipColors <const> = {
    {id = 0, color = {255, 255, 255}}, -- Blanc
    {id = 1, color = {255, 0, 0}},     -- Rouge
    {id = 2, color = {0, 255, 0}},     -- Vert
    {id = 3, color = {0, 255, 255}},   -- Bleu clair
    {id = 7, color = {153, 0, 153}},   -- Violet
    {id = 5, color = {0, 0, 255}},     -- Bleu
    {id = 17, color = {255, 102, 0}},   -- Orange
    {id = 15, color = {0, 255, 255}},   -- Cyan
    {id = 22, color = {128, 128, 128}}, -- Gris
    {id = 8, color = {255, 0, 255}},  -- Rose
    {id = 11, color = {144, 238, 144}},-- Vert clair
    {id = 40, color = {169, 169, 169}},-- Gris foncé
    {id = 31, color = {139, 69, 19}},  -- Marron
    {id = 29, color = {0, 0, 139}},    -- Bleu foncé
    {id = 43, color = {50, 205, 50}},  -- Vert fluo
}

local function colorDistanceRGB(color1, color2)
    return math.sqrt((color1[1] - color2[1])^2 + (color1[2] - color2[2])^2 + (color1[3] - color2[3])^2)
end

local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))}
end

local function findClosestBlipColor(hex)
    local rgb = hexToRGB(hex)
    local closestBlip = blipColors[1]
    local minDistance = colorDistanceRGB(rgb, closestBlip.color)

    for i = 1, #blipColors do
        local blip = blipColors[i]
        local dist = colorDistanceRGB(rgb, blip.color)
        if dist < minDistance then
            minDistance = dist
            closestBlip = blip
        end
    end

    return closestBlip.id
end

local NotifsTexts <const> = {
    [1] = "Yo, y’a un mec qui est en train de voler l’oseille du Binco !",
    [2] = "Hey, y'a un man qui braque ta supérette !",
    [3] = "Salut, des gens braque la fleeca de chez toi !",
    [4] = "Yo, des mecs vole un camion sur ta zone !", -- Braquage Brinks
    [5] = "Big up, j'ai cru voir des gens voler des sacs à main des tantines de chez toi !", -- Vol à l'arracher
    [6] = "Yo, un mec vole un véhicule dans les parages, viens vérifier !", -- Vol de véhicules
    [7] = "Hey, j'ai cru apercevoir des gars vendre de la cam dans le coin, amènes toi !", -- Vente de drogue
    [8] = "Salut, y'a des tags sur mon mur, viens t'en occuper !", -- Tags
    [9] = "Holà, quelqu'un braque une entreprise de ton territoire !", -- Braquage Entreprise
    [10] = "Bonjour, l'ATM de chez toi ce fait braquer !", -- ATM
    [11] = "Coucou, des voyous braquent le Vangelico !", -- Vangelico
    [12] = "Yo, y'a une agression au couteau vers chez toi !", -- Raquette
    [13] = "Yo bro, j'ai vu un mec cambrioler une baraque vers chez toi !", -- Cambriolage
    [14] = "Hey, un crew revendique ta zone, va les dégager !", -- Debut Revendication
    [15] = "Un crew revendique désormais ta zone !", -- Fin Revendication
}

local function IllegalNotification(_type, zone, color, coords)
    local notifdata = NotifImageIA[math.random(1, #NotifImageIA)]
    if (not NotifsTexts[_type]) then return end
    VFW.ShowNotification({
        type = "ILLEGAL",
        name = notifdata.name,
        label = zone,
        labelColor = color,
        logo = notifdata.lien,
        mainMessage = NotifsTexts[_type],
        duration = 10,
    })
    if _type == 14 then
        CreateThread(function()
            local blipRevendication = AddBlipForRadius(coords + vector3(math.random(3,6), math.random(3,6), 0.0), 100.0)
            SetBlipSprite(blipRevendication, 9)
            SetBlipColour(blipRevendication, findClosestBlipColor(color) or 22)
            SetBlipAlpha(blipRevendication, 100)
            Wait(2*60000)
            RemoveBlip(blipRevendication)
        end)
    end
end

RegisterNetEvent("core:territories:notification", function(leader, action, zone, color, coords)
    if VFW.PlayerData.faction.name == leader then
        IllegalNotification(action, zone, color, coords)
    end
end)