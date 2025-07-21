local crewQuery = nil

function StaffMenu.BuildCrewsMenu()
    xmenu.items(StaffMenu.crews, function()
        local firstLabel = crewQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = crewQuery == nil and "UN CREW" or crewQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if crewQuery ~= nil then
                    crewQuery = nil
                    StaffMenu.BuildCrewsMenu()
                    return
                end

                crewQuery = VFW.Nui.KeyboardInput(true, "Entrez un Nom / Label")
                if crewQuery == nil or crewQuery == "" then return end
                StaffMenu.BuildCrewsMenu()
            end
        })

        addLine()

        if next(StaffMenu.data.crewsList) then
            for _, v in pairs(StaffMenu.data.crewsList) do
                if v.label == nil then
                    v.label = "Inconnu"
                end

                if crewQuery == nil or string.find(string.lower(v.name), string.lower(crewQuery)) or string.find(string.lower(v.label), string.lower(crewQuery)) then
                    if StaffMenu.data.playerInfo.crew ~= v.label then
                        addButton(string.upper(v.label), { rightLabel = tostring(string.upper(v.name)) }, {
                            onSelected = function()
                                print("Crew selected", v.name)
                                StaffMenu.data.selecteCrew = v.name
                                StaffMenu.BuildGradesCrewMenu()
                            end
                        }, StaffMenu.grades_crews)
                    end
                end
            end
        end

        onClose(function()
            crewQuery = nil
        end)
    end)
end
