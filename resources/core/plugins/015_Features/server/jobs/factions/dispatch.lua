RegisterServerEvent("core:createDispatchCallOnMDT")
AddEventHandler("core:createDispatchCallOnMDT", function(service, title, pos)
    local source = source
    local place = TriggerClientCallback(source, "core:getStreetName", pos)
end)
