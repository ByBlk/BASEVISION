function VFW.SendItemGestionData()
    local itemsList = {}
    for k, v in pairs(VFW.Items) do
        if (v.type ~= "keys") and (v.type ~= "clothes") then
            local typeI
            if v.data then
                if v.data.type == nil then
                    typeI = "objects"
                elseif v.data.type == "consumable" then
                    typeI = "consumable"
                elseif v.data.type == "drugs" then
                    typeI = "drugs"
                elseif string.find(k, "weapon_") then
                    typeI = "weapon"
                elseif v.data.type == "gpb" then
                    typeI = "gpb"
                elseif v.data.type == "ammo" then
                    typeI = "ammo"
                else
                    typeI = "objects"
                end
            else
                typeI = "objects"
            end

            itemsList[#itemsList + 1] = {
                name = k,
                label = v.label,
                type = typeI,
                weight = v.weight,
                image = v.image,
                premium = v.premium,
                permanent = v.perm,
                drop = v.data?.drop,
                buyPrice = v.data?.buyPrice,
                effect = v.data?.effect,
                duration = v.data?.duration,
                hunger = v.data?.hunger,
                thirst = v.data?.thirst,
                expiration = v.data?.expiration,
                anim = v.data?.anim,
                prop = v.data?.prop,
                ammoType = v.data?.ammoType
            }
        end
    end

    SendNUIMessage({
        action = "nui:server-gestion-items:items",
        data = itemsList
    })
end

local bypassDelete = {
    ["keys"] = true,
    ["outfit"] = true,
    ["hat"] = true,
    ["top"] = true,
    ["accessory"] = true,
    ["bottom"] = true,
    ["shoe"] = true
}
RegisterNuiCallback("nui:server-gestion-items:save", function(data)
    local changedItem = {}
    for i = 1, #data do
        local item = data[i]
        local typeI
        if (item.type == "consumable") or (item.type == "drugs") or (item.type == "objects") then
            typeI = "items"
        elseif (item.type == "weapon") or (item.type == "ammo") or (item.type == "gpb") then
            typeI = "weapons"
        end

        if not VFW.Items[item.name] then
            changedItem[item.name] = {
                label = item.label,
                type = typeI,
                weight = item.weight,
                image = item.image,
                premium = item.premium or false,
                perm = item.permanent or false,
                data = {
                    drop = item.drop,
                    type = item.type,
                    buyPrice = item.buyPrice,
                    effect = item.effect,
                    duration = item.duration,
                    hunger = item.hunger,
                    thirst = item.thirst,
                    expiration = item.expiration,
                    anim = item.anim,
                    prop = item.prop,
                    ammoType = item.ammoType
                }
            }
            VFW.Items[item.name] = changedItem[item.name]
        else
            local editItem = {
                label = item.label,
                type = typeI,
                weight = item.weight,
                image = item.image,
                premium = item.premium,
                perm = item.permanent,
                data = {
                    drop = item.drop,
                    type = item.type,
                    buyPrice = item.buyPrice,
                    effect = item.effect,
                    duration = item.duration,
                    hunger = item.hunger,
                    thirst = item.thirst,
                    expiration = item.expiration,
                    anim = item.anim,
                    prop = item.prop,
                    ammoType = item.ammoType
                }
            }
            local change = false
            for k, v in pairs(VFW.Items[item.name]) do
                if (k == "data") then
                    for e, j in pairs(v) do
                        if editItem[k][e] ~= j then
                            change = true
                            break
                        end
                    end
                    if change then
                        break
                    end
                elseif editItem[k] ~= v then
                    change = true
                    break
                end
            end

            if not change then
                for k, v in pairs(editItem) do
                    if (k == "data") then
                        for e, j in pairs(v) do
                            if VFW.Items[item.name][k][e] ~= j then
                                change = true
                                break
                            end
                        end
                        if change then
                            break
                        end
                    elseif VFW.Items[item.name][k] ~= v then
                        change = true
                        break
                    end
                end
            end

            if change then
                changedItem[item.name] = editItem
                VFW.Items[item.name] = editItem
            end
        end
    end
    for k, v in pairs(VFW.Items) do
        if not bypassDelete[k] then
            local found = false
            for i = 1, #data do
                if data[i].name == k then
                    found = true
                    break
                end
            end
            if not found then
                changedItem[k] = "delete"
                VFW.Items[k] = nil
            end
        end
    end

    console.debug(json.encode(changedItem, {indent = true}))

    TriggerServerEvent("vfw:staff:saveItems", changedItem)
end)

RegisterNUICallback("nui:server-gestion-items:give", function(data)
    ExecuteCommand(("giveitem me %s %s"):format(data, 1))
end)