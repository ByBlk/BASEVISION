while not logs do Wait(0) end
logs.society = {}

function logs.society.startService(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    local jobLabel, jobName, gradeLabel, grade, playerName = job.label or "Inconnu", job.name or "inconnu", job.grade_label or "N/A", job.grade or 0, xPlayer.getName()
    local embed = { { title = "**Prise de service**", color = 5763719, fields = {
        { name = "Nom du joueur", value = playerName, inline = true }, { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Job", value = jobLabel .. " (`" .. jobName .. "`)", inline = true },
        { name = "Grade", value = gradeLabel .. " (`" .. tostring(grade) .. "`)", inline = true },
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.society.startService, nil, embed)
end

function logs.society.stopService(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    local jobLabel, jobName, gradeLabel, grade, playerName = job.label or "Inconnu", job.name or "inconnu", job.grade_label or "N/A", job.grade or 0, xPlayer.getName()
    local embed = { { title = "**Fin de service**", color = 16711680, fields = {
        { name = "Nom du joueur", value = playerName, inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Job", value = jobLabel .. " (`" .. jobName .. "`)", inline = true },
        { name = "Grade", value = gradeLabel .. " (`" .. tostring(grade) .. "`)", inline = true },
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.society.stopService, nil, embed)
end

function logs.society.startCraft(source, item, quantity)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    local jobLabel, jobName, gradeLabel, grade, playerName = job.label or "Inconnu", job.name or "inconnu", job.grade_label or "N/A", job.grade or 0, xPlayer.getName()
    local embed = { { title = "**Craft lancé**", color = 5793266, fields = {
        { name = "Nom du joueur", value = playerName, inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Job", value = jobLabel .. " (`" .. jobName .. "`)", inline = true },
        { name = "Grade", value = gradeLabel .. " (`" .. tostring(grade) .. "`)", inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Item", value = item, inline = true },
        { name = "Quantité", value = quantity, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.society.startCraft, nil, embed)
end 

function logs.society.finishCraft(source, item, quantity)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    local jobLabel, jobName, gradeLabel, grade, playerName = job.label or "Inconnu", job.name or "inconnu", job.grade_label or "N/A", job.grade or 0, xPlayer.getName()
    local embed = { { title = "**Craft terminé**", color = 5763719, fields = {
        { name = "Nom du joueur", value = playerName, inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "ID Temporaire", value = tostring(source), inline = true },
        { name = "ID Unique", value = tostring(VFW.GetPermId(source)), inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Job", value = jobLabel .. " (`" .. jobName .. "`)", inline = true },
        { name = "Grade", value = gradeLabel .. " (`" .. tostring(grade) .. "`)", inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Item", value = item, inline = true },
        { name = "Quantité", value = quantity, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.society.finishCraft, nil, embed)
end

function logs.society.reset(source, society)
    local playerName = (source == 0) and "Système" or GetPlayerName(source)
    local embed = { { title = "**Reset de la société**", color = 16711680, fields = {
        { name = "Provenance", value = playerName, inline = true },
        { name = " ", value = " ", inline = false },
        { name = "Société", value = society, inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.society.reset, nil, embed)
end

function logs.society.companySafe(source, company)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Coffre entreprise**", color = 3447003, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = "Entreprise", value = company or "Inconnue", inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.companySafe, nil, embed)
end

function logs.society.vehicleSafe(source, vehicle)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Coffre véhicule**", color = 3447003, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = "Véhicule", value = vehicle or "Inconnu", inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.vehicleSafe, nil, embed)
end

function logs.society.crewSafe(source, crew)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local embed = { { title = "**Coffre Crew/Stockage**", color = 3447003, fields = {
        { name = "Nom du joueur", value = xPlayer.getName(), inline = true },
        { name = "Discord", value = tostring("<@"..VFW.GetIdentifier(source)..">"), inline = true },
        { name = "Crew/Stockage", value = crew or "Inconnu", inline = true }
    }, footer = { text = os.date("%d/%m/%Y à %H:%M:%S") } } }
    sendToDiscord(logs.config.events.crewSafe, nil, embed)
end