local lastEntity = false
local lastModel = false
local defaultCategory = "Super"

local VehicleProd = {}

local function deleteCar()
    if lastEntity and DoesEntityExist(lastEntity) then
        SetEntityAsMissionEntity(lastEntity, true, true)
        SetEntityAsNoLongerNeeded(lastEntity)
        DeleteEntity(lastEntity)
        lastEntity = false
        lastModel = false
        console.debug("Entity successfully deleted when closing.")
    else
        console.debug("No entity to delete or entity already deleted when closing.")
    end
end

local function getCategoryIndex(category)
    local data = {
        ["Super"] = 0,
        ["Sport-Classic"] = 1,
        ["Compact"] = 2,
        ["Coupe"] = 3,
        ["SUV"] = 4,
        ["Sedans"] = 5,
        ["Sport"] = 6,
        ["Van"] = 7,
    }

    return data[category]
end

local function getCategory(category)
    for category, vehicles in pairs(BLK.Vehicule) do
        VehicleProd[category] = {}
        if type(vehicles) == "table" then
            for _, vehicle in ipairs(vehicles) do
                local tempCatalogue = {
                    label = vehicle.label or vehicle.model,
                    model = vehicle.model,
                    image = "vehicules/"..vehicle.model..".webp",
                    price = VFW.Math.GroupDigits(vehicle.price),
                    premium = vehicle.premium or false,
                    stats = {
                        firstLabel = category,
                        secondLabel = vehicle.label or vehicle.model,
                        info = {
                            { label = "Vitesse", value = GetVehicleModelMaxSpeed(joaat(vehicle.model))*3.6/200*90 or 0 },
                            { label = "Frein", value = GetVehicleModelAcceleration(joaat(vehicle.model))*3.6*60 or 0 },
                            { label = "Accélération", value = GetVehicleModelMaxBraking(joaat(vehicle.model))*60 or 0 },
                            { label = "Traction", value = GetVehicleModelMaxTraction(joaat(vehicle.model))*15 or 0 }
                        }
                    }
                }
                table.insert(VehicleProd[category], tempCatalogue)
            end
        end
    end
    console.debug(json.encode(VehicleProd[category]))
    return VehicleProd[category]
end

function MenuConfig()
    console.debug("MenuConfig")
    console.debug(defaultCategory)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 1,
            buyType = 2,
            lineColor = "linear-gradient(to right, rgba(255, 255, 255, .6) 0%, rgba(255, 255, 255, .6) 56%, rgba(255, 255, 255, 0) 100%)",
            title = "CONCESSIONNAIRE",
            buyTextType = "price",
        },
        eventName = "cardealer",
        showStats = {
            show = true,
            default = true,
            showButton = false
        },
        mouseEvents = true,
        color = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        category = {
            show = true,
            defaultIndex = getCategoryIndex(defaultCategory),
            items = {
                {id = "Super", label = "Super", image = "assets/catalogues/cardealer/Super.svg"},
                {id = "Sport-Classic", label = "Sport-Classic", image = "assets/catalogues/cardealer/Sport-Classic.svg"},
                {id = "Compact", label = "Compact", image = "assets/catalogues/cardealer/Compact.svg"},
                {id = "Coupe", label = "Coupe", image = "assets/catalogues/cardealer/Coupe.svg"},
                {id = "SUV", label = "SUV", image = "assets/catalogues/cardealer/SUV.svg"},
                {id = "Sedans", label = "Sedans", image = "assets/catalogues/cardealer/Sedans.svg"},
                {id = "Sport", label = "Sport", image = "assets/catalogues/cardealer/Sport.svg"},
                {id = "Van", label = "Van", image = "assets/catalogues/cardealer/Van.svg"}
            }
        },
        cameras = {
            show = true,
            label = "Caméras",
            items = {
                {id = "front", image = "assets/catalogues/cardealer/front.svg"},
                {id = "back", image = "assets/catalogues/cardealer/back.svg"},
                {id = "interior", image = "assets/catalogues/cardealer/interior.svg"}
            }
        },
        color = { show = false },
        items = getCategory(defaultCategory)
    }
    console.debug(json.encode(data.items))
    return data
end

RegisterNuiCallback("nui:newgrandcatalogue:cardealer:selectGridType", function(data)
    console.debug("nui:newgrandcatalogue:selectGridType", data)
    local model = data
    if model then
        if lastModel ~= model then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            if lastEntity and DoesEntityExist(lastEntity) then
                SetEntityAsMissionEntity(lastEntity, true, true)
                SetEntityAsNoLongerNeeded(lastEntity)
                DeleteEntity(lastEntity)
                if not DoesEntityExist(lastEntity) then
                    console.debug("Entity successfully deleted.")
                else
                    console.debug("Failed to delete entity.")
                end
                lastEntity = false
            end
            VFW.Game.SpawnVehicle(model, vector3(-36.932983398438, -1093.2131347656, 26.890316009521), 120.0, function(vehicle)
                FreezeEntityPosition(vehicle, true)
                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleOnGroundProperly(vehicle)
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleEngineOn(vehicle, true, true, true)
                SetVehicleLights(vehicle, 2)
                SetModelAsNoLongerNeeded(lastModel)
                lastModel = model
                lastEntity = vehicle
                cEntity.Visual.AddEntityToException(vehicle)
            end, false)
        end
    end
end)

local timer = false

