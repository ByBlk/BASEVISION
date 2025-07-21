VFW.PlayerMugshot = {}
local PlayerMugshotOffline = {}

RegisterNetEvent("vfw:server:setMugshot", function(url)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)


    local crew =  VFW.GetCrewByName(xPlayer.faction.name)
    if crew then
        crew.updatePlayerMugshot(xPlayer.getIdentifier(), url)
    end
    xPlayer.mugshot = url

    VFW.PlayerMugshot[xPlayer.identifier] = url
end)

RegisterServerCallback("vfw:server:getSkinByCharId", function(source, charId)
    local id = tonumber(charId)
    if not id then
        return nil, nil
    end

    local results = MySQL.Sync.fetchAll([[SELECT skin, tattoos, identifier FROM users WHERE id = @id]], { ["@id"] = id })

    if results[1] then
        local row = results[1]
        local skin = row.skin and json.decode(row.skin) or nil
        local tattoos = row.tattoos and json.decode(row.tattoos) or nil
        PlayerMugshotOffline[charId] = row.identifier
        return skin, tattoos
    else
        return nil, nil
    end
end)

RegisterNetEvent("vfw:server:setMugshotForChar", function(charId, url)
    local id = tonumber(charId)
    if not id then return end

    MySQL.Async.execute([[UPDATE users SET mugshot = @url WHERE id = @id]], { ["@url"] = url, ["@id"]  = id })

    VFW.PlayerMugshot[PlayerMugshotOffline[charId]] = url
    local results = MySQL.Sync.fetchAll("SELECT identifier FROM users WHERE id = @id", { ["@id"] = id })

    if results[1] then

        local row = results[1]
        local identifier = row.identifier
        local xPlayer = VFW.GetPlayerFromIdentifier(identifier)

        if xPlayer then

            xPlayer.mugshot = url
        end
    end
end)

RegisterServerCallback("vfw:server:getMugshot", function(source)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)

    return VFW.PlayerMugshot[xPlayer.identifier]
end)

RegisterServerCallback("vfw:server:getMugshotAll", function()
    return VFW.PlayerMugshot
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT identifier, mugshot FROM users ", function(result)
        if result[1] then
            for k, v in pairs(result) do
                local identifier = v.identifier
                local mugshot = v.mugshot

                VFW.PlayerMugshot[identifier] = mugshot
            end
        end
    end)
end)
