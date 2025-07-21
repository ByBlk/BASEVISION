
local isOpen = false

RegisterNetEvent("core:weazel:sendAnnounceAll")
AddEventHandler("core:weazel:sendAnnounceAll", function(data)
    VFW.ShowNotification({
        type = "WEAZEL",
        category = data.type,
        media = data.media,
        media_url = data.media_url,
        buttons = data.buttons,
        preview = data.preview,
    })

    local opened = true

    if not IsNuiFocused() then
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, false)
    end

    CreateThread(function()
        while opened do 
            Wait(1)
            if IsDisabledControlJustPressed(0, 194) or IsDisabledControlJustPressed(0, 202) or IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) then 
                opened = false
                break
            end
            if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) and data.position ~= nil then
                SetNewWaypoint(data.position.x, data.position.y)

                VFW.ShowNotification({
                    type = "JAUNE",
                    content = "Position de l'annonce ajouté sur votre GPS"
                })

                opened = false
                break
            end
        end
    end)

    Wait(10000)
    
    if opened then
        opened = false
    end
end)


RegisterNUICallback("CreateWeazelNews", function(data)
    data.isInPreview = false

    if IsWaypointActive() then
        data.position = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
    else
        data.position =  GetEntityCoords(PlayerPedId())
    end

    VFW.ClearPreview()
    TriggerServerEvent("core:weazel:sendAnnounce", data)
end)


RegisterNuiCallback("PreviewWeazelNews", function(data)
    data.isInPreview = true
    data.position = nil

    VFW.PreviewNotificaions({
        type = "WEAZEL",
        category = data.type,
        media = data.media,
        media_url = data.media_url,
        buttons = data.buttons,
        preview = data.isInPreview,
    })
end)

VFW.Nui.AnnounceWeazel = function(visible)
    if visible then 
        SendNUIMessage({
            action = "nui:weazelNewsAnnouncement:data",
            data = {
                job = VFW.PlayerData.job.name,
            }
        })
    end

    SendNUIMessage({
        action = "nui:weazelNewsAnnouncement:visible",
        data = visible
    })
    VFW.Nui.Focus(visible)
end


function OpenMenuAnnonceWeazel()
    VFW.Nui.AnnounceWeazel(true)
end




RegisterNuiCallback("nui:closeWeazelNewsAnnouncement", function()
    VFW.Nui.AnnounceWeazel(false)
    isOpen = false
    VFW.ClearPreview()
end)