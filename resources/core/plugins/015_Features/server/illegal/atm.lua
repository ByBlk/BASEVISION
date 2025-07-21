local playerList = {}

RegisterServerCallback("core:atm:AlreadyRob", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)

    if xPlayer.identifier ~= nil then
        for k, v in pairs(playerList) do
            if v == xPlayer.identifier then
                return true
            end
        end
    end

    return false
end)

RegisterNetEvent("core:atm:AddMoney", function(money)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)

    xPlayer.createItem("money", money)

    if xPlayer.identifier ~= nil then
        table.insert(playerList, xPlayer.identifier)
    end
end)
