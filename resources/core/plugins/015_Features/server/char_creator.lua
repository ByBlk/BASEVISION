RegisterNetEvent("core:server:instanceCreator", function(type)
    if type then
        SetPlayerRoutingBucket(source, source)
    else
        SetPlayerRoutingBucket(source, 0)
    end
end)

local function GetIdentifier(playerId)
    playerId = tostring(playerId)

    local identifier = GetPlayerIdentifierByType(playerId, "license")
    return identifier and identifier:gsub("license:", "")
end

RegisterServerCallback("core:server:characterCreator", function(source)
    return {}
end)

RegisterNetEvent("core:server:createIdentity", function(data)
    local source = source

    TriggerEvent("creator:completedRegistration", source, data)

    local function capitalize(str)
        return (str:gsub("^%l", string.upper))
    end

    local mdtParams = {
        identifier = VFW.GetIdentifier(source),
        name = capitalize(data.firstname) .. " " .. string.upper(data.lastname) .. " ("..data.sex..")",
        birthdate = data.dateofbirth,
    }
end)


RegisterNetEvent("core:server:startCreator", function()
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)

    if not xPlayer then return end

    local skin = xPlayer.skin

    if not skin then return end

    xPlayer.addItem("top", 1, {
        renamed = skin.torso_1,
        sex = skin.sex == 1 and "w" or "m",
        skin = {
            ["tshirt_1"] = skin.tshirt_1,
            ["tshirt_2"] = skin.tshirt_2,
            ["torso_1"] = skin.torso_1,
            ["torso_2"] = skin.torso_2,
            ["arms"] = skin.arms,
        }
    })
    xPlayer.addItem("bottom", 1, {
        renamed = skin.pants_1,
        sex = skin.sex == 1 and "w" or "m",
        id = skin.pants_1,
        var = skin.pants_2
    })
    xPlayer.addItem("shoe", 1, {
        renamed = skin.shoes_1,
        sex = skin.sex == 1 and "w" or "m",
        id = skin.shoes_1,
        var = skin.shoes_2
    })
    xPlayer.addItem("accessory", 1, {
        renamed = skin.chain_1,
        type = "necklace",
        sex = skin.sex == 1 and "w" or "m",
        id = skin.chain_1,
        var = skin.chain_2
    })
    xPlayer.addItem("bag", 1, {
        renamed = skin.bags_1,
        sex = skin.sex == 1 and "w" or "m",
        id = skin.bags_1,
        var = skin.bags_2
    })
    xPlayer.addItem("accessory", 1, {
        renamed = skin.glasses_1,
        type = "glasses",
        sex = skin.sex == 1 and "w" or "m",
        id = skin.glasses_1,
        var = skin.glasses_2
    })
    xPlayer.addItem("accessory", 1, {
        renamed = skin.helmet_1,
        type = "hat",
        sex = skin.sex == 1 and "w" or "m",
        id = skin.helmet_1,
        var = skin.helmet_2
    })
    xPlayer.addItem("accessory", 1, {
        renamed = skin.bags_1,
        type = "bag",
        sex = skin.sex == 1 and "w" or "m",
        id = skin.bags_1,
        var = skin.bags_2
    })

    xPlayer.createItem("phone", 1)
    xPlayer.createItem("bread", 5)
    xPlayer.createItem("water", 5)
    xPlayer.createItem("gps", 1)

    xPlayer.addMoney(1000)
end)
