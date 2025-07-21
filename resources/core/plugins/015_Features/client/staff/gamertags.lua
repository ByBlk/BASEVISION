local gamerTags = {}
local pendingPlayers = {}
local datas = {}
local gamerTagActive = false

local function IsValid(var, varType)
    if varType then
        return var ~= nil and type(var) == varType
    end
    return var ~= nil
end

RegisterNetEvent("Admin:updateValue", function(ADMIN_KEY, ADMIN_DATA)
    local key = tonumber(ADMIN_KEY) or ADMIN_KEY
    datas[key] = ADMIN_DATA

    if pendingPlayers[key] then
        pendingPlayers[key] = nil
    end
end)

RegisterNetEvent("Admin:removeValue", function(ADMIN_KEY)
    local key = tonumber(ADMIN_KEY) or ADMIN_KEY
    datas[key] = nil
    pendingPlayers[key] = nil
end)

RegisterNetEvent("Admin:gamerTag", function(BOOLEAN)
    gamerTagActive = BOOLEAN
    if gamerTagActive then
        CreateThread(function()
            while gamerTagActive do
                local MY_PED, ACTIVE_PLAYERS = PlayerPedId(), GetActivePlayers()

                for PLY_INDEX = 1, (#ACTIVE_PLAYERS) do
                    local PLAYER_ID = ACTIVE_PLAYERS[PLY_INDEX]
                    local PLAYER_PED, PLAYER_SERVER_ID = GetPlayerPed(PLAYER_ID), GetPlayerServerId(PLAYER_ID)

                    if ((#(GetEntityCoords(MY_PED, false) - GetEntityCoords(PLAYER_PED, false))) < 5000.0) then
                        local PLAYER_DATA = datas[PLAYER_SERVER_ID]

                        if not PLAYER_DATA and not pendingPlayers[PLAYER_SERVER_ID] then
                            pendingPlayers[PLAYER_SERVER_ID] = true
                            TriggerServerEvent("Admin:requestPlayerData", PLAYER_SERVER_ID)
                        end

                        if (IsValid(PLAYER_DATA, "table")) then
                            local tag = tostring(PLAYER_DATA["NAME"])
                            if StaffMenu.showRPNamesOnPlayerTags then
                                tag = tostring(PLAYER_DATA["RP_NAME"])
                            end

                            gamerTags[PLAYER_PED] = CreateFakeMpGamerTag(PLAYER_PED, ('%s - %s'):format(tostring(PLAYER_DATA["ID"]), tag), false, false, false, 0, 0, 0, 0)

                            SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 4, 255)
                            SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 0, true)
                            SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 2, true)
                            SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 4, NetworkIsPlayerTalking(PLAYER_ID))

                            if PLAYER_DATA["NEW"] then
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 6, true)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 6, 255)
                            else
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 6, false)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 6, 0)
                            end

                            if PLAYER_DATA["IS_GAMERTAG"] then
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 14, true)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 14, 255)
                            else
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 14, false)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 14, 0)
                            end

                            if PLAYER_DATA["PREMIUM"] then
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 7, true)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 7, 255)
                            else
                                SetMpGamerTagVisibility(gamerTags[PLAYER_PED], 7, false)
                                SetMpGamerTagAlpha(gamerTags[PLAYER_PED], 7, 0)
                            end
                        end

                        if PLAYER_DATA ~= nil then
                            if NetworkIsPlayerTalking(PLAYER_ID) then
                                SetMpGamerTagColour(gamerTags[PLAYER_PED], 0, 18)
                            else
                                if PLAYER_DATA["COLOR"] then
                                    SetMpGamerTagColour(gamerTags[PLAYER_PED], 0, VFW.DecimalColorToHUDColor(tonumber(PLAYER_DATA["COLOR"])).id)
                                else
                                    SetMpGamerTagColour(gamerTags[PLAYER_PED], 0, 0)
                                end
                            end
                        end
                    else
                        if gamerTags[PLAYER_PED] then
                            RemoveMpGamerTag(gamerTags[PLAYER_PED])
                            gamerTags[PLAYER_PED] = nil
                        end
                    end
                end

                Wait(25)
            end

            for _,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end

            gamerTags = {}
        end)
    end
end)

function VFW.UpdateAllGamerTags()
    for playerPed, tag in pairs(gamerTags) do
        RemoveMpGamerTag(tag)
        gamerTags[playerPed] = nil
    end
end

function VFW.IsGamerTagsActive()
    return gamerTagActive
end
