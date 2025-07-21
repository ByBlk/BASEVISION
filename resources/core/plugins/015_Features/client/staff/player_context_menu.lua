local staffSubmenu = VFW.ContextAddSubmenu("ped", "Action Staff", function(ped)
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"]
end , {  color = {255, 64, 64}}, nil)

VFW.ContextAddButton("ped", "Voir dans le menu Admi", function(ped)
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(ped)
    ExecuteCommand(("openplayer %d"):format(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))))
end, {}, staffSubmenu)

local nom = false

VFW.ContextAddButton("ped", "Noms des Joueurs", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId == source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    nom = not nom
    if nom then
        VFW.ShowBlips()
        VFW.ShowNames()
        TriggerServerEvent("vfw:staff:useBlibName", true)
    else
        VFW.DestroyGamerTag()
        TriggerServerEvent("vfw:staff:useBlibName", false)
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Revive", function(ped)
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(ped)
    ExecuteCommand(("revive %d"):format(Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state.id))
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Heal", function(ped)
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(ped)
    ExecuteCommand(("heal %d"):format(Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state.id))
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Message", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local msg = VFW.Nui.KeyboardInput(true, "Message", "")

    if msg ~= nil or msg ~= "" then
        TriggerServerEvent("core:vnotif:createAlert:player", msg, playerId)
        VFW.ShowNotification({
            type = 'VERT',
            content = "Message chiant envoyé à ~s " .. playerId
        })
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Message chiant", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local message = VFW.Nui.KeyboardInput(true, "Message", "")

    if message then
        TriggerServerEvent("vfw:staff:message", playerId, message)
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Inventaire", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    VFW.OpenShearch(playerId)
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Screen", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))

end, {}, staffSubmenu)

local freeze = false

VFW.ContextAddButton("ped", "Freeze", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    freeze = not freeze
    TriggerServerEvent("core:FreezePlayer", playerId, freeze)
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Warn", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local reason = VFW.Nui.KeyboardInput(true, "Raison du warn")

    if reason ~= nil and reason ~= "" then
        TriggerServerEvent("core:warn:addwarn", reason, playerId)
        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous avez warn ~s " .. playerId
        })
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Kick", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local reason = VFW.Nui.KeyboardInput(true, "Raison du kick")

    if reason ~= nil and reason ~= "" then
        TriggerServerEvent("core:KickPlayer", playerId, reason)
        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous avez kick ~s " .. playerId
        })
    end
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Ban", function(ped)
    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
    local pId = GetPlayerServerId(isPlayer)
    local source = GetPlayerServerId(PlayerId())
    local isSamePlayer = pId ~= source
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and isSamePlayer
end, function(ped)
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local reason = VFW.Nui.KeyboardInput(true, "Raison", "")
    if not reason then return end
    local type = VFW.Nui.KeyboardInput(true, "Type de ban (jour, heure, perm)", "")
    if not type then return end
    local time
    if type ~= "perm" then
        time = VFW.Nui.KeyboardInput(true, "Durée", "")
        if not time then return end
    else
        time = 0
    end
    TriggerServerEvent("core:ban:banplayer", playerId, reason, time, GetPlayerServerId(PlayerId()), type)
    VFW.ShowNotification({
        type = 'VERT',
        content = "Joueur banni avec succès"
    })
end, {
    color = {255, 64, 64}
}, staffSubmenu)
