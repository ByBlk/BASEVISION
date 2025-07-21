RegisterNetEvent("core:farms:recolte", function(job, data)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    if data.item and data.amount then
        xPlayer.addItem(data.item, data.amount)
        xPlayer.updateInventory()
        xPlayer.showNotification({
            type = "VERT",
            content = "Vous avez récolté " .. data.amount .. "x " .. data.item
        })
    end
end)

RegisterNetEvent("core:farms:traitement", function(job, data)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    if data.itemIn and data.itemOut and data.amount then
        local count = 0
        for _, item in pairs(xPlayer.getInventory()) do
            if item.name == data.itemIn then
                count = count + (item.count or 0)
            end
        end
        if count >= data.amount then
            xPlayer.removeItem(data.itemIn, data.amount)
            xPlayer.addItem(data.itemOut, data.amount)
            xPlayer.updateInventory()
            xPlayer.showNotification({
                type = "VERT",
                content = "Vous avez traité " .. data.amount .. "x " .. data.itemIn .. " en " .. data.itemOut
            })
        else
            xPlayer.showNotification({
                type = "ROUGE",
                content = "Vous n'avez pas assez de " .. data.itemIn
            })
        end
    end
end)

RegisterNetEvent("core:farms:vente", function(job, data)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    if data.item and data.price then
        local total = 0
        for _, item in pairs(xPlayer.getInventory()) do
            if item.name == data.item then
                total = total + (item.count or 0)
            end
        end
        if total > 0 then
            xPlayer.removeItem(data.item, total)
            xPlayer.addMoney(data.price * total)
            xPlayer.updateInventory()
            xPlayer.showNotification({
                type = "VERT",
                content = "Vous avez vendu " .. total .. "x " .. data.item .. " pour $" .. (data.price * total)
            })
        else
            xPlayer.showNotification({
                type = "ROUGE",
                content = "Vous n'avez pas d'" .. data.item .. " à vendre"
            })
        end
    end
end) 