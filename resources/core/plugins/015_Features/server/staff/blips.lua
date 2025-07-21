local blipsData = {}
local PLAYER_MANAGER = {
    LIST = {}
}

RegisterNetEvent("Admin:activeBlips", function(blips_boolean)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions or not playerGlobal.permissions["staff_menu"] then
        return
    end

    if not blips_boolean then
        TriggerClientEvent("ADMIN:BLIP:ACTIONS", source, {
            ["ACTION"] = "DELETE",
            ["VALUE"] = "ALL"
        })
        blipsData[source] = nil
        return
    end

    if not blipsData[source] then
        blipsData[source] = true
        return
    end
end)

function PLAYER_MANAGER.getFromId(PLAYER_ID)
    local SELECT_PLAYER = PLAYER_MANAGER["LIST"][tonumber(PLAYER_ID)]

    return (type(SELECT_PLAYER) == "table" and SELECT_PLAYER) or false
end

function PLAYER_MANAGER.check(PLAYER_ID)
    local PLAYER_PED = GetPlayerPed(PLAYER_ID)
    if (PLAYER_PED == 0) then
        return false
    end

    local TARGET_GLOBAL = VFW.GetPlayerGlobalFromId(PLAYER_ID)
    local TARGET = VFW.GetPlayerFromId(PLAYER_ID)
    if (not TARGET_GLOBAL or not TARGET or not TARGET.source or not TARGET_GLOBAL.pseudo) then
        return false
    end

    local color = nil
    if TARGET_GLOBAL.permissions and TARGET_GLOBAL.permissions["staff_menu"] then
        color = 17
    end

    local DATA = {
        ["ID"] = VFW.GetPermId(TARGET.source),
        ["NAME"] = ((PLAYER_PED ~= 0 and TARGET_GLOBAL.pseudo) or ("FAKE_PLAYER#%s"):format(PLAYER_ID)),
        ["COLOR"] = color,
        ["COORDS"] = {
            ["POS"] = ((PLAYER_PED ~= 0 and GetEntityCoords(PLAYER_PED)) or vector3(math.random(-2000.0, 2000.0), math.random(-2000.0, 2000.0), math.random(-2000.0, 2000.0))),
            ["HEADING"] = ((PLAYER_PED ~= 0 and GetEntityHeading(PLAYER_PED)) or math.random(50.0, 360.0))
        }
    }

    PLAYER_MANAGER["LIST"][tonumber(PLAYER_ID)] = DATA

    return DATA
end

function PLAYER_MANAGER.delete(PLAYER_ID)
    if (not PLAYER_MANAGER.getFromId(PLAYER_ID)) then
        return false
    end

    PLAYER_MANAGER["LIST"][tonumber(PLAYER_ID)] = nil

    for adminSrc, _ in pairs(blipsData) do
        TriggerClientEvent("ADMIN:BLIP:ACTIONS", adminSrc, {
            ["ACTION"] = "DELETE",
            ["VALUE"] = PLAYER_ID
        })
    end
end

CreateThread(function()
    while true do
        local PLAYERS_LIST = GetPlayers()

        for i = 1, #PLAYERS_LIST do
            local selectPLAYER_ID = PLAYERS_LIST[i]

            if (GetPlayerPed(selectPLAYER_ID) ~= 0) then
                PLAYER_MANAGER.check(selectPLAYER_ID)
            end
        end

        for adminSrc, _ in pairs(blipsData) do
            TriggerClientEvent("ADMIN:BLIP:ACTIONS", adminSrc, {
                ["ACTION"] = "LIST",
                ["VALUE"] = PLAYER_MANAGER["LIST"]
            })
        end

        Wait(3000)
    end
end)

AddEventHandler("vfw:playerDropped", function(playerId)
    local PLAYER_ID = playerId
    return PLAYER_MANAGER.delete(tonumber(PLAYER_ID))
end)

AddEventHandler("vfw:playerLoaded", function(playerId)
    PLAYER_MANAGER.check(playerId)

    for adminSrc, _ in pairs(blipsData) do
        TriggerClientEvent("ADMIN:BLIP:ACTIONS", adminSrc, {
            ["ACTION"] = "LIST",
            ["VALUE"] = PLAYER_MANAGER["LIST"]
        })
    end
end)
