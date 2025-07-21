RegisterServerCallback("core:mechanic:hasRepairKit", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    xPlayer.updateInventory()
    hasItem = xPlayer.haveItem("repairkit")
    if hasItem then
        xPlayer.removeItem("repairkit", 1, {})
        xPlayer.updateInventory()
        return hasItem
    end
    return hasItem
end)

RegisterServerCallback("core:mechanic:hasCleanKit", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    xPlayer.updateInventory()
    hasItem = xPlayer.haveItem("cleankit")
    if hasItem then
        xPlayer.removeItem("cleankit", 1, {})
        xPlayer.updateInventory()
        return hasItem
    end
    return hasItem
end)

RegisterServerCallback("core:mechanic:hasCarroserieKit", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    xPlayer.updateInventory()
    hasItem = xPlayer.haveItem("kitcarosserie")
    if hasItem then
        xPlayer.removeItem("kitcarosserie", 1, {})
        xPlayer.updateInventory()
        return hasItem
    end
    return hasItem
end)

RegisterServerCallback("core:mechanic:hasCrochetageKit", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    xPlayer.updateInventory()
    hasItem = xPlayer.haveItem("crochet")
    if hasItem then
        xPlayer.removeItem("crochet", 1, {})
        xPlayer.updateInventory()
        return hasItem
    end
    return hasItem
end)