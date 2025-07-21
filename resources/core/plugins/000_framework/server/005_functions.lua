--- Triggers an event for one or more clients.
---@param eventName string The name of the event to trigger.
---@param playerIds table|number If a number, represents a single player ID. If a table, represents an array of player IDs.
---@param ... any Additional arguments to pass to the event handler.
function VFW.TriggerClientEvent(eventName, playerIds, ...)
    if type(playerIds) == "number" then
        TriggerClientEvent(eventName, playerIds, ...)
        return
    end

    local payload = msgpack.pack_args(...)
    local payloadLength = #payload

    for i = 1, #playerIds do
        TriggerClientEventInternal(eventName, playerIds[i], payload, payloadLength)
    end
end

function VFW.TriggerClientEvents(name, ids, ...)
    if type(ids) == "table" then
        if next(ids) then
            for i,v in ipairs(ids) do
                TriggerClientEvent(name, v, ...)
            end
        end
    else
        if ids and ids == -1 then
            TriggerClientEvent(name, -1, ...)
        else
            console.debug("[Core] Erreur lors d'un TriggerClientEvents, les ids ne sont pas une table. Type : " .. ids .. ". Nom de l'event : " .. name)
        end
    end
end

local function updateHealthAndArmorInMetadata(xPlayer)
    local ped = GetPlayerPed(xPlayer.source)
    xPlayer.setMeta("health", GetEntityHealth(ped))
    -- xPlayer.setMeta("armor", GetPedArmour(ped))
    xPlayer.setMeta("lastPlaytime", xPlayer.getPlayTime())
end

---@param xPlayer table
---@param cb? function
---@return nil
function Core.SavePlayer(xPlayer, cb)
    if not xPlayer.spawned then
        return cb and cb()
    end

    updateHealthAndArmorInMetadata(xPlayer)
    local parameters <const> = {
        json.encode(xPlayer.getAccounts(true)),
        xPlayer.job.name,
        xPlayer.job.grade,
        xPlayer.faction.name,
        xPlayer.faction.grade,
        json.encode(xPlayer.getCoords(false, true)),
        json.encode(xPlayer.skin),
        json.encode(xPlayer.getInventory()),
        json.encode(xPlayer.getMeta()),
        xPlayer.mugshot,
        json.encode(xPlayer.tattoos),
        xPlayer.identifier,
    }

    MySQL.prepare(
        "UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `faction` = ?, `faction_grade` = ?, `position` = ?, `skin` = ?, `inventory` = ?, `metadata` = ?, `mugshot` = ?, `tattoos` = ? WHERE `identifier` = ?",
        parameters,
        function(affectedRows)
            if affectedRows == 1 then
                console.info(('Saved player ^3"%s^7"'):format(xPlayer.name))
                TriggerEvent("vfw:playerSaved", xPlayer.playerId, xPlayer)
            end
            if cb then
                cb()
            end
        end
    )
end

