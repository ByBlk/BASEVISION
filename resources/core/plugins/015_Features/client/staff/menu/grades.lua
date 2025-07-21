function StaffMenu.BuildGradesJobsMenu()
    xmenu.items(StaffMenu.grades_jobs, function()
        if StaffMenu.data.jobsList and StaffMenu.data.selecteJob and StaffMenu.data.jobsList[StaffMenu.data.selecteJob] then
            for k, v in pairs(StaffMenu.data.jobsList[StaffMenu.data.selecteJob].grades) do
                addButton(string.upper(v.label), { rightLabel = tostring(k) }, {
                    onSelected = function()
                        if not (StaffMenu.data.playerInfo.job == StaffMenu.data.selecteJob and tostring(StaffMenu.data.playerInfo.grade) == k) then
                            StaffMenu.data.playerInfo.grade = tostring(k)
                            StaffMenu.data.playerInfo.job = StaffMenu.data.selecteJob
                            ExecuteCommand(("setjob %s %s %s"):format(StaffMenu.data.playerInfo.id, StaffMenu.data.selecteJob, v.grade))
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous venez de changer le job."
                            })
                        end
                    end
                })
            end
        end
    end)
end

function StaffMenu.BuildGradesCrewMenu()
    xmenu.items(StaffMenu.grades_crews, function()
        if StaffMenu.data.crewsList and StaffMenu.data.selecteCrew and StaffMenu.data.crewsList[StaffMenu.data.selecteCrew] then
            print("Grade menu", json.encode(StaffMenu.data.crewsList[StaffMenu.data.selecteCrew].grade))
            print("Crews server", json.encode(StaffMenu.data.crewsList, {indent = true}))
            for k, v in pairs(StaffMenu.data.crewsList[StaffMenu.data.selecteCrew].grade) do
                addButton(string.upper(v.label), { rightLabel = StaffMenu.data.selecteCrew }, {
                    onSelected = function()
                        if not (StaffMenu.data.playerInfo.crew == StaffMenu.data.selecteCrew and tostring(StaffMenu.data.playerInfo.crewGrade) == v.name) then
                            StaffMenu.data.playerInfo.grade = tostring(v.name)
                            StaffMenu.data.playerInfo.job = StaffMenu.data.selecteCrew
                            ExecuteCommand(("setfaction %s %s %s"):format(StaffMenu.data.playerInfo.id, StaffMenu.data.selecteCrew, v.grade))
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous venez de changer le crew."
                            })
                        end
                    end
                })
            end
        end
    end)
end
