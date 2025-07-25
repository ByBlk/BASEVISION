local pedpoints = {}
local pedRobbed = {}
local playerpoint = nil
local sacs = {
    "vw_prop_casino_shopping_bag_01a",
    "prop_ld_handbag",
    "prop_shopping_bags01",
}
local items = {
    "jewel",
    "perfume",
    "enceinte",
    "manettejv",
    "weapon_bouteille",
    "guitar",
    "bouteille2",
    "champagne_pack",
    "money",
    "coke",
    "weed",
    "cig",
    "can",
    "penden",
    "penden2",
    "pince",
}

local function SetupMuggingAnimations(playerPed, ped)
    RequestAnimDict("random@mugging4")
    while not HasAnimDictLoaded("random@mugging4") do Wait(1) end

    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(playerPed, true)
    ClearPedTasksImmediately(playerPed)
    ClearPedTasksImmediately(ped)

    local p1 = GetEntityCoords(playerPed, true)
    local p2 = GetEntityCoords(ped, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local headingPlayer = GetHeadingFromVector_2d(dx, dy)

    SetEntityHeading(playerPed, headingPlayer)

    local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local pedNewCoord = (coords + forward * 2.0)
    SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9))

    local p1 = GetEntityCoords(ped, true)
    local p2 = GetEntityCoords(playerPed, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)

    SetEntityHeading(ped, heading)
    SetEntityHeading(playerPed, headingPlayer)

    local newcoords = GetOffsetFromEntityInWorldCoords(ped, -0.3, 0.0, 0.0)
    SetEntityCoords(ped, newcoords - vec3(0.0, 0.0, 0.9))

    TaskPlayAnim(playerPed, "random@mugging4", "struggle_loop_b_thief", 1.0, 1.0, -1, 1, 1.0)
    TaskPlayAnim(ped, "random@mugging4", "struggle_loop_b_thief", 1.0, 1.0, -1, 1, 1.0)
    PlayPain(ped, 6)
end

