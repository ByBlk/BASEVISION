local allZone = {}
local allZoneShows = {}

VFW.TerritoriesServer = {
    FactionTotalInfluence = {},
    Crews = {},
    TotalTopFive = {
        week = {},
        month = {},
        global = {}
    }
}

local function isTableEmpty(tbl)
    return next(tbl) == nil
end

local function initInfluenceData(data)
    if not data or type(data) ~= "table" then
        return {}
    end
    for k, v in pairs(data) do
        if not v.influence then
            v.influence = 0
        end
    end
    return data
end

function VFW.TerritoriesServer.GetTopFive(zone)
    if not zone or not zone.global then
        return {}
    end

    local result = {}
    local sorted = {}
    for i, v in ipairs(zone.global) do
        sorted[i] = { leader = v.leader, influence = v.influence, color = v.color }
    end

    table.sort(sorted, function(a, b)
        return a.influence > b.influence
    end)

    for i = 1, 5 do
        if sorted[i] and sorted[i].influence ~= 12000 then
            result[i] = sorted[i]
        else
            result[i] = { leader = "Aucun", influence = 0, color = "#a2a2a3" }
        end
    end

    return result
end

function VFW.TerritoriesServer.GetWeeklyCrewRanks()
    local factionInfluences = {}

    for crewName, crewData in pairs(VFW.GetAllCrews()) do
        local influence = VFW.TerritoriesServer.GetCrewTotalInfluence(crewData.name)
        table.insert(factionInfluences, {
            name = crewData.name,
            influence = influence,
            createdAt = crewData.createdAt or 0
        })
    end

    table.sort(factionInfluences, function(a, b)
        if a.influence == b.influence then
            return a.createdAt < b.createdAt
        end
        return a.influence > b.influence
    end)

    for rank, faction in ipairs(factionInfluences) do
        local name = faction.name
        VFW.TerritoriesServer.Crews[name] = VFW.TerritoriesServer.Crews[name] or {}
        VFW.TerritoriesServer.Crews[name].weeklyRank = rank
        print(("Weekly rank for crew %s: %d (Influence: %d)"):format(name, rank, faction.influence))
    end

    return factionInfluences
end

function VFW.TerritoriesServer.GetCrewTotalInfluence(name)
    if not name then
        return 0
    end

    if VFW.TerritoriesServer.FactionTotalInfluence[name] then
        return VFW.TerritoriesServer.FactionTotalInfluence[name]
    end

    local totalInfluence = 0

    for zoneName, zoneData in pairs(allZone) do
        if zoneData.week then
            for _, crewData in pairs(zoneData.week) do
                if crewData.leader == name then
                    totalInfluence = totalInfluence + crewData.influence
                end
            end
        end
    end

    VFW.TerritoriesServer.FactionTotalInfluence[name] = totalInfluence
    return totalInfluence
end

function VFW.TerritoriesServer.GetTotalTopFive()
    local totalInfluence = {
        week = {},
        month = {},
        global = {}
    }

    for _, zone in pairs(allZone) do
        if zone.week then
            for _, crew in pairs(zone.week) do
                totalInfluence.week[crew.leader] = totalInfluence.week[crew.leader] or {
                    leader = crew.leader,
                    influence = 0,
                    color = crew.color or "#a2a2a3"
                }
                totalInfluence.week[crew.leader].influence = totalInfluence.week[crew.leader].influence + crew.influence
            end
        end

        if zone.month then
            for _, crew in pairs(zone.month) do
                totalInfluence.month[crew.leader] = totalInfluence.month[crew.leader] or {
                    leader = crew.leader,
                    influence = 0,
                    color = crew.color or "#a2a2a3"
                }
                totalInfluence.month[crew.leader].influence = totalInfluence.month[crew.leader].influence + crew.influence
            end
        end

        if zone.global then
            for _, crew in pairs(zone.global) do
                totalInfluence.global[crew.leader] = totalInfluence.global[crew.leader] or {
                    leader = crew.leader,
                    influence = 0,
                    color = crew.color or "#a2a2a3"
                }
                totalInfluence.global[crew.leader].influence = totalInfluence.global[crew.leader].influence + crew.influence
            end
        end
    end

    local result = {
        week = {},
        month = {},
        global = {}
    }

    for period, data in pairs(totalInfluence) do
        for _, crewData in pairs(data) do
            table.insert(result[period], crewData)
        end
        table.sort(result[period], function(a, b)
            return a.influence > b.influence
        end)
    end

    for period, data in pairs(result) do
        for i = 1, 5 do
            if not data[i] then
                data[i] = { leader = "Aucun", influence = 0, color = "#a2a2a3" }
            end
        end
    end

    VFW.TerritoriesServer.TotalTopFive = result
    return result
