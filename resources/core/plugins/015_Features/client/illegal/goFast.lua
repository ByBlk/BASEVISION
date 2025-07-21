local peds = {}
local inMission = false
local bagPoints = {}
local vehPoint = nil
local bagPoint = nil
local bagPoint2 = nil

local function PlayAnim(dict, anim, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(1) end
    TaskPlayAnim(VFW.PlayerData.ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    RemoveAnimDict(dict)
end

local function CreateMissionGoFast(data)
    inMission = true
    local take = false
    local random = math.random(1, #data.mission)
    local firstSms = false
    local finishMess = false
    local secondMess = false
    local veh = nil
    local objectCreated = false
    local thirdMessage = false
    local payMess = false
    local index = 1
    local object = {}
    local recup = 0
    local pedsLiraison = nil
    local HaveBag = false
    local TextLast = false
    local vehLivraison = nil
    local bag = nil
    local notif = {}
    local flic1 = false
    local flic2 = false
    local pay = false
    local payed = false
    local props = {
        offset = { 0.449, 0.02, -0.041, 3.1, -88.09, 0.0 }
    }

    while inMission do
        local pNear = false

        if not firstSms then
            firstSms = true
            TriggerServerEvent("gofast:firstSms", vector2(data.mission[random].vehicle.pos.x, data.mission[random].vehicle.pos.y))
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].vehicle.pos.xyz) <= 50 and not secondMess then
            if not data.mission[random].vehicle.create then
                data.mission[random].vehicle.create = true
                TriggerServerEvent("gofast:spawnVehicle", data.mission[random].vehicle.model, data.mission[random].vehicle.pos, data.mission[random].vehicle.pos.w)
            end

            if IsPedSittingInVehicle(VFW.PlayerData.ped, veh) then
                if not secondMess then
                    secondMess = true
                    TriggerServerEvent("gofast:secondSms", vector2(data.mission[random].loot[1].x, data.mission[random].loot[1].y))
                end
            end
            pNear = true
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].loot[1].xyz) <= 50 then
            if not objectCreated then
                objectCreated = true
                for i = 1, #data.mission[random].loot do
                    notif[i] = false
                    local _, groundZ = GetGroundZFor_3dCoord(data.mission[random].loot[i].x, data.mission[random].loot[i].y, data.mission[random].loot[i].z, false);
                    object[i] = cEntity.Manager:CreateObject("prop_money_bag_01", vector3(data.mission[random].loot[i].x, data.mission[random].loot[i].y, groundZ))
                    object[i]:setFreeze(true)
                end
            end

            if objectCreated then
                for i = 1, #object do
                    if not notif[i] then
                        notif[i] = true
                        if not bagPoints[object[i].id] then
                            bagPoints[object[i].id] = Worlds.Zone.Create(vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 0.50), 2, false, function()
                                VFW.RegisterInteraction("bagGofast", function()
                                    if not take then
                                        take = true
                                        PlayAnim("pickup_object", "pickup_low", 0)
                                        Wait(1000)
                                        AttachEntityToEntity(object[i]:getEntityId(), VFW.PlayerData.ped, GetEntityBoneIndexByName(VFW.PlayerData.ped, "IK_R_Hand"), props.offset[1], props.offset[2], props.offset[3], props.offset[4], props.offset[5], props.offset[6], false, false, false, false, 0.0, true)
                                        index = i

                                        VFW.RemoveInteraction("bagGofast")
                                        if bagPoints[object[i].id] then
                                            Worlds.Zone.Remove(bagPoints[object[i].id])
                                            bagPoints[object[i].id] = nil
                                        end

                                        if recup == 0 and take and not flic1 then
                                            flic1 = true
                                            TriggerServerEvent('core:alert:makeCall', "lssd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false,"illegal")
                                            TriggerServerEvent('core:alert:makeCall', "lspd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false,"illegal") -- FIX_LSSD_LSPD
                                        end
                                    else
                                        VFW.ShowNotification({
                                            type = 'ROUGE',
                                            content = "~s Impossible de ramasser, ~c vous avez déjà quelque choses dans les mains"
                                        })
                                    end
                                end)
                            end, function()
                                VFW.RemoveInteraction("bagGofast")
                            end, "Ramasser", "E", "Barber")
                        end
                    end
                end
            end
        end

        if recup == #data.mission[random].loot then
            if not thirdMessage then
                thirdMessage = true
                TriggerServerEvent("gofast:thirdSms", vector2(data.mission[random].livraison.peds.x, data.mission[random].livraison.peds.y))
                SetVehicleDoorShut(veh, 5, false, false)
            end
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.peds.xyz) <= 100 then
            pNear = true
            if not data.mission[random].livraison.create then
                data.mission[random].livraison.create = true
                pedsLiraison = cEntity.Manager:CreatePedLocal(data.mission[random].livraison.model, vector3(data.mission[random].livraison.peds.x, data.mission[random].livraison.peds.y, data.mission[random].livraison.peds.z), data.mission[random].livraison.peds.w)
                pedsLiraison:setScenario("WORLD_HUMAN_DRUG_DEALER", -1, true)
                pedsLiraison:setInvincible(true)
                pedsLiraison:setFreeze(true)

                local tableVeh = cEntity.Manager:CreateVehicleLocal(data.mission[random].livraison.veh, vector3(data.mission[random].livraison.car.x, data.mission[random].livraison.car.y, data.mission[random].livraison.car.z), data.mission[random].livraison.car.w)
                vehLivraison = tableVeh:getEntityId()
                SetVehicleDoorsLocked(vehLivraison, 2)
                SetVehicleDoorsLockedForAllPlayers(vehLivraison, true)
            end

            if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.peds.xyz) <= 50 then
                if not TextLast then
                    TextLast = true
                    VFW.Subtitle("Je te laisse charger mon véhicule.", 4000)
                    VFW.ShowNotification({
                        type = 'JAUNE',
                        content = "Va a l'arriere de ton coffre et récupere les sacs"
                    })
                end

                if #(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5)) < 1.5 then
                    if IsControlJustPressed(0, 38) and recup >= 1 and not HaveBag then
                        HaveBag = true
                        VFW.ShowNotification({
                            type = 'JAUNE',
                            content = "Va a l'arriere du coffre du speedo et dépose ton sac"
                        })
                        TriggerServerEvent("gofast:removeItemTrunk", GetVehicleNumberPlateText(veh))
                        bag = cEntity.Manager:CreateObject("prop_money_bag_01", vector3(GetEntityCoords(VFW.PlayerData.ped).x, GetEntityCoords(VFW.PlayerData.ped).y, GetEntityCoords(VFW.PlayerData.ped).z - 1))
                        SetVehicleDoorOpen(veh, 5, false, false)
                        AttachEntityToEntity(bag:getEntityId(), VFW.PlayerData.ped, GetEntityBoneIndexByName(VFW.PlayerData.ped, "IK_R_Hand"), props.offset[1], props.offset[2], props.offset[3], props.offset[4], props.offset[5], props.offset[6], false, false, false, false, 0.0, true)
                        if recup == 8 and HaveBag and not flic2 then
                            flic2 = true
                            TriggerServerEvent('core:alert:makeCall', "lssd", vector3(GetEntityCoords(VFW.PlayerData.ped).x, GetEntityCoords(VFW.PlayerData.ped).y, GetEntityCoords(VFW.PlayerData.ped).z), true, "Go Fast", false, "illegal")
                            TriggerServerEvent('core:alert:makeCall', "lspd", vector3(GetEntityCoords(VFW.PlayerData.ped).x, GetEntityCoords(VFW.PlayerData.ped).y, GetEntityCoords(VFW.PlayerData.ped).z), true, "Go Fast", false, "illegal") -- FIX_LSSD_LSPD
                        end
                    end
                end

                if #(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(vehLivraison, GetEntityBoneIndexByName(vehLivraison, "platelight")) + vector3(0.0, 0.0, 0.5)) < 1.5 then
                    if IsControlJustPressed(0, 38) and HaveBag then
                        HaveBag = false
                        SetVehicleDoorOpen(veh, 5, false, false)
                        PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(1000)
                        recup = recup - 1
                        bag:delete()
                        ClearPedTasks(VFW.PlayerData.ped)
                    end
                end

                if recup == 0 and not finishMess then
                    finishMess = true
                    SetVehicleDoorShut(veh, 5, false, false)
                    VFW.Subtitle("Merci de ton aide, on te recontacte pour le paiement. Maintenant bouge de là !", 4000)
                end
            end
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.peds.xyz) >= 60.0 and finishMess and not payMess then
            pedsLiraison:delete()
            DeleteEntity(vehLivraison)
            Wait(20000)
            pay = true
            payMess = true
            TriggerServerEvent("gofast:paySms", vector2(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y))
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].reward.pos) <= 60 and pay then
            pNear = true
            if not data.mission[random].reward.create then
                data.mission[random].reward.create = true
                local _, groundZ = GetGroundZFor_3dCoord(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y, data.mission[random].reward.pos.z, false);
                bag = cEntity.Manager:CreateObject("prop_money_bag_01", vector3(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y, groundZ))
                if not bagPoint then
                    bagPoint = Worlds.Zone.Create(vector3(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y, data.mission[random].reward.pos.z + 1.0), 1.5, false, function()
                        VFW.RegisterInteraction("rewardGoFast", function()
                            SetVehicleDoorsLockedForAllPlayers(veh, false)
                            SetVehicleDoorsLocked(veh, 0)
                            SetEntityAsNoLongerNeeded(veh)
                            pay = false
                            PlayAnim("pickup_object", "pickup_low", 0)
                            Wait(1000)
                            bag:delete()
                            ClearPedTasks(VFW.PlayerData.ped)

                            VFW.RemoveInteraction("rewardGoFast")
                            if bagPoint then
                                Worlds.Zone.Remove(bagPoint)
                                bagPoint = nil
                            end

                            VFW.ShowNotification({
                                type = 'DOLLAR',
                                content = "Tu as reçu ~s " .. data.mission[random].reward.money .. "$"
                            })

                            TriggerServerEvent("core:addMoney", data.mission[random].reward.money)
                            Wait(2000)
                            SetNewWaypoint(data.mission[random].reward2.pos.x, data.mission[random].reward2.pos.y)
                            --TriggerServerEvent("gofast:deleteconvo")

                            OpenStepCustom("GoFast", "Retourne au point de départ pour rendre le véhicule")
                            SetTimeout(7500, function()
                                HideStep()
                            end)
                        end)
                    end, function()
                        VFW.RemoveInteraction("rewardGoFast")
                    end, "Prendre", "E", "Barber")
                end
            end
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].reward2.pos) <= 60 and (not pay) then
            if not data.mission[random].reward2.create then
                data.mission[random].reward2.create = true
                if not bagPoint2 then
                    bagPoint2 = Worlds.Zone.Create(vector3(data.mission[random].reward2.pos.x, data.mission[random].reward2.pos.y, data.mission[random].reward2.pos.z + 1.0), 1.5, false, function()
                        VFW.RegisterInteraction("rewardGoFast2", function()
                            if not payed then
                                payed = true
                                DeleteEntity(veh)

                                VFW.ShowNotification({
                                    type = 'DOLLAR',
                                    content = "Tu as reçu ~s " .. data.mission[random].reward2.money .. "$"
                                })

                                TriggerServerEvent("core:addMoney", data.mission[random].reward2.money)
                                HideStep()

                                VFW.RemoveInteraction("rewardGoFast2")
                                if bagPoint2 then
                                    Worlds.Zone.Remove(bagPoint2)
                                    bagPoint2 = nil
                                end
                            end
                        end)
                    end, function()
                        VFW.RemoveInteraction("rewardGoFast2")
                    end, "Rendre", "E", "Barber")
                end
            end
        end

        if take then
            pNear = true
            if not vehPoint then
                vehPoint = Worlds.Zone.Create(GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), 1.5, false, function()
                    VFW.RegisterInteraction("poserCoffreGfst1", function()
                        TriggerServerEvent("gofast:addItemTrunk", GetVehicleNumberPlateText(veh))
                        SetVehicleDoorOpen(veh, 5, false, false)
                        PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(1000)
                        object[index]:delete()
                        recup = recup + 1
                        take = false
                        ClearPedTasks(VFW.PlayerData.ped)

                        if recup == #data.mission[random].loot then
                            VFW.RemoveInteraction("poserCoffreGfst1")
                            if vehPoint then
                                Worlds.Zone.Remove(vehPoint)
                                vehPoint = nil
                            end
                        end
                    end)
                end, function()
                    VFW.RemoveInteraction("poserCoffreGfst1")
                end, "Déposer", "E", "Barber")
            end
        end

        if pNear then
            Wait(1)
        else
            Wait(500)
        end
    end
