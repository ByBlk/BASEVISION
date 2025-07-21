function StaffMenu.BuildVehsMenu()
    xmenu.items(StaffMenu.vehs, function()
        if StaffMenu.data.vehsList then
            addSeparator("Véhicules de ~y~" .. StaffMenu.data.playerInfo.name)
            addSeparator("Owned : ~y~" .. #StaffMenu.data.vehsList.owned .. "~s~ véhicules")
            addSeparator("Job : ~y~" .. #StaffMenu.data.vehsList.job .. "~s~ véhicules")
            addSeparator("Crew : ~y~" .. #StaffMenu.data.vehsList.crew .. "~s~ véhicules")
            addLine()
        else
            addSeparator("Véhicules de ~y~" .. StaffMenu.data.playerInfo.name)
            addSeparator("Owned : ~y~0~s~ véhicules")
            addSeparator("Job : ~y~0~s~ véhicules")
            addSeparator("Crew : ~y~0~s~ véhicules")
            addLine()
        end

        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.owned > 0 then
            addButton("VÉHICULES DU OWNED", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildVehsOwnedMenu()
                end
            }, StaffMenu.vehs_owned)
        end

        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.job > 0 then
            addButton("VÉHICULES DU JOB", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildVehsJobMenu()
                end
            }, StaffMenu.vehs_job)
        end

        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.crew > 0 then
            addButton("VÉHICULES DU CREW", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildVehsCrewMenu()
                end
            }, StaffMenu.vehs_crew)
        end
    end)
end

function StaffMenu.BuildVehsOwnedMenu()
    xmenu.items(StaffMenu.vehs_owned, function()
        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.owned > 0 then
            for i = 1, #StaffMenu.data.vehsList.owned do
                local veh = StaffMenu.data.vehsList.owned[i]

                if veh.stored == 0 then
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Sorti(e)" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, true)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "owned") or {}
                            StaffMenu.BuildVehsOwnedMenu()
                        end
                    })
                else
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Fourrière" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, false)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "owned") or {}
                            StaffMenu.BuildVehsOwnedMenu()
                        end
                    })
                end
            end
        else
            addLine("Aucun véhicule dans le Owned")
        end
    end)
end

function StaffMenu.BuildVehsJobMenu()
    xmenu.items(StaffMenu.vehs_job, function()
        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.job > 0 then
            for i = 1, #StaffMenu.data.vehsList.job do
                local veh = StaffMenu.data.vehsList.job[i]

                if veh.stored == 0 then
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Sorti(e)" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, true)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "job") or {}
                            StaffMenu.BuildVehsJobMenu()
                        end
                    })
                else
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Fourrière" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, false)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "job") or {}
                            StaffMenu.BuildVehsJobMenu()
                        end
                    })
                end
            end
        else
            addLine("Aucun véhicule dans le Job")
        end
    end)
end

function StaffMenu.BuildVehsCrewMenu()
    xmenu.items(StaffMenu.vehs_crew, function()
        if StaffMenu.data.vehsList and #StaffMenu.data.vehsList.crew > 0 then
            for i = 1, #StaffMenu.data.vehsList.crew do
                local veh = StaffMenu.data.vehsList.crew[i]

                if veh.stored == 0 then
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Sorti(e)" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, true)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "crew") or {}
                            StaffMenu.BuildVehsCrewMenu()
                        end
                    })
                else
                    addButton(string.upper(GetMakeNameFromVehicleModel(veh.name) .. " " .. GetLabelText(veh.name) .. " " .. veh.plate), { rightLabel = "Fourrière" }, {
                        onSelected = function()
                            TriggerServerEvent("vfw:staff:impound", StaffMenu.data.selectedPlayer, veh.plate, false)
                            StaffMenu.data.vehsList = TriggerServerCallback("core:server:GetTypeVehicle", StaffMenu.data.selectedPlayer, "crew") or {}
                            StaffMenu.BuildVehsCrewMenu()
                        end
                    })
                end
            end
        else
            addLine("Aucun véhicule dans le Crew")
        end
    end)
end
