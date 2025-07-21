local lastGamerTag = {}

RegisterNetEvent("Admin:gamerTag", function(enable)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local xPlayers = VFW.GetPlayers()

    for i = 1, #xPlayers do
        local playerId = xPlayers[i]

        if VFW.GamerTags[tonumber(playerId)] then
            if VFW.GamerTags[source] then
                VFW.GamerTags[source]["IS_GAMERTAG"] = enable
            end
            TriggerClientEvent("Admin:updateValue", source, playerId, VFW.GamerTags[tonumber(playerId)])
        end
    end

    VFW.StaffActionForActive(function(staff_player_source)
        if staff_player_source ~= source then
            TriggerClientEvent("Admin:updateValue", staff_player_source, source, VFW.GamerTags[tonumber(source)])
        end
    end)

    TriggerClientEvent("Admin:gamerTag", source, enable)

    lastGamerTag[source] = enable
end)

RegisterNetEvent("Admin:requestPlayerData")
AddEventHandler("Admin:requestPlayerData", function(targetId)
    local src = source
    if VFW.GamerTags[tonumber(targetId)] then
        TriggerClientEvent("Admin:updateValue", src, targetId, VFW.GamerTags[tonumber(targetId)])
    end
end)

function VFW.GetLastGamerTag(playerId)
    return lastGamerTag[playerId]
end
