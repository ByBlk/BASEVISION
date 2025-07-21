local alerteTable = {}

RegisterNetEvent("core:alert:callIncoming")
AddEventHandler("core:alert:callIncoming", function(job, pos, targetData, msg, type)
    local posPlayer = GetEntityCoords(VFW.PlayerData.ped)
    local pointA = vector3(posPlayer.x, posPlayer.y, posPlayer.x)
    local pointB = vector3(pos.x, pos.y, pos.x)
    local dist = CalculateTravelDistanceBetweenPoints(pointA.x, pointA.y, pointA.z, pointB.x, pointB.y, pointB.z)
    local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
    local title = "Centrale"
    if job == "lspd" then
        title = "POLICE"
    elseif job == "sams" then
        title = "SAMS"
    elseif job == "lssd" then
        title = "SHERIFF"
    elseif job == "lsfd" then
        title = "POMPIERS"
    elseif job == "usss" then
        title = "SECURITE"
    end

    VFW.ShowNotification({
        type = 'ALERTEJOBS',
        jobicon = './police.svg',
        title = targetData.name ~= '' and title or "CENTRALE",
        content = msg or '',
        name = msg or '',
        adress = streetName,
        duration = 10,
        distance = math.ceil(dist),
    })

    table.insert(alerteTable, {
        job = job,
        hour = GlobalState.OsDateHM,
        name = targetData.name ~= '' and targetData.name or "Inconnu(e)",
        street = streetName,
        mess = msg or '',
        pos = pos,
        targetData = targetData,
        type = type
    })

    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)

    if msg and string.find(msg, "PANIC") then
        CreateThread(function()
            for _ = 1, 2 do
                Wait(500)
                PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
            end
        end)
    end

    local timer = GetGameTimer() + 10000

    while true do
        if GetGameTimer() > timer then
            VFW.RemoveNotification()
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous avez ~s ignoré l'appel"
            })
            return
        elseif IsControlJustPressed(0, 246) then
            if type == "illegal" then
                VFW.RemoveNotification()
                TriggerServerEvent('core:alert:callAccept', job, pos, targetData, "illegal")
            elseif type == "drugs" then
                VFW.RemoveNotification()
                TriggerServerEvent('core:alert:callAccept', job, pos, targetData, "drugs")
            else
                VFW.RemoveNotification()
                TriggerServerEvent('core:alert:callAccept', job, pos, targetData)
            end
            return
        elseif IsControlJustPressed(0, 306) then
            VFW.RemoveNotification()
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous avez ~s refusé l'appel"
            })
            return
        end

        Wait(0)
    end
end)

local blips = nil
local call = false

RegisterNetEvent("core:alert:callAccepted")
AddEventHandler("core:alert:callAccepted", function(pos, type)
    CreateThread(function()
        SetWaypointOff()
        if type == "drugs" then
            local random = math.random(100, 300.0)
            local random2 = math.random(1, 4)

            if random2 == 1 then
                pos = vector3(pos.x + random, pos.y + random, pos.z + random)
            elseif random2 == 2 then
                pos = vector3(pos.x + random, pos.y - random, pos.z + random)
            elseif random2 == 3 then
                pos = vector3(pos.x - random, pos.y + random, pos.z + random)
            else
                pos = vector3(pos.x - random, pos.y - random, pos.z + random)
            end
            if blips then
                RemoveBlip(blips)
                blips = nil
            end
            blips = AddBlipForRadius(pos, 500.0)
            SetBlipSprite(blips, 9)
            SetBlipColour(blips, 1)
            SetBlipAlpha(blips, 100)
            Wait(5 * 60000)
            RemoveBlip(blips)
        else
            if call then
                RemoveBlip(blips)
                call = false
            end
            blips = AddBlipForCoord(pos)
            call = true
            SetBlipRoute(blips, true)
            VFW.ShowNotification({
                type = 'VERT',
                content = "Vous avez ~s pris l'appel"
            })

            while true do
                Wait(1000)
                if #(pos.xyz - GetEntityCoords(VFW.PlayerData.ped)) < 10.0 then
                    RemoveBlip(blips)
                    return
                end
            end
        end
    end)
end)

