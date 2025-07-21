local lastJob = nil
local contextMenu = {}

local function loadContextMenu()
    while not next(VFW.Jobs.ContextMenu) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.ContextMenu[lastJob] then return end

    contextMenu = {}

    local submenupedsKey = ("%submenupedsKey"):format(lastJob)
    contextMenu[submenupedsKey] = VFW.ContextAddSubmenu("ped", VFW.PlayerData.job.label, function(ped)
        local isPlayer = NetworkGetPlayerIndexFromPed(ped)
        local pId = GetPlayerServerId(isPlayer)
        local source = GetPlayerServerId(PlayerId())
        local isSamePlayer = pId ~= source
        local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(ped), true)
        return distance < 2.75 and IsPedAPlayer(ped) and lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty and isSamePlayer
    end, {
        color = { 44, 135, 255 }
    })

    local submenuvehKey = ("%submenuvehKey"):format(lastJob)
    contextMenu[submenuvehKey] = VFW.ContextAddSubmenu("vehicle", VFW.PlayerData.job.label, function(vehicle)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
        return distance < 2.75 and lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty
    end, {
        color = { 44, 135, 255 }
    })

    local submenuworldKey = ("%submenuworldKey"):format(lastJob)
    contextMenu[submenuworldKey] = VFW.ContextAddSubmenu("world", VFW.PlayerData.job.label, function()
        return lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty
    end, {
        color = { 44, 135, 255 }
    })

    for category, actions in pairs(VFW.Jobs.ContextMenu[lastJob]) do
        for _, action in ipairs(actions) do
            if category == "veh" then
                VFW.ContextAddButton("vehicle", action.label, function(vehicle)
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
                    return distance < 2.75 and lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty
                end, function(vehicle)
                    action.callback(vehicle)
                end, action.style or {}, contextMenu[submenuvehKey])
            elseif category == "ped" then
                VFW.ContextAddButton("ped", action.label, function(ped)
                    local isPlayer = NetworkGetPlayerIndexFromPed(ped)
                    local pId = GetPlayerServerId(isPlayer)
                    local source = GetPlayerServerId(PlayerId())
                    local isSamePlayer = pId ~= source
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(ped), true)
                    return distance < 2.75 and IsPedAPlayer(ped) and lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty and isSamePlayer
                end, function(ped)
                    action.callback(ped)
                end, action.style or {}, contextMenu[submenupedsKey])
            elseif category == "world" then
                VFW.ContextAddButton("world", action.label, function()
                    return lastJob ~= "unemployed" and VFW.PlayerData.job.onDuty
                end, function(_, worldPosition)
                    action.callback(worldPosition)
                end, action.style or {}, contextMenu[submenuworldKey])
            end
        end
    end

    console.debug(("^3[%s]: ^7ContextMenu ^3loaded"):format(VFW.PlayerData.job.label))
end

local function clearContextMenu()
    for key, _ in pairs(contextMenu) do
        VFW.ContextRemoveButton(contextMenu[key])
        contextMenu[key] = nil
    end
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    clearContextMenu()
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(500)
    loadContextMenu()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        clearContextMenu()
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadContextMenu()
end)
