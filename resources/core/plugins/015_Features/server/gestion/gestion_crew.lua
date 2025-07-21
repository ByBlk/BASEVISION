local accents = {
    ['é'] = 'e', ['è'] = 'e', ['ê'] = 'e', ['ë'] = 'e',
    ['à'] = 'a', ['â'] = 'a', ['ä'] = 'a',
    ['ù'] = 'u', ['û'] = 'u', ['ü'] = 'u',
    ['ï'] = 'i', ['î'] = 'i',
    ['ô'] = 'o', ['ö'] = 'o',
    ['ÿ'] = 'y',
    ['ñ'] = 'n',
    ['ç'] = 'c',
    ['œ'] = 'oe',
    ['æ'] = 'ae'
}

VFW.GestionCrew = {}

VFW.GestionCrew.CrewLaboratories = {
    ["gang"] = "weed",
    ["mc"] = "meth",
    ["mafia"] = "coke",
    ["orga"] = "fentanyl"
}

--[[
    Example : 
    console.debug(labelToName("École Élémentaire")) -- output: ecole_elementaire
    console.debug(labelToName("Café & Thé")) -- output: cafe_the
]]
function VFW.GestionCrew.LabelToName(label)
    if not label then
        return ""
    end

    local name = string.lower(label)

    -- Remove accents
    for accented, normal in pairs(accents) do
        name = name:gsub(accented, normal)
    end

    -- Replace spaces with underscores
    name = name:gsub("%s+", "_")

    -- Delete all non-alphanumeric characters
    name = name:gsub("[^%w_]", "")

    return name
end

function VFW.GestionCrew.DeleteNewFaction(id, src)

    local crew = VFW.GetCrewByName(id)

    if crew then
        crew.id = id
        crew.grades = {
            { grade = 0, name = "recrue", label = "Recrue" },
            { grade = 1, name = "membre", label = "Membre" },
            { grade = 2, name = "soldat", label = "Soldat" },
            { grade = 3, name = "brasdroit", label = "Bras droit" },
            { grade = 4, name = "souschef", label = "Sous chef" },
            { grade = 5, name = "chef", label = "Chef" }
        }

        VFW.CreateFaction(VFW.GestionCrew.LabelToName(id),  crew.name,  crew.grades)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Vous avez acceptée la demande de création du groupe " .. id .. "."
        })

        console.debug("Creaor : ", crew.creator)

        local targetPlayer = VFW.GetPlayerFromIdentifier(crew.creator)
        console.debug("Target : ", targetPlayer.source)
        if (not targetPlayer) then
            return
        end
        console.debug("Target : ", targetPlayer.name, "source : ", targetPlayer.source)
        targetPlayer.setFaction(id, 5)
        TriggerClientEvent("vfw:showNotification", targetPlayer.source, {
            type = 'VERT',
            content = "Votre demande de création du groupe " .. id .. " a été acceptée. Vous pouvez désormais inviter des membres."
        })

        crew.state = true
        crew:save()
    end
end

RegisterServerCallback("core:factions:getNewOrganizations", function(src)
    local newOrga = {}
    for k, v in pairs(VFW.Gestion.Organizations) do
        console.debug("Organization new : ", v.name, v.state)
        if not v.state then
            table.insert(newOrga, v.data())
        end
    end
    return newOrga
end)

RegisterServerCallback("core:crew:getTerritories", function(src)
    local xPlayer = VFW.GetPlayerFromId(src)
    local crew = xPlayer.getFaction().name

    local territories = VFW.TerritoriesServer.GetTerritoriesByLeader(crew)
    return territories
end)

RegisterServerCallback("core:factions:getOrganizations", function(src)
    local orga = {}
    for k, v in pairs(VFW.Gestion.Organizations) do
        console.debug("Organization : ", v.name, v.state)
        if v.state then
            table.insert(orga, v.data())
        end
    end
    return orga
end)

RegisterServerCallback("core:crew:getProperties", function(source, name)
    return VFW.GetCrewProperty(name)
end)

RegisterServerCallback("core:crew:getVehicles", function(source, name)
    return VFW.GetCrewByName(name).vehicles
end)

RegisterServerCallback("core:gestion-factions:addMember", function(source, data)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_crew"]
    if not perm then return {state = false} end

    local crew = VFW.GetCrewByName(data.crew)
    if not crew then return {state = false} end

    local targetPlayer = VFW.GetPlayerFromIdentifier(data.discord)
    if not targetPlayer then return {state = false} end

    targetPlayer.setFaction(data.crew, 0)

    local memberAdd = crew.addMember(data.discord, targetPlayer.name)
    return {  state = true, value =  memberAdd}

end)