end

function VFW.TerritoriesServer.GetLeader(zone)
    if not zone or not zone.week or isTableEmpty(zone.week) then
        return "Aucun"
    end

    local sorted = {}
    for i, v in ipairs(zone.week) do
        sorted[i] = { leader = v.leader, influence = v.influence }
    end

    table.sort(sorted, function(a, b)
        return a.influence > b.influence
    end)

    return sorted[1].leader or "Aucun"
end

local function findIsSouthFromPolygon(polygon)
    if not polygon then
        return false
    end

    for i = 1, #polygon do
        local v = polygon[i]
        if type(v) == "table" and v.x and v.y then
            if VFW.IsCoordsInSouth({ y = v.x }) then
                return true
            end
        elseif type(v) == "table" and v[1] and v[2] then
            if VFW.IsCoordsInSouth({ y = v[1] }) then
                return true
            end
        end
    end
    return false
end

local function generateBasicTopFive()
    local result = {}
    for i = 1, 5 do
        result[i] = { leader = "Aucun", influence = 0, color = "#a2a2a3" }
    end
    return result
end

function VFW.TerritoriesServer.GetTerritoriesByLeader(leader)
    if not leader then
        return {}
    end

    local territories = {}
    for k, v in pairs(allZone) do
        if v.week then
            for _, crewData in ipairs(v.week) do
                if crewData.leader == leader then
                    table.insert(territories, k)
                    break
                end
            end
        end
    end
    return territories
end

