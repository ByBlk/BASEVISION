Adjustments = {}

--- Removes HUD components based on the configuration.
function Adjustments:RemoveHudComponents()
    for i = 1, #Config.RemoveHudComponents do
        if Config.RemoveHudComponents[i] then
            SetHudComponentSize(i, 0.0, 0.0)
            SetHudComponentPosition(i, 900, 900)
        end
    end
end

--- Disables aim assist for the player.
function Adjustments:DisableAimAssist()
    SetPlayerTargetingMode(3)
end

--- Disables NPC weapon drops.
function Adjustments:DisableNPCDrops()
    local weaponPickups = {
        `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`,
        `PICKUP_WEAPON_PUMPSHOTGUN`
    }

    for i = 1, #weaponPickups do
        ToggleUsePickupsForPlayer(VFW.playerId, weaponPickups[i], false)
    end
end

--- Handles seat shuffling when entering a vehicle.
function Adjustments:SeatShuffle()
    AddEventHandler("vfw:enteredVehicle", function(vehicle, _, seat)
        if seat > -1 then
            SetPedIntoVehicle(VFW.PlayerData.ped, vehicle, seat)
            SetPedConfigFlag(VFW.PlayerData.ped, 184, true)
        end
    end)
end

--- Disables health regeneration for the player.
function Adjustments:HealthRegeneration()
    SetPlayerHealthRechargeMultiplier(VFW.playerId, 0.0)
end

--- Disables ammo and vehicle rewards for the player.
function Adjustments:AmmoAndVehicleRewards()
    CreateThread(function()
        while true do
            DisablePlayerVehicleRewards(VFW.playerId)
            Wait(10)
        end
    end)
end

--- Enables PvP mode for the player.
function Adjustments:EnablePvP()
    SetCanAttackFriendly(VFW.PlayerData.ped, true, false)
    NetworkSetFriendlyFireOption(true)
end

--- Disables dispatch services.
function Adjustments:DispatchServices()
    for i = 1, 15 do
        EnableDispatchService(i, false)

    end
    SetAudioFlag('PoliceScannerDisabled', true)
end

--- Disables specific NPC scenarios.
function Adjustments:NPCScenarios()
    local scenarios = {
        "WORLD_VEHICLE_ATTRACTOR", "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_BICYCLE_BMX", "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
        "WORLD_VEHICLE_BICYCLE_BMX_FAMILY", "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
        "WORLD_VEHICLE_BICYCLE_BMX_VAGOS", "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
        "WORLD_VEHICLE_BICYCLE_ROAD", "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
        "WORLD_VEHICLE_BIKER", "WORLD_VEHICLE_BOAT_IDLE",
        "WORLD_VEHICLE_BOAT_IDLE_ALAMO", "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
        "WORLD_VEHICLE_BOAT_IDLE_MARQUIS", "WORLD_VEHICLE_BROKEN_DOWN",
        "WORLD_VEHICLE_BUSINESSMEN", "WORLD_VEHICLE_HELI_LIFEGUARD",
        "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER", "WORLD_VEHICLE_CONSTRUCTION_SOLO",
        "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
        "WORLD_VEHICLE_DRIVE_PASSENGERS",
        "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED", "WORLD_VEHICLE_DRIVE_SOLO",
        "WORLD_VEHICLE_FIRE_TRUCK", "WORLD_VEHICLE_EMPTY",
        "WORLD_VEHICLE_MARIACHI", "WORLD_VEHICLE_MECHANIC",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL", "WORLD_VEHICLE_PARK_PARALLEL",
        "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
        "WORLD_VEHICLE_PASSENGER_EXIT", "WORLD_VEHICLE_POLICE_BIKE",
        "WORLD_VEHICLE_POLICE_CAR", "WORLD_VEHICLE_POLICE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR", "WORLD_VEHICLE_QUARRY",
        "WORLD_VEHICLE_SALTON", "WORLD_VEHICLE_SALTON_DIRT_BIKE",
        "WORLD_VEHICLE_SECURITY_CAR", "WORLD_VEHICLE_STREETRACE",
        "WORLD_VEHICLE_TOURBUS", "WORLD_VEHICLE_TOURIST", "WORLD_VEHICLE_TANDL",
        "WORLD_VEHICLE_TRACTOR", "WORLD_VEHICLE_TRACTOR_BEACH",
        "WORLD_VEHICLE_TRUCK_LOGS", "WORLD_VEHICLE_TRUCKS_TRAILERS",
        "WORLD_VEHICLE_DISTANT_EMPTY_GROUND", "WORLD_HUMAN_PAPARAZZI"
    }

    for i = 1, #scenarios do
        SetScenarioTypeEnabled(scenarios[i], false)
    end
