RegisterServerCallback("vfw:license:getMugshot", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = VFW.GetIdentifier(source)
    local data = {}
    local slots = Database:GetPlayerSlots(identifier)
    identifier = Server.prefix .. "%:" .. identifier
    local rawCharacters = Database:GetPlayerInfo(identifier, slots)
    local characterCount = #rawCharacters
    local characters = table.create(characterCount, 0)
    for i = 1, characterCount do
        local v = rawCharacters[i]
         data = {
            mugshot = xPlayer.mugshot,
            firstname = v.firstname,
            lastname = v.lastname,
            date = v.dateofbirth,
        }
    end
    print("Mugshot data: ", json.encode(data))
    return data
end)
