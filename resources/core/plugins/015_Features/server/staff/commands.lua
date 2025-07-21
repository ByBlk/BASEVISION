VFW.RegisterCommand("noclip", function(xPlayer)
    TriggerClientEvent("core:staff:noclip", xPlayer.source)
end, "noclip")

VFW.RegisterCommand("gestion", function(xPlayer)
    TriggerClientEvent("core:staff:gestion", xPlayer.source)
end, "gestion")

VFW.RegisterCommand("kill", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent("vfw:killPlayer")
end, "kill")

VFW.RegisterCommand("tp", function(xPlayer, args)
    xPlayer.setCoords(vec3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end, "tp")

VFW.RegisterCommand("tpm", function(xPlayer, args)
    xPlayer.triggerEvent("vfw:tpm")
end, "tp")

VFW.RegisterCommand("setjob", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then return end

    if not VFW.DoesJobExist(args[2], args[3]) then
        console.debug("Job not found")
        return
    end

    target.setJob(args[2], args[3])
end, "setjob")

local upgrades = Config.SpawnVehMaxUpgrades and {
    plate = "ADMINCAR",
    modEngine = 3,
    modBrakes = 2,
    modTransmission = 2,
    modSuspension = 3,
    modArmor = true,
    windowTint = 1,
} or {}

VFW.RegisterCommand("car", function(xPlayer, args)
    local playerPed = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)

    if not args[1] or type(args[1]) ~= "string" then
        args[1] = "adder"
    end

    if playerVehicle then
        DeleteEntity(playerVehicle)
    end

    local xRoutingBucket = GetPlayerRoutingBucket(xPlayer.source)

    VFW.OneSync.SpawnVehicle(args[1], playerCoords, playerHeading, upgrades, function(networkId)
        if networkId then
            local vehicle = NetworkGetEntityFromNetworkId(networkId)

            if xRoutingBucket ~= 0 then
                SetEntityRoutingBucket(vehicle, xRoutingBucket)
            end
            for _ = 1, 100 do
                Wait(5)
                SetPedIntoVehicle(playerPed, vehicle, -1)

                if GetVehiclePedIsIn(playerPed, false) == vehicle then
                    break
                end
            end

            if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
                console.debug("[^1ERROR^7] The player could not be seated in the vehicle")
            end
        end
    end)
end, "spawn_vehicle")

VFW.RegisterCommand("giveitem", function(xPlayer, args)
    if not args[1] or not args[2] or not args[3] then
        return console.debug("Usage: /giveitem [id] [item], [amount]")
    end

    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then return end

    local item = args[2]
    if not VFW.Items[item] then
        return console.debug("Item introuvable")
    end

    local amount = tonumber(args[3])
    if not amount then
        return console.debug("Amount invalide")
    end

    target.createItem(item, amount)
    target.updateInventory()
    -- Log Discord Give
    if logs and logs.gestion and logs.gestion.adminGive then
        logs.gestion.adminGive(xPlayer.source, target.getName(), item, amount)
    end
end, "give_item")

VFW.RegisterCommand("setfaction", function(xPlayer, args)
    if (not args[1]) or (not args[2]) then
        return console.debug("Usage: /setfaction [id] [crew]")
    end
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if (not target) then
        return
    end

    local name = args[2]
    if (not VFW.GetCrewByName(name)) then
        return console.debug("~g~Faction introuvable")
    end

    console.debug("Setting faction to " .. name .. " for player " .. target.getName())
    target.setFaction(name, (tonumber(args[3]) or 0))
end, "gestion_crew")

VFW.RegisterCommand("heal", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.setMeta("hunger", 100)
    target.setMeta("thirst", 100)
    target.setMeta("health", 200)
    target.triggerEvent("core:jobs:client:HealthPlayer", 200)
end, "heal")

VFW.RegisterCommand("revive", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent("vfw:revivePlayer")
    target.setMeta("hunger", 100)
    target.setMeta("thirst", 100)
    target.setMeta("health", 200)
end, "revive")

VFW.RegisterCommand("repair", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    local ped = GetPlayerPed(target.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
        return
    end

    target.triggerEvent("vfw:repairPedVehicle")
end, "repair")

VFW.RegisterCommand("dv", function(xPlayer, args)
    local ped = GetPlayerPed(xPlayer.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if DoesEntityExist(pedVehicle) then
        DeleteEntity(pedVehicle)
    end

    local coords = GetEntityCoords(ped)
    local Vehicles = VFW.OneSync.GetVehiclesInArea(coords, tonumber(args[1]) or 5.0)

    for i = 1, #Vehicles do
        local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
        if DoesEntityExist(Vehicle) then
            DeleteEntity(Vehicle)
        end
    end
end, "dv")

VFW.RegisterCommand('weather', function(xPlayer, args, debugLog)
    if xPlayer == nil then return end

    if args[1] and not VFW.IsBlacklisted(args[1]:upper()) then
        VFW.currentWeather = args[1]:upper()
        TriggerClientEvent("core:sync:setWeather", -1,  VFW.currentWeather)
    else
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Type de mÃ©tÃ©o invalide ou blacklist."
        })
    end
end, "weather")

