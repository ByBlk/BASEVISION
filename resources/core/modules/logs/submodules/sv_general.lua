while not logs do Wait(0) end
logs.general = {}

function logs.general.connect(source, uniqueId)
    local embed = { { title = "**Connexion**", color = 5763719, fields = {
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Unique", value = tostring(uniqueId), inline = true },
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.general.connect, nil, embed)
end

function logs.general.disconnect(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Déconnexion**", color = 16711680, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.general.disconnect, nil, embed)
end

function logs.general.selectCharacter(source, character)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Changement de personnage**", color = 16705372, fields = {
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Personnage sélectionné", value = character, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.general.selectCharacter, nil, embed)
end

function logs.general.armurerieBuy(source, item, price)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Achat d'armurerie**", color = 5763719, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Objet acheté", value = item, inline = true },
        { name = "Prix", value = price.."$", inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.general.armurerie, nil, embed)
end

function logs.general.death(source, killer, reason)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local killerName = killer and GetPlayerName(killer) or "Inconnu"
    local reasonText = reason or "Inconnue"
    local embed = { { title = "**Mort d'un joueur**", color = 16711680, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Tueur", value = killerName, inline = true },
        { name = "Raison", value = reasonText, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.death, nil, embed)
end 