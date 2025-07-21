local open = false

local function openMenuCustom()
    console.debug(VFW.PlayerData.job.name)
    local main = xmenu.create({ subtitle = "ACTION DISPONIBLE", banner = "https://cdn.eltrane.cloud/alkiarp/assets/catalogues/headers/header_"..VFW.PlayerData.job.name..".webp" })

    local performance = xmenu.createSub(main, { subtitle = "ACTION DISPONIBLE" })
    local performance_moteur = xmenu.createSub(performance, { subtitle = "MOTEUR - NIVEAUX" })
    local performance_frein = xmenu.createSub(performance, { subtitle = "FREIN - NIVEAUX" })
    local performance_transmission = xmenu.createSub(performance, { subtitle = "TRANSMISSION - NIVEAUX" })
    local performance_suspension = xmenu.createSub(performance, { subtitle = "SUSPENSION - NIVEAUX" })
    local performance_turbo = false

    local esthetique = xmenu.createSub(main, { subtitle = "ACTION DISPONIBLE" })
    local esthetique_klaxon = xmenu.createSub(esthetique, { subtitle = "KLAXON" })
    local esthetique_peinture = xmenu.createSub(esthetique, { subtitle = "PEINTURE" })
    local esthetique_peinture_index_interieur = 1
    local esthetique_peinture_index_tableau = 1
    local esthetique_phare = xmenu.createSub(esthetique, { subtitle = "PHARE" })
    local esthetique_phare_checkbox = false
    local esthetique_roue = xmenu.createSub(esthetique, { subtitle = "ROUE" })
    local esthetique_vitre = xmenu.createSub(esthetique, { subtitle = "VITRE" })
    local esthetique_interieur = xmenu.createSub(esthetique, { subtitle = "INTÉRIEUR" })
    local esthetique_plaque = xmenu.createSub(esthetique, { subtitle = "PLAQUE" })
    local esthetique_extra = xmenu.createSub(esthetique, { subtitle = "EXTRA" })
    
    CreateThread(function()
        open = true
        while open do
            xmenu.items(main, function()
                addButton("Performance", { rightIcon = "chevron" }, {}, performance)
                addButton("Esthétique", { rightIcon = "chevron" }, {}, esthetique)
                addLine()
                addButton("Valider la customisation", { rightIcon = "chevron" }, {})
                addButton("Annuler la customisation", { rightIcon = "chevron" }, {})
                onClose(function()
                    xmenu.render(false)
                    open = false
                end)
            end)
            xmenu.items(performance, function()
                addButton("Moteur", { rightIcon = "chevron" }, {}, performance_moteur)
                addButton("Frein", { rightIcon = "chevron" }, {}, performance_frein)
                addButton("Transmission", { rightIcon = "chevron" }, {}, performance_transmission)
                addButton("Suspension", { rightIcon = "chevron" }, {}, performance_suspension)
                addCheckbox("Moteur", performance_turbo, { rightIcon = "chevron" }, {
                    onChange = function(value)
                        performance_turbo = value
                        console.debug("Moteur : " .. tostring(value))
                    end,
                })
            end)
            xmenu.items(performance_moteur, function()
                addButton("Moteur - Niveau n°0", {}, {}, function()
                end)
                addButton("Moteur - Niveau n°1", {}, {}, function()
                end)
                addButton("Moteur - Niveau n°2", {}, {}, function()
                end)
                addButton("Moteur - Niveau n°3", {}, {}, function()
                end)
                addButton("Moteur - Niveau n°4", {}, {}, function()
                end)
            end)
            xmenu.items(performance_frein, function()
                addButton("Frein - Niveau n°0", {}, {}, function()
                end)
                addButton("Frein - Niveau n°1", {}, {}, function()
                end)
                addButton("Frein - Niveau n°2", {}, {}, function()
                end)
                addButton("Frein - Niveau n°3", {}, {}, function()
                end)
                addButton("Frein - Niveau n°4", {}, {}, function()
                end)
            end)
            xmenu.items(performance_transmission, function()
                addButton("Transmission - Niveau n°0", {}, {}, function()
                end)
                addButton("Transmission - Niveau n°1", {}, {}, function()
                end)
                addButton("Transmission - Niveau n°2", {}, {}, function()
                end)
                addButton("Transmission - Niveau n°3", {}, {}, function()
                end)
                addButton("Transmission - Niveau n°4", {}, {}, function()
                end)
            end)
            xmenu.items(performance_suspension, function()
                addButton("Suspension - Niveau n°0", {}, {}, function()
                end)
                addButton("Suspension - Niveau n°1", {}, {}, function()
                end)
                addButton("Suspension - Niveau n°2", {}, {}, function()
                end)
                addButton("Suspension - Niveau n°3", {}, {}, function()
                end)
                addButton("Suspension - Niveau n°4", {}, {}, function()
                end)
            end)

            xmenu.items(esthetique, function()
                addButton("Klaxon", {}, {}, esthetique_klaxon)
                addButton("Peinture", {}, {}, esthetique_peinture)
                addButton("Phares", {}, {}, esthetique_phare)
                addButton("Roue", {}, {}, esthetique_roue)
                addButton("Vitre", {}, {}, esthetique_vitre)
                addButton("Intérieur", {}, {}, esthetique_interieur)
                addButton("Plaque", {}, {}, esthetique_plaque)
                addButton("Extra", {}, {}, esthetique_extra)
            end)
            
            xmenu.items(esthetique_klaxon, function()
                for i = 1, 10 do
                    addButton("Klaxon n°"..i, {}, {}, function()
                        console.debug("Klaxon n°"..i)
                    end)
                end
            end)
            
            xmenu.items(esthetique_peinture, function()
                addButton("Couleur principale", { rightIcon = "chevron" }, {})
                addButton("Couleur secondaire", { rightIcon = "chevron" }, {})
                addButton("Nacrage", { rightIcon = "chevron" }, {})
                addButton("Motif", { rightIcon = "chevron" }, {})
                addButton("Stickers", { rightIcon = "chevron" }, {})
                addList("Couleur intérieur", { "Rouge", "Bleu", "Vert", "Jaune" }, esthetique_peinture_index_interieur, {}, {
                    onChange = function(value)
                        esthetique_peinture_index_interieur = value
                        console.debug("Couleur intérieur : " .. value)
                    end,
                    onSelected = function(value)
                        console.debug("Couleur intérieur : " .. value)
                    end
                })
                addList("Couleur tableau de bord", { "Rouge", "Bleu", "Vert", "Jaune" }, esthetique_peinture_index_tableau, {}, {
                    onChange = function(value)
                        esthetique_peinture_index_tableau = value
                        console.debug("Couleur intérieur : " .. value)
                    end,
                    onSelected = function(value)
                        console.debug("Couleur intérieur : " .. value)
                    end
                })
            end)
            
            xmenu.items(esthetique_phare, function()
                addCheckbox("Phare xénon", esthetique_phare_checkbox, {}, {
                    onChange = function(value)
                        esthetique_phare_checkbox = value
                        console.debug("Phare xénon : " .. tostring(value))
                    end,
                })
                if esthetique_phare_checkbox then
                    addButton("Couleur des phares", { rightIcon = "chevron" }, {})
                end
                addButton("Kits néon", { rightIcon = "chevron" }, {})
                addButton("Position des phares", { rightIcon = "chevron" }, {})
            end)
            
            xmenu.items(esthetique_roue, function()
                addButton("Type de roue", { rightIcon = "chevron" }, {})
                addButton("Couleur des jantes", { rightIcon = "chevron" }, {})
                addButton("Fumée de pneu", { rightIcon = "chevron" }, {})
            end)
            
            xmenu.items(esthetique_vitre, function()
                addButton("Aucun", { rightIcon = "chevron" }, {})
                addButton("Noir pur", { rightIcon = "chevron" }, {})
                addButton("Fumée foncée", { rightIcon = "chevron" }, {})
                addButton("Fumée légère", { rightIcon = "chevron" }, {})
                addButton("Stock", { rightIcon = "chevron" }, {})
                addButton("Lime", { rightIcon = "chevron" }, {})
                addButton("Vert", { rightIcon = "chevron" }, {})
            end)
            
            xmenu.items(esthetique_interieur, function()
                addButton("Habitacle", { rightIcon = "chevron" }, {})
                addButton("Ornements", { rightIcon = "chevron" }, {})
                addButton("Tableau de bord", { rightIcon = "chevron" }, {})
                addButton("Cadran", { rightIcon = "chevron" }, {})
                addButton("Intérieur porte", { rightIcon = "chevron" }, {})
                addButton("Siege", { rightIcon = "chevron" }, {})
                addButton("Volant", { rightIcon = "chevron" }, {})
                addButton("Levier de vitesse", { rightIcon = "chevron" }, {})
                addButton("Enceinte", { rightIcon = "chevron" }, {})
            end)
            
            xmenu.items(esthetique_plaque, function()
                addButton("Couleur plaque", { rightIcon = "chevron" }, {})
                addButton("Position plaque", { rightIcon = "chevron" }, {})
            end)
            
            xmenu.items(esthetique_extra, function()
                addCheckbox("Extra 1", false, {}, {})
                addCheckbox("Extra 2", false, {}, {})
                addCheckbox("Extra 3", false, {}, {})
            end)

            Wait(500)
        end
    end)
    xmenu.render(main)
end