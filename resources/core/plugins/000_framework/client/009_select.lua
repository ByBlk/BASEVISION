local inSelect = false
local forceStop = false
function VFW.StartSelect(dist, ignoreSelf)
    if inSelect then return end
    inSelect = true
    SendNUIMessage({
        action = "nui:hud:visible:interactNotif",
        data = {
            visible = true
        }
    })

    VFW.DisableInterations(true)

    local playerSelected
    while inSelect do
        local playersList = VFW.Game.GetPlayersInArea(GetEntityCoords(VFW.PlayerData.ped), dist, ignoreSelf and {VFW.playerId} or nil)
        local selectedHear = false
        for i = 1, #playersList do
            if playersList[i] == playerSelected then
                selectedHear = true
                break
            end
        end

        if not selectedHear then
            playerSelected = playersList[1]
        end

        if playerSelected then
            DrawMarker(2, GetEntityCoords(GetPlayerPed(playerSelected))+vec3(0,0,1), .0, .0, .0, .0, 180.0, .0, .3, .3, .3, 255, 255, 255, 140, 0, 0, 2, 1, nil, nil, 0)
        end

        if IsControlJustPressed(0, 38) then
            inSelect = false
        elseif IsControlJustPressed(0, 246) then
            if playerSelected then
                for i = 1, #playersList do
                    if playersList[i] == playerSelected then
                        if playersList[i+1] then
                            playerSelected = playersList[i+1]
                        else
                            playerSelected = playersList[1]
                        end
                        break
                    end
                end
            end
        elseif IsControlJustPressed(0, 306) or forceStop then
            inSelect = false
            playerSelected = nil
        end

        Wait(0)
    end

    forceStop = false
    inSelect = false
    VFW.DisableInterations(false)
    SendNUIMessage({
        action = "nui:hud:visible:interactNotif",
        data = {
            visible = false
        }
    })
    return playerSelected
end

function VFW.ForceStopSelect()
    if inSelect then
        forceStop = true
    end
end