VFW.RegisterCommand('time', function(xPlayer, args, debugLog)
    if xPlayer == nil then return end

    if args[1] and args[2] then
        local hour = tonumber(args[1])
        local minute = tonumber(args[2])

        if hour and minute and hour >= 0 and hour < 24 and minute >= 0 and minute < 60 then
            VFW.InGameHour = hour
            VFW.InGameMinute = minute

            VFW.LastUpdate = os.time()

            TriggerClientEvent("core:sync:setTime", -1, hour, minute)

            local igTotalMinutes = hour * 60 + minute
            local isNight = (igTotalMinutes >= 22 * 60 or igTotalMinutes < 7 * 60)

            local currentCycle = getCurrentCycle()
            if (currentCycle.type == "NIGHT" and not isNight) or (currentCycle.type == "DAY" and isNight) then
                xPlayer.showNotification({
                    type = 'ORANGE',
                    content = "Attention: l'heure définie ne correspond pas au cycle jour/nuit actuel"
                })
            end

            xPlayer.showNotification({
                type = 'VERT',
                content = ("Heure IG changée à %02d:%02d"):format(hour, minute)
            })
        else
            xPlayer.showNotification({
                type = 'ROUGE',
                content = "Veuillez entrer une heure (0-23) et une minute (0-59) valides."
            })
        end
    else
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Usage : /time <heure> <minute>"
        })
    end
end, "time")


VFW.RegisterCommand('freezeweather', function(xPlayer, args)
    VFW.DynamicWeather = not VFW.DynamicWeather
    if not VFW.DynamicWeather then
        xPlayer.showNotification({
            type = 'VERT',
            content = "Weather is now frozen."
        })
    else
        xPlayer.showNotification({
            type = 'VERT',
            content = "Weather is no longer frozen."
        })
    end
end, 'freezeweather')

VFW.RegisterCommand('freezetime', function(xPlayer, args)
    VFW.FreezeTime = not VFW.FreezeTime
    if VFW.FreezeTime then
        xPlayer.showNotification({
            type = 'VERT',
            content = "Time is now frozen."
        })
    else
        xPlayer.showNotification({
            type = 'VERT',
            content = "Time is no longer frozen."
        })
    end
end, 'freezetime')

VFW.RegisterCommand('gestionstock', function(xPlayer, args)
    xPlayer.triggerEvent("open:gestionstock")
end, 'gestionstock')

VFW.RegisterCommand('skin', function(xPlayer, args)
    xPlayer.triggerEvent("open:skin")
end, 'skin')

VFW.RegisterCommand("uncuff", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent('handcuff:client:setHandcuff', false)
    target.setMeta('cuffState', { isCuffed = false })
end, "uncuff")

VFW.RegisterCommand("creator", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent('core:client:spawnCharCreator')
end, "creator")

VFW.RegisterCommand("goto", function(xPlayer, args)
    local targetId = tonumber(args[1])
    if not targetId then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Usage: /goto [ID]"
        })
    end

    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(targetId))
    if not target then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Joueur introuvable"
        })
    end

    local targetCoords = target.getCoords()
    local srcDim = GetPlayerRoutingBucket(xPlayer.source)
    local targetDim = GetPlayerRoutingBucket(target.source)

    if srcDim ~= targetDim then
        SetPlayerRoutingBucket(xPlayer.source, targetDim)
    end

    xPlayer.setCoords(targetCoords)

    xPlayer.showNotification({
        type = 'VERT',
        content = ("Téléporté vers %s"):format(target.getName())
    })
end, "goto")

VFW.RegisterCommand("gotoVehicle", function(xPlayer, args)
    local vehicle = VFW.GetVehicleByPlate(args[1])
    if not vehicle then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Véhicule introuvable"
        })
        return
    end

    if vehicle.state == -1 then
        xPlayer.showNotification({
            type = 'JAUNE',
            content = "Véhicule dans le garage public"
        })
        return
    end

    if vehicle.state > 0 then
        xPlayer.showNotification({
            type = 'JAUNE',
            content = "Véhicule dans le garage privé (id:" .. vehicle.state .. ")"
        })
        return
    end

    local vehicleCoords = vehicle.getVehiclePos()
    if not vehicleCoords then
        xPlayer.showNotification({
            type = 'JAUNE',
            content = "Véhicule en fourière"
        })
        return
    end

    local srcDim = GetPlayerRoutingBucket(xPlayer.source)
    if srcDim ~= 0 then
        SetPlayerRoutingBucket(xPlayer.source, 0)
    end
    SetEntityCoords(GetPlayerPed(xPlayer.source), vehicleCoords)
    xPlayer.showNotification({
        type = 'JAUNE',
        content = "Téléporté vers le véhicule"
    })
