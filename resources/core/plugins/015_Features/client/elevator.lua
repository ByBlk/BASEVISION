local currentElevator = nil

function OpenMenuElevator(elevatorData, currentFloor)
    currentElevator = elevatorData

    local floorOptions = {}

    for _, entry in ipairs(elevatorData.entries) do
        if entry.floor ~= currentFloor then
            table.insert(floorOptions, {
                entry.floor
            })
        end
    end

    VFW.Nui.ElevatorMenu(true, {
        title = elevatorData.name,
        floor = floorOptions
    })
end

RegisterNuiCallback("nui:elevator:close", function()
    VFW.Nui.ElevatorMenu(false)
end)

RegisterNuiCallback("nui:elevator:selectFloor", function(data)
    if not data then return end

    local selectedFloor = tonumber(data.floor[1])
    local targetEntry

    for _, entry in ipairs(currentElevator.entries) do
        if entry.floor == selectedFloor then
            targetEntry = entry
            break
        end
    end

    if not targetEntry then return end

    VFW.Nui.ElevatorMenu(false)
    VFW.Nui.HudVisible(false)

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(VFW.PlayerData.ped, targetEntry.pos.x, targetEntry.pos.y, targetEntry.pos.z, false, false, false, true)
    SetEntityHeading(VFW.PlayerData.ped, targetEntry.heading or 0.0)

    DoScreenFadeIn(500)
    VFW.Nui.HudVisible(true)
end)
