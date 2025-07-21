local playerAlreadyDid = {}
local playerAlreadyDidM = {}

RegisterNetEvent("gofast:firstSms")
AddEventHandler("gofast:firstSms", function(pos)
    local source = source
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("687-6543", pPhone, "Tiens récupère le véhicule les clés sont dedans je t'enverrais les instructions une fois le véhicule récuperé.", nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
end)

RegisterNetEvent("gofast:secondSms")
AddEventHandler("gofast:secondSms", function(pos)
    local source = source
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("687-6543", pPhone, "La cargaison est située a l'endroit que je t'envoie, n'oublie rien sinon tu le regretteras.", nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
end)

RegisterNetEvent("gofast:thirdSms")
AddEventHandler("gofast:thirdSms", function(pos)
    local source = source
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("687-6543", pPhone, "On m'a informé que tu as pu récuperer la cargaison je t'attends.", nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
end)

RegisterNetEvent("gofast:paySms")
AddEventHandler("gofast:paySms", function(pos)
    local source = source
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("687-6543", pPhone, "Merci de ton aide, ton argent t'attends là-bas, gare la voiture, prends ton argent et tires toi !", nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
end)

RegisterNetEvent("gofast:deleteconvo")
AddEventHandler("gofast:deleteconvo", function()
    --local source = source
    --local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    --local channelId = MySQL.Sync.fetchScalar([[SELECT c.channel_id FROM phone_message_channels c WHERE c.is_group = 0 AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @from) AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @to)]], {
    --    ["@from"] = "687-6543",
    --    ["@to"] = pPhone
    --})
    --
    --MySQL.Async.execute("DELETE FROM phone_message_messages WHERE channel_id = @channel", {
    --    ["@channel"] = channelId
    --})
    --MySQL.Async.execute("DELETE FROM phone_message_channels WHERE channel_id = @channel", {
    --    ["@channel"] = channelId
    --})
end)

local items = {}

RegisterNetEvent("gofast:addItemTrunk")
AddEventHandler("gofast:addItemTrunk", function(plate)
    if not items[plate] then
        items[plate] = 0
    end

    items[plate] = items[plate] + 1
end)

RegisterNetEvent("gofast:removeItemTrunk")
AddEventHandler("gofast:removeItemTrunk", function(plate)
    if not items[plate] then
        items[plate] = 0
    end

    if items[plate] > 0 then
        items[plate] = items[plate] - 1
    end
end)

RegisterServerCallback("core:GetNumber", function(source)
    return exports["lb-phone"]:GetEquippedPhoneNumber(source)
end)

RegisterServerCallback("gofast:AlreadyDidGoFast1", function(source)
    if playerAlreadyDid[source] then
        return false
    end

    playerAlreadyDid[source] = true

    return true
end)

RegisterServerCallback("gofast:AlreadyDidGoFast2", function(source)
    if playerAlreadyDidM[source] then
        return false
    end

    playerAlreadyDidM[source] = true

    return true
end)

RegisterNetEvent("gofast:spawnVehicle")
AddEventHandler("gofast:spawnVehicle", function(model, pos, heading)
    local src = source
    local veh = CreateVehicle(model, pos.x, pos.y, pos.z, heading, true, true)
    local vID = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleNumberPlateText(veh, "GOFAST")
    TriggerClientEvent("gofast:vehicleSpawned", src, vID)
end)

RegisterNetEvent("gofast:vehicleSpawned")
AddEventHandler("gofast:vehicleSpawned", function(vID)
    veh = NetworkGetEntityFromNetworkId(vID)
end)
