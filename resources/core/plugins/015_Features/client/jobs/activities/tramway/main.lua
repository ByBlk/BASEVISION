local insert = false
local tram = nil
local StationToGo = 1
local blip = nil
local PlayersId = {}
local PlayersInJob = {}
local DLCMars = true
local TramPeds = {}


local TrajetsTram = {
    {
        TramSpawn = vector3(-498.7607421875, -680.59393310547, 9.9208860397339),
        PnjSpawnArea = vector3(-501.94165039062, -677.01226806641, 10.808960914612),
        TakeTram = vector4(-534.93597412109, -674.98834228516, 10.808974266052, 272.13305664062),
        GotoPed = vector3(-497.40921020508, -680.75177001953, 10.861402511597),
        maxNPC = math.random(3, 7),
        Stations = {
            vector3(-218.06478881836, -1032.5264892578, 28.325445175171),
            vector3(122.80764770508, -1737.68359375, 28.054738998413),
            vector3(109.93307495117, -1715.8511962891, 28.129474639893),
            vector3(-206.00556945801, -1026.3991699219, 28.324773788452),
            vector3(-512.25152587891, -665.74517822266, 9.912693977356),
        },
        StationsPed = {
            vector3(-214.193359375, -1029.2198486328, 29.140468597412),
            vector3(118.22438812256, -1729.9093017578, 29.110849380493),
            vector3(113.62266540527, -1722.3287353516, 29.112947463989),
            vector3(-210.59341430664, -1029.5753173828, 29.139059066772),
            vector3(-508.96597290039, -669.2578125, 10.808961868286),
        },
        StationsInside = {
            vector3(-216.37489318848, -1027.9421386719, 28.325445175171),
            vector3(113.18564605713, -1729.4057617188, 29.020282745361),
            vector3(114.15760040283, -1719.4011230469, 29.128114700317),
            vector3(-210.59341430664, -1029.5753173828, 29.139059066772),
            vector3(-506.77508544922, -665.33447265625, 9.9162216186523),
        },
    }
}

local function CreateMissionPnjTram(amount, posspawn, pedgoto)
    local possiblePnj = {"a_f_m_ktown_01", "a_m_y_busicas_01", "a_f_o_salton_01", "a_f_y_business_03",
        "a_f_y_femaleagent", "a_f_y_topless_01", "a_f_y_gencaspat_01", "a_f_o_genstreet_01", "a_m_y_soucent_01"}
    for i = 1, amount do 
        if possiblePnj[i] then
            local ped = CreatePed(4, GetHashKey(possiblePnj[i]), posspawn, math.random(1, 300), true, false)

            if i <= 2 then
                TaskWarpPedIntoVehicle(ped, tram, i)
            else
                SetEntityCoords(ped, pedgoto)
            end
            SetBlockingOfNonTemporaryEvents(ped, true)
            table.insert(TramPeds, ped)
            Wait(50)
        end
    end
end

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
            Citizen.Wait(500)
        end
    end
end

function endTramWay(pedpos)
    PlayersInJob = {
        { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
    }
    RemoveBlip(blip)
    TaskLeaveVehicle(VFW.PlayerData.ped, tram, 16)
    TaskLeaveAnyVehicle(VFW.PlayerData.ped, 1, 1)
    Wait(1000)
    DeleteMissionTrain(tram)
    if pedpos then SetEntityCoords(PlayerPedId(), pedpos) end
    StationToGo = 1
    local playerSkin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    TriggerEvent('skinchanger:loadSkin', playerSkin or {})



    for k,v in pairs(TramPeds) do 
        DeleteEntity(v)
    end
    TramPeds = {}

    local amount = 150

    TriggerServerEvent("core:activities:tramway:finish", "tram", amount)

    console.debug(amount)

    VFW.ShowNotification({
        type = "VERT",
        content = "Vous avez gagné "..amount..'$',
    })

    tram = nil
end


function CreerTram(trampos, pedpos, pedgoto, pos, stations, stationsped, inside, isfriend)
    if not isfriend then
        loadTrainModels()
        Wait(1000)
        tram = CreateMissionTrain(27, trampos, true, false,false)
        FreezeEntityPosition(tram, true)
        --exports['tuto-wl']:OpenStepCustom("Tram", "Vous avez récupéré des usagers, aller à la prochaine station")
        SetVehicleDoorShut(tram, 0, true)
        SetVehicleDoorShut(tram, 1, true)
        SetVehicleDoorShut(tram, 2, true)
        SetVehicleDoorShut(tram, 3, true)
        SetVehicleDoorShut(tram, 4, true)
        SetVehicleDoorShut(tram, 5, true)
        SetVehicleDoorsLocked(tram, 2)
        SetVehicleDoorShut(tram, 0, true)
        SetVehicleDoorShut(tram, 1, true)
        SetVehicleDoorShut(tram, 2, true)
        SetVehicleDoorShut(tram, 3, true)
        SetVehicleDoorShut(tram, 4, true)
        SetVehicleDoorShut(tram, 5, true)
        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, tram, pos)
        SetTrainCruiseSpeed(tram, 0.0)
        CreateMissionPnjTram(5, pedpos, pedgoto)
        FreezeEntityPosition(tram, false)
        TriggerServerEvent("core:activities:update", PlayersId, "tramway", {trampos = trampos, pedpos = pedpos, pedgoto = pedgoto, pos = pos, stations = stations, stationsped = stationsped, inside = inside, isfriend = isfriend, tram = tram})
    else
        --exports['tuto-wl']:OpenStepCustom("Tram", "Vous avez récupéré des usagers, aller à la prochaine station")
        tram = NetToVeh(isfriend.tram)
        TaskWarpPedIntoVehicle(VFW.PlayerData.ped, tram, 0)
    end
    blip = AddBlipForCoord(stations[StationToGo])
    while true do 
        Wait(1)
        if stations[StationToGo] then
            DrawMarker(43, stations[StationToGo] + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 
                51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
        end
        if stations[StationToGo] and stationsped[StationToGo] then
            if GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), stations[StationToGo]) < 4.0 then 
                --exports['tuto-wl']:HideStep()
                SetVehicleDoorsLocked(tram, 0)
                SetTrainCruiseSpeed(tram, 0.0)
                for k,v in pairs(TramPeds) do 
                    ClearPedTasksImmediately(v)
                    TaskLeaveVehicle(v, tram, 1)
                    SetEntityCoords(v, stationsped[StationToGo])
                    SetEntityAsNoLongerNeeded(v)
                end
                Wait(5000)


                VFW.ShowNotification({
                    type = "VERT",
                    content = "Allez à la station suivante pour déposer vos usagers",
                })

                SetVehicleDoorShut(tram, 0, true)
                SetVehicleDoorShut(tram, 1, true)
                SetVehicleDoorShut(tram, 2, true)
                SetVehicleDoorShut(tram, 3, true)
                SetVehicleDoorShut(tram, 4, true)
                SetVehicleDoorShut(tram, 5, true)
                SetVehicleDoorsLocked(tram, 2)
                SetVehicleDoorShut(tram, 0, true)
                SetVehicleDoorShut(tram, 1, true)
                SetVehicleDoorShut(tram, 2, true)
                SetVehicleDoorShut(tram, 3, true)
                SetVehicleDoorShut(tram, 4, true)
                SetVehicleDoorShut(tram, 5, true)
                if stationsped[StationToGo] then
                    CreateMissionPnjTram(5, stationsped[StationToGo], inside[StationToGo])
                end
                StationToGo += 1
                RemoveBlip(blip)
                Wait(700)
                if stations[StationToGo] then
                    blip = AddBlipForCoord(stations[StationToGo])
                end
            end
        else
            for k,v in pairs(TramPeds) do 
                DeleteEntity(v)
            end
            TramPeds =  {}
            endTramWay(pedpos)
            break
        end
        if DoesEntityExist(tram) then
            if IsPedInVehicle(PlayerPedId(), tram, false) then
                if IsControlPressed(0, 32) then -- "Z"
                    SetTrainCruiseSpeed(tram, 15.0)
                end
                if IsControlPressed(0, 33) then -- "S" 
                    SetTrainCruiseSpeed(tram, 5.0)
                end
            end
        end
    end
