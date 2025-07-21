local WEAPONS_ALLOWED <const> = {
    [GetHashKey('weapon_knife')] = true,
    [GetHashKey('weapon_switchblade')] = true,
    [GetHashKey('weapon_machete')] = true,
    [GetHashKey('weapon_dagger')] = true
}

local pedRobbed = {}
local pedpoints = {}
local CanRaquette = false
local stolenPaintings = {}
local fouillerPoint = nil

CreateThread(function()
    while not VFW.PlayerData or not VFW.PlayerData.job do
        Wait(1000)
    end

    while true do
        Wait(1)
        local playerPed = VFW.PlayerData.ped
        local playerCoords = GetEntityCoords(playerPed)
        local playerJob = VFW.PlayerData.job
        local isJobGood = playerJob and playerJob.type ~= "faction"
        local weapon = GetSelectedPedWeapon(playerPed)
        local hasGoodWeapon = WEAPONS_ALLOWED[weapon]
        local inCasino = #(playerCoords - vector3(2490.32, -264.024, -59.92385)) <= 100.0

        if not VFW.CanAccessAction('racket') then
            Wait(60000)
            goto continue
        end

        if not isJobGood or not hasGoodWeapon or inCasino or not IsPedArmed(playerPed, 1) then
            for k, _ in pairs(pedpoints) do
                Worlds.Zone.Remove(pedpoints[k])
                pedpoints[k] = nil
            end
            Wait(2000)
            goto continue
        end

        local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)
        if tonumber(policeNumber) > 0 then
            for k, _ in pairs(pedpoints) do
                Worlds.Zone.Remove(pedpoints[k])
                pedpoints[k] = nil
            end
            Wait(5000)
            goto continue
        end

        local _, hasBool = VFW.HasMultipleDrugs()
        if next(hasBool) then
            for k, _ in pairs(pedpoints) do
                Worlds.Zone.Remove(pedpoints[k])
                pedpoints[k] = nil
            end
            Wait(1000)
            goto continue
        end

         for _, ped in pairs(GetGamePool("CPed")) do
             if GetEntityPopulationType(ped) == 5 and GetEntityHealth(ped) ~= 0 and GetVehiclePedIsIn(ped, false) == 0 and DoesEntityExist(ped) then
                 local pedCoords = GetEntityCoords(ped)

                 if not pedRobbed[ped] and not IsEntityDead(ped) then
                     if not pedpoints[ped] and not stolenPaintings["racket:"..ped] then
                         pedpoints[ped] = Worlds.Zone.Create(vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.5), 1.25, false, function()
                             VFW.RegisterInteraction("racket", function()
                                 GoToSpecialStep(1)
                                 CanRaquette = true
                                 stolenPaintings["racket:"..ped] = true

                                 while CanRaquette do
                                     Wait(1)
                                     if IsControlJustPressed(0, 25) or IsPedInMeleeCombat(VFW.PlayerData.ped) == 1 and CanRaquette then
                                         local myLimitServ = TriggerServerCallback("core:illegal:getlimit", "racket") or 0
                                         if myLimitServ >= 5 then
                                             VFW.ShowNotification({
                                                 type = 'ROUGE',
                                                 content = "Vous avez atteint la limite de vols aujourd'hui"
                                             })
                                             for k, _ in pairs(pedpoints) do
                                                 Worlds.Zone.Remove(pedpoints[k])
                                                 pedpoints[k] = nil
                                             end
                                             return
                                         end

                                         VFW.RemoveInteraction("racket")
                                         if pedpoints[ped] then
                                             Worlds.Zone.Remove(pedpoints[ped])
                                             pedpoints[ped] = nil
                                         end

                                         pedRobbed[ped] = true

                                         RequestAnimDict("random@mugging4")
                                         while not HasAnimDictLoaded("random@mugging4") do Wait(1) end

                                         local p1 = GetEntityCoords(ped, true)
                                         local p2 = GetEntityCoords(playerPed, true)
                                         local dx = p2.x - p1.x
                                         local dy = p2.y - p1.y

                                         ActionInTerritoire(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), 15, 12, VFW.IsCoordsInSouth(GetEntityCoords(playerPed)))

                                         local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                                         local pedNewCoord = (coords + forward * 1.5)
                                         local heading = GetHeadingFromVector_2d(dx, dy)

                                         SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9))
                                         SetEntityHeading(ped, heading)

                                         local mathrand = math.random(1, 3)

                                         Wait(700)

                                         TriggerServerEvent('core:alert:makeCall', "lspd", GetEntityCoords(playerPed), true, "Racket", false, "illegal")
                                         TriggerServerEvent('core:alert:makeCall', "lssd", GetEntityCoords(playerPed), true, "Racket", false, "illegal") -- FIX_LSSD_LSPD

                                         HideStep()

                                         TriggerServerEvent("core:illegal:addlimit", "racket")

                                         if mathrand == 2 then
                                             PlayPain(ped, 5, 0.0)
                                             TaskSmartFleePed(ped, playerPed, 999.9, -1, true,true)
                                             GoToSpecialStep(2)
                                         elseif mathrand == 3 then
                                             SetEntityAsMissionEntity(ped, true,true)
                                             NetworkRequestControlOfEntity(ped)
                                             SetBlockingOfNonTemporaryEvents(ped, true)
                                             TaskCombatPed(ped, playerPed, 0, 16)
                                             SetPedCombatAttributes(ped, 5, true)
                                             SetPedCombatAttributes(ped, 13, true)
                                             GoToSpecialStep(3)
                                         else
                                             ClearPedTasksImmediately(ped)
                                             SetEntityAsMissionEntity(ped, true,true)
                                             NetworkRequestControlOfEntity(ped)
                                             SetBlockingOfNonTemporaryEvents(ped, true)
                                             Wait(200)
                                             PlayPain(ped, 5, 0.0)
                                             RequestAnimDict("random@domestic")
                                             while not HasAnimDictLoaded("random@domestic") do Wait(1) end
                                             TaskPlayAnim(ped, "random@domestic", "f_distressed_loop", 1.0, 1.0, -1, 1, 1.0)
                                         end

                                         Wait(2500)

                                         CanRaquette = false

                                         if mathrand == 1 then
                                             local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                                             local pedNewCoord = (coords + forward * 1.1)

                                             SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9))
                                             TaskPlayAnim(ped, "random@domestic", "f_distressed_loop", 1.0, 1.0, -1, 1, 1.0)
                                         end

                                         local showNotifFouille = true

                                         while true do
                                             Wait(1)

                                             if not DoesEntityExist(ped) then
                                                 HideStep()
                                                 break
                                             end

                                             if showNotifFouille then
                                                 if not IsPedFleeing(ped) then
                                                     if mathrand ~= 2 then
                                                         if not IsPedInCombat(ped, playerPed) then
                                                             if not fouillerPoint then
                                                                 fouillerPoint = Worlds.Zone.Create(GetEntityCoords(ped), 2, false, function()
                                                                     VFW.RegisterInteraction("fouiller", function()
                                                                         HideStep()

                                                                         if not IsEntityDead(ped) then
                                                                             local p1 = GetEntityCoords(ped, true)
                                                                             local p2 = GetEntityCoords(playerPed, true)
                                                                             local dx = p2.x - p1.x
                                                                             local dy = p2.y - p1.y
                                                                             local heading = GetHeadingFromVector_2d(dx, dy)

                                                                             SetEntityHeading(ped, heading)

                                                                             showNotifFouille = false

                                                                             local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                                                                             local pedNewCoord = (coords + forward * 1.0)

                                                                             SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9))

                                                                             RequestAnimDict('mp_common')
                                                                             while not HasAnimDictLoaded('mp_common') do Wait(1) end

                                                                             TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                             TaskPlayAnim(ped, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)

                                                                             VFW.RemoveInteraction("fouiller")
                                                                             if fouillerPoint then
                                                                                 Worlds.Zone.Remove(fouillerPoint)
                                                                                 fouillerPoint = nil
                                                                             end

                                                                             local moneyprop = GetHashKey("bkr_prop_money_sorted_01")

                                                                             TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                             TaskPlayAnim(ped, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)

                                                                             local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                             local bone = GetPedBoneIndex(ped, 28422)

                                                                             AttachEntityToEntity(moneyProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                             Wait(1000)

                                                                             DeleteEntity(moneyProp)

                                                                             local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                             local bone = GetPedBoneIndex(playerPed, 28422)

                                                                             AttachEntityToEntity(moneyProp, playerPed, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                             Wait(1000)

                                                                             DeleteEntity(moneyProp)

                                                                             local moneyGiven = math.floor(math.random(122, 453))

                                                                             VFW.ShowNotification({
                                                                                 type = 'JAUNE',
                                                                                 content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                             })

                                                                             Wait(500)

                                                                             ClearPedTasks(playerPed)
                                                                             ClearPedTasks(ped)

                                                                             TriggerServerEvent("core:addMoney", moneyGiven)

                                                                             TaskSmartFleePed(ped, playerPed, 999.9, -1, true,true)
                                                                         else
                                                                             mathrand = 0

                                                                             local moneyprop = GetHashKey("bkr_prop_money_sorted_01")

                                                                             showNotifFouille = false

                                                                             TaskStartScenarioInPlace(playerPed,'PROP_HUMAN_BUM_BIN')

                                                                             VFW.RemoveInteraction("fouiller")
                                                                             if fouillerPoint then
                                                                                 Worlds.Zone.Remove(fouillerPoint)
                                                                                 fouillerPoint = nil
                                                                             end

                                                                             Wait(500)

                                                                             local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                             local bone = GetPedBoneIndex(playerPed, 28422)

                                                                             AttachEntityToEntity(moneyProp, playerPed, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                             Wait(1000)

                                                                             DeleteEntity(moneyProp)

                                                                             local moneyGiven = math.floor(math.random(122, 453))

                                                                             VFW.ShowNotification({
                                                                                 type = 'JAUNE',
                                                                                 content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                             })

                                                                             Wait(1000)

                                                                             ClearPedTasks(playerPed)

                                                                             TriggerServerEvent("core:addMoney", moneyGiven)
                                                                         end
                                                                     end)
                                                                 end, function()
                                                                     VFW.RemoveInteraction("fouiller")
                                                                 end, "Fouiller", "E", "vente")
                                                             elseif fouillerPoint then
                                                                 Worlds.Zone.UpdateCoords(fouillerPoint, GetEntityCoords(ped))
                                                             end
                                                         end
                                                     end
                                                 end
                                                 if IsEntityDead(ped) then
                                                     if not fouillerPoint then
                                                         fouillerPoint = Worlds.Zone.Create(GetEntityCoords(ped), 2, false, function()
                                                             VFW.RegisterInteraction("fouiller", function()
                                                                 HideStep()

                                                                 if not IsEntityDead(ped) then
                                                                     local p1 = GetEntityCoords(ped, true)
                                                                     local p2 = GetEntityCoords(playerPed, true)
                                                                     local dx = p2.x - p1.x
                                                                     local dy = p2.y - p1.y
                                                                     local heading = GetHeadingFromVector_2d(dx, dy)

                                                                     SetEntityHeading(ped, heading)

                                                                     showNotifFouille = false

                                                                     local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                                                                     local pedNewCoord = (coords + forward * 1.0)

                                                                     SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9))

                                                                     RequestAnimDict('mp_common')
                                                                     while not HasAnimDictLoaded('mp_common') do Wait(1) end

                                                                     TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                     TaskPlayAnim(ped, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)

                                                                     VFW.RemoveInteraction("fouiller")
                                                                     if fouillerPoint then
                                                                         Worlds.Zone.Remove(fouillerPoint)
                                                                         fouillerPoint = nil
                                                                     end

                                                                     local moneyprop = GetHashKey("bkr_prop_money_sorted_01")

                                                                     TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                     TaskPlayAnim(ped, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)

                                                                     local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                     local bone = GetPedBoneIndex(ped, 28422)

                                                                     AttachEntityToEntity(moneyProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                     Wait(1000)

                                                                     DeleteEntity(moneyProp)

                                                                     local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                     local bone = GetPedBoneIndex(playerPed, 28422)

                                                                     AttachEntityToEntity(moneyProp, playerPed, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                     Wait(1000)

                                                                     DeleteEntity(moneyProp)

                                                                     local moneyGiven = math.floor(math.random(122, 453))

                                                                     VFW.ShowNotification({
                                                                         type = 'JAUNE',
                                                                         content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                     })

                                                                     Wait(500)

                                                                     ClearPedTasks(playerPed)
                                                                     ClearPedTasks(ped)

                                                                     TriggerServerEvent("core:addMoney", moneyGiven)

                                                                     TaskSmartFleePed(ped, playerPed, 999.9, -1, true,true)
                                                                 else
                                                                     mathrand = 0

                                                                     local moneyprop = GetHashKey("bkr_prop_money_sorted_01")

                                                                     showNotifFouille = false

                                                                     TaskStartScenarioInPlace(playerPed,'PROP_HUMAN_BUM_BIN')

                                                                     VFW.RemoveInteraction("fouiller")
                                                                     if fouillerPoint then
                                                                         Worlds.Zone.Remove(fouillerPoint)
                                                                         fouillerPoint = nil
                                                                     end

                                                                     Wait(500)

                                                                     local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                     local bone = GetPedBoneIndex(playerPed, 28422)

                                                                     AttachEntityToEntity(moneyProp, playerPed, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

                                                                     Wait(1000)

                                                                     DeleteEntity(moneyProp)

                                                                     local moneyGiven = math.floor(math.random(122, 453))

                                                                     VFW.ShowNotification({
                                                                         type = 'JAUNE',
                                                                         content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                     })

                                                                     Wait(1000)

                                                                     ClearPedTasks(playerPed)

                                                                     TriggerServerEvent("core:addMoney", moneyGiven)
                                                                 end
                                                             end)
                                                         end, function()
                                                             VFW.RemoveInteraction("fouiller")
                                                         end, "Fouiller", "E", "vente")
                                                     elseif fouillerPoint then
                                                         Worlds.Zone.UpdateCoords(fouillerPoint, GetEntityCoords(ped))
                                                     end
                                                 end
                                             end
                                         end
                                     end
                                 end
                             end)
                         end, function()
                             VFW.RemoveInteraction("racket")
                         end, "Racketter", "E", "vente")
                     elseif pedpoints[ped] then
                         Worlds.Zone.UpdateCoords(pedpoints[ped], vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.5))
                     end
                 else
                     if pedpoints[ped] then
                         Worlds.Zone.Remove(pedpoints[ped])
                         pedpoints[ped] = nil
                     end
                 end
             else
                 if pedpoints[ped] then
                     Worlds.Zone.Remove(pedpoints[ped])
                     pedpoints[ped] = nil
                 end
             end
         end

        for ped, _ in pairs(pedpoints) do
            if not DoesEntityExist(ped) then
                Worlds.Zone.Remove(pedpoints[ped])
                pedpoints[ped] = nil
            end
        end

        ::continue::
    end
end)
