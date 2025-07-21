local blipsData = {}
local PLAYER_MANAGER = {
    LIST = {}
}

RegisterNetEvent("core:jobs:activeBlips", function(blips_boolean)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    if not xPlayer.getJob() then
        return
    end
    if xPlayer.getJob().type ~= "faction" then
        return
    end

    if not blips_boolean then
        TriggerClientEvent("CORE:JOBS:BLIP:ACTIONS", source, {
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

RegisterNetEvent("core:jobs:setBracelet", function(playerId)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    if not xPlayer.getJob() then
        return
    end
    if xPlayer.getJob().type ~= "faction" then
        return
    end

    local target = VFW.GetPlayerFromId(playerId)
    if not target then
        return
    end
    local targetBracelet = target.getMeta().bracelet

    if targetBracelet.isBracelet then
        target.setMeta("bracelet", { isBracelet = false })
        PLAYER_MANAGER.delete(playerId)
        TriggerClientEvent("__kpz::createNotification", source, {
            type = 'JAUNE',
            content = "Vous avez retiré le bracelet de " .. target.name,
        })
    else
        target.setMeta("bracelet", { isBracelet = true })
        TriggerClientEvent("__kpz::createNotification", source, {
            type = 'JAUNE',
            content = "Vous avez mis un bracelet à " .. target.name,
        })
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

    local TARGET = VFW.GetPlayerFromId(PLAYER_ID)
    if not TARGET or not TARGET.name then
        return false
    end

    local targetBracelet = TARGET.getMeta().bracelet
    if not targetBracelet then
        return false
    end

    if not targetBracelet.isBracelet then
        return false
    end

    local DATA = {
        ["NAME"] = ((PLAYER_PED ~= 0 and TARGET.name) or ("FAKE_PLAYER#%s"):format(PLAYER_ID)),
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
        TriggerClientEvent("CORE:JOBS:BLIP:ACTIONS", adminSrc, {
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
            TriggerClientEvent("CORE:JOBS:BLIP:ACTIONS", adminSrc, {
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
        TriggerClientEvent("CORE:JOBS:BLIP:ACTIONS", adminSrc, {
            ["ACTION"] = "LIST",
            ["VALUE"] = PLAYER_MANAGER["LIST"]
        })
    end
end)
