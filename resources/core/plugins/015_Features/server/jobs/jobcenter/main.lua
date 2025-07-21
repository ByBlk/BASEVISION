RegisterNetEvent("core:server:instanceJobCenter")
AddEventHandler("core:server:instanceJobCenter", function(bool)
    -- local _source = source

    if bool then 
        -- SetPlayerRoutingBucket(_source, math.random(0, 65535))
        VFW.FreezeTime = false
    else
        -- SetPlayerRoutingBucket(_source, 0)
        VFW.FreezeTime = true
        TriggerClientEvent("core:sync:setTime", source, VFW.InGameHour, VFW.InGameMinute)
    end
end)
