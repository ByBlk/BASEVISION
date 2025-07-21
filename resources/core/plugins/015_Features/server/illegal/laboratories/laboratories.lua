VFW.Laboratories = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM laboratories", {}, function(result)
        if result ~= nil then
            for i = 1, #result do

                    CreateLaboratory(result[i].id, result[i].crew, result[i].laboType, json.decode(result[i].coords), result[i].state, result[i].minutes, result[i].maxTime, result[i].drugs, false, json.decode(result[i].percentages), false)
            end
            console.debug("[^2INFO^7] Loaded all laboratories")
        else
            console.debug("[^2INFO^7] Couldn't load laboratory, ^1empty table or no sql^7")
        end
    end)
end)

RegisterServerCallback("core:lab:launchProduction", function(source, id, itemCountOne, itemCountTwo, itemCountThree, amountNeedOne, amountNeedTwo, amountNeedThree)
    ---@type itemCountOne string First item name that we need to produce the drug
    ---@type itemCountTwo string Second item name that we need to produce the drug
    ---@type itemCountThree string Third item name that we need to produce the drug
    ---@type amountNeedOne number Amount of the first item that we need to produce the drug
    ---@type amountNeedTwo number Amount of the second item that we need to produce the drug
    ---@type amountNeedThree number Amount of the third item that we need to produce the drug
    if (itemCountOne == nil and itemCountTwo == nil and itemCountThree == nil) or (itemCountOne == 0 and itemCountTwo == 0 and itemCountThree == 0) then
        return false
    end
    local src = source
    local player = VFW.GetPlayerFromId(src)

    -- Exception pour l'essence : si l'item demandé est "essence", on vérifie "weapon_petrolcan"
    local actualItemOne = itemCountOne == "essence" and "weapon_petrolcan" or itemCountOne
    local actualItemTwo = itemCountTwo == "essence" and "weapon_petrolcan" or itemCountTwo
    local actualItemThree = itemCountThree == "essence" and "weapon_petrolcan" or itemCountThree

    local hasItemOne = player.haveItem(actualItemOne)
    local hasItemTwo = player.haveItem(actualItemTwo)
    local hasItemThree = player.haveItem(actualItemThree)

    if hasItemOne and hasItemTwo and hasItemThree then

        local CountOne = player.countItem(actualItemOne, {})
        local CountTwo = player.countItem(actualItemTwo, {})
        local CountThree = player.countItem(actualItemThree, {})

        if CountOne < amountNeedOne or CountTwo < amountNeedTwo or CountThree < amountNeedThree then
            return false
        end

        player.removeItem(actualItemOne, amountNeedOne, {})
        player.removeItem(actualItemTwo, amountNeedTwo, {})
        player.removeItem(actualItemThree, amountNeedThree, {})
        player.updateInventory()
        return true

    else
        return false
    end

end)

function VFW.Laboratories.UpdateLaboratoryPosition(name, coords)
    local lab = GetLaboByCrew(name)
    if not lab then
        return
    end
    MySQL.Async.execute("UPDATE laboratories SET coords = @coords WHERE crew = @crew", {
        ['@coords'] = json.encode(coords),
        ['@crew'] = name
    })
    lab.updateCoords(coords)
    return true
end

function VFW.Laboratories.CreateLaboratory(nameCrew, entry, typeLabs)
    local crew = nameCrew
    local _src = source

    if GetLaboByCrew(nameCrew) then
        TriggerClientEvent("vfw:showNotification", _src, {
            type = 'ROUGE',
            content = "Impossible de créer un deuxieme laboratoire pour le crew " .. nameCrew .. " !"
        })
        return nil
    end

    if (not crew) or (not VFW.GetCrewByName(crew)) then
        TriggerClientEvent("vfw:showNotification", _src, {
            type = 'ROUGE',
            content = "Le crew n'existe pas !"
        })
        return nil
    else
        local promise = promise.new()

        MySQL.Async.insert("INSERT INTO laboratories (crew, laboType, coords, minutes, state, drugs, maxTime, percentages) VALUES (@crew, @laboType, @coords, @minutes, @state, @drugs, @maxTime, @percentages)"
        , {
                    ['@crew'] = crew,
                    ['@laboType'] = typeLabs,
                    ['@minutes'] = 0,
                    ['@coords'] = json.encode(entry),
                    ['@state'] = 0,
                    ['@drugs'] = 180,
                    ['@maxTime'] = 120,
                    ['@percentages'] = json.encode({ 0, 0, 0 })
                }, function(affectedRows)

                    CreateLaboratory(affectedRows, crew, typeLabs, entry, 0, 0, 120, 180, false, { 0, 0, 0 }, false)
                    TriggerClientEvent("vfw:showNotification", _src, {
                        type = 'VERT',
                        content = "Vous avez bien créé le laboratoire !"
                    })
                    TriggerClientEvent("core:createNewLab", -1, affectedRows, crew, typeLabs, entry)

                    promise:resolve(affectedRows)
                end)

        return Citizen.Await(promise)
    end
