local function DataToInfo(data)
    console.debug("DataToInfo:", json.encode(data, { indent = true }))
    local info = {}
    local quantity
    if data.quantity and data.quantity > 0 then
        quantity = data.quantity
    end
    if data.item.id then
        info = { position = data.item.position, type = data.item.type, quantity = quantity or data.item.count }
    else
        for k, v in pairs(data.item) do
            info[k] = { position = v.position, type = v.type, quantity = quantity or v.count }
        end
    end
    console.debug("DataToInfo:", json.encode(info, { indent = true }))
    return info
end

local pedModel = {
    ["m"] = 0,
    ["w"] = 1
}

local function RefreshInventory(data)
    local info = {}

    if data.item.id then
        info = { type = data.item.type, name = data.item.name, meta = data.item.metadatas }
    else
        for k, v in pairs(data.item) do
            info[k] = { type = v.type, name = v.name, meta = v.metadatas }
        end
    end

    if (VFW.Items[info.name].type == "weapons") and string.find(info.name, "weapon_") then
        if IsPedArmed(VFW.PlayerData.ped, 4) then
            RemoveWeaponFromPed(VFW.PlayerData.ped, GetHashKey(info.name))
        end
    elseif VFW.Items[info.name].type == "clothes" then
        if GetClothes[info.name] then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == pedModel[info.meta.sex] then
                    TriggerEvent("vfw:clothes", info.name, info.meta)
                else
                    self.showNotification({
                        type = 'ROUGE',
                        content = "Vous ne pouvez pas utiliser des vêtements qui ne sont pas de votre sexe."
                    })
                end
            end)
        end
    end
end

local isDragging = false
RegisterNUICallback("nui:inventory:drag-item", function(data)
    isDragging = data.isDragging

    local SCREEN_X <const>, SCREEN_Y <const> = GetActiveScreenResolution()
    while isDragging do
        local x, y = GetNuiCursorPosition()
        local hit, worldPosition, normalDirection, entity = RaycastScreen(vector2(x/SCREEN_X, y/SCREEN_Y), 100.0, VFW.PlayerData.ped)

        local change = false
        if entity and IsEntityAPed(entity) and IsPedAPlayer(entity) then
            change = true
            SetEntityAlpha(entity, 200, false)
        end

        Wait(100)
        if change then
            ResetEntityAlpha(entity)
        end
    end
end)

RegisterNUICallback("nui:inventory:move-item", function(data)
    local positionsStart = {
        x = data.item.position.x,
        y = data.item.position.y
    }
    local positionsEnd = {
        x = tonumber(data.newPosition.x),
        y = tonumber(data.newPosition.y)
    }

    local inventory, weight = TriggerServerCallback("vfw:moveItem", positionsStart, positionsEnd, data.item.type)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:toggle-shortcuts", function()
    VFW.PlayerData.shortcutsActive = not VFW.PlayerData.shortcutsActive
    SetResourceKvpInt("vfw:ShorcutActive", VFW.PlayerData.shortcutsActive and 1 or 0)
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:use-item", function(data)
    local inventory, weight = TriggerServerCallback("vfw:useItem", data.name, data.metadatas)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:throw-item", function(data)
    local info = DataToInfo(data)
    local SCREEN_X <const>, SCREEN_Y <const> = GetActiveScreenResolution()
    local x, y = GetNuiCursorPosition()
    local hit, worldPosition, normalDirection, entity = RaycastScreen(vector2(x/SCREEN_X, y/SCREEN_Y), 100.0, VFW.PlayerData.ped)

    if entity and IsEntityAPed(entity) and IsPedAPlayer(entity) then
        local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
        
        local inventory, weight = TriggerServerCallback("vfw:giveItem", id, info)
        VFW.NotifyInventoryChange(inventory)
        VFW.PlayerData.inventory = inventory
        VFW.PlayerData.weight = weight
        VFW.LoadInventory()
        RefreshInventory(data)
    else
        local inventory, weight = TriggerServerCallback("vfw:dropItem", info)
        VFW.NotifyInventoryChange(inventory)
        VFW.PlayerData.inventory = inventory
        VFW.PlayerData.weight = weight
        VFW.LoadInventory()
        RefreshInventory(data)
    end
end)

RegisterNUICallback("nui:inventory:bind-weapon", function(data)
    VFW.PlayerData.shortcuts[data.bind] = { name = data.item.name, metadatas = data.item.metadatas }
    SetResourceKvp("vfw:Shorcut", json.encode(VFW.PlayerData.shortcuts))
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:unbind-weapon", function(data)
    VFW.PlayerData.shortcuts[data.bind] = nil
    SetResourceKvp("vfw:Shorcut", json.encode(VFW.PlayerData.shortcuts))
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:split", function(data)
    if (data.split <= 0) and (data.split >= data.item.count) then
        return
    end
    local inventory, weight = TriggerServerCallback("vfw:splitItem", data.item.position, data.item.type, data.split)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
end)

