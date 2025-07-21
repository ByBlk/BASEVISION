function StaffMenu.BuildWipeMenu()
    xmenu.items(StaffMenu.wipe, function()
        if StaffMenu.data.charList then
            for _, v in pairs(StaffMenu.data.charList.charList) do
                local pseudo = "~" .. VFW.DecimalColorToHUDColor(v.color).name .. "~" .. v.pseudo .. "~s~ "
                local panel = {
                    title = tostring(pseudo),
                    image = v.mugshot,
                    value = {
                        { "Temps de jeu", "~y~"..v.time },
                        { "Premium", "~y~"..v.premium },
                        { "VCOINS", "~y~"..v.vcoins },
                        { "Job", "~y~"..v.job },
                        { "Grade", "~y~"..v.grade },
                        { "Crew", "~y~"..v.crew },
                        { "Grade", "~y~"..v.crewGrade },
                        { "Banque", "~y~"..v.bank },
                        { "Espece", "~y~"..v.money }
                    },
                }

                addButton(string.upper(v.name .. " - " .. (v.actual and "Actuel" or "OFF")), { rightLabel = tostring(v.id), panel = panel }, {
                    onSelected = function()
                        local validations = VFW.Nui.KeyboardInput(true, "Confimer 'OUI'")

                        if string.lower(validations) == "oui" then
                            TriggerServerEvent("vfw:staff:wipePlayer", StaffMenu.data.selectedPlayer, v.id)
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous venez de wipe le personnage."
                            })
                            if GetPlayerServerId(PlayerId()) == StaffMenu.data.selectedPlayer then
                                xmenu.render(StaffMenu.player)
                                StaffMenu.BuildPlayerMenu()
                            end
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous n'avez pas confirmé."
                            })
                        end
                    end
                })
            end
        end
    end)
end