end

CreateThread(function()
    while GoFast == nil do Wait(100) end
    while not VFW.IsPlayerLoaded() do Wait(100) end

    if VFW.CanAccessAction('gofast') and VFW.PlayerData.faction and VFW.PlayerData.faction.type and (VFW.PlayerData.faction.type == "gang" or VFW.PlayerData.faction.type == "mc" or VFW.PlayerData.faction.type == "orga" or VFW.PlayerData.faction.type == "mafia") then
        for k, v in pairs(GoFast) do
            VFW.CreateBlipAndPoint("gofast", vector3(v.peds.x, v.peds.y, v.peds.z + 0.75), k, 225, 1, 0.8, "GoFast",  "Ramasser", "E", "Location",{
                onPress = function()
                    local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)
                    local playerLicenseKey = 'heistsLimitPerReboot_' .. VFW.PlayerData.identifier
                    local goFastLimitPerReboot = (GlobalState[playerLicenseKey] and GlobalState[playerLicenseKey].gofast) or nil

                    if not inMission and policeNumber >= 0 and goFastLimitPerReboot == nil or goFastLimitPerReboot < 1 then
                        local phone = TriggerServerCallback("core:GetNumber")

                        if phone ~= nil then
                            inMission = true
                            CreateThread(function()
                                VFW.Subtitle("Yo mon petit, j'ai besoin de toi pour me récuperer une cargaison", 3000)
                                VFW.RealWait(3000)
                                VFW.Subtitle("je vais t'envoyer toutes les informations un peu plus tard. ", 3000)
                                VFW.RealWait(3000)
                                VFW.Subtitle("Maintenant BOUGE ! ", 2000)
                                VFW.RealWait(5 * 1000) -- 5 Minute
                                CreateMissionGoFast(v)
                                -- TriggerServerEvent("core:crew:updateXp", gf1.xp, "add", p:getCrew(), "gofast1")
                            end)
                        else
                            VFW.Subtitle("Va t'acheter un téléphone que je puisse te contacter et reviens me voir", 2000)
                        end
                    else
                        VFW.Subtitle("J'ai pas besoin de toi petit, bouge de la avant que tu le regrette", 2000)
                    end
                end
            })

            peds[k] = cEntity.Manager:CreatePedLocal(v.modelPed, vector3(v.peds.x, v.peds.y, v.peds.z - 1.0), v.peds.w)
            peds[k]:setScenario("WORLD_HUMAN_DRUG_DEALER", -1, true)
            peds[k]:setInvincible(true)
            peds[k]:setFreeze(true)
        end
    end
end)