function VFW.TerritoriesServer.UpdateTerritory(datas)
    if not datas or not datas.name then
        print("UpdateTerritory: Données manquantes")
        return
    end

    local oldName = datas.oldName
    local newName = datas.name

    if not oldName then
        -- Nouveau territoire
        allZone[newName] = {
            price1 = datas.price1,
            price2 = datas.price2,
            price3 = datas.price3,
            shop1 = datas.shop1,
            shop2 = datas.shop2,
            shop3 = datas.shop3,
            zone = datas.polygon,
            inSouth = findIsSouthFromPolygon(datas.polygon),
            global = {},
            month = {},
            week = {},
            needSave = true
        }

        table.insert(allZoneShows, {
            crewid = "Aucun",
            name = newName,
            polygon = datas.polygon,
            business = {
                { label = datas.shop1 or 'Commerce 1' },
            },
            zone = newName,
            location = findIsSouthFromPolygon(datas.polygon) and "Los Santos" or "Blaine County",
            topCrews = generateBasicTopFive(),
            image = "",
            options = { color = "#a2a2a3" },
        })
    else
        if allZone[oldName] then
            allZone[newName] = allZone[oldName]
            allZone[newName].name = newName
            allZone[newName].price1 = datas.price1
            allZone[newName].price2 = datas.price2
            allZone[newName].price3 = datas.price3
            allZone[newName].shop1 = datas.shop1
            allZone[newName].shop2 = datas.shop2
            allZone[newName].shop3 = datas.shop3
            allZone[newName].needSave = true
            allZone[oldName] = nil

            for i, zoneShow in ipairs(allZoneShows) do
                if zoneShow.name == oldName then
                    allZoneShows[i].name = newName
                    allZoneShows[i].business = {
                        { label = datas.shop1 or 'Commerce 1' },
                    }
                    allZoneShows[i].topCrews = VFW.TerritoriesServer.GetTopFive(allZone[newName])
                    allZoneShows[i].polygon = datas.polygon
                    allZoneShows[i].location = findIsSouthFromPolygon(datas.polygon) and "Los Santos" or "Blaine County"
                    allZoneShows[i].zone = newName
                    allZoneShows[i].crewid = newName
                    break
                end
            end
        end
    end

    MySQL.Async.execute("UPDATE territories SET name = @newName WHERE name = @oldName", {
        ["@newName"] = newName,
        ["@oldName"] = oldName
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print("Territoire " .. oldName .. " renommé en " .. newName)
            if source and source > 0 then
                TriggerClientEvent("vfw:showNotification", source, {
                    type = 'VERT',
                    content = "Le territoire " .. oldName .. " a été renommé en " .. newName,
                })
            end
        end
    end)

    TriggerClientEvent("core:territories:updateTerritory", -1, oldName, newName, allZone[newName])
end

function VFW.TerritoriesServer.DeleteTerritory(name)
    if not name or not allZone[name] then
        return
    end

    local territoryId = allZone[name].id
    MySQL.Async.transaction({
        "DELETE FROM influence WHERE zone = @id",
        "DELETE FROM territories WHERE id = @id"
    }, {
        ["@id"] = territoryId
    }, function(success)
        if success then
            print("Territoire " .. name .. " supprimé")

            for i = #allZoneShows, 1, -1 do
                if allZoneShows[i].name == name then
                    table.remove(allZoneShows, i)
                    break
                end
            end

            allZone[name] = nil

            if source and source > 0 then
                TriggerClientEvent("vfw:showNotification", source, {
                    type = "VERT",
                    content = name .. " a été supprimé",
                })
            end

            TriggerClientEvent("core:territories:deleteTerritory", -1, name)
        end
    end)
end

local function updateTerritory(crew, zone, influence)
    print("updateTerritory called with:", crew, zone, influence)

    if not crew then
        print("updateTerritory: crew is nil")
        return
    end

    if not zone then
        print("updateTerritory: zone is nil")
        return
    end

    if not allZone[zone] then
        print("updateTerritory: zone not found in allZone:", zone)
        print("Available zones:", json.encode(VFW.Table.GetKeys(allZone)))
        return
    end

    if not influence then
        print("updateTerritory: influence is nil")
        return
    end

    influence = tonumber(influence) or 0
    if influence < 1 then
        print("updateTerritory: influence is less than 1:", influence)
        return
    end

    print("updateTerritory: All checks passed, proceeding with update")

    VFW.TerritoriesServer.FactionTotalInfluence[crew] = (VFW.TerritoriesServer.FactionTotalInfluence[crew] or 0) + influence

    local crewData = VFW.GetCrewByName(crew)
    local color = crewData and crewData.getColor() or "#a2a2a3"

    local function updateInfluenceTable(tableName)
        if not allZone[zone][tableName] then
            allZone[zone][tableName] = {}
        end

        local found = false
        for i, v in ipairs(allZone[zone][tableName]) do
            if v.leader == crew then
                allZone[zone][tableName][i].influence = v.influence + influence
                found = true
                break
            end
        end

        if not found then
            table.insert(allZone[zone][tableName], {
                leader = crew,
                influence = influence,
                color = color
            })
        end
    end

    updateInfluenceTable("global")
    updateInfluenceTable("week")
    updateInfluenceTable("month")

    allZone[zone].needSave = true
    print("Territory marked for save:", zone, "ID:", allZone[zone].id)
    TriggerClientEvent("core:territories:update", -1, crew, zone, influence, allZone[zone].inSouth, color)
end

RegisterNetEvent("core:territories:update", updateTerritory)

local function formatNumber(num)
    if not num then
        return nil
    end
    return tonumber(string.format("%.1f", num))
end

local function formatNumberForFront(num)
    if not num then
        return nil
    end
    return tonumber(string.format("%.0f", num))
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2 * 60000) -- Toutes les 2 minutes

        for k, v in pairs(allZone) do
            if v.needSave then
                console.debug("Saving territory:", k, "with ID:", v.id)
                MySQL.Async.execute("UPDATE influence SET global = @global, month = @month, week = @week WHERE zone = @zone", {
                    ["@zone"] = v.id,
                    ["@global"] = json.encode(v.global or {}),
                    ["@month"] = json.encode(v.month or {}),
                    ["@week"] = json.encode(v.week or {})
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        console.debug("Territoire " .. k .. " sauvegardé avec succès")
                        allZone[k].needSave = false
                    else
                        print("Erreur: Aucune ligne mise à jour pour le territoire " .. k .. " (ID: " .. tostring(v.id) .. ")")
                    end
                end)
            end
        end
    end
end)

