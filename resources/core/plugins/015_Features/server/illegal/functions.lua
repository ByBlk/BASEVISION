local limitIllegals = {}

local function addToLimitIllegal(name)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    local identifier = player.getIdentifier()
    if (not limitIllegals[name]) then limitIllegals[name] = {} end
    if not limitIllegals[name][identifier] then
        limitIllegals[name][identifier] = 1
    else
        limitIllegals[name][identifier] += 1
    end
end

RegisterNetEvent("core:illegal:addlimit", addToLimitIllegal)

RegisterServerCallback("core:illegal:getlimit", function(source, name)
    local player = VFW.GetPlayerFromId(source)
    local identifier = player.getIdentifier()
    if not limitIllegals[name] then 
        return 0
    end
    return limitIllegals[name][identifier]
end)