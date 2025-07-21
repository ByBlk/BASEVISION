local oneSyncState = GetConvar("onesync", "off")
local newPlayer = "INSERT INTO `users` SET `accounts` = ?, `identifier` = ?"
local loadPlayer = "SELECT `id`, `accounts`, `job`, `job_grade`, `faction`, `faction_grade`, `position`, `inventory`, `skin`, `metadata`, `mugshot`, `tattoos`"

if Config.Multichar then
    newPlayer = newPlayer .. ", `firstname` = ?, `lastname` = ?, `dateofbirth` = ?, `sex` = ?, `skin` = ?, `mugshot` = ?, `tattoos` = ?"
end

if Config.StartingInventoryItems then
    newPlayer = newPlayer .. ", `inventory` = ?"
end

if Config.Multichar or Config.Identity then
    loadPlayer = loadPlayer .. ", `firstname`, `lastname`, `dateofbirth`, `sex`"
end

loadPlayer = loadPlayer .. " FROM `users` WHERE identifier = ?"

local function createVFWPlayer(identifier, playerId, data)
    local accounts = {}

    for account, money in pairs(Config.StartingAccountMoney) do
        accounts[account] = money
    end

    console.debug(json.encode(data, {indent = true}))

    local parameters = Config.Multichar and { json.encode(accounts), identifier, data.firstname, data.lastname, data.dateofbirth, data.sex, json.encode(data.skin), data.mugshot, json.encode(data.tattoos) } or { json.encode(accounts), identifier }

    if Config.StartingInventoryItems then
        table.insert(parameters, json.encode(Config.StartingInventoryItems))
    end

    MySQL.prepare(newPlayer, parameters, function()
        loadVFWPlayer(identifier, playerId, true)
    end)
end

