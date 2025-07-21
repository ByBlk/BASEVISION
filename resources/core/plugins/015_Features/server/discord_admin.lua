-- Commandes d'administration pour la gestion Discord

-- Commande pour vérifier le statut Discord d'un joueur
RegisterCommand("checkdiscord", function(source, args, rawCommand)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer or not Core.IsPlayerAdmin(source) then
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Usage: /checkdiscord [ID du joueur]"
        })
        return
    end
    
    local targetPlayer = VFW.GetPlayerFromId(targetId)
    if not targetPlayer then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Joueur introuvable"
        })
        return
    end
    
    local discordCheck = VFW.VerifyDiscordRequirements(targetId)
    local discordIdentifier = GetPlayerIdentifierByType(targetId, "discord")
    local discordId = discordIdentifier and string.gsub(discordIdentifier, "discord:", "") or "Non lié"
    
    local status = discordCheck.success and "✅ Valide" or "❌ Invalide"
    local reason = discordCheck.success and "Toutes les vérifications passées" or (discordCheck.error or "Erreur inconnue")
    
    xPlayer.showNotification({
        type = discordCheck.success and 'VERT' or 'ROUGE',
        content = string.format("Discord Status - %s\nJoueur: %s\nDiscord ID: %s\nStatut: %s\nRaison: %s", 
            targetPlayer.getName(), targetPlayer.getName(), discordId, status, reason)
    })
end, false)

-- Commande pour recharger la configuration Discord
RegisterCommand("reloaddiscord", function(source, args, rawCommand)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer or not Core.IsPlayerAdmin(source) then
        return
    end
    
    -- Recharger la configuration
    ExecuteCommand("refresh")
    
    xPlayer.showNotification({
        type = 'VERT',
        content = "Configuration Discord rechargée"
    })
end, false)

-- Commande pour afficher la configuration Discord actuelle
RegisterCommand("discordconfig", function(source, args, rawCommand)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer or not Core.IsPlayerAdmin(source) then
        return
    end
    
    local config = Config.DiscordRequirements
    if not config then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Configuration Discord non trouvée"
        })
        return
    end
    
    local configText = string.format([[
Configuration Discord:
• Activé: %s
• Compte lié requis: %s
• Membre serveur requis: %s
• Retry API: %s (%d tentatives)
• Logs activés: %s
• Rôles exemptés: %d
    ]], 
        config.enabled and "Oui" or "Non",
        config.requireLinkedAccount and "Oui" or "Non",
        config.requireServerMembership and "Oui" or "Non",
        config.retryOnApiFailure and "Oui" or "Non",
        config.maxRetries or 0,
        config.logging.enabled and "Oui" or "Non",
        #config.exemptRoles
    )
    
    xPlayer.showNotification({
        type = 'BLEU',
        content = configText
    })
end, false)

-- Commande pour tester la connexion à l'API Discord
RegisterCommand("testdiscordapi", function(source, args, rawCommand)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer or not Core.IsPlayerAdmin(source) then
        return
    end
    
    if not Config.Discord.token or Config.Discord.token == "" then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Token Discord non configuré"
        })
        return
    end
    
    xPlayer.showNotification({
        type = 'BLEU',
        content = "Test de l'API Discord en cours..."
    })
    
    CreateThread(function()
        local serverInfo = VFW.GetServerInfo()
        if serverInfo then
            xPlayer.showNotification({
                type = 'VERT',
                content = string.format("✅ API Discord fonctionnelle\nServeur: %s\nMembres: %d", 
                    serverInfo.name, serverInfo.member_count or 0)
            })
        else
            xPlayer.showNotification({
                type = 'ROUGE',
                content = "❌ Échec de connexion à l'API Discord"
            })
        end
    end)
end, false)

-- Commande pour forcer la vérification Discord sur tous les joueurs connectés
RegisterCommand("forcediscordcheck", function(source, args, rawCommand)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer or not Core.IsPlayerAdmin(source) then
        return
    end
    
    xPlayer.showNotification({
        type = 'BLEU',
        content = "Vérification Discord forcée en cours..."
    })
    
    CreateThread(function()
        local players = VFW.GetPlayers()
        local checked = 0
        local failed = 0
        
        for i = 1, #players do
            local playerId = players[i]
            local discordCheck = VFW.VerifyDiscordRequirements(playerId)
            
            if not discordCheck.success then
                local targetPlayer = VFW.GetPlayerFromId(playerId)
                if targetPlayer then
                    DropPlayer(playerId, discordCheck.error)
                    failed = failed + 1
                end
            end
            
            checked = checked + 1
            Wait(100) -- Éviter de surcharger l'API
        end
        
        xPlayer.showNotification({
            type = failed > 0 and 'ORANGE' or 'VERT',
            content = string.format("Vérification terminée\nJoueurs vérifiés: %d\nJoueurs exclus: %d", checked, failed)
        })
    end)
end, false)

-- Event pour notifier les admins des tentatives de connexion échouées
AddEventHandler("vfw:discordVerificationFailed", function(playerId, reason, discordId)
    local players = VFW.GetPlayers()
    for i = 1, #players do
        local adminPlayer = VFW.GetPlayerFromId(players[i])
        if adminPlayer and Core.IsPlayerAdmin(players[i]) then
            adminPlayer.showNotification({
                type = 'ROUGE',
                content = string.format("🚫 Connexion Discord refusée\nJoueur: %s\nRaison: %s", 
                    GetPlayerName(playerId) or "Inconnu", reason)
            })
        end
    end
end)

-- Suggestions de commandes
TriggerEvent('chat:addSuggestion', '/checkdiscord', 'Vérifier le statut Discord d\'un joueur', {
    { name = "id", help = "ID du joueur" }
})

TriggerEvent('chat:addSuggestion', '/reloaddiscord', 'Recharger la configuration Discord')
TriggerEvent('chat:addSuggestion', '/discordconfig', 'Afficher la configuration Discord actuelle')
TriggerEvent('chat:addSuggestion', '/testdiscordapi', 'Tester la connexion à l\'API Discord')
TriggerEvent('chat:addSuggestion', '/forcediscordcheck', 'Forcer la vérification Discord sur tous les joueurs')
