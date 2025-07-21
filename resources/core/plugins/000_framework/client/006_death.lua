Death = {}
Death._index = Death
Death.isDead = false
Death.secToWait = 300  
Death.secLeft = Death.secToWait
Death.GetAllDamagePed = {}
Death.GetBonesType = {
    ["Dos"] = { 0, 23553, 56604, 57597 },
    ["Crâne"] = { 1356, 11174, 12844, 17188, 17719, 19336, 20178, 20279, 20623, 21550, 25260, 27474, 29868, 31086,
                  35731, 43536, 45750, 46240, 47419, 47495, 49979, 58331, 61839, 39317 },
    ["Coude droit"] = { 2992 },
    ["Coude gauche"] = { 22711 },
    ["Main gauche"] = { 4089, 4090, 4137, 4138, 4153, 4154, 4169, 4170, 4185, 4186, 18905, 26610, 26611, 26612, 26613,
                        26614, 60309 },
    ["Main droite"] = { 6286, 28422, 57005, 58866, 58867, 58868, 58869, 58870, 64016, 64017, 64064, 64065, 64080, 64081,
                        64096, 64097, 64112, 64113 },
    ["Bras gauche"] = { 5232, 45509, 61007, 61163 },
    ["Bras droit"] = { 28252, 40269, 43810 },
    ["Jambe droite"] = { 6442, 16335, 51826, 36864 },
    ["Jambe gauche"] = { 23639, 46078, 58271, 63931 },
    ["Pied droit"] = { 20781, 24806, 35502, 52301 },
    ["Pied gauche"] = { 2108, 14201, 57717, 65245 },
    ["Poîtrine"] = { 10706, 64729, 24816, 24817, 24818 },
    ["Ventre"] = { 11816 }
}
Death.deatCause = {
    -- Armes de mêlée
    [GetHashKey('WEAPON_UNARMED')] = { 'Tabassé', 'Poings' },
    [GetHashKey('WEAPON_KNUCKLE')] = { 'Tabassé', 'Poing américain' },
    [GetHashKey('WEAPON_NIGHTSTICK')] = { 'Tabassé', 'Matraque' },
    [GetHashKey('WEAPON_HAMMER')] = { 'Tabassé', 'Marteau' },
    [GetHashKey('WEAPON_BAT')] = { 'Tabassé', 'Batte de baseball' },
    [GetHashKey('WEAPON_GOLFCLUB')] = { 'Tabassé', 'Club de golf' },
    [GetHashKey('WEAPON_CROWBAR')] = { 'Tabassé', 'Pied de biche' },
    [GetHashKey('WEAPON_BOTTLE')] = { 'Stabbed', 'Bouteille cassée' },
    [GetHashKey('WEAPON_DAGGER')] = { 'Stabbed', 'Dague' },
    [GetHashKey('WEAPON_HATCHET')] = { 'Stabbed', 'Hachette' },
    [GetHashKey('WEAPON_MACHETE')] = { 'Stabbed', 'Machette' },
    [GetHashKey('WEAPON_FLASHLIGHT')] = { 'Tabassé', 'Lampe torche' },
    [GetHashKey('WEAPON_SWITCHBLADE')] = { 'Stabbed', 'Couteau à cran d\'arrêt' },
    [GetHashKey('WEAPON_POOLCUE')] = { 'Tabassé', 'Queue de billard' },
    [GetHashKey('WEAPON_PIPEWRENCH')] = { 'Tabassé', 'Clé à molette' },
    [GetHashKey('WEAPON_STONE_HATCHET')] = { 'Stabbed', 'Hache en pierre' },

    -- Armes à feu
    [GetHashKey('WEAPON_PISTOL')] = { 'Pistolled', 'Pistolet' },
    [GetHashKey('WEAPON_PISTOL_MK2')] = { 'Pistolled', 'Pistolet MK2' },
    [GetHashKey('WEAPON_COMBATPISTOL')] = { 'Pistolled', 'Pistolet de combat' },
    [GetHashKey('WEAPON_APPISTOL')] = { 'Pistolled', 'Pistolet automatique' },
    [GetHashKey('WEAPON_STUNGUN')] = { 'Electrocuté', 'Taser' },
    [GetHashKey('WEAPON_PISTOL50')] = { 'Pistolled', 'Pistolet .50' },
    [GetHashKey('WEAPON_SNSPISTOL')] = { 'Pistolled', 'Pistolet SNS' },
    [GetHashKey('WEAPON_SNSPISTOL_MK2')] = { 'Pistolled', 'Pistolet SNS MK2' },
    [GetHashKey('WEAPON_HEAVYPISTOL')] = { 'Pistolled', 'Pistolet lourd' },
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = { 'Pistolled', 'Pistolet vintage' },
    [GetHashKey('WEAPON_FLAREGUN')] = { 'Brulé', 'Pistolet de détresse' },
    [GetHashKey('WEAPON_MARKSMANPISTOL')] = { 'Pistolled', 'Pistolet marksman' },
    [GetHashKey('WEAPON_REVOLVER')] = { 'Pistolled', 'Revolver' },
    [GetHashKey('WEAPON_REVOLVER_MK2')] = { 'Pistolled', 'Revolver MK2' },
    [GetHashKey('WEAPON_DOUBLEACTION')] = { 'Pistolled', 'Revolver à double action' },
    [GetHashKey('WEAPON_RAYPISTOL')] = { 'Pistolled', 'Pistolet Up-n-Atomizer' },

    -- Mitraillettes
    [GetHashKey('WEAPON_MICROSMG')] = { 'Riddled', 'Micro SMG' },
    [GetHashKey('WEAPON_SMG')] = { 'Riddled', 'SMG' },
    [GetHashKey('WEAPON_SMG_MK2')] = { 'Riddled', 'SMG MK2' },
    [GetHashKey('WEAPON_ASSAULTSMG')] = { 'Riddled', 'SMG d\'assaut' },
    [GetHashKey('WEAPON_COMBATPDW')] = { 'Riddled', 'PDW de combat' },
    [GetHashKey('WEAPON_MACHINEPISTOL')] = { 'Riddled', 'Pistolet mitrailleur' },
    [GetHashKey('WEAPON_MINISMG')] = { 'Riddled', 'Mini SMG' },

    -- Fusils
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = { 'Rifled', 'Fusil d\'assaut' },
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = { 'Rifled', 'Fusil d\'assaut MK2' },
    [GetHashKey('WEAPON_CARBINERIFLE')] = { 'Rifled', 'Carabine' },
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = { 'Rifled', 'Carabine MK2' },
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = { 'Rifled', 'Fusil avancé' },
    [GetHashKey('WEAPON_SPECIALCARBINE')] = { 'Rifled', 'Carabine spéciale' },
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = { 'Rifled', 'Carabine spéciale MK2' },
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = { 'Rifled', 'Fusil bullpup' },
    [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = { 'Rifled', 'Fusil bullpup MK2' },
    [GetHashKey('WEAPON_COMPACTRIFLE')] = { 'Rifled', 'Fusil compact' },
    [GetHashKey('WEAPON_MILITARYRIFLE')] = { 'Rifled', 'Fusil militaire' },
    [GetHashKey('WEAPON_HEAVYRIFLE')] = { 'Rifled', 'Fusil lourd' },

    -- Fusils à pompe
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = { 'Pulverized', 'Fusil à pompe' },
    [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = { 'Pulverized', 'Fusil à pompe MK2' },
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = { 'Pulverized', 'Fusil à canon scié' },
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = { 'Pulverized', 'Fusil d\'assaut' },
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = { 'Pulverized', 'Fusil bullpup' },
    [GetHashKey('WEAPON_MUSKET')] = { 'Pulverized', 'Mousquet' },
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = { 'Pulverized', 'Fusil à pompe lourd' },
    [GetHashKey('WEAPON_DBSHOTGUN')] = { 'Pulverized', 'Fusil à double canon' },
    [GetHashKey('WEAPON_AUTOSHOTGUN')] = { 'Pulverized', 'Fusil à pompe automatique' },

    -- Armes de précision
    [GetHashKey('WEAPON_SNIPERRIFLE')] = { 'Sniped', 'Fusil de précision' },
    [GetHashKey('WEAPON_HEAVYSNIPER')] = { 'Sniped', 'Fusil de précision lourd' },
    [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = { 'Sniped', 'Fusil de précision lourd MK2' },
    [GetHashKey('WEAPON_MARKSMANRIFLE')] = { 'Sniped', 'Fusil marksman' },
    [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = { 'Sniped', 'Fusil marksman MK2' },

    -- Armes lourdes
    [GetHashKey('WEAPON_GRENADELAUNCHER')] = { 'Obliterated', 'Lance-grenades' },
    [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = { 'Obliterated', 'Lance-grenades fumigènes' },
    [GetHashKey('WEAPON_RPG')] = { 'Obliterated', 'RPG' },
    [GetHashKey('WEAPON_MINIGUN')] = { 'Obliterated', 'Minigun' },
    [GetHashKey('WEAPON_FIREWORK')] = { 'Obliterated', 'Lanceur de feux d\'artifice' },
    [GetHashKey('WEAPON_RAILGUN')] = { 'Obliterated', 'Railgun' },
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = { 'Obliterated', 'Lance-missiles guidés' },
    [GetHashKey('WEAPON_COMPACTLAUNCHER')] = { 'Obliterated', 'Lance-grenades compact' },
    [GetHashKey('WEAPON_RAYMINIGUN')] = { 'Obliterated', 'Minigun Widowmaker' },

    -- Explosifs
    [GetHashKey('WEAPON_GRENADE')] = { 'Bombed', 'Grenade' },
    [GetHashKey('WEAPON_STICKYBOMB')] = { 'Bombed', 'Bombe collante' },
    [GetHashKey('WEAPON_PROXMINE')] = { 'Bombed', 'Mine de proximité' },
    [GetHashKey('WEAPON_PIPEBOMB')] = { 'Bombed', 'Bombe artisanale' },
    [GetHashKey('WEAPON_SMOKEGRENADE')] = { 'Bombed', 'Grenade fumigène' },
    [GetHashKey('WEAPON_BZGAS')] = { 'Bombed', 'Grenade à gaz BZ' },
    [GetHashKey('WEAPON_MOLOTOV')] = { 'Brulé', 'Cocktail Molotov' },
    [GetHashKey('WEAPON_FIREEXTINGUISHER')] = { 'Étouffé', 'Extincteur' },
    [GetHashKey('WEAPON_PETROLCAN')] = { 'Brulé', 'Jerrican' },
    [GetHashKey('WEAPON_FLARE')] = { 'Brulé', 'Fusée éclairante' },
    [GetHashKey('WEAPON_SNOWBALL')] = { 'Tabassé', 'Boule de neige' },
    [GetHashKey('WEAPON_BALL')] = { 'Tabassé', 'Balle' },

    -- Armes spéciales
    [GetHashKey('WEAPON_KNIFE')] = { 'Stabbed', 'Couteau' },
    [GetHashKey('WEAPON_NIGHTVISION')] = { 'Tabassé', 'Lunettes de vision nocturne' },
    [GetHashKey('WEAPON_PARACHUTE')] = { 'Chute', 'Parachute' },
    [GetHashKey('WEAPON_GARBAGEBAG')] = { 'Étouffé', 'Sac poubelle' },

    -- Armes de véhicules
    [GetHashKey('VEHICLE_WEAPON_ROTORS')] = { 'Découpé', 'Rotors d\'hélicoptère' },
    [GetHashKey('VEHICLE_WEAPON_TANK')] = { 'Obliterated', 'Canon de char' },
    [GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET')] = { 'Obliterated', 'Roquette spatiale' },
    [GetHashKey('VEHICLE_WEAPON_PLAYER_LASER')] = { 'Obliterated', 'Laser' },
    [GetHashKey('VEHICLE_WEAPON_PLAYER_BUZZARD')] = { 'Obliterated', 'Mitrailleuse Buzzard' },
    [GetHashKey('VEHICLE_WEAPON_PLAYER_LAZER')] = { 'Obliterated', 'Canon Lazer' },

    -- Causes spéciales
    [GetHashKey('WEAPON_RAMMED_BY_CAR')] = { 'Carkill', 'Renversé par un véhicule' },
    [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = { 'Carkill', 'Écrasé par un véhicule' },
    [GetHashKey('WEAPON_EXPLOSION')] = { 'Bombed', 'Explosion' },
    [GetHashKey('WEAPON_FALL')] = { 'Chute', 'Chute mortelle' },
    [GetHashKey('WEAPON_DROWNING')] = { 'Noyade', 'Noyade' },
    [GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = { 'Noyade', 'Noyade dans un véhicule' },
    [GetHashKey('WEAPON_BLEEDING')] = { 'Saignement', 'Hémorragie' },
    [GetHashKey('WEAPON_ELECTRIC_FENCE')] = { 'Electrocuté', 'Clôture électrique' },
    [GetHashKey('WEAPON_BARBED_WIRE')] = { 'Blessé', 'Fil barbelé' },
    [GetHashKey('WEAPON_FIRE')] = { 'Brulé', 'Feu' },
    [GetHashKey('WEAPON_ANIMAL')] = { 'Animal', 'Attaque d\'animal' },
    [GetHashKey('WEAPON_COUGAR')] = { 'Animal', 'Cougar' },
    [GetHashKey('WEAPON_BARREL')] = { 'Écrasé', 'Baril' },
}
Death.GetDeathType = { "Non-Identifiée", "Dégâts de mêlée", "Blessure par balle", "Chute", "Dégâts explosifs", "Feu", "Chute", "Éléctrique", "Écorchure", "Gaz", "Gaz", "Eau" }

function Death:GetValueWithTable(value, table, number)
    if not value or not table or type(value) ~= "table" then
        return
    end

    for k, v in pairs(value) do
        if number and v[number] == table or v == table then
            return true, k
        end
    end
end

function Death:GetAllCauseOfDeath()
    local exist, lastBone = GetPedLastDamageBone(VFW.PlayerData.ped)
    local cause, what_cause, timeDeath = GetPedCauseOfDeath(VFW.PlayerData.ped), GetPedSourceOfDeath(VFW.PlayerData.ped), GetPedTimeOfDeath(VFW.PlayerData.ped)

    if IsEntityAPed(what_cause) then
        what_cause = "Traces de combat"
    elseif IsEntityAVehicle(what_cause) then
        what_cause = "Écrasé par un véhicule"
    elseif IsEntityAnObject(what_cause) then
        what_cause = "Semble s'être pris un objet"
    end

    what_cause = type(what_cause) == "string" and what_cause or "Non-Identifiée"

    if IsWeaponValid(cause) then
        cause = Death.GetDeathType[GetWeaponDamageType(cause)] or "Non-Identifiée"
    elseif IsModelInCdimage(cause) then
        cause = "Véhicule"
    end

    cause = type(cause) == "string" and cause or "Mêlée"
    local boneName = "Dos"

    if exist and lastBone then
        for k, v in pairs(Death.GetBonesType) do
            if self:GetValueWithTable(v, lastBone) then
                boneName = k
                break
            end
        end
    end

    return timeDeath, what_cause, cause, boneName
end

function Death:Died()
    self:ShowDeathScreen()
    VFW.Nui.HudVisible(false)
end

function Death:ShowDeathScreen()
    self.isDead = true
    self.secLeft = self.secToWait
    console.debug("Death:ShowDeathScreen")
    VFW.Nui.deathScreen(true, self.secToWait)
    TriggerScreenblurFadeIn(1000)
    VFW.Nui.updateDeathScreen({ secToWait = self.secToWait, secLeft = self.secLeft })
    VFW.Nui.Focus(true)
end

RegisterNUICallback("nui:deathscreen:action", function(data, cb)
    if data.action == "DeathscreenRespawn" and Death.secLeft <= 0 then
        TriggerEvent("nui:deathscreen:hide")
        TriggerServerEvent("deathscreen:respawnPlayer")
    elseif data.action == "DeathscreenCallEmergency" then
        TriggerServerEvent("deathscreen:callEmergency")
    end
    cb("ok")
end)

AddEventHandler("vfw:onPlayerDeath", function()
    VFW.PlayerData.dead = true;
    VFW.Nui.Visible(false)
    Wait(50)
    VFW.Nui.Visible(true)
    Wait(50)
    Death:Died()
end)

RegisterNetEvent("vfw:revivePlayer", function()
    local playerPed = PlayerPedId()

    if IsEntityDead(playerPed) then
        local coords = GetEntityCoords(playerPed)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
        SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
        ClearPedTasksImmediately(playerPed)
        VFW.ReviveSelf()
    end

    VFW.Nui.Focus(false, false)
end)

function VFW.ReviveSelf()
    Death.isDead = false;
    VFW.PlayerData.dead = false;
    VFW.Nui.deathScreen(false);
    TriggerScreenblurFadeOut(800)
    VFW.Nui.HudVisible(true);
end

RegisterNUICallback("nui:deathscreen:respawn",function()
    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then
        local coords = GetEntityCoords(playerPed)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
        SetEntityHealth(playerPed, 200)
        ClearPedTasksImmediately(playerPed)
        VFW.ReviveSelf()
    end
end)

RegisterNUICallback("nui:deathscreen:send-report",function(data)
    console.debug("Report", json.encode(data))
    ExecuteCommand("report "..data.report)
end)

local cooldownems = false

RegisterNUICallback("nui:deathscreen:callemergency",function()
    if not cooldownems then
        cooldownems = true
        VFW.ShowNotification({
            type = 'JAUNE',
            content = "Vous avez envoyé un appel ~s aux SAMS"
        })

        TriggerServerEvent('core:alert:makeCall', "sams", GetEntityCoords(VFW.PlayerData.ped), false, "Patient dans le coma")
        TriggerServerEvent('core:alert:makeCall', "lsfd", GetEntityCoords(VFW.PlayerData.ped), false, "Patient dans le coma")
        Wait(120000)
        cooldownems = false
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous avez déjà envoyé un appel ~s aux SAMS"
        })
    end
end)

local function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
    local victimCoords = GetEntityCoords(VFW.PlayerData.ped)
    local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
    local distance = GetDistanceBetweenCoords(victimCoords, killerCoords, true)
    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },
        killerCoords = {
            x = math.round(killerCoords.x, 1),
            y = math.round(killerCoords.y, 1),
            z = math.round(killerCoords.z, 1)
        },
        causeDeath = table.pack(Death:GetAllCauseOfDeath()),
        killedByPlayer = true,
        deathCause = GetEntityModel(killerWeapon),
        distance = math.round(distance, 1),

        killerServerId = killerServerId,
        killerClientId = killerClientId
    }

    TriggerEvent("vfw:onPlayerDeath")
    --todo: Add log death
    TriggerServerEvent("vfw:onPlayerDeath","killed", killerServerId)
end

local function PlayerKilled()
    local playerPed = VFW.PlayerData.ped
    local victimCoords = GetEntityCoords(playerPed)
    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },

        killedByPlayer = false,
        deathCause = GetPedCauseOfDeath(playerPed)
    }

    TriggerEvent("vfw:onPlayerDeath")
    --todo: Add log death
    -- TriggerServerEvent("vfw:onPlayerDeath")
end


local function CEventNetworkEntityDamage(victim, victimDied)
    if not IsPedAPlayer(victim) then return end
    local player = PlayerId()
    local _, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
    local playerPed = VFW.PlayerData.ped

    if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim)) then
        local killerEntity = GetPedSourceOfDeath(playerPed)
        local killerServerId = NetworkGetPlayerIndexFromPed(killerEntity)
        local DeathCause = Death.deatCause[GetPedCauseOfDeath(playerPed)]

        if killerEntity ~= playerPed and killerServerId > 0 then
            PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
        else
            if DeathCause and DeathCause[1] then
                local kPed = GetPedSourceOfDeath(playerPed)
                local kPlayer = NetworkGetPlayerIndexFromPed(kPed)

                PlayerKilledByPlayer(GetPlayerServerId(kPlayer), kPlayer, DeathCause[2])
            else
                PlayerKilled()
            end
        end
    end
end

AddEventHandler("gameEventTriggered", function(event, args)
    if event == "CEventNetworkEntityDamage" and args[6] == 1 then
        if not IsEntityAPed(args[1]) or not IsPedAPlayer(args[1]) or (args[1] ~= VFW.PlayerData.ped) then
            return
        end
        CEventNetworkEntityDamage(args[1], args[4])
    end
end)
