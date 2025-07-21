RegisterNetEvent("vfw:playerReady", function()
    local shortcuts = GetResourceKvpString("vfw:Shorcut")
    VFW.PlayerData.shortcuts = json.decode(shortcuts or "[]") or {}

    local active = GetResourceKvpInt("vfw:shorcutActive")
    VFW.PlayerData.shortcutsActive = ((active and active or 1) == 1)
end)

RegisterNetEvent("vfw:inventoryGive", function(target)
    VFW.OpenInventory(target)
end)

local open = false
function VFW.OpenInventory(target)
    if not VFW.Items then return end
    open = not open
    if not open then
        SendNUIMessage({
            action = "nui:inventory:visible",
            data = false
        })
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)

        VFW.DisableEscapeMenu(false)
        VFW.Nui.HudVisible(true, true)

        if VFW.PlayerData.target then
            if VFW.PlayerData.target.chestId then
                TriggerServerEvent("vfw:chest:close", VFW.PlayerData.target.chestId)
            elseif VFW.PlayerData.target.pickupId then
                TriggerServerEvent("vfw:pickup:close", VFW.PlayerData.target.pickupId)
            elseif VFW.PlayerData.target.targetId then
                TriggerServerEvent("vfw:search:close", VFW.PlayerData.target.targetId)
            end
            VFW.PlayerData.target = nil
        end

        return
    end

    VFW.Nui.HudVisible(false, true)
    VFW.DisableEscapeMenu(true)

    SendNUIMessage({
        action = "nui:inventory:visible",
        data = true
    })
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SetCursorLocation(0.5, 0.5)

    local change = false
    VFW.PlayerData.target = target
    VFW.LoadInventory()
    CreateThread(function()
        while open do
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 36, true)

            DisablePlayerFiring(VFW.playerId, true)

            if IsControlJustPressed(0, 200) then
                VFW.OpenInventory()
            end

            Wait(0)
        end
    end)
end

function VFW.CloseInventory()
    if open then
        VFW.OpenInventory()
    end
end

function VFW.StateInventory()
    return open
end

RegisterNetEvent("vfw:loadInventory", function(inventory, weight)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
end)

RegisterKeyMapping('+inventory', 'Inventaire', 'keyboard', 'TAB')
RegisterCommand('+inventory', function()
    VFW.OpenInventory()
end)

local function haveItem(itemCompare)
    for i = 1, #VFW.PlayerData.inventory do
        if VFW.SameItem(VFW.PlayerData.inventory[i], itemCompare) then
            return i
        end
    end
    return false
end

local sex = {
    ["m"] = "male",
    ["w"] = "female"
}
local imgType = {
    ["top"] = "torso2",
    ["bottom"] = "leg",
    ["shoe"] = "shoes",
    ["hat"] = "hat",
    ["glasses"] = "glasses",
    ["bag"] = "bag",
    ["ring"] = "ring",
    ["bracelet"] = "bracelet",
    ["earring"] = "ear",
    ["watch"] = "watch",
    ["necklace"] = "accessory",
    ["mask"] = "mask",
    ["outfit"] = "torso2"
}

