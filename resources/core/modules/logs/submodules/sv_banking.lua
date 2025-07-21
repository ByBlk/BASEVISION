while not logs do Wait(0) end
logs.banking = {}

function logs.banking.deposit(source, amount)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Dépôt d'argent**", color = 5763719, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Montant déposé", value = "$" .. VFW.Math.GroupDigits(amount), inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.banking.deposit, nil, embed)
end

function logs.banking.withdraw(source, amount)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Retrait d'argent**", color = 16711680, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Montant retiré", value = "$" .. VFW.Math.GroupDigits(amount), inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.banking.withdraw, nil, embed)
end