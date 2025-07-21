local allowedModels = {
    [joaat("strykerpro")] = true,
}

local brancardSubMenu = VFW.ContextAddSubmenu("vehicle", "Brancard", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end , {})

VFW.ContextAddButton("vehicle", "Tête-repos", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75 and (VFW.PlayerData.job.name == "sams" or VFW.PlayerData.job.name == "lsfd") and VFW.PlayerData.job.onDuty
end, function(vehicle)
    TriggerEvent("ToggleHeadrest")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Plan dur", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75 and (VFW.PlayerData.job.name == "sams" or VFW.PlayerData.job.name == "lsfd") and VFW.PlayerData.job.onDuty
end, function(vehicle)
    TriggerEvent("ToggleBackboard")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Moniteur", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75 and (VFW.PlayerData.job.name == "sams" or VFW.PlayerData.job.name == "lsfd") and VFW.PlayerData.job.onDuty
end, function(vehicle)
    TriggerEvent("ToggleMonitor")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Sac rouge", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75 and (VFW.PlayerData.job.name == "sams" or VFW.PlayerData.job.name == "lsfd") and VFW.PlayerData.job.onDuty
end, function(vehicle)
    TriggerEvent("ToggleRedBag")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Sac bleu", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75 and (VFW.PlayerData.job.name == "sams" or VFW.PlayerData.job.name == "lsfd") and VFW.PlayerData.job.onDuty
end, function(vehicle)
    TriggerEvent("ToggleBlueBag")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Se lever", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherGetUp")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "Recevoir RCR", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherReceiveCPR")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir à droite", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitRight")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir à gauche", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitRight")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir à gauche", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitLeft")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir au bout", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitEnd")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir droit", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitUpright")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir jambes croisées", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitUprightLegsCrossed")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir genoux repliés", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherSitUprightKneesTucked")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'allonger sur le côté gauche", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherLieBack")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'allonger à plat ventre", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherLieProne")
end, {}, brancardSubMenu)

VFW.ContextAddButton("vehicle", "S'asseoir allongé", function(vehicle)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(vehicle), true)
    return DoesEntityExist(vehicle) and allowedModels[GetEntityModel(vehicle)] and distance < 2.75
end, function(vehicle)
    TriggerEvent("StretcherLieUpright")
end, {}, brancardSubMenu)
