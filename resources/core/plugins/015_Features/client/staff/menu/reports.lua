function StaffMenu.BuildReportsMenu()
    local haveReports = false

    xmenu.items(StaffMenu.reports, function()
        for _, v in pairs(VFW.Reports) do
            if not haveReports then
                haveReports = true
            end

            local buttonLabel = string.upper(v.player.id .. " " .. v.player.name)
            local rightLabel = "N° " .. tostring(v.id)
            
            if v.takenBy then
                buttonLabel = buttonLabel .. " (Pris par " .. v.takenBy.name .. ")"
                rightLabel = rightLabel .. " ✓"
            end

            addButton(buttonLabel, { rightLabel = rightLabel, description = v.message }, {
                onSelected = function()
                    StaffMenu.data.playerInfo = TriggerServerCallback("vfw:staff:getPlayerInfo", v.player.source) or {}
                    StaffMenu.data.selectedPlayer = v.player.source
                    StaffMenu.data.reportInfo = v
                    
                    StaffMenu.BuildReportMenu()
                end
            }, StaffMenu.report)
        end

        if not haveReports then
            addSeparator("Aucun report en attente")
        end
    end)
end
