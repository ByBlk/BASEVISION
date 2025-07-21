GlobalState["reportCount"] = 0

local function minifyReport(report)
    local playerGlobal = VFW.GetPlayerGlobalFromId(report.player)
    return {
        id = report.id,
        player = {
            name = playerGlobal.pseudo,
            id = playerGlobal.id,
            source = report.player,
        },
        message = report.message,
        date = report.date,
        takenBy = report.takenBy
    }
end

local idReports = 1
local reports = {}
function VFW.CreateReport(message, player)
    local report = VFW.GetReportFromPlayer(player)
    if report then
        report.message = report.message .. " | " .. message
        return
    end
    reports[idReports] = VFW.CreateReportClass(idReports, player, message)
    local playerGlobal = VFW.GetPlayerGlobalFromId(player)
    for i = 1, #VFW.staffMode do
        TriggerClientEvent("vfw:showNotification", VFW.staffMode[i], {
            title = "["..playerGlobal.id.."] "..playerGlobal.pseudo,
            mainMessage = message,
            type = "INVITE_NOTIFICATION",
            duration = 10
        })
        TriggerClientEvent("vfw:staff:report", VFW.staffMode[i], minifyReport(reports[idReports]))
    end
    GlobalState["reportCount"] = GlobalState["reportCount"] + 1
    idReports += 1
end

function VFW.GetReportFromPlayer(playerId)
    for i = 1, idReports do
        if reports[i] and (reports[i].player == playerId) then
            return reports[i]
        end
    end
end

function VFW.GetReports()
    return reports
end

function VFW.GetReport(id)
    return reports[id]
end

function VFW.DeleteReport(id)
    for i = 1, #VFW.staffMode do
        TriggerClientEvent("vfw:staff:deleteReport", VFW.staffMode[i], id)
    end
    GlobalState["reportCount"] = GlobalState["reportCount"] - 1
    reports[id] = nil
end

function VFW.GetMinifiedReports()
    local minifiedReports = {}
    for i = 1, idReports do
        if reports[i] then
            table.insert(minifiedReports, minifyReport(reports[i]))
        end
    end
    return minifiedReports
end

function VFW.TakeReport(reportId, staffId)
    local report = reports[reportId]
    if not report then return false end
    
    local staffGlobal = VFW.GetPlayerGlobalFromId(staffId)
    if not staffGlobal then return false end
    
    report.takenBy = {
        id = staffId,
        name = staffGlobal.pseudo
    }
    
    local targetPlayer = VFW.GetPlayerFromId(report.player)
    
    if targetPlayer then
        local targetCoords = targetPlayer.getCoords()
        
        if report.player ~= staffId then
            local srcDim = GetPlayerRoutingBucket(staffId)
            local targetDim = GetPlayerRoutingBucket(report.player)

            if srcDim ~= targetDim then
                SetPlayerRoutingBucket(staffId, targetDim)
            end
        end

        TriggerClientEvent("vfw:staff:teleportToReport", staffId, targetCoords)
    end
    
    TriggerClientEvent("vfw:showNotification", staffId, {
        type = 'VERT',
        content = "Vous avez pris le report de " .. VFW.GetPlayerGlobalFromId(report.player).pseudo
    })
    
    TriggerClientEvent("vfw:showNotification", report.player, {
        type = 'VERT',
        content = "Votre report a été pris par " .. staffGlobal.pseudo
    })
    
    for i = 1, #VFW.staffMode do
        if VFW.staffMode[i] ~= staffId then
            TriggerClientEvent("vfw:showNotification", VFW.staffMode[i], {
                type = 'JAUNE',
                content = staffGlobal.pseudo .. " a pris le report de " .. VFW.GetPlayerGlobalFromId(report.player).pseudo
            })
        end
    end
    
    for i = 1, #VFW.staffMode do
        TriggerClientEvent("vfw:staff:updateReport", VFW.staffMode[i], minifyReport(report))
    end
    
    return true
end

RegisterCommand("report", function(source, args)
    local message = table.concat(args, " ")
    VFW.CreateReport(message, source)
    TriggerClientEvent("vfw:showNotification", source, {
        type = 'VERT',
        content = "Votre report a bien été envoyé."
    })
end)

RegisterNetEvent("vfw:staff:closeReport", function(playerId)
    local report = VFW.GetReportFromPlayer(playerId)

    if report then
        VFW.DeleteReport(report.id)
    end
    TriggerClientEvent("vfw:showNotification", playerId, {
        type = 'VERT',
        content = "Votre report a bien été supprimé."
    })
end)

RegisterNetEvent("vfw:staff:takeReport", function(reportId)
    local staffId = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(staffId)
    
    if not playerGlobal or not playerGlobal.permissions["staff_menu"] then
        return
    end
    
    VFW.TakeReport(reportId, staffId)
end)

AddEventHandler("playerDropped", function()
    local report = VFW.GetReportFromPlayer(source)

    if report then
        VFW.DeleteReport(report.id)
    end
end)
