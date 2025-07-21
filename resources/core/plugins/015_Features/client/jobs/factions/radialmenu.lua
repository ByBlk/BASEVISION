local hose = false

function ToggleHose()
    if VFW.PlayerData.job.onDuty then
        ExecuteCommand('hose')
        if hose == false then
            hose = true
        else
            hose = false
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Tu n'es ~s pas en service"
        })
    end
end

local foam = false

function ToggleFoam()
    if VFW.PlayerData.job.onDuty then
        if hose == false then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "La lance n'est pas déployée"
            })
        else
            ExecuteCommand('foam')
            if foam == false then
                VFW.ShowNotification({
                    type = 'VERT',
                    content = "La mousse est activée"
                })
                foam = true
            else
                VFW.ShowNotification({
                    type = 'VERT',
                    content = "La mousse est désactivée"
                })
                foam = false
            end
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Tu n'es ~s pas en service"
        })
    end
end

local brancard = false

function ToggleBrancard()
    if VFW.PlayerData.job.onDuty then
        if brancard == false then
            VFW.ShowNotification({
                type = 'VERT',
                content = "Le brancard est déployé"
            })
            brancard = true
            ExecuteCommand('stretcher')
        else
            VFW.ShowNotification({
                type = 'VERT',
                content = "Le brancard est rangé"
            })
            brancard = false
            ExecuteCommand('delstretcher')
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Tu n'es ~s pas en service"
        })
    end
end

local bracelet = false

function ToggleBracelet()
    if VFW.PlayerData.job.onDuty then
        if bracelet == false then
            VFW.ShowNotification({
                type = 'VERT',
                content = "Les bracelet sont activés"
            })
            bracelet = true
            TriggerServerEvent("core:jobs:activeBlips", true)
        else
            VFW.ShowNotification({
                type = 'VERT',
                content = "Les bracelet sont désactivés"
            })
            bracelet = false
            TriggerServerEvent("core:jobs:activeBlips", false)
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Tu n'es ~s pas en service"
        })
    end
end
