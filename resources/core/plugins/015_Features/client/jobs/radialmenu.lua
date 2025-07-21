local lastJob = nil
RadialOpen = false
local currentMenu = "main"

local function loadRadialMenu()
    while not next(VFW.Jobs.RadialMenu) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.RadialMenu[lastJob] then return end

    local function getRadialMenu(menuKey)
        local radialData = {}
        print(menuKey, lastJob)
        local menu = VFW.Jobs.RadialMenu[lastJob][menuKey or "main"]

        for _, item in pairs(menu) do
            local tempCatalogue = {
                name = item.name,
                icon = item.icon,
                action = item.action or nil,
                args = item.args or nil
            }

            table.insert(radialData, tempCatalogue)
        end

        return radialData
    end

    local function OpenRadialJob(menuKey)
        if RadialOpen then
            VFW.Nui.Radial(nil, false)
            RadialOpen = false
            return
        end
        RadialOpen = true
        currentMenu = menuKey or "main"
        VFW.Nui.Radial({ elements = getRadialMenu(currentMenu), title = VFW.PlayerData.job.label }, true)
    end

    function OpenSubRadialJobs(submenu)
        VFW.Nui.Radial({ elements = getRadialMenu(submenu), title = VFW.PlayerData.job.label }, true)
    end

    VFW.RegisterInput("radialjob", "Menu radial job", "keyboard", "F1", function()
        OpenRadialJob()
    end)

    console.debug(("^3[%s]: ^7RadialMenu ^3loaded"):format(VFW.PlayerData.job.label))
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(500)
    loadRadialMenu()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadRadialMenu()
end)
