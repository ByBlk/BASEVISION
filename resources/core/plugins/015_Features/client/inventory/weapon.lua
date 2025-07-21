CreateThread(function()
    while true do
        local weapon = GetSelectedPedWeapon(VFW.PlayerData.ped)

        if weapon ~= `weapon_unarmed` then
            if IsPedShooting(VFW.PlayerData.ped) then

                TriggerServerEvent("vfw:weapon:used", weapon)
                if IsPedArmed(VFW.PlayerData.ped, 4) then
                    VFW.TriggerDouille(weapon)
                end
            end
        else
            Wait(1000)
        end
        Wait(0)
    end
end)