local RequestScriptAudioBank <const> = RequestScriptAudioBank

local function getTopFive()
    local totalTopFive = TriggerServerCallback("core:territories:getTopFive")
    local result = {
        week = {},
        month = {},
        global = {}
    }

    table.sort(totalTopFive.week, function(a, b)
        return a.influence > b.influence
    end)
    table.sort(totalTopFive.month, function(a, b)
        return a.influence > b.influence
    end)
    table.sort(totalTopFive.global, function(a, b)
        return a.influence > b.influence
    end)

    console.debug("Get Top Five Territoire")
    for i = 1, 5 do
        if totalTopFive.week[i] then
            if totalTopFive.week[i].influence ~= 12000 then
                result.week[#result.week + 1] = totalTopFive.week[i]
            end
        end
        if totalTopFive.month[i] then
            if totalTopFive.month[i].influence ~= 12000 then
                result.month[#result.month + 1] = totalTopFive.month[i]
            end
        end
        if totalTopFive.global[i] then
            if totalTopFive.global[i].influence ~= 12000 then
                result.global[#result.global + 1] = totalTopFive.global[i]
            end
        end
    end

    return result
end

function OpenMenuTerrioire(variation)
    VFW.Nui.Radial(nil, false)
    variation = (variation or "global")
    local DataToSend = {
        crews_over = variation,
        revendication = 100,
        crew = VFW.PlayerData.faction.name,
    }
    local topFive = getTopFive()
    DataToSend.crews = {
        semaine = topFive.week,
        mois = topFive.month,
        global = topFive.global,
    }
    DataToSend.zone = "TERRITOIRES"

    DataToSend.territories = TriggerServerCallback("core:territories:getShowTerritories")
    print("Territories : ", json.encode(DataToSend.territories, { indent = true }))
    DataToSend.location = "San Andreas"
    for i = 1, #DataToSend.territories do
        --console.debug(json.encode(DataToSend.territories[i].polygon), next(DataToSend.territories[i].polygon))
        if (not next(DataToSend.territories[i].polygon)) then
            DataToSend.territories[i].polygon = {
                { 0, 0 },
            }
        end
        if not DataToSend.territories[i].business then
            DataToSend.territories[i].business = {
                { label = 'Magasin de masques' },
            }
        end

        console.debug("Resell indice : ", DataToSend.territories[i].resellIndice)

        print("DataToSend.territories", json.encode(DataToSend.territories[i], { indent = true }))
        --DataToSend.territories[i].resellIndice =
        -- TODO : image crew
        --if (not DataToSend.territories[i].image) then
        DataToSend.territories[i].image = "https://cdn.eltrane.cloud/alkiarp/assets/Illégal/Image/Groupes/" .. DataToSend.territories[i].topCrews[1].leader .. ".webp"
        DataToSend.territories[i].color = DataToSend.territories[i].topCrews[1].color
        --DataToSend.territories[i].options = {}
        DataToSend.territories[i].options.color = DataToSend.territories[i].topCrews[1].color
        --end
    end
    print("DataToSend.territories", json.encode(DataToSend.territories, { indent = true }))
    VFW.Nui.TerritoriesMenu(true, DataToSend)
end

RegisterNUICallback("nui:territories:close", function()
    VFW.Nui.TerritoriesMenu(false)
end)

local inTerritorySteal = false
local canTakeTerritory = false
local timeBlock = 300

local function startTerritorySteal()
    if (not inTerritorySteal) then
        inTerritorySteal = true
        CreateThread(function()
            while inTerritorySteal do
                Wait(1000)
                timeBlock = timeBlock - 1
                if timeBlock <= 0 then
                    inTerritorySteal = false
                    break
                end
            end
        end)
    end
end

local uiMessageSend = false
local lastZoneName = nil

RegisterNetEvent("vfw:playerLoaded", function()
    CreateThread(function()
        while true do
            Wait(1000)

            --todo: A opti demain
            local zoneName = VFW.Territories.GetZoneByPlayer()
            local zone = zoneName and VFW.Territories.GetZoneByName(zoneName)

            if zone and zone.name ~= lastZoneName then

                local topOne = nil

                if #zone.global > 1 then
                    topOne = zone.global[1]
                    for i = 1, #zone.global do
                        local currentCrew = zone.global[i]
                        if currentCrew.influence > topOne.influence then
                            topOne = currentCrew
                        end
                    end
                elseif #zone.month > 1 then
                    topOne = zone.month[1]
                    for i = 1, #zone.month do
                        local currentCrew = zone.month[i]
                        if currentCrew.influence > topOne.influence then
                            topOne = currentCrew
                        end
                    end
                elseif #zone.week > 1 then
                    topOne = zone.week[1]
                    for i = 1, #zone.week do
                        local currentCrew = zone.week[i]
                        if currentCrew.influence > topOne.influence then
                            topOne = currentCrew
                        end
                    end
                end

                print("zone", json.encode(zone, { indent = true }))
                if not uiMessageSend then
                    SendNUIMessage({
                        action = "nui:localisationHud:visible",
                        data = {
                            visible = true,
                            position = zone.name,
                            color = topOne and topOne.color or "#10A8D1",
                            icon = topOne and topOne.leader or "",
                        }
                    })

                    uiMessageSend = true
                    lastZoneName = zone.name

                    Citizen.SetTimeout(4000, function()
                        SendNUIMessage({
                            action = "nui:localisationHud:visible",
                            data = { visible = false }
                        })
                        uiMessageSend = false
                    end)
                end

            elseif not zone and uiMessageSend then
                SendNUIMessage({
                    action = "nui:localisationHud:visible",
                    data = { visible = false }
                })
                uiMessageSend = false
                lastZoneName = nil
            end
        end
    end)
end)


local function startRevendication()
    RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1)
    local PLAYER_ZONE <const> = VFW.Territories.GetZoneByPlayer()
    local zone = VFW.Territories.GetZoneByName(PLAYER_ZONE)
    if next(zone) and zone.global[1] then
        if VFW.PlayerData.faction.name == zone.global[1].leader then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez pas revendiquer une zone que vous possédez déjà"
            })
            return
        end
        local isThisZoneTaken = TriggerServerCallback("core:territories:hasZoneBeenTaken", PLAYER_ZONE)
        local inZone = true
        if (isThisZoneTaken) then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Cette zone à déjà été revendiqué récemment"
            })
            return
        end
        local timer = 1
        while (not RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1)) and timer < 500 do
            Wait(1)
            timer += 1
        end
        PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
        startTerritorySteal()
        VFW.ShowNotification({
            type = "ILLEGAL",
            name = "Revendication",
            label = PLAYER_ZONE,
            labelColor = MyFaction.MyCrewColor or "#10A8D1",
            logo = "https://cdn.eltrane.cloud/alkiarp/Discord/11871954819531448521187719957442744320image.webp",
            mainMessage = "Attendez 5 minutes dans cette zone pour la revendiquer ! Le leader peut être prévenu.",
            duration = 10,
        })
        ActionInTerritoire(VFW.PlayerData.faction.name, PLAYER_ZONE, 1, 14, VFW.IsCoordsInSouth(GetEntityCoords(VFW.PlayerData.ped)))
        CreateThread(function()
            local timer = 1
            while true do
                Wait(1)
                VFW.DrawTimeBars("Revendication dans " .. tostring(VFW.DisplayTime(timeBlock)), 1, 0.025)
                timer += 1
                if timer == 500 then
                    local territoire = zone.zone
                    local coords = GetEntityCoords(VFW.PlayerData.ped, true)
                    local pX, pY, pZ = coords.x, coords.y, coords.z
                    if (not VFW.IsPlayerInsideZone(territoire, pX, pY)) then
                        inZone = false
                    end
                    timer = 1
                end
                if (not inZone) then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous avez quitté la zone, la revendication est annulé"
                    })
                    canTakeTerritory = false
                    break
                end
                if (not inTerritorySteal) then
                    canTakeTerritory = true
                end
                if canTakeTerritory then
                    VFW.ShowNotification({
                        type = "ILLEGAL",
                        name = "Revendication",
                        label = PLAYER_ZONE,
                        labelColor = MyFaction.MyCrewColor or "#10A8D1",
                        logo = "https://cdn.eltrane.cloud/alkiarp/Discord/11871954819531448521187719957442744320image.webp",
                        mainMessage = "Votre crew revendique la zone " .. PLAYER_ZONE .. " !",
                        duration = 10,
                    })
                    ActionInTerritoire(VFW.PlayerData.faction.name, PLAYER_ZONE, 100, 15, VFW.IsCoordsInSouth(GetEntityCoords(VFW.PlayerData.ped)))
                    break
                end
            end
            ReleaseScriptAudioBank()
            inTerritorySteal = false
            canTakeTerritory = false
        end)
    else
        VFW.ShowNotification({
            type = "ILLEGAL",
            name = "Revendication",
            label = PLAYER_ZONE,
            labelColor = MyFaction.MyCrewColor or "#10A8D1",
            logo = "https://cdn.eltrane.cloud/alkiarp/Discord/11871954819531448521187719957442744320image.webp",
            mainMessage = "Votre crew revendique la zone " .. PLAYER_ZONE,
            duration = 10,
        })
        ActionInTerritoire(VFW.PlayerData.faction.name, PLAYER_ZONE, 100, 14, VFW.IsCoordsInSouth(GetEntityCoords(VFW.PlayerData.ped)))
    end
end

local function transformPolygonToCoord(poly)
    local result = {}
    for i = 1, #poly do
        result[#result + 1] = { x = poly[i][2], y = poly[i][1] }
    end
    return result
end

RegisterNUICallback("nui:territories:submit", function(data)
    local coo = GetEntityCoords(VFW.PlayerData.ped)
    local zone = transformPolygonToCoord(data.territory.polygon)

    -- Extraire les coordonnées x et y du vecteur
    if (not VFW.IsPlayerInsideZone(zone, coo.x, coo.y)) then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous n'êtes pas dans la zone"
        })
        return
    end
    VFW.Nui.TerritoriesMenu(false)
    startRevendication()
end)