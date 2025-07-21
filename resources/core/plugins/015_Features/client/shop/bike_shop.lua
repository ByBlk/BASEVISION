local lastEntity = false
local lastModel = false
local cams = nil

VFW.skateShop.VehicleProd = {}

for _, vehicle in pairs(VFW.skateShop.Items) do
    local tempCatalogue = {
        label = vehicle.label or vehicle.model,
        model = vehicle.model,
        image = "items/"..vehicle.model..".webp",
        price = VFW.Math.GroupDigits(vehicle.price),
        premium = false,
        stats = {
            firstLabel = vehicle.label or vehicle.model,
            secondLabel = "",
            info = {
                { label = "Vitesse", value = GetVehicleModelMaxSpeed(joaat(vehicle.model))*3.6/200*90 or 0 },
                { label = "Frein", value = GetVehicleModelAcceleration(joaat(vehicle.model))*3.6*60 or 0 },
                { label = "Traction", value = GetVehicleModelMaxTraction(joaat(vehicle.model))*15 or 0 }
            }
        }
    }
    table.insert(VFW.skateShop.VehicleProd, tempCatalogue)
end

local function deleteCar()
    if lastEntity and DoesEntityExist(lastEntity) then
        SetEntityAsMissionEntity(lastEntity, true, true)
        SetEntityAsNoLongerNeeded(lastEntity)
        DeleteEntity(lastEntity)
        lastEntity = false
        console.debug("Entity successfully deleted when closing.")
    else
        console.debug("No entity to delete or entity already deleted when closing.")
    end
end

function VFW.skateShop.MenuConfig()
    console.debug("VFW.skateShop.MenuConfig")
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_skateshop.webp",
            lineColor = "linear-gradient(to right, rgba(255, 255, 255, .6) 0%, rgba(255, 255, 255, .6) 56%, rgba(255, 255, 255, 0) 100%)",
            title = "SKATE SHOP",
            buyTextType = "price",
        },
        eventName = "skateShop",
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items= {
                { label = "Produits", value = "skate" }
            }
        },
        nameContainer = { show = false },
        showStats = {
            show = true,
            default = true,
            showButton = false
        },
        mouseEvents = true,
        color = { show = false },
        items = VFW.skateShop.VehicleProd
    }
    console.debug(json.encode(data.items))
    return data
end

function VFW.skateShop.Load(data)
    cams = data
    cEntity.Visual.HideAllEntities(true)
    VFW.Cam:Create('cam_skate', cams.Cam)
    VFW.Nui.NewGrandMenu(true, VFW.skateShop.MenuConfig())
end

for k, v in pairs(Config.Features.Bike) do
    VFW.CreatePed(v.Ped, 'a_m_y_roadcyc_01')
end

RegisterNuiCallback("nui:newgrandcatalogue:skateShop:selectGridType", function(data)
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
            
            VFW.Game.SpawnVehicle(model, vector3( cams.Cam.COH.x, cams.Cam.COH.y, cams.Cam.COH.z), cams.Cam.COH.w, function(vehicle)
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

RegisterNuiCallback("nui:newgrandcatalogue:skateShop:selectBuy", function(data)
    console.debug("nui:newgrandcatalogue:skateShop:selectBuy", data)
    for _, vehicle in pairs(VFW.skateShop.Items) do
        if vehicle.model == data then
            TriggerServerEvent("vfw:bike:buy", data)
            break
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:skateShop:mouseEvents", function(data)
    SetEntityHeading(lastEntity, GetEntityHeading(lastEntity) + (0.5 * data.x))
end)

RegisterNUICallback("nui:newgrandcatalogue:skateShop:close", function()
    deleteCar()
    cEntity.Visual.HideAllEntities(false)
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy('cam_skate')
end)