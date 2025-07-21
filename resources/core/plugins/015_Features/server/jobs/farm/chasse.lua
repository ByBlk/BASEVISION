local limit = {}

local huntingAnimals = {
    { ped = "a_c_boar", meat = "viandesanglier", label = "Viande de sanglier" },
    { ped = "a_c_deer", meat = "viandebiche", label = "Viande de biche" },
    { ped = "a_c_rabbit_01", meat = "viandelapin", label = "Viande de lapin" },
    { ped = "a_c_mtlion", meat = "viandepuma", label = "Viande de puma" },
    { ped = "a_c_pigeon", meat = "viandeoiseau", label = "Viande de pigeon" },
    { ped = "a_c_seagull", meat = "viandeoiseau", label = "Viande d'oiseau" },
    { ped = "a_c_chickenhawk", meat = "viandeoiseau", label = "Viande d'aigle" },
}

function isHuntingAnimal(entityModel)
    for _, animal in ipairs(huntingAnimals) do
        if GetHashKey(animal.ped) == entityModel then
            return true
        end
    end
    return false
end

RegisterNetEvent("core:Hunting:depece", function(animalID, animals)
    local xPlayer = VFW.GetPlayerFromId(source)
    local entity = NetworkGetEntityFromNetworkId(animalID)
    local entityModel = GetEntityModel(entity)

    if animalID and entity and DoesEntityExist(entity) and isHuntingAnimal(entityModel) then
        if not limit[animalID] then
            limit[animalID] = true

            xPlayer.createItem(animals, 1)
            xPlayer.updateInventory()
            DeleteEntity(entity)
        else
            console.debug("Cet animal a déjà été dépecé.")
        end
    else
        console.debug("animalID or entity is nil or don't exist")
    end
end)

RegisterNetEvent("core:Hunting:removeWeapons", function()
    local xPlayer = VFW.GetPlayerFromId(source)
    if xPlayer.haveItem("weapon_knife") then
        xPlayer.removeItem("weapon_knife", 1, {})
        xPlayer.updateInventory()
    end
    if xPlayer.haveItem("weapon_musket") then
        xPlayer.removeItem("weapon_musket", 1, {})
        xPlayer.updateInventory()
    end
end)

RegisterNetEvent("core:sellHunt")
AddEventHandler("core:sellHunt", function (token, name, price, quantity)
    local id = GetPlayer(source):getId()
    if id ~= nil then    
        if limit[id] == nil then
            limit[id] = 0
        end
        new_limit = tonumber(quantity) + limit[id]
        if CheckPlayerToken(source, token) then
            if DoesPlayerHaveItemCount(source, name, quantity) then
                if AddItemToInventory(source, "money", price * quantity, {}) then
                    if new_limit <= 234 then
                        RemoveItemFromInventory(source, name, quantity, {})
                        --[[TriggerClientEvent("core:ShowNotification", source, "~g~Tu as vendu x" .. quantity .. " ~o~" .. getItemLabel(name) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")]]
                        TriggerClientEvent("__kpz::createNotification", source, {
                            type = 'DOLLAR',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Tu as vendu ~s x" .. quantity .. " " .. getItemLabel(name) .. " ~c pour ~s $" .. price * quantity
                        })
                        limit[id] = new_limit
                    else
                        --[[TriggerClientEvent("core:ShowNotification", source, "~r~Tu as atteint la limite de 234 viandes par jour")]]
                        TriggerClientEvent("__kpz::createNotification", source, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Tu as atteint la limite de 234 viandes par jour"
                        })
                    end
                else
                    --[[TriggerClientEvent("core:ShowNotification", source, "~r~Tu n'as pas assez de place dans ton inventaire")]]
                    TriggerClientEvent("__kpz::createNotification", source, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Tu n'as pas assez de place dans ton inventaire"
                    })
                end
            else
                TriggerClientEvent("__kpz::createNotification", source, {
                    type = 'ROUGE',
                    content = "~s Tu n'as pas assez de " .. getItemLabel(name)
                })
            end
        end  
    end
end)

RegisterNetEvent("hunt:animalLock")
AddEventHandler("hunt:animalLock", function(animal)
    TriggerClientEvent("hunt:animalLock", -1, animal)
end)