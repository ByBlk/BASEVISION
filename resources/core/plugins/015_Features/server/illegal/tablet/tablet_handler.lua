VFW.IllegalTablet = {
    CommandToDo = {},
    CommandNeeds = {},
    HourTabletTaken = {},
    CrewCooldown = {}
}

local crewCommandes = {}

local DoesEntityExist <const> = DoesEntityExist
local SetEntityDistanceCullingRadius <const> = SetEntityDistanceCullingRadius
local CreateObject <const> = CreateObject

local function addItemToTrunk(plate, item, count)
    --@TODO a chack demanin
    local chest = VFW.GetChest("veh:"..plate)
    if (not chest) then
        chest = VFW.TempChest("tempVeh:"..plate, 50, plate)
    end
    if not chest then return end
    chest.createItem(item, count)
end

RegisterNetEvent("core:tablet:addItemToTrunk", function(plate, item, nbr, actualDeliveryId)
    local source = source
    console.debug("enter to add item to trunk : ", plate, item, nbr, actualDeliveryId)
    if (not VFW.DoesItemExist(item)) then 
        TriggerClientEvent("vfw:showNotification", source, {
            type = "ROUGE",
            content = "L'item "..item.." n'existe pas, merci de montrer ce message au STAFF (pas au dev)."
        })
        return
    end
    if (not VFW.IllegalTablet.CommandNeeds[actualDeliveryId]) then
        TriggerClientEvent("vfw:showNotification", source, {
            type = "ROUGE",
            content = "La commande a déjà était prise 1."
        })
        return 
    end 
    if VFW.IllegalTablet.CommandNeeds[actualDeliveryId].total <= 0 then 
        TriggerClientEvent("vfw:showNotification", source, {
            type = "ROUGE",
            content = "La commande a déjà était prise 2."
        })
        return 
    end
    if VFW.IllegalTablet.CommandNeeds[actualDeliveryId].total - nbr < 0 then 
        return 
    end
    VFW.IllegalTablet.CommandNeeds[actualDeliveryId].total -= nbr
    console.debug("Added to trunk : ", item, nbr)
    console.debug("AddItemToInventoryVehicleStaff", plate, item, tonumber(nbr))
    addItemToTrunk(plate, item, tonumber(nbr))
end)

local DeliveryIndexes = {}
RegisterServerCallback("core:tablet:getIndex", function(source, namecrew, deliveryId)
    if not DeliveryIndexes[deliveryId] then 
        DeliveryIndexes[deliveryId] = 1
        return 1
    else
        DeliveryIndexes[deliveryId] += 1
        if DeliveryIndexes[deliveryId] >= 4 then 
            console.debug("Finished livraison id " .. deliveryId)
            TriggerClientEvent("core:tablet:endDelivery", -1, deliveryId, namecrew)
            SetTimeout(2000, function()
                DeliveryIndexes[deliveryId] = "finished"
                VFW.IllegalTablet.CommandNeeds[deliveryId] = nil
            end)
        end
        return DeliveryIndexes[deliveryId] ~= nil and DeliveryIndexes[deliveryId] or 4
    end
end)

local function addToCooldown(source, command)
    local player = VFW.GetPlayerFromId(source)
    local crew = player.getFaction().name
    for i = 1, #command do
        local item = command[i]
        if VFW.IllegalTablet.CrewCooldown[crew] then
            if VFW.IllegalTablet.CrewCooldown[crew][item.spawnName] then
                VFW.IllegalTablet.CrewCooldown[crew][item.spawnName].quantity = VFW.IllegalTablet.CrewCooldown[crew][item.spawnName].quantity + item.quantity
            else
                local cooldownValue = (type(item.cooldown) == "number" and item.cooldown > 0) and item.cooldown or 0
                VFW.IllegalTablet.CrewCooldown[crew][item.spawnName] = {quantity = item.quantity, cooldown = cooldownValue}
            end
        else
            local cooldownValue = (type(item.cooldown) == "number" and item.cooldown > 0) and item.cooldown or 0
            VFW.IllegalTablet.CrewCooldown[crew] = {}
            VFW.IllegalTablet.CrewCooldown[crew][item.spawnName] = {quantity = item.quantity, cooldown = cooldownValue}
        end
    end
end