function VFW.TerritoriesServer.UpdateTerritoireOnWipeCrew(crew)
    if not crew then
        return
    end

    for k, v in pairs(allZone) do
        local needSave = false

        local function removeCrewFromTable(tbl)
            for i = #tbl, 1, -1 do
                if tbl[i].leader == crew then
                    table.remove(tbl, i)
                    needSave = true
                end
            end
        end

        if v.week then
            removeCrewFromTable(v.week)
        end
        if v.global then
            removeCrewFromTable(v.global)
        end
        if v.month then
            removeCrewFromTable(v.month)
        end

        if needSave then
            allZone[k].needSave = true
        end
    end
end

function GetAllCrewIds(leader)
    local crew = VFW.GetCrewByName(leader)
    if not crew then
        return {}
    end

    local ids = {}
    for _, member in ipairs(crew.members) do
        local xPlayer = VFW.GetPlayerFromIdentifier(member.identifier)
        if xPlayer then
            table.insert(ids, xPlayer.source)
        end
    end

    return ids
end

RegisterNetEvent("core:territories:notification", function(leader, action, zone, coords)
    local color = "#a2a2a3"
    if leader ~= "Aucun" then
        local crew = VFW.GetCrewByName(leader)
        if crew then
            color = crew.color
        end
    end
    VFW.TriggerClientEvents("core:territories:notification", GetAllCrewIds(leader), leader, action, zone, color, coords)
end)

function VFW.TerritoriesServer.SetInfluence(name, value, zone)
    if not name or not value or not zone then
        return
    end
    updateTerritory(name, zone, tonumber(value))
end

