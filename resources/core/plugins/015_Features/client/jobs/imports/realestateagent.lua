function CreateJobInvoince()
    if not VFW.PlayerData.job.onDuty then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
        return
    end
end

local pointList = {}
function VFW.PointCreate(id, pos)
    local inPoint = false
    pointList[id] = Worlds.Zone.Create(vector3(pos.x, pos.y, pos.z - 0.3), 1, false, function()
        console.debug("Entering edit property interaction zone "..id)
        
        inPoint = true
        CreateThread(function()
            while inPoint do
                if IsControlJustPressed(0, 47) then
                    VFW.OpenPropertyEdit(id)
                end
                Wait(0)
            end
        end)
    end, function()
        console.debug("Exiting edit property interaction zone "..id)

        inPoint = false
    end, "Gérer", "G", "tshirt", "#38D964", -0.25)
end

AddEventHandler("vfw:loadProperty", function(id, pos)
    if VFW.PlayerData.job.name ~= "dynasty" then return end
    if not VFW.PlayerData.job.onDuty then return end
    VFW.PointCreate(id, pos)
end)

AddEventHandler("vfw:deleteProperty", function(id)
    if VFW.PlayerData.job.name ~= "dynasty" then return end
    if not VFW.PlayerData.job.onDuty then return end
    Worlds.Zone.Remove(pointList[id])
    pointList[id] = nil
end)

local function loadPropertiesEdit()
    for k, v in pairs(VFW.Properties) do
        local info = Worlds.Zone.Get(v)

        VFW.PointCreate(k, info.coords)
    end
end

local function unloadPropertiesEdit()
    for k, v in pairs(pointList) do
        Worlds.Zone.Remove(v)
        pointList[k] = nil
    end
end

CreateJobAdvert = function()
    if not VFW.PlayerData.job.onDuty then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
        return
    end
    VFW.Nui.AnnounceEntreprise(true)
end

function SetJobDuty()
    VFW.ChangeDuty(not VFW.PlayerData.job.onDuty)
    if VFW.PlayerData.job.onDuty then
        loadPropertiesEdit()
        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous êtes maintenant en service."
        })
    else
        unloadPropertiesEdit()
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous n'êtes plus en service."
        })
    end
end

function OpenInvoice()
    TriggerEvent("vfw:radial:open:invoice")
end

function OpenPropertyCreationMenu()
    if not VFW.PlayerData.job.onDuty then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
        return
    end
    VFW.Nui.Radial(nil,false)
    radialOpen = false
    VFW.CreateProperty()
end

local function GetPropertyList()
    local properties = {}
    for i = 1, #Property.Garage.data do
        local property = Property.Garage.data[i]
        table.insert(properties, {
            type = "Garage",
            name = property.name,
            img = property.id
        })  
    end
    for i = 1, #Property.Appartement.data do
        local property = Property.Appartement.data[i]
        table.insert(properties, {
            type = "Habitations",
            name = property.name,
            img = property.id
        })  
    end
    for i = 1, #Property.Entrepot.data do
        local property = Property.Entrepot.data[i]
        table.insert(properties, {
            type = "Entrepot",
            name = property.name,
            img = property.id
        })  
    end
    return properties
end

local openEdit = false
local idProperty = 0
function VFW.OpenPropertyEdit(id)
    openEdit = not openEdit
    SetNuiFocus(openEdit, openEdit)
    VFW.Nui.HudVisible(not openEdit)
    SendNUIMessage({
        action = "nui:habitation-menu:visible",
        data = openEdit
    })
    if openEdit then
        SetCursorLocation(0.5, 0.5)
        local property = TriggerServerCallback("vfw:job:dynasty:getProperty", id)
        idProperty = id
        local endOwner, _ = string.find(property.owner, ":")
        SendNUIMessage({
            action = "nui:habitation-menu:data",
            data = {    
                type = "Gestion",
                name = property.name,
                access = property.state,
                ownerType = string.sub(property.owner, 1, (endOwner or 2)-1), 
            }
        })
    else
        idProperty = 0
    end
end

RegisterNUICallback("nui:habitation-menu:transfert", function()
    if not openEdit then return end
    local propertyId = idProperty
    VFW.OpenPropertyEdit()

    local playerId = VFW.StartSelect(5.0)
    if not playerId then return end

    TriggerServerEvent("vfw:job:dynasty:transfert", propertyId, GetPlayerServerId(playerId))
end)

RegisterNUICallback("nui:habitation-menu:double", function()
    if not openEdit then return end
    local propertyId = idProperty
    VFW.OpenPropertyEdit()

    local playerId = VFW.StartSelect(5.0)
    if not playerId then return end

    TriggerServerEvent("vfw:job:dynasty:giveKey", propertyId, GetPlayerServerId(playerId))
end)

