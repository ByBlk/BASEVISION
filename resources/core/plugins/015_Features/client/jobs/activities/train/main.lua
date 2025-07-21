
local train
local insert = false
local PlayersInJob = {}
local PlayersId = {}
local hidemarker = false
local shouldDecharge = true
local DLCMars = true
local InsideZoneSlow = false
local SlowZones = {
    vector3(-327.18380737305, 5948.3193359375, 40.573261260986),
    vector3(1790.8619384766, 3498.400390625, 37.758052825928),
    vector3(2172.7763671875, 3717.8544921875, 37.492031097412),
    vector3(158.78112792969, -2100.6513671875, 15.523509979248),
    vector3(188.17074584961, -1962.8299560547, 18.735847473145),
    vector3(246.34248352051, -1894.3791503906, 25.009220123291),
    vector3(337.14743041992, -1786.1184082031, 27.627416610718),
    vector3(432.37048339844, -1672.3115234375, 28.195081710815),
    vector3(2610.8278808594, 1750.52734375, 25.405025482178),
    vector3(3026.0993652344, 4284.73828125, 59.74813079834),
    vector3(218.11433410645, -2164.4768066406, 13.230734825134),
}


function loadTrainModels()
    local trainsAndCarriages = {
        'freight', 'metrotrain', 'freightcont1', 'freightcar', 
        'freightcar2', 'freightcont2', 'tankercar', 'freightgrain'
    }

    for _, vehicleName in ipairs(trainsAndCarriages) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey) -- load the model
        -- wait for the model to load
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(200)
        end
    end
end

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(5)
    end
end

function CreateTrain(isFriend)
    if not isFriend then
        loadModel('freight')
        loadModel('freightcar')
        loadModel('tr_prop_tr_container_01a')
        loadModel('prop_ld_container')
        loadModel('tr_prop_tr_lock_01a')
        loadModel('xm_prop_lab_desk_02')
        loadTrainModels()
        Wait(200)
        train = CreateMissionTrain(24, -139.67497253418, 6142.466796875, 30.577228546143, true, true, true)
        while not DoesEntityExist(train) do Wait(1) end
        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, train, -1)
        TriggerServerEvent("core:activities:update", PlayersId, "train", {train = VehToNet(train)})
    end
    if isFriend then 
        train = NetToVeh(isFriend.train)
        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, train, 0)
    end
    --exports['tuto-wl']:OpenStepCustom("Conducteur de train", "Conduit le train, jusqu'a son prochain arrêt")
    CreateThread(function()
        while DoesEntityExist(train) do
            Wait(250)
            for k,v in pairs(SlowZones) do 
                if GetDistanceBetweenCoords(GetEntityCoords(train), v) < 80.0 then 
                    SetTrainCruiseSpeed(train, 25.0)
                end
            end
        end
    end)


    while DoesEntityExist(train) do 
        Wait(1)
        if DoesEntityExist(train) then
            if IsPedInVehicle(PlayerPedId(), train, false) then
                if IsControlPressed(0, 32) then -- "Z"
                    SetTrainCruiseSpeed(train, 80.0)
                end
                if IsControlPressed(0, 33) then -- "S" 
                    SetTrainCruiseSpeed(train, 15.0)
                end
            end

            if GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(train)) < 6.0 then 
                if IsControlJustPressed(0, 75) then 
                    TaskWarpPedIntoVehicle(VFW.PlayerData.ped, train, -1)
                end
            end
        end

        if not hidemarker then 
            DrawMarker(43, 669.18304443359, -978.31384277344, 21.49976348877, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 
                51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
        end

        -- DECHARGE
        if shouldDecharge and GetDistanceBetweenCoords(vector3(669.18304443359, -978.31384277344, 21.49976348877), GetEntityCoords(VFW.PlayerData.ped)) < 4.0 then 
            hidemarker = true
            shouldDecharge = false
        end

        -- FINISH
        if GetDistanceBetweenCoords(vector3(-186.20272827148, 6095.8564453125, 30.651691436768), GetEntityCoords(VFW.PlayerData.ped)) < 4.0 then 
            hidemarker = false
            shouldDecharge = true
            endMissionTrain()
        end
    end
    hidemarker = false
    shouldDecharge = true
end

function endMissionTrain()
    PlayersInJob = {
        { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
    }
    SetEntityCoords(VFW.PlayerData.ped, -140.67037963867, 6145.5571289062, 31.438667297363)
    SetTrainCruiseSpeed(train, 0.0)
    DeleteMissionTrain(train)
    --exports['tuto-wl']:HideStep()

    local price = 230

    TriggerServerEvent("core:activities:train:finish", "train", price)


    VFW.ShowNotification({
        type = "VERT",
        content = "Vous avez gagné "..price.." $"
    })

    local playerSkin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    TriggerEvent('skinchanger:loadSkin', playerSkin or {})
end

function OpenMenuTraiInter()
    if not insert then 
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
        insert = true
    end
    Wait(50)

    VFW.Nui.JobMenu(true, {
        headerBanner = "https://cdn.eltrane.cloud/alkiarp/assets/jobmenu/train_header.webp",
        choice = {
            label = "Trains",
            isOptional = false,
            choices = {{id = 1, label = 'Train de fret', name = 'train', img= "https://cdn.eltrane.cloud/alkiarp/assets/jobmenu/train_vehicle.webp"}},
        },
        participants = PlayersInJob,
        participantsNumber = 1,
        callbackName = "MetierTrain",
    })
end

RegisterNUICallback("MetierTrain", function(data)
    if not data then return end

    if data.button == "start" then
        PlayersId = {}
        for _, v in pairs(PlayersInJob) do
            table.insert(PlayersId, v.id)
        end
        TriggerServerEvent("core:activities:create", PlayersId, "train")
        VFW.Nui.JobMenu(false)
        Wait(50)

        CreateTrain()
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "train")
        for k,v in pairs(PlayersInJob) do
            if v.id == playerSe then table.remove(PlayersInJob, k) end
        end
        if PlayersId then
            for k,v in pairs(PlayersId) do
                if v == playerSe then table.remove(PlayersId, k) end
            end
        end
        Wait(50)
        -- OpenMenuTramway()
    elseif data.button == "addPlayer" and data.selected ~= 0 then
        VFW.Nui.JobMenu(false)
        local closestPlayer = VFW.StartSelect(5.0, true)
        if closestPlayer then
            TriggerServerEvent("core:activities:askJob", GetPlayerServerId(closestPlayer), "train")
        end
        Wait(50)
        -- OpenMenuTramway()
    elseif data.button == "stop" then
        DeleteMissionTrain(train)
        local playerSkin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', playerSkin or {})
    end
end)

RegisterNuiCallback("nui:job-menu:close", function() VFW.Nui.JobMenu(false) end)




RegisterCommand("trainInt", function()
    OpenMenuTraiInter()
end)

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "train" then 
        --AddTenueTrain()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "train" then 
            CreateTrain(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "train" then 
        endMissionTrain()
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)