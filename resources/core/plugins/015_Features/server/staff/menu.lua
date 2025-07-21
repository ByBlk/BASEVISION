local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function timeFormatToSeconds(time)
    local timeParts = split(time, ':')
    local hours = tonumber(timeParts[1])
    local minutes = tonumber(timeParts[2])
    local seconds = tonumber(timeParts[3])
    return (hours * 3600) + (minutes * 60) + seconds
end

local function minifyPlayer(source, player)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    local target = VFW.GetPlayerFromId(source)

    local premium = "Non"
    if playerGlobal.permissions["premiumplus"] then
        premium = "Plus"
    elseif playerGlobal.permissions["premium"] then
        premium = "Oui"
    end

    local crew = "Aucun"
    if target.getFaction().label ~= "nocrew" then
        crew = target.getFaction().label
    end

    local color = nil
    if playerGlobal and playerGlobal.permissions["staff_menu"] then
        color = VFW.GetPermissionColor(source)
    end

    return {
        id = VFW.GetPermId(source) or 0,
        source = source or 0,
        pseudo = playerGlobal.pseudo or "Aucun",
        name = player.getName() or "Aucun",
        color = color,
        job = target.getJob().label or "Aucun",
        grade = target.getJob().grade or "Aucun",
        crew = crew or "Aucun",
        crewGrade = target.getFaction().grade or "Aucun",
        money = target.getMoney() or 0,
        bank = target.getAccount("bank").money or 0,
        vcoins = 0, --@todo
        premium = premium,
        time = VFW.GetPlayerTime(source),
        new = timeFormatToSeconds(VFW.GetPlayerTime(source)) < 3600 * 5,
        mugshot = target.mugshot or "",
    }
end

RegisterServerCallback("vfw:staff:getPlayerList", function(src)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local players = {}

    for k, v in pairs(VFW.Players) do
        players[k] = minifyPlayer(k, v)
    end

    return players
end)

RegisterServerCallback("vfw:staff:getPlayerInfo", function(src, player)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local targetGlobal = VFW.GetPlayerGlobalFromId(player)
    if not targetGlobal then
        return
    end

    local target = VFW.GetPlayerFromId(player)
    if not target then
        return
    end

    local premium = "Non"
    if targetGlobal.permissions["premiumplus"] then
        premium = "Plus"
    elseif targetGlobal.permissions["premium"] then
        premium = "Oui"
    end

    local crew = "Aucun"
    if target.getFaction().label ~= "nocrew" then
        crew = target.getFaction().label
    end

    local color = nil
    if targetGlobal and targetGlobal.permissions["staff_menu"] then
        color = VFW.GetPermissionColor(player)
    end

    return {
        id = VFW.GetPermId(player) or 0,
        source = player or 0,
        discord =  VFW.GetIdentifier(player) or "Aucun",
        name = targetGlobal.pseudo or "Aucun",
        color = color,
        job = target.getJob().label or "Aucun",
        grade = target.getJob().grade or "Aucun",
        crew = crew or "Aucun",
        crewGrade = target.getFaction().grade or "Aucun",
        money = target.getMoney() or 0,
        bank = target.getAccount("bank").money or 0,
        vcoins = 0, --@todo
        premium = premium or "Aucun",
        time = VFW.GetPlayerTime(player),
        mugshot = target.mugshot or "",
    }
end)

RegisterServerCallback("vfw:staff:getJobs", function(src)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    return VFW.Jobs
end)

RegisterServerCallback("vfw:staff:getCharList", function(src, target)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        console.debug("vfw:staff:getCharList: xPlayer not found")
        return
    end

    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        console.debug("vfw:staff:getCharList: target not found")
        return
    end

    local targetGlobal = VFW.GetPlayerGlobalFromId(target)
    if not targetGlobal then
        return
    end

    local id = VFW.GetIdentifier(target)
    local result = MySQL.query.await("SELECT id, firstname, lastname, job, job_grade, faction, faction_grade, accounts, mugshot, inventory FROM users WHERE identifier LIKE ?", { "%"..id })

    local charList = {}

    local premium = "Non"
    if targetGlobal.permissions["premiumplus"] then
        premium = "Plus"
    elseif targetGlobal.permissions["premium"] then
        premium = "Oui"
    end

    for i = 1, #result do
        local crew = "Aucun"
        if result[i].faction ~= "nocrew" then
            crew = result[i].faction
        end

        local inventory = json.decode(result[i].inventory)
        local moneyCount = 0

        for _, item in ipairs(inventory) do
            if item.name == "money" then
                moneyCount = item.count
                break
            end
        end

        local accounts = json.decode(result[i].accounts)
        local bankCount = 0

        if accounts and accounts.bank then
            bankCount = json.decode(accounts.bank)
        end

        charList[i] = {
            id = result[i].id,
            name = ("%s %s"):format(result[i].firstname, result[i].lastname),
            pseudo = targetGlobal.pseudo,
            actual = (xTarget.id == result[i].id),
            color = VFW.GetPermissionColor(target) or 0,
            job = result[i].job or "Aucun",
            grade = result[i].job_grade or "Aucun",
            crew = crew or "Aucun",
            crewGrade = result[i].faction_grade or "Aucun",
            money = moneyCount or 0,
            bank = bankCount or 0,
            vcoins = 0, --@todo
            premium = premium or "Aucun",
            time = VFW.GetPlayerTime(target),
            mugshot = result[i].mugshot or "",
        }
    end

    return { charList = charList, pseudo = targetGlobal.pseudo }
end)

