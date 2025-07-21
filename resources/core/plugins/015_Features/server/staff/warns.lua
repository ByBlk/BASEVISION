local warns = {}

MySQL.ready(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM warns')

    for _, v in pairs(result) do
        warns[v.id] = {
            id = v.id,
            license = v.license,
            discord = v.discord,
            by = v.warned_by,
            at = v.warn_date,
            reason = v.reason
        }
    end
end)

local function generateWarnId()
    math.randomseed(os.time())
    return string.format("%dWARN%d", math.random(112, 9999), math.random(11, 99))
end

local function addWarn(license, discord, by, reason, playerId)
    if not license or not discord or not by or not reason then return end

    local warnData = {
        id = generateWarnId(),
        license = license,
        discord = "discord:" .. discord,
        by = by,
        at = os.time(),
        reason = reason
    }

    warns[warnData.id] = warnData

    MySQL.Async.insert("INSERT INTO warns (id, license, discord, warned_by, warn_date, reason) VALUES (@id, @license, @discord, @by, @at, @reason)", {
        ['@id'] = warnData.id,
        ['@license'] = warnData.license,
        ['@discord'] = warnData.discord,
        ['@by'] = warnData.by,
        ['@at'] = warnData.at,
        ['@reason'] = warnData.reason
    })

    local xPlayer = VFW.GetPlayerFromId(playerId)
    if not xPlayer then return end

    xPlayer.showNotification({
        type = 'VISION',
        name = "VISION",
        content = reason,
        typeannonce = "ADMINISTRATION",
        labeltype = "AVERTISSEMENT RECU",
        duration = 15
    })
end

local function removeWarn(id)
    if not warns[id] then return end

    warns[id] = nil
    MySQL.Async.execute('DELETE FROM warns WHERE id = @id', {
        ['@id'] = id
    }, function(rowsChanged)
        if rowsChanged == 0 then
            print(("Failed to remove warn %s from database"):format(id))
        end
    end)
end

local function getPlayerWarns(filterKey, filterValue)
    local playerWarns = {}

    for _, warn in pairs(warns) do
        if warn[filterKey] == ("%s:%s"):format(filterKey, filterValue) then
            table.insert(playerWarns, warn)
        end
    end

    return playerWarns
end

RegisterNetEvent("core:warn:addwarn", function(reason, playerId)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end
    local discord = GetPlayerIdentifierByType(playerId, "discord")
    local license = GetPlayerIdentifierByType(playerId, "license")
    if not discord or not license then return end

    addWarn(string.gsub(license, "license:", ""), string.gsub(discord, "discord:", ""), playerGlobal.pseudo, reason, playerId)
    -- Log Discord Warn
    if logs and logs.gestion and logs.gestion.adminWarn then
        logs.gestion.adminWarn(src, playerId, reason)
    end
end)

RegisterNetEvent("core:warn:removewarn", function(id)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end
    removeWarn(id)
end)

RegisterServerCallback("core:warn:getwarns", function(source)
    return warns
end)

RegisterServerCallback("core:warn:getwarnsbylicense", function(source, license)
    return getPlayerWarns('license', license)
end)

RegisterServerCallback("core:warn:getwarnsbydiscord", function(source, discord)
    return getPlayerWarns('discord', discord)
end)

function VFW.GetWarnsByLicense(license)
    return getPlayerWarns('license', license)
end

function VFW.GetWarnsByDiscord(discord)
    return getPlayerWarns('discord', discord)
end
