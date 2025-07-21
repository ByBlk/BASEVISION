local staffQuery = nil

function StaffMenu.BuildStaffMenu()
    xmenu.items(StaffMenu.staff, function()
        local firstLabel = staffQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = staffQuery == nil and "UN STAFF" or staffQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if staffQuery ~= nil then
                    staffQuery = nil
                    StaffMenu.BuildStaffMenu()
                    return
                end

                staffQuery = VFW.Nui.KeyboardInput(true, "Entrez un Grade / Prénom / Nom")
                if staffQuery == nil or staffQuery == "" then return end
                StaffMenu.BuildStaffMenu()
            end
        })

        addLine()

        if next(StaffMenu.data.staffList) then
            for _, v in pairs(StaffMenu.data.staffList) do
                if staffQuery == nil or string.find(string.lower(v.pseudo), string.lower(staffQuery)) or string.find(string.lower(v.name), string.lower(staffQuery))
                        or string.find(tostring(v.grade), staffQuery) then
                    local pseudo = "~" .. VFW.DecimalColorToHUDColor(v.color).name .. "~" .. v.pseudo .. "~s~ "
                    local grade = "~" .. VFW.DecimalColorToHUDColor(v.color).name .. "~" .. v.grade .. "~s~ "

                    addButton(string.upper(pseudo .. v.name), { rightLabel = string.upper(grade) }, {
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
            staffQuery = nil
        end)
    end)
end
