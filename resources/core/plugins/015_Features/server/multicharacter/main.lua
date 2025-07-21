Server = {}
Server._index = Server

Server.oneSync = GetConvar("onesync", "off")
Server.slots = Config.Multicharacter.Slots or 4
Server.prefix = Config.Multicharacter.Prefix or "char"

RegisterNetEvent("vfw:multicharacter:SetupCharacters", function()
    local source = source
    Multicharacter:SetupCharacters(source)
end)

RegisterNetEvent("vfw:multicharacter:CharacterChosen", function(charid, isNew)
    local source = source
    Multicharacter:CharacterChosen(source, charid, isNew)
end)

AddEventHandler("creator:completedRegistration", function(source, data)
    Multicharacter:RegistrationComplete(source, data)
end)

AddEventHandler("playerDropped", function()
    local source = source
    Multicharacter:PlayerDropped(source)
end)

RegisterNetEvent("vfw:multicharacter:DeleteCharacter", function(charid)
    if not Config.Multicharacter.CanDelete or type(charid) ~= "number" or string.len(charid) > 2 then
        return
    end
    local source = source
    Database:DeleteCharacter(source, charid)
end)

RegisterNetEvent("vfw:multicharacter:relog", function()
    local source = source
    TriggerEvent("vfw:playerLogout", source)
end)
