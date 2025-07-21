RegisterNetEvent("catalogue:farm:buy", function(recu, price, item)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    
    if not xPlayer then
        return
    end

    if xPlayer.getMoney() < price then
        xPlayer.showNotification({
            type = "ROUGE",
            content = "Vous n'avez pas assez d'argent sur vous. Prix: " .. price .. "$"
        })
        return
    end

    xPlayer.removeMoney(price)
    
    for k, v in pairs(item) do
        xPlayer.addItem(v.model, v.quantity)
        xPlayer.updateInventory()
    end
    
    xPlayer.addItem("papier", 1, recu)
    xPlayer.updateInventory()
    
    xPlayer.showNotification({
        type = "VERT",
        content = "Achat effectué pour " .. price .. "$"
    })
end)