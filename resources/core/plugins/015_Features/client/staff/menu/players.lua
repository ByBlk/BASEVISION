local playerQuery = nil

function StaffMenu.BuildPlayersMenu()
    xmenu.items(StaffMenu.players, function()
        local firstLabel = playerQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = playerQuery == nil and "UN JOUEUR" or playerQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if playerQuery ~= nil then
                    playerQuery = nil
                    StaffMenu.BuildPlayersMenu()
                    return
                end

                playerQuery = VFW.Nui.KeyboardInput(true, "Entrez un ID / Prénom / Nom")
                if playerQuery == nil or playerQuery == "" then return end
                StaffMenu.BuildPlayersMenu()
            end
        })

        addLine()

        if next(StaffMenu.data.playerList) then
            local sortedPlayers = {}

            for _, v in pairs(StaffMenu.data.playerList) do
                table.insert(sortedPlayers, v)
            end

            table.sort(sortedPlayers, function(a, b)
                return a.source < b.source
            end)

            for _, v in ipairs(sortedPlayers) do
                if playerQuery == nil or string.find(string.lower(v.pseudo), string.lower(playerQuery)) or string.find(string.lower(v.name), string.lower(playerQuery))
                        or string.find(tostring(v.id), playerQuery) then
                    local pseudo
                    if v.color then
                        pseudo = "~" .. VFW.DecimalColorToHUDColor(v.color).name .. "~" .. v.pseudo .. "~s~ "
                    else
                        pseudo = v.pseudo
                    end
                    local playerIdx = GetPlayerFromServerId(v.source)
                    local ped = GetPlayerPed(playerIdx)
                    local panel = {
                        title = tostring(pseudo),
                        image = v.mugshot,
                        value = {
                            { "Temps de jeu", tostring(v.time) },
                            { "Premium", tostring(v.premium) },
                            { "VCOINS", tostring(v.vcoins) },
                            { "Job", tostring(v.job) },
                            { "Grade", tostring(v.grade) },
                            { "Crew", tostring(v.crew) },
                            { "Grade", tostring(v.crewGrade) },
                            { "Banque", tostring(v.bank) },
                            { "Espece", tostring(v.money) }
                        },
                        statistics = {
                            { "Vie", GetEntityHealth(ped) },
                            { "Armure", GetPedArmour(ped) }
                        }
                    }
                    local new = v.new and " ~r~[NEW]~s~" or ""

                    addButton(string.upper(pseudo .. v.name .. new), { rightLabel = tostring(v.id), panel = panel }, {
                        onSelected = function()
                            StaffMenu.data.playerInfo = TriggerServerCallback("vfw:staff:getPlayerInfo", v.source) or {}
                            StaffMenu.data.selectedPlayer = v.source
                            StaffMenu.BuildPlayerMenu()
                        end
                    }, StaffMenu.player)
                end
            end
        end

        onClose(function()
            playerQuery = nil
        end)
    end)
end
