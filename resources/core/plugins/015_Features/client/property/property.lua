local open = false
function VFW.OpenUIProperty(property)
    open = not open
    SetNuiFocus(open, open)
    SendNUIMessage({
        action = "nui:alternate-property-menu:visible",
        data = open
    })
    VFW.Nui.HudVisible(not open)
    if open then
        SetCursorLocation(0.5, 0.5)
        SendNUIMessage({
            action = "nui:alternate-property-menu:data",
            data = property
        })
    else
        Worlds.Zone.HideInteract(true)
    end
end

RegisterNUICallback("nui:alternate-property-menu:close", function()
    if not open then
        return
    end
    VFW.OpenUIProperty()
end)


RegisterNetEvent("vfw:property:reject", function()
    VFW.OpenUIProperty()
    VFW.ShowNotification({
        type= "ROUGE",
        content = "Personne n'a répondu"
    })
end)

RegisterNetEvent("vfw:property:accept", function(property)
    VFW.OpenUIProperty()
    if property.garageList then
        local vehicle = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
        if vehicle and (vehicle ~= 0) then
            if (GetPedInVehicleSeat(vehicle, -1) == VFW.PlayerData.ped) and Entity(vehicle).state.VehicleProperties then
                local result
                local model = GetEntityModel(vehicle)

                result, property = TriggerServerCallback("vfw:enterVehicle", propertyId, Entity(vehicle).state.VehicleProperties.plate, GetMakeNameFromVehicleModel(model))
                if not result then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous ne pouvez pas rentrer un véhicule qui n'est pas a vous."
                    })
                    return
                end
            else
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Vous devez sortir du véhicule ou être conducteur pour rentrer dans le garage."
                })
                return
            end
        end

        VFW.LoadGarage(property.maxPlaces, property.garageList)
        property.subTitle = ("%s PLACES"):format(property.maxPlaces)
        property.maxPlaces = nil
        VFW.OpenUIGarage(property)
    else
        VFW.EnterHouse(property)
    end
end)

RegisterNetEvent("vfw:property:forceEnter", function(id, property)
    VFW.ActualProperty = id
    VFW.EnterHouse(property, true)
end)

RegisterNUICallback("nui:property-menu:button", function(data, cb)
    if (data.type == "set_double" ) then
        VFW.OpenGestionProperty()
        local target = VFW.StartSelect(5.0, true)
        if not target then
            return
        end

        console.debug("Sended to " .. target)
        TriggerServerEvent("vfw:property:giveAccess", GetPlayerServerId(target), VFW.ActualProperty)
    end
end)


RegisterNUICallback("nui:alternate-property-menu:button", function(data)
    if not open then return end

    if data.type == "entrer" then
        VFW.OpenUIProperty()
        local property = TriggerServerCallback("vfw:property:enter", VFW.ActualProperty)
        if not property then
            console.debug("Property not found")
            return
        end

        console.debug("Entering property", json.encode(property, {indent = true}))
        if property.garageList then
            local vehicle = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
            if vehicle and (vehicle ~= 0) then
                if (GetPedInVehicleSeat(vehicle, -1) == VFW.PlayerData.ped) and Entity(vehicle).state.VehicleProperties then
                    local result
                    local model = GetEntityModel(vehicle)

                    result, property = TriggerServerCallback("vfw:enterVehicle", VFW.ActualProperty, Entity(vehicle).state.VehicleProperties.plate, GetMakeNameFromVehicleModel(model))
                    if not result then
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "Vous ne pouvez pas rentrer un véhicule qui n'est pas a vous."
                        })
                        return
                    end
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "Vous devez sortir du véhicule ou être conducteur pour rentrer dans le garage."
                    })
                    return
                end
            end

            VFW.LoadGarage(property.maxPlaces, property.garageList)
            property.subTitle = ("%s PLACES"):format(property.maxPlaces)
            property.maxPlaces = nil
            VFW.OpenUIGarage(property)
        else
            VFW.EnterHouse(property)
        end
    elseif data.type == "sonner" then
        TriggerServerEvent("vfw:property:bell", VFW.ActualProperty)
    end
end)

RegisterNetEvent("vfw:property:bell", function(propertyId, targetId)
    VFW.ShowNotification({
        title = "Sonnette",
        mainMessage = "Quelqu'un sonne à la porte",
        type = "INVITE_NOTIFICATION",
        duration = 30
    })

    local choiced = false
    CreateThread(function()
        while not choiced do
            Wait(0)
            if IsControlJustPressed(0, 246) then
                TriggerServerEvent("vfw:property:accept", targetId, propertyId)
                choiced = true
                VFW.RemoveNotification()
            elseif IsControlJustPressed(0, 249) then
                TriggerServerEvent("vfw:property:reject", targetId)
                choiced = true
                VFW.RemoveNotification()
            end
        end
    end)

end)