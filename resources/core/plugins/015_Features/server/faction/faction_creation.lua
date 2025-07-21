while not VFW.Gestion do
    Wait(0)
end
VFW.Gestion.Organizations = {}

RegisterNetEvent("core:factions:askCreationCrew", function(name, color, hierarchie, crewBdd, devise, placement, type)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    local label = name
    local name = VFW.GestionCrew.LabelToName(name)

    console.debug("Type de faction", type)
    if VFW.Gestion.Organizations[name] then
        player.showNotification({
            type = 'ROUGE',
            content = "Le nom de groupe " .. name .. " est déjà utilisé."
        })
        return
    end
    console.debug("[^2INFO^7] Demande de création de faction reçue de la part de " .. player.getName() .. " pour le groupe " .. name .. ".")

    console.debug("crew bdd", crewBdd)
    ---@type Organization
    VFW.Gestion.Organizations[name] = CreateCrew(name, label, crewBdd, devise, {}, 0, placement, color, player.identifier, hierarchie, nil, nil, nil, 0, nil, false, "")

    player.showNotification({
        type = 'VERT',
        -- Merci l'IA hein psahtek le texte
        content = "Votre demande de création du groupe " .. name .. " a été transmise à l'équipe administrative. Vous serez notifié de la décision finale."
    })
    VFW.Admin.Alert("Création faction", "Le joueur " .. player.getName() .. " a demandé la création du groupe " .. name .. ".")
    VFW.Gestion.Organizations[name]:create()
end)

MySQL.ready(function()
    -- selected all from faction_ask
    local result = MySQL.Sync.fetchAll("SELECT * FROM crews ")

    for i = 1, #result do
        local v = result[i]
        VFW.Gestion.Organizations[v.name] = CreateCrew(v.name, v.label, v.type, v.devise, json.decode(v.perms), (v.xp or 0), v.place, v.color, v.creator, v.hierarchie, v.stockageId, v.garageId, v.laboratoryId, 0, v.craftId, v.state, v.image)
    end
end)