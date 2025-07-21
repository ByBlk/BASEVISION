JobInfo = {}

-- RegisterNetEvent("core:jobs:newJob", function(name, label, grades, typeJob)
--     -- Event handler code here
-- end)

function VFW.ChangeDuty(state)
    VFW.PlayerData.job.onDuty = state
    TriggerServerEvent("vfw:changeDuty", state)
    -- TriggerServerEvent("phone:services:toggleDuty", VFW.PlayerData.job.name, state)
    -- ("tablet:services:toggleDuty", VFW.PlayerData.job.name, state)
end

function VFW.LoadMyJob()
    TriggerEvent(("core:loadjob:%s"):format(VFW.PlayerData.job.name))
end

RegisterNetEvent("vfw:playerReady", function()
    VFW.LoadMyJob()
end)

RegisterNetEvent("vfw:setJob", function(Job)
    VFW.SetPlayerData("job", Job)
    VFW.LoadMyJob()
end)