local function addCommandToBdd(order, time, date, total, typeObject, crewName)
    local id = MySQL.Sync.insert("INSERT INTO `tablet_command` (`order`, `time`, `date`, `total`, `typeObject`, `done`, `crewName`) VALUES (@1, @2, @3, @4, @5, @6, @7)",
        {
            ["1"] = tostring(json.encode(order)),
            ["2"] = time,
            ["3"] = tostring(date),
            ["4"] = total,
            ["5"] = typeObject,
            ["6"] = false,
            ["7"] = crewName
        })

    return id
end

local function saveCommand(source, data, crewName)
    local player = VFW.GetPlayerFromId(source)
    local total = tonumber(data.total)
    if (not total) then return false end
    if player.getMoney() < total then
        return false
    end
    player.removeMoney(total)
    local typeObject = data.order[1].type
    local date = os.date("%Y-%m-%dT%X")--2022-12-05T22:30:17-01:00
    if next(VFW.IllegalTablet.CommandToDo) then
        for i = 1, #VFW.IllegalTablet.CommandToDo do
            local command = VFW.IllegalTablet.CommandToDo[i]
            if command.time == data.time and command.crewName == crewName then
                TriggerClientEvent('core:tablet:saveCommandReturn', source, "Votre crew a déjà une livraison à cette heure ci", data.order, data.total, typeObject)
                return
            end
        end
    end
    if VFW.IllegalTablet.HourTabletTaken[tostring(data.time)] == true then 
        TriggerClientEvent('core:tablet:saveCommandReturn', source, "Cette horraire n'est pas disponible, choisi en une autre")
        return
    end
    VFW.IllegalTablet.HourTabletTaken[tostring(data.time)] = true
    local id = addCommandToBdd(data.order, data.time, date, data.total, typeObject, crewName)

    if not crewCommandes[crewName] then
        crewCommandes[crewName] = {}
    end
    table.insert(crewCommandes[crewName], {
        id = id,
        order = data.order,
        time = data.time,
        date = date,
        total = data.total,
        typeObject = typeObject,
        crewName = crewName,
        quantity = data.quantity,
    })

    local timer = 1
    console.debug("La faction "..crewName.." à passé la commande id : ",id,data.time)
    while (not id) and (timer < 50) do 
        Wait(1) 
        timer += 1
    end
    addToCooldown(source, data.order)
    VFW.IllegalTablet.CommandToDo[#VFW.IllegalTablet.CommandToDo + 1] = {
        id = id,
        order = data.order,
        time = data.time,
        date = date,
        total = data.total,
        typeObject = typeObject,
        crewName = crewName,
        quantity = data.quantity,
        done = false
    }
    -- TODO : Logs
    --SendDiscordLog("tablet", source, string.sub(GetDiscord(source), 9, -1),
    --    GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), crewName,
    --    json.encode(data.order))
    TriggerClientEvent('core:tablet:saveCommandReturn', source, true, data.order, data.total, typeObject)
    return true
end

RegisterServerCallback("core:tablet:saveCommand", saveCommand)

