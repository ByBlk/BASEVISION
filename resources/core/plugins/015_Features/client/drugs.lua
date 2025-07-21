local DrugsConfig = exports["core"]:GetDrugsConfig()

local zones = {}
local currentPoints = {}
local harvestProps = {}
local processProps = {}

local function randomPoint(points)
    return points[math.random(1, #points)]
end

local function spawnProp(model, coords)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    local obj = CreateObject(model, coords.x, coords.y, coords.z - 1.0, false, false, false)
    SetEntityAsMissionEntity(obj, true, true)
    SetEntityCollision(obj, false, false)
    PlaceObjectOnGroundProperly(obj)
    return obj
end

local function removeProp(obj)
    if obj and DoesEntityExist(obj) then
        DeleteEntity(obj)
    end
end

local function refreshPoints(drugName)
    local drug = DrugsConfig[drugName]
    if not drug then return end
    currentPoints[drugName] = {
        harvest = randomPoint(drug.harvest.positions),
        process = randomPoint(drug.process.positions)
    }
    if zones[drugName] then
        for _, z in pairs(zones[drugName]) do
            Worlds.Zone.Remove(z)
        end
    end
    removeProp(harvestProps[drugName])
    removeProp(processProps[drugName])
    harvestProps[drugName] = spawnProp(`prop_weed_01`, currentPoints[drugName].harvest)
    processProps[drugName] = spawnProp(`prop_barrel_02a`, currentPoints[drugName].process)
    zones[drugName] = {}
    zones[drugName]["harvest"] = Worlds.Zone.Create(currentPoints[drugName].harvest, 1.5, false, function()
        VFW.RegisterInteraction(drugName.."_harvest", function()
            local ped = PlayerPedId()
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
            local progress = VFW.Nui.ProgressBar("Récolte en cours...", 9000)
            ClearPedTasks(ped)
            if progress == true then
                TriggerServerEvent('drugs:'..drugName..':harvest')
            end
        end)
    end, function()
        VFW.RemoveInteraction(drugName.."_harvest")
    end, "Récolter du "..drug.label, "E", "Illegal_recolte", {"#ff6363", "#ff2b2b", "#FFFFFF", 0.7})
    zones[drugName]["process"] = Worlds.Zone.Create(currentPoints[drugName].process, 1.5, false, function()
        VFW.RegisterInteraction(drugName.."_process", function()
            local ped = PlayerPedId()
            TaskStartScenarioInPlace(ped, "PROP_HUMAN_BBQ", 0, true)
            local progress = VFW.Nui.ProgressBar("Traitement en cours...", 9000)
            ClearPedTasks(ped)
            if progress == true then
                TriggerServerEvent('drugs:'..drugName..':process')
            end
        end)
    end, function()
        VFW.RemoveInteraction(drugName.."_process")
    end, "Traiter le "..drug.label, "E", "Illegal_traitement", {"#ff6363", "#ff2b2b", "#FFFFFF", 0.7})
end

for drugName, drug in pairs(DrugsConfig) do
    RegisterNetEvent('drugs:'..drugName..':refreshPoints', function()
        refreshPoints(drugName)
    end)
    RegisterNetEvent('drugs:'..drugName..':notify', function(data)
        VFW.ShowNotification(data)
    end)
end

Citizen.CreateThread(function()
    for drugName, _ in pairs(DrugsConfig) do
        refreshPoints(drugName)
    end
end)