RegisterNetEvent("vfw:staff:wipePlayer", function(target, charId)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["wipe"] then
        return
    end

    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        return
    end

    MySQL.query("DELETE FROM users WHERE id = ?", { charId })
    -- @todo: wipe other data

    if xTarget.id == charId then
        TriggerEvent("vfw:playerLogout", xTarget.playerId)
    end
end)

RegisterNetEvent("core:vnotif:createAlert:global", function(message)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    TriggerClientEvent("core:vnotif:createAlert", -1, message, nil)
end)

RegisterNetEvent("core:vnotif:createAlert:staff", function(message)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    VFW.StaffActionForAll(function(staff_player_source)
        TriggerClientEvent("core:vnotif:createAlert", staff_player_source, message, "alert_logo_red.png")
    end)
end)

RegisterNetEvent("core:vnotif:createAlert:player")
AddEventHandler("core:vnotif:createAlert:player", function(message, playerId)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end
    local xTarger = VFW.GetPlayerFromId(playerId)
    if not xTarger then return end

    xTarger.triggerEvent("core:vnotif:createAlert", message, "alert_logo_red.png")
end)

RegisterServerCallback("core:CoordsOfPlayer", function(source, idSelect)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    return GetEntityCoords(GetPlayerPed(idSelect))
end)

RegisterNetEvent("core:StaffSpectate", function(id, status)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then return end
    local target = VFW.GetPlayerFromId(id)
    if not target then return end
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if status then
        local targetCoords = target.getCoords()
        local srcDim = GetPlayerRoutingBucket(source)
        local targetDim = GetPlayerRoutingBucket(target.source)

        if srcDim ~= targetDim then
            xPlayer.set("lastBucket", GetPlayerRoutingBucket(source))
            SetPlayerRoutingBucket(source, targetDim)
        end
        xPlayer.set("lastCoords", xPlayer.getCoords())
        TriggerClientEvent("core:StaffSpectate", source, targetCoords, tonumber(id), true)
    else
        local lastCoords = xPlayer.get("lastCoords")
        local lastBucket = target.get("lastBucket")

        if lastBucket then
            SetPlayerRoutingBucket(target.source, lastBucket)
        end
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent("core:StaffSpectate", source, lastCoords, tonumber(id), false)
        xPlayer.set("lastCoords", nil)
        xPlayer.set("lastBucket", nil)
    end
end)

RegisterNetEvent("core:FreezePlayer", function(id, staut)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    TriggerClientEvent("core:FreezePlayer", tonumber(id), staut)
end)

RegisterNetEvent("core:KickPlayer", function(id, reason)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    DropPlayer(tonumber(id), "Kick: "..reason)
    -- Log Discord Kick
    if logs and logs.gestion and logs.gestion.adminKick then
        logs.gestion.adminKick(source, id, reason)
    end
end)

RegisterNetEvent("core:sendToJail", function(id, jailTime, reason)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    TriggerEvent("jail:sendToJail", id, (jailTime * 60), reason, playerGlobal.pseudo)
end)

local function minifyStaff(player)
    local playerGlobal = VFW.GetPlayerGlobalFromId(player.source)

    return {
        source = player.playerId,
        pseudo = playerGlobal.pseudo,
        name = player.getName(),
        color = VFW.GetPermissionColor(player.source) or 0,
        grade = VFW.GetPermissionLabel(player.source) or "Aucun",
    }
end

RegisterServerCallback("vfw:staff:getStaffList", function(src)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local players = {}

    for k, v in pairs(VFW.Players) do
        local targetGlobal = VFW.GetPlayerGlobalFromId(v.source)

        if targetGlobal and targetGlobal.permissions["staff_menu"] then
            players[k] = minifyStaff(v)
        end
    end

    return players
end)

RegisterServerCallback("core:staff:getOrganizations", function(src)
    local orga = {}

    for k, v in pairs(VFW.Gestion.Organizations) do
        if v.state then
            orga[k] = v.data()
        end
    end

    return orga
end)

RegisterNetEvent("vfw:staff:impound", function(target, plate, pound)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        return
    end

    local vehicle = VFW.GetVehicleByPlate(plate)
    if not vehicle then
        return
    end

    if pound then
        vehicle.changeState(1)
        vehicle.dispawnVehicle()
    else
        vehicle.changeState(0)
        vehicle.spawnVehicle(GetEntityCoords(GetPlayerPed(target)))
        Wait(75)
        TaskWarpPedIntoVehicle(GetPlayerPed(target), NetworkGetEntityFromNetworkId(vehicle.vehicle), -1)
    end
end)

RegisterNetEvent("vfw:staff:setComponent", function(weaponComponent)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.setComponent(weaponComponent)
    xPlayer.updateInventory()
end)

RegisterNetEvent("vfw:staff:setTint", function(weaponTint)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.setTint(weaponTint)
    xPlayer.updateInventory()
end)

RegisterServerCallback("vfw:staff:getSkin", function(source, targetId)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    local xTarget = VFW.GetPlayerFromId(targetId)
    if not xTarget then return end

    return xTarget.skin
end)

local placedPropsEvent =  {}

RegisterNetEvent("vfw:staff:saveObject", function(object)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    placedPropsEvent[object.geneartedId] = {
        name = object.name,
        id = object.id,
    }
end)

RegisterServerCallback("vfw:staff:getObject", function(src)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    return placedPropsEvent
end)

RegisterNetEvent("vfw:staff:deleteObject", function(object)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end

    placedPropsEvent[object] = nil
end)
