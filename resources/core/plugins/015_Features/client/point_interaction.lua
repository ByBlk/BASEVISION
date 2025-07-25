CreateThread(function()
    while not VFW.PlayerLoaded do
        Wait(100)
    end

    for k, v in pairs(Config.Features.Masque) do
        local firstCOH = v[1].COH

        VFW.CreateBlipAndPoint("masque", vector3(firstCOH.x, firstCOH.y, firstCOH.z), k, 362, 47, 0.8, "Magasin de masque",  "Masque", "E", "Masque",{
            onPress = function()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.sex == 0 or skin.sex == 1 then
                        SetEntityCoords(VFW.PlayerData.ped, firstCOH.x, firstCOH.y, firstCOH.z - 1)
                        SetEntityHeading(VFW.PlayerData.ped, firstCOH.w)
                        LoadMask(v)
                    else
                        VFW.ShowNotification({
                            type = "ROUGE",
                            content = "Les peds ne peuvent pas utiliser le magasin de masque.",
                        })
                    end
                end)
            end
        })
    end

    for k, v in pairs(Config.Features.Vangelico) do
        local firstCOH = v[1].COH

        VFW.CreateBlipAndPoint("vangelico", vector3(firstCOH.x, firstCOH.y, firstCOH.z), k, 617, 0, 0.8, "Magasin de bijoux",  "Vangelico", "E", "Vangelico",{
            onPress = function()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.sex == 0 or skin.sex == 1 then
                        SetEntityCoords(VFW.PlayerData.ped, firstCOH.x, firstCOH.y, firstCOH.z - 1)
                        SetEntityHeading(VFW.PlayerData.ped, firstCOH.w)
                        LoadVangelico(v)
                    else
                        VFW.ShowNotification({
                            type = "ROUGE",
                            content = "Les peds ne peuvent pas utiliser le vangelico.",
                        })
                    end
                end)
            end
        })
    end

    for k, v in pairs(BLK.Shop.Location.Position) do
        VFW.CreateBlipAndPoint("location", vector3(v.Ped.x, v.Ped.y, v.Ped.z + 1.25), k, 466, 3, 0.8, "Location de véhicules",  "Location", "E", "Location",{
            onPress = function()
                LoadLocation(v)
            end
        })
    end

    for k, v in pairs(Config.Features.Binco) do
        for _, pos in ipairs(v.Pos) do
            VFW.CreateBlipAndPoint("binco", vector3(pos.x, pos.y, pos.z), k, 73, 8, 0.8, "Binco", v.Title, "E", "Binco", {
                onPress = function()
                    SetEntityCoords(VFW.PlayerData.ped, pos.x, pos.y, pos.z - 1)
                    SetEntityHeading(VFW.PlayerData.ped, pos.w)
                    LoadPreBinco(v.Cam)
                end
            })
        end
    end

    for k, v in pairs(Config.Features.Ponsobys) do
        for _, pos in ipairs(v.Pos) do
            VFW.CreateBlipAndPoint("ponsobys", vector3(pos.x, pos.y, pos.z), k, 73, 8, 0.8, "Ponsobys", v.Title, "E", "Binco", {
                onPress = function()
                    SetEntityCoords(VFW.PlayerData.ped, pos.x, pos.y, pos.z - 1)
                    SetEntityHeading(VFW.PlayerData.ped, pos.w)
                    LoadPreBinco(v.Cam)
                end
            })
        end
    end

    for k, v in pairs(Config.Features.Suburban) do
        for _, pos in ipairs(v.Pos) do
            VFW.CreateBlipAndPoint("suburban", vector3(pos.x, pos.y, pos.z), k, 73, 8, 0.8, "Suburban", v.Title, "E", "Binco", {
                onPress = function()
                    SetEntityCoords(VFW.PlayerData.ped, pos.x, pos.y, pos.z - 1)
                    SetEntityHeading(VFW.PlayerData.ped, pos.w)
                    LoadPreBinco(v.Cam)
                end
            })
        end
    end

    for k, v in pairs(BLK.Public.Garage) do
        VFW.CreateBlipAndPoint("garage", v.Public, k, 524, 32, 0.8, "Garage", "Garage", "E", "Garage",{
            onPress = function()
                local vehicle = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                if vehicle and (vehicle ~= 0) then
                    if (GetPedInVehicleSeat(vehicle, -1) == VFW.PlayerData.ped) and Entity(vehicle).state.VehicleProperties then
                        local result = TriggerServerCallback("vfw:vehicleGaragePublic", Entity(vehicle).state.VehicleProperties.plate, VFW.Game.GetVehicleProperties(vehicle))

                        if not result then
                            return
                        end
                    else
                        xPlayer.showNotification({
                            type = 'ILLEGAL',
                            name = "GARAGE",
                            label = "REFUSÉ",
                            labelColor = "#5A0606",
                            mainColor = 'rouge',
                            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
                            mainMessage = "Vous n'êtes pas le propriétaire du véhicule ou pas conducteur.",
                            duration = 10,
                        })
                        return
                    end
                end

                VFW.OpenGaragePublic(v)
            end
        })
    end

    for k, v in pairs(BLK.Public.Fourriere) do
        VFW.CreateBlipAndPoint("pound", v.Public, k, 68, 47, 0.8, "Fourriere", "Fourriere", "E", "Fourriere",{
            onPress = function()
                VFW.OpenPound(v)
            end
        })
    end

    VFW.CreateBlipAndPoint("dynasty", Config.Features.Dynasty.pos - vector3(0, 0, -1), "dynasty", 374, 0, 0.8, "Dynasty", "Propiété", "E", "Dynasty",{
        onPress = function()
            VFW.OpenPreviewProperties()
            SetEntityCoords(VFW.PlayerData.ped, -704.2142333984375, 269.3979187011719, 83.14735412597656 - 1)
            SetEntityHeading(VFW.PlayerData.ped, 274.460693359375)
            VFW.Cam:Create("previewHabitation", {
                Fov = 41.0,
                Dof = true,
                DofStrength = 1.0,
                Animation = {
                    anim = "idle_a",
                    dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
                    prop = "prop_cs_tablet",
                    propPlacement = {
                        -0.05,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0
                    },
                    propBone = 28422,
                },
                Freeze = true,
                CamRot = {
                    x = -2.40957427024841,
                    y = 5.336084996088175e-8,
                    z = 105.05803680419922
                },
                CamEffects = "MEDIUM_EXPLOSION_SHAKE",
                CamCoords = {
                    x = -702.9032592773438,
                    y = 269.6044006347656,
                    z = 83.61614990234375
                },
                COH = {
                    x = -704.2142333984375,
                    y = 269.3979187011719,
                    z = 83.14735412597656,
                    w = 274.460693359375
                },
                Invisible = true
            })
        end
    })

    for k, v in pairs(Config.Features.Tattoo) do
        for _, pos in ipairs(v.Pos) do
            VFW.CreateBlipAndPoint("tattoo", vector3(pos.x, pos.y, pos.z), k, 75, 1, 0.8, "Salon de tatouage", "Tatouage", "E", "Tatouage", {
                onPress = function()
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 or skin.sex == 1 then
                            SetEntityHeading(VFW.PlayerData.ped, pos.w)
                            LoadTattoo(v.Cam)
                        else
                            VFW.ShowNotification({
                                type = "ROUGE",
                                content = "Les peds ne peuvent pas utiliser le salon de tatouage.",
                            })
                        end
                    end)
                end
            })
        end
    end

    for k, v in pairs(Config.Features.Bike) do
        VFW.CreateBlipAndPoint("bike", vector3(v.Ped.x, v.Ped.y, v.Ped.z + 1.25), k, 226, 23, 0.8, "Magasin de skate",  "PRO Bikes", "E", "Catalogue",{
            onPress = function()
                cEntity.Visual.HideAllEntities(true)
                VFW.skateShop.Load(v)
            end
        })
    end

    for k, v in pairs(Config.Features.SheNails) do
        local firstCOH = v[1].COH

        VFW.CreateBlipAndPoint("shenails", vector3(firstCOH.x, firstCOH.y, firstCOH.z), k, 279, 8, 0.8, "SheNails",  "SheNails", "E", "Catalogue",{
            onPress = function()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.sex == 0 or skin.sex == 1 then
                        SetEntityCoords(VFW.PlayerData.ped, firstCOH.x, firstCOH.y, firstCOH.z - 1)
                        SetEntityHeading(VFW.PlayerData.ped, firstCOH.w)
                        LoadSheNails(v)
                    else
                        VFW.ShowNotification({
                            type = "ROUGE",
                            content = "Les peds ne peuvent pas utiliser le shenails.",
                        })
                    end
                end)
            end
        })
    end

    for _, elevator in ipairs(Config.Features.Elevators) do
        for k, entry in ipairs(elevator.entries) do
            VFW.CreateBlipAndPoint("elevator", vector3(entry.pos.x, entry.pos.y, entry.pos.z + 1.0), k, nil, nil, nil, nil, "Ascenseur", "E", "Tatouage", {
                onPress = function()
                    OpenMenuElevator(elevator, entry.floor)
                end
            })
        end
    end

    VFW.CreatePed(vector4(-268.698, -956.209, 30.223, 208.359), "cs_bankman")

    VFW.CreateBlipAndPoint("jobcenter", vector3(-268.698, -956.209, 30.223 + 0.75), "jobcenter", 407, 29, 0.8, "Job center", "Job center", "E", "Jobcenter",{
        onPress = function()
            OpenJobCenter()
        end
    })

    VFW.CreatePed(vector4(60.200622558594, 129.7130279541, 78.224227905273, 178.23), "s_m_m_cntrybar_01")
    
    VFW.CreateBlipAndPoint("gopostal", vector3(60.200622558594, 129.7130279541, 79.224227905273), "gopostal", 541, 1, 0.8, "Go Postal", "Go Postal", "E", "Stockage",{
        onPress = function()
            OpenMenuGoPostal()
        end
    })

    VFW.CreatePed(vector4(-322.22, -1546.02, 30.02, 266.99), "s_m_y_garbage")

    VFW.CreateBlipAndPoint("garbage", vector3(-322.22, -1546.02, 30.02 + 0.75), "garbage", 318, 25, 0.8, "Éboueur", "Eboueur", "E", "Poubelle",{
        onPress = function()
            OpenMenuGarbage()
        end
    })
    
    VFW.CreateBlipAndPoint("pizzeria", vector3(287.37, -963.98, 28.42 + 0.75), "pizzeria", 267, 44, 0.8, "Pizzeria", "Pizzeria", "E", "Stockage",{
        onPress = function()
            OpenMenuPizzeriaInt()
        end
    })

    VFW.CreatePed(vector4(287.37, -963.98, 28.42, 358.7), "s_m_m_cntrybar_01")

    VFW.CreateBlipAndPoint("tramway", vector3(-534.93597412109, -674.98834228516, 10.808974266052 + 0.75), "tramway", 208, 44, 0.8, "Tramway", "Tramway", "E", "Stockage",{
        onPress = function()
            OpenMenuTramway()
        end
    })

    VFW.CreatePed(vector4(-534.93597412109, -674.98834228516, 10.808974266052, 272.13305664062), "a_m_y_business_02")

    VFW.CreateBlipAndPoint("trainint", vector3(-139.5951385498, 6146.96875, 31.436786651611 + 0.75), "trainint", 208, 44, 0.8, "Train", "Train", "E", "Stockage",{
        onPress = function()
            OpenMenuTraiInter()
        end
    })

    VFW.CreatePed(vector4(2829.0295410156, 2810.6799316406, 56.414730072021, 170.57766723633), "s_m_y_dockwork_01")

    VFW.CreateBlipAndPoint("mine", vector3(2829.0295410156, 2810.6799316406, 58.414730072021), "mine", 541, 1, 0.8, "Mineur", "Mineur", "E", "Stockage",{
        onPress = function()
            OpenMenuMine()
        end
    })

    for serviceName, serviceConfig in pairs(Config.Features.Sonnette) do
        for _, position in ipairs(serviceConfig.pos) do
            VFW.CreatePed(position, serviceConfig.ped)
            VFW.CreateBlipAndPoint("sonnette", vector3(position.x, position.y, position.z + 1.25), serviceName, nil, nil, nil, nil, "Sonnette", "E", "Poubelle", {
                onPress = function()
                    TriggerServerEvent('core:alert:makeCall', serviceName, position, false, serviceConfig.msg, true)
                end
            })
        end
    end
end)
