local PawnshopConfig = exports["core"]:GetPawnshopConfig()

local pawnshopPed = nil

local function DeletePawnshopPed()
    if pawnshopPed and DoesEntityExist(pawnshopPed) then
        DeleteEntity(pawnshopPed)
        pawnshopPed = nil
    end
end

local function ExchangeAllItems(player)
    local totalMoney = 0
    local hasItems = false
    
    for i = 1, #player.inventory do
        local item = player.inventory[i]
        if PawnshopConfig.items[item.name] then
            hasItems = true
            totalMoney = totalMoney + (item.count * PawnshopConfig.items[item.name].price)
            player.removeItem(item.name, item.count, {})
        end
    end
    
    if not hasItems then
        return false, PawnshopConfig.messages.noItems
    end
    
    local currentWeight = player.getWeight()
    local moneyWeight = VFW.Items["money"].weight * totalMoney
    local maxWeight = Config.MaxWeight
    
    if currentWeight + moneyWeight > maxWeight then
        return false, PawnshopConfig.messages.notEnoughSpace
    end
    
    player.addMoney(totalMoney)
    player.updateInventory()
    
    return true, string.format(PawnshopConfig.messages.exchangeSuccess, totalMoney)
end

RegisterNetEvent("pawnshop:exchangeItems", function()
    local source = source
    local player = VFW.GetPlayerFromId(source)
    
    if not player then
        return
    end
    
    local success, message = ExchangeAllItems(player)
    
    if success then
        TriggerClientEvent("vfw:showNotification", source, {
            type = PawnshopConfig.notifications.success.type,
            content = message
        })
    else
        TriggerClientEvent("vfw:showNotification", source, {
            type = PawnshopConfig.notifications.error.type,
            content = message
        })
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeletePawnshopPed()
    end
end)

