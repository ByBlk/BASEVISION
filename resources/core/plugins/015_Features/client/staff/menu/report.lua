function StaffMenu.BuildReportMenu()
    xmenu.items(StaffMenu.report, function()
        if StaffMenu.data.playerInfo and StaffMenu.data.playerInfo.name and StaffMenu.data.reportInfo then
            local reportStatus = ""
            if StaffMenu.data.reportInfo.takenBy then
                reportStatus = " (Pris par " .. StaffMenu.data.reportInfo.takenBy.name .. ")"
            end
            
            if not StaffMenu.data.reportInfo.takenBy then
                addButton("PRENDRE LE REPORT", { rightIcon = "chevron", description = "Report N° " .. StaffMenu.data.reportInfo.id .. " de " .. StaffMenu.data.playerInfo.name .. " pour " .. StaffMenu.data.reportInfo.message .. reportStatus }, {
                    onSelected = function()
                        TriggerServerEvent("vfw:staff:takeReport", StaffMenu.data.reportInfo.id)
                        Wait(200)
                        for i = 1, #VFW.Reports do
                            if VFW.Reports[i].id == StaffMenu.data.reportInfo.id then
                                StaffMenu.data.reportInfo = VFW.Reports[i]
                                break
                            end
                        end
                        StaffMenu.BuildReportMenu()
                    end
                })
            end

            addButton("FERMER LE REPORT", { rightIcon = "chevron", description = "Report N° " .. StaffMenu.data.reportInfo.id .. " de " .. StaffMenu.data.playerInfo.name .. " pour " .. StaffMenu.data.reportInfo.message .. reportStatus }, {
                onSelected = function()
                    TriggerServerEvent("vfw:staff:closeReport", StaffMenu.data.selectedPlayer)
                    Wait(150)
                    xmenu.render(StaffMenu.reports)
                    StaffMenu.BuildReportsMenu()
                end
            })

            addButton("Action joueur", { rightIcon = "chevron", description = "Report N° " .. StaffMenu.data.reportInfo.id .. " de " .. StaffMenu.data.playerInfo.name .. " pour " .. StaffMenu.data.reportInfo.message .. reportStatus }, {
                onSelected = function()
                    StaffMenu.data.playerList = TriggerServerCallback("vfw:staff:getPlayerList") or {}
                    StaffMenu.BuildPlayersMenu()
                    StaffMenu.BuildPlayerMenu()
                end
            }, StaffMenu.player)
        end
    end)
end
