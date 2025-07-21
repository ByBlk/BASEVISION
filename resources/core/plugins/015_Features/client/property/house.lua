local function GetPropertyByName(name)
    for k, v in pairs(Property) do
        for i = 1, #v.data do
            if v.data[i].name == name then
                return v.data[i] 
            end
        end
    end
    return false
end

local handleList = {}
local function deletingHandle()
    for i = 1, 3 do
        if handleList[i] then
            Worlds.Zone.Remove(handleList[i])
            handleList[i] = nil
        end
    end
    VFW.RemoveInteraction("gestionProperty")
    VFW.RemoveInteraction("chestProperty")
    VFW.RemoveInteraction("leaveProperty")
end
function VFW.EnterHouse(name, force)
    local property = GetPropertyByName(name)
    if not property then return end
    deletingHandle()

    if not force then
        DoScreenFadeOut(500)
        Wait(500)
        FreezeEntityPosition(VFW.PlayerData.ped, true)
        if property.ipl then
            property.ipl()
        end
        SetEntityCoords(VFW.PlayerData.ped, property.leave-vec3(0,0,0.9))
        Wait(1000)
        FreezeEntityPosition(VFW.PlayerData.ped, false)
        DoScreenFadeIn(500)
    end

    handleList[1] = Worlds.Zone.Create(property.leave, 1, false, function()
        console.debug("Entering property leave interaction zone "..name)
        
        VFW.RegisterInteraction("leaveProperty", function()
            deletingHandle()
            DoScreenFadeOut(500)
            Wait(1000)
            FreezeEntityPosition(VFW.PlayerData.ped, true)
            TriggerServerEvent("vfw:leaveProperty", VFW.ActualProperty)
            Wait(1000)
            FreezeEntityPosition(VFW.PlayerData.ped, false)
            DoScreenFadeIn(500)
        end)
    end, function()
        console.debug("Exiting property leave interaction zone "..name)
        VFW.RemoveInteraction("leaveProperty")
    end, "Sortir", "E", "tshirt")

    handleList[2] = Worlds.Zone.Create(property.coffre, 1, false, function()
        console.debug("Entering property chest interaction zone "..name)
        
        VFW.RegisterInteraction("chestProperty", function()
            VFW.OpenChest(("property:%s"):format(VFW.ActualProperty))
        end)
    end, function()
        console.debug("Exiting property chest interaction zone "..name)
        VFW.RemoveInteraction("chestProperty")
    end, "Coffre", "E", "tshirt")

    handleList[3] = Worlds.Zone.Create(property.gestion, 1, false, function()
        console.debug("Entering property gestion interaction zone "..name)
        
        VFW.RegisterInteraction("gestionProperty", function()
            VFW.OpenGestionProperty()
        end)
    end, function()
        console.debug("Exiting property gestion interaction zone "..name)
        VFW.RemoveInteraction("gestionProperty")
    end, "Gestion", "E", "tshirt")
end

local coOwnerList = {}
local open = false
function VFW.OpenGestionProperty()
    open = not open
    SetNuiFocus(open, open)
    VFW.Nui.HudVisible(not open)
    SendNUIMessage({
        action = "nui:property-menu:visible",
        data = open
    })
    if open then
        SetCursorLocation(0.5, 0.5)
        local propertyData = TriggerServerCallback("vfw:property:get", VFW.ActualProperty)
        if not propertyData then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez pas gérer cette propriété."
            })
            VFW.OpenGestionProperty()
        else
            SendNUIMessage({
                action = "nui:property-menu:data",
                data = propertyData
            })
        end
    end
end

RegisterNUICallback("nui:property-menu:close", function()
    if not open then return end
    VFW.OpenGestionProperty()
end)

RegisterNUICallback("nui:property-menu:save", function(data)
    if not open then return end
    VFW.OpenGestionProperty()
    TriggerServerEvent("vfw:property:save", VFW.ActualProperty, data)
end)