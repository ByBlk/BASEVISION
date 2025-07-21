local properties = {}

function VFW.LoadProperty(id, typeProperty, owner, name, access, pos, data, rental)
    properties[id] = VFW.CreatePropertyClass(id, typeProperty, owner, name, access, pos, data, rental)
    TriggerClientEvent("vfw:loadProperty", -1, id, pos)
    return properties[id]
end

function VFW.InitProperty()
    local result = MySQL.Sync.fetchAll("SELECT * FROM `property`")
    for i = 1, #result do
        local pos = json.decode(result[i].pos)
        if pos then
            VFW.LoadProperty(result[i].id, result[i].type, result[i].owner, result[i].name, json.decode(result[i].access), vec3(pos.x, pos.y, pos.z), json.decode(result[i].data), result[i].rental)
        end
    end
    
    CreateThread(function()
        while true do
            Wait(6000)
            for k, v in pairs(properties) do
                if (v.rental ~= 0) and (v.rental < os.time()) then
                    --@todo: Logs les fin de location
                    console.debug("Property "..k.." is now available")
                    properties[k].owner = ""
                    properties[k].rental = 0
                    MySQL.Sync.execute("UPDATE `property` SET owner = '', rental = 0 WHERE id = @id", {["@id"] = k})
                end
            end
        end
    end)
end

function VFW.GetProperty(id)
    return properties[id]
end

function VFW.GetProperties()
    return properties
end

function VFW.CreateProperty(typeProperty, owner, name, access, pos, data, rental)
    console.debug("Create property executed")
    local id = MySQL.Sync.insert("INSERT INTO `property` (type, owner, name, access, pos, data, rental) VALUES (?, ?, ?, ?, ?, ?, ?)", {
        typeProperty, owner, name, json.encode(access), json.encode(pos), json.encode(data), rental
    })

    return VFW.LoadProperty(id, typeProperty, owner, name, access, pos, data, rental)
end

function VFW.ClientGetProperties()
    local list = {}

    for k, v in pairs(properties) do
        list[k] = v.pos
    end

    return list
end

function VFW.DeleteProperty(id)
    if not properties[id] then
        return
    end
    MySQL.Sync.execute("DELETE FROM `property` WHERE id = @id", {["@id"] = id})
    TriggerClientEvent("vfw:deleteProperty", -1, id)
    properties[id] = nil
end