RegisterNUICallback("nui:inventory:rename", function(data)
    local inventory, weight = TriggerServerCallback("vfw:renameItem", data.item.position, data.item.type, data.name)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    VFW.OpenInventory()
    
end)

RegisterNUICallback("nui:inventory:focus", function()
    SetNuiFocusKeepInput(false)
end)

RegisterNUICallback("nui:inventory:unfocus", function()
    SetNuiFocusKeepInput(true)
end)

RegisterNUICallback("nui:inventory:put-item", function(data)
    local inventory, weight
    local info = DataToInfo(data)
    if VFW.PlayerData.target.chestId then
        inventory, weight = TriggerServerCallback("vfw:chest:put-item", VFW.PlayerData.target.chestId, info)
    elseif VFW.PlayerData.target.pickupId then
        inventory, weight = TriggerServerCallback("vfw:pickup:put-item", VFW.PlayerData.target.pickupId, info)
    end
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    RefreshInventory(data)
end)

RegisterNUICallback("nui:inventory:take-item", function(data)
    local inventory, weight
    local info = DataToInfo(data)
    if VFW.PlayerData.target.chestId then
        inventory, weight = TriggerServerCallback("vfw:chest:take-item", VFW.PlayerData.target.chestId, info)
    elseif VFW.PlayerData.target.pickupId then
        inventory, weight = TriggerServerCallback("vfw:pickup:take-item", VFW.PlayerData.target.pickupId, info)
    elseif VFW.PlayerData.target.targetId then
        inventory, weight = TriggerServerCallback("vfw:search:take-item", VFW.PlayerData.target.targetId, info)
    end
    if not inventory and not weight then return end
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    RefreshInventory(data)
end)

RegisterNUICallback("nui:inventory:move-item-in-target", function(data)
    local positionsStart = {
        x = data.item.position.x,
        y = data.item.position.y
    }
    local positionsEnd = {
        x = tonumber(data.newPosition.x),
        y = tonumber(data.newPosition.y)
    }

    if VFW.PlayerData.target.chestId then
        TriggerServerEvent("vfw:chest:moveItem", VFW.PlayerData.target.chestId, positionsStart, positionsEnd)
    elseif VFW.PlayerData.target.pickupId then
        TriggerServerEvent("vfw:pickup:moveItem", VFW.PlayerData.target.pickupId, positionsStart, positionsEnd)
    end
end)

RegisterNUICallback("nui:inventory:drop", function(data)
    local info = DataToInfo(data)
    local inventory, weight = TriggerServerCallback("vfw:dropItem", info)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    RefreshInventory(data)
end)

RegisterNUICallback("nui:inventory:trade", function(data)
    local inventory, weight
    local info = DataToInfo(data)
    if data.source == "target" then
        if VFW.PlayerData.target.chestId then
            inventory, weight = TriggerServerCallback("vfw:chest:take-item", VFW.PlayerData.target.chestId, info)
        elseif VFW.PlayerData.target.pickupId then
            inventory, weight = TriggerServerCallback("vfw:pickup:take-item", VFW.PlayerData.target.pickupId, info)
        end
    else
        if VFW.PlayerData.target.chestId then
            inventory, weight = TriggerServerCallback("vfw:chest:put-item", VFW.PlayerData.target.chestId, info)
        elseif VFW.PlayerData.target.pickupId then
            inventory, weight = TriggerServerCallback("vfw:pickup:put-item", VFW.PlayerData.target.pickupId, info)
        end
    end
    if not inventory and not weight then return end
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    RefreshInventory(data)
end)

RegisterNUICallback("nui:inventory:give", function(data)
    VFW.CloseInventory()
    local waitSelect = true
    CreateThread(function()
        while waitSelect do
            if VFW.StateInventory() then
                VFW.ForceStopSelect()
                waitSelect = false
            end
            Wait(5)
        end
    end)
    local playerId = VFW.StartSelect(5.0, true)
    waitSelect = false
    if not playerId then return end

    local info = DataToInfo(data)
    local id = GetPlayerServerId(playerId)
    local inventory, weight = TriggerServerCallback("vfw:giveItem", id, info)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
    RefreshInventory(data)
end)

RegisterNUICallback("nui:inventory:giveMoney", function()
    VFW.CloseInventory()
    local waitSelect = true
    CreateThread(function()
        while waitSelect do
            if VFW.StateInventory() then
                VFW.ForceStopSelect()
                waitSelect = false
            end
            Wait(5)
        end
    end)
    local playerId = VFW.StartSelect(5.0, true)
    waitSelect = false
    if not playerId then return end

    local count = VFW.Nui.KeyboardInput(true, "Montant à donner")
    if (not count) or (not tonumber(count)) then return end

    local id = GetPlayerServerId(playerId)
    local inventory, weight = TriggerServerCallback("vfw:giveMoney", id, tonumber(count))
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    VFW.LoadInventory()
end)