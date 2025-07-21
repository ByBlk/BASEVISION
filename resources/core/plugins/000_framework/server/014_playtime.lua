local config = {
    debug = true,
}
local playersPlaytime = {}
local playersSessionStart = {}

MySQL.ready(function()
    if config.debug then
        console.debug("[^3PLAYTIME^7] Initialisation du système de temps de jeu")
    end

    MySQL.Async.fetchAll('SELECT identifier, total_playtime FROM player_global', {}, function(results)
        for _, row in ipairs(results) do
            playersPlaytime[row.identifier] = row.total_playtime or "00:00:00"
        end

        if config.debug then
            console.debug(("[^3PLAYTIME^7] Chargement initial terminé - %d joueurs chargés"):format(#results))
        end
    end)
end)

local function split(str, sep)
    if not str or type(str) ~= "string" then return {} end
    local fields = {}
    local pattern = string.format("([^%s]+)", sep or ":")
    str:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

local function timeToSeconds(timeStr)
    if not timeStr or timeStr == "" then return 0 end
    local parts = split(timeStr, ':')
    local hours = tonumber(parts[1] or 0)
    local minutes = tonumber(parts[2] or 0)
    local seconds = tonumber(parts[3] or 0)
    return hours * 3600 + minutes * 60 + seconds
end

local function secondsToTime(totalSeconds)
    totalSeconds = tonumber(totalSeconds) or 0
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = math.floor(totalSeconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function startPlaySession(source)
    local identifier = VFW.GetIdentifier(source)
    if not identifier then
        if config.debug then
            console.debug(("[^3PLAYTIME^7] Impossible de démarrer la session - identifiant non trouvé pour source %d"):format(source))
        end
        return false
    end

    playersSessionStart[identifier] = os.time()

    if config.debug then
        console.debug(("[^3PLAYTIME^7] Session démarrée pour %s (source: %d)"):format(identifier, source))
    end

    return true
end

local function savePlayerPlaytime(identifier)
    if not identifier or not playersPlaytime[identifier] then return false end

    MySQL.Async.execute("UPDATE player_global SET total_playtime = @playtime WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
        ['@playtime'] = playersPlaytime[identifier]
    }, function(rowsChanged)
        if config.debug and rowsChanged > 0 then
            console.debug(("[^3PLAYTIME^7] Temps de jeu sauvegardé pour %s"):format(identifier))
        end
    end)

    return true
end

local function stopPlaySession(source)
    local identifier = VFW.GetIdentifier(source)
    if not identifier or not playersSessionStart[identifier] then
        if config.debug then
            console.debug(("[^3PLAYTIME^7] Impossible d'arrêter la session - session non trouvée pour source %d"):format(source))
        end
        return false
    end

    local sessionStart = playersSessionStart[identifier]
    local sessionDuration = os.time() - sessionStart
    local currentPlaytime = timeToSeconds(playersPlaytime[identifier] or "00:00:00")
    local newPlaytime = currentPlaytime + sessionDuration

    playersPlaytime[identifier] = secondsToTime(newPlaytime)
    playersSessionStart[identifier] = nil

    savePlayerPlaytime(identifier)

    if config.debug then
        console.debug(("[^3PLAYTIME^7] Session arrêtée pour %s - durée: %d sec"):format(identifier, sessionDuration))
    end

    return true, secondsToTime(sessionDuration)
end

RegisterNetEvent('core:playerTimer:start')
AddEventHandler('core:playerTimer:start', function()
    startPlaySession(source)
end)

RegisterNetEvent('core:playerTimer:stop')
AddEventHandler('core:playerTimer:stop', function(sourceId)
    stopPlaySession(sourceId)
end)

function VFW.GetPlayerTime(source)
    local identifier = VFW.GetIdentifier(source)
    if not identifier then
        if config.debug then
            console.debug(("[^3PLAYTIME^7] GetPlayerTime - identifiant non trouvé pour source %d"):format(source))
        end
        return "00:00:00"
    end

    local baseTime = timeToSeconds(playersPlaytime[identifier] or "00:00:00")

    if playersSessionStart[identifier] then
        local sessionTime = os.time() - playersSessionStart[identifier]
        baseTime = baseTime + sessionTime
    end

    return secondsToTime(baseTime)
end
