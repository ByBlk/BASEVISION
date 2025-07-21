local lastEntity = false
local lastModel = false
local cams = nil
local locationData = {}
local lastCategory = "Economique"

local function getLocation(category)
    locationData[category] = {}

    for k, v in pairs(Kipstz.Shop.Location.Vehicule[category]) do
        local tempCatalogue = {
            label = v.label,
            model = k,
            image = ("vehicules/%s.webp"):format(k),
            price = VFW.Math.GroupDigits(v.price),
            premium = false,
            stats = {
                firstLabel = v.label or k,
                secondLabel = "",
                info = {
                    { label = "Vitesse", value = GetVehicleModelMaxSpeed(joaat(k))*3.6/200*90 or 0 },
                    { label = "Frein", value = GetVehicleModelAcceleration(joaat(k))*3.6*60 or 0 },
                    { label = "Traction", value = GetVehicleModelMaxTraction(joaat(k))*15 or 0 }
                }
            }
        }

        table.insert(locationData[category], tempCatalogue)
    end

    return locationData[category]
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

local function getLocationData(category, firstLabel, secondLabel)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = "assets/catalogues/headers/header_location.webp",
            buyTextType = false,
            buyText = "Louer",
        },
        eventName = "location",
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Economique ", id = "Economique" },
                { label = "Standard ", id = "Standard" },
                { label = "Premium ", id = "Premium" },
            }
        },
        showStats = {
            show = true,
            default = true,
            showButton = false
        },
        mouseEvents = false,
        color = { show = false },
        items = getLocation(category)
    }

    if firstLabel and secondLabel then
        data.nameContainer = {
            show = true,
            top = false,
            firstLabel = firstLabel,
            secondLabel = secondLabel
        }
    end

    return data
end

function LoadLocation(data)
    local state = TriggerServerCallback("core:server:getLocation")

    if not state then
        VFW.ShowNotification({ type = 'ROUGE', content = "Vous avez une location en cours." })
        return
    end

    cams = data

    cEntity.Visual.HideAllEntities(true)
    SetPlayerInvincible(VFW.PlayerData.ped, true)
    VFW.Nui.NewGrandMenu(true, getLocationData(lastCategory))
    SetFocusArea(cams.Cam.Normal.CamCoords.x, cams.Cam.Normal.CamCoords.y, cams.Cam.Normal.CamCoords.z)
    Wait(100)
    VFW.Cam:Create('cam_location', cams.Cam.Normal)
end

for k, v in pairs(Kipstz.Shop.Location.Position) do
    VFW.CreatePed(v.Ped, 'ig_thornton')
end

RegisterNuiCallback("nui:newgrandcatalogue:location:selectHeadCategory", function(data)
    if data == nil then return end
    lastCategory = data
    Wait(50)
    VFW.Nui.UpdateNewGrandMenu(getLocationData(lastCategory))
end)

local function getVehicleLength(vehicle)
    local min, max = GetModelDimensions(vehicle)
    local length = max.y - min.y

    return length
end

RegisterNuiCallback("nui:newgrandcatalogue:location:selectGridType", function(data)
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

            local cam = cams.Cam.Normal

            if getVehicleLength(model) > 5.5 then
                cam = cams.Cam.Suv
            end
            VFW.Cam:Update('cam_location', cam)

            lastEntity = CreateVehicle(model, cam.COH.x, cam.COH.y, cam.COH.z, cam.COH.w, false, false)

            for name, vehicle in pairs(Kipstz.Shop.Location.Vehicule[lastCategory]) do
                if name == model then
                    VFW.Nui.UpdateNewGrandMenu(getLocationData(lastCategory, GetMakeNameFromVehicleModel(GetEntityModel(lastEntity)), vehicle.label))
                    break
                end
            end

            FreezeEntityPosition(lastEntity, true)
            SetEntityAsMissionEntity(lastEntity, true, true)
            SetVehicleOnGroundProperly(lastEntity)
            SetVehicleDoorsLocked(lastEntity, 2)
            SetVehicleEngineOn(lastEntity, true, true, true)
            SetVehicleLights(lastEntity, 2)
            SetModelAsNoLongerNeeded(lastModel)
            lastModel = model
            cEntity.Visual.AddEntityToException(lastEntity)
        end
    end
end)

RegisterNuiCallback("nui:newgrandcatalogue:location:selectBuy", function(data)
    if lastEntity and DoesEntityExist(lastEntity) then
        SetEntityAsMissionEntity(lastEntity, true, true)
        SetEntityAsNoLongerNeeded(lastEntity)
        DeleteEntity(lastEntity)
        lastEntity = false
        console.debug("Entity successfully deleted when closing.")
    else
        console.debug("No entity to delete or entity already deleted when closing.")
    end

    ClearFocus()
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy('cam_location')
    cEntity.Visual.HideAllEntities(false)
    SetPlayerInvincible(VFW.PlayerData.ped, false)
    Wait(150)

    for k, _ in pairs(Kipstz.Shop.Location.Vehicule[lastCategory]) do
        if k == data then
            TriggerServerEvent("core:server:setLocation", data, lastCategory, vector3(cams.Spawn.x, cams.Spawn.y, cams.Spawn.z), cams.Spawn.w)
            break
        end
    end
end)

RegisterNUICallback("nui:newgrandcatalogue:location:close", function()
    deleteCar()
    ClearFocus()
    cEntity.Visual.HideAllEntities(false)
    SetPlayerInvincible(VFW.PlayerData.ped, false)
    VFW.Nui.NewGrandMenu(false)
    VFW.Cam:Destroy('cam_location')
end)
