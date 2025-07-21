VFW.JobsMembers = {}

local roles = {
    faction = {
        'Rookie',
        'Officer',
        'Sergent',
        'Capitaine',
        'Commandant'
    },
    job = {
        'Novice',
        'Employé expérimenté',
        'DRH',
        'Co Patron',
        'Patron'
    }
}

VFW.GetJobRoleByGrade = function(type, grade)
    return roles[type][grade]
end

VFW.UpdateJobMembers = function(job, identifier, grade, type)
    if not VFW.JobsMembers[job] then
        VFW.JobsMembers[job] = {}
    end

    local memberFind = false

    for _, member in ipairs(VFW.JobsMembers[job]) do
        if member.identifier == identifier then
            member.rank = grade + 1
            member.Information.roles = roles[type][grade + 1]
            memberFind = true
            break
        end
    end

    if not memberFind then
        local xPlayer = VFW.GetPlayerFromIdentifier(identifier)

        if xPlayer then
            table.insert(VFW.JobsMembers[job], {
                identifier = identifier,
                rank = grade + 1,
                Information = {
                    xPlayer.mugshot,
                    roles = roles[type][grade + 1],
                    seniority = "16.01.2025",
                    speciality = "",
                    status = true,
                    classements = {}
                }
            })
        end
    end
end

VFW.RemoveJobMember = function(job, identifier)
    if not VFW.JobsMembers[job] then
        return false
    end

    for i, member in ipairs(VFW.JobsMembers[job]) do
        if member.identifier == identifier then
            table.remove(VFW.JobsMembers[job], i)
            return true
        end
    end

    return false
end

VFW.GetJobsMemberFromIdentifier = function(job, identifier)
    if not VFW.JobsMembers[job] then
        return nil
    end

    for _, member in ipairs(VFW.JobsMembers[job]) do
        if member.identifier == identifier then
            return member
        end
    end

    return nil
end

MySQL.ready(function()
    local loaded = false

    while not loaded do
        if VFW.RefreshJobs() then
            loaded = true
        end
        Wait(100)
    end

    local result = MySQL.Sync.fetchAll('SELECT * FROM users')

    for _, v in pairs(result) do
        if v.job ~= "unemployed" then
            if not VFW.JobsMembers[v.job] then
                VFW.JobsMembers[v.job] = {}
            end

            table.insert(VFW.JobsMembers[v.job], {
                identifier = v.identifier,
                fname = v.firstname,
                lname = v.lastname,
                rank = v.job_grade + 1,
                Information = {
                    mugshot = v.mugshot,
                    roles = roles[VFW.Jobs[v.job].type][v.job_grade + 1],
                    seniority = "16.01.2025",
                    speciality = "",
                    status = false,
                    classements = {}
                }
            })
        end
    end
end)

RegisterNetEvent("vfw:playerLoaded", function(_, xPlayer)
    for _, members in pairs(VFW.JobsMembers) do
        for _, member in ipairs(members) do
            if member.identifier == xPlayer.identifier then
                member.Information.status = true
                break
            end
        end
    end
end)

RegisterNetEvent("vfw:playerDropped", function(playerId)
    local xPlayer = VFW.GetPlayerFromId(playerId)
    if not xPlayer then return end

    for _, members in pairs(VFW.JobsMembers) do
        for _, member in ipairs(members) do
            if member.identifier == xPlayer.identifier then
                member.Information.status = false
                break
            end
        end
    end
end)

RegisterServerCallback("core:jobs:getMembers", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    if not job then return end

    return VFW.JobsMembers[job.name]
end)

RegisterServerCallback("core:jobs:getProperties", function()
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    if not job then return end
    local properties = VFW.GetJobProperty(job.name)

    return properties
end)

RegisterServerCallback("core:jobs:getNumberMembers", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    if not job then return end
    local players = VFW.GetPlayers()
    local count = 0

    for i = 1, #players do
        local player = VFW.GetPlayerFromId(players[i])

        if player then
            if player.getJob().name == job.name and player.getJob().onDuty then
                count = count + 1
            end
        end
    end

    return count
end)

RegisterServerCallback("core:jobs:getNumberSup", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob()
    if not job then return end
    local players = VFW.GetPlayers()
    local count = 0

    for i = 1, #players do
        local player = VFW.GetPlayerFromId(players[i])

        if player then
            if player.getJob().name == job.name and player.getJob().onDuty and player.getJob().grade >= 2 then
                count = count + 1
            end
        end
    end

    return count
end)

RegisterServerCallback("core:jobs:getClonePed", function(source, name)
    local xTargets = VFW.GetPlayers()
    local playersFound = {}

    for i = 1, #xTargets do
        local xTargetId = xTargets[i]

        if tonumber(xTargetId) ~= tonumber(source) then
            local xTarget = VFW.GetPlayerFromId(xTargetId)

            if xTarget and xTarget.getJob() then
                if xTarget.getJob().name == name and xTarget.getJob().onDuty then
                    table.insert(playersFound, {
                        skin = xTarget.skin,
                        tattoos = xTarget.tattoos
                    })

                    if #playersFound >= 2 then
                        break
                    end
                end
            end
        end
    end

    if #playersFound >= 1 then
        if #playersFound >= 2 then
            return playersFound[1].skin, playersFound[1].tattoos, playersFound[2].skin, playersFound[2].tattoos
        else
            return playersFound[1].skin, playersFound[1].tattoos, nil, nil
        end
    else
        return nil, nil, nil, nil
    end
end)

RegisterServerCallback('core:jobs:requestMemberCam', function(src, identifier)
    local results = MySQL.Sync.fetchAll([[SELECT skin, tattoos FROM users WHERE identifier = @identifier]], { ["@identifier"] = identifier })
    local skin = json.decode(results[1].skin)
    local tattoos = json.decode(results[1].tattoo)

    return skin or nil, tattoos or nil
end)