local function onPlayerJoined(playerId)
    local identifier = VFW.GetIdentifier(playerId)
    if not identifier then
        return DropPlayer(playerId, "there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
    end

    -- if VFW.GetPlayerFromIdentifier(identifier) then
    --     DropPlayer(
    --         playerId,
    --         ("there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s"):format(
    --             identifier
    --         )
    --     )
    -- else
        local result = MySQL.scalar.await("SELECT 1 FROM users WHERE identifier = ?", { identifier })
        if result then
            loadVFWPlayer(identifier, playerId, false)
        else
            createVFWPlayer(identifier, playerId)
        end
    -- end
end

if Config.Multichar then
    AddEventHandler("vfw:onPlayerConnect", function(src, char, data)
        while not next(VFW.Jobs) do
            Wait(50)
        end

        while not next(VFW.Factions) do
            Wait(50)
        end

        if not VFW.Players[src] then
            local identifier = char .. ":" .. VFW.GetIdentifier(src)
            if data then
                createVFWPlayer(identifier, src, data)
            else
                loadVFWPlayer(identifier, src, false)
            end
        end
    end)
else
    RegisterNetEvent("vfw:onPlayerConnect", function()
        local _source = source
        while not next(VFW.Jobs) do
            Wait(50)
        end

        while not next(VFW.Factions) do
            Wait(50)
        end

        if not VFW.Players[_source] then
            onPlayerJoined(_source)
        end
    end)
end

local playerRoles = {}

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local playerId = source
    deferrals.defer()
    Wait(0)

    if GetResourceState("PoPaAP-Anticheat") == "started" then
        local isBanned = exports["PoPaAP-Anticheat"]:handleBanCheck(deferrals, playerId)
        if isBanned then return end
    end

    if oneSyncState == "off" or oneSyncState == "legacy" then
        return deferrals.done(("[VFW] VFW Requires Onesync Infinity to work. This server currently has Onesync set to: %s"):format(oneSyncState))
    end

    if not Core.DatabaseConnected then
        return deferrals.done("[VFW] OxMySQL Was Unable To Connect to your database. Please make sure it is turned on and correctly configured in your server.cfg")
    end

    local identifier = VFW.GetIdentifier(playerId)

    if identifier then
        while not VFW.IsPlayerBanned do
            Wait(5000)
        end

        local isBanned, banInfo, banDay, banHour, banMin = VFW.IsPlayerBanned(playerId)

        if isBanned then
            local banDetails = banInfo or { raison = "Aucune raison", id = "Aucun ID" }
            local remainingDay = banDay or "0"
            local remainingHour = banHour or "0"
            local remainingMin = banMin or "0"
            local banMessage = ("Vous êtes banni du serveur.\n\nRaison: %s\nID: %s\nDurée restante: %s jours, %s heures, %s minutes"):format(banDetails.raison, banDetails.id, remainingDay, remainingHour, remainingMin)
            return deferrals.done(banMessage)
        end

        local uniqueID = MySQL.Sync.fetchAll("SELECT id FROM player_global WHERE identifier = @identifier", {
            ['@identifier'] = identifier
        })
        
        logs.general.connect(playerId, uniqueID[1] and uniqueID[1].id or "Aucun ID")
        
        deferrals.done()
    else
        return deferrals.done("[VFW] There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
    end
end)

function loadVFWPlayer(identifier, playerId, isNew)
    -- if not playerRoles[indentifier] then
    --     local discord = GetPlayerIdentifierByType(playerId, "discord")
    --     if discord then
    --         local info = VFW.GetPlayerInfo(string.gsub(discord, "discord:", ""))
    --         playerRoles[identifier] = info and info.roles or {}
    --     else
    --         playerRoles[identifier] = {}
    --     end
    -- end
    -- local role, permissions = VFW.LoadPlayerRank(playerRoles[identifier] or {})
    local userData = {
        accounts = {},
        inventory = {},
        weight = 0,
        name = GetPlayerName(playerId),
        identifier = identifier,
        firstName = "John",
        lastName = "Doe",
        dateofbirth = "01/01/2000",
        sex = "m",
        dead = false,
        -- role = role,
        -- permissions = permissions,
    }

    local result = MySQL.prepare.await(loadPlayer, { identifier })

    -- Accounts
    local accounts = result.accounts
    accounts = (accounts and accounts ~= "") and json.decode(accounts) or {}

    for account, data in pairs(Config.Accounts) do
        data.round = data.round or data.round == nil

        local index = #userData.accounts + 1
        userData.accounts[index] = {
            name = account,
            money = accounts[account] or Config.StartingAccountMoney[account] or 0,
            label = data.label,
            round = data.round,
            index = index,
        }
    end

    -- Job
    local job, grade = result.job, tostring(result.job_grade)

    if not VFW.DoesJobExist(job, grade) then
        console.debug(("[^3WARNING^7] Ignoring invalid job for ^3%s^7 [job: ^3%s^7, grade: ^3%s^7]"):format(identifier, job, grade))
        job, grade = "unemployed", "0"
    end

    local jobObject, gradeObject = VFW.Jobs[job], VFW.Jobs[job].grades[grade]

    userData.job = {
        id = jobObject.id,
        name = jobObject.name,
        label = jobObject.label,
        type = jobObject.type,
        perms = jobObject.perms,
        devise = jobObject.devise,
        color = jobObject.color,

        grade = tonumber(grade),
        grade_name = gradeObject.name,
        grade_label = gradeObject.label,
        grade_salary = gradeObject.salary,
    }

    -- Faction
    local faction, grade = result.faction, tostring(result.faction_grade)

    if not VFW.DoesFactionExist(faction, grade) then
        console.debug(("[^3WARNING^7] Ignoring invalid faction for ^3%s^7 [faction: ^3%s^7, grade: ^3%s^7]"):format(identifier, faction, grade))
        faction, grade = "nocrew", "0"
    end

    console.debug("Faction", faction, grade)
    local factionObject = VFW.GetCrewByName(faction)
    if not factionObject then
        factionObject = VFW.GetCrewByName("nocrew")
    end

    console.debug("Faction Object", factionObject)
    local gradeObject = factionObject.getGrade(faction == "nocrew" and 0 or tonumber(grade))

    userData.faction = {
        id = factionObject.id,
        name = factionObject.name,
        label = factionObject.label,
        permissions = factionObject.getPerms() or {},
        type = factionObject.type,
        grade = tonumber(grade),
        grade_name = gradeObject.name,
        grade_label = gradeObject.label,
        grade_salary = gradeObject.salary,
    }
    -- Inventory
    userData.inventory = json.decode(result.inventory or "[]") or {}

    -- Position
    userData.coords = json.decode(result.position) or Config.DefaultSpawns[VFW.Math.Random(1,#Config.DefaultSpawns)]

    -- Skin
    userData.skin = (result.skin and result.skin ~= "") and json.decode(result.skin) or { sex = userData.sex == "f" and 1 or 0 }

    -- Metadata
    userData.metadata = (result.metadata and result.metadata ~= "") and json.decode(result.metadata) or {}

    --Mugshot
    userData.mugshot = result.mugshot

    --Tattoos
    userData.tattoos = json.decode(result.tattoos or "[]") or {}

    --Id
    userData.id = result.id

    --Vcoins
    userData.vcoins = result.vcoins
    

    local realName = result.firstname ~= "" and ("%s %s"):format(result.firstname, result.lastname) or GetPlayerName(playerId)
    -- xPlayer Creation
    local xPlayer = CreateExtendedPlayer(userData.id, playerId, identifier, userData.accounts, userData.inventory, userData.weight, userData.job, userData.faction, realName, userData.coords, userData.metadata, userData.skin, userData.mugshot, userData.tattoos, userData.vcoins)

    GlobalState["playerCount"] = GlobalState["playerCount"] + 1

    VFW.Players[playerId] = xPlayer

    Core.playersByIdentifier[identifier] = xPlayer

    if factionObject then
        factionObject.updateMemberStatus(identifier, true)
    end

    -- Identity
    if result.firstname and result.firstname ~= "" then
        userData.firstName = result.firstname
        userData.lastName = result.lastname

        local name = ("%s %s"):format(result.firstname, result.lastname)
        userData.name = name

        xPlayer.set("firstName", result.firstname)
        xPlayer.set("lastName", result.lastname)
        xPlayer.setName(name)

        if result.dateofbirth then
            userData.dateofbirth = result.dateofbirth
            xPlayer.set("dateofbirth", result.dateofbirth)
        end
        if result.sex then
            userData.sex = result.sex
            xPlayer.set("sex", result.sex)
        end
    end

    TriggerEvent("vfw:playerLoaded", playerId, xPlayer, isNew)
    userData.money = xPlayer.getMoney()
    userData.maxWeight = xPlayer.getMaxWeight()
    xPlayer.triggerEvent("vfw:playerLoaded", userData, isNew, userData.skin)

    -- if not Config.CustomInventory then
    --     xPlayer.triggerEvent("vfw:loadMissingPickups", Core.Pickups)
    -- else
    if setPlayerInventory then
        setPlayerInventory(playerId, xPlayer, userData.inventory, isNew)
    end

    -- xPlayer.triggerEvent("vfw:registerSuggestions", Core.RegisteredCommands)
    xPlayer.checkDeleteItem()
    xPlayer.triggerEvent("vfw:loadInventory", xPlayer.inventory, xPlayer.weight)
    console.debug(('[^2INFO^0] Player ^3"%s"^0 has connected to the server. ID: ^3%s^7'):format(xPlayer.getName(), playerId))
end

AddEventHandler("chatMessage", function(playerId, _, message)
    local xPlayer = VFW.GetPlayerFromId(playerId)
    if xPlayer and message:sub(1, 1) == "/" and playerId > 0 then
        CancelEvent()
        local commandName = message:sub(1):gmatch("%w+")()
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "commanderror_invalidcommand " .. commandName
        })
    end
end)

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    local xPlayer = VFW.GetPlayerFromId(playerId)

    if xPlayer then
        TriggerEvent("vfw:playerDropped", playerId, reason)
        TriggerEvent("core:playerTimer:stop", playerId)

        local job = xPlayer.getJob().name
        local currentJob = Core.JobsPlayerCount[job]
        Core.JobsPlayerCount[job] = ((currentJob and currentJob > 0) and currentJob or 1) - 1
        GlobalState[("%s:count"):format(job)] = Core.JobsPlayerCount[job]

        local faction = xPlayer.getFaction().name
        local currentFaction = Core.FactionsPlayerCount[faction]
        Core.FactionsPlayerCount[faction] = ((currentFaction and currentFaction > 0) and currentFaction or 1) - 1
        GlobalState[("%s:count"):format(faction)] = Core.FactionsPlayerCount[faction]

        Core.playersByIdentifier[xPlayer.identifier] = nil

        local factionObject = VFW.GetCrewByName(faction)
        if factionObject then
            factionObject.updateMemberStatus(identifier, false)
        end

        Core.SavePlayer(xPlayer, function()
            VFW.Players[playerId] = nil
            VFW.PlayerFromId[VFW.PlayerGlobal[playerId].id] = nil
            VFW.PlayerGlobal[playerId] = nil
            GlobalState["playerCount"] = GlobalState["playerCount"] - 1
        end)
        
        logs.general.disconnect(playerId)
    end
end)

