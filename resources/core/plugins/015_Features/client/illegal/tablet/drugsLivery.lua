local inDrugsDeliveries = {}
local deliveryId = {}
local dataTablette = {}
local commandData = {}
local propsToSpawn = {}
local items = {}
local ownerName = {}
local blipMissions = {}
local remainingItems = {}
local function getTableCount(tabl)
    local count = 0
    for _ in pairs(tabl) do
        count = count + 1
    end
    return count
end

local function closestDrugWrap()
    local obj = {
        `hei_prop_hei_drug_pack_01b`,
        `prop_box_guncase_01a`,
        `prop_tool_box_04`,
    }
    local playerCoords = GetEntityCoords(VFW.PlayerData.ped)
    local closestObject = nil

    for i = 1, #obj do
        local objType1 = GetClosestObjectOfType(playerCoords, 2.0, obj[i], true)
        local objType2 = GetClosestObjectOfType(playerCoords, 2.0, obj[i], false)

        if objType1 ~= 0 then
            closestObject = objType1
            break
        elseif objType2 ~= 0 then
            closestObject = objType2
            break
        end
    end

    return closestObject
end



local lastObject = nil
local interactedBag = {}
local InTook = false
local InTookCoffre = false
local isTaken = false
local PROPS <const> = {
    offset = { 0.130, 0.02, -0.041, 3.1, 0.0, 0.0 }
}
local took = 0

---@param netId number
local function takeDrugBag(netId, interactId)
    InTook = true
    -- console.debug("------------")
    -- console.debug("[CACA] Remove interaction", interactPoints["illegal_tablet" .. netId])
    -- console.debug("------------")
    -- Worlds.Zone.Remove(interactPoints["illegal_tablet" .. netId])
    VFW.DestroyInteract(interactId)
    local thisObject = closestDrugWrap()
    local netId = NetworkGetNetworkIdFromEntity(thisObject)
    SetEntityAsMissionEntity(thisObject, true, true)
    NetworkRequestControlOfEntity(thisObject)
    local timer = 1
    while (not NetworkHasControlOfEntity(thisObject)) and timer < 30 do
        Wait(1)
        timer = timer + 1
    end
    SetNetworkIdCanMigrate(netId, true) -- allow other player to take control of the entity
    isTaken = true
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do Wait(1) end
    TaskPlayAnim(VFW.PlayerData.ped, "pickup_object", "pickup_low", 8.0, 1.0, -1, 0, 0, 0, 0, 0)
    Wait(1000)
    AttachEntityToEntity(thisObject, VFW.PlayerData.ped, GetEntityBoneIndexByName(VFW.PlayerData.ped, "IK_R_Hand"), PROPS.offset[1], PROPS.offset[2],
            PROPS.offset[3], PROPS.offset[4], PROPS.offset[5], PROPS.offset[6], false, false, false, false, 0.0, true)
    lastObject = thisObject
    InTook = false
end

