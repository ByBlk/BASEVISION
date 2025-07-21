VFW.Jobs.Menu.Bracelet = {
    ["lspd"] = {
        Point = {
            { coords = {
                vector3(458.6630, -991.8305, 31.0900-1),
            }, zone = {
                name = "bracelet_lspd",
                interactLabel = "Bracelet",
                interactKey = "E",
                interactIcons = "Vetement",
                onPress = function()
                    if VFW.PlayerData.job.onDuty then
                        Wait(150)
                        local playerId = VFW.StartSelect(5.0, true)
                        if playerId then
                            TriggerServerEvent("core:jobs:setBracelet", GetPlayerServerId(playerId))
                        end
                    else
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "Vous devez être en service pour accéder à cette fonctionnalité."
                        })
                    end
                end
            }, blip = { sprite = 189, color = 29, scale = 0.8, label = "LSPD - Bracelet"}},
        }
    },

    ["lssd"] = {
        Point = {
            { coords = {
                vector3(1829.68, 3686.59, 28.66),
            }, zone = {
                name = "bracelet_lssd",
                interactLabel = "Bracelet",
                interactKey = "E",
                interactIcons = "Vetement",
                onPress = function()
                    if VFW.PlayerData.job.onDuty then
                        Wait(150)
                        local playerId = VFW.StartSelect(5.0, true)
                        if playerId then
                            TriggerServerEvent("core:jobs:setBracelet", GetPlayerServerId(playerId))
                        end
                    else
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "Vous devez être en service pour accéder à cette fonctionnalité."
                        })
                    end
                end
            }, blip = { sprite = 189, color = 17, scale = 0.8, label = "LSSD - Bracelet"}},
        }
    },
}
