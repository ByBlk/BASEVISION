local open = false
function VFW.Gestion()
    open = not open
    SetNuiFocus(open, open)
    SendNUIMessage({
        action = "nui:server-gestion:visible",
        data = open
    })
    if open then
        SendNUIMessage({
            action = "nui:server-gestion:setPage",
            data = 0
        })
        SetCursorLocation(0.5, 0.5)
        TriggerScreenblurFadeIn(0)
    else
        TriggerScreenblurFadeOut(0)
    end
    VFW.Nui.HudVisible(not open)
end

RegisterNuiCallback("nui:closeServerGestion", function()
    if open then
        VFW.Gestion()
        VFW.Variables.GestionSent = false
    end
end)

RegisterNuiCallback("nui:server-gestion:minimize", function(data, cb)
    console.debug("Minimize", data.minimize)
    if data and data.minimize then
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(0)
    else
        Wait(300)
        SetNuiFocus(true, true)
        TriggerScreenblurFadeOut(0)
    end
end)

local perm = {
    [9] = "gestion_items",
    [1] = "gestion_perm",
    [7] = "gestion_crew"
}
RegisterNuiCallback("nui:server-gestion:itemEnter", function(data)
    console.debug("Item enter NUI", (data and data.id or "no data"))
    if perm[data.id] and not VFW.PlayerGlobalData.permissions[perm[data.id]] then
        SendNUIMessage({
            action = "nui:server-gestion:setPage",
            data = 0
        })
        return
    end 

    if data.id == 1 then -- Permissions
        VFW.SendPermGestionData()
    elseif data.id == 2 then -- Illégal
        VFW.Territories.SendGestionData()
    elseif data.id == 3 then -- Grand catalogues

    elseif data.id == 4 then -- 911
        VFW.Factions.SendGestionData()
    elseif data.id == 5 then -- Blips

    elseif data.id == 6 then -- Joueurs

    elseif data.id == 7 then -- Groupes illégaux
        VFW.Factions.SendGestionData()
    elseif data.id == 8 then -- Entreprises

    elseif data.id == 9 then -- Items
        VFW.SendItemGestionData()
    elseif data.id == 10 then -- Boutique

    end
end)

RegisterNuiCallback("nui:server-gestion:illegal:typeCrew", function(crew)
    orint("Selement les membres de la faction peuvent accéder à cette section", crew)
    VFW.Variables.SendGestionData()
end)