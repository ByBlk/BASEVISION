VFW.weatherTypes = {
    {type = "EXTRASUNNY", chance = 30},
    {type = "CLEAR", chance = 25},
    {type = "CLOUDY", chance = 15},
    {type = "OVERCAST", chance = 10},
    {type = "RAIN", chance = 5},
    {type = "FOGGY", chance = 5},
    {type = "THUNDER", chance = 5}
}

VFW.CurrentWeather = "EXTRASUNNY"
VFW.WeatherBlacklist = {"XMAS", "HALLOWEEN", "SNOWLIGHT", "SMOG", "BLIZZARD"}
VFW.DynamicWeather = false
VFW.FreezeTime = false
VFW.TimeMultiplierDay = 5
VFW.TimeMultiplierNight = 9
VFW.LastUpdate = os.time()
VFW.DayNightCycles = {
    {irlStart = 9,  irlEnd = 12, type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 12, irlEnd = 13, type = "NIGHT", igStart = 22, igEnd = 7},
    {irlStart = 13, irlEnd = 16, type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 16, irlEnd = 17, type = "NIGHT", igStart = 22, igEnd = 7},
    {irlStart = 17, irlEnd = 20, type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 20, irlEnd = 21, type = "NIGHT", igStart = 22, igEnd = 7},
    {irlStart = 21, irlEnd = 0,  type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 0,  irlEnd = 1,  type = "NIGHT", igStart = 22, igEnd = 7},
    {irlStart = 1,  irlEnd = 4,  type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 4,  irlEnd = 5,  type = "NIGHT", igStart = 22, igEnd = 7},
    {irlStart = 5,  irlEnd = 8,  type = "DAY",   igStart = 7,  igEnd = 22},
    {irlStart = 8,  irlEnd = 9,  type = "NIGHT", igStart = 22, igEnd = 7}
}


local function getRandomWeather()
    local totalChance = 0
    for _, weather in ipairs(VFW.weatherTypes) do
        totalChance = totalChance + weather.chance
    end

    local rand = math.random(1, totalChance)
    local cumulativeChance = 0

    for _, weather in ipairs(VFW.weatherTypes) do
        cumulativeChance = cumulativeChance + weather.chance
        if rand <= cumulativeChance and not VFW.IsBlacklisted(weather.type) then
            return weather.type
        end
    end
    return "EXTRASUNNY"
end

function VFW.InitializeGameTime()
    local currentIRLTime = os.date("*t")
    local irlHour = currentIRLTime.hour
    local irlMin = currentIRLTime.min
    local irlTotalMinutes = irlHour * 60 + irlMin

    for _, cycle in ipairs(VFW.DayNightCycles) do
        local cycleStart = cycle.irlStart * 60
        local cycleEnd = cycle.irlEnd * 60
        if cycleEnd == 0 then cycleEnd = 24 * 60 end

        if (cycleStart < cycleEnd and irlTotalMinutes >= cycleStart and irlTotalMinutes < cycleEnd) or
                (cycleStart > cycleEnd and (irlTotalMinutes >= cycleStart or irlTotalMinutes < cycleEnd)) then

            local cycleDuration
            if cycleStart < cycleEnd then
                cycleDuration = cycleEnd - cycleStart
            else
                cycleDuration = (24 * 60 - cycleStart) + cycleEnd
            end

            local elapsedInCycle = (irlTotalMinutes - cycleStart) % (24 * 60)
            if elapsedInCycle < 0 then elapsedInCycle = elapsedInCycle + (24 * 60) end
            local progress = elapsedInCycle / cycleDuration

            local igDuration
            if cycle.igStart < cycle.igEnd then
                igDuration = cycle.igEnd - cycle.igStart
            else
                igDuration = (24 - cycle.igStart) + cycle.igEnd
            end

            local igTotalHours = cycle.igStart + (progress * igDuration)
            VFW.InGameHour = igTotalHours % 24
            VFW.InGameMinute = (igTotalHours * 60) % 60
            break
        end
    end
end

VFW.InitializeGameTime()

function VFW.IsBlacklisted(weather)
    for _, w in ipairs(VFW.WeatherBlacklist) do
        if w == weather then
            return true
        end
    end
    return false
end


function getCurrentCycle()
    local currentIRLTime = os.date("*t")
    local irlHour = currentIRLTime.hour
    local irlMin = currentIRLTime.min
    local irlTotalMinutes = irlHour * 60 + irlMin

    for _, cycle in ipairs(VFW.DayNightCycles) do
        local cycleStart = cycle.irlStart * 60
        local cycleEnd = cycle.irlEnd * 60
        if cycleEnd == 0 then cycleEnd = 24 * 60 end

        if (cycleStart < cycleEnd and irlTotalMinutes >= cycleStart and irlTotalMinutes < cycleEnd) or
                (cycleStart > cycleEnd and (irlTotalMinutes >= cycleStart or irlTotalMinutes < cycleEnd)) then
            return cycle
        end
    end
    return VFW.DayNightCycles[1]
end

local function updateGameTime()
    local now = os.time()
    local elapsedRealSeconds = now - VFW.LastUpdate
    local elapsedRealMinutes = elapsedRealSeconds / 60
    local currentCycle = getCurrentCycle()
    local currentMultiplier = currentCycle.type == "NIGHT" and VFW.TimeMultiplierNight or VFW.TimeMultiplierDay
    local elapsedGameMinutes = elapsedRealMinutes * currentMultiplier

    VFW.InGameMinute = VFW.InGameMinute + elapsedGameMinutes

    while VFW.InGameMinute >= 60 do
        VFW.InGameMinute = VFW.InGameMinute - 60
        VFW.InGameHour = (VFW.InGameHour + 1) % 24
    end

    VFW.LastUpdate = now
    return math.floor(VFW.InGameHour), math.floor(VFW.InGameMinute)
end

RegisterNetEvent("core:sync:onPlayerJoined", function()
    local hours, minutes = updateGameTime()
    TriggerClientEvent("core:sync:setWeather", source, VFW.CurrentWeather)
    TriggerClientEvent("core:sync:setTime", source, hours, minutes)
end)

CreateThread(function()
    while true do
        Wait(300000)

        if VFW.DynamicWeather then
            local newWeather = getRandomWeather()
            if newWeather ~= VFW.CurrentWeather then
                VFW.CurrentWeather = newWeather
                TriggerClientEvent("core:sync:setWeather", -1, VFW.CurrentWeather)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if VFW.FreezeTime then
            local hours, minutes = updateGameTime()
            TriggerClientEvent("core:sync:setTime", -1, hours, minutes)
        end
    end
end)
