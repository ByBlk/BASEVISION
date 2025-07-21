local staffSubmenu = VFW.ContextAddSubmenu("world", "Action Staff", function()
    return VFW.PlayerGlobalData.permissions["contextmenu"]
end , {  color = {255, 64, 64}}, nil)

VFW.ContextAddButton("world", "Heal zone", function()
    return VFW.PlayerGlobalData.permissions["contextmenu"]
end, function(_, worldPosition)
    VFW.TreatZone(75, vector3(worldPosition.x, worldPosition.y, worldPosition.z))
end, {}, staffSubmenu)
