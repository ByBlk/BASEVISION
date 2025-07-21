Multicharacter = {}
Multicharacter._index = Multicharacter
Multicharacter.awaitingRegistration = {}

function Multicharacter:SetupCharacters(source)
    SetPlayerRoutingBucket(source, source)
    while not Database.connected do
        Wait(100)
    end

    local identifier = VFW.GetIdentifier(source)

    local slots = Database:GetPlayerSlots(identifier)
    identifier = Server.prefix .. "%:" .. identifier

    local rawCharacters = Database:GetPlayerInfo(identifier, slots)
    local characters

    if rawCharacters then
        local characterCount = #rawCharacters
        characters = table.create(0, characterCount)

        for i = 1, characterCount, 1 do
            local v = rawCharacters[i]
            local job, grade_job = v.job or "unemployed", tostring(v.job_grade)

            if VFW.Jobs[job] and VFW.Jobs[job].grades[grade_job] then
                if job ~= "unemployed" then
                    grade_job = VFW.Jobs[job].grades[grade_job].label
                else
                    grade_job = ""
                end
                job = VFW.Jobs[job].label
            end

            local faction, grade_faction = v.faction or "nofaction", tostring(v.faction_grade)

            if VFW.Factions[faction] and VFW.Factions[faction].grades[grade_faction] then
                if faction ~= "nofaction" then
                    grade_faction = VFW.Factions[faction].grades[grade_faction].label
                else
                    grade_faction = ""
                end
                faction = VFW.Factions[faction].label
            end

            local idString = string.sub(v.identifier, #Server.prefix + 1, string.find(v.identifier, ":") - 1)
            local id = tonumber(idString)
            if id then
                characters[id] = {
                    id = id,
                    info = v.id,
                    firstname = v.firstname,
                    lastname = v.lastname,
                    dateofbirth = v.dateofbirth,
                    skin = v.skin and json.decode(v.skin) or {},
                    disabled = v.disabled,
                    sex = v.sex == "m" and "male" or "female",
                    mugshot = v.mugshot,
                    tattoos = v.tattoos and json.decode(v.tattoos) or {}
                }
            end
        end
    end

    TriggerClientEvent("vfw:multicharacter:SetupUI", source, characters, slots)
end

function Multicharacter:CharacterChosen(source, charid, isNew)
    if type(charid) ~= "number" or string.len(charid) > 2 or type(isNew) ~= "boolean" then
        return
    end

    if isNew then
        self.awaitingRegistration[source] = charid
    else
        SetPlayerRoutingBucket(source, 0)
        if not Config.EnableDebug then
            local identifier = ("%s%s:%s"):format(Server.prefix, charid, VFW.GetIdentifier(source))

            if VFW.GetPlayerFromIdentifier(identifier) then
                DropPlayer(source, "[VFW Multicharacter] Your identifier " .. identifier .. " is already on the server!")
                return
            end
        end
        console.debug("[VFW Multicharacter] Player %s has chosen character %s", source, charid)
        TriggerEvent("vfw:onPlayerConnect", source, ("%s%s"):format(Server.prefix, charid))
    end
end

function Multicharacter:RegistrationComplete(source, data)
    local charId = self.awaitingRegistration[source]
    self.awaitingRegistration[source] = nil

    SetPlayerRoutingBucket(source, 0)
    TriggerEvent("vfw:onPlayerConnect", source, ("%s%s"):format(Server.prefix, charId), data)
end

function Multicharacter:PlayerDropped(player)
    self.awaitingRegistration[player] = nil
end
