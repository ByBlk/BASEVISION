VFW.RegisterUsableItem("phone", function(xPlayer, _, metaData)
    if metaData.lbFormattedNumber then
        xPlayer.showNotification({
            type = 'VERT',
            content = "Téléphone Actif : " .. metaData.lbFormattedNumber,
        })
    end
    TriggerClientEvent("lb-phone:usePhoneItem", xPlayer.source, metaData)
end)

exports("GetPlayerPhones", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    return xPlayer.getPhones()
end)

exports("SetPhoneNumber", function(source, phone, info)
    local xPlayer = VFW.GetPlayerFromId(source)
    
    local newMeta = phone.meta
    newMeta.lbPhoneNumber = info.lbPhoneNumber
    newMeta.lbFormattedNumber = info.lbFormattedNumber
    newMeta.renamed = info.lbFormattedNumber

    xPlayer.registerPhone(phone.position, newMeta)
end)

VFW.RegisterUsableItem("tablet", function(xPlayer, _, _)
    TriggerClientEvent("vfw:openTablet", xPlayer.source)
end)