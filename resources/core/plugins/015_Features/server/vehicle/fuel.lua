RegisterServerCallback("core:server:getFuelMoney", function(source, type, price)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if type == "espèce" then
        if xPlayer.getMoney() >= tonumber(price) then
            xPlayer.removeMoney(tonumber(price))
            return true
        end
    elseif type == "carte" then
        if xPlayer.getAccount("bank").money >= tonumber(price) then
            xPlayer.removeAccountMoney("bank", tonumber(price))
            return true
        end
    end

    return false
end)

RegisterNetEvent("vfw:removePetrolCan", function()
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.removeItem("weapon_petrolcan", 1, {})
    xPlayer.updateInventory()
end)

RegisterNetEvent("vfw:addPetrolCan", function()
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.createItem("weapon_petrolcan", 1)
    xPlayer.updateInventory()
end)
