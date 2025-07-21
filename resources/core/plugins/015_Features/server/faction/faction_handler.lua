RegisterServerCallback("core:faction:getCrewInfosForRadial", function(source, name)
    local crew = VFW.GetCrewByName(name)
    if not crew then
        return 0, "#ff0000"
    end
    local xp = crew.xp or 0
    local colour = crew.color or "#ff0000"
    return xp, colour
end)

RegisterServerCallback("core:crew:getInfos", function(source, name)
    local crew = VFW.GetCrewByName(name)
    return { perms = crew.perms, place = crew.place, colorIndex = crew.colorIndex, color = crew.color, devise = crew.devise, members = crew.members, activities = crew.activities }
end)

RegisterServerCallback("core:crew:getFactionInfluence", function(source, name)
    return VFW.TerritoriesServer.GetCrewTotalInfluence(name)
end)

RegisterServerCallback("core:faction:getCrewRankWeekly", function(source, name)
    return VFW.TerritoriesServer.Crews[name].weeklyRank or #VFW.Gestion.Organizations["crew"] -- Or nouveau crew
end)

RegisterServerCallback("core:crew:getPermissions", function(source, name)
    local crew = VFW.GetCrewByName(name)
    return crew.perms
end)

RegisterServerCallback("core:crew:getCrewLevelByName", function(source, name)
    local crew = VFW.GetCrewByName(name)
    if not crew then
        return 0
    end
    return crew.level or 0
end)
RegisterServerCallback("core:crew:getCrewXpByName", function(source, name)
    local crew = VFW.GetCrewByName(name)
    if not crew then
        return 0
    end
    return crew.xp or 0
end)

RegisterNetEvent("core:faction:update", function(type, name, color, devise, place)
    local src = source
    local player = VFW.GetPlayerFromId(src)

    if type == "crew" then
        local faction = player.getFaction()
        console.debug("faction update", json.encode(faction), faction.name)
        if not faction then
            return
        end
        if not player.canUseCrewPermission("manage_crew") then
            TriggerClientEvent("vfw:showNotification", src, {
                type = 'ROUGE',
                content = "Vous n'avez pas les permissions pour modifier votre faction."
            })
            return
        end
        local crew = VFW.GetCrewByName(faction.name)
        if not crew then
            return
        end

        crew.label = name
        crew.place = place
        crew.color = color
        crew.devise = devise
        crew.save()
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Les informations de votre faction ont été mises à jour."
        })
    elseif type == "faction" or type == "company" then
        VFW.Jobs[player.getJob().name].devise = devise
        VFW.Jobs[player.getJob().name].color = color
        VFW.Jobs[player.getJob().name].label = name
        player.getJob().devise = devise
        player.getJob().color = color
        player.getJob().label = name

        MySQL.Async.execute("UPDATE `jobs` SET `label` = @label, `devise` = @devise, `color` = @color WHERE `name` = @name", {
            ['@label'] = name,
            ['@devise'] = devise,
            ['@color'] = color,
            ['@name'] = player.getJob().name
        }, function()
            player.triggerEvent('vfw:updatePlayerData', 'job', player.getJob())
        end)
    end
end)

RegisterNetEvent("vfw:staff:ChangeCrew", function(plyid, crew, grade)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local hasPerm = playerGlobal.permissions["gestion_crew"]
    if hasPerm then
        local player = VFW.GetPlayerFromId(tonumber(plyid))
        if player then
            console.debug("setfaction", crew, grade)
            player.setFaction(crew, tonumber(grade))
            TriggerClientEvent("vfw:showNotification", src, {
                type = 'VERT',
                content = "Vous avez changé la faction de " .. player.getName() .. " pour " .. crew .. " avec le grade " .. grade
            })
            TriggerClientEvent("vfw:showNotification", tonumber(plyid), {
                type = 'VERT',
                content = "Votre faction a été changée pour " .. crew .. " avec le grade " .. grade
            })
        end
    else
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission de changer la faction d'un joueur."
        })
    end
end)

local xpToRank = {
    { rank = "S", xp = 14000 },
    { rank = "A", xp = 7000 },
    { rank = "B", xp = 3000 },
    { rank = "C", xp = 1000 },
    { rank = "D", xp = 0 }
}