local function startDrugsDeliveries(actualDeliveryId)
    CreateThread(function()
        inDrugsDeliveries[actualDeliveryId] = true
        local doneObjectAllow = 0
        local indexItems = 0
        console.debug("Start Drugs devlivery", actualDeliveryId)
        local shownInteract = {}
        local shownInteractTrunk = {}
        while inDrugsDeliveries[actualDeliveryId] do
            local pNear = false
            if #(GetEntityCoords(VFW.PlayerData.ped) - dataTablette[actualDeliveryId].pos.xyz) <= 50 then
                pNear = true
                if (not isTaken) then
                    local vehs = VFW.Game.GetVehiclesInArea(GetEntityCoords(VFW.PlayerData.ped), 10.0)
                    for i = 1, #vehs do
                        local veh = vehs[i]
                        local dist = #(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")))
                        if dist > 2.0 then 
                            if shownInteractTrunk[veh] then
                                if shownInteractTrunk[veh].interaction then
                                    shownInteractTrunk[veh].interaction = nil
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        interactKey = "E", 
                                        keyColor = "#ff6363",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactIcons = "Illegal_deposer", 
                                        type = "setInteraction", 
                                        visible = false
                                    })
                                end
                                if (not shownInteractTrunk[veh].point) then
                                    shownInteractTrunk[veh].point = true
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        keyColor = "#ff6363",
                                        glowColor = "#ff6363",
                                        labelGradientStart = "#ff6363",
                                        innerGradientStart = "#ff6363",
                                        innerGradientEnd = "#ff2b2b",
                                        outerStrokeStart = "#ff6363",
                                        outerStrokeEnd = "#ff2b2b",
                                        labelGradientEnd = "#ff2b2b",
                                        interactKey = "E", 
                                        interactIcons = "Illegal_deposer",
                                        type = "setPointVisibility", 
                                        visible = true
                                    })
                                end
                            end
                        end
                    end
                    for k, v in pairs(dataTablette[actualDeliveryId].objects) do
                        if (not shownInteract[k]) then 
                            shownInteract[k] = {
                                base = false,
                                Illegal_commande = false,
                                setInteraction = false
                            }
                        end
                        if (not shownInteract[k].base) then 
                            shownInteract[k].base = true
                            VFW.CreateInteract(k, vector3(v.pos.x, v.pos.y, v.pos.z))
                            VFW.SendDataInteract(k, {
                                interactLabel = "Ramasser", 
                                keyColor = "#ff6363",
                                glowColor = "#ff6363",
                                labelGradientStart = "#ff6363",
                                innerGradientStart = "#ff6363",
                                innerGradientEnd = "#ff2b2b",
                                outerStrokeStart = "#ff6363",
                                outerStrokeEnd = "#ff2b2b",
                                labelGradientEnd = "#ff2b2b",
                                interactKey = "E", 
                                interactIcons = "Illegal_commande", 
                                type = "setPointVisibility", 
                                visible = true
                            })
                        end
                        if tonumber(doneObjectAllow) < tonumber(getTableCount(dataTablette[actualDeliveryId].objects)) then
                            SetNetworkIdCanMigrate(v.netId, false) -- ne pas migrate car l'id peut changer sinon
                            SetNetworkIdExistsOnAllMachines(v.netId, true) -- netid exist pr tt le monde
                            NetworkUseHighPrecisionBlending(v.netId, true)
                            console.debug("Allow object", v.netId)
                            local objec = NetworkGetEntityFromNetworkId(v.netId)
                            if objec ~= 0 or objec ~= -1 then
                                if DoesEntityExist(objec) then
                                    SetEntityAsMissionEntity(objec, true, true)
                                end
                            end
                            doneObjectAllow = doneObjectAllow + 1
                        end
                        if #(GetEntityCoords(VFW.PlayerData.ped) - v.pos.xyz) < 10.0 then
                            VFW.HideInteract(false)
                        --if #(GetEntityCoords(VFW.PlayerData.ped) - v.pos.xyz) < 10.0 and (not interactedBag["illegal_tablet" .. v.netId]) then
                        --    interactedBag["illegal_tablet" .. v.netId] = true
                            if #(GetEntityCoords(VFW.PlayerData.ped) - v.pos.xyz) < 1.5 then
                                if (not shownInteract[k].setInteraction) then
                                    shownInteract[k].setInteraction = true
                                    VFW.SendDataInteract(k, {
                                        interactLabel = "Ramasser", 
                                        keyColor = "#FFFFFF",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactKey = "E", 
                                        interactIcons = "Illegal_commande",
                                        type = "setPointVisibility", 
                                        visible = false
                                    })
                                    VFW.SendDataInteract(k, {
                                        interactLabel = "Ramasser", 
                                        interactKey = "E", 
                                        keyColor = "#FFFFFF",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactIcons = "Illegal_commande", 
                                        type = "setInteraction", 
                                        visible = true
                                    })
                                end
                                if IsControlJustPressed(0, 38) then
                                    takeDrugBag(v.netId, k)
                                end
                            else
                                if shownInteract[k].setInteraction then
                                    shownInteract[k].setInteraction = nil
                                    VFW.SendDataInteract(k, {
                                        interactLabel = "Ramasser", 
                                        interactKey = "E", 
                                        keyColor = "#FFFFFF",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactIcons = "Illegal_commande", 
                                        type = "setInteraction", 
                                        visible = false
                                    })
                                end
                                if not shownInteract[k].Illegal_commande then
                                    shownInteract[k].Illegal_commande = nil
                                    VFW.SendDataInteract(k, {
                                        interactLabel = "Ramasser", 
                                        keyColor = "#ff6363",
                                        glowColor = "#ff6363",
                                        labelGradientStart = "#ff6363",
                                        innerGradientStart = "#ff6363",
                                        innerGradientEnd = "#ff2b2b",
                                        outerStrokeStart = "#ff6363",
                                        outerStrokeEnd = "#ff2b2b",
                                        labelGradientEnd = "#ff2b2b",
                                        interactKey = "E", 
                                        interactIcons = "Illegal_commande",
                                        type = "setPointVisibility", 
                                        visible = true
                                    })
                                end
                            end
                            -- interactPoints["illegal_tablet" .. v.netId] = Worlds.Zone.Create(vector3(v.pos.x, v.pos.y, v.pos.z + 1.5), 0.85, false, function()
                            --     VFW.RegisterInteraction("illegal_tablet:interaction" .. v.netId, function()
                            --         if (not InTook) then -- Necessary because interactions are bugged
                            --             took = took + 1
                            --             console.debug("Take drug bag number "..took.."", #(GetEntityCoords(VFW.PlayerData.ped) - v.pos.xyz), interactPoints["illegal_tablet" .. v.netId])
                            --             console.debug(json.encode(interactedBag), json.encode(interactPoints))
                            --             takeDrugBag(v.netId)
                            --         end
                            --     end)
                            -- end, function()
                            --     VFW.RemoveInteraction("illegal_tablet:interaction" .. v.netId)
                            -- end, "Ramasser", "E", "Illegal_commande", {"#ff6363", "#ff2b2b", "#FFFFFF", "0.7"}, -1.0)
                        else
                            VFW.HideInteract(true)
                        end
                    end
                else
                    local vehs = VFW.Game.GetVehiclesInArea(GetEntityCoords(VFW.PlayerData.ped), 10.0)
                    for i = 1, #vehs do
                        local veh = vehs[i]
                        local platePos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight"))
                        local distPlate = #(GetEntityCoords(VFW.PlayerData.ped) - platePos)
                        local distTrunk = #(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot")))
                        local trunkPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot"))
                        if (distPlate < 9.75 or distTrunk < 9.75) then
                            if not shownInteractTrunk[veh] then 
                                shownInteractTrunk[veh] = {
                                    point = false,
                                    interaction = false
                                }
                                VFW.CreateInteract(veh, vector3(trunkPos.x, trunkPos.y, trunkPos.z - 0.5))
                                VFW.SendDataInteract(veh, {
                                    interactLabel = "Déposer", 
                                    keyColor = "#ff6363",
                                    glowColor = "#ff6363",
                                    labelGradientStart = "#ff6363",
                                    innerGradientStart = "#ff6363",
                                    innerGradientEnd = "#ff2b2b",
                                    outerStrokeStart = "#ff6363",
                                    outerStrokeEnd = "#ff2b2b",
                                    labelGradientEnd = "#ff2b2b",
                                    interactKey = "E", 
                                    interactIcons = "Illegal_deposer", 
                                    type = "setPointVisibility", 
                                    visible = true
                                })
                            end
                            if (distPlate < 1.75 or distTrunk < 1.75) then -- Necessary because interactions are bugged
                                if not shownInteractTrunk[veh].interaction then
                                    shownInteractTrunk[veh].interaction = true
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        interactKey = "E", 
                                        keyColor = "#FFFFFF",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactIcons = "Illegal_deposer", 
                                        type = "setInteraction", 
                                        visible = true
                                    })
                                end
                                if (shownInteractTrunk[veh].point) then
                                    shownInteractTrunk[veh].point = nil
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        keyColor = "#FFFFFF",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactKey = "E", 
                                        interactIcons = "Illegal_deposer",
                                        type = "setPointVisibility", 
                                        visible = false
                                    })
                                end
                                if IsControlJustPressed(0, 38) and (not InTookCoffre) and isTaken then
                                    InTookCoffre = true
                                    isTaken = false
                                    indexItems = TriggerServerCallback("core:tablet:getIndex", VFW.PlayerData.faction.name, actualDeliveryId)
                                    SetVehicleDoorOpen(veh, 5, false, false)
                                    RequestAnimDict("pickup_object")
                                    while not HasAnimDictLoaded("pickup_object") do Wait(1) end
                                    TaskPlayAnim(VFW.PlayerData.ped, "pickup_object", "putdown_low", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                                    Wait(1000)
                                    DetachEntity(lastObject)
                                    TriggerServerEvent("deleteObject", NetworkGetNetworkIdFromEntity(lastObject))
                                    ClearPedTasks(VFW.PlayerData.ped)
                                    SetVehicleDoorShut(veh, 5, false, false)
                                    RemoveAnimDict("pickup_object")

                                    if items[indexItems] and type(items[indexItems]) == "table" and items[indexItems].name and items[indexItems].quantity then
                                        console.debug("add to coffre", items[indexItems].name, items[indexItems].quantity, GetVehicleNumberPlateText(veh))
                                        TriggerServerEvent("core:tablet:addItemToTrunk", VFW.Game.GetPlate(veh), items[indexItems].name, items[indexItems].quantity, actualDeliveryId)

                                        if indexItems >= 4 then
                                            if #remainingItems > 0 then
                                                for i = 1, #remainingItems do
                                                    if remainingItems[i] and remainingItems[i].name and remainingItems[i].quantity then
                                                        TriggerServerEvent("core:tablet:addItemToTrunk", VFW.Game.GetPlate(veh), remainingItems[i].name, remainingItems[i].quantity, actualDeliveryId)
                                                        console.debug("add to coffre", remainingItems[i].name, remainingItems[i].quantity, GetVehicleNumberPlateText(veh))
                                                    end
                                                end
                                                remainingItems = {}
                                            end
                                        end
                                    end
                                    lastObject = nil
                                    InTookCoffre = false
                                end
                            else
                                if shownInteractTrunk[veh].interaction then
                                    shownInteractTrunk[veh].interaction = nil
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        interactKey = "E", 
                                        keyColor = "#ff6363",
                                        labelGradientStart = "#ff6363",
                                        labelGradientEnd = "#ff2b2b",
                                        interactIcons = "Illegal_deposer", 
                                        type = "setInteraction", 
                                        visible = false
                                    })
                                end
                                if (not shownInteractTrunk[veh].point) then
                                    shownInteractTrunk[veh].point = true
                                    VFW.SendDataInteract(veh, {
                                        interactLabel = "Déposer", 
                                        keyColor = "#ff6363",
                                        glowColor = "#ff6363",
                                        labelGradientStart = "#ff6363",
                                        innerGradientStart = "#ff6363",
                                        innerGradientEnd = "#ff2b2b",
                                        outerStrokeStart = "#ff6363",
                                        outerStrokeEnd = "#ff2b2b",
                                        labelGradientEnd = "#ff2b2b",
                                        interactKey = "E", 
                                        interactIcons = "Illegal_deposer",
                                        type = "setPointVisibility", 
                                        visible = true
                                    })
                                end
                            end
                        end
                    end
                end
            end
            if pNear then
                Wait(1)
            else
                Wait(500)
            end
        end

        for k, v in pairs(shownInteractTrunk or {}) do
            VFW.DestroyInteract(k)
        end
    end)
