local function snatchingGive(netid)
    local src = source
    local ped = NetworkGetEntityFromNetworkId(netid)
    if ped and DoesEntityExist(ped) then 
        local var = VFW.Variables.GetVariable("heist_snatching")
        local moneyGiven = math.floor(math.random(var.winMin, var.winMax))
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez récupéré "..moneyGiven.."$ !"
        })
        local player = VFW.GetPlayerFromId(src)
        player.addMoney(moneyGiven)

        -- TODO :  add crew xp
        
        -- Alerte LSPD
        local pos = GetEntityCoords(ped)
        TriggerEvent('core:alert:makeCall', "lspd", vector3(pos.x, pos.y, pos.z), true, "Vol en cours", false, "illegal")
        TriggerEvent('core:alert:makeCall', "lssd", vector3(pos.x, pos.y, pos.z), true, "Vol en cours", false, "illegal")
    end
end

RegisterNetEvent("core:snatching:give", snatchingGive)

local function lootBag(netid)
    local src = source
    local bag = NetworkGetEntityFromNetworkId(netid)
    console.debug("netid", netid, "bag", bag, DoesEntityExist(bag))
    if bag and DoesEntityExist(bag) then 
        local var = VFW.Variables.GetVariable("heist_snatching")
        local moneyGiven = math.floor(math.random(var.winMin, var.winMax))
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez récupéré "..moneyGiven.."$ !"
        })

        -- Alerte LSPD
        local pos = GetEntityCoords(bag)
        TriggerEvent('core:alert:makeCall', "lspd", vector3(pos.x, pos.y, pos.z), true, "Vol de sac", false, "illegal")
        TriggerEvent('core:alert:makeCall', "lssd", vector3(pos.x, pos.y, pos.z), true, "Vol de sac", false, "illegal")

        DeleteEntity(bag)
    end
end


RegisterNetEvent("core:Alert:cops")
AddEventHandler("core:Alert:cops", function(pos, isImportant, message, isUrgent, type)
    TriggerEvent('core:alert:makeCall', "lspd", pos, isImportant, message, isUrgent, type)
    TriggerEvent('core:alert:makeCall', "lssd", pos, isImportant, message, isUrgent, type)
end)

RegisterNetEvent("core:snatching:loot", lootBag)