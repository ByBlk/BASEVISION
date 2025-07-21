RegisterNetEvent("core:activities:create", function(players, typejob)
    local xPlayer = VFW.GetPlayerFromId(source)

    if typejob == "chasse" then
        if not xPlayer.haveItem("weapon_musket", {}) then
            xPlayer.createItem("weapon_musket", 1)
            xPlayer.updateInventory()
            console.debug("musket gived")
        end
        if not xPlayer.haveItem("weapon_knife") then
            xPlayer.createItem("weapon_knife", 1)
            xPlayer.updateInventory()
            console.debug("knife gived")
        end
    end

    VFW.TriggerClientEvents("core:activities:create", players, typejob, players)
end)

RegisterNetEvent("core:activities:update", function(players, typejob, data)
    local src = source
    VFW.TriggerClientEvents("core:activities:update", players, typejob, data, src)
end)

RegisterNetEvent("core:activities:liveupdate", function(players, typejob, data)
    local src = source
    VFW.TriggerClientEvents("core:activities:liveupdate", players, typejob, data, src)
end)

RegisterNetEvent("core:activities:askJob", function(ply, label, forcePremium)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    --if forcePremium then
    --    if GetPlayer(ply):getSubscription() == 0 then
    --        TriggerClientEvent("__kpz::createNotification", src, {
    --            type = 'ROUGE',
    --            content = "Votre ami doit avoir le premium pour pouvoir participer."
    --        })
    --        return
    --    end
    --end
    TriggerClientEvent("core:activities:askJob", ply, label, src, xPlayer.getName())
end)

RegisterNetEvent("core:activities:acceptJob", function(psource)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    TriggerClientEvent("core:activities:acceptedJob", src, psource, xPlayer.getName())
    TriggerClientEvent("core:activities:acceptedJob", psource, src, xPlayer.getName())
end)

RegisterNetEvent("core:activities:kickPlayers", function(tablePly, typeJob, proper, info)
    local src = source
    if not proper then
        for k,v in pairs(tablePly) do
            if v then
                if type(v) == "number" then
                    TriggerClientEvent("core:activities:kickPlayer", v, typeJob, info)
                else
                    TriggerClientEvent("core:activities:kickPlayer", v.id, typeJob, info)
                end
            end
        end
    else
        VFW.TriggerClientEvents("core:activities:kickPlayer", tablePly, typeJob, info)
    end
end)

RegisterNetEvent("core:activities:SelectedKickPlayer", function(player, typeJob,info)
    local src = source
    TriggerClientEvent("core:activities:kickPlayer", player, typeJob, info)
end)