local function initTabletData()
    math.randomseed(GetGameTimer()) -- Real random
    local ramdom = math.random(1, #Drugs.Delivery)
    data = Drugs.Delivery[ramdom]
    return data
end

local function callService(pos)
    SetTimeout(30000, function()
        -- TODO Call lspd
        TriggerEvent('core:alert:makeCall', "lspd", vector3(pos.x, pos.y, pos.z), true, "Colis illégal", false, "illegal")
        TriggerEvent('core:alert:makeCall', "lssd", vector3(pos.x, pos.y, pos.z), true, "Colis illégal", false, "illegal")
        --makeCallGreatAgain('lspd', pos, "Livraison suspecte", "drugs")
        --makeCallGreatAgain('lssd', pos, "Livraison suspecte", "drugs")
    end)
end

local function formulateOrder(order)
    local data = {}
    for i = 1, #order do
        local item = order[i]
        data[#data + 1] = {
            quantity = item.quantity,
            name = item.name,
            type = item.type,
            spawnName = item.spawnName,
        }
    end
    return data
end

Citizen.CreateThread(function()
    while true do
        Wait(1 * 20000) -- 30 seconds
        for k, v in pairs(VFW.IllegalTablet.CommandToDo) do
            if (tostring(v.time) == tostring(os.date("%H:%M"))) and (v.done ~= true) then
                v.done = true
                local crewNameCreator = v.crewName
                local dataInit = initTabletData()
                VFW.IllegalTablet.HourTabletTaken[tostring(data.time)] = nil
                local crewType = VFW.Factions[crewNameCreator] and VFW.Factions[crewNameCreator].type or "gang"
                dataInit.objects = {}
                local propsSpawnName = `hei_prop_hei_drug_pack_01b`
                if v.typeObject == "weapons" then
                    propsSpawnName = `prop_box_guncase_01a`
                elseif v.typeObject == "utils" then
                    propsSpawnName = `prop_tool_box_04`
                end
                for _, x in pairs(dataInit.props) do
                    local object = CreateObject(propsSpawnName, x.posProp, true, true)
                    local timer = 1
                    while (not DoesEntityExist(object)) and (timer < 50) do Wait(1) timer += 1 end
                    if object and DoesEntityExist(object) then
                        FreezeEntityPosition(object, true)
                        SetEntityDistanceCullingRadius(object, 999.9)
                        table.insert(dataInit.objects, {pos = x.posProp, netId = NetworkGetNetworkIdFromEntity(object)})
                    end
                end
                VFW.IllegalTablet.CommandNeeds[v.id] = { total = 0 }
                for i = 1, #v.order do
                    local item = v.order[i]
                    VFW.IllegalTablet.CommandNeeds[v.id].total = VFW.IllegalTablet.CommandNeeds[v.id].total + item.quantity
                end
                console.debug("Envoi de la commande aux clients :", crewNameCreator, crewType, v.id)
                local sendData = {}
                sendData.objects = dataInit.objects
                sendData.pos = dataInit.pos

                console.debug("Commandes à faire : ", json.encode(v.order, {indent = true}))
                -- TODO ne pas envoyer de table
                TriggerClientEvent("core:tablet:startMission", -1, formulateOrder(v.order), crewNameCreator, v.typeObject, sendData, v.id, crewType)
                callService(dataInit.pos)
                MySQL.Async.execute("UPDATE `tablet_command` SET `done` = @done WHERE `date` = @date and `time` = @time and `crewName` = @crewName",
                {
                    ["done"] = v.done,
                    ["date"] = v.date,
                    ["time"] = v.time,
                    ["crewName"] = v.crewName
                }, function(result)

                end)
                Wait(200)
                VFW.IllegalTablet.CommandToDo[k] = nil
            end
        end
    end
end)

local function getCooldowns(source)
    local player = VFW.GetPlayerFromId(source)
    local crew = player.getFaction().name
    if VFW.IllegalTablet.CrewCooldown[crew] then
        return VFW.IllegalTablet.CrewCooldown[crew]
    end
end

RegisterServerCallback("core:tablet:getCooldowns", getCooldowns)

RegisterNetEvent("deleteObject", function(netid)
    netid = tonumber(netid)
    if netid and netid > 0 then
        local object = NetworkGetEntityFromNetworkId(netid)
        if DoesEntityExist(object) then DeleteEntity(object) end
    end
end)

VFW.RegisterUsableItem("tablet", function(player, deleteCallback, metaData)
    player.triggerEvent("core:tablet:open")
end)

RegisterServerCallback("core:crew:getCrewOrders", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return {} end
    local faction = xPlayer.getFaction()
    if faction.name == "nocrew" then return {} end

    return crewCommandes[faction.name] or {}

end)


RegisterNetEvent("core:crew:updateXp", function(xp)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    local crewName = player.getFaction().name
    if not crewName then return end

    local crew = VFW.GetCrewByName(crewName)
    crew.addXp(xp)

end)

-- Useless ?
 MySQL.ready(function()
     MySQL.Async.fetchAll("SELECT * FROM tablet_cooldown", {}, function(result)
         if result ~= nil then
             for i = 1, #result do
                 if not VFW.IllegalTablet.CrewCooldown[result[i].crewName] then
                     VFW.IllegalTablet.CrewCooldown[result[i].crewName] = {}
                 end
                 VFW.IllegalTablet.CrewCooldown[result[i].crewName][result[i].item] = {quantity = result[i].quantity, cooldown = result[i].cooldown}
             end
             console.debug("[^2INFO^7] Tous les cooldowns de la tablette ont été chargées")
         end
     end)

     MySQL.Async.fetchAll("SELECT * FROM tablet_command", {}, function(result)
         if result ~= nil then
             for _, v in pairs(result) do
                 if not crewCommandes[v.crewName] then
                        crewCommandes[v.crewName] = {}
                 end
                 table.insert(crewCommandes[v.crewName], {
                     id = v.id,
                     order = json.decode(v.order),
                     time = v.time,
                     date = v.date,
                     total = v.total,
                     typeObject = v.typeObject,
                     crewName = v.crewName,
                     done = v.done
                 })
             end
         end
     end)
 end)