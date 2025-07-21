RegisterNetEvent("vfw:blips:create", function(data)
    local source = source
    local blip = data.blip 

    console.debug(json.encode(data, { indent = true }))

    TriggerClientEvent("vfw:blips:create", -1, data)

end)