AddEventHandler("vfw:playerLoaded", function(_, xPlayer)
    local job = xPlayer.getJob().name
    local jobKey = ("%s:count"):format(job)
    Core.JobsPlayerCount[job] = (Core.JobsPlayerCount[job] or 0) + 1
    GlobalState[jobKey] = Core.JobsPlayerCount[job]

    local faction = xPlayer.getFaction().name
    local factionKey = ("%s:count"):format(faction)
    Core.FactionsPlayerCount[faction] = (Core.FactionsPlayerCount[faction] or 0) + 1
    GlobalState[factionKey] = Core.FactionsPlayerCount[faction]

    logs.general.selectCharacter(xPlayer.source, xPlayer.getName())
    
    VFW.DynamicWeather = true
    VFW.FreezeTime = true
end)

AddEventHandler("vfw:setJob", function(_, job, lastJob)
    local lastJobKey = ("%s:count"):format(lastJob.name)
    local jobKey = ("%s:count"):format(job.name)
    local currentLastJob = Core.JobsPlayerCount[lastJob.name]

    Core.JobsPlayerCount[lastJob.name] = ((currentLastJob and currentLastJob > 0) and currentLastJob or 1) - 1
    Core.JobsPlayerCount[job.name] = (Core.JobsPlayerCount[job.name] or 0) + 1

    GlobalState[lastJobKey] = Core.JobsPlayerCount[lastJob.name]
    GlobalState[jobKey] = Core.JobsPlayerCount[job.name]
end)

