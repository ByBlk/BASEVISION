VFW.ContextAddButton("object", "Ajuster", function(object)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(object), true)
    return distance < 2.75 and DoesEntityExist(object)
end, function(object)

end, {})
