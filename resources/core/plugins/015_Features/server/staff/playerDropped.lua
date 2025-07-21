RegisterNetEvent('vfw:playerDropped', function(playerId, raison)
    local ped = GetPlayerPed(playerId)
    local pedCoords = GetEntityCoords(ped)
    local playerData = VFW.GetPlayerGlobalFromId(playerId)

    VFW.StaffActionForAll(function(staff_player_source)
        TriggerClientEvent("core:sendPlayerDroppedText", staff_player_source, {
            src = VFW.GetPermId(playerId),
            name = playerData.pseudo,
            raison = raison,
            coords = pedCoords
        })
    end)
end)
