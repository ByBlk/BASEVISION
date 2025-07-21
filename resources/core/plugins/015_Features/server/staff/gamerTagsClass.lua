VFW.GamerTags = {}

function VFW.CreateGamertagsClass(id, name, rp_name, premium, color, new)
    local self = {}

    self["ID"] = id or "Unknown"
    self["NAME"] = name or "Unknown"
    self["RP_NAME"] = rp_name or "Unknown"
    self["PREMIUM"] = premium or false
    self["COLOR"] = color or nil
    self["NEW"] = new or false
    self["IS_GAMERTAG"] = false

    return self
end

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
    local hours = tonumber(timeParts[1])
    local minutes = tonumber(timeParts[2])
    local seconds = tonumber(timeParts[3])
    return (hours * 3600) + (minutes * 60) + seconds
end

local NEW_PLAYER_THRESHOLD = 3600 * 5

RegisterNetEvent("vfw:playerLoaded", function(playerId, xPlayer)
    local playerGlobal = VFW.GetPlayerGlobalFromId(playerId)
    local playTime = VFW.GetPlayerTime(playerId)
    local playTimeSeconds = timeFormatToSeconds(playTime) or 0
    local isNewPlayer = playTimeSeconds < NEW_PLAYER_THRESHOLD
    local color = VFW.GetPermissionColor(playerId)

    VFW.GamerTags[playerId] = VFW.CreateGamertagsClass(
            VFW.GetPermId(playerId) or "Unknown",
            playerGlobal.pseudo or "Unknown",
            xPlayer.getName() or "Unknown",
            (playerGlobal.permissions and (playerGlobal.permissions["premium"] or playerGlobal.permissions["premiumplus"])) or false,
            color or nil,
            isNewPlayer or false
    )

    if VFW.GamerTags[tonumber(playerId)] then
        VFW.GamerTags[tonumber(playerId)]["IS_GAMERTAG"] = VFW.GetLastGamerTag(playerId) or false
        VFW.StaffActionForActive(function(staff_player_source)
            TriggerClientEvent("Admin:updateValue", staff_player_source, playerId, VFW.GamerTags[tonumber(playerId)])
        end)
    end
end)

AddEventHandler("vfw:playerDropped", function(playerId)
    if (VFW.GamerTags[playerId]) then
        VFW.GamerTags[playerId] = nil
        VFW.StaffActionForActive(function(staff_player_source)
            TriggerClientEvent("Admin:removeValue", staff_player_source, playerId)
        end)
    end
end)
