local function UpdateMinimapLocation()
    local ratio <const> = GetScreenAspectRatio()
    local posX = -0.0045
    local posY = 0.002

    if tonumber(string.format("%.2f", ratio)) >= 2.3 then
        posX = -0.17
        posY = 0.002
    else
        posX = -0.0045
        posY = 0.002
    end

    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(100)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, 0.150, 0.188888)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX + 0.0155, posY + 0.03, 0.111, 0.159)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', posX - 0.0255, posY + 0.02, 0.266, 0.237)

    DisplayRadar(false)
    SetRadarBigmapEnabled(true, false)

    Wait(0)

    SetRadarBigmapEnabled(false, false)
    DisplayRadar(true)
end

local function LoadHud()
    UpdateMinimapLocation()
    VFW.Nui.HudVisible(true)
    while true do

        VFW.Nui.HudData({
            visible = true,
            health = (GetEntityHealth(VFW.PlayerData.ped) - 100),
            armor = GetPedArmour(VFW.PlayerData.ped)
        })

        if IsPedArmed(VFW.PlayerData.ped, 4) and VFW.PlayerData.weapon ~= GetHashKey("WEAPON_UNARMED") then
            SendNUIMessage({
                action = "nui:weapon:data",
                data = {
                    visible = true,
                    weapon = string.lower(VFW.GetWeaponFromHash(VFW.PlayerData.weapon).name),
                    bullets = GetAmmoInPedWeapon(VFW.PlayerData.ped, VFW.PlayerData.weapon),
                    maxBullets = GetMaxAmmoInClip(VFW.PlayerData.ped, VFW.PlayerData.weapon),
                }
            })
        else
            SendNUIMessage({
                action = "nui:weapon:data",
                data = {
                    visible = false,
                    weapon = "",
                    bullets = 0,
                    maxBullets = 0,
                }
            })
        end

        Wait(250)
    end
end

RegisterNetEvent("LoadHud", LoadHud)

local lastType = 2

local function HandleMicrophoneAction(visible)
    SendNUIMessage({
        action = "nui:hud:visible:microphone",
        data = {
            visible = visible,
            type = lastType,
        }
    })
end

CreateThread(function()
    while true do
        HandleMicrophoneAction(NetworkIsPlayerTalking(VFW.playerId))
        Wait(250)
    end
end)

AddEventHandler("pma-voice:setTalkingMode", function(type)
    lastType = type
    HandleMicrophoneAction(true, lastType)
end)

local function isVehAllowed()
    if VFW.PlayerData.seat ~= -1 or GetVehicleClass(VFW.PlayerData.vehicle) ~= 18 or IsPedInAnyHeli(VFW.PlayerData.vehicle) or IsPedInAnyPlane(VFW.PlayerData.vehicle) then
        return false
    end

    return true
end

local state = false

local function Thread(veh, seat)
    CreateThread(function()
        while state do
            if veh ~= 0 and (seat == -1 or seat == 0) then
                local shouldUseMetric = ShouldUseMetricMeasurements()
                local speed = math.ceil(GetEntitySpeed(veh) * (shouldUseMetric and 3.6 or 2.236936))
                local _, positionLight, roadLight = GetVehicleLightsState(veh)
                local fuelLevel = GetVehicleFuelLevel(veh)
                local fuelMax = GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume")
                local fuel = fuelMax > 0 and (100 * (fuelLevel / fuelMax)) or 0
                local health = GetVehicleEngineHealth(veh) / 10
                local indicator = GetVehicleIndicatorLights(VFW.PlayerData.vehicle)
                local sirenState = Entity(VFW.PlayerData.vehicle).state
                
                SendNUIMessage({
                    action = "nui:speedometer:visible",
                    data = {
                        visible = true,
                        fuelState = fuel,
                        speedState = speed,
                        motorState = health,
                        HeadlightTop = roadLight,
                        HeadlightBottom = positionLight,
                        TursignalLeft = (indicator == 1 or indicator == 3),
                        TursignalRight = (indicator == 2 or indicator == 3),
                        isSiren = sirenState.lightsOn,
                        isSirenSound = sirenState.sirenMode,
                        is911 = isVehAllowed(),
                    }
                })
            else
                SendNUIMessage({
                    action = "nui:speedometer:visible",
                    data = { visible = false }
                })
            end

            Wait(100)
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
    SendNUIMessage({
        action = "nui:speedometer:visible",
        data = { visible = false }
    })
end)

RegisterKeyMapping('+leftIndicator', 'Clignotant gauche', 'keyboard', 'LEFT')
RegisterCommand('+leftIndicator', function()
    if not VFW.PlayerData.vehicle then return end
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 1, not (GetVehicleIndicatorLights(VFW.PlayerData.vehicle) == 1))
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 0, false)
end)

RegisterKeyMapping('+rightIndicator', 'Clignotant droit', 'keyboard', 'RIGHT')
RegisterCommand('+rightIndicator', function()
    if not VFW.PlayerData.vehicle then return end
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 0, not (GetVehicleIndicatorLights(VFW.PlayerData.vehicle) == 2))
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 1, false)
end)

RegisterKeyMapping('+hazardIndicator', 'Warning', 'keyboard', 'UP')
RegisterCommand('+hazardIndicator', function()
    if not VFW.PlayerData.vehicle then return end
    local indicator = GetVehicleIndicatorLights(VFW.PlayerData.vehicle)
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 1, not (indicator == 3))
    SetVehicleIndicatorLights(VFW.PlayerData.vehicle, 0, not (indicator == 3))
end)
