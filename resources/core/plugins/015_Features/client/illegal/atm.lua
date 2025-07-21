InsideRobberyAtm = false
local pfx = nil
local AnimBillet = false
local melee = 0
local timerStop = 1
local CanAttackAtm = false
local ATMList = {
    -1364697528,
    -870868698,
    -1126237515,
    506770882
}

local function StartDropBillet(entity)
    local heading = GetEntityHeading(entity)

    RequestNamedPtfxAsset("scr_xs_celebration")
    while not HasNamedPtfxAssetLoaded("scr_xs_celebration") do
        Wait(10)
    end

    UseParticleFxAssetNextCall("scr_xs_celebration")
    pfx = StartParticleFxLoopedOnEntity("scr_xs_money_rain", entity, -0.1, -0.3, 0.75, -90.0, heading - 180.0, heading, 1.0, false, false, false)
end

local function CleanupATM()
    if pfx then
        StopParticleFxLooped(pfx, 0)
        pfx = nil
    end
    AnimBillet = false
    melee = 0
    InsideRobberyAtm = false
    HideStep()
end

local interactedATM = {}
local atmPoints2 = {}
local boucle = false

local function loadATM()
    CreateThread(function()
        while true do
            if IsPedArmed(VFW.PlayerData.ped, 1) then
                if VFW.CanAccessAction('racket_atm') then
                    for _, entity in pairs(GetGamePool("CObject")) do
                        local model = GetEntityModel(entity)
                        local objectPos = GetEntityCoords(entity)

                        if not atmPoints2[objectPos] then
                            if ATMList[model] then
                                atmPoints2[objectPos] = Worlds.Zone.Create(vector3(objectPos.x, objectPos.y, objectPos.z + 0.5), 2, false, function()
                                    VFW.RegisterInteraction("frapper", function()
                                        local policeMans = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

                                        if policeMans >= 0 then
                                            local isPlayerAlrdyBraked = TriggerServerCallback("core:atm:AlreadyRob")

                                            if not isPlayerAlrdyBraked then
                                                RequestAnimDict('pickup_object')
                                                while not HasAnimDictLoaded('pickup_object') do
                                                    Wait(10)
                                                end

                                                CanAttackAtm = true
                                                VFW.ShowNotification({
                                                    type = 'VERT',
                                                    content = "Vous commencez à voler l'ATM."
                                                })
                                                InsideRobberyAtm = true
                                                Worlds.Zone.Remove(interactedATM[atmId])
                                                VFW.RemoveInteraction(interactionId)
                                                interactedATM[atmId] = nil
                                                GoToSpecialStep(0)
                                            else
                                                VFW.ShowNotification({
                                                    type = 'ROUGE',
                                                    content = "Vous ne pouvez pas braquer l'ATM (Vous en avez déjà braqué un)"
                                                })
                                            end
                                        else
                                            VFW.ShowNotification({
                                                type = 'ROUGE',
                                                content = "Il n'y a pas assez de policiers en ville"
                                            })
                                        end
                                    end)
                                end, function()
                                    VFW.RemoveInteraction("frapper")
                                end, "Frapper", "G", "Banque")

                                if InsideRobberyAtm then
                                    timerStop = timerStop + 1
                                    if timerStop > 3000 or GetDistanceBetweenCoords(GetEntityCoords(VFW.PlayerData.ped), GetEntityCoords(atm)) > 20.0 then
                                        CleanupATM()
                                    end

                                    if IsPedPerformingMeleeAction(VFW.PlayerData.ped) then
                                        melee += 1
                                        if melee > 10 then
                                            Wait(1100)
                                            local plyPed = VFW.PlayerData.ped
                                            ClearPedTasksImmediately(plyPed)
                                            TaskPlayAnim(plyPed, "pickup_object", "pickup_low", 2.0, 2.0, -1, 31, 2.0, 0, 0, 0)
                                            Wait(500)
                                            PlaySound(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', 0, 0, 1)
                                            local money = math.random(80, 125)
                                            TriggerServerEvent("core:atm:AddMoney", money)
                                            VFW.ShowNotification({
                                                type = 'DOLLAR',
                                                content = ("Vous avez récupéré ~s %s$"):format(money)
                                            })
                                            Wait(500)
                                            ClearPedTasks(plyPed)
                                            Wait(200)
                                        else
                                            Wait(1200)
                                        end

                                        if melee >= 30 then
                                            CleanupATM()
                                            VFW.ShowNotification({
                                                type = 'ROUGE',
                                                content = "Le distributeur n'a plus de billets"
                                            })
                                        elseif melee > 10 and not AnimBillet then
                                            AnimBillet = true
                                            ActionInTerritoire(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), 5, 10, VFW.IsCoordsInSouth(GetEntityCoords(VFW.PlayerData.ped)))
                                            TriggerServerEvent('core:alert:makeCall', "lspd", GetEntityCoords(VFW.PlayerData.ped), true, "Braquage d'ATM", false, "illegal")
                                            TriggerServerEvent('core:alert:makeCall', "lssd", GetEntityCoords(VFW.PlayerData.ped), true, "Braquage d'ATM", false, "illegal")
                                            StartDropBillet(atm)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            Wait(5000)
        end
    end)
end

local lastJob = nil

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.type == "faction" then
        lastJob = nil
        boucle = false
        return
    end
    lastJob = Job.type
    boucle = true
    loadATM()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob == VFW.PlayerData.job.type then return end
    if VFW.PlayerData.job.type == "faction" then
        boucle = false
        return
    end
    boucle = true
    loadATM()
end)
