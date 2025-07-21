local editData = {}
local vehiclePos = nil
local open = false
function VFW.OpenUIGarage(data)
    console.debug("Opended crew garage")
    console.debug(json.encode(data))
    open = not open
    SetNuiFocus(open, open)
    SendNUIMessage({
        action = "nui:garage-menu:visible",
        data = open
    })
    if open then
        editData = {}
        SetCursorLocation(0.5, 0.5)

        local vehicles = {}
        for k, v in pairs(data.garageList) do
            table.insert(vehicles, {
                id = k,
                label = GetDisplayNameFromVehicleModel(GetHashKey(v)),
                img = v
            })
        end
        data.garageList = vehicles

        SendNUIMessage({
            action = "nui:garage-menu:data",
            data = data
        })
    end
end

local vehicle = nil 
function VFW.LoadGarage(maxPlaces, garageList)
    local garageId = Property.Garage.List[maxPlaces]
    if not garageId then
        console.debug("Garage ID not found")
        return
    end

    local garage = Property.Garage.data[garageId]
    if not garage then
        console.debug("Garage not found")
        return
    end

    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(250)
    Wait(250)
    SetFocusArea(garage.cam.CamCoords.x, garage.cam.CamCoords.y, garage.cam.CamCoords.z)

    local vehicleplate, vehicleHash, prop
    for k, v in pairs(garageList) do
        vehicleplate = k
        break
    end
    if vehicleplate then
        prop, model = TriggerServerCallback("vfw:getVehicleInfo", vehicleplate)
        vehicleHash = VFW.Streaming.RequestModel(model)
    end
    Wait(1000)
    PinInteriorInMemory(GetInteriorAtCoords(garage.cam.CamCoords.x, garage.cam.CamCoords.y, garage.cam.CamCoords.z))
    Wait(500)
    vehiclePos = garage.vehicle
    if vehicleplate then
        vehicle = CreateVehicle(vehicleHash, vehiclePos.x, vehiclePos.y, vehiclePos.z, vehiclePos.w, false, false)
        SetModelAsNoLongerNeeded(vehicleHash)
        VFW.Game.SetVehicleProperties(vehicle, prop)
        FreezeEntityPosition(vehicle, true)
    end
    
    VFW.Cam:Create("garage", garage.cam)
    DoScreenFadeIn(250)
end

function VFW.UnloadGarage()
    DoScreenFadeOut(250)
    Wait(250)
    VFW.Cam:Destroy("garage")
    ClearFocus()
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(1000)
    DoScreenFadeIn(250)
    VFW.Nui.HudVisible(true)
    FreezeEntityPosition(PlayerPedId(), false)

    if vehicle then
        DeleteEntity(vehicle)
        vehicle = nil
    end
end 

RegisterNUICallback("nui:garage-menu:close", function()
    if not open then
        return
    end
    VFW.OpenUIGarage()
    VFW.UnloadGarage()
    Worlds.Zone.HideInteract(true)
end)

RegisterNuiCallback("nui:garage-menu:rename", function(data)
    editData.rename = data.rename
end)

RegisterNuiCallback("nui:garage-menu:button", function(data)
    if data.type == "access" then
        editData.access = data.value
    elseif data.type == "save" then
        TriggerServerEvent("vfw:property:edit", VFW.ActualProperty, editData)
    end
end)

RegisterNuiCallback("nui:garage-menu:use", function(data)
    if not data.selected then
        return
    end
    TriggerServerEvent("vfw:property:useVehicle", VFW.ActualProperty, data.selected.id)
    VFW.OpenUIGarage()
    VFW.UnloadGarage()
    Worlds.Zone.HideInteract(true)
end)

RegisterNuiCallback("nui:garage-menu:pound" , function(data)
    console.debug("nui:garage-menu:pound", json.encode(data, {indent = true}))
end)

RegisterNUICallback("nui:garage-menu:setVehicle", function(data)
    if vehicle then
        DeleteEntity(vehicle)
        vehicle = nil
    end
    local prop, model = TriggerServerCallback("vfw:getVehicleInfo", data.id)
    local vehicleHash = VFW.Streaming.RequestModel(model)
    vehicle = CreateVehicle(vehicleHash, vehiclePos.x, vehiclePos.y, vehiclePos.z, vehiclePos.w, false, false)
    SetModelAsNoLongerNeeded(vehicleHash)
    VFW.Game.SetVehicleProperties(vehicle, prop)
    FreezeEntityPosition(vehicle, true)
end)