end

RegisterNetEvent("core:labo:clear", function(id)
    local src = source
    local labo = GetLabo(id)
    labo.updateQuantityDrugs(0)
    labo.updateState(0)
    labo.updateMinutes(0)
end)

RegisterNetEvent("core:labo:setOpen", function(id, open)
    local labo = GetLabo(id)
    labo.setOpen(open)
    TriggerClientEvent("core:labo:setOpen", -1, id, open)
end)

RegisterNetEvent("core:labo:alertCrew", function(id, crew)
    local lab = GetLabo(id)
    lab.setAttacked(true)
    TriggerClientEvent("core:labo:alertCrew", -1, id, crew)
end)

-- TODO : Take only id & pos
RegisterServerCallback('core:getLaboratory', function(source)
    return classlabo
end)

RegisterServerCallback('core:getMyLab', function(source, id)
    console.debug("id", id)
    local labo = GetLabo(id)
    if labo == nil then
        return
    end

    return labo
end)

RegisterServerCallback("core:IsFinishedLab", function(source, id)
    local labo = GetLabo(id)
    if labo == nil then
        return
    end
    labo.updateBlocked(false)
    if labo.getMinutes() <= 0 and labo.getState() == 2 then
        return labo.getQuantityDrugs()
    else
        return false
    end
end)

RegisterServerCallback("core:getLabProduction", function(source, id)
    local labo = GetLabo(id)
    return labo.getMinutes(), labo.getPercentages()
end)

RegisterNetEvent("core:labo:LaunchProduction", function(LaboType, LaboQuantity, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes, poswork)
    local src = source
    local percentages = { 100, 100, 100 }
    local player = VFW.GetPlayerFromId(src)
    local playerCrew = VFW.GetCrewByName(player.getFaction().name)
    console.debug("LaboType, LaboQuantity", LaboType, LaboQuantity, percentages, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes, poswork)
    console.debug(json.encode(percentages), percentages[1], percentages[2], percentages[3])
    local labo = GetLabo(labid)
    labo.updatePercentages(percentages)
    labo.updateMaxTime(MaxTimeProd)
    if percentages[1] <= 0 or percentages[2] <= 0 or percentages[3] <= 0 then
        console.debug("labo.getPercentages()", labo.getPercentages())
        TriggerClientEvent("core:labo.changeState", -1, 0, labid, labo.getMinutes(), false, labo.getPercentages())
        labo.updateState(0)
    else
        console.debug("labo.getState()", labo.getState())
        console.debug("labo.getBlocked()", labo.getBlocked())
        if labo.getState() == 1 or labo.getBlocked() then
            console.debug("makeDrug labo.getMinutes()", labo.getMinutes())
            labo.makeDrug(labid, labo.getMinutes())
        else
            labo.updateState(1)
            console.debug("Minutes", Minutes)
            if Minutes and Minutes > 2 then
                labo.updateMinutes(Minutes)
                labo.makeDrug(labid, Minutes)
            else
                console.debug("MaxTimeProd", MaxTimeProd)
                if MaxTimeProd == 0 then
                    labo.updateMinutes(105)
                    labo.makeDrug(labid, 105, 105)
                else
                    if MaxTimeProd > 20 then
                        labo.updateMinutes(MaxTimeProd)
                        labo.makeDrug(labid, MaxTimeProd)
                    else
                        labo.updateMinutes(105)
                        labo.makeDrug(labid, MaxTimeProd)
                    end
                end
            end
        end
        Wait(50)
        labo.updateState(1)
        labo.updateBlocked(false)
        labo.updateQuantityDrugs(quantitydrugs)
        LaboState = 1
        console.debug("send", LaboState, quantitydrugs, labid)
        if playerCrew and playerCrew.name ~= "nocrew" then
            playerCrew.addActivity(player.identifier, "drugs_production")
        end
        TriggerClientEvent("core:labo:StartProduction", -1, labid, percentages, labo.getMinutes(), LaboState, labo.getQuantityDrugs())
    end
end)

