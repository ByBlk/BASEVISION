
local insert, inMision, pickupPointPizza, trunkPoint, trunkPointDelivery, deliveryPoint, returnPoint, packageCollected, maxPackages, inPickupPizza, blippos = false, false, nil, nil, nil, nil, nil, 0, 10, false, nil





pizzaPos = {
    [1] = {
        vector4(363.73327636719, -711.91381835938, 28.292636871338, 67.018737792969),
        vector4(286.04180908203, -790.54522705078, 28.43664932251, 247.69717407227),
        vector4(65.968658447266, -1008.7619018555, 28.357431411743, 336.50701904297),
        vector4(185.18872070312, -1078.0997314453, 28.276679992676, 265.16470336914),
        vector4(198.24786376953, -1276.6242675781, 28.324604034424, 253.51258850098),
        vector4(114.5531463623, -1038.5085449219, 28.29328918457, 59.458160400391),
        vector4(66.633720397949, -803.67126464844, 30.533937454224, 333.34713745117),
        vector4(239.36796569824, -696.89111328125, 35.737487792969, 61.265003204346),
    },
    [2] = {
        vector4(390.71688842773, -909.83923339844, 28.538501739502, 326.02059936523),
        vector4(418.60119628906, -767.58728027344, 28.430757522583, 85.559356689453),
        vector4(462.84582519531, -694.0107421875, 26.401000976562, 89.452857971191),
        vector4(393.67028808594, -803.80499267578, 28.294363021851, 268.80068969727),
        vector4(375.54995727539, -688.29418945312, 28.262901306152, 356.44198608398),
        vector4(281.4091796875, -800.88458251953, 28.316814422607, 251.61630249023),
        vector4(65.785804748535, -1008.7196044922, 28.357448577881, 329.21905517578),
        vector4(360.78146362305, -1072.9774169922, 28.540794372559, 356.45745849609),
    },
    [3] = {
        vector4(192.20275878906, -1066.5933837891, 28.307769775391, 273.79824829102),
        vector4(146.40007019043, -1058.8426513672, 29.18879699707, 102.16819000244),
        vector4(16.09215927124, -1032.2716064453, 28.515707015991, 162.21797180176),
        vector4(8.573543548584, -916.37585449219, 28.905002593994, 77.72868347168),
        vector4(142.86772155762, -832.88525390625, 30.176988601685, 304.25109863281),
        vector4(286.00814819336, -790.20654296875, 28.436660766602, 251.25372314453),
        vector4(438.27841186523, -625.69580078125, 27.708429336548, 93.793685913086),
        vector4(416.76766967773, -1084.0567626953, 29.057832717896, 167.11041259766),
    },
}



