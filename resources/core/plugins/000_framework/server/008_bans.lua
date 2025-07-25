local bans = {}
local BAN_CACHE_TTL = 300
local lastCacheUpdate = 0
local PERMISSION_BAN = "ban"
local PERMISSION_BAN_OFFLINE = "ban_offline"
local MAX_TEMP_BAN_DURATION = 900

local function HasPermission(source, requiredLevel)
    local player = VFW.GetPlayerGlobalFromId(source)
    return player and player.permissions and player.permissions[requiredLevel]
end

local function CheckTimeRemaining(expirationTime)
    if expirationTime == 0 then return 0, 0, 0 end

    local remaining = expirationTime - os.time()
    if remaining <= 0 then return 0, 0, 0 end

    local d = math.floor(remaining / 86400)
    remaining = remaining % 86400
    local h = math.floor(remaining / 3600)
    remaining = remaining % 3600
    local m = math.ceil(remaining / 60)

    return d, h, m
end

function VFW.IsPlayerBanned(source)
    local currentTime = os.time()

    if currentTime - lastCacheUpdate > BAN_CACHE_TTL then
        MySQL.Async.fetchAll('SELECT * FROM ban', {}, function(result)
            bans = {}
            for _, v in ipairs(result) do
                bans[v.id] = {
                    id = v.id,
                    raison = v.raison,
                    ids = json.decode(v.ids),
                    by = v.by,
                    expiration = tonumber(v.expiration),
                    banDate = v.date
                }
            end
            lastCacheUpdate = currentTime
        end)
    end

    local ids = GetPlayerIdentifiers(source)
    if not ids or #ids == 0 then return false end

    local tokens = GetNumPlayerTokens(source)
    for i = 1, tokens do
        local token = GetPlayerToken(source, i)
        if token and token ~= "" then
            table.insert(ids, "token:" .. token)
        end
    end

    local idsToCheck = {}
    for _, v in ipairs(ids) do
        if v and not v:find("ip:") then
            idsToCheck[v] = true
        end
    end

    for banId, banData in pairs(bans) do
        for _, banIdentifier in ipairs(banData.ids) do
            if idsToCheck[banIdentifier] then
                if banData.expiration == 0 or banData.expiration > currentTime then
                    local d, h, m = CheckTimeRemaining(banData.expiration)
                    return true, banData, d, h, m
                else
                    MySQL.Async.execute("DELETE FROM ban WHERE id = @id", {['@id'] = banId})
                    bans[banId] = nil
                    return false
                end
            end
        end
    end

    return false
end

local function BanPlayer(source, raison, time2, by, heureoujour, data, callback)
    if not raison or raison == "" then
        if callback then callback(false, "Raison manquante") end
        return
    end

    if time2 and time2 > MAX_TEMP_BAN_DURATION then
        time2 = MAX_TEMP_BAN_DURATION
    end

    local ids = GetPlayerIdentifiers(source)
    if not ids or #ids == 0 then
        if by ~= 0 then
            TriggerClientEvent("__blk::createNotification", by, {
                type = 'ROUGE',
                duration = 15,
                content = "Ce joueur n'a pas d'identifiant valide. Le ban n'a pas été effectué.",
            })
        end
        if callback then callback(false, "Identifiants manquants") end
        return
    end

    local tokens = GetNumPlayerTokens(source)
    for i = 1, tokens do
        local token = GetPlayerToken(source, i)
        if token and token ~= "" then
            table.insert(ids, "token:" .. token)
        end
    end

    if by ~= 0 then
        if not HasPermission(by, PERMISSION_BAN) then
            if callback then callback(false, "Permission insuffisante") end
            return
        end
    end

    local expiration
    heureoujour = heureoujour and string.lower(heureoujour) or "heures"

    if heureoujour == "perm" then
        expiration = 32508259200
    elseif time2 then
        if heureoujour == "heures" then
            expiration = os.time() + (time2 * 3600)
        elseif heureoujour == "jours" then
            expiration = os.time() + (time2 * 86400)
        else
            if callback then callback(false, "Format de durée invalide") end
            return
        end
    else
        if callback then callback(false, "Durée manquante") end
        return
    end

    local added = os.date("%d/%m/%Y %X")
    local timetext = heureoujour ~= "perm" and (time2 .. " " .. heureoujour) or "Permanent"
    local idban = "BAN" .. math.random(1000, 9999) .. os.time() % 10000

    local name = by == 0 and "CONSOLE" or GetPlayerName(by)
    if data and data.username and data.username ~= "" then
        name = data.username
    end

    DropPlayer(source, ("Vous avez été banni.\nRaison: %s\nDurée: %s\nID du ban: %s"):format(raison, timetext, idban))

    local newBan = {
        id = idban,
        raison = raison,
        ids = ids,
        by = name,
        expiration = expiration,
        banDate = added
    }

    bans[idban] = newBan

    MySQL.Async.insert("INSERT INTO ban (id, ids, raison, `by`, expiration, date) VALUES (@id, @ids, @raison, @by, @expiration, @date)", {
        ['@id'] = idban,
        ['@ids'] = json.encode(ids),
        ['@raison'] = raison,
        ['@by'] = name,
        ['@expiration'] = expiration,
        ['@date'] = added
    }, function(insertId)
        if callback then callback(true, idban) end
        -- sendEmbed("ban", name, raison, added, expiration, ids, idban)
    end)
