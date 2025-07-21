local banQuery = nil

function StaffMenu.BuildBansMenu()
    xmenu.items(StaffMenu.bans, function()
        local firstLabel = banQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = banQuery == nil and "UN BAN" or banQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if banQuery ~= nil then
                    banQuery = nil
                    StaffMenu.BuildBansMenu()
                    return
                end

                banQuery = VFW.Nui.KeyboardInput(true, "Entrez un Ban ID")
                if banQuery == nil or banQuery == "" then return end
                StaffMenu.BuildBansMenu()
            end
        })

        addLine()

        if next(StaffMenu.data.banList) then
            for k, v in pairs(StaffMenu.data.banList) do
                if banQuery == nil or v.id == tonumber(banQuery) then
                    addButton(v.id .. " - " .. string.upper(v.by), { rightIcon = "chevron" }, {
                        onSelected = function()
                            TriggerServerEvent("core:ban:unbanplayer", v.id)
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous avez unban le joueur n°" .. v.id .. "."
                            })
                            xmenu.render(StaffMenu.sanctions)
                            StaffMenu.BuildSanctionsMenu()
                        end
                    })
                end
            end
        end

        onClose(function()
            banQuery = nil
        end)
    end)
end
