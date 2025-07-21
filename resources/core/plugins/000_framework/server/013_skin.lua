RegisterNetEvent("vfw:skin:save", function(skin)
    if not skin or type(skin) ~= "table" then
        return
    end

    local xPlayer = VFW.GetPlayerFromId(source)

    xPlayer.skin = skin
end)

RegisterServerCallback("vfw:skin:getPlayerSkin", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)

    return xPlayer.skin
end)