RegisterNUICallback("nui:habitation-menu:confirm", function(data)
    if not openEdit then return end
    TriggerServerCallback("vfw:job:dynasty:propertyUpdate", idProperty, data)
    VFW.OpenPropertyEdit()
end)

RegisterNUICallback("nui:habitation-menu:delete", function()
    if not openEdit then return end
    local propertyId = idProperty
    VFW.OpenPropertyEdit()
    local validations = VFW.Nui.KeyboardInput(true, "Confimer 'OUI'")

    if string.lower(validations) == "oui" then
        TriggerServerEvent("vfw:job:dynasty:deleteProperty", propertyId)

        VFW.ShowNotification({
            type = 'VERT',
            content = "Vous venez de supprimer la propriété."
        })
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas confirmé."
        })
    end
end)

RegisterNUICallback("nui:habitation-menu:copro", function()
    if not openEdit then return end
    local propertyId = idProperty
    VFW.OpenPropertyEdit()
    idProperty = propertyId
    VFW.OpenGestionCoowner()
end)

local coOwnerList = {}
local openCopro = false
function VFW.OpenGestionCoowner()
    openCopro = not openCopro
    SetNuiFocus(openCopro, openCopro)
    VFW.Nui.HudVisible(not openCopro)
    SendNUIMessage({
        action = "nui:property-menu:visible",
        data = openCopro
    })
    if openCopro then
        SetCursorLocation(0.5, 0.5)
        local propertyData = TriggerServerCallback("vfw:job:dynasty:coowner", idProperty)
        SendNUIMessage({
            action = "nui:property-menu:dataCoowner",
            data = propertyData
        })
    else
        idProperty = 0
    end
end

RegisterNUICallback("nui:property-menu:return", function(id)
    if not openCopro then return end
    TriggerServerEvent("vfw:job:dynasty:save", idProperty, id)
    VFW.OpenGestionCoowner()
end)

RegisterNUICallback("nui:property-menu:close", function()
    if not openCopro then return end
    VFW.OpenGestionCoowner()
end)

local open = false
function VFW.CreateProperty()
    open = not open
    SetNuiFocus(open, open)
    VFW.Nui.HudVisible(not open)
    SendNUIMessage({
        action = "nui:habitation-menu:visible",
        data = open
    })
    if open then
        SetCursorLocation(0.5, 0.5)
        SendNUIMessage({
            action = "nui:habitation-menu:data",
            data = {
                type = "Creation",
                duration = 1,
                maxLocationJours = 30,
                items = GetPropertyList(),
                durationProlongation = 1
            }
        })
    else
        VFW.ClosePropertyPreview()
    end
end

RegisterNUICallback("nui:habitation-menu:close", function()
    if open then
        VFW.CreateProperty()
    elseif openEdit then
        VFW.OpenPropertyEdit()
    end
end)

RegisterNUICallback("nui:habitation-menu:create", function(data)
    if not open then return end
    VFW.CreateProperty()
    data.pos = GetEntityCoords(VFW.PlayerData.ped)
    TriggerServerEvent("vfw:job:dynasty:createProperty", data)
end)

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

local id = 0
RegisterNUICallback("nui:habitation-menu:selectedItems", function(data)
    if not open then return end

    local property = GetPropertyByName(data.items)
    if not property then return end
    id += 1
    local currentId = id
    DoScreenFadeOut(250)
    Wait(250)
    if currentId ~= id then return end
    SetFocusArea(property.cam.CamCoords.x, property.cam.CamCoords.y, property.cam.CamCoords.z)
    Wait(1000)
    if currentId ~= id then return end
    if property.ipl then
        property.ipl()
    else
        PinInteriorInMemory(GetInteriorAtCoords(property.cam.CamCoords.x, property.cam.CamCoords.y, property.cam.CamCoords.z))
    end
    Wait(500)
    if currentId ~= id then return end
    if VFW.Cam:Get("previewHabitation") then
        VFW.Cam:Update("previewHabitation", property.cam)
    else
        VFW.Cam:Create("previewHabitation", property.cam)
    end
    DoScreenFadeIn(250)
end)

RegisterNUICallback("nui:habitation-menu:disablePreview", function()
    if not open then return end
    VFW.ClosePropertyPreview()
end)

function VFW.ClosePropertyPreview()
    if VFW.Cam:Get("previewHabitation") then
        id += 1
        DoScreenFadeOut(250)
        Wait(250)
        VFW.Cam:Destroy("previewHabitation")
        ClearFocus()
        Wait(500)
        DoScreenFadeIn(500)
    end
end