end

--- Sets custom license plates for AI vehicles.
function Adjustments:LicensePlates()
    SetDefaultVehicleNumberPlateTextPattern(-1, Config.CustomAIPlates)
end

local placeHolders = {
    server_name = function()
        return GetConvar("sv_projectName", "VFW-Framework")
    end,
    server_endpoint = function()
        return GetCurrentServerEndpoint() or "localhost:30120"
    end,
    server_players = function() return GlobalState.playerCount or 0 end,
    server_maxplayers = function() return GetConvarInt("sv_maxClients", 48) end,
    player_name = function() return GetPlayerName(VFW.playerId) end,
    player_rp_name = function() return VFW.PlayerData.name or "John Doe" end,
    player_id = function() return VFW.serverId end,
    player_street = function()
        if not VFW.PlayerData.ped then return "Unknown" end

        local playerCoords = GetEntityCoords(VFW.PlayerData.ped)
        local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y,
                                                playerCoords.z)

        return GetStreetNameFromHashKey(streetHash) or "Unknown"
    end
}

--- Replaces placeholders in the Discord presence string.
--- @return string The presence string with placeholders replaced.
function Adjustments:PresencePlaceholders()
    local presence = Config.DiscordActivity.presence

    for placeholder, cb in pairs(placeHolders) do
        local success, result = pcall(cb)

        if not success then
            error(("Failed to execute presence placeholder: ^3%s^7"):format(
                      placeholder))
            error(result)
            return "Unknown"
        end

        presence = presence:gsub(("{%s}"):format(placeholder), result)
    end

    return presence
end

--- Sets the Discord presence for the player.
function Adjustments:DiscordPresence()
    if Config.DiscordActivity.appId ~= 0 then
        CreateThread(function()
            SetDiscordAppId(Config.DiscordActivity.appId)
            SetDiscordRichPresenceAsset(Config.DiscordActivity.assetName)
            SetDiscordRichPresenceAssetText(Config.DiscordActivity.assetText)

            for i = 1, #Config.DiscordActivity.buttons do
                local button = Config.DiscordActivity.buttons[i]
                SetDiscordRichPresenceAction(i - 1, button.label, button.url)
            end

            SetRichPresence(self:PresencePlaceholders())
        end)
    end
end

--- Clears the player's wanted level and sets the maximum wanted level to 0.
function Adjustments:WantedLevel()
    ClearPlayerWantedLevel(VFW.playerId)
    SetMaxWantedLevel(0)
end

--- Disables the radio in vehicles.
function Adjustments:DisableRadio()
    if Config.RemoveHudComponents[16] then
        AddEventHandler("vfw:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
            SetVehRadioStation(vehicle, "OFF")
            SetUserRadioControlEnabled(false)
        end)
    end
end