AddEventHandler("vfw:setFaction", function(_, faction, lastFaction)
    local lastFactionKey = ("%s:count"):format(lastFaction.name)
    local factionKey = ("%s:count"):format(faction.name)
    local currentLastFaction = Core.FactionsPlayerCount[lastFaction.name]

    Core.FactionsPlayerCount[lastFaction.name] = ((currentLastFaction and currentLastFaction > 0) and currentLastFaction or 1) - 1
    Core.FactionsPlayerCount[faction.name] = (Core.FactionsPlayerCount[faction.name] or 0) + 1

    GlobalState[lastFactionKey] = Core.FactionsPlayerCount[lastFaction.name]
    GlobalState[factionKey] = Core.FactionsPlayerCount[faction.name]
end)

AddEventHandler("vfw:playerLogout", function(playerId, cb)
    local xPlayer = VFW.GetPlayerFromId(playerId)
    if xPlayer then
        TriggerEvent("vfw:playerDropped", playerId, "Changement de personnage")
        TriggerEvent("core:playerTimer:stop", playerId)
        Core.playersByIdentifier[xPlayer.identifier] = nil
        Core.SavePlayer(xPlayer, function()
            VFW.Players[playerId] = nil
            VFW.DynamicWeather = false
            VFW.FreezeTime = false
            GlobalState["playerCount"] = GlobalState["playerCount"] - 1
            if cb then
                cb()
            end
        end)
    end
    TriggerClientEvent("vfw:onPlayerLogout", playerId)
end)