local function CreateAndAttachBag(playerPed)
    local obj = cEntity.Manager:CreateObject(sacs[math.random(1, #sacs)], GetEntityCoords(playerPed))
    AttachEntityToEntity(obj:getEntityId(), playerPed, GetEntityBoneIndexByName(playerPed, "IK_R_Hand"), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, false, false, false, false, 0.0, true)
    return obj
end

local function HandleSuccessfulMugging(playerPed, ped, obj, crew, zone, isInSouth, varArrache)
    local multiplication = isInSouth and 1 or varArrache.XPNorthMultiplication

    TriggerServerEvent("core:crew:updateXp", token, tonumber(varArrache.xp * multiplication) or 5, "add", crew, "vol arrache")

    VFW.ShowNotification({
        type = 'VERT',
        content = "T'as récupéré le sac, cours !"
    })

    SetEntityVisible(obj:getEntityId(), true)
    AttachEntityToEntity(obj:getEntityId(), playerPed, GetEntityBoneIndexByName(playerPed, "IK_R_Hand"), 0.0, 0.0, 0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)

    Wait(5000)

    local showBulle = true

    while showBulle do
        Wait(1)
        if not playerpoint then
            playerpoint = Worlds.Zone.Create(GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9), 2, false, function()
                VFW.RegisterInteraction("fouiller", function()
                    showBulle = false
                    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN')
                    VFW.RemoveInteraction("fouiller")
                    if playerpoint then
                        Worlds.Zone.Remove(playerpoint)
                        playerpoint = nil
                    end
                    Wait(4000)
                    ClearPedTasks(playerPed)
                    for i = 1, math.random(4, 6) do
                        TriggerServerEvent("core:addItemToInventory", BLK.arache.items[math.random(1, #BLK.arache.items)], 1)
                    end
                    VFW.ShowNotification({
                        type = 'JAUNE',
                        content = "Vous avez fouillé le sac"
                    })
                    obj:delete()
                end)
            end, function()
                VFW.RemoveInteraction("fouiller")
            end, "Fouiller", "E", "vente")
        elseif playerpoint then
            Worlds.Zone.UpdateCoords(playerpoint, GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9))
        end
    end

    VFW.RemoveInteraction("fouiller")
    if playerpoint then
        Worlds.Zone.Remove(playerpoint)
        playerpoint = nil
    end
end

local function HandleFleeScenario(playerPed, ped, obj, crew, isInSouth, varArrache)
    DetachEntity(obj:getEntityId())
    AttachEntityToEntity(obj:getEntityId(), ped, GetEntityBoneIndexByName(ped, "IK_R_Hand"), 0.0, 0.0, 0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)
    PlayPain(ped, 5, 0.0)
    TaskSmartFleePed(ped, playerPed, 999.9, -1, true, true)

    OpenStepCustom("Vol à l'arraché", "Rattrape la personne et frappe là pour la mettre au sol")
    SetTimeout(7500, function()
        HideStep()
    end)

    local reussi = false

    while true do
        Wait(1)

        if not DoesEntityExist(ped) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(ped)) > 50.0 then
            reussi = false
            break
        end

        if GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(ped)) < 2.0 and IsPedDeadOrDying(ped) then
            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN')
            Wait(4000)
            ClearPedTasks(playerPed)
            reussi = true
            break
        end
    end

    if reussi then
        local multiplication = isInSouth and 1 or varArrache.XPNorthMultiplication
        TriggerServerEvent("core:crew:updateXp", token, tonumber(varArrache.xp * multiplication) or 50, "add", crew, "vol arrache")
        DetachEntity(obj:getEntityId())
        AttachEntityToEntity(obj:getEntityId(), playerPed, GetEntityBoneIndexByName(playerPed, "IK_R_Hand"), 0.0, 0.0, 0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)

        local showBulle = true

        while showBulle do
            Wait(1)
            if not playerpoint then
                playerpoint = Worlds.Zone.Create(GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9), 2, false, function()
                    VFW.RegisterInteraction("fouiller", function()
                        showBulle = false
                        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN')
                        VFW.RemoveInteraction("fouiller")
                        if playerpoint then
                            Worlds.Zone.Remove(playerpoint)
                            playerpoint = nil
                        end
                        Wait(4000)
                        ClearPedTasks(playerPed)
                        for i = 1, math.random(4, 6) do
                            TriggerServerEvent("core:addItemToInventory", BLK.arache.items[math.random(1, #BLK.arache.items)], 1)
                        end
                        VFW.ShowNotification({
                            type = 'JAUNE',
                            content = "Vous avez fouillé le sac"
                        })
                        obj:delete()
                    end)
                end, function()
                    VFW.RemoveInteraction("fouiller")
                end, "Fouiller", "E", "vente")
            elseif playerpoint then
                Worlds.Zone.UpdateCoords(playerpoint, GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9))
            end
        end

        VFW.RemoveInteraction("fouiller")
        if playerpoint then
            Worlds.Zone.Remove(playerpoint)
            playerpoint = nil
        end
    end

    HideStep()
end

local function HandlePhoneScenario(playerPed, ped, obj, crew, isInSouth, varArrache)
    AttachEntityToEntity(obj:getEntityId(), playerPed, GetEntityBoneIndexByName(playerPed, "IK_R_Hand"), 0.0, 0.0, 0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)

    local multiplication = isInSouth and 1 or varArrache.XPNorthMultiplication
    TriggerServerEvent("core:crew:updateXp", token, tonumber(varArrache.xp * multiplication) or 10, "add", crew, "vol arrache")

    VFW.ShowNotification({
        type = 'VERT',
        content = "T'as récupéré le sac, cours !"
    })

    TriggerServerEvent("core:Alert:cops",GetEntityCoords(playerPed), true, "Vol à l'arraché", false, "illegal")
    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do Wait(1) end
    TaskPlayAnim(ped, 'cellphone@', 'cellphone_call_listen_base', 1.0, 1.0, -1, 49, 1.0)

    local phoneModel = `prop_amb_phone`
    RequestModel(phoneModel)
    while not HasModelLoaded(phoneModel) do Wait(1) end

    local phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
    local bone = GetPedBoneIndex(ped, 28422)
    AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    TaskSmartFleePed(ped, playerPed, 999.9, -1, true, true)

    Wait(5000)
    DeleteEntity(phoneProp)

    local showBulle = true

    while showBulle do
        Wait(1)
        if not playerpoint then
            playerpoint = Worlds.Zone.Create(GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9), 2, false, function()
                VFW.RegisterInteraction("fouiller", function()
                    showBulle = false
                    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN')
                    VFW.RemoveInteraction("fouiller")
                    if playerpoint then
                        Worlds.Zone.Remove(playerpoint)
                        playerpoint = nil
                    end
                    Wait(4000)
                    ClearPedTasks(playerPed)
                    for i = 1, math.random(4, 6) do
                        TriggerServerEvent("core:addItemToInventory", BLK.arache.items[math.random(1, #BLK.arache.items)], 1)
                    end
                    VFW.ShowNotification({
                        type = 'JAUNE',
                        content = "Vous avez fouillé le sac"
                    })
                    obj:delete()
                end)
            end, function()
                VFW.RemoveInteraction("fouiller")
            end, "Fouiller", "E", "vente")
        elseif playerpoint then
            Worlds.Zone.UpdateCoords(playerpoint, GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.9))
        end
    end

    VFW.RemoveInteraction("fouiller")
    if playerpoint then
        Worlds.Zone.Remove(playerpoint)
        playerpoint = nil
    end
end

local function StartMuggingScenario(playerPed, ped, crew, zone, isInSouth, varArrache)
    local myLimitServ = TriggerServerCallback("core:illegal:getlimit", "racket_bags") or 0

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

    pedRobbed[ped] = true
    local obj = CreateAndAttachBag(playerPed)
    SetupMuggingAnimations(playerPed, ped)

    ActionInTerritoire(crew, zone, tonumber(varArrache.influence) or 10, 5, isInSouth)
    TriggerServerEvent("core:illegal:addlimit", "racket_bags")

    SetPedComponentVariation(ped, 8, -1, 0)

    VFW.RemoveInteraction("snatching")
    if pedpoints[ped] then
        Worlds.Zone.Remove(pedpoints[ped])
        pedpoints[ped] = nil
    end

    local randomize = math.random(1, 3)

    Wait(3000)
    PlayPain(ped, 5)
    Wait(2000)
    PlayPain(ped, 7)
    Wait(2000)

    StopAnimTask(playerPed, "random@mugging4", "struggle_loop_b_thief", 1.0)
    StopAnimTask(ped, "random@mugging4", "struggle_loop_b_thief", 1.0)
    Wait(500)
    DetachEntity(obj:getEntityId())
    Wait(100)

    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(playerPed, false)

    if randomize == 1 then -- FRAPPE
        TaskCombatPed(ped, playerPed, 0, 16)

        OpenStepCustom("Vol à l'arraché", "Frappe la personne pour la mettre au sol")
        SetTimeout(7500, function()
            HideStep()
        end)

        local reussi = false

        while true do
            Wait(1)

            if not DoesEntityExist(ped) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(ped)) > 50.0 then
                reussi = false
                break
            end

            if GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(ped)) < 2.0 and IsPedDeadOrDying(ped) then
                TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN')
                Wait(4000)
                ClearPedTasks(playerPed)
                reussi = true
                break
            end
        end

        if reussi then
            HandleSuccessfulMugging(playerPed, ped, obj, crew, zone, isInSouth, varArrache)
        end
    elseif randomize == 2 then -- FUIS
        HandleFleeScenario(playerPed, ped, obj, crew, isInSouth, varArrache)
    else
        HandlePhoneScenario(playerPed, ped, obj, crew, isInSouth, varArrache)
    end

    HideStep()
end

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
        local inCasino = #(playerCoords - vector3(2490.32, -264.024, -59.92385)) <= 100.0

        if not VFW.CanAccessAction('racket_bags') then
            Wait(60000)
            goto continue
        end

        -- Vérifier si le joueur est dans un crew
        local playerFaction = VFW.PlayerData.faction
        if not playerFaction or not playerFaction.name or playerFaction.name == "" then
            for k, _ in pairs(pedpoints) do
                Worlds.Zone.Remove(pedpoints[k])
                pedpoints[k] = nil
            end
            goto continue
        end

        if not isJobGood or inCasino or weapon ~= GetHashKey("weapon_unarmed") then
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

                if not pedRobbed[ped] and not IsPedMale(ped) and not IsEntityDead(ped) then
                    if not pedpoints[ped] then
                        pedpoints[ped] = Worlds.Zone.Create(vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.5), 2, false, function()
                            VFW.RegisterInteraction("snatching", function()
                                print(VFW.PlayerData.faction.name)
                                local varArrache =  { limit = "5", winMax = "400", XPNorthMultiplication = "1.5", xp = "100", winMin = "200", rebootLimit = "10", cops = "2", influence = "5", active = "true" }
                                StartMuggingScenario(playerPed, ped, VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), VFW.IsCoordsInSouth(GetEntityCoords(playerPed)), varArrache)
                            end)
                        end, function()
                            VFW.RemoveInteraction("snatching")
                        end, "Arracher", "E", "vente")
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
