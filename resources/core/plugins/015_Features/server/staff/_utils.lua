function VFW.RegisterCommand(name, callback, permission)
    RegisterCommand(name, function(source, args, ...)
        console.debug("test")
        local xPlayer = VFW.GetPlayerFromId(source)
        local playerGlobal = VFW.GetPlayerGlobalFromId(source)


        console.debug("Permissions ", json.encode(playerGlobal.permissions))
        if playerGlobal and playerGlobal.permissions[permission] then
            for i = 1, #args do
                if args[i] == "me" then
                    args[i] = VFW.GetPermId(xPlayer.source)
                end
            end

            callback(xPlayer, args, ...)  
        end
    end, false)
end

function VFW.StaffActionForAll(cb)
    if (cb == nil or type(cb) ~= "function") then
        return
    end

    local staff_list = VFW.GetPlayers()

    for i = 1, #staff_list do
        local staff_player_data = staff_list[i]

        if staff_player_data ~= nil then
            cb(staff_player_data)
        end
    end
end

function VFW.StaffActionForActive(cb)
    if (cb == nil or type(cb) ~= "function") then
        return
    end

    for i = 1, #VFW.staffMode do
        local staff_player_data = VFW.staffMode[i]

        if staff_player_data ~= nil then
            cb(staff_player_data)
        end
    end
end
