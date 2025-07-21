local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function timeFormatToSeconds(time)
    local timeParts = split(time, ':')
    local hours = tonumber(timeParts[1]) or 0
    local minutes = tonumber(timeParts[2]) or 0
    local seconds = tonumber(timeParts[3]) or 0
    return (hours * 3600) + (minutes * 60) + seconds
end

RegisterNetEvent("core:antitroll:load", function()
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal then return end
    local new = timeFormatToSeconds(playerGlobal.total_playtime or "OO:OO:OO") < 3600

    TriggerClientEvent("core:antitroll:load", src, new)
end)

RegisterServerCallback("core:antitroll:check", function(source)
    local new = timeFormatToSeconds(VFW.GetPlayerTime(source) or "OO:OO:OO") < 3600

    return new
end)