RegisterNetEvent("core:alert:takeCall")
AddEventHandler("core:alert:takeCall", function(type)
    if type == 'noAnswer' then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Personne ne peut venir actuellement"
        })
    elseif type == 'callAlrdyActive' then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = '~s Veuillez rappeler dans quelques instants'
        })
    elseif type == "callTake" then
        VFW.ShowNotification({
            type = 'CLOCHE',
            content = "~s Quelqu'un arrive !"
        })
    end
end)

function MakeRenfortCall()
    if VFW.PlayerData.job.onDuty and VFW.PlayerData.job.type == "faction" then
        print("renfort")
        TriggerServerEvent('core:alert:makeCall', VFW.PlayerData.job.name, GetEntityCoords(VFW.PlayerData.ped),
                false, "Appel de renfort (" .. VFW.PlayerData.lastName .. " " .. VFW.PlayerData.firstName .. ")")
    end
end

function MakePanicCall()
    if VFW.PlayerData.job.onDuty and VFW.PlayerData.job.type == "faction" then
        TriggerServerEvent('core:alert:makeCall', VFW.PlayerData.job.name, GetEntityCoords(VFW.PlayerData.ped),
                false, "PANIC BUTTON (" .. VFW.PlayerData.lastName .. " " .. VFW.PlayerData.firstName .. ")")
        TriggerServerEvent('core:createDispatchCallOnMDT', VFW.PlayerData.job.label,
                "PANIC BUTTON (" ..VFW.PlayerData.lastName .. " " .. VFW.PlayerData.firstName .. ")", GetEntityCoords(VFW.PlayerData.ped))
    end
end

RegisterKeyMapping("+MakeRenfortCall", "Faire un appel de renfort", "keyboard", "F2")
RegisterCommand("+MakeRenfortCall", function()
    MakeRenfortCall()
end)

local lastJob = nil

local function loadAlertMenu()
    if not lastJob then return end

    local open = false
    local mainmenu = xmenu.create({ subtitle = "Historique des appels", banner = ("https://cdn.eltrane.cloud/alkiarp/assets/catalogues/headers/header_%s.webp"):format(lastJob) })

    local function OpenAlerteMenu()
        if open then
            open = false
            xmenu.render(false)
        else
            open = true
            CreateThread(function()
                xmenu.render(mainmenu)

                while open do
                    xmenu.items(mainmenu, function()
                        if next(alerteTable) then
                            if call then
                                addButton("Annuler le dernier appel", {}, {
                                    onSelected = function()
                                        if call then
                                            RemoveBlip(blips)
                                            call = false
                                        end
                                    end
                                })
                            else
                                addButton("Aucun dernier appel", {}, {})
                            end

                            for k, v in ipairs(alerteTable) do
                                if k >= #alerteTable - 8 and k <= #alerteTable then
                                    addButton("[" .. v.hour .. "] " .. v.mess .. " " .. v.street, {}, {
                                        onSelected = function()
                                            if v.type == "illegal" then
                                                TriggerServerEvent('core:alert:callAccept', v.job, v.pos, v.targetData, "illegal")
                                            elseif v.type == "drugs" then
                                                TriggerServerEvent('core:alert:callAccept', v.job, v.pos, v.targetData, "drugs")
                                            else
                                                TriggerServerEvent('core:alert:callAccept', v.job, v.pos, v.targetData)
                                            end
                                            VFW.ShowNotification({
                                                type = 'CLOCHE',
                                                content = "Vous avez pris l'appel"
                                            })
                                        end
                                    })
                                end
                            end
                        else
                            addButton("Aucun appel", {}, {})
                        end

                        onClose(function()
                            open = false
                            xmenu.render(false)
                        end)
                    end)

                    Wait(500)
                end
            end)
        end
    end

    RegisterKeyMapping("+OpenAlerteMenu", "Menu appels", "keyboard", "F4")
    RegisterCommand("+OpenAlerteMenu", function()
        if VFW.PlayerData.job.onDuty and VFW.PlayerData.job.type == "faction" then
            OpenAlerteMenu()
        end
    end)
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    loadAlertMenu()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then lastJob = nil end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadAlertMenu()
end)
