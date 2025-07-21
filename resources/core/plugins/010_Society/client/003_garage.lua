local LastGarage = nil
local LastGarageDelete = nil
local Items = {}
local lastEntity = false
local lastModel = false

---deleteCar
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

---MenuConfig
---@param job string
local function MenuConfig(job)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            buyText = "Sortir le véhicule",
            bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(job),
        },
        eventName = "catalogue:garage",
        showStats = { show = false },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        mouseEvents = true,
        headCategory = {
            show = true,
            items = {
                { label = "Garage", id = 1 },
            }
        },
        color = { show = false },
        items = Items
    }
    return data
end

RegisterNuiCallback(("nui:newgrandcatalogue:catalogue:garage:selectGridType"), function(data)
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
            VFW.Game.SpawnVehicle(model, vector3(Society.Jobs[VFW.PlayerData.job.name].Garage.Camera.COH.x, Society.Jobs[VFW.PlayerData.job.name].Garage.Camera.COH.y, Society.Jobs[VFW.PlayerData.job.name].Garage.Camera.COH.z), Society.Jobs[VFW.PlayerData.job.name].Garage.Camera.COH.w, function(vehicle)
                FreezeEntityPosition(vehicle, true)
                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleOnGroundProperly(vehicle)
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleEngineOn(vehicle, true, true, true)
                SetVehicleLights(vehicle, 2)
                SetModelAsNoLongerNeeded(lastModel)
                for k, v in pairs(Society.Jobs[VFW.PlayerData.job.name].Garage.Items) do
                    if v.model == model then
                        if v.bonus then
                            v.bonus(vehicle)
                        end
                    end
                end
                lastModel = model
                lastEntity = vehicle
                cEntity.Visual.AddEntityToException(vehicle)
            end)
        end
    end
end)

RegisterNuiCallback(("nui:newgrandcatalogue:catalogue:garage:selectBuy"), function(data)
    deleteCar()
    VFW.Nui.NewGrandMenu(false)
    cEntity.Visual.HideAllEntities(false)
    VFW.Cam:Destroy('job:garage')
    VFW.Game.SpawnVehicle(data, Society.Jobs[VFW.PlayerData.job.name].Garage.PositionSpawn, Society.Jobs[VFW.PlayerData.job.name].Garage.PositionSpawnH, function(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleEngineOn(vehicle, true, true, true)
        SetVehicleLights(vehicle, 2)
        for k, v in pairs(Society.Jobs[VFW.PlayerData.job.name].Garage.Items) do
            if v.model == data then
                if v.bonus then
                    v.bonus(vehicle)
                end
            end
        end
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end)

RegisterNuiCallback("nui:newgrandcatalogue:catalogue:garage:mouseEvents", function(data)
    SetEntityHeading(lastEntity, GetEntityHeading(lastEntity) + (0.5 * data.x))
end)

RegisterNUICallback("nui:newgrandcatalogue:catalogue:garage:close", function()
    deleteCar()
    VFW.Nui.NewGrandMenu(false)
    cEntity.Visual.HideAllEntities(false)
    VFW.Cam:Destroy('job:garage')
end)

---loadGarage
---@param job string
function Society.loadGarage(job)
    if LastGarage then
        console.debug("Removing LastGarage:", LastGarage)
        Worlds.Zone.Remove(LastGarage)
        LastGarage = nil
    end
    if LastGarageDelete then
        console.debug("Removing LastGarageDelete:", LastGarageDelete)
        Worlds.Zone.Remove(LastGarageDelete)
        LastGarageDelete = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Garage then
        console.debug("Invalid job or garage configuration for job:", job)
        return
    end

    Items = {} -- Reset Items table
    for k, v in pairs(Society.Jobs[job].Garage.Items) do
        local tempCatalogue = {
            label = v.label,
            model = v.model,
            image = "vehicules/"..v.model..".webp",
            price = false,
            premium = false
        }
        table.insert(Items, tempCatalogue)
    end

    LastGarage = VFW.CreateBlipAndPoint("society:garage:"..job, Society.Jobs[job].Garage.Position, 1, false, false, false, false, "Garage", "E", "Catalogue", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            if not Society.Jobs[job] or not Society.Jobs[job].Garage then
                console.debug("Invalid job or garage configuration for job:", job)
                return
            end
            VFW.Nui.NewGrandMenu(true, MenuConfig(job))
            cEntity.Visual.HideAllEntities(true)
            VFW.Cam:Create("job:garage", Society.Jobs[job].Garage.Camera)
        end
    })

    LastGarageDelete = VFW.CreateBlipAndPoint("society:garage:"..job, Society.Jobs[job].Garage.PositionDelete, 1, false, false, false, false, "Garage", "E", "Catalogue", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            if not Society.Jobs[job] or not Society.Jobs[job].Garage then
                console.debug("Invalid job or garage configuration for job:", job)
                return
            end
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
        end
    })
    return true
end