end, "goto")

VFW.RegisterCommand("bring", function(xPlayer, args)
    local targetId = tonumber(args[1])
    if not targetId then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Usage: /bring [ID]"
        })
    end

    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(targetId))
    if not target then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Joueur introuvable"
        })
    end

    target.set("lastCoords", target.getCoords())

    local playerCoords = xPlayer.getCoords()
    local srcDim = GetPlayerRoutingBucket(xPlayer.source)
    local targetDim = GetPlayerRoutingBucket(target.source)

    if srcDim ~= targetDim then
        target.set("lastBucket", GetPlayerRoutingBucket(target.source))
        SetPlayerRoutingBucket(xPlayer.source, targetDim)
    end

    target.setCoords(playerCoords)

    xPlayer.showNotification({
        type = 'VERT',
        content = ("Vous avez fait venir %s"):format(target.getName())
    })

    target.showNotification({
        type = 'INFO',
        content = ("Vous avez été téléporté vers %s"):format(xPlayer.getName())
    })
end, "goto")

VFW.RegisterCommand("return", function(xPlayer, args)
    local targetId = tonumber(args[1])
    if not targetId then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Usage: /return [ID]"
        })
    end

    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(targetId))
    if not target then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Joueur introuvable"
        })
    end

    local lastCoords = target.get("lastCoords")
    if not lastCoords then
        return xPlayer.showNotification({
            type = 'ROUGE',
            content = "Aucune position précédente enregistrée"
        })
    end

    target.setCoords(lastCoords)
    local lastBucket = target.get("lastBucket")
    if lastBucket then
        SetPlayerRoutingBucket(target.source, lastBucket)
    end
    target.set("lastCoords", nil)
    target.set("lastBucket", nil)

    xPlayer.showNotification({
        type = 'VERT',
        content = ("Vous avez renvoyé %s à sa position précédente"):format(target.getName())
    })

    target.showNotification({
        type = 'INFO',
        content = "Vous avez été renvoyé à votre position précédente"
    })
end, "goto")

VFW.RegisterCommand("jail", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then return end
    local playerGlobal = VFW.GetPlayerGlobalFromId(xPlayer.source)
    local reason = tostring(args[2])
    local jailTime = tonumber(args[3])

    if jailTime > 360 then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Vous ne pouvez pas emprisonner quelqu'un pour plus de 6 heures."
        })
        return
    end

    TriggerEvent("jail:sendToJail", target.source, (jailTime * 60), reason, playerGlobal.pseudo)
    -- Log Discord Jail
    if logs and logs.gestion and logs.gestion.adminJail then
        logs.gestion.adminJail(xPlayer.source, target.getName(), reason, jailTime)
    end
end, "jail")

VFW.RegisterCommand("unjail", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then return end

    TriggerEvent("jail:releasePlayer", target.source)
    -- Log Discord Unjail
    if logs and logs.gestion and logs.gestion.adminUnjail then
        logs.gestion.adminUnjail(xPlayer.source, target.getName())
    end
end, "jail")

VFW.RegisterCommand("setped", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent('core:client:setped', args[2])
end, "setped")

VFW.RegisterCommand("unsetped", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    target.triggerEvent('core:client:unsetped')
end, "setped")

VFW.RegisterCommand("forceleaveproperty", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    local insideProperty = target.getMeta("insideProperty")
    if (not insideProperty) or (insideProperty == 0) then
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Le joueur n'est pas dans une propriété."
        })
        return
    end

    target.setMeta("insideProperty", 0)
    SetPlayerRoutingBucket(target.source, 0)
    local pos = json.decode(target.getMeta("lastOutside"))
    SetEntityCoords(GetPlayerPed(target.source), pos.x, pos.y, pos.z)
    xPlayer.showNotification({
        type = 'JAUNE',
        content = "Le joueur a été forcé de quitter la propriété."
    })
    target.showNotification({
        type = 'JAUNE',
        content = "Vous avez été forcé de quitter la propriété."
    })
end, "forceleaveproperty")

VFW.RegisterCommand("upgrade", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    local ped = GetPlayerPed(target.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
        return
    end

    target.triggerEvent("vfw:upgrade")
end, "upgrade")

VFW.RegisterCommand("setcarcolor", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then
        target = xPlayer
    end

    local ped = GetPlayerPed(target.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
        return
    end

    target.triggerEvent("vfw:setcarcolor", args[2], args[3])
end, "setcarcolor")

VFW.RegisterCommand("wipe", function(xPlayer, args)
    local target = VFW.GetPlayerFromId(VFW.GetSourceFromId(args[1]))
    if not target then return end
    -- Log Discord Wipe
    if logs and logs.gestion and logs.gestion.adminWipe then
        logs.gestion.adminWipe(xPlayer.source, target.getName())
    end
    -- ... (le reste du code de wipe)
end, "wipe")
