local callActive = {}

MySQL.ready(function()
    while not next(VFW.Jobs) do Wait(0) end
    for _, v in pairs(VFW.Jobs) do
        if v.type == "faction" then
            callActive[v.name] = { target = {} }
        end
    end
end)

RegisterNetEvent("core:alert:makeCall")
AddEventHandler("core:alert:makeCall", function(job, pos, isPnjCall, msg, sonnette, type)
    if not job then return end
    -- Initialiser callActive[job] s'il n'existe pas
    if not callActive[job] then
        callActive[job] = { target = {} }
    end

    local source = source
    if not source then return end
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if not isPnjCall then
        if callActive[job].target and callActive[job].target.id == source then
            if type ~= "illegal" then
                TriggerClientEvent('core:alert:takeCall', callActive[job].target.id, 'callAlrdyActive')
                return
            end
        end

        callActive[job].target = {
            id = source
        }

        SetTimeout(60000, function()
            -- Vérifier que callActive[job] existe encore
            if callActive[job] and callActive[job].target and next(callActive[job].target) then
                if type ~= 'illegal' then
                    TriggerClientEvent('core:alert:takeCall', callActive[job].target.id, 'noAnswer')
                    callActive[job].target = {}
                end
            end
        end)
    else
        callActive[job].target = {
            id = source
        }
    end

    if sonnette then
        local label = "Inconnu"

        for _, v in pairs(VFW.Jobs) do
            if v.name == job then
                label = v.label
                break
            end
        end

        if callActive[job].target and callActive[job].target.id then
            local xTarget = VFW.GetPlayerFromId(callActive[job].target.id)
            if xTarget then
                xTarget.showNotification({
                    type = 'CLOCHE',
                    content = "Vous venez d'appeler l'entreprise : ~s" .. label
                })
            end
        end
    end

    local id = VFW.GetPlayersWithJobs(job)

    if callActive[job] and callActive[job].target then
        for _, playerId in ipairs(id) do
            TriggerClientEvent("core:alert:callIncoming", playerId, job, pos, callActive[job].target, msg, type)
        end
    end
end)

RegisterNetEvent("core:alert:callAccept")
AddEventHandler("core:alert:callAccept", function(job, pos, targetData, type)
    local source = source
    if not source then return end
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end

    if not job then return end

    -- Initialiser callActive[job] s'il n'existe pas
    if not callActive[job] then
        callActive[job] = { target = {} }
    end

    local isPnj = false

    if callActive[job].target and callActive[job].target.name == 'Inconnu(e)' then
        isPnj = true
    end

    callActive[job].target = {}

    TriggerClientEvent("core:alert:callAccepted", source, pos, type)

    if type == "drugs" or type == "illegal" then return end

    if not isPnj then
        if callActive[job] and callActive[job].target and not next(callActive[job].target) then
            if type == nil and targetData and targetData.id then
                TriggerClientEvent('core:alert:takeCall', targetData.id, 'callTake')
            end
        end
    end
end)

CreateThread(function()
    GlobalState.OsDateHM = os.date("%H:%M")
    while true do
        Wait(30000)
        GlobalState.OsDateHM = os.date("%H:%M")
    end
end)