---@param cb? function
---@return nil
function Core.SavePlayers(cb)
    local xPlayers <const> = VFW.Players
    if not next(xPlayers) then
        return
    end

    local startTime <const> = os.time()
    local parameters = {}

    for _, xPlayer in pairs(VFW.Players) do
        updateHealthAndArmorInMetadata(xPlayer)
        parameters[#parameters + 1] = {
            json.encode(xPlayer.getAccounts(true)),
            xPlayer.job.name,
            xPlayer.job.grade,
            xPlayer.faction.name,
            xPlayer.faction.grade,
            json.encode(xPlayer.getCoords(false, true)),
            json.encode(xPlayer.skin),
            json.encode(xPlayer.getInventory()),
            json.encode(xPlayer.getMeta()),
            xPlayer.mugshot,
            json.encode(xPlayer.tattoos),
            xPlayer.identifier,
        }
        TriggerEvent("core:playerTimer:stop", xPlayer.source)
    end

    MySQL.prepare(
        "UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `faction` = ?, `faction_grade` = ?, `position` = ?, `skin` = ?, `inventory` = ?, `metadata` = ?, `mugshot` = ?, `tattoos` = ? WHERE `identifier` = ?",
        parameters,
        function(results)
            if not results then
                return
            end

            if type(cb) == "function" then
                return cb()
            end

            console.info(("Saved ^3%s^7 %s over ^3%s^7 ms"):format(#parameters, #parameters > 1 and "players" or "player", VFW.Math.Round((os.time() - startTime) / 1000000, 2)))
        end
    )
end

VFW.GetPlayers = GetPlayers

local function checkTable(key, val, xPlayer, xPlayers)
    for valIndex = 1, #val do
        local value = val[valIndex]
        if not xPlayers[value] then
            xPlayers[value] = {}
        end

        if (key == "job" and xPlayer.job.name == value) or xPlayer[key] == value then
            xPlayers[value][#xPlayers[value] + 1] = xPlayer
        elseif (key == "faction" and xPlayer.faction.name == value) or xPlayer[key] == value then
            xPlayers[value][#xPlayers[value] + 1] = xPlayer
        end
    end
end

---@param key? string
---@param val? string|table
---@return table
function VFW.GetExtendedPlayers(key, val)
    if not key then
        return VFW.Table.ToArray(VFW.Players)
    end

    local xPlayers = {}
    if type(val) == "table" then
        for _, xPlayer in pairs(VFW.Players) do
            checkTable(key, val, xPlayer, xPlayers)
        end

        return xPlayers
    end

    for _, xPlayer in pairs(VFW.Players) do
        if (key == "job" and xPlayer.job.name == val) or xPlayer[key] == val then
            xPlayers[#xPlayers + 1] = xPlayer
        elseif (key == "faction" and xPlayer.faction.name == val) or xPlayer[key] == val then
            xPlayers[#xPlayers + 1] = xPlayer
        end
    end

    return xPlayers
end

---@param key? string
---@param val? string|table
---@return number | table
function VFW.GetNumPlayers(key, val)
    if not key then
        return #GetPlayers()
    end

    if type(val) == "table" then
        local numPlayers = {}
        if key == "job" then
            for _, v in ipairs(val) do
                numPlayers[v] = (Core.JobsPlayerCount[v] or 0)
            end
            return numPlayers
        elseif key == "faction" then
            for _, v in ipairs(val) do
                numPlayers[v] = (Core.FactionsPlayerCount[v] or 0)
            end
            return numPlayers
        end

        local filteredPlayers = VFW.GetExtendedPlayers(key, val)
        for i, v in pairs(filteredPlayers) do
            numPlayers[i] = (#v or 0)
        end
        return numPlayers
    end

    if key == "job" then
        return (Core.JobsPlayerCount[val] or 0)
    elseif key == "faction" then
        return (Core.FactionsPlayerCount[val] or 0)
    end

    return #VFW.GetExtendedPlayers(key, val)
end

---@param source number
---@return table
function VFW.GetPlayerFromId(source)
    return VFW.Players[tonumber(source)]
end

---@param identifier string
---@return table
function VFW.GetPlayerFromIdentifier(identifier)
    return Core.playersByIdentifier[identifier]
end

---@param source number
---@return table
function VFW.GetPlayerGlobalFromId(source)
    return VFW.PlayerGlobal[tonumber(source)]
end

function VFW.GetPermId(source)
    return VFW.PlayerGlobal[tonumber(source)].id
end
-- get vcoins from player
function VFW.GetVCoins(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('SELECT vcoins FROM users WHERE id = @id', {
        ['@id'] = xPlayer.id
    })
    return result or 0
end

function VFW.RemoveVCoins(source, coins)
    local xPlayer = VFW.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('UPDATE users SET vcoins = vcoins - @coins WHERE id = @id', {
        ['@id'] = xPlayer.id,
        ['@coins'] = coins
    })
    return result or 0
end

function VFW.GetSourceFromId(id)
    return VFW.PlayerFromId[tonumber(id)]
end

function VFW.GetSourceFromCharacterId(characterId)
    for _, player in pairs(VFW.Players) do
        if player.id == characterId then
            return player.source
        end
    end
end

---@param playerId number | string
---@return string
function VFW.GetIdentifier(playerId)
    local fxDk = GetConvarInt("sv_fxdkMode", 0)
    if fxDk == 1 then
        return "VFW-DEBUG-LICENCE"
    end

    playerId = tostring(playerId)

    local identifier = GetPlayerIdentifierByType(playerId, "discord")
    return identifier and identifier:gsub("discord:", "")
end

---@param model string|number
---@param player number
---@param cb function
---@diagnostic disable-next-line: duplicate-set-field
function VFW.GetVehicleType(model, player, cb)
    model = type(model) == "string" and joaat(model) or model

    if Core.vehicleTypesByModel[model] then
        return cb(Core.vehicleTypesByModel[model])
    end

    local vehicleType = TriggerClientCallback(player, "vfw:GetVehicleType", model)
    Core.vehicleTypesByModel[model] = vehicleType
    cb(vehicleType)
end

local permsDefault = {
    novice = {
        recruit = false,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        announce = false,
        billing = false,
        accounting = false,
        custom = false,
    },
    exp = {
        recruit = false,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        announce = false,
        billing = false,
        accounting = false,
        custom = false,
    },
    drh = {
        recruit = false,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        announce = false,
        billing = false,
        accounting = false,
        custom = false,
    },
    copatron = {
        recruit = true,
        promote = true,
        demote = true,
        kick = true,
        manage_permissions = true,
        announce = true,
        billing = true,
        accounting = true,
        custom = true,
    },
    boss = {
        recruit = true,
        promote = true,
        demote = true,
        kick = true,
        manage_permissions = true,
        announce = true,
        billing = true,
        accounting = true,
        custom = true,
    },
}

---@return nil
function VFW.RefreshJobs()
    local Jobs = {}
    local jobs = MySQL.query.await("SELECT * FROM jobs")

    for _, v in ipairs(jobs) do
        Jobs[v.name] = v
        Jobs[v.name].grades = {}
        Jobs[v.name].perms = v.perm and json.decode(v.perm) or permsDefault
        Jobs[v.name].devise = v.devise or "Aucune"
        Jobs[v.name].color = v.color or "#FFFFFF"
    end

    local jobGrades = MySQL.query.await("SELECT * FROM job_grades")

    for _, v in ipairs(jobGrades) do
        if Jobs[v.job_name] then
            Jobs[v.job_name].grades[tostring(v.grade)] = v
        else
            console.warn(('Ignoring job grades for ^3"%s"^0 due to missing job'):format(v.job_name))
        end
    end

    for _, v in pairs(Jobs) do
        if VFW.Table.SizeOf(v.grades) == 0 then
            Jobs[v.name] = nil
            console.warn(('[^3WARNING^7] Ignoring job ^3"%s"^0 due to no job grades found'):format(v.name))
        end
    end

    if not Jobs then
        -- Fallback data, if no jobs exist
        VFW.Jobs["unemployed"] = { label = "Unemployed", type = "aucun", perms = {}, devise = "Aucune", color = "#FFFFFF", grades = { ["0"] = { grade = 0, label = "Unemployed", salary = 200 } } }
    else
        VFW.Jobs = Jobs
    end

    return true
end

local function getCrewMembers(faction)
    local members = MySQL.query.await("SELECT firstname, lastname, identifier, faction_grade, xp, playtime FROM crew_members WHERE faction = ?", { faction })
    local crewMembers = {}

    for i = 1, #members do
        crewMembers[#crewMembers + 1] = {
            fname = members[i].firstname, 
            lname = members[i].lastname, 
            identifier = members[i].identifier, 
            rank = members[i].faction_grade,
            xp = members[i].xp,
            playtime = members[i].playtime,
        }
    end

    return crewMembers
end

---@return nil
function VFW.RefreshFactions()
    local Factions = {}
    local factions = MySQL.query.await("SELECT * FROM crews")

    for i = 1, #factions do
        local v = factions[i]
        local member = getCrewMembers(v.name)
        Factions[v.name] = v
        Factions[v.name].grades = {}
        Factions[v.name].perms = v.perms and json.decode(v.perms) or {}
        Factions[v.name].members = member
        Factions[v.name].type = v.type or "Normal"
    end

    local factionGrades = MySQL.query.await("SELECT * FROM crew_grades")

    for i = 1, #factionGrades do
        local v = factionGrades[i]
        if Factions[v.faction_name] then
            Factions[v.faction_name].grades[tostring(v.grade)] = v
        else
            console.warn(('Ignoring faction grades for ^3"%s"^0 due to missing faction'):format(v.faction_name))
        end
    end

    for k, v in pairs(Factions) do
        if VFW.Table.SizeOf(v.grades) == 0 then
            Factions[k] = nil
            console.warn(('Ignoring faction ^3"%s"^0 due to no faction grades found'):format(k))
        end
    end

    if (not Factions) then
        VFW.Factions["nofaction"] = { label = "Aucune Faction", grades = { ["0"] = { grade = 0, label = "Aucune Faction"} } }
    else
        VFW.Factions = Factions
    end
end

---@param item string
---@param cb function
---@return nil
function VFW.RegisterUsableItem(item, cb)
    Core.UsableItemsCallbacks[item] = cb
end

---@param index string
---@param overrides table
---@return nil
function VFW.RegisterPlayerFunctionOverrides(index, overrides)
    Core.PlayerFunctionOverrides[index] = overrides
end

---@param index string
---@return nil
function VFW.SetPlayerFunctionOverride(index)
    if not index or not Core.PlayerFunctionOverrides[index] then
        return console.debug("[^3WARNING^7] No valid index provided.")
    end

    Config.PlayerFunctionOverride = index
end

---@param item string
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function VFW.GetItemLabel(item)
    if VFW.Items[item] then
        return VFW.Items[item].label
    else
        console.warn(("Attemting to get invalid Item -> ^3%s^7"):format(item))
    end
end

---@return table
function VFW.GetJobs()
    return VFW.Jobs
end

function VFW.DoesItemExist(item)
    return VFW.Items[item] ~= nil
end

---@return table
function VFW.GetFactions()
    return VFW.Factions
end

---@return table
function VFW.GetItems()
    return VFW.Items
end

---@return table
function VFW.GetUsableItems()
    local Usables = {}
    for k in pairs(Core.UsableItemsCallbacks) do
        Usables[k] = true
    end
    return Usables
end

---@param job string
---@param grade string
---@return boolean
function VFW.DoesJobExist(job, grade)
    return (VFW.Jobs[job] and VFW.Jobs[job].grades[tostring(grade)] ~= nil) or false
end

---@param faction string
---@param grade string
---@return boolean
function VFW.DoesFactionExist(faction, grade)
    --return VFW.Gestion.Organizations["crew"] ~= nil and VFW.Gestion.Organizations["crew"][faction] ~= nil and VFW.Gestion.Organizations["crew"][faction].grades ~= nil and VFW.Gestion.Organizations["crew"][faction].grades[tostring(grade)] ~= nil

    if faction == "nocrew" then
        return true
    end

    local crew = VFW.GetCrewByName(faction)
    local attemps = 0

    while crew == nil and attemps < 10 do
        Wait(100)
        crew = VFW.GetCrewByName(faction)
        attemps = attemps + 1
    end

    if crew == nil then
        console.debug("dont exist")
        console.debug("DEBUG: VFW.Gestion.Organizations[\"crew\"][" .. tostring(faction) .. "] est nil")
        return false
    end

    if crew.grades == nil then
        console.debug("DEBUG: VFW.Gestion.Organizations[\"crew\"][" .. tostring(faction) .. "].grades est nil")
        return false
    end

    for _, gradeInfo in ipairs(crew.grades) do
        if tonumber(gradeInfo.grade) == tonumber(grade) then
            return true
        end
    end

    return false
end

---@param playerId string | number
---@return boolean
function Core.IsPlayerAdmin(playerId)
    playerId = tostring(playerId)
    if (IsPlayerAceAllowed(playerId, "command") or GetConvar("sv_lan", "") == "true") then
        return true
    end

    local xPlayer = VFW.Players[playerId]
    return (xPlayer and true) or false
end

-- API_ERROR_CODE: Table containing error codes and their corresponding messages for the Discord API
local API_ERROR_CODE <const> = {
    [200] = 'OK - The request was completed successfully..!',
    [400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
    [401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
    [403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
    [404] = "Error - The resource at the location specified doesn't exist.",
    [429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
    [502] = 'Error - Discord API may be down'
}

-- DiscordApiRequest(method, endpoint, data, headers)
-- Makes a request to the Discord API.
-- @param method (string): The HTTP method to use for the request (e.g., 'GET', 'POST').
-- @param endpoint (string): The API endpoint to send the request to.
-- @param data (string): The data to send with the request, if any.
-- @param reason (string): Additional headers to include in the request.
-- @return (promise): A promise that resolves with the API response or rejects with an error message.
local function discordApiRequest(method, endpoint, data, reason)
    local p = promise.new()
    local URL <const> = ("https://discord.com/api/%s/%s"):format(Config.Discord.apiVersion, endpoint)
    PerformHttpRequest(URL, function(statusCode, response, headers)
        if statusCode == 200 then
            p:resolve(json.decode(response))
        else
            local error = API_ERROR_CODE[statusCode] or ('Unknown Error %s'):format(statusCode)
            console.debug(('Discord API Error: %s'):format(error))
            p:resolve(nil)
        end
    end, method, (data or ""), {
        ["Content-Type"] = "application/json",
        ["Authorization"] = ("Bot %s"):format(Config.Discord.token),
        ['X-Audit-Log-Reason'] = reason
    })

    return Citizen.Await(p)
end

-- GetPlayerInfo(discordId)
-- Retrieves discord information about a player from the Discord API.
-- @param discordId (string): The Discord ID of the player to retrieve information for.
-- @return (promise): A promise that resolves with the player's information or rejects with an error message.
function VFW.GetPlayerInfo(discordId)
    assert(type(discordId) == 'string', 'Invalid key type, expected string, got ' .. type(discordId))
    return discordApiRequest('GET', ('guilds/%s/members/%s'):format(Config.Discord.guildId, discordId))
end

-- GetServerInfo()
-- Retrieves information about the server from the Discord API.
-- @return (promise): A promise that resolves with the server's information or rejects with an error message.
function VFW.GetServerInfo()
    return discordApiRequest('GET', ('guilds/%s'):format(Config.Discord.guildId))
end

function VFW.IsVehicleOnPos(pos, dist)
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        local vehiclePos = GetEntityCoords(vehicles[i])
        
        if #(vehiclePos - pos) <= dist then
            return true
        end
    end
    return false
end

function VFW.GetEmptyPos(posList, dist)
    for i = 1, #posList do
        if not VFW.IsVehicleOnPos(posList[i].xyz, dist) then
            return posList[i]
        end
    end
    return false
end

-- Fonction pour vérifier si un joueur a Discord lié et est sur le serveur
-- @param playerId (number): L'ID du joueur à vérifier
-- @return (table): { success: boolean, error: string|nil, discordId: string|nil }
function VFW.VerifyDiscordRequirements(playerId)
    -- Si la vérification Discord n'est pas activée, on autorise
    if not Config.DiscordRequirements or not Config.DiscordRequirements.enabled then
        return { success = true }
    end

    local playerName = GetPlayerName(playerId) or "Inconnu"

    -- Vérifier si le joueur a un Discord lié
    local discordIdentifier = GetPlayerIdentifierByType(playerId, "discord")
    if not discordIdentifier and Config.DiscordRequirements.requireLinkedAccount then
        -- Log de la tentative de connexion sans Discord
        if Config.DiscordRequirements.logging.logRejections then
            Config.DiscordRequirements.sendLog(
                "🚫 Connexion refusée - Discord non lié",
                string.format("**Joueur:** %s\n**ID:** %s\n**Raison:** Compte Discord non lié", playerName, playerId),
                16711680 -- Rouge
            )
        end

        return {
            success = false,
            error = Config.DiscordRequirements.messages.noDiscordLinked
        }
    end

    -- Si Discord n'est pas requis mais pas lié, on autorise
    if not discordIdentifier then
        return { success = true }
    end

    -- Extraire l'ID Discord
    local discordId = string.gsub(discordIdentifier, "discord:", "")

    -- Si on ne requiert que le lien Discord (pas l'appartenance au serveur)
    if not Config.DiscordRequirements.requireServerMembership then
        -- Log de la connexion réussie
        if Config.DiscordRequirements.logging.logConnections then
            Config.DiscordRequirements.sendLog(
                "✅ Connexion autorisée - Discord lié",
                string.format("**Joueur:** %s\n**ID:** %s\n**Discord ID:** %s", playerName, playerId, discordId),
                65280 -- Vert
            )
        end

        return {
            success = true,
            discordId = discordId
        }
    end

    -- Vérifier si le bot token est configuré
    if not Config.Discord.token or Config.Discord.token == "" then
        console.debug("Discord bot token not configured, skipping server membership check")
        return {
            success = true,
            discordId = discordId
        }
    end

    -- Vérifier l'appartenance au serveur Discord avec retry
    local playerInfo = nil
    local retries = 0
    local maxRetries = Config.DiscordRequirements.retryOnApiFailure and Config.DiscordRequirements.maxRetries or 1

    while retries < maxRetries and not playerInfo do
        playerInfo = VFW.GetPlayerInfo(discordId)

        if not playerInfo and retries < maxRetries - 1 then
            retries = retries + 1
            console.debug(string.format("Discord API retry %d/%d for player %s", retries, maxRetries, playerName))
            Wait(Config.DiscordRequirements.retryDelay or 2000)
        else
            break
        end
    end

    if not playerInfo then
        -- Log de l'échec de vérification
        if Config.DiscordRequirements.logging.logRejections then
            Config.DiscordRequirements.sendLog(
                "🚫 Connexion refusée - Non membre du Discord",
                string.format("**Joueur:** %s\n**ID:** %s\n**Discord ID:** %s\n**Tentatives:** %d", playerName, playerId, discordId, retries + 1),
                16711680 -- Rouge
            )
        end

        return {
            success = false,
            error = Config.DiscordRequirements.messages.notInDiscordServer
        }
    end

    -- Vérifier si le joueur est bien membre du serveur (pas juste invité)
    if not playerInfo.user or not playerInfo.user.id then
        return {
            success = false,
            error = Config.DiscordRequirements.messages.notInDiscordServer
        }
    end

    -- Vérifier si le joueur a un rôle exempté
    if Config.DiscordRequirements.hasExemptRole(playerInfo.roles) then
        -- Log de la connexion avec rôle exempté
        if Config.DiscordRequirements.logging.logConnections then
            Config.DiscordRequirements.sendLog(
                "✅ Connexion autorisée - Rôle exempté",
                string.format("**Joueur:** %s\n**ID:** %s\n**Discord:** %s\n**Rôles:** %s",
                    playerName, playerId, playerInfo.user.global_name or playerInfo.user.username,
                    table.concat(playerInfo.roles, ", ")),
                255 -- Bleu
            )
        end

        return {
            success = true,
            discordId = discordId,
            playerInfo = playerInfo,
            exempt = true
        }
    end

    -- Log de la connexion réussie
    if Config.DiscordRequirements.logging.logConnections then
        Config.DiscordRequirements.sendLog(
            "✅ Connexion autorisée - Membre Discord",
            string.format("**Joueur:** %s\n**ID:** %s\n**Discord:** %s",
                playerName, playerId, playerInfo.user.global_name or playerInfo.user.username),
            65280 -- Vert
        )
    end

    return {
        success = true,
        discordId = discordId,
        playerInfo = playerInfo
    }
end

function VFW.GetPlayersWithJobs(jobs)
    local players = {}
    local xPlayers = VFW.GetPlayers()

    for _, v in pairs(xPlayers) do
        local xPlayer = VFW.GetPlayerFromId(v)

        if xPlayer then
            local job = xPlayer.getJob()

            if type(jobs) == "table" then
                for _, c in pairs(jobs) do
                    if job.name == c and job.onDuty then
                        table.insert(players, v)
                    end
                end
            else
                if job.name == jobs and job.onDuty then
                    table.insert(players, v)
                end
            end
        end
    end

    return players
end
