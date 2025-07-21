local staffSubmenu = VFW.ContextAddSubmenu("ped", "Action Staff", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, {color = {255, 64, 64}}, nil)

VFW.ContextAddInfo("ped", "", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    return GetEntityArchetypeName(ped)
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Dupliquer", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    local new = Target:DuplicateEntity(ped)
    Target:MouveEntity(new)
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Déplacer", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    Target:MouveEntity(ped)
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Copier le nom", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    TriggerEvent("addToCopy", GetEntityArchetypeName(ped))
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Copier le hash", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    TriggerEvent("addToCopy", GetEntityModel(ped))
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Copier l'entité", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    TriggerEvent("addToCopy", ped)
end, {}, staffSubmenu)

local function formatNumber(num)
    return tonumber(string.format("%.2f", num))
end

VFW.ContextAddButton("ped", "Copier la position", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    local pos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local posFinal = formatNumber(pos.x)..", "..formatNumber(pos.y)..", "..formatNumber(pos.z)..", "..formatNumber(heading)
    TriggerEvent("addToCopy", posFinal)
    VFW.ShowNotification({
        type = 'JAUNE',
        content = "Coordonées copiées : " .. pos
    })
end, {}, staffSubmenu)

VFW.ContextAddButton("ped", "Suprimer", function(ped)
    return DoesEntityExist(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and not IsPedAPlayer(ped)
end, function(ped)
    SetEntityAsMissionEntity(ped, false, false)
    DeleteObject(ped)
end, {color = {255, 64, 64}}, staffSubmenu)