RegisterServerCallback("vfw:getPlayerData", function(source)
    local xPlayer <const> = VFW.GetPlayerFromId(source)

    return {
        identifier = xPlayer.identifier,
        accounts = xPlayer.getAccounts(),
        inventory = xPlayer.getInventory(),
        job = xPlayer.getJob(),
        faction = xPlayer.getFaction(),
        money = xPlayer.getMoney(),
        position = xPlayer.getCoords(true),
        metadata = xPlayer.getMeta(),
    }
end)

RegisterServerCallback("vfw:isUserAdmin", function(source)
    return Core.IsPlayerAdmin(source)
end)

RegisterServerCallback("vfw:getGameBuild", function()
    return (tonumber(GetConvar("sv_enforceGameBuild", "1604")))
end)

RegisterServerCallback("vfw:getOtherPlayerData", function(_, target)
    local xPlayer = VFW.GetPlayerFromId(target)

    return {
        identifier = xPlayer.identifier,
        accounts = xPlayer.getAccounts(),
        inventory = xPlayer.getInventory(),
        job = xPlayer.getJob(),
        faction = xPlayer.getFaction(), 
        money = xPlayer.getMoney(),
        position = xPlayer.getCoords(true),
        metadata = xPlayer.getMeta(),
    }
end)

RegisterServerCallback("vfw:getPlayerNames", function(source, players)
    players[source] = nil

    for playerId, _ in pairs(players) do
        local xPlayer = VFW.GetPlayerFromId(playerId)

        if xPlayer then
            players[playerId] = xPlayer.getName()
        else
            players[playerId] = nil
        end
    end

    return (players)
end)

RegisterServerCallback("vfw:spawnVehicle", function(source, vehData)
    local ped = GetPlayerPed(source)
    local veh

    VFW.OneSync.SpawnVehicle(vehData[1] or 'ADDER', vehData[2] or GetEntityCoords(ped), vehData[3] or 0.0, vehData[4] or {}, function(id)
        if vehData[5] then
            local vehicle = NetworkGetEntityFromNetworkId(id)
            local timeout = 0
            while GetVehiclePedIsIn(ped, false) ~= vehicle and timeout <= 15 do
                Wait(0)
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                timeout = timeout + 1
            end
        end

        veh = id
    end)

    while not veh do Wait(0) end

    console.debug("vfw:spawnVehicle", veh)

    return veh
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(50000)
            Core.SavePlayers()
        end)
    end
end)

AddEventHandler("txAdmin:events:serverShuttingDown", function()
    Core.SavePlayers()
end)


AddEventHandler('onResourceStop', function(resource)
    Core.SavePlayers()
end)

