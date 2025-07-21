local jailTable = {}

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM players_jail', {}, function(result)
        for _, v in pairs(result) do
            jailTable[v.player_id] = {
                id = v.id,
                time = v.jail_time,
                startTime = os.time(),
                reason = v.reason,
                by = v.by
            }
        end
    end)
end)

local function generateJailId()
    math.randomseed(os.time())
    return string.format("%dJAIL%d", math.random(112, 9999), math.random(11, 99))
end

local function JailPlayer(identifier, playerId, jailTime, reason, by, callback)
    local result = MySQL.Sync.fetchAll('SELECT * FROM players_jail WHERE player_id = @player_id', {
        ['@player_id'] = identifier
    })

    if result[1] then
        MySQL.Async.execute('UPDATE players_jail SET jail_time = @jail_time WHERE player_id = @player_id', {
            ['@player_id'] = identifier,
            ['@jail_time'] = jailTime
        })

        jailTable[identifier] = {
            id = generateJailId(),
            time = jailTime,
            startTime = os.time(),
            reason = result[1].reason,
            by = result[1].by
        }
    else
        MySQL.Async.execute('INSERT INTO players_jail (id, player_id, jail_time, reason, `by`) VALUES (@id, @player_id, @jail_time, @reason, @by)', {
            ['@id'] = generateJailId(),
            ['@player_id'] = identifier,
            ['@jail_time'] = jailTime,
            ['@reason'] = reason,
            ['@by'] = by
        })

        jailTable[identifier] = {
            id = generateJailId(),
            time = jailTime,
            startTime = os.time(),
            reason = reason,
            by = by
        }
    end

    TriggerClientEvent('jail:sendToJail', playerId, jailTime)
    if callback then callback(true) end
end

local function ReleasePlayer(playerId, callback)
    local identifier = VFW.GetIdentifier(playerId)

    MySQL.Async.execute('DELETE FROM players_jail WHERE player_id = @player_id', {
        ['@player_id'] = identifier
    })

    jailTable[identifier] = nil

    TriggerClientEvent('jail:releaseFromJail', playerId)
    if callback then callback(true) end
end

local function SaveJailTime(idBdd)
    if jailTable[idBdd] then
        local remainingTime = jailTable[idBdd].time - (os.time() - jailTable[idBdd].startTime)

        MySQL.Async.execute('UPDATE players_jail SET jail_time = @jail_time WHERE player_id = @player_id', {
            ['@player_id'] = idBdd,
            ['@jail_time'] = remainingTime
        })

        jailTable[idBdd] = {
            time = remainingTime,
            startTime = os.time()
        }
    end
end

AddEventHandler('vfw:playerDropped', function(playerId, reason)
    local identifier = VFW.GetIdentifier(playerId)

    if identifier and jailTable[identifier] then
        SaveJailTime(identifier)
    end
end)

RegisterNetEvent('jail:load', function()
    local source = source
    local identifier = VFW.GetIdentifier(source)

    if jailTable[identifier] then
        JailPlayer(identifier, source, jailTable[identifier].time)
    end
end)

RegisterNetEvent('jail:sendToJail', function(id, jailTime, reason, by)
    local identifier = VFW.GetIdentifier(id)
    JailPlayer(identifier, id, jailTime, reason, by)
end)

RegisterNetEvent('jail:releasePlayer', function(id)
    ReleasePlayer(id)
end)

RegisterServerCallback("jail:getJails", function(source)
    return jailTable
end)
