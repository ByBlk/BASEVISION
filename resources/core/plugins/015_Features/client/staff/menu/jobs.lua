local jobQuery = nil

function StaffMenu.BuildjobsMenu()
    xmenu.items(StaffMenu.jobs, function()
        local firstLabel = jobQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = jobQuery == nil and "UN JOB" or jobQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if jobQuery ~= nil then
                    jobQuery = nil
                    StaffMenu.BuildjobsMenu()
                    return
                end

                jobQuery = VFW.Nui.KeyboardInput(true, "Entrez un Nom / Label")
                if jobQuery == nil or jobQuery == "" then return end
                StaffMenu.BuildjobsMenu()
            end
        })

        addLine()

        if next(StaffMenu.data.jobsList) then
            for _, v in pairs(StaffMenu.data.jobsList) do
                if v.label == nil then
                    v.label = "Inconnu"
                end

                if jobQuery == nil or string.find(string.lower(v.name), string.lower(jobQuery)) or string.find(string.lower(v.label), string.lower(jobQuery)) then
                    if StaffMenu.data.playerInfo.job ~= v.name then
                        addButton(string.upper(v.label), { rightLabel = tostring(v.name) }, {
                            onSelected = function()
                                StaffMenu.data.selecteJob = v.name
                                StaffMenu.BuildGradesJobsMenu()
                            end
                        }, StaffMenu.grades_jobs)
                    end
                end
            end
        end

        onClose(function()
            jobQuery = nil
        end)
    end)
end
