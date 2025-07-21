VFW.RegisterUsableItem("laptop", function(xPlayer)
    TriggerClientEvent("core:UseLaptop", xPlayer.source)
end)

RegisterNetEvent("core:removeLaptop")
AddEventHandler("core:removeLaptop", function()
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    xPlayer.removeItem("laptop", 1, {})
    xPlayer.updateInventory()
end)
