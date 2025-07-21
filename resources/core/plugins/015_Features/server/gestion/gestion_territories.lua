RegisterNetEvent("core:territories:addTerritory", function(points, name)
    local src = source
    local isSouth = false
    local newPoints = {}

    for i = 1, #points do
        local v = points[i]
        local oldX = v[2]
        local oldY = v[1]
        newPoints[i] = {
            x = oldX,
            y = oldY,
            z = 0.0
        }
        isSouth = VFW.IsCoordsInSouth(newPoints[i])
    end

    VFW.TerritoriesServer.Create(name, newPoints, isSouth)
    TriggerClientEvent("vfw:showNotification", src, {
        type = 'VERT',
        content = "Le territoire "..name.." a été ajouté avec succès."
    })
end)

RegisterNetEvent("core:territories:setInfluence", function(name, value, zone)
    local src = source 
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local playerPerm = playerGlobal.permissions["gestion_crew"]
    if playerPerm then
        VFW.TerritoriesServer.SetInfluence(name, value, zone)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "L'influence de "..name.." a été modifiée avec succès."
        })
    end
end)

RegisterNetEvent("core:territories:updateTerrritory", function(datas)
    local src = source 
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local playerPerm = playerGlobal.permissions["gestion_crew"]
    if playerPerm then
        VFW.TerritoriesServer.UpdateTerritory(datas)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Le territoire "..(datas.oldName or datas.name).." a été modifié avec succès."
        })
    end
end)

RegisterNetEvent("core:territories:deleteTerritory", function(name)
    local src = source 
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local playerPerm = playerGlobal.permissions["gestion_crew"]
    if playerPerm then
        VFW.TerritoriesServer.DeleteTerritory(name)
    end
end)