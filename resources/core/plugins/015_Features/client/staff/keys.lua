RegisterKeyMapping("+noclip", "Activer/Désactiver le noclip", "keyboard", "O")
RegisterCommand("+noclip", function()
    if not VFW.PlayerData or not VFW.PlayerGlobalData.permissions or not VFW.PlayerGlobalData.permissions["noclip"] then
        console.debug("Vous n'avez pas la permission d'utiliser le noclip.")
        return
    end
    ExecuteCommand("noclip")
end)

RegisterKeyMapping("+openStaffMenu", "Ouvrir le menu staff", "keyboard", "F10")
RegisterCommand("+openStaffMenu", function()
    VFW.OpenStaffMenu()
end)

RegisterKeyMapping("+dismissReport", "Fermer le report", "keyboard", "N")
RegisterCommand("+dismissReport", function()
    VFW.RemoveNotification()
end)

RegisterKeyMapping("+acceptReport", "Accepter le report", "keyboard", "Y")
RegisterCommand("+acceptReport", function()
    if VFW.lastReport == nil then return end
    local v = VFW.Reports[VFW.lastReport]

    StaffMenu.data.playerInfo = {}
    StaffMenu.data.playerInfo = TriggerServerCallback("vfw:staff:getPlayerInfo", v.player.source) or {}
    StaffMenu.data.selectedPlayer = v.player.source
    StaffMenu.data.reportInfo = v

    if not StaffMenu.data.playerInfo and not v then return end

    TriggerServerEvent("vfw:staff:takeReport", v.id)

    VFW.OpenStaffMenu()
    Wait(150)
    xmenu.render(StaffMenu.report)
    StaffMenu.BuildReportMenu()
    VFW.RemoveNotification()
end)