end

local EnemyBlips = {}
local function setEnemyBlip(pos, delId)
    local timeBlips = 5 * 60000
    local random = math.random(100, 300.0)
    EnemyBlips[delId] = AddBlipForRadius(vector3(pos.x + random, pos.y + random, pos.z), 500.0)
    SetBlipSprite(EnemyBlips[delId], 9)
    -- Maybe PulseBlip
    SetBlipColour(EnemyBlips[delId], 1)
    SetBlipAlpha(EnemyBlips[delId], 100)
end



local function splitItem(_id)
    items = {}
    local nbr = 0
    local ins = false
    console.debug("splitItem", #commandData[_id], commandData[_id][1].spawnName, commandData[_id][1].quantity, json.encode(commandData[_id], {indent=true}))

    for i = 1, #commandData[_id] do
        if commandData[_id][i].type == "weapons" then
            ins = true
            items[i] = {}
            if not commandData[_id][i] then
                commandData[_id][i] = {}
            end
            items[i].name = commandData[_id][i].spawnName
            items[i].quantity = commandData[_id][i].quantity
            console.debug(items[i].name, items[i].quantity)
        end
    end
    if ins then
        return
    end
    console.debug("splitItem", #commandData[_id], commandData[_id][1].spawnName, commandData[_id][1].quantity, json.encode(commandData[_id][1]))
    if #commandData[_id] == 1 and commandData[_id][1].quantity < 4 then
        for i = 1, commandData[_id][1].quantity do
            items[i] = {}
            items[i].name = commandData[_id][1].spawnName
            items[i].quantity = 1
            console.debug("Item0-1", items[i].name, items[i].quantity)
        end
        return
    end
    if #commandData[_id] == 1 then --if 1 item split in four
        nbr = 0
        for i = 1, 4 do
            items[i] = {}
            items[i].name = commandData[_id][1].spawnName
            items[i].quantity = math.floor(commandData[_id][1].quantity/4)
            console.debug("Item1", items[i].name, items[i].quantity)
            nbr = nbr + math.floor(commandData[_id][1].quantity/4)
        end
        if nbr < commandData[_id][1].quantity then items[4].quantity = items[4].quantity + (commandData[_id][1].quantity - nbr) end
    elseif #commandData[_id] == 2 then --if 2 items split in 2 by 2
        if commandData[_id][1].quantity < 2 then
            items[1] = {}
            items[1].name = commandData[_id][1].spawnName
            items[1].quantity = 1
            console.debug("Item2-1", items[1].name, items[1].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i] = {}
                items[i].name = commandData[_id][1].spawnName
                items[i].quantity = math.floor(commandData[_id][1].quantity/2)
                console.debug("Item2-1", items[i].name, items[i].quantity)
                nbr = nbr + math.floor(commandData[_id][i].quantity/2)
            end
            if nbr < commandData[_id][1].quantity then items[2].quantity = items[2].quantity + (commandData[_id][1].quantity - nbr) end
        end
        if commandData[_id][2].quantity < 2 then
            items[3] = {}
            items[3].name = commandData[_id][1].spawnName
            items[3].quantity = 1
            console.debug("Item2-1", items[3].name, items[3].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i+2] = {}
                items[i+2].name = commandData[_id][2].spawnName
                items[i+2].quantity = math.floor(commandData[_id][2].quantity/2)
                console.debug("Item2-2", items[i+2].name, items[i+2].quantity)
                nbr = nbr + math.floor(commandData[_id][2].quantity/2)
            end
            if nbr < commandData[_id][2].quantity then items[4].quantity = items[4].quantity + (commandData[_id][2].quantity - nbr) end
        end
    elseif #commandData[_id] == 3 then --if 3 items split in 2 the bigger en 2 other
        local bigger = 0
        local indexE = 1
        for i = 1, #commandData[_id] do --find the biggest quantity item
            if commandData[_id][i].quantity > bigger then
                bigger = commandData[_id][i].quantity
                indexE = i
            end
        end
        console.debug("big", bigger, indexE)
        if commandData[_id][indexE].quantity < 2 then
            items[1] = {}
            items[1].name = commandData[_id][indexE].spawnName
            items[1].quantity = 1
            console.debug("Item3-1", items[1].name, items[1].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i] = {}
                items[i].name = commandData[_id][indexE].spawnName
                items[i].quantity = math.floor(commandData[_id][indexE].quantity/2)
                console.debug("Item3-1", items[i].name, items[i].quantity)
                nbr = nbr + math.floor(commandData[_id][i].quantity/2)
            end
            if nbr < commandData[_id][indexE].quantity then items[2].quantity = items[2].quantity + (commandData[_id][indexE].quantity - nbr) end
        end
        local j = 3
        for i = 1, #commandData[_id] do --find the biggest quantity item
            if i ~= indexE then
                items[j] = {}
                items[j].name = commandData[_id][i].spawnName
                items[j].quantity = math.floor(commandData[_id][i].quantity)
                console.debug("Item3-2", items[j].name, items[j].quantity)
                j = j + 1
            end
        end
    else  --if 4 items or more split in 3 plus the other
        for i = 1, 4 do
            items[i] = {}
            items[i].name = commandData[_id][i].spawnName
            items[i].quantity = math.floor(commandData[_id][i].quantity)
            console.debug("Item4-1", items[i].name, items[i].quantity)
        end

        -- Add to remainingItems
        for i = 5, #commandData[_id] do
            table.insert(remainingItems, {name = commandData[_id][i].spawnName, quantity = math.floor(commandData[_id][i].quantity)})
        end

        -- for i = 1, #commandData do --find the biggest quantity item
        --     items[4] = {}
        --     items[4].name = commandData[i].spawnName
        --     items[4].quantity = math.floor(commandData[i].quantity)
        --     console.debug("Item4-2", items[i].name, items[i].quantity)
        -- end
    end
end

local function endDeliveryMessage(crew, thatdeliveryId)
    if ownerName[thatdeliveryId] == true then
        if crew == VFW.PlayerData.faction.name then
            VFW.ShowNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Ta commande est finie, échappe toi !",
                duration = 20,
            })
        else
            VFW.ShowNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Une commande vient d'être terminée, poursuis-les !",
                duration = 20,
            })
        end
    else
        if ownerName[thatdeliveryId] == VFW.PlayerData.faction.name then
            VFW.ShowNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Tu viens de te faire voler ta livraison, viens la retrouver !",
                duration = 20,
            })
        elseif crew == VFW.PlayerData.faction.name then
            VFW.ShowNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Tu as volé une commande, échappe toi !",
                duration = 20,
            })
        else
            VFW.ShowNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Une commande vient d'être volée, poursuis-les !",
                duration = 20,
            })
        end
    end
    RemoveBlip(blipMissions[thatdeliveryId])
