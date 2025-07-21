local outils = {
    Godmod = false,
    Invisible = false,
    indexBan = 1,
    Spectate = false,
}
StaffMenu.LastPlayerource = nil
StaffMenu.showRPNamesOnPlayerTags = false

function StaffMenu.BuildOutilsMenu()
    xmenu.items(StaffMenu.outils, function()
        addButton("ANNONCE SERVEUR", { rightIcon = "chevron" }, {
            onSelected = function()
                local annonce = VFW.Nui.KeyboardInput(true, "Entrez le contenu de l'annonce")

                if annonce ~= "" and type(annonce) == "string" then
                    TriggerServerEvent("core:vnotif:createAlert:global", annonce)
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Veuillez entrer un texte valide"
                    })
                end
            end
        })

        addButton("ANNONCE MODÉRATEUR", { rightIcon = "chevron" }, {
            onSelected = function()
                local annonce = VFW.Nui.KeyboardInput(true, "Entrez le contenu de l'annonce")

                if annonce ~= "" and type(annonce) == "string" then
                    TriggerServerEvent("core:vnotif:createAlert:staff", annonce)
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Veuillez entrer un texte valide"
                    })
                end
            end
        })

        addCheckbox("NOCLIP", VFW.IsNoclipActive(), {}, {
            onChange = function(checked)
                VFW.ToggleNoclip(checked)
            end
        })

        addCheckbox("GODMOD", outils.Godmod, {}, {
            onChange = function(checked)
                outils.Godmod = checked
                SetEntityInvincible(VFW.PlayerData.ped, checked)
            end
        })

        addCheckbox("INVISIBLE", outils.Invisible, {}, {
            onChange = function(checked)
                outils.Invisible = checked
                SetEntityVisible(VFW.PlayerData.ped, not checked, false)
            end
        })

        addCheckbox("NOM DES JOUEURS", VFW.IsGamerTagsActive(), {}, {
            onChange = function(checked)
                if checked then
                    TriggerServerEvent("Admin:activeBlips", true)
                    TriggerServerEvent("Admin:gamerTag", true)
                else
                    TriggerServerEvent("Admin:activeBlips", false)
                    TriggerServerEvent("Admin:gamerTag", false)
                end
            end
        })

        addCheckbox("AFFICHAGE DES NAME TAGS", StaffMenu.showRPNamesOnPlayerTags, {}, {
            onChange = function(checked)
                StaffMenu.showRPNamesOnPlayerTags = checked
                VFW.UpdateAllGamerTags()
            end
        })

        addButton("TP SUR LE POINT", { rightIcon = "arrow" }, {
            onSelected = function()
                TriggerEvent("vfw:tpm")
            end
        })

        addButton("RÉCUPERER LES CLES DU VÉHICULE", { rightIcon = "chevron" }, {
            onSelected = function()

            end
        })

        addButton("SOIGNER LA ZONE", { rightIcon = "heart" }, {
            onSelected = function()
                local radius = VFW.Nui.KeyboardInput(true, "Radius de la zone")

                if tonumber(radius) ~= nil and tonumber(radius) >= 0 then
                    VFW.TreatZone(radius)
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~sRayon invalide !"
                    })
                end
            end
        })

        addCheckbox("SPECTATE ALEATOIRE", outils.Spectate, {}, {
            onChange = function(checked)
                outils.Spectate = checked
                local playerSource = TriggerServerCallback("vfw:staff:getPlayerList")
                local randomPlayer = playerSource[math.random(1, #playerSource)].source

                if randomPlayer ~= GetPlayerServerId(PlayerId()) then
                    if outils.Spectate then
                        StaffMenu.LastPlayerource = randomPlayer
                        TriggerServerEvent("core:StaffSpectate", randomPlayer, true)
                    else
                        if StaffMenu.LastPlayerource ~= nil then
                            TriggerServerEvent("core:StaffSpectate", StaffMenu.LastPlayerource, false)
                            StaffMenu.LastPlayerource = nil
                        end
                    end
                end
            end
        })

        addList("BAN UN JOUEUR OFFLINE", { "Jours", "Heures", "Perm" }, outils.indexBan, {}, {
            onChange = function(value)
                outils.indexBan = value
            end,
            onSelected = function()
                local identifiers = VFW.Nui.KeyboardInput(true, "Identifiers du joueur (JSON)")
                if identifiers == nil or identifiers == "" then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous devez entrer un identifiant"
                    })
                    return
                end
                local time
                local typeBan
                local reason = VFW.Nui.KeyboardInput(true, "Raison", "")
                if reason == nil or reason == "" then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous devez entrer une raison"
                    })
                    return
                end
                if outils.indexBan == 0 then
                    time = VFW.Nui.KeyboardInput(true, "Nombre de jours", "")
                    typeBan = "jours"
                elseif outils.indexBan == 1 then
                    time = VFW.Nui.KeyboardInput(true, "Nombre d'heures", "")
                    typeBan = "heures"
                elseif outils.indexBan == 2 then
                    time = 0
                    typeBan = "perm"
                end

                if time ~= nil or time ~= "" then
                    TriggerServerEvent("core:ban:banofflineplayer", identifiers, reason, time, GetPlayerServerId(PlayerId()), typeBan)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Joueur banni avec succès"
                    })
                end
            end
        })

        addButton("UNBAN UN JOUEUR", { rightIcon = "chevron" }, {
            onSelected = function()
                local id = VFW.Nui.KeyboardInput(true, "Ban ID")

                if id ~= nil and id ~= "" then
                    TriggerServerEvent("core:ban:unbanplayer", id)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Vous avez unban le joueur n°" .. id .. "."
                    })
                end
            end
        })

        addButton("DONNER UN PERMIS", { rightIcon = "chevron" }, {
            onSelected = function()
                local idplayer = VFW.Nui.KeyboardInput(true, "id du joueur")
                local kind = VFW.Nui.KeyboardInput(true, "traffic_law, driving, moto, camion, bateau, helico")

                if idplayer ~= nil and idplayer ~= "" and kind ~= nil and (kind == "traffic_law" or kind == "driving" or kind == "moto" or kind == "camion" or kind == "bateau" or kind == "helico") then
                    --todo: Add trigger server event
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Vous avez donner le permis " .. kind .. " au joueur n°" .. idplayer .. "."
                    })
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "L'ID du joueur ou le type de permis est invalide"
                    })
                end
            end
        })
    end)
end
