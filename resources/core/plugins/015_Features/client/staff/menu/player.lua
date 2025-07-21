local playerStates = {}

local function getPlayerState(playerId)
    if not playerStates[playerId] then
        playerStates[playerId] = {
            Spectate = false,
            Freeze = false,
            Return = false,
            indexBan = 1
        }
    end

    return playerStates[playerId]
end

function StaffMenu.BuildPlayerMenu()
    xmenu.items(StaffMenu.player, function()
        local pseudo
        if StaffMenu.data.playerInfo.color then
            pseudo = "~" .. VFW.DecimalColorToHUDColor(StaffMenu.data.playerInfo.color).name .. "~" .. StaffMenu.data.playerInfo.name .. "~s~ "
        else
            pseudo = StaffMenu.data.playerInfo.name
        end
        local playerIdx = GetPlayerFromServerId(StaffMenu.data.playerInfo.source)
        local ped = GetPlayerPed(playerIdx)
        local panel = {
            title = tostring(pseudo),
            image = StaffMenu.data.playerInfo.mugshot,
            value = {
                { "Temps de jeu", tostring(StaffMenu.data.playerInfo.time) },
                { "Premium", tostring(StaffMenu.data.playerInfo.premium) },
                { "VCOINS", tostring(StaffMenu.data.playerInfo.vcoins) },
                { "Job", tostring(StaffMenu.data.playerInfo.job) },
                { "Grade", tostring(StaffMenu.data.playerInfo.grade) },
                { "Crew", tostring(StaffMenu.data.playerInfo.crew) },
                { "Grade", tostring(StaffMenu.data.playerInfo.crewGrade) },
                { "Banque", tostring(StaffMenu.data.playerInfo.bank) },
                { "Espece", tostring(StaffMenu.data.playerInfo.money) }
            },
            statistics = {
                { "Vie", GetEntityHealth(ped) },
                { "Armure", GetPedArmour(ped) }
            }
        }

        local player = getPlayerState(StaffMenu.data.selectedPlayer)

        addButton("DISCORD ID : " .. string.upper(StaffMenu.data.playerInfo.discord), { rightIcon = "chevron", rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                TriggerEvent("addToCopy", StaffMenu.data.playerInfo.discord)
            end
        })

        addButton("CHANGER LE JOB", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.data.jobsList = TriggerServerCallback("vfw:staff:getJobs") or {}
                StaffMenu.BuildjobsMenu()
            end
        }, StaffMenu.jobs)

        addButton("CHANGER LE CREW", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.data.crewsList = TriggerServerCallback("core:staff:getOrganizations") or {}
                StaffMenu.BuildCrewsMenu()
            end
        }, StaffMenu.crews)

        addButton("GIVE UN ITEM", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.BuildItemsMenu()
            end
        }, StaffMenu.items)

        addButton("INVENTAIRE DU JOUEUR", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                VFW.OpenStaffMenu()
                Wait(250)
                VFW.OpenShearch(StaffMenu.data.selectedPlayer)
            end
        })

        addButton("INVENTAIRE CLEANER (NON ACTIF)", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()

            end
        })

        addButton("VEHICULES DU JOUEUR", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetAllVehicle", StaffMenu.data.selectedPlayer) or {}
                StaffMenu.BuildVehsMenu()
            end
        }, StaffMenu.vehs)

        addButton("ENVOYER UN MESSAGE", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                local msg = VFW.Nui.KeyboardInput(true, "Message", "")

                if msg ~= nil or msg ~= "" then
                    TriggerServerEvent("core:vnotif:createAlert:player", msg, StaffMenu.data.selectedPlayer)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Message chiant envoyé à ~s " .. StaffMenu.data.playerInfo.name
                    })
                end
            end
        })

        addButton("REVIVE LE JOUEUR", { rightIcon = "heart", panel = panel }, {
            onSelected = function()
                ExecuteCommand(("revive %s"):format(StaffMenu.data.playerInfo.id))
            end
        })

        addButton("HEAL LE JOUEUR", { rightIcon = "heart", panel = panel }, {
            onSelected = function()
                ExecuteCommand(("heal %s"):format(StaffMenu.data.playerInfo.id))
            end
        })

        addButton("WIPE", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.data.charList = TriggerServerCallback("vfw:staff:getCharList", StaffMenu.data.selectedPlayer) or {}
                StaffMenu.BuildWipeMenu()
            end
        }, StaffMenu.wipe)

        addCheckbox("SPECTATE LE JOUEUR", player.Spectate, {}, {
            onChange = function(checked)
                player.Spectate = checked
                TriggerServerEvent("core:StaffSpectate", StaffMenu.data.selectedPlayer, player.Spectate)
            end
        })

        addButton("DÉFINIR UN WAYPOINT", { rightIcon = "arrow", panel = panel }, {
            onSelected = function()
                local playerCoords = TriggerServerCallback("core:CoordsOfPlayer", StaffMenu.data.selectedPlayer)
                SetNewWaypoint(playerCoords.x, playerCoords.y)
            end
        })

        addButton("GOTO", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                ExecuteCommand(("goto %s"):format(StaffMenu.data.playerInfo.id))
            end
        })

        if not player.Return then
            addButton("BRING", { rightIcon = "chevron", panel = panel }, {
                onSelected = function()
                    ExecuteCommand(("bring %s"):format(StaffMenu.data.playerInfo.id))
                    player.Return = true
                    StaffMenu.BuildPlayerMenu()
                end
            })
        end

        if player.Return then
            addButton("RETURN", { rightIcon = "chevron", panel = panel }, {
                onSelected = function()
                    ExecuteCommand(("return %s"):format(StaffMenu.data.playerInfo.id))
                    player.Return = false
                    StaffMenu.BuildPlayerMenu()
                end
            })
        end

        addCheckbox("FREEZE LE JOUEUR", player.Freeze, {}, {
            onChange = function(checked)
                player.Freeze = checked
                TriggerServerEvent("core:FreezePlayer", StaffMenu.data.selectedPlayer, player.Freeze)
            end
        })

        addButton("WARN", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                local reason = VFW.Nui.KeyboardInput(true, "Raison du warn")

                if reason ~= nil and reason ~= "" then
                    TriggerServerEvent("core:warn:addwarn", reason, StaffMenu.data.selectedPlayer)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Vous avez warn ~s " .. StaffMenu.data.playerInfo.name
                    })
                end
            end
        })

        addButton("LISTE DES WARNS", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                StaffMenu.data.warnsPlayerList = TriggerServerCallback("core:warn:getwarnsbydiscord", StaffMenu.data.playerInfo.discord) or {}
                StaffMenu.BuildWarnsMenu()
            end
        }, StaffMenu.warns)

        addButton("JAIL", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                local reason = VFW.Nui.KeyboardInput(true, "Raison du jail")
                if not reason or reason == "" then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous devez entrer une raison"
                    })
                    return
                end
                local time = VFW.Nui.KeyboardInput(true, "Durée du jail (heure)", "")
                if not time or time == "" then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous devez entrer une durée"
                    })
                    return
                end
                TriggerServerEvent("core:sendToJail", StaffMenu.data.selectedPlayer, (time * 60), reason)
                VFW.ShowNotification({
                    type = 'VERT',
                    content = "Vous avez jail ~s " .. StaffMenu.data.playerInfo.name
                })
            end
        })

        addButton("UNJAIL", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                ExecuteCommand("unjail " .. StaffMenu.data.playerInfo.id)
                VFW.ShowNotification({
                    type = 'VERT',
                    content = "Vous avez unjail ~s " .. StaffMenu.data.playerInfo.name
                })
            end
        })

        addButton("KICK", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                local reason = VFW.Nui.KeyboardInput(true, "Raison du kick")

                if reason ~= nil and reason ~= "" then
                    TriggerServerEvent("core:KickPlayer", StaffMenu.data.selectedPlayer, reason)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Vous avez kick ~s " .. StaffMenu.data.playerInfo.name
                    })
                end
            end
        })

        addList("BAN", { "Jours", "Heures", "Perm" }, player.indexBan, {}, {
            onChange = function(value)
                player.indexBan = value
            end,
            onSelected = function()
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
                if player.indexBan == 0 then
                    time = VFW.Nui.KeyboardInput(true, "Nombre de jours", "")
                    typeBan = "jours"
                elseif player.indexBan == 1 then
                    time = VFW.Nui.KeyboardInput(true, "Nombre d'heures", "")
                    typeBan = "heures"
                elseif player.indexBan == 2 then
                    time = 0
                    typeBan = "perm"
                end

                if time ~= nil or time ~= "" then
                    TriggerServerEvent("core:ban:banplayer", StaffMenu.data.selectedPlayer, reason, time, GetPlayerServerId(PlayerId()), typeBan)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Joueur banni avec succès"
                    })
                end
            end
        })

        addButton("SCREEN ÉCRAN DU JOUEUR", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()

            end
        })

        addButton("RECUPERER SON APPARENCE", { rightIcon = "chevron", panel = panel }, {
            onSelected = function()
                local skin = TriggerServerCallback("vfw:staff:getSkin", StaffMenu.data.selectedPlayer)

                if skin then
                    TriggerEvent("skinchanger:loadSkin", skin)
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Apparence du joueur récupérée"
                    })
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Impossible de récupérer l'apparence du joueur"
                    })
                end
            end
        })
    end)
end

local function openPlayerOnAdminMenu(id)
    if id == nil then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Impossible d'ouvrir le menu du joueur, ID invalide"
        })
        return
    end
    StaffMenu.data.playerInfo = TriggerServerCallback("vfw:staff:getPlayerInfo", id) or {}
    StaffMenu.data.playerList = TriggerServerCallback("vfw:staff:getPlayerList") or {}

    if not StaffMenu.data.playerInfo then return end

    StaffMenu.data.selectedPlayer = id

    VFW.OpenStaffMenu()
    Wait(150)
    xmenu.render(StaffMenu.player)
    StaffMenu.BuildPlayerMenu()
    StaffMenu.BuildPlayersMenu()
end

RegisterCommand("openplayer", function(source, args, rawCommand)
    if not VFW.PlayerData or not VFW.PlayerGlobalData.permissions or not VFW.PlayerGlobalData.permissions["staff_menu"] then
        console.debug("Vous n'avez pas la permission d'utiliser le menu staff.")
        return
    end
    if not StaffMenu.adminChecked then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour utiliser cette commande"
        })
        return
    end
    openPlayerOnAdminMenu(args[1])
end, false)