RegisterNetEvent("core:lab:amorcing", function()
    -- TODO : Remove item "dynamite"
end)

RegisterNetEvent("core:lab:desamorce", function(id)
    local labo = GetLabo(id)
    labo.setAttacked(false)
    TriggerClientEvent("core:lab:desamorce", -1, id)
end)

RegisterNetEvent("core:lab:ring", function(id, crew)
    local _src = source
    TriggerClientEvent("vfw:showNotification", _src, {
        type = 'VERT',
        content = "Vous avez sonné"
    })
    TriggerClientEvent("core:lab:ring", -1, id, _src)
end)

RegisterNetEvent("core:labo:acceptsonnette", function(id, plyid)
    TriggerClientEvent("core:labo:acceptedsonette", tonumber(plyid), id)
end)

-- TODO : Mettre coté client
RegisterNetEvent("core:labo:getLastLab", function()
    local src = source
    local lastPropId, _type = GetLastPlayerProperty(src)
    if _type ~= "laboratory" then
        return
    end
    TriggerClientEvent("core:labo:enterLab", src, lastPropId)
end)

RegisterNetEvent("core:updateLastLabo", function(enter, labid)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    local lastProperty = {}
    MySQL.Sync.execute("UPDATE `users` SET `last_property` = @property WHERE `identifier` = @identifier", {
        ['@property'] = ((enter and labid and "L" .. labid) or nil),
        ['@identifier'] = player.identifier
    })
    SetPlayerRoutingBucket(src, enter == false and 0 or labid)
end)

RegisterNetEvent("core:lab:takeDrugs", function(id, quantity)
    local src = source
    local lab = GetLabo(id)
    local labQuantity = lab.getQuantityDrugs()
    console.debug("labQuantity", labQuantity)
    if quantity <= labQuantity then
        lab.updateQuantityDrugs(labQuantity - quantity)
        local labType = lab.getlaboType()
        local player = VFW.GetPlayerFromId(src)
        player.createItem(labType, quantity)
        player.updateInventory()
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Vous avez bien récupéré x" .. quantity .. " " .. labType .. " !"
        })
        lab.updateState(2)
        if labQuantity - quantity <= 0 then
            lab.updatePercentages({ 0, 0, 0 })
            lab.updateQuantityDrugs(0)
            lab.updateState(0)
            lab.removeEntities()
            TriggerClientEvent("core:labo:sendnotif", src, lab.getCrew(), 55, id)
        end
    else
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous ne pouvez pas prendre plus de drogues que le laboratoire en possède !"
        })
    end
end)

RegisterNetEvent("core:labo:deleteLabo", function(laboid)
    local source = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if playerGlobal.permissions["gestion"] then
        local labo = GetLabo(laboid)
        labo.deleteLabo()
        TriggerClientEvent("core:labo:gotDeleted", -1, laboid)
        TriggerClientEvent("vfw:showNotification", source, {
            type = 'VERT',
            content = "Vous avez supprimé le laboratoire n°" .. laboid
        })
    else
        TriggerClientEvent("vfw:showNotification", source, {
            type = 'ROGUE',
            content = "Permissions \"gestion\" manquantes pour supprimer un laboratoire"
        })
    end
end)

RegisterNetEvent("core:labo:rmpeds", function(id)
    local labo = GetLabo(id)
    labo.removeEntities()
end)

RegisterNetEvent('core:labo:instance', function(netid, id)
    local labo = GetLabo(id)
    labo.addEntity(netid)
    local entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityRoutingBucket(entity, id)
end)