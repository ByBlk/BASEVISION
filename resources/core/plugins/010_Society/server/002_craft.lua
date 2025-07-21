RegisterNetEvent("society:craft:startLogs", function(name, quantity)
    local source = source
    logs.society.startCraft(source, name, quantity)
end)

RegisterServerCallback("society:craft:removeitem", function(source, items)
    local xPlayer = VFW.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    for _, rI in pairs(items) do
        for _, mI in pairs(inventory) do
            if mI.name == rI.name then
                if mI.count >= rI.amount then
                    xPlayer.removeItem(mI.name, rI.amount, {})
                else
                    return false
                end
            end  
        end
    end
    xPlayer.updateInventory()
    return true
end)

RegisterNetEvent("society:craft:additem", function(name, quantity)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.addItem(name, quantity, {})
    xPlayer.updateInventory()
    logs.society.finishCraft(source, name, quantity)
end)