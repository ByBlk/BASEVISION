local Config = {
    PrisonLocation = vector3(1685.99, 2583.93, 50.5),
    PrisonEntrance = vector3(1775.62, 2551.88, 44.57),
    ReleaseLocation = vector3(1845.77, 2585.93, 44.67),
    MaxDistanceFromPrison = 125.0,
    JailDoors = {
        {hash = 241550507, pos = vector4(1775.4141845703, 2491.025390625, 49.840057373047, 29.999996185303)},
        {hash = 241550507, pos = vector4(1772.9385986328, 2495.3132324219, 49.840057373047, 29.999996185303)},
        {hash = -1156020871, pos = vector4(1681.2083740234, 2564.7822265625, 46.252220153809, 269.30627441406)},
        {hash = -1156020871, pos = vector4(1618.3304443359, 2573.6110839844, 46.252220153809, 134.24517822266)},
        {hash = -1156020871, pos = vector4(1618.3071289062, 2533.8703613281, 46.252220153809, 225.06985473633)},
        {hash = -1156020871, pos = vector4(1623.3203125, 2519.109375, 46.252220153809, 185.64677429199)},
        {hash = -1156020871, pos = vector4(1653.7633056641, 2493.5766601562, 46.252220153809, 275.06982421875)},
        {hash = -1156020871, pos = vector4(1673.0327148438, 2489.5812988281, 46.252220153809, 224.84396362305)},
        {hash = -1156020871, pos = vector4(1712.7598876953, 2489.6130371094, 46.252220153809, 313.96069335938)},
        {hash = -1156020871, pos = vector4(1727.015625, 2509.4235839844, 46.062404632568, 255.21278381348)},
        {hash = -1156020871, pos = vector4(1761.3977050781, 2529.3381347656, 46.252220153809, 344.50881958008)},
        {hash = -1156020871, pos = vector4(1744.181640625, 2562.525390625, 46.252220153809, 269.50003051758)},
        {hash = -1156020871, pos = vector4(1708.4818115234, 2564.7824707031, 46.252220153809, 269.50003051758)},
        {hash = -1156020871, pos = vector4(1798.0900878906, 2591.6872558594, 46.417839050293, 179.99987792969)},
        {hash = -1156020871, pos = vector4(1797.7608642578, 2596.5649414062, 46.387306213379, 179.99987792969)},
        {hash = 1373390714, pos = vector4(1819.0743408203, 2594.8745117188, 46.086990356445, 270.31356811523)},
        {hash = 2074175368, pos = vector4(1772.8133544922, 2570.2963867188, 45.744674682617, 4.8494572639465)},
    }
}
local remainingJailTime = 0
local isInJail = false
local controlList = {
    140, 141, 142, 25, 24, 257
}

local function cuff(isCuffed)
    local playerPed = PlayerPedId()

    if isCuffed then
        VFW.Streaming.RequestAnimDict('mp_arresting')

        SetEnableHandcuffs(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)

        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        RemoveAnimDict('mp_arresting')
    else
        SetEnableHandcuffs(playerPed, false)
        ClearPedTasksImmediately(playerPed)
    end

    CreateThread(function()
        while isCuffed do
            Wait(10)
            for i = 1, #controlList do
                DisableControlAction(0, controlList[i], true)
            end
        end
    end)
end

local function FormatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", mins, secs)
end

local function ReleaseFromJail()
    remainingJailTime = 0
    isInJail = false

    SetEntityCoords(PlayerPedId(), Config.ReleaseLocation.x, Config.ReleaseLocation.y, Config.ReleaseLocation.z)

    cuff(false)

    VFW.ShowNotification({
        type = 'VERT',
        content = "Vous avez été libéré de prison."
    })
end

local function showText(args)
    args.shadow = args.shadow or true;
    args.font = args.font or 6;
    args.size = args.size or 0.50;
    args.posx = args.posx or 0.5;
    args.posy = args.posy or 0.4;
    args.msg = args.msg or "";

    SetTextFont(args.font)
    SetTextProportional(0)
    SetTextScale(args.size, args.size)
    if args.shadow == true then
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(1, 0, 0, 0, 255)
    end
    SetTextEntry("STRING")
    AddTextComponentString(args.msg);
    DrawText(args.posx, args.posy);
end

local function DrawSpecialText(title, barPosition, addLeft)
    if not addLeft then addLeft = 0; end
    RequestStreamedTextureDict("timerbars");
    if not HasStreamedTextureDictLoaded("timerbars") then return; end
    local x = 1.0 - (1.0 - GetSafeZoneSize()) * 0.5 - 0.180 / 2;
    local y = 1.0 - (1.0 - GetSafeZoneSize()) * 0.5 - 0.045 / 2 - (barPosition - 1) * (0.045 + 0);
    DrawSprite("timerbars", "all_black_bg", x, y, 0.180, 0.045, 0.0, 255, 255, 255, 160);
    showText({msg = title, font = 0, size = 0.36, posx = 0.840, posy = y/1.014, shadow = false});
end

RegisterNetEvent('jail:sendToJail')
AddEventHandler('jail:sendToJail', function(time)
    remainingJailTime = time
    isInJail = true

    SetEntityCoords(PlayerPedId(), Config.PrisonEntrance.x, Config.PrisonEntrance.y, Config.PrisonEntrance.z)

    cuff(true)

    VFW.ShowNotification({
        type = 'ROUGE',
        content = "Vous avez été emprisonné pour " .. FormatTime(time) .. "."
    })

    CreateThread(function()
        while isInJail do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - Config.PrisonLocation)

            if distance > Config.MaxDistanceFromPrison then
                SetEntityCoords(playerPed, Config.PrisonEntrance.x, Config.PrisonEntrance.y, Config.PrisonEntrance.z)
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Vous avez été téléporté à l'entrée de la prison car vous étiez trop loin."
                })
            end

            remainingJailTime = remainingJailTime - 1

            if remainingJailTime <= 0 then
                TriggerServerEvent('jail:releasePlayer', GetPlayerServerId(PlayerId()))
            end

            for _, door in ipairs(Config.JailDoors) do
                local doorEntity = GetClosestObjectOfType(door.pos.x, door.pos.y, door.pos.z, 1.0, door.hash, false, false, false)

                SetEntityHeading(doorEntity, door.pos.w)
                FreezeEntityPosition(doorEntity, true)
            end

            Wait(1000)
        end
    end)

    CreateThread(function()
        while isInJail and remainingJailTime > 0 do
            DrawSpecialText("Libération dans ".. FormatTime(remainingJailTime), 1, 0.025)
            Wait(0)
        end
    end)
end)

RegisterNetEvent('jail:releaseFromJail')
AddEventHandler('jail:releaseFromJail', ReleaseFromJail)