end

RegisterNetEvent("core:tablet:startMission", function(dataDeliveries, crewName, typeObject, _data, _id, crewTypeNeeed)
    console.debug("Start command ID : ", _id)
    if string.lower(VFW.PlayerData.faction.name) == "nocrew" then
        console.debug("Dont start command because no crew")
        return
    end
    if crewTypeNeeed then
        local playerFactionName = string.lower(VFW.PlayerData.faction.name or "families")
        local playerFactionType = string.lower(VFW.PlayerData.faction.type or "gang")
        local requiredCrewName = string.lower(crewName)
        local requiredCrewType = string.lower(crewTypeNeeed)
        if playerFactionName ~= requiredCrewName and playerFactionType ~= requiredCrewType then
            console.debug("Not the same crew type", VFW.PlayerData.faction.type, crewTypeNeeed)
            return
        end
    else
        console.debug("No crew type needed")
    end
    deliveryId[_id] = true -- For multiple commands at once
    dataTablette[_id] = _data  -- For multiple commands at once
    commandData[_id] = dataDeliveries -- quantity type spawnName
    propsToSpawn[_id] = Drugs.props.ground[typeObject or "drugs"]
    ownerName[_id] = true -- For multiple commands at once
    splitItem(_id)
    if VFW.PlayerData.faction.name == crewName then
        console.debug("1")
        inDrugsDeliveries[_id] = true
        --TriggerServerEvent("drugsDeliveries:msg1", vector2(dataTablette.pos.x, dataTablette.pos.y))
        VFW.ShowNotification({
            type = 'ILLEGAL',
            name = "Kannan",
            label = "Livraison",
            labelColor = "#F3F049",
            logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
            mainMessage = "Hey, ta livraison viens d'arriver, va vite la chercher !",
            duration = 20,
        })
        startDrugsDeliveries(_id)
        if dataTablette[_id].objects then
            local objects = dataTablette[_id].objects
            if #objects > 0 and objects[1].pos then
                local pos = objects[1].pos
                blipMissions[_id] = AddBlipForCoord(pos.x, pos.y, pos.z)
            end
        else
            blipMissions[_id] = AddBlipForCoord(dataTablette[_id].pos.x, dataTablette[_id].pos.y, dataTablette[_id].pos.z)
        end
        SetNewWaypoint(dataTablette[_id].pos.x, dataTablette[_id].pos.y)
        SetBlipSprite(blipMissions[_id], 478)
        SetBlipScale(blipMissions[_id], 0.75)
        SetBlipColour(blipMissions[_id], 3)
        SetBlipAsShortRange(blipMissions[_id], true)
        SetBlipRoute(blipMissions[_id], true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("~r~Livraison")
        EndTextCommandSetBlipName(blipMissions[_id])
        SetTimeout(5*60000, function()
            RemoveBlip(blipMissions[_id])
        end)
    else
        Wait(10000)
        inDrugsDeliveries[_id] = true
        VFW.ShowNotification({
            type = 'ILLEGAL',
            name = "Kannan",
            label = "Livraison",
            labelColor = "#F3F049",
            logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
            mainMessage = "Hey, une livraison viens d'arriver, va vite la voler !",
            duration = 20,
        })
        setEnemyBlip(dataTablette[_id].pos, _id)
        startDrugsDeliveries(_id)
        SetTimeout(2*60000, function()
            RemoveBlip(EnemyBlips[delId])
        end)
        --elseif VFW.PlayerData.faction.name ~= "None" then --todo check in bdd if crew have drugs weapond ect + add other crew on start script too
    end
end)

RegisterNetEvent("core:removeBulleTablet", function(id)
    -- TODO : Remove bulle
    --Bulle.remove("trailerSell"..id)
end)

RegisterNetEvent("core:tablet:endDelivery", function(deliveryIde, crew)
    if deliveryId[deliveryIde] then
        inDrugsDeliveries[deliveryIde] = false
        endDeliveryMessage(crew, deliveryIde)
        if dataTablette[deliveryIde] and dataTablette[deliveryIde].objects then
            for k,v in pairs(dataTablette[deliveryIde].objects) do
                if v and v.netId then
                    -- Suppression de l'interaction/marker
                    VFW.DestroyInteract(k)
                end
            end
        end
        Wait(1000)
        deliveryId[deliveryIde] = nil
    end
end)