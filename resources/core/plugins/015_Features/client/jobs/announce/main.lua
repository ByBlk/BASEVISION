RegisterNuiCallback("notificationCreateSociety_callback", function(data)
    if not data.choiceType_notif or not data.message_notif or not data.telephone_notif then
        return VFW.ShowNotification({type = "ROUGE", content = "Veuillez remplir tout les champs !"})
    end

    TriggerServerEvent("core:server:announceEntreprise:sendData", data)
end)


VFW.Nui.AnnounceEntreprise = function(visible)
    if visible then 
        SendNUIMessage({
            action = "nui:CardNewsSocietyCreate:data",
            data = {
                name_society = VFW.PlayerData.job.label,
                logo_society = "https://cdn.eltrane.cloud/3838384859/assets/hud/notifications/"..VFW.PlayerData.job.name..".webp",
                preset = preset
            }
        })
    end

    SendNUIMessage({
        action = "nui:CardNewsSocietyCreate:visible",
        data = visible
    })
    VFW.Nui.Focus(visible)
end

RegisterNuiCallback("nui:CardNewsSocietyCreate:close", function()
    VFW.Nui.AnnounceEntreprise(false)
    isOpen = false
end)



-- RegisterCommand("annonceentreprise", function()
--     if isOpen then
--         VFW.Nui.AnnounceEntreprise(false)
--         isOpen = false
--     else
--         VFW.Nui.AnnounceEntreprise(true)
--         isOpen = true
--     end
-- end, false)