end



function OpenMenuTramway()
    if not insert then 
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
        insert = true
    end
    Wait(50)

    VFW.Nui.JobMenu(true, {
        headerBanner = "https://cdn.eltrane.cloud/3838384859/assets/jobmenu/tram_header.webp",
        choice = {
            label = "Tram",
            isOptional = false,
            choices = {{id = 1, label = 'Tramway', name = 'tram', img= "https://cdn.eltrane.cloud/3838384859/assets/jobmenu/tram_vehicle.webp"}},
        },
        participants = PlayersInJob,
        participantsNumber = 1,
        callbackName = "MetierTram",
    })
end

RegisterNUICallback("MetierTram", function(data)
    if not data then return end

    if data.button == "start" then
        PlayersId = {}
        for _, v in pairs(PlayersInJob) do
            table.insert(PlayersId, v.id)
        end
        TriggerServerEvent("core:activities:create", PlayersId, "tram")
        VFW.Nui.JobMenu(false)
        Wait(50)

        for k,v in pairs(TrajetsTram) do 
            TramSpawn, PnjSpawnArea, GotoPed, Stations, StationsPed, StationsInside = v.TramSpawn, v.PnjSpawnArea, v.GotoPed, v.Stations, v.StationsPed, v.StationsInside
        end

        CreerTram(TramSpawn, PnjSpawnArea, GotoPed, -1, Stations, StationsPed, StationsInside)
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "tram")
        for k,v in pairs(PlayersInJob) do
            if v.id == playerSe then table.remove(PlayersInJob, k) end
        end
        if PlayersId then
            for k,v in pairs(PlayersId) do
                if v == playerSe then table.remove(PlayersId, k) end
            end
        end
        Wait(50)
        OpenMenuTramway()
    elseif data.button == "addPlayer" and data.selected ~= 0 then
        VFW.Nui.JobMenu(false)
        local closestPlayer = VFW.StartSelect(5.0, true)
        if closestPlayer then
            TriggerServerEvent("core:activities:askJob", GetPlayerServerId(closestPlayer), "tram")
        end
        Wait(50)
        OpenMenuTramway()
    elseif data.button == "stop" then
        if blip then RemoveBlip(blip) end
        DeleteMissionTrain(tram)
        local playerSkin = TriggerServerCallback("vfw:skin:getPlayerSkin")
        TriggerEvent('skinchanger:loadSkin', playerSkin or {})
        for k,v in pairs(TramPeds) do 
            DeleteEntity(v)
        end
        TramPeds = {}
    end
end)

RegisterNuiCallback("nui:job-menu:close", function() VFW.Nui.JobMenu(false) end)

RegisterCommand("tramint", function()
    OpenMenuTramway()
end)

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "tram" then 
        print("Tramway is started for friends")
        -- ADD TENUE TO PLAYER
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "tram" then 
            CreerTram(data.trampos, data.pedpos, data.pedgoto, data.pos, data.stations, data.stationsped, data.inside, data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "tram" then 
        endTramWay()
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)

    console.debug("core:activities:acceptedJob", ply, pname)
    
    table.insert(PlayersInJob, {name = pname, id = ply})
end)


