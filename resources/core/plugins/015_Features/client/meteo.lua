VFW.currentHour = 7
VFW.currentMinute = 0
VFW.currentWeather = "EXTRASUNNY"

local function getTimeIcon(hour)
    if hour >= 20 or hour < 6 then
        return "nuit"
    elseif hour >= 6 and hour < 7 then
        return "debut"
    elseif hour >= 7 and hour < 9 then
        return "debut"
    elseif hour >= 9 and hour < 18 then
        return "jour"
    elseif hour >= 18 and hour < 20 then
        return "fin"
    end
    return "jour"
end

local function updateNUIDisplay()
    local displayWeather = VFW.currentWeather
    local hour = tonumber(VFW.currentHour) or 12

    if hour >= 9 and hour < 18 then
        displayWeather = VFW.currentWeather
    else
        displayWeather = getTimeIcon(hour)
    end

    SendNUIMessage({
        action = "nui:weather-time:visible",
        data = {
            visible = true,
            hour = VFW.currentHour,
            minute = VFW.currentMinute,
            weather = displayWeather,
        }
    })
end

RegisterNetEvent("core:sync:setWeather", function(weather)
    if VFW.currentWeather ~= weather then
        SetWeatherTypeOvertimePersist(weather, 15.0)
        Wait(15000)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)

        VFW.currentWeather = weather

        if VFW.currentWeather == "XMAS" then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end

        updateNUIDisplay()
    end
end)

RegisterNetEvent("core:sync:setTime", function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
    SetClockTime(hour, minute, 0)
    VFW.currentHour = hour
    VFW.currentMinute = minute

    updateNUIDisplay()
end)
