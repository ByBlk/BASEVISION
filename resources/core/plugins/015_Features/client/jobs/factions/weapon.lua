local hasWeapon = false
local sendNotif = false
local boucle = false
local EXCLUDED_WEAPONS = {
    [GetHashKey("WEAPON_UNARMED")] = true,
    [GetHashKey("weapon_petrolcan")] = true,
    [GetHashKey("weapon_nailgun")] = true,
    [GetHashKey("weapon_hose")] = true,
    [GetHashKey("weapon_fireextinguisher")] = true,
    [GetHashKey("weapon_fakemachinepistol")] = true,
    [GetHashKey("weapon_stungun")] = true,
    [GetHashKey("weapon_fakepistol")] = true,
    [GetHashKey("weapon_fakecombatpistol")] = true,
    [GetHashKey("weapon_fakespecialcarbine")] = true,
    [GetHashKey("weapon_fakesmg")] = true,
    [GetHashKey("weapon_fakeshotgun")] = true,
    [GetHashKey("weapon_fakeminismg")] = true,
    [GetHashKey("weapon_fakemicrosmg")] = true,
    [GetHashKey("weapon_fakeak")] = true,
    [GetHashKey("weapon_fakeaku")] = true,
    [GetHashKey("weapon_fakem4")] = true,
    [GetHashKey("weapon_laser")] = true,
    [GetHashKey("weapon_paintball")] = true
}

VFW.LastFireTime = 0

local function loadAlertWeapon()
    CreateThread(function()
        while boucle do
            local ped = VFW.PlayerData.ped
            local _, hash = GetCurrentPedWeapon(ped)
            hasWeapon = false

            if hash ~= 0 and hash ~= GetHashKey("WEAPON_UNARMED") then
                hasWeapon = true

                if IsPedShooting(ped) and not sendNotif then
                    if not EXCLUDED_WEAPONS[hash] then
                        local instance = TriggerServerCallback("core:CheckInstance")

                        if instance then
                            VFW.LastFireTime = GetGameTimer()
                            sendNotif = true
                            local pos = GetEntityCoords(ped)
                            TriggerServerEvent('core:alert:makeCall', "lspd", vector3(pos.x, pos.y, pos.z), true, "Coup de feu", false, "drugs")
                            TriggerServerEvent('core:alert:makeCall', "lssd", vector3(pos.x, pos.y, pos.z), true, "Coup de feu", false, "drugs")
                            TriggerServerEvent('core:testPoudre')
                            Wait(5000)
                            sendNotif = false
                        end
                    end
                end
            end

            if hasWeapon then
                Wait(30)
            else
                Wait(1000)
            end
        end
    end)
end

RegisterNetEvent("core:useTestPoudre", function()
    local closestPlayer = VFW.StartSelect(5.0, true)
    local globalTarget = GetPlayerServerId(closestPlayer)
    local check = TriggerServerCallback("core:getTestPoudre", globalTarget)

    VFW.ShowNotification({
        type = check == nil and 'ROUGE' or 'VERT',
        duration = 15,
        content = check == nil and "Résultat du test de poudre :~s Négatif~c" or "Résultat du test de poudre : ~sPositif~c (" .. check .. "%)"
    })
end)

local lastJob = nil

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.type == "faction" then
        lastJob = nil
        boucle = false
        return
    end
    lastJob = Job.type
    boucle = true
    loadAlertWeapon()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob == VFW.PlayerData.job.type then return end
    if VFW.PlayerData.job.type == "faction" then
        boucle = false
        return
    end
    boucle = true
    loadAlertWeapon()
end)
