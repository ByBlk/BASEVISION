local peds = {}
local inMission = false

local function CreateMissionGoFastMaritime(data)
    inMission = true
    local random = math.random(1, #data.mission)
    local firstSms = false
    local finishMess = false
    local secondMess = false
    local veh = nil
    local thirdMessage = false
    local payMess = false
    local removeFromTrunk = false
    local recup = 0
    local pedsLiraison = nil
    local TextLast = false
    local vehLivraison = nil
    local pay = false
    local pNear = false

    while inMission do
        if not firstSms then
            firstSms = true
            TriggerServerEvent("gofast:firstSms", vector2(data.mission[random].vehicle.pos.x, data.mission[random].vehicle.pos.y))
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].vehicle.pos.xyz) <= 50 and not secondMess then
            if not data.mission[random].vehicle.create then
                data.mission[random].vehicle.create = true
                local tableVeh = cEntity.Manager:CreateVehicleLocal(data.mission[random].vehicle.model, data.mission[random].vehicle.pos, data.mission[random].vehicle.pos.w)
                veh = tableVeh:getEntityId()

                blipVeh = AddBlipForEntity(veh)
                SetBlipSprite(blipVeh, 427)
                SetBlipColour(blipVeh, 2)
                Wait(50)
            end

            if IsPedSittingInVehicle(VFW.PlayerData.ped, veh) then
                if not secondMess then
                    secondMess = true
                    recup = 1
                    if not thirdMessage then
                        thirdMessage = true
                        local x, y,z = table.unpack(data.mission[random].livraison.pos)
                        TriggerServerEvent("gofast:thirdSms", vector2(x, y))
                        SetVehicleDoorShut(veh, 5, false, false)
                    end
                    TriggerServerEvent('core:alert:makeCall', "lspd", GetEntityCoords(VFW.PlayerData.ped), true, "GoFast Maritime")
                    Wait(10000)
                    TriggerServerEvent('core:alert:makeCall', "lspd", GetEntityCoords(VFW.PlayerData.ped), true, "Suite GoFast Maritime")
                end
            end
            pNear = true
        end


        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.pos) <= 100 then
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

            if not finishMess then
                DrawMarker(35, data.mission[random].livraison.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 1.5, 1.0, 255, 255, 255, 120, 0, 1, 2, 0, nil, nil, 0)
            end

            if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.pos) <= 10.0 then
                if not TextLast then
                    TextLast = true
                    VFW.Subtitle("Laisse moi décharger.", 4000)
                    Wait(4000)
                    VFW.Subtitle("C'est bon, tiens t'es ".. data.mission[random].money .."$, moi je me casse ciao.", 4000)
                    if not removeFromTrunk then
                        removeFromTrunk = true
                        -- TriggerServerEvent("gofast:removeItemTrunk", GetVehicleNumberPlateText(veh), data.mission[random].loot, data.mission[random].lootAmount)
                        recup = 0
                    end
                    TriggerServerEvent("core:addMoney", data.mission[random].money)
                    SetVehicleDoorsLocked(vehLivraison, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehLivraison, false)
                    FreezeEntityPosition(pedsLiraison.id, false)
                    TaskEnterVehicle(pedsLiraison.id, vehLivraison, -1, -1, 2.0, 1, 0)
                    Wait(6000)
                    TaskVehicleDriveWander(pedsLiraison.id, vehLivraison, 60.0, 0)
                    pNear = false
                end
                if recup == 0 and not finishMess then
                    finishMess = true
                    SetVehicleDoorShut(veh, 5, false, false)
                    VFW.Subtitle("Merci de ton aide. Maintenant bouge de là !", 4000)
                end
            end
        end

        if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].livraison.pos) >= 20.0 and finishMess and not payMess then
            pedsLiraison:delete()
            DeleteEntity(vehLivraison)
            Wait(5000)
            pay = true
            payMess = true
            SetNewWaypoint(vector2(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y))
        end

        if pay and payMess then
            if #(GetEntityCoords(VFW.PlayerData.ped) - data.mission[random].reward.pos) < 35.0 then
                pNear = true
                DrawMarker(35, data.mission[random].reward.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 1.5, 1.0, 255, 255, 255, 120, 0, 1, 2, 0, nil, nil, 0)
                if IsControlJustPressed(0, 38) then
                    DeleteEntity(GetVehiclePedIsIn(VFW.PlayerData.ped))
                    SetEntityCoords(VFW.PlayerData.ped, data.peds.xyz)
                    VFW.Subtitle("Reviens quand tu veux !", 4000)
                    inMission = false
                end
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
    while GoFastMaritime == nil do Wait(100) end
    while not VFW.IsPlayerLoaded() do Wait(100) end

    if VFW.PlayerData.faction and VFW.PlayerData.faction.type and (VFW.PlayerData.faction.type == "gang" or VFW.PlayerData.faction.type == "mc" or VFW.PlayerData.faction.type == "orga" or VFW.PlayerData.faction.type == "mafia") then
        for k, v in pairs(GoFastMaritime) do

            VFW.CreateBlipAndPoint("gofastmaritime", vector3(v.peds.x, v.peds.y, v.peds.z + 0.75), k, 225, 1, 0.8, "GoFast Maritime",  "Ramasser", "E", "Location",{
                onPress = function()
                    local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)
                    local playerLicenseKey = 'heistsLimitPerReboot_' .. VFW.PlayerData.identifier
                    local goFastLimitPerReboot = (GlobalState[playerLicenseKey] and GlobalState[playerLicenseKey].gofastMaritime) or nil

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
                                VFW.RealWait(3 * 1000) -- 3 Minutes
                                CreateMissionGoFastMaritime(v)
                                -- TriggerServerEvent("core:crew:updateXp", 200, "add", p:getCrew(), "gofast1")
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
