if not Config.Multichar then return end

RegisterNuiCallback("nui:webLoaded", function()
    CreateThread(function()
        while not VFW.PlayerLoaded do
            if NetworkIsPlayerActive(VFW.playerId) then
                DoScreenFadeOut(0)
                VFW.Nui.Visible(true)
                TriggerServerEvent("core:server:loadPlayerGlobal")
                Wait(1000)
                Multicharacter:SetupCharacters()
                break
            end
        end
    end)
end)

RegisterNetEvent("vfw:multicharacter:SetupUI", function(data, slots)
    Multicharacter:SetupUI(data, slots)
end)

RegisterNetEvent('vfw:playerLoaded', function(playerData, isNew, skin)
    Multicharacter:PlayerLoaded(playerData, isNew, skin)
end)

RegisterNetEvent('vfw:onPlayerLogout', function()
    Multicharacter:HideHud(true)
    DoScreenFadeOut(100)
    Wait(500)

    Multicharacter.spawned = false

    Multicharacter:SetupCharacters()
end)

RegisterCommand("relog", function()
    if not IsPedInAnyVehicle(VFW.PlayerData.ped, false) and not IsPedRunning(VFW.PlayerData.ped) then
        DoScreenFadeOut(0)
        TriggerServerEvent("vfw:multicharacter:relog")
    else
        console.debug("You cannot relog while in a vehicle or running.")
    end
end, false)
