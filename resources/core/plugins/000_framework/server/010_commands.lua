RegisterCommand("playtime", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    local playtime = xPlayer.getPlayTime()
    local days = math.floor(playtime / 86400)
    local hours = math.floor((playtime % 86400) / 3600)
    local minutes = math.floor((playtime % 3600) / 60)

    xPlayer.showNotification({
        type = 'INFO',
        content = ("Playtime: ^5%s^0 Days | ^5%s^0 Hours | ^5%s^0 Minutes"):format(days, hours, minutes)
    })
end, false)