--- Adds custom text entry for the authors.
function Adjustments:Authers()
    SetWeaponsNoAutoswap(true)
    SetFlashLightKeepOnWhileMoving(true)

    local relationshipTypes = {
        "PLAYER", "CIVMALE", "CIVFEMALE", "COP", "SECURITY_GUARD", "PRIVATE_SECURITY", "FIREMAN",
        "GANG_1", "GANG_2", "GANG_9", "GANG_10", "AMBIENT_GANG_LOST", "AMBIENT_GANG_MEXICAN",
        "AMBIENT_GANG_FAMILY", "AMBIENT_GANG_BALLAS", "AMBIENT_GANG_MARABUNTE", "AMBIENT_GANG_CULT",
        "AMBIENT_GANG_SALVA", "AMBIENT_GANG_WEICHENG", "AMBIENT_GANG_HILLBILLY", "DEALER",
        "HATES_PLAYER", "HEN", "NO_RELATIONSHIP", "SPECIAL", "MISSION2", "MISSION3", "MISSION4",
        "MISSION5", "MISSION6", "MISSION7", "MISSION8", "ARMY", "GUARD_DOG", "AGGRESSIVE_INVESTIGATE",
        "MEDIC", "CAT"
    }
    local RELATIONSHIP_HATE = 1

    for _, v in pairs(relationshipTypes) do
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey('PLAYER'), GetHashKey(v))
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey(v), GetHashKey('PLAYER'))
    end

    CreateThread(function()
        while true do
            RestorePlayerStamina(VFW.playerId, 1.0)

            -- Inventory
            DisableControlAction(0, 37, true)
            HudWeaponWheelIgnoreSelection()

            -- Pause Menu
            SetPauseMenuActive(false)

            if IsAimCamActive() then
                DisableControlAction(1, 22, true)
            end

            if IsPedArmed(VFW.PlayerData.ped, 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end

            SetPedSuffersCriticalHits(VFW.PlayerData.ped, false)

            SetEveryoneIgnorePlayer(VFW.PlayerData.ped, true)

            SetPedConfigFlag(VFW.PlayerData.ped, 35, false)

            Wait(1)
        end
    end)
end

-- Disable enter vehicle png
function Adjustments:NoCarJack()
    local unlockedModels = {
        ['bumpercar'] = true,
        ['bmx'] = true,
        ['cruiser'] = true,
        ['fixter'] = true,
        ['scorcher'] = true,
        ['tribike'] = true,
        ['tribike2'] = true,
        ['tribike3'] = true,
        ['trash'] = true,
        ['trash2'] = true,
    }

    CreateThread(function()
        while true do
            Wait(500)

            local ped = VFW.PlayerData.ped
            local veh = GetVehiclePedIsTryingToEnter(ped)

            if DoesEntityExist(veh) and (not Entity(veh).state.VehicleProperties) then
                local model = GetEntityModel(veh)
                local lock = GetVehicleDoorLockStatus(veh)
                local driverPed = GetPedInVehicleSeat(veh, -1)

                if driverPed and not IsPedAPlayer(driverPed) then
                    if lock ~= 0 then
                        local lockStatus = unlockedModels[model] and 0 or 2
                        SetVehicleDoorsLocked(veh, lockStatus)
                    end
                    SetPedCanBeDraggedOut(driverPed, false)
                else
                    SetVehicleDoorsLocked(veh, 0)
                end
            end
        end
    end)
end

function Adjustments:RemoveDriveBy()
    local state = false

    local function Thread(veh, seat)
        CreateThread(function()
            while state do
                if veh ~= 0 and seat == -1 then
                    DisableControlAction(0, 69, true)
                    DisableControlAction(0, 92, true)
                end

                Wait(1)
            end
        end)
    end

    AddEventHandler("vfw:enteredVehicle", function(vehicle, _, seat)
        if state then return end
        state = true
        Thread(vehicle, seat)
    end)

    AddEventHandler("vfw:exitedVehicle", function()
        state = false
    end)
end

function Adjustments:RemoveCops()
    CreateThread(function()
        local config = {
            checkInterval = 1000,
            suppressionRadius = 400.0
        }

        SetCreateRandomCops(false)
        SetDispatchCopsForPlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), true)

        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())

            ClearAreaOfCops(playerCoords.x, playerCoords.y, playerCoords.z, config.suppressionRadius, 0)

            Wait(config.checkInterval)
        end
    end)
end

--- Loads all adjustments.
function Adjustments:Load()
    self:RemoveHudComponents()
    self:DisableAimAssist()
    self:DisableNPCDrops()
    self:SeatShuffle()
    self:HealthRegeneration()
    self:AmmoAndVehicleRewards()
    self:EnablePvP()
    self:DispatchServices()
    self:NPCScenarios()
    self:LicensePlates()
    self:DiscordPresence()
    self:WantedLevel()
    self:DisableRadio()
    self:Authers()
    -- self:NoCarJack()
    self:RemoveDriveBy()
    self:RemoveCops()
end