function VFW.TerritoriesServer.Create(name, zone, inSouth)
    if not name or not zone then
        return
    end

    allZone[name] = {
        zone = zone,
        inSouth = inSouth,
        global = {},
        month = {},
        week = {},
        needSave = false
    }

    MySQL.Async.execute("INSERT INTO territories (name, zone, south) VALUES (@name, @zone, @south)", {
        ["@name"] = name,
        ["@zone"] = json.encode(zone),
        ["@south"] = inSouth
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.fetchScalar("SELECT id FROM territories WHERE name = @name", {
                ["@name"] = name
            }, function(id)
                if id then
                    allZone[name].id = id
                    MySQL.Async.execute("INSERT INTO influence (zone, global, month, week) VALUES (@zone, @global, @month, @week)", {
                        ["@zone"] = id,
                        ["@global"] = json.encode({}),
                        ["@month"] = json.encode({}),
                        ["@week"] = json.encode({})
                    }, function()
                        print("Territoire " .. name .. " créé")
                        TriggerClientEvent("core:territories:addTerritory", -1, name, allZone[name])
                    end)
                end
            end)
        end
    end)
end

RegisterNetEvent("core:territories:create", VFW.TerritoriesServer.Create)

RegisterNetEvent("core:territories:deleteInfluence", function(name, id)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["gestion_territoires"] then
        return
    end

    MySQL.Async.execute("UPDATE influence SET month=@month, global=@global2, week=@week WHERE zone = @id", {
        ['@id'] = tonumber(id),
        ['@month'] = "[]",
        ['@global2'] = "[]",
        ['@week'] = "[]",
    }, function()
        if allZone[name] then
            allZone[name].global = {}
            allZone[name].week = {}
            allZone[name].month = {}
            allZone[name].needSave = true
        end
        TriggerClientEvent("core:territories:resetInfluence", -1, name, allZone[name] and allZone[name].inSouth or true)
    end)
end)

local function get2DCoords(zone)
    if not zone then
        return {}
    end

    local coordinates = {}
    for i = 1, #zone do
        local v = zone[i]
        if v.x and v.y then
            table.insert(coordinates, {
                tonumber(formatNumberForFront(v.y)),
                tonumber(formatNumberForFront(v.x))
            })
        elseif v[1] and v[2] then
            table.insert(coordinates, {
                tonumber(formatNumberForFront(v[1])),
                tonumber(formatNumberForFront(v[2]))
            })
        end
    end
    return coordinates
end

local numberOfTerritoriesPerFactions = {}

local function loadTerritories()
    MySQL.Async.fetchAll(
            "SELECT t.*, i.global, i.month, i.week " ..
                    "FROM territories t " ..
                    "INNER JOIN influence i ON t.id = i.zone",
            {},
            function(result)
                if not result or #result == 0 then
                    console.debug("Aucun territoire trouvé")
                    return
                end

                console.debug("Chargement de " .. #result .. " territoires")

                local date = os.date("*t")
                local isMonday = (date.wday - 1) == 1
                local isFirstDayOfMonth = date.day == 1

                for i = 1, #result do
                    local v = result[i]
                    local zoneData = {
                        id = v.id,
                        name = v.name,
                        zone = json.decode(v.zone),
                        inSouth = v.south,
                        resellIndice = v.resellIndice,
                        needSave = false,
                        shop1 = v.shop1,
                    }

                    if isMonday then
                        -- Lundi: reset semaine
                        zoneData.global = initInfluenceData(json.decode(v.global))
                        zoneData.month = initInfluenceData(json.decode(v.month))
                        zoneData.week = {}
                        zoneData.needSave = true
                    elseif isFirstDayOfMonth then
                        -- 1er du mois: reset mois
                        zoneData.global = initInfluenceData(json.decode(v.global))
                        zoneData.month = {}
                        zoneData.week = initInfluenceData(json.decode(v.week))
                        zoneData.needSave = true
                    else
                        -- Normal
                        zoneData.global = initInfluenceData(json.decode(v.global))
                        zoneData.month = initInfluenceData(json.decode(v.month))
                        zoneData.week = initInfluenceData(json.decode(v.week))
                    end

                    allZone[v.name] = zoneData
                    console.debug("Loaded territory:", v.name, "with ID:", v.id)

                    local zoneLeader = VFW.TerritoriesServer.GetLeader(zoneData)
                    local crew = VFW.GetCrewByName(zoneLeader)

                    table.insert(allZoneShows, {
                        crewid = zoneLeader,
                        name = v.name,
                        polygon = get2DCoords(zoneData.zone),
                        business = {
                            { label = zoneData.shop1 or 'Commerce 1' },
                            { label = zoneData.shop2 or 'Commerce 2' },
                            { label = zoneData.shop3 or 'Commerce 3' },
                        },
                        zone = v.name,
                        resellIndice = v.resellIndice,
                        location = zoneData.inSouth and "Los Santos" or "Blaine County",
                        topCrews = VFW.TerritoriesServer.GetTopFive(zoneData),
                        image = crew and crew.image or "",
                        options = {
                            color = crew and crew.color or "#a2a2a3",
                        },
                    })

                    if zoneData.week then
                        for _, crewData in pairs(zoneData.week) do
                            numberOfTerritoriesPerFactions[crewData.leader] = (numberOfTerritoriesPerFactions[crewData.leader] or 0) + 1
                        end
                    end
                end

                VFW.TerritoriesServer.GetTotalTopFive()
                VFW.TerritoriesServer.GetWeeklyCrewRanks()

                console.debug("Territoires chargés avec succès")
            end
    )
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then

        allZone = {}
        allZoneShows = {}
        numberOfTerritoriesPerFactions = {}

        loadTerritories()
    end
end)

-- Callbacks
RegisterServerCallback("core:territories:getTerritories", function()
    return allZone
end)

RegisterServerCallback("core:territories:getShowTerritories", function()
    return allZoneShows
end)

RegisterServerCallback("core:territories:getTerritory", function(source, named)
    return allZone[named]
end)

local function findZoneAtCoords(source, pX, pY)
    if not pX or not pY then
        return nil
    end

    for k, v in pairs(allZone) do
        if v.zone and VFW.IsPlayerInsideZone(v.zone, pX, pY) then
            return k
        end
    end
    return nil
end

RegisterServerCallback("core:territories:findZone", findZoneAtCoords)

RegisterServerCallback("core:territories:getTerritoryGlobal", function(source, named)
    return allZone[named] and allZone[named].global or {}
end)

local RevendiqueZone = {}
local function hasZoneBeenTaken(source, zonename)
    if not zonename then
        return true
    end

    if not RevendiqueZone[zonename] then
        RevendiqueZone[zonename] = true
        SetTimeout(15 * 60000, function()
            RevendiqueZone[zonename] = nil
        end)
        return false
    end
    return true
end

RegisterServerCallback("core:territories:hasZoneBeenTaken", hasZoneBeenTaken)

RegisterServerCallback("core:crew:getNumberOfTerritories", function(source)
    local player = VFW.GetPlayerFromId(source)
    if not player then
        return 0
    end

    local faction = player.getFaction()
    if not faction or faction.name == "nocrew" then
        return 0
    end

    return numberOfTerritoriesPerFactions[faction.name] or 0
end)

RegisterServerCallback("core:territories:getTopFive", function()
    return VFW.TerritoriesServer.TotalTopFive
end)

