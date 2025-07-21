local staffSubmenu = VFW.ContextAddSubmenu("object", "Action Staff", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end , {  color = {255, 64, 64}}, nil)

VFW.ContextAddInfo("object", "", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    return GetEntityArchetypeName(object)
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Dupliquer", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    local new = Target:DuplicateEntity(object)
    Target:MouveEntity(new)
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Déplacer", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    Target:MouveEntity(object)
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Copier le nom", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    TriggerEvent("addToCopy", GetEntityArchetypeName(object))
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Copier le hash", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    TriggerEvent("addToCopy", GetEntityModel(object))
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Copier l'entité", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    TriggerEvent("addToCopy", object)
end, {}, staffSubmenu)

local function formatNumber(num)
    return tonumber(string.format("%.2f", num))
end

VFW.ContextAddButton("object", "Copier la position", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    local pos = GetEntityCoords(object)
    local heading = GetEntityHeading(object)
    local posFinal = formatNumber(pos.x)..", "..formatNumber(pos.y)..", "..formatNumber(pos.z)..", "..formatNumber(heading)
    TriggerEvent("addToCopy", posFinal)
    VFW.ShowNotification({
        type = 'JAUNE',
        content = "Coordonées copiées : " .. pos
    })
end, {}, staffSubmenu)

VFW.ContextAddButton("object", "Suprimer", function(object)
    return DoesEntityExist(object) and VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(object)
    SetEntityAsMissionEntity(object, false, false)
    DeleteObject(object)
end, {  color = {255, 64, 64}}, staffSubmenu)
