AllSafeZone = {}

local isInSafeZone = false
local WEAPON_UNARMED = `weapon_unarmed`

local controlThread = nil

local function isInSafeZoneArea(zonePoints, x, y)
    local inZone = false
    local j = #zonePoints

    for i = 1, #zonePoints do
        if zonePoints[i] and zonePoints[j] then
            if ((zonePoints[i].y < y and zonePoints[j].y >= y) or (zonePoints[j].y < y and zonePoints[i].y >= y)) and (zonePoints[i].x <= x or zonePoints[j].x <= x) then
                if zonePoints[i].x + (y - zonePoints[i].y) / (zonePoints[j].y - zonePoints[i].y) * (zonePoints[j].x - zonePoints[i].x) < x then
                    inZone = not inZone
                end
            end
        end

        j = i
    end

    return inZone
end

local function startDisableControlsThread()
    if controlThread then return end
    controlThread = CreateThread(function()
        while isInSafeZone do
            Wait(0)
            DisableControlAction(0, 45, true)   -- INPUT_RELOAD (R)
            DisableControlAction(0, 140, true)  -- INPUT_MELEE_ATTACK_HEAVY (R)
            DisableControlAction(0, 141, true)  -- INPUT_MELEE_ATTACK_LIGHT
            DisableControlAction(0, 142, true)  -- INPUT_MELEE_ATTACK_ALTERNATE
            DisableControlAction(0, 143, true)  -- INPUT_MELEE_BLOCK
            DisableControlAction(0, 263, true)  -- INPUT_MELEE_ATTACK1
            DisableControlAction(0, 264, true)  -- INPUT_MELEE_ATTACK2
            DisableControlAction(0, 257, true)  -- INPUT_ATTACK2
            DisableControlAction(0, 24, true)   -- INPUT_ATTACK (clic gauche)
        end
        controlThread = nil
    end)
end

local function handleSafeZoneState(entering)
    if entering then
        SetEntityInvincible(VFW.PlayerData.ped, true)
        SetCanAttackFriendly(VFW.PlayerData.ped, false, false)

        if not isInSafeZone then
            isInSafeZone = true
            VFW.Nui.SafeZoneVisible(true)
            startDisableControlsThread()
        end
    else
        if isInSafeZone then
            isInSafeZone = false
            SetEntityInvincible(VFW.PlayerData.ped, false)
            SetCanAttackFriendly(VFW.PlayerData.ped, true, false)
            VFW.Nui.SafeZoneVisible(false)
        end
    end
end

RegisterNetEvent('core:createZoneSafe', function(name, pos)
    AllSafeZone[name] = { pos = pos }
end)

RegisterNetEvent('core:deleteZoneSafe', function(name)
    AllSafeZone[name] = nil
end)

CreateThread(function()
    while not VFW.IsPlayerLoaded() do Wait(100) end

    AllSafeZone = TriggerServerCallback('core:admin:getAllZoneSafe')
    while not AllSafeZone do Wait(100) end

    while true do
        local playerX, playerY = table.unpack(GetEntityCoords(VFW.PlayerData.ped, true))
        local foundInZone = false

        for _, zone in pairs(AllSafeZone) do
            if isInSafeZoneArea(zone.pos, playerX, playerY) then
                foundInZone = true
                break
            end
        end

        handleSafeZoneState(foundInZone)

        Wait(750)
    end
end)