function VFW.LoadInventory()
    local targetData
    if VFW.PlayerData.target then
        local chestInventory = {}
        for i = 1, #VFW.PlayerData.target.inventory do
            local v = VFW.PlayerData.target.inventory[i]
            if VFW.Items[v.name] then
                chestInventory[#chestInventory + 1] = {
                    id = i,
                    name = v.name,
                    count = v.count,
                    label = VFW.Items[v.name].label,
                    url = VFW.Items[v.name].image,
                    weight = VFW.Items[v.name].weight,
                    weight = VFW.Items[v.name].weight,
                    type = VFW.Items[v.name].type,
                    premium = VFW.Items[v.name].premium,
                    -- durability = 75,
                    position = v.position,
                    metadatas = v.meta,
                }
                local currentItem = chestInventory[#chestInventory]
                if VFW.Items[v.name].type == "clothes" then
                    if (v.name == "accessory") then
                        if (v.meta.type ~= "bracelet") and (v.meta.type ~= "earring") and (v.meta.type ~= "glasses") and (v.meta.type ~= "hat") and (v.meta.type ~= "watch") then
                            if v.meta.var > 0 then
                                currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.meta.type], v.meta.id .. "_"..v.meta.var)
                            else
                                currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.meta.type], v.meta.id)
                            end
                        else
                            if v.meta.var > 0 then
                                currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "props", imgType[v.meta.type], v.meta.id .. "_"..v.meta.var)
                            else
                                currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "props", imgType[v.meta.type], v.meta.id)
                            end
                        end
                    elseif (v.name == "top" or v.name == "outfit") then
                        if v.meta.skin["torso_2"] > 0 then
                            currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.skin["torso_1"] .. "_"..v.meta.skin["torso_2"])
                        else
                            currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.skin["torso_1"])
                        end
                    else
                        if v.meta.var > 0 then
                            currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.id .. "_"..v.meta.var)
                        else
                            currentItem.url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.id)
                        end
                    end
                end
            else
                console.warn(('[VFW - INVENTORY] Tentative de chargement d\'un item invalide ("%s") depuis un coffre.'):format(v.name))
            end
        end
        targetData = {
            items = chestInventory,
            name = VFW.PlayerData.target.name,
            maxWeight = VFW.PlayerData.target.maxWeight,
            currentWeight = VFW.PlayerData.target.weight,
            search = VFW.PlayerData.target.search,
        }
    end

    local inventoryData = {}
    local money = 0

    for i = 1, #VFW.PlayerData.inventory do
        local v = VFW.PlayerData.inventory[i]

        inventoryData[i] = {
            id = i,
            name = v.name,
            count = v.count,
            label = VFW.Items[v.name].label or v.name,
            url = VFW.Items[v.name].image,
            weight = VFW.Items[v.name].weight,
            type = VFW.Items[v.name].type,
            premium = VFW.Items[v.name].premium,
            -- durability = 75,
            position = v.position,
            metadatas = v.meta,
        }
        if VFW.Items[v.name].type == "clothes" then
            if (v.name == "accessory") then
                if (v.meta.type ~= "bracelet") and (v.meta.type ~= "earring") and (v.meta.type ~= "glasses") and (v.meta.type ~= "hat") and (v.meta.type ~= "watch") then
                    if (v.meta.var or 0) > 0 then
                        inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.meta.type], v.meta.id .. "_"..v.meta.var)
                    else
                        inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.meta.type], v.meta.id)
                    end
                else
                    if (v.meta.var or 0) > 0 then
                        inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "props", imgType[v.meta.type], v.meta.id .. "_"..v.meta.var)
                    else
                        inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "props", imgType[v.meta.type], v.meta.id)
                    end
                end
            elseif (v.name == "top" or v.name == "outfit") then
                if v.meta.skin["torso_2"] > 0 then
                    inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.skin["torso_1"] .. "_"..v.meta.skin["torso_2"])
                else
                    inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.skin["torso_1"])
                end
            else
                if (v.meta.var or 0) > 0 then
                    inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.id .. "_"..v.meta.var)
                else
                    inventoryData[i].url = ('https://cdn.eltrane.cloud/alkiarp/outfits_greenscreener/%s/%s/%s/%s.webp'):format(sex[v.meta.sex], "clothing", imgType[v.name], v.meta.id)
                end
            end
        end

        if inventoryData[i].name == "money" then
            money = inventoryData[i].count
        end
    end
    local shortcuts = {}
    for i = 1, 5 do
        if VFW.PlayerData.shortcuts[i] then
            local itemId = haveItem({ name = VFW.PlayerData.shortcuts[i].name, meta = VFW.PlayerData.shortcuts[i].metadatas or {} })

            if itemId then
                shortcuts[i+1] = inventoryData[itemId]
            end
        end
    end

    SendNUIMessage({
        action = "nui:inventory:data",
        data = {
            shortcuts = shortcuts,
            showShortcut = VFW.PlayerData.shortcutsActive,
            maxWeight = VFW.PlayerGlobalData.permissions["staff_menu"] and 1000 or Config.MaxWeight,
            currentWeight = VFW.PlayerData.weight,
            items = inventoryData,
            thirst = VFW.PlayerData.metadata.thirst,
            hunger = VFW.PlayerData.metadata.hunger,
            target = targetData,
            playerInfo = {
                money = money,
                mugshot = VFW.PlayerData.mugshot or "",
                lastname = VFW.PlayerData.lastName or "",
                firstname = VFW.PlayerData.firstName or "",
            }
        }
    })
end

local id = 1
function VFW.NotifyInventoryChange(inventory)
    local oldInventory = VFW.PlayerData.inventory
    local listItems = {}

    for i = 1, #inventory do
        if not listItems[inventory[i].name] then
            listItems[inventory[i].name] = listItems[inventory[i].name] or {}
            listItems[inventory[i].name].newCount = 0

            for j = 1, #inventory do
                if inventory[i].name == inventory[j].name then
                    listItems[inventory[i].name].newCount += inventory[j].count
                end
            end
        end
    end

    for i = 1, #oldInventory do
        if not listItems[oldInventory[i].name] or not listItems[oldInventory[i].name].oldCount then
            listItems[oldInventory[i].name] = listItems[oldInventory[i].name] or {}
            listItems[oldInventory[i].name].oldCount = 0

            for j = 1, #oldInventory do
                if oldInventory[i].name == oldInventory[j].name then
                    listItems[oldInventory[i].name].oldCount += oldInventory[j].count
                end
            end
        end
    end

    for k, v in pairs(listItems) do
        if not v.newCount then
            id += 1
            SendNUIMessage({
                action = "nui:itemTrade:data",
                data = {
                    id = id,
                    type = 0,
                    item_number = v.oldCount,
                    item_image = k..'.webp'
                }
            })
        elseif not v.oldCount then
            id += 1
            SendNUIMessage({
                action = "nui:itemTrade:data",
                data = {
                    id = id,
                    type = 1,
                    item_number = v.newCount,
                    item_image = k..'.webp'
                }
            })
        else
            local diff = v.newCount - v.oldCount
            local positiveDiff = diff > 0 and diff or -diff

            if positiveDiff > 0 then
                id += 1
                SendNUIMessage({
                    action = "nui:itemTrade:data",
                    data = {
                        id = id,
                        type = diff > 0 and 1 or 0,
                        item_number = positiveDiff,
                        item_image = k..'.webp'
                    }
                })
            end
        end
    end
