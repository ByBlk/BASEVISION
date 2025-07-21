VFW.Properties = {}
VFW.ActualProperty = nil
function VFW.EnterProperty(id)
    local property = TriggerServerCallback("vfw:getProperty", id)
    if not property then
        console.debug("Property not found")
        return
    end

    VFW.ActualProperty = id
    Worlds.Zone.HideInteract(false)
    VFW.OpenUIProperty(property)
end

local function createPoint(id, pos)
    VFW.Properties[id] = Worlds.Zone.Create(pos, 1, false, function()
        console.debug("Entering property interaction zone "..id)
        
        VFW.RegisterInteraction(("property:%s"):format(id), function()
            VFW.EnterProperty(id)
        end)
    end, function()
        console.debug("Exiting property interaction zone "..id)

        VFW.RemoveInteraction(("property:%s"):format(id))
    end, "Propriété", "E", "Sonnette")
end

RegisterNetEvent("vfw:loadProperty", createPoint)
RegisterNetEvent("vfw:loadProperties", function(properties)
    for k, v in pairs(properties) do
        createPoint(k, v)
    end
end)

RegisterNetEvent("vfw:deleteProperty", function(id)
    Worlds.Zone.Remove(VFW.Properties[id])
    VFW.Properties[id] = nil
end)