local isHandsup = false
RegisterCommand('+handsup', function()
    if not IsPedOnFoot(VFW.PlayerData.ped) then return end

    isHandsup = not isHandsup

    if isHandsup then
        local dict = "random@mugging3"
        local name = "handsup_standing_base"

        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end

        TaskPlayAnim(VFW.PlayerData.ped, dict, name, 2.0, 2.0, -1, 49, 0, false, false, false)
        RemoveAnimDict(dict)
    else
        ClearPedSecondaryTask(VFW.PlayerData.ped)
    end
end, false)
RegisterKeyMapping('+handsup', "Handsup", 'keyboard', 'X')