end

local function UnBanPlayer(id, callback)
    if not id or id == "" then
        if callback then callback(false, "ID manquant") end
        return
    end

    if bans[id] then
        bans[id] = nil
        MySQL.Async.execute("DELETE FROM ban WHERE id = @id", { ['@id'] = id }, function(affectedRows)
            if callback then callback(affectedRows > 0, affectedRows > 0 and "Ban supprimé" or "Ban non trouvé") end
        end)
    else
        if callback then callback(false, "Ban non trouvé dans le cache") end
    end
end

local function BanOfflinePlayer(identifiers, raison, time, by, heureoujour, data, callback)
    if not HasPermission(by, PERMISSION_BAN_OFFLINE) then
        if callback then callback(false, "Permission insuffisante") end
        return
    end

    if not identifiers or identifiers == "" then
        if callback then callback(false, "Identifiants manquants") end
        return
    end

    local ids = {}
    local licenseFound = false

    for identifier in identifiers:gmatch("([^,]+)") do
        identifier = identifier:trim()
        if identifier ~= "" then
            table.insert(ids, identifier)
            if not licenseFound and identifier:find("license:") then
                licenseFound = true
            end
        end
    end

    if #ids == 0 then
        if callback then callback(false, "Aucun identifiant valide") end
        return
    end

    local expiration
    heureoujour = heureoujour and string.lower(heureoujour) or "heures"

    if heureoujour == "perm" then
        expiration = 32508259200
    elseif time then
        if heureoujour == "heures" then
            expiration = os.time() + (time * 3600)
        elseif heureoujour == "jours" then
            expiration = os.time() + (time * 86400)
        else
            if callback then callback(false, "Format de durée invalide") end
            return
        end
    else
        if callback then callback(false, "Durée manquante") end
        return
    end

    local added = os.date("%d/%m/%Y %X")
    local timetext = heureoujour ~= "perm" and (time .. " " .. heureoujour) or "Permanent"
    local idban = "OFF" .. math.random(1000, 9999) .. "BAN" .. os.time() % 10000

    local name = by == 0 and "CONSOLE" or GetPlayerName(by)
    if data and data.username and data.username ~= "" then
        name = data.username
    end

    if licenseFound then
        local players = VFW.GetPlayers()
        for _, playerId in ipairs(players) do
            local playerIds = GetPlayerIdentifiers(playerId)
            for _, playerIdentifier in ipairs(playerIds) do
                if VFW.Table.TableContains(ids, playerIdentifier) then
                    DropPlayer(playerId, ("Vous avez été banni.\nRaison: %s\nDurée: %s\nID du ban: %s"):format(raison, timetext, idban))
                    break
                end
            end
        end
    end

    local newBan = {
        id = idban,
        raison = raison,
        ids = ids,
        by = name,
        expiration = expiration,
        banDate = added
    }

    bans[idban] = newBan

    MySQL.Async.insert("INSERT INTO ban (id, ids, raison, `by`, expiration, date) VALUES (@id, @ids, @raison, @by, @expiration, @date)", {
        ['@id'] = idban,
        ['@ids'] = json.encode(ids),
        ['@raison'] = raison,
        ['@by'] = name,
        ['@expiration'] = expiration,
        ['@date'] = added
    }, function(insertId)
        if callback then callback(true, idban) end
        -- sendEmbed("ban", name, raison, added, expiration, ids, idban)
    end)
end

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM ban', {}, function(result)
        bans = {}
        for _, v in ipairs(result) do
            bans[v.id] = {
                id = v.id,
                raison = v.raison,
                ids = json.decode(v.ids),
                by = v.by,
                expiration = tonumber(v.expiration),
                banDate = v.date
            }
        end
        lastCacheUpdate = os.time()
    end)
end)

RegisterServerCallback("core:ban:getbans", function(source)
    local src = source
    if HasPermission(src, PERMISSION_BAN) then
        return bans
    end
end)

RegisterNetEvent("core:ban:banplayer", function(id, raison, time, by, heureoujour)
    local src = source
    if HasPermission(src, PERMISSION_BAN) then
        BanPlayer(tonumber(id), tostring(raison), tonumber(time), tonumber(by), tostring(heureoujour))
    end
end)

RegisterNetEvent("core:ban:banofflineplayer", function(identifiers, raison, time, by, heureoujour)
    local src = source
    if HasPermission(src, PERMISSION_BAN_OFFLINE) then
        BanOfflinePlayer(identifiers, tostring(raison), tonumber(time), tonumber(by), tostring(heureoujour))
    end
end)

RegisterNetEvent("core:ban:unbanplayer", function(id)
    local src = source
    if HasPermission(src, PERMISSION_BAN) then
        UnBanPlayer(id)
    end
end)