RegisterNuiCallback("nui:newgrandcatalogue:cardealer:selectBuy", function(data)
    if timer then
        console.debug("nui:newgrandcatalogue:selectBuy", "Already in cooldown")
        return
    end
    timer = true
    SetTimeout(2000, function()
        timer = false
    end)
    console.debug("nui:newgrandcatalogue:selectBuy", data)
    for k, v in pairs(VehicleProd) do
        for _, vehicle in ipairs(v) do
            if vehicle.model == data then
                if vehicle.premium then
                    if VFW.PlayerGlobalData.permissions["premium"] or VFW.PlayerGlobalData.permissions["premiumplus"] then
                        TriggerServerEvent("vfw:cardealer:buy", data, VFW.Game.GetVehicleProperties(lastEntity), GetMakeNameFromVehicleModel(vehicle.model))
                    else
                        TriggerEvent("vfw:cardealer:hasBuying")
                        TriggerEvent("vfw:openEscapeMenuBoutique")
                    end
                    return
                else
                    TriggerServerEvent("vfw:cardealer:buy", data, VFW.Game.GetVehicleProperties(lastEntity), GetMakeNameFromVehicleModel(vehicle.model))
                    return
                end
            end
        end
    end
end)

RegisterNetEvent("vfw:cardealer:hasBuying", function()
    if lastEntity and DoesEntityExist(lastEntity) then
        SetEntityAsMissionEntity(lastEntity, true, true)
        SetEntityAsNoLongerNeeded(lastEntity)
        DeleteEntity(lastEntity)
        lastEntity = false
        console.debug("Entity successfully deleted when closing.")
    else
        console.debug("No entity to delete or entity already deleted when closing.")
    end
    deleteCar()
    defaultCategory = "Super"
    cEntity.Visual.HideAllEntities(false)
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy('cardealer')
end)

RegisterNuiCallback("nui:newgrandcatalogue:cardealer:selectCategory", function(data)
    console.debug("nui:newgrandcatalogue:selectCategory", data)
    defaultCategory = data
    Wait(50)
    console.debug(defaultCategory)
    deleteCar()
    VFW.Nui.UpdateNewGrandMenu(MenuConfig())
end)

RegisterNuiCallback("nui:newgrandcatalogue:cardealer:selectCamera", function(data)
    console.debug("nui:newgrandcatalogue:selectCamera", data)
    console.debug("Changement de cameras",data)
    if data == "front" then
        VFW.Cam:Update("cardealer", {
            Dof = true,
            Vehicle = 436196712,
            Fov = 45.0,
            Freeze = true,
            COH = {
                x = -37.19424057006836,
                y = -1093.3096923828126,
                z = 26.72858810424804,
                w = 130.64974975585938
            },
            Gamertags = true,
            CamRot = {
                x = -4.0876235961914,
                y = -0.0,
                z = -13.61736488342285
            },
            Invisible = true,
            DofStrength = 0.9,
            CamCoords = {
                x = -39.4229507446289,
                y = -1097.9178466796876,
                z = 27.04218482971191
            }
        })
        SetEntityHeading(lastEntity, 120.0)
    elseif data == "back" then
        VFW.Cam:Update("cardealer", {
            Dof = true,
            Vehicle = 436196712,
            Fov = 45.0,
            Freeze = true,
            COH = {
                x = -37.31726455688476,
                y = -1093.7607421875,
                z = 26.72868537902832,
                w = 328.755859375
            },
            Gamertags = false,
            CamRot = {
                x = -2.86692190170288,
                y = 1.3340212490220438e-8,
                z = -3.40289950370788
            },
            Invisible = true,
            DofStrength = 0.9,
            CamCoords = {
                x = -38.27918243408203,
                y = -1099.0107421875,
                z = 27.21435737609863
            }
        })
        SetEntityHeading(lastEntity, 294.91712188721)
    elseif data == "interior" then
        VFW.Cam:Update("cardealer", {
            Dof = false,
            Vehicle = 436196712,
            Fov = 45.0,
            Freeze = true,
            COH = {
                x = -37.19424057006836,
                y = -1093.3096923828126,
                z = 26.72858810424804,
                w = 130.64974975585938
            },
            Gamertags = true,
            CamRot = {
                x = -10.34746837615966,
                y = 0.0,
                z = 156.77630615234376
            },
            Invisible = true,
            DofStrength = 0.9,
            CamCoords = {
                x = -36.91572952270508,
                y = -1092.9061279296876,
                z = 27.34952926635742
            }
        })
        SetEntityHeading(lastEntity, 120.0)
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:cardealer:mouseEvents", function(data)
    SetEntityHeading(lastEntity, GetEntityHeading(lastEntity) + (0.5 * data.x))
end)

RegisterNUICallback("nui:newgrandcatalogue:cardealer:close", function()
    deleteCar()
    defaultCategory = "Super"
    cEntity.Visual.HideAllEntities(false)
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy('cardealer')
end)

print("MenuConfig()")
VFW.CreateBlipAndPoint("cardealer", vector3(-43.02, -1094.35, 26.27+1), "cardealer", false, false, false, false, "Vehicules", "E", "Catalogue",{
    onPress = function()
        VFW.Nui.NewGrandMenu(true, MenuConfig())
        cEntity.Visual.HideAllEntities(true)
        VFW.Cam:Create("cardealer", {
            Dof = true,
            Vehicle = 436196712,
            Fov = 45.0,
            Freeze = true,
            COH = {
                x = -37.19424057006836,
                y = -1093.3096923828126,
                z = 26.72858810424804,
                w = 130.64974975585938
            },
            Gamertags = true,
            CamRot = {
                x = -4.0876235961914,
                y = -0.0,
                z = -13.61736488342285
            },
            Invisible = true,
            DofStrength = 0.9,
            CamCoords = {
                x = -39.4229507446289,
                y = -1097.9178466796876,
                z = 27.04218482971191
            }
        })
    end
})