local function SelectRandomDeliveryPoints()
    local randomCategory = math.random(1, #pizzaPos)
    local selectedCategory = pizzaPos[randomCategory]
    

    local shuffledPoints = {}
    for i = 1, #selectedCategory do
        shuffledPoints[i] = selectedCategory[i]
    end
    
    for i = #shuffledPoints, 2, -1 do
        local j = math.random(1, i)
        shuffledPoints[i], shuffledPoints[j] = shuffledPoints[j], shuffledPoints[i]
    end
    

    deliveryPoints = {}
    for i = 1, maxPackages do
        if shuffledPoints[i] then
            table.insert(deliveryPoints, shuffledPoints[i])
        end
    end
    
    return deliveryPoints
end

local function StartPizzeria()
    if inMision then 
        return VFW.ShowNotification({ type = "ROUGE", content ="Vous êtes déjà en service !"})
    end


    inMision = true 
    VFW.ShowNotification({ type = "VERT", content = "Service de livraison activé" })

    local clearSpawn = VFW.Game.IsSpawnPointClear(vector3(71.79, 121.77, 78.18), 2.5)

    if clearSpawn then 
        vehicle = VFW.Game.SpawnVehicle(GetHashKey("faggio"), vector3(291.07, -957.63, 28.26), 85.91, nil, true)
    else
        isInMision = false
        VFW.ShowNotification({ type = "ROUGE", content = "Le point de spawn est bloqué" })
    end

    pickupPointPizza = Worlds.Zone.Create(vector3(290.09, -963.88, 28.42 + 0.60), 1.75, false, function()
        VFW.RegisterInteraction("pickup_pizzeria", function()
            if packageCollected >= maxPackages then 
                VFW.ShowNotification({ type = "ROUGE", content = "Vous avez déjà ramassé tous les colis" })
                return
            end

            ExecuteCommand("e carrypizza")

            inPickupPizza = true

            local trunkPos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -3.0, 0.0)

            if not trunkPoint then 
                trunkPoint = Worlds.Zone.Create(trunkPos, 1.75, false, function()
                    VFW.RegisterInteraction("deposit_package", function()
                        if not inPickupPizza then 
                            return VFW.ShowNotification({ type = "ROUGE", content = "Vous devez avoir une pizza dans les mains pour déposer dans le coffre" })
                        end

                        local lib, anim = "anim@heists@narcotics@trash", "throw_b"

                        RequestAnimDict(lib)

                        while not HasAnimDictLoaded(lib) do
                            Wait(0)
                        end

                        TaskPlayAnim(VFW.PlayerData.ped, lib, anim, 8.0, -8.0, -1, 49, 0, false, false, false, false)
                    
                        Wait(1000)
                        
                        ClearPedTasks(VFW.PlayerData.ped)

                        packageCollected = packageCollected + 1
                        VFW.ShowNotification({ type = "VERT", content = "Pizza chargé : "..packageCollected.."/"..maxPackages })
                        ExecuteCommand("e c")
                        inPickupPizza = false


                        if packageCollected == maxPackages then 
                            VFW.ShowNotification({ type = "JAUNE", content = "Tous les colis sont chargés, commencez la livraison !" })
                        
                            if trunkPoint then 
                                Worlds.Zone.Remove(trunkPoint)
                                VFW.RemoveInteraction("deposit_package")
                                trunkPoint = nil
                            end
                        
                            if pickupPointPizza then
                                Worlds.Zone.Remove(pickupPointPizza)
                                VFW.RemoveInteraction("pickup_pizzeria")
                                pickupPointPizza = nil
                            end

                            deliveryPoints = SelectRandomDeliveryPoints()
                            currentDeliveryIndex = 1
                            local deliveryPos = vector3(deliveryPoints[currentDeliveryIndex].x, deliveryPoints[currentDeliveryIndex].y, deliveryPoints[currentDeliveryIndex].z)
                        

                            if blippos then
                                RemoveBlip(blippos)
                            end

                            blippos = AddBlipForCoord(deliveryPos)
                            SetBlipRoute(blippos, true)
                            SetBlipRouteColour(blippos, 5)
                        

                            CreateThread(function()
                                while inMision and currentDeliveryIndex <= #deliveryPoints do
                                    local playerCoords = GetEntityCoords(VFW.PlayerData.ped)
                                    local deliveryPos = vector3(deliveryPoints[currentDeliveryIndex].x, deliveryPoints[currentDeliveryIndex].y, deliveryPoints[currentDeliveryIndex].z)
                                    local dist = #(playerCoords - deliveryPos)
                            
                                    if dist < 10.0 and not IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                        if not trunkPointDelivery then
                                            local trunkDeliveryPos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -3.0, 0.0)
                                            trunkPointDelivery = Worlds.Zone.Create(trunkDeliveryPos, 1.75, false, function()
                                                VFW.RegisterInteraction("take_pizza_delivery", function()

                                                    TriggerServerEvent("core:activities:pizza:addPizza", "pizza", 1)

                                                    ExecuteCommand("e carrypizza")
                                                    VFW.ShowNotification({ type = "VERT", content = "Prenez la pizza et livrez-la !" })
                            


                                                    if not deliveryPoint then
                                                        deliveryPoint = Worlds.Zone.Create(deliveryPos, 1.75, false, function()
                                                            VFW.RegisterInteraction("deliver_pizza", function()
                                                                ExecuteCommand("e c")
                                                            
                                                                local dict = "timetable@jimmy@doorknock@"
                                                                local anim = "knockdoor_idle"
                                                                RequestAnimDict(dict)
                                                                while not HasAnimDictLoaded(dict) do Wait(0) end
                                                                TaskPlayAnim(VFW.PlayerData.ped, dict, anim, 8.0, -8.0, 1500, 49, 0, false, false, false)
                                                                Wait(1000)


                                                                ExecuteCommand("e carrypizza")


                                                                local forward = GetEntityForwardVector(VFW.PlayerData.ped)
                                                                local offset = 1.5
                                                                local pedPos = GetOffsetFromEntityInWorldCoords(VFW.PlayerData.ped, forward.x * offset, forward.y * offset, 0.0)
                                                            
                                                                local pedModel = "a_m_m_business_01"
                                                                RequestModel(pedModel)
                                                                while not HasModelLoaded(pedModel) do Wait(0) end
                                                            
                                                                local deliveryPed = CreatePed(4, pedModel, pedPos.x, pedPos.y, pedPos.z - 1.0, GetEntityHeading(VFW.PlayerData.ped) - 180.0, false, true)
                                                                FreezeEntityPosition(deliveryPed, true)
                                                                SetEntityInvincible(deliveryPed, true)
                                                                SetBlockingOfNonTemporaryEvents(deliveryPed, true)
                                                            

                                                                local pedDict = "mp_common"
                                                                local pedAnim = "givetake1_a"
                                                                RequestAnimDict(pedDict)
                                                                while not HasAnimDictLoaded(pedDict) do Wait(0) end
                                                            
                                                                TaskPlayAnim(VFW.PlayerData.ped, pedDict, pedAnim, 8.0, -8.0, 1000, 49, 0, false, false, false)
                                                                TaskPlayAnim(deliveryPed, pedDict, "givetake1_b", 8.0, -8.0, 1000, 49, 0, false, false, false)
                                                            
                                                                Wait(1200)
                                                                ExecuteCommand("e c")
                                                                ClearPedTasks(VFW.PlayerData.ped)
                                                                Wait(1000)
                                                                DeleteEntity(deliveryPed)
                                                                
                                                                TriggerServerEvent("core:activities:pizza:removePizza", "pizza", 1)
                                                            

                                                                currentDeliveryIndex = currentDeliveryIndex + 1
                                                            
                                                                if deliveryPoint then
                                                                    Worlds.Zone.Remove(deliveryPoint)
                                                                    VFW.RemoveInteraction("deliver_pizza")
                                                                    deliveryPoint = nil
                                                                end
                                                            
                                                                if trunkPointDelivery then
                                                                    Worlds.Zone.Remove(trunkPointDelivery)
                                                                    VFW.RemoveInteraction("take_pizza_delivery")
                                                                    trunkPointDelivery = nil
                                                                end
                                                            
                                                                if currentDeliveryIndex <= #deliveryPoints then
                                                                    local nextPos = vector3(deliveryPoints[currentDeliveryIndex].x, deliveryPoints[currentDeliveryIndex].y, deliveryPoints[currentDeliveryIndex].z)
                                                                    if blippos then RemoveBlip(blippos) end
                                                                    blippos = AddBlipForCoord(nextPos)
                                                                    SetBlipRoute(blippos, true)
                                                                    SetBlipRouteColour(blippos, 5)
                                                                else
                                                                    VFW.ShowNotification({ type = "JAUNE", content = "Toutes les pizzas sont livrées ! Ramenez le scooter à la pizzeria." })
                                                            
                                                                    if blippos then RemoveBlip(blippos) end
                                                                    local returnCoords = vector3(291.07, -957.63, 28.26)
                                                                    blippos = AddBlipForCoord(returnCoords)
                                                                    SetBlipRoute(blippos, true)
                                                                    SetBlipRouteColour(blippos, 2)
                                                            
                                                                    returnPoint = Worlds.Zone.Create(returnCoords, 3.0, false, function()
                                                                        VFW.RegisterInteraction("return_vehicle", function()
                                                                            if DoesEntityExist(vehicle) then
                                                                                DeleteVehicle(vehicle)
                                                                                vehicle = nil
                                                                            end
                                                            
                                                                            if blippos then RemoveBlip(blippos) end
                                                            
                                                                            VFW.ShowNotification({ type = "VERT", content = "Véhicule rendu. Vous avez reçu votre salaire !" })



                                                                            inMision = false
                                                                            packageCollected = 0
                                                                            deliveryPoints = nil
                                                            
                                                                            Worlds.Zone.Remove(returnPoint)
                                                                            VFW.RemoveInteraction("return_vehicle")
                                                                        end)
                                                                    end, function()
                                                                        VFW.RemoveInteraction("return_vehicle")
                                                                    end, "Rendre", "E", "Rendre le véhicule")
                                                                end
                                                            end)
                                                        end, function()
                                                            VFW.RemoveInteraction("deliver_pizza")
                                                        end, "Livrer", "E", "Livrer")
                                                    end
                                                end)
                                            end, function()
                                                VFW.RemoveInteraction("take_pizza_delivery")
                                            end, "Prendre", "E", "Prendre")
                                        end
                                    end
                            
                                    Wait(1000)
                                end
                            end)
                        end
                        
                    end)
                end, function()
                    VFW.RemoveInteraction("deposit_package")
                end, "Deposer", "E", "Deposer")
            end
        end)
    end, function()
        VFW.RemoveInteraction("pickup_pizzeria")
    end, "Ramasser", "E", "Ramasser")
end


function OpenMenuPizzeriaInt()
    if not insert then 
        PlayersInJob = {
            { name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId()) }
        }
        insert = true
    end
    Wait(50)

    VFW.Nui.JobMenu(true, {
        headerBanner = "https://cdn.eltrane.cloud/alkiarp/assets/jobmenu/pizza_header.webp",
        choice = {
            label = "Scoots",
            isOptional = false,
            choices = {{id = 1, label = 'Faggio', name = 'faggio', img= "https://cdn.eltrane.cloud/alkiarp/assets/jobmenu/pizza_vehicle.webp"}},
        },
        participants = PlayersInJob,
        participantsNumber = 1,
        callbackName = "MetierPizzeria",
    })
end

RegisterNUICallback("MetierPizzeria", function(data)
    if not data then return end

    if data.button == "start" then
        StartPizzeria()
    elseif data.button == "stop" then
        StopJobCourse()
    end
end)