end

RegisterNetEvent("vfw:updateInventory", function(inventory, weight)
    VFW.NotifyInventoryChange(inventory)
    VFW.PlayerData.inventory = inventory
    VFW.PlayerData.weight = weight
    if open then
        VFW.LoadInventory()
    end
end)

RegisterNetEvent("vfw:chest:update", function(inventory, weight)
    VFW.PlayerData.target.inventory = inventory
    VFW.PlayerData.target.weight = weight
    if open then
        VFW.LoadInventory()
    end
end)

RegisterNetEvent("vfw:search:update", function(inventory, weight)
    VFW.PlayerData.target.inventory = inventory
    VFW.PlayerData.target.weight = weight
    if open then
        VFW.LoadInventory()
    end
end)

for i = 1, 5 do
    RegisterCommand(('+shortcut%s'):format(tostring(i)), function()
        newmetadata = {}
        if open then
             print("inventaire ouvert")
            return
         end
        if not VFW.PlayerData.shortcuts[i] then
            print("pas d'arme")
            return end
        if IsPedSittingInAnyVehicle(VFW.PlayerData.ped, false) then
            return
        end 
        newmetadata = {
            ammo = VFW.PlayerData.shortcuts[i].metadatas.ammo,
            weaponId = VFW.PlayerData.shortcuts[i].metadatas.weaponId,
            components = VFW.PlayerData.shortcuts[i].metadatas.components,
            tint = VFW.PlayerData.shortcuts[i].metadatas.tint,
            serialNumber = VFW.PlayerData.shortcuts[i].metadatas.serialNumber,
        }
        local inventory, weight = TriggerServerCallback("vfw:useItem", VFW.PlayerData.shortcuts[i].name, newmetadata)
        VFW.PlayerData.inventory = inventory
        VFW.PlayerData.weight = weight
        VFW.LoadInventory()
    end)
    
    RegisterKeyMapping(('+shortcut%s'):format(tostring(i)), ('Raccourci inventaire %s'):format(tostring(i)), 'keyboard', tostring(i))
end

RegisterCommand('+useAmmo', function(source, args)
    
    if open then return end
    if IsPedSittingInAnyVehicle(VFW.PlayerData.ped, false) then
        return
    end
    if not VFW.PlayerData.inventory then return end
    local inventorys = VFW.PlayerData.inventory

    for i = 1, #inventorys do
        local item = inventorys[i]

        if VFW.Items[item.name] and VFW.Items[item.name].data.type == "ammo" then
            local inventory, weight = TriggerServerCallback("vfw:useItem", item.name, item.meta, item.count)
            VFW.PlayerData.inventory = inventory
            VFW.PlayerData.weight = weight
            VFW.LoadInventory()
            break
        end
    end
end)
RegisterKeyMapping("+useAmmo", "Recharger l'arme", "keyboard", "R")

RegisterClientCallback("vfw:getAmmoInPedWeapon", function(hash)
    local ammo = GetAmmoInClip(VFW.PlayerData.ped, hash)
    return ammo
end)

function VFW.OpenChest(chestId)
    if VFW.StateInventory() then
        VFW.CloseInventory() -- Ferme et reset avant d'ouvrir un nouveau
    end
    local inventory, weight, maxWeight, name = TriggerServerCallback("vfw:chest:get", chestId)
    VFW.OpenInventory({
        chestId = chestId,
        inventory = inventory,
        name = name,
        maxWeight = maxWeight,
        weight = weight,
        search = false,
    })
end

function VFW.OpenShearch(targetId)
    if targetId == GetPlayerServerId(NetworkGetPlayerIndexFromPed(VFW.PlayerData.ped)) then
        return
    end
    local inventory = TriggerServerCallback("vfw:search:get", targetId)

    VFW.OpenInventory({
        targetId = targetId,
        inventory = inventory or {},
        name = "",
        maxWeight = 0,
        weight = 0,
        search = true,
    })
end

RegisterClientCallback("vfw:getMaxAmmo", function()
    local weapon = GetSelectedPedWeapon(VFW.PlayerData.ped)
    if weapon == `weapon_unarmed` then
    return false, false
    end
    return string.lower(VFW.GetWeaponFromHash(weapon).name), GetMaxAmmoInClip(VFW.PlayerData.ped, weapon)
end)

RegisterNetEvent("lb-phone:usePhoneItem", function()
    VFW.CloseInventory()
end)

function VFW.HaveTablet()
    for i = 1, #VFW.PlayerData.inventory do
        if VFW.PlayerData.inventory[i].name == "tablet" then
            return true
        end
    end
    return false
end


