local open = false
local vehicle = nil
local cams = nil

function VFW.OpenGaragePublic(data)
    open = not open
    SetNuiFocus(open, open)
    VFW.Nui.HudVisible(not open)
    SendNUIMessage({
        action = "nui:garagePublic:visible",
        data = open
    })
    if open then
        SetCursorLocation(0.5, 0.5)
        cams = data
        SetEntityVisible(VFW.PlayerData.ped, false)
        VFW.Cam:Create("garagePublic", cams.Preview.Cam)
        local vehicleList, fourriere = TriggerServerCallback("vfw:getGaragePublic")
        for i = 1, #vehicleList do
            if i == 1 then
                local vehicleHash = VFW.Streaming.RequestModel(vehicleList[1].name)
                local pos = cams.Preview.Vehicle
                vehicle = CreateVehicle(vehicleHash, pos.x, pos.y, pos.z, pos.w, false, false)
                SetModelAsNoLongerNeeded(vehicleHash)
                FreezeEntityPosition(vehicle, true)
                SetEntityCollision(vehicle, true, true)
                VFW.Game.SetVehicleProperties(vehicle, vehicleList[i].prop)
            end
            vehicleList[i].prop = nil
            vehicleList[i].name = GetDisplayNameFromVehicleModel(GetHashKey(vehicleList[i].name))
        end
        for i = 1, #fourriere do
            fourriere[i].name = GetDisplayNameFromVehicleModel(GetHashKey(fourriere[i].name))
        end
        SendNUIMessage({
            action = "nui:garagePublic:Emplacement",
            data = {
                items = vehicleList,
                premium = VFW.PlayerGlobalData.permissions["premium"],
                premiumplus = VFW.PlayerGlobalData.permissions["premiumplus"]
            }
        })
        SendNUIMessage({
            action = "nui:garagePublic:Fourrière",
            data = fourriere
        })

        local pools = {
            "CPed",
            "CObject",
            "CNetObject",
            "CPickup",
            "CVehicle"
        }
        while open do
            for i = 1, #pools do
                local pool = GetGamePool('CVehicle')
                for i = 1, #pool do
                    SetEntityLocallyInvisible(pool[i])
                end
            end
            Wait(0)
        end
    else
        if vehicle then
            DeleteEntity(vehicle)
            vehicle = nil
        end
        VFW.Cam:Destroy("garagePublic")
        SetEntityVisible(VFW.PlayerData.ped, true)
    end
end

RegisterNuiCallback("nui:garagePublic:close", function()
    if not open then return end
    VFW.OpenGaragePublic(cams)
end)

RegisterNuiCallback("nui:garagePublic:use", function(data)
    if not open then return end
    if not data.selectedEmplacement then return end
    TriggerServerEvent("vfw:garagePublic:use", cams.Pos, data.selectedEmplacement.id, GetMakeNameFromVehicleModel(data.selectedEmplacement.name))
    VFW.OpenGaragePublic(cams)
end)

RegisterNUICallback("garagePublic:selectEmplacement", function(data)
    if not open then return end
    if vehicle then
        DeleteEntity(vehicle)
        vehicle = nil
    end
    local model, prop = TriggerServerCallback("vfw:garagePublic:get", data)
    local vehicleHash = VFW.Streaming.RequestModel(model)
    local pos = cams.Preview.Vehicle
    vehicle = CreateVehicle(vehicleHash, pos.x, pos.y, pos.z, pos.w, false, false)
    FreezeEntityPosition(vehicle, true)
    SetEntityCollision(vehicle, true, true)
    VFW.Game.SetVehicleProperties(vehicle, prop)
end)

RegisterNuiCallback("nui:garagePublic:premium", function(data)

end)