
local NOTIFY_TYPES = {
    INFO = "^3[%s]^7-^6[INFO]^7 %s",
    SUCCESS = "^3[%s]^7-^2[SUCCESS]^7 %s",
    ERROR = "^3[%s]^7-^1[ERROR]^7 %s"
}

local function doesFactionAndGradesExist(name, grades)
    if not VFW.Factions[name] then
       return false
    end

   for _, grade in ipairs(grades) do
       if not VFW.DoesFactionExist(name, grade.grade) then
           return false
       end
   end

   return true
end

local function generateNewFactionTable(name, label, grades)
    local faction = { name = name, label = label, grades = {} }
    for _, v in pairs(grades) do
        faction.grades[tostring(v.grade)] = { faction_name = name, grade = v.grade, name = v.name, label = v.label }
    end

    return faction
end

local function notify(notifyType,resourceName,message,...)
    local formattedMessage = string.format(message, ...)

    if not NOTIFY_TYPES[notifyType] then
        return console.debug(NOTIFY_TYPES.INFO:format(resourceName,formattedMessage))
    end

    return console.debug(NOTIFY_TYPES[notifyType]:format(resourceName,formattedMessage))
end


local crewPermissionBase = {
    recrue = {
        recruit = false,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        manage_crew = false,
        orders = false,
        manage_garage = false,
        manage_property = false,
    },
    membre = {
        recruit = false,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        manage_crew = false,
        orders = false,
        manage_garage = false,
        manage_property = false,
    },
    soldat = {
        recruit = true,
        promote = false,
        demote = false,
        kick = false,
        manage_permissions = false,
        manage_crew = false,
        orders = false,
        manage_garage = false,
        manage_property = false,
    },
    brasdroit = {
        recruit = true,
        promote = true,
        demote = false,
        kick = false,
        manage_permissions = false,
        manage_crew = false,
        orders = false,
        manage_garage = false,
        manage_property = false,
    },
    souschef = {
        recruit = true,
        promote = true,
        demote = true,
        kick = false,
        manage_permissions = false,
        manage_crew = false,
        orders = false,
        manage_garage = false,
        manage_property = false,
    },
    chef = {
        recruit = true,
        promote = true,
        demote = true,
        kick = true,
        manage_permissions = true,
        manage_crew = true,
        orders = true,
        manage_garage = true,
        manage_property = true,
    }

}

--VFW.Gestion.Organizations["crew"][id].grades = {
--    { grade = 0, name = "recrue", label = "Recrue" },
--    { grade = 1, name = "membre", label = "Membre" },
--    { grade = 2, name = "soldat", label = "Soldat" },
--    { grade = 3, name = "brasdroit", label = "Bras droit" },
--    { grade = 4, name = "souschef", label = "Sous chef" },
--    { grade = 5, name = "chef", label = "Chef" }
--}

--- Create Faction at Runtime
--- @param name string
--- @param label string
--- @param grades table
function VFW.CreateFaction(name, label, grades)
    local currentResourceName = GetInvokingResource()
    local success = false

    if not name or name == '' then
        notify("ERROR",currentResourceName, "Missing argument 'name'")
        return success
    end

    if not label or label == '' then
        notify("ERROR",currentResourceName, "Missing argument 'label'")
        return success
    end

    if not grades or not next(grades) then
        notify("ERROR",currentResourceName, "Missing argument 'grades'")
        return success
    end

    local defaultPermissions = crewPermissionBase

    local crew = VFW.GetCrewByName(name)
    crew.perms = defaultPermissions
    crew:save()

    queries = {}

    for _, grade in ipairs(grades) do
        queries[#queries + 1] = {
            query = 'INSERT INTO crew_grades (faction_name, grade, name, label) VALUES (?, ?, ?, ?)',
            values = { name, grade.grade, grade.name, grade.label }
        }
    end

    success = exports.oxmysql:transaction_async(queries)

    if not success then
        notify("ERROR", currentResourceName, "Failed to insert one or more grades for faction: '%s'", name)
        return success
    end

    notify("SUCCESS", currentResourceName, "Faction created successfully: '%s'", name)

    return success
end

--delete
function VFW.DeleteFaction(name)
    local currentResourceName = (GetInvokingResource() or GetCurrentResourceName())
    local success = false

    if (not name) then
        notify("ERROR",currentResourceName, "Missing argument 'name'")
        return success
    end

    local crew = VFW.GetCrewByName(name)

    if not crew then
        notify("ERROR",currentResourceName, "Faction does not exist: '%s'", name)
        return success
    end

    local queries = {
        { query = 'DELETE FROM crews WHERE name = ?', values = { name } },
        { query = 'DELETE FROM crew_grades WHERE faction_name = ?', values = { name } },
        { query = "DELETE FROM crew_members WHERE faction = ?", values = { name } },
        { query = "DELETE FROM laboratories WHERE crew = ?", values = { name}},
    }

    VFW.DeleteProperty(crew.stockageId)
    VFW.DeleteProperty(crew.garageId)
    local lab = GetLabo(crew.laboId)
    if lab then
        lab.deleteLabo()
    end

    success = exports.oxmysql:transaction_async(queries)

    if not success then
        notify("ERROR", currentResourceName, "Failed to delete faction: '%s'", name)
        return success
    end

    VFW.Gestion.Organizations[name] = nil

    -- remove faction from all connected players
    for i = 1, #VFW.GetPlayers() do
        local player = VFW.GetPlayerFromId(VFW.GetPlayers()[i])
        if player.getFaction().name == name then
            player.setFaction("nocrew", 0)
        end
    end

    notify("SUCCESS", currentResourceName, "Faction deleted successfully: '%s'", name)

    return success
end