RegisterNetEvent("core:server:loadPlayerGlobal", function()
    local source = source
    if VFW.PlayerGlobal[source] then return end

    local identifier = VFW.GetIdentifier(source)
    if not identifier then return end

    local pseudo = nil
    local discord = GetPlayerIdentifierByType(source, "discord")

    if discord then
        local info = VFW.GetPlayerInfo(string.gsub(discord, "discord:", ""))
        if info and info.user then
            pseudo = info.user.global_name
            playerRoles[identifier] = info.roles or {}
        else
            pseudo = GetPlayerName(source) or 'Pseudo Invalid'
            playerRoles[identifier] = {}
        end
    else
        pseudo = GetPlayerName(source) or 'Pseudo Invalid'
        playerRoles[identifier] = {}
    end

    local id
    local total_playtime = 0

    local result = MySQL.Sync.fetchAll("SELECT id, total_playtime FROM player_global WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    
    if #result > 0 then
        id = result[1].id
        total_playtime = result[1].total_playtime
    else
        id = MySQL.insert.await("INSERT INTO `player_global` (identifier) VALUES (?)", {
            identifier
        })
    end

    local role, permissions = VFW.LoadPlayerRank(playerRoles[identifier])
    local playerGlobal = CreatePlayerGlobal(id, role, permissions, pseudo, total_playtime, playerRoles[identifier])

    Player(source).state.id = id
    
    VFW.PlayerGlobal[source] = playerGlobal
    VFW.PlayerFromId[id] = source

    TriggerClientEvent("vfw:updatePlayerGlobalData", source, playerGlobal)
    TriggerLatentClientEvent("vfw:loadItems", source, 50000, VFW.Items)
    TriggerLatentClientEvent("vfw:loadProperties", source, 25000, VFW.ClientGetProperties())
end)

RegisterNetEvent("vfw:server:setInstance", function(status)
    local source = source
    SetPlayerRoutingBucket(source, status and source or 0)
end)

RegisterServerCallback("core:CheckInstance", function(source)
    if GetPlayerRoutingBucket(source) == 0 then
        return true
    else
        return false
    end
end)

RegisterNetEvent("vfw:onPlayerDeath", function(type, killerId)
    local playerId = source
    if type == "killed" then
        local xPlayer = VFW.GetPlayerFromId(killerId)
        local playerCrew = VFW.GetCrewByName(xPlayer.getFaction().name)
        if playerCrew == "nocrew" then
            return
        end
        playerCrew.addActivity(xPlayer.identifier, "kill")
    end
    -- Log Discord mort
    if logs and logs.general and logs.general.death then
        logs.general.death(playerId, killerId, type)
    end
end)

RegisterNetEvent("vfw:recruter", function(playerId)
    local xTarget = VFW.GetPlayerFromId(playerId)
    if not xTarget then
        return
    end

    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    xTarget.setJob(xPlayer.getJob().name, 0)
end)


local weapons = {
   {name = "weapon_advancedrifle", ammo = "ammo_rifle" },
   {name = "weapon_ak74", ammo = "ammo_rifle" },
   {name = "weapon_appistol", ammo = "ammo_pistol" },
   {name = "weapon_assaultrifle", ammo = "ammo_rifle" },
   {name = "weapon_assaultrifle_mk2", ammo = "ammo_rifle" },
   {name = "weapon_assaultshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_assaultsmg", ammo = "ammo_sub" },
   {name = "weapon_autoshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_beambag", ammo = "ammo_beambag" },
   {name = "weapon_bullpuprifle_mk2", ammo = "ammo_rifle" },
   {name = "weapon_carbinerifle", ammo = "ammo_rifle" },
   {name = "weapon_carbinerifle_mk2", ammo = "ammo_rifle" },
   {name = "weapon_ceramicpistol", ammo = "ammo_pistol" },
   {name = "weapon_coltm1878", ammo = "ammo_pistol" },
   {name = "weapon_combatmg", ammo = "ammo_heavy" },
   {name = "weapon_combatmg_mk2", ammo = "ammo_heavy" },
   {name = "weapon_combatpdw", ammo = "ammo_sub" },
   {name = "weapon_combatpistol", ammo = "ammo_pistol" },
   {name = "weapon_combatshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_compactlauncher", ammo = "ammo_rocket" },
   {name = "weapon_compactrifle", ammo = "ammo_rifle" },
   {name = "weapon_dbshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_doubleaction", ammo = "ammo_pistol" },
   {name = "weapon_emplauncher", ammo = "ammo_rocket" },
   {name = "weapon_fakeak", ammo = "ammo_rifle" },
   {name = "weapon_fakeaku", ammo = "ammo_rifle" },
   {name = "weapon_fakecombatpistol", ammo = "ammo_pistol" },
   {name = "weapon_fakem4", ammo = "ammo_rifle" },
   {name = "weapon_fakemachinepistol", ammo = "ammo_sub" },
   {name = "weapon_fakemicrosmg", ammo = "ammo_sub" },
   {name = "weapon_fakeminismg", ammo = "ammo_sub" },
   {name = "weapon_fakepistol", ammo = "ammo_pistol" },
   {name = "weapon_fakeshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_fakesmg", ammo = "ammo_sub" },
   {name = "weapon_fakespecialcarbine", ammo = "ammo_rifle" },
   {name = "weapon_flaregun", ammo = "ammo_flare" },
   {name = "weapon_g19", ammo = "ammo_pistol" },
   {name = "weapon_gadgetpistol", ammo = "ammo_pistol" },
   {name = "weapon_glock17", ammo = "ammo_pistol" },
   {name = "weapon_grenadelauncher_smoke", ammo = "ammo_rocket" },
   {name = "weapon_gusenberg", ammo = "ammo_sub" },
   {name = "weapon_heavypistol", ammo = "ammo_pistol" },
   {name = "weapon_heavyrifle", ammo = "ammo_rifle" },
   {name = "weapon_heavyshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_heavysniper", ammo = "ammo_heavy" },
   {name = "weapon_heavysniper_mk2", ammo = "ammo_heavy" },
   {name = "weapon_hominglauncher", ammo = "ammo_rocket" },
   {name = "weapon_lwrc", ammo = "ammo_rifle" },
   {name = "weapon_machinepistol", ammo = "ammo_sub" },
   {name = "weapon_marksmanpistol", ammo = "ammo_heavy" },
   {name = "weapon_marksmanrifle", ammo = "ammo_heavy" },
   {name = "weapon_marksmanrifle_mk2", ammo = "ammo_heavy" },
   {name = "weapon_microsmg", ammo = "ammo_sub" },
   {name = "weapon_militaryrifle", ammo = "ammo_rifle" },
   {name = "weapon_minismg", ammo = "ammo_sub" },
   {name = "weapon_musket", ammo = "ammo_musquet" },
   {name = "weapon_navyrevolver", ammo = "ammo_pistol" },
   {name = "weapon_p2000", ammo = "ammo_pistol" },
   {name = "weapon_pisto", ammo = "ammo_pistol" },
   {name = "weapon_pistol", ammo = "ammo_pistol" },
   {name = "weapon_pistol_mk", ammo = "ammo_pistol" },
   {name = "weapon_pistol50", ammo = "ammo_pistol" },
   {name = "weapon_precisionrifle", ammo = "ammo_heavy" },
   {name = "weapon_pumpshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_pumpshotgun_mk2", ammo = "ammo_shotgun" },
   {name = "weapon_revolver", ammo = "ammo_pistol" },
   {name = "weapon_revolver_mk", ammo = "ammo_pistol" },
   {name = "weapon_sawnoffshotgun", ammo = "ammo_shotgun" },
   {name = "weapon_smg", ammo = "ammo_sub" },
   {name = "weapon_smg_mk2", ammo = "ammo_sub" },
   {name = "weapon_sniperrifle", ammo = "ammo_heavy" },
   {name = "weapon_snspistol", ammo = "ammo_pistol" },
   {name = "weapon_snspistol_mk", ammo = "ammo_pistol" },
   {name = "weapon_specialcarbine", ammo = "ammo_rifle" },
   {name = "weapon_specialcarbine_mk2", ammo = "ammo_rifle" },
   {name = "weapon_tacticalrifle", ammo = "ammo_rifle" },
   {name = "weapon_vintagepistol", ammo = "ammo_pistol" },
}



RegisterCommand("fixweapons", function()
   for _, weapon in ipairs(weapons) do
       local weaponName = weapon.name
       local ammoName = weapon.ammo

       MySQL.Async.fetchAll("SELECT * FROM items WHERE name = @name", {
           ['@name'] = weaponName
       }, function(result)
           if not result[1] then
               print("Item not found: " .. weaponName)
               return
           end
           local item = result[1]
           local data = json.decode(item.data)
           data.ammoType = ammoName

           MySQL.Async.execute("UPDATE items SET data = @data WHERE name = @name", {
               ['@data'] = json.encode(data),
               ['@name'] = weaponName
           }, function(affectedRows)
               if affectedRows > 0 then
                   print("Updated item: " .. weaponName)
               else
                   print("Failed to update item: " .. weaponName)
               end
           end)

       end)

   end
end)