function VFW.GetRankFromXP(xp)
    if (not xp) or (type(xp) ~= "number") then
        return "D", 0
    end

    local currentRank = "D"
    local currentThreshold = 0
    local nextThreshold = 0

    for i = 1, #xpToRank do
        if xp >= xpToRank[i].xp then
            currentRank = xpToRank[i].rank
            currentThreshold = xpToRank[i].xp

            if i > 1 then
                nextThreshold = xpToRank[i - 1].xp
            else
                return currentRank, 100
            end

            break
        end
    end

    local xpDifference = nextThreshold - currentThreshold
    local currentProgress = xp - currentThreshold
    local percentage = math.floor((currentProgress / xpDifference) * 100)

    percentage = math.max(0, math.min(100, percentage))

    return currentRank, percentage
end

RegisterServerCallback("core:orga:updateRole", function(source, type, currentRole, isPromote, targetIdentifier)
    local player = VFW.GetPlayerFromId(source)
    local isUp = isPromote and 1 or -1
    if type == "crew" then
        local crew = VFW.GetCrewByName(player.getFaction() and player.getFaction().name or "")
        if not crew then
            return false, nil, "Aucun crew"
        end

        -- PROMOTE OR DEMOTE
        if not player.canUseCrewPermission(isPromote and "promote" or "demote") then
            console.debug("[core:crew:updateRole] Permission denied for player " .. player.getName())
            return false, nil, "Permission refusée"
        end

        local currentRank = crew.getRoleByLabel(currentRole)
        if currentRank == 5 then
            return false, nil, "Permission refusée"
        end

        local newRank = currentRank + isUp
        if newRank < 0 then
            crew.removeMember(targetIdentifier)
            return true, "nocrew", "Membre retiré"
        end

        crew.updateMemberGrade(targetIdentifier, newRank)
        return true, crew.getMemberRole(targetIdentifier), "Rang mis à jour"
    elseif type == "faction" or type == "company" then
        if not player.canUseJobPermission(isPromote and "promote" or "demote") then
            return false, nil, "Permission refusée"
        end

        local target = VFW.GetPlayerFromIdentifier(targetIdentifier)

        if target then
            local newRank = target.job.grade + isUp

            if newRank < 0 then
                VFW.RemoveJobMember(target.job.name, targetIdentifier)
                target.setJob("unemployed", 0)
                return true, "unemployed", "Employé retiré"
            end

            target.setJob(target.job.name, newRank, target.job.onDuty)

            return true, VFW.GetJobRoleByGrade(type == "faction" and "faction" or "job", newRank + 1), "Rang mis a jour"
        else
            local playerOffline = VFW.GetJobsMemberFromIdentifier(player.job.name, targetIdentifier)
            if not playerOffline then
                return false, nil, "Aucun membre trouvé"
            end
            local newRank = playerOffline.rank - 1 + isUp

            if newRank < 0 then
                MySQL.Async.execute([[UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier]], {
                    ["@identifier"] = targetIdentifier,
                    ["@job"]  = "unemployed",
                    ["@job_grade"] = 0
                }, function()
                    print("Player " .. targetIdentifier .. " removed from job")
                end)
                VFW.RemoveJobMember(player.job.name, targetIdentifier)
                return true, "unemployed", "Employé retiré"
            end

            MySQL.Async.execute([[UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier]], {
                ["@identifier"] = targetIdentifier,
                ["@job"]  = player.job.name,
                ["@job_grade"] = newRank
            }, function()
                print("Player " .. targetIdentifier .. " updated to job " .. player.job.name .. " with grade " .. newRank)
            end)
            VFW.UpdateJobMembers(player.job.name, targetIdentifier, newRank, type == "faction" and "faction" or "job")
            return true, VFW.GetJobRoleByGrade(type == "faction" and "faction" or "job", newRank + 1), "Rang mis a jour"
        end
    end
end)

RegisterServerCallback("core:crew:getFactionRank", function(source, name)
    local player = VFW.GetPlayerFromId(source)
    local crew = VFW.GetCrewByName(player.getFaction() and player.getFaction().name or "")
    if not crew then
        return "D", 0
    end
    return VFW.GetRankFromXP(crew.xp or 0)
end)

RegisterServerCallback("vfw:IsTargetLowerRank", function(source, target)
    local player = VFW.GetPlayerFromId(source)
    local targetPlayer = VFW.GetPlayerFromId(target)

    if not player or not targetPlayer then
        print("Player " .. (player and player.getName() or "nil") .. " or target " .. (targetPlayer and targetPlayer.getName() or "nil") .. " not found")
        return
    end

    local playerFaction = player.getFaction()
    local targetFaction = targetPlayer.getFaction()


    if not playerFaction or not targetFaction then
        print("Player or target not in a faction")
        return
    end

    if playerFaction.name ~= targetFaction.name then
        print("Player and target are not in the same faction")
        return
    end

    local playerRank = playerFaction.grade
    local targetRank = targetFaction.grade

    if playerRank == targetRank then
        return false
    elseif playerRank > targetRank then
        return true
    else
        return false
    end
end)



local function getMyCrewPermission(crewPermission, name)
    local perm = crewPermission
    for i = 1, #(perm or {}) do
        if perm[i].name == name then
            return perm[i].access
        end
    end
    return false
end

local roles = {
    faction = {
        rookie = 'novice',
        officer = 'exp',
        supervisor = "drh",
        ["capitaine"] = "copatron",
        ["chief office"] = "boss"
    },
    company = {
        novice = 'novice',
        ["employée experimenté"] = 'exp',
        drh = "drh",
        ["co patron"] = "copatron",
        ["patron"] = "boss"
    }
}

RegisterNetEvent("core:orga:savePermissions", function(type, permissions, grade)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    if type == "crew" then
        local playerCrew = player.getFaction()
        local crewPermission = player and playerCrew.permissions or {}
        local faction = player and playerCrew.name or nil
        local hasPermission = player.canUseCrewPermission("manage_permissions")

        if (not hasPermission) then
            TriggerClientEvent("vfw:showNotification", src, {
                type = 'ROUGE',
                content = "Vous n'avez pas les permissions pour modifier les permissions de votre faction."
            })
            return
        end
        local crew = VFW.GetCrewByName(faction)
        local perms = crew.getPerms() or {}
        perms[grade] = permissions
        crew.save()
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Les permissions du rang id " .. grade .. " de votre crew ont été mises à jour."
        })

        local players = VFW.GetPlayers()
        for i = 1, #players do
            local player = VFW.GetPlayerFromId(players[i])
            if player.getFaction().name == faction then
                TriggerClientEvent("core:crew:updatePerms", player.source, perms)
            end
        end
    elseif type == "faction" or type == "company" then
        local job = player.getJob()
        if not player.canUseJobPermission("manage_permissions") then
            return
        end

        print("type ", type, "grade", grade)
        VFW.Jobs[job.name].perms[roles[type][grade]] = permissions
        job.perms[roles[type][grade]] = permissions

        MySQL.Async.execute("UPDATE `jobs` SET `perm` = @perm WHERE `name` = @name", {
            ['@perm'] = json.encode(VFW.Jobs[job.name].perms),
            ['@name'] = job.name
        }, function()
            player.triggerEvent('vfw:updatePlayerData', 'job', player.getJob())
        end)
    end
end)

local function leaveMyCrew()
    local src = source
    local player = VFW.GetPlayerFromId(src)
    if player then
        player.setFaction("nofaction", 0)
    end
    TriggerClientEvent("vfw:showNotification", src, {
        type = 'VERT',
        content = "Vous avez quitté votre faction"
    })
end

RegisterNetEvent("core:faction:leavemyCrew", leaveMyCrew)

local function inviteIdToMyCrew(player)
    local src = source
    if player == -1 then
        return
    end
    local PLAYER = VFW.GetPlayerFromId(src)
    local targetPlayer = VFW.GetPlayerFromId(player)
    local faction = PLAYER.getFaction().name
    if faction == "nocrew" then
        return
    else
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous ne pouvez pas inviter un joueur dans une faction si vous n'avez pas de crew."
        })
    end
    if PLAYER and targetPlayer then
        TriggerClientEvent("core:faction:invitePlayer", player, PLAYER.getFaction().name, PLAYER.getFaction().label, src)
    end
end

RegisterNetEvent("core:faction:acceptInvite", function(name, inviteId)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    if player then
        player.setFaction(name, 1)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Vous avez rejoint le crew " .. name .. "."
        })
        TriggerClientEvent("vfw:showNotification", inviteId, {
            type = 'VERT',
            content = "Vous avez recruté " .. player.getName() .. " dans votre crew."
        })
    end
end)

RegisterNetEvent("core:faction:invitePlayer", inviteIdToMyCrew)

local function canRecruitFaction(source)
    local player = VFW.GetPlayerFromId(source)
    local faction = player and player.getFaction() or nil
    local identifier = player and player.getIdentifier() or nil
    local crewData = VFW.GetCrewByName(faction)
    local members = crewData and crewData.members or {}
    for i = 1, #members do
        local v = members[i]
        if identifier and v.id == identifier then
            if crewData.perms[v.crewRank].recruit then
                return true
            else
                return false
            end
        end
    end
    return false
end

RegisterServerCallback("core:faction:canIRecruit", canRecruitFaction)

RegisterServerCallback("core:faction:getClonePed", function(source, name)
    local xTargets = VFW.GetPlayers()
    local playersFound = {}

    for i = 1, #xTargets do
        local xTargetId = xTargets[i]

        if tonumber(xTargetId) ~= tonumber(source) then
            local xTarget = VFW.GetPlayerFromId(xTargetId)

            if xTarget and xTarget.getFaction() then
                if xTarget.getFaction().name == name then
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

RegisterServerCallback('core:faction:requestMemberCam', function(src, identifier)
    local results = MySQL.Sync.fetchAll([[SELECT skin, tattoos FROM users WHERE identifier = @identifier]], { ["@identifier"] = identifier })
    local skin = json.decode(results[1].skin)
    local tattoos = json.decode(results[1].tattoo)

    return skin or nil, tattoos or nil
end)

RegisterServerCallback("core:faction:requestCraftPosition", function(src)
    local player = VFW.GetPlayerFromId(src)
    local faction = player.getFaction()

    if faction.name == "nocrew" then
        return nil
    end

    console.debug("Type de la faction : ", faction.type)

    return VFW.GetCraftPosByCrew(faction.type)
end)

RegisterServerCallback("core:faction:getMyCraftItems", function(src)
    local player = VFW.GetPlayerFromId(src)
    local faction = player.getFaction()
    if faction.name == "nocrew" then
        return nil
    end

    local crew = VFW.GetCrewByName(faction.name)

    return crew.getMyItemsCraft()
end)


RegisterServerCallback("core:crew:UpToNewRoles", function(source, target, actionType)
    local sourcePlayer = VFW.GetPlayerFromId(source)
    local targetPlayer = VFW.GetPlayerFromId(target)

    
    if not sourcePlayer or not targetPlayer then
        print("[CrewSystem] Erreur : joueur source ou cible invalide.")
        return false
    end

    local sourceFaction = sourcePlayer.getFaction()
    local targetFaction = targetPlayer.getFaction()

    if not sourceFaction or not targetFaction then
        print("[CrewSystem] Erreur : faction source ou cible invalide.")
        return false
    end

    if sourceFaction.name ~= targetFaction.name then
        print("[CrewSystem] Erreur : les joueurs ne sont pas dans la même faction.")
        return false
    end
    local currentGrade = targetFaction.grade
    local newGrade = currentGrade
    local actionLabel = ""
    
    if actionType == "promote" then
        newGrade = currentGrade + 1
        if newGrade > 5 then
            print("[CrewSystem] Erreur : grade maximum atteint.")
            return false
        end
        actionLabel = "promu"
    elseif actionType == "demote" then
        newGrade = currentGrade - 1
        if newGrade < 0 then
            print("[CrewSystem] Erreur : grade minimum atteint.")
            return false
        end
        actionLabel = "rétrogradé"
    elseif actionType == "kick" then
        targetPlayer.setFaction("nofaction", 0)
        actionLabel = "retiré"
    else
        print("[CrewSystem] Erreur : action inconnue (" .. tostring(actionType) .. ").")
        return false
    end
    targetFaction.grade = newGrade 
    local newGradeName = targetFaction.grade_name 

    print(string.format("[CrewSystem] %s -> %s : %s au grade %s (niveau %d)", 
        sourcePlayer.getName(), 
        targetPlayer.getName(), 
        actionLabel, 
        newGradeName, 
        newGrade
    ))
    local notificationMsgTarget = "Vous avez été " .. actionLabel .. " au rang " .. newGradeName
    local notificationMsgSource = "Vous avez " .. actionLabel .. " " .. targetPlayer.getName() .. " au rang " .. newGradeName
    local notificationKick = targetPlayer.getName() .. " a été " .. actionLabel .. " de la faction"     
    local notificationKickTarget = "Vous avez été " .. actionLabel .. " de la faction"
    TriggerClientEvent("vfw:showNotification", targetPlayer.source, {
        type = 'ROUGE',
        content = notificationMsgTarget
    })
    TriggerClientEvent("vfw:showNotification", sourcePlayer.source, {
        type = 'ROUGE',
        content = notificationMsgSource
    })
    TriggerClientEvent("vfw:showNotification", sourcePlayer.source, {
        type = 'ROUGE',
        content = notificationKick
    })
    TriggerClientEvent("vfw:showNotification", targetPlayer.source, {
        type = 'ROUGE',
        content = notificationKickTarget
    })
    return newGradeName
end)
