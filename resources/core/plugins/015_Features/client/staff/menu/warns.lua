local warnQuery = nil

function StaffMenu.BuildWarnsMenu()
    xmenu.items(StaffMenu.warns, function()
        local firstLabel = warnQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = warnQuery == nil and "UN WARN" or warnQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if warnQuery ~= nil then
                    warnQuery = nil
                    StaffMenu.BuildWarnsMenu()
                    return
                end

                warnQuery = VFW.Nui.KeyboardInput(true, "Entrez un Warn ID")
                if warnQuery == nil or warnQuery == "" then return end
                StaffMenu.BuildWarnsMenu()
            end
        })

        addLine()

        if StaffMenu.data.warnsPlayerList then
            for k, v in pairs(StaffMenu.data.warnsPlayerList) do
                if warnQuery == nil or v.id == tonumber(warnQuery) then
                    addButton(v.id .. " - " .. string.upper(v.by or "CONSOLE"), { rightIcon = "chevron", description = "Raison : " .. v.reason }, {
                        onSelected = function()
                            TriggerServerEvent("core:warn:removewarn", v.id)
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous avez enlever le warn n°" .. v.id .. " du joueur."
                            })
                            xmenu.render(StaffMenu.player)
                            StaffMenu.BuildPlayerMenu()
                        end
                    })
                end
            end
        end

        onClose(function()
            warnQuery = nil
        end)
    end)
end
