
RegisterNetEvent("core:gestion-tablet:newTabletItems", function(datas)
    local src = source 
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_tablet"]
    if perm then
        local groups = {}
        for i = 1, #datas do 
            local data = datas[i]
            local gangType = data.crewType
            if not groups[gangType] then 
                groups[gangType] = {}
            end
            data.img = nil 
            data.itemType = data.matierePremiere == true and "matierePremiere" or "armes"
            data.matierePremiere = nil 
            data.armes = nil
            data.crewType = nil
            groups[gangType][#groups[gangType] + 1] = data
        end

        for k, v in pairs(groups) do 
            VFW.Variables.SetVariable(k, v)
        end

        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Variables modifiées avec succès"
        })
    end
end)

RegisterServerCallback("core:gestion-tablet:getAllFactionsVariables", function()
    local variablesNeedded = {
        "gang",
        "organisation",
        "mafia",
        "mc"
    }
    local allVariables = {}
    for i = 1, #variablesNeedded do 
        local variable = VFW.Variables.GetVariable(variablesNeedded[i])
        for j = 1, #variable do 
            local data = variable[j]
            data.crewType = variablesNeedded[i]
            data.stock = tonumber(data.stock) or 0
            data.price = tonumber(data.price) or 0
            data.cooldown = tonumber(data.cooldown) or 0
            data.matierePremiere = data.itemType == "matierePremiere" and true or false
            data.armes = not data.matierePremiere
            data.img = ""
            allVariables[#allVariables + 1] = data
        end
    end
    return allVariables
end)

RegisterNetEvent("core:gestion-tablet:sendTabletXP", function(data)
    local src = source 
    local playerGlobal = VFW.GetPlayerGlobalFromId(src)
    local perm = playerGlobal.permissions["gestion_tablet"]
    local data = json.decode(data)
    --if perm then
        local variable = VFW.Variables.GetVariable("xpTablet")
        VFW.Variables.SetVariable("xpTablet", data)
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'VERT',
            content = "Variable modifiée avec succès"
        })
    --end
end)