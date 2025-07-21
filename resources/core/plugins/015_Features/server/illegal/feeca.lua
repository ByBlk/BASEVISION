RegisterNetEvent("core:DisableGrabFleeca")
AddEventHandler("core:DisableGrabFleeca", function(key, info)
    TriggerClientEvent("core:DisableGrabFleeca", -1 , key, info)
end)

RegisterNetEvent("core:FleecaDone")
AddEventHandler("core:FleecaDone", function(key)
    TriggerClientEvent("core:FleecaDone", -1 , key)
end)

RegisterNetEvent("core:LockDoorFleecaSync")
AddEventHandler("core:LockDoorFleecaSync", function(data, bool)
    TriggerClientEvent("core:LockDoorFleecaSync", -1 ,data, bool)
end)

RegisterNetEvent("core:OpenTheFleecaDoor")
AddEventHandler("core:OpenTheFleecaDoor", function(pos, hash)
    TriggerClientEvent("core:OpenTheFleecaDoor", -1 ,pos, hash)
end)

RegisterNetEvent("core:HackSuccess")
AddEventHandler("core:HackSuccess", function(key, bool)
    TriggerClientEvent("core:HackSuccess", -1 ,key, bool)
end)

RegisterNetEvent("core:IpHacking")
AddEventHandler("core:IpHacking", function(key, bool)
    TriggerClientEvent("core:IpHacking", -1 ,key, bool)
end)

RegisterNetEvent("core:StartBoucleGrab")
AddEventHandler("core:StartBoucleGrab", function(data, cam, door, key)
    TriggerClientEvent("core:StartBoucleGrab", -1 ,data, cam, door, key)
end)