RegisterServerCallback("core:gestion-factions:addVehicle", function(source, data)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_crew"]
    if not perm then return {state = false} end

    local crew = VFW.GetCrewByName(data.crew)
    if not crew then return {state = false} end

    local vehiclePlate = crew.addVehicle(data.vehicle)

    return {state = true, name = data.vehicle, plate = vehiclePlate}
end)

RegisterNetEvent("core:gestion-factions:join", function(data)
    local src = source
    local player = VFW.GetPlayerFromId(src)
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_crew"]
    if not perm then return end

    local crew = VFW.GetCrewByName(data)
    if not crew then return end

    player.setFaction(data, 5)

    crew.addMember(player.identifier, player.getName())


end)

RegisterNetEvent("core:gestion-factions:start", function(crewId)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    local perm = playerGlobal.permissions["gestion_crew"]
    if perm then

        local crew = VFW.GetCrewByName(crewId)
        if not crew then return end

        local garage = crew.posGarage
        local craft = crew.posCraft
        local stockage = crew.posStockage
        local laboratory = crew.posLaboratory
        local crewName = crew.name
        local crewType = crew.type
        console.debug("Crew type ", crew.type)
        local owner = crew.creator
        local ownerData = VFW.GetPlayerFromId(owner)

        if laboratory.x ~= 0 and laboratory.y ~= 0 and laboratory.z ~= 0 then
            local laboratoryId = VFW.Laboratories.CreateLaboratory(crewName, laboratory, VFW.GestionCrew.CrewLaboratories[crewType])
            crew.laboratoryId = laboratoryId
        end

        if craft.x ~= 0 and craft.y ~= 0 and craft.z ~= 0 then
            --VFW.Crafts.CreateCraftTable(crewName, craft)
        end

        if stockage.x ~= 0 and stockage.y ~= 0 and stockage.z ~= 0 then
            local info = {
                nameProperty = "Petit Stockage"
            }
            local propertyData = VFW.CreateProperty(3, "crew:" .. crewName, "Stockage " .. crewName, {}, vector3(stockage.x, stockage.y, stockage.z), info, 0)
            VFW.CreateChest("property:" .. propertyData.id, 100, "Stockage " .. crewName)
            crew.stockageId = propertyData.id
            -- Log Discord Coffre Crew/Stockage
            if logs and logs.society and logs.society.crewSafe then
                logs.society.crewSafe(src, crewName)
            end
        end

        if garage.x ~= 0 and garage.y ~= 0 and garage.z ~= 0 then
            local info = {
                maxPlaces = 10,
                vehicles = {}
            }
            local propertyData = VFW.CreateProperty(2, "crew:" .. crewName, "Garage " .. crewName, {}, vector3(garage.x, garage.y, garage.z), info, 0)

            crew.garageId = propertyData.id
        end

        VFW.GestionCrew.DeleteNewFaction(crewName, src)
    else
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission de créer un groupe."
        })
    end
end)


RegisterNetEvent("core:gestion-factions:save", function(data, hierarchie)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_crew"]

    if not perm then
        return
    end

    if not data.name then
        return
    end

    local crew = VFW.GetCrewByName(data.name)

    if crew then

        local lastCoordLabo = crew.posLaboratory

        crew.label = data.name
        crew.setType(data.type)
        crew.color = data.color
        crew.devise = data.moto
        crew.creator = data.lead
        crew.level = data.level
        crew.xp = data.experience
        crew.hierarchie = hierarchie
        crew.place = data.place
        crew.posGarage = data.posGarage
        crew.posCraft = data.posCraft
        crew.posStockage = data.posStockage


        if lastCoordLabo ~= data.posLaboratory then
            crew.posLaboratory = data.posLaboratory
            TriggerClientEvent("vfw:showNotification", src, {
                type = 'ROUGE',
                content = "Nouveau point labo dispo au prochain reboot"
            })
        end

        crew.image = data.image

        crew.save()
    end

end)

RegisterNetEvent("core:gestion-factions:delete", function(name)
    local src = source
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_crew"]
    if perm then
        VFW.DeleteFaction(name)
        console.debug("[^2INFO^7] La faction " .. name .. " a été supprimée.")
        TriggerClientEvent("core:faction:deleteFaction", -1, name)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'ROUGE',
            content = "Vous avez supprimé le groupe " .. name .. "."
        })
    else
        DropPlayer(src, "Que fait un chinois sur un moto ? Nemnemnem")
    end
end)

RegisterServerCallback("core:crew:getCrewDataByName", function(source, name)
    return VFW.GetCrewByName(name)
end)