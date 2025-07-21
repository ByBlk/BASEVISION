Society = {}
Society.Jobs = {}

while not ConfigManager.Loaded do
    Wait(100)
end

local defaultConfig = {
    ["autoexotic"] = true,
    ["bahamas"] = true,
    ["beekers"] = true,
    ["bennys"] = true,
    ["burgershot"] = true,
    ["dynasty"] = true,
    ["getaweigh"] = true,
    ["harmony"] = true,
    ["hayes"] = true,
    ["ltdgroove"] = false,
    ["ltdroxwood"] = false,
    ["ltdseoul"] = false,
    ["miroir"] = true,
    ["pawnshop"] = true,
    ["pdm"] = false,
    ["pizzathis"] = true,
    ["rexdiner"] = true,
    ["rockford"] = true,
    ["skyblue"] = true,
    ["sweetholes"] = true,
    ["unicorn"] = true,
    ["uwucoffee"] = true,
    ["weazelnews"] = true,
    ["yellowjack"] = true,
}

local grades = {
    { name = "boss",     label = "Patron",              grade = 4,   salary = 500, perm = { recruit = true, billing = true, announce = true, demote = true, kick = true, custom = true, manage_permissions = true, accounting = true, promote = true } },
    { name = "copatron", label = "Co Patron",           grade = 3,   salary = 400, perm = { recruit = false, billing = false, announce = false, demote = false, kick = false, custom = false, manage_permissions = false, accounting = false, promote = false } },
    { name = "drh",      label = "DRH",                 grade = 2,   salary = 300, perm = { recruit = false, billing = false, announce = false, demote = false, kick = false, custom = false, manage_permissions = false, accounting = false, promote = false } },
    { name = "exp",      label = "Employé expérimenté", grade = 1,   salary = 200, perm = { recruit = false, billing = false, announce = false, demote = false, kick = false, custom = false, manage_permissions = false, accounting = false, promote = false } },
    { name = "novice",   label = "Novice",              grade = 0,   salary = 100, perm = { recruit = false, billing = false, announce = false, demote = false, kick = false, custom = false, manage_permissions = false, accounting = false, promote = false } },
}

ConfigManager.loadConfig("society", defaultConfig)

local function ensureJobAndGradesExist(jobName)
    exports.oxmysql:scalar('SELECT name FROM jobs WHERE name = ?', {jobName}, function(result)
        if not result then
            local allPermissions = {}
            for _, grade in ipairs(grades) do
                allPermissions[grade.name] = grade.perm
            end

            exports.oxmysql:execute('INSERT INTO jobs (name, label, type, perm) VALUES (?, ?, ?, ?)', {
                jobName,
                jobName:upper(),
                "job",
                json.encode(allPermissions)
            })
        end

        for _, grade in ipairs(grades) do
            exports.oxmysql:scalar('SELECT id FROM job_grades WHERE job_name = ? AND grade = ?', {jobName, grade.grade}, function(gradeResult)
                if not gradeResult then
                    exports.oxmysql:execute([[
                        INSERT INTO job_grades (job_name, grade, name, label, salary)
                        VALUES (?, ?, ?, ?, ?)
                    ]], {
                        jobName,
                        grade.grade,
                        grade.name,
                        grade.label,
                        grade.salary
                    })
                end
            end)
        end

        exports.oxmysql:scalar('SELECT job FROM society WHERE job = ?', {jobName}, function(societyResult)
            if not societyResult then
                exports.oxmysql:execute([[
                    INSERT INTO society (job, perm, account)
                    VALUES (?, ?, ?)
                ]], {
                    jobName,
                    json.encode({}),
                    json.encode({ money = 8000, history = {} })
                })
                console.success("Inserted society entry for job: " .. jobName)
            else
                console.info("Society entry already exists for job: " .. jobName)
            end
        end)

    end)
end

local function resetSociety(jobName)
    if not jobName or jobName == "" then
        console.error("Reset société échoué: nom de job invalide.")
        return
    end

    if defaultConfig[jobName] == nil then
        console.error("Reset société échoué: société " .. jobName .. " inconnue dans la config.")
        return
    end

    console.info("Démarrage du reset de la société: " .. jobName)

    exports.oxmysql:execute('DELETE FROM job_grades WHERE job_name = ?', {jobName})
    exports.oxmysql:execute('DELETE FROM jobs WHERE name = ?', {jobName})
    exports.oxmysql:execute('DELETE FROM society WHERE job = ?', {jobName})
    exports.oxmysql:execute('UPDATE users SET job = ?, job_grade = 0 WHERE job = ?', {"unemployed", jobName})

    ensureJobAndGradesExist(jobName)

    console.success("Reset terminé pour la société: " .. jobName)
end

RegisterCommand('resetsociety', function(source, args)
    if source ~= 0 then
        console.info('Cette commande ne peut être exécutée que par le serveur.')
        return
    end
    if #args < 1 then
        console.info('Usage: /resetsociety <jobname>')
        return
    end

    local jobName = args[1]:lower()
    logs.society.reset(source, jobName)
    resetSociety(jobName)
end)


for jobName, _ in pairs(defaultConfig) do
    ensureJobAndGradesExist(jobName)
end

RegisterNetEvent("GestionDev:saveSociety", function(name, value)
    if name == nil or name == "" or value == nil then
        return false
    end
    ConfigManager.Config["society"][name] = value
    ConfigManager.saveConfig("society", ConfigManager.Config["society"])
end)