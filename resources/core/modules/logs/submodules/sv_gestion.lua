while not logs do Wait(0) end
logs.gestion = {}

function logs.gestion.adminMenu(source, action, target, details)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Menu admin / Give**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Action", value = action or "Inconnue", inline = true },
        { name = "Cible", value = target or "Aucune", inline = true },
        { name = "Détails", value = details or "Aucun", inline = false }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminMenu, nil, embed)
end

function logs.gestion.adminGive(source, target, item, amount)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Give**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true },
        { name = "Item", value = item, inline = true },
        { name = "Quantité", value = tostring(amount), inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminGive, nil, embed)
end

function logs.gestion.adminBan(source, target, reason, duration)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Ban**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true },
        { name = "Raison", value = reason, inline = true },
        { name = "Durée", value = duration or "Permanent", inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminBan, nil, embed)
end

function logs.gestion.adminKick(source, target, reason)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Kick**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true },
        { name = "Raison", value = reason, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminKick, nil, embed)
end

function logs.gestion.adminWarn(source, target, reason)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Warn**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true },
        { name = "Raison", value = reason, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminWarn, nil, embed)
end

function logs.gestion.adminJail(source, target, reason, duration)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Jail**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true },
        { name = "Raison", value = reason, inline = true },
        { name = "Durée", value = tostring(duration), inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminJail, nil, embed)
end

function logs.gestion.adminUnjail(source, target)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Unjail**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminUnjail, nil, embed)
end

function logs.gestion.adminWipe(source, target)
    local xPlayer = VFW.GetPlayerFromId(source)
    local embed = { { title = "**Admin Wipe**", color = 15158332, fields = {
        { name = "Admin", value = xPlayer.getName() .. " (<@"..VFW.GetIdentifier(source)..">)", inline = true },
        { name = "Cible", value = target, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.adminWipe, nil, embed)
    print("test")
end

