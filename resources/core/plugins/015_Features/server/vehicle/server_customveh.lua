local function getPlayer(source)
    return VFW.GetPlayerFromId(source)
end

RegisterServerCallback("core:server:customveh:pay", function(source, price)
    local xPlayer = getPlayer(source)
    if not xPlayer then return false end
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        return true
    else
        return false
    end
end) 