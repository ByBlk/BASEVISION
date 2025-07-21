local function racketGive(netid)
    local src = source
    local ped = NetworkGetEntityFromNetworkId(netid)
    if ped and DoesEntityExist(ped) then 
        local var = VFW.Variables.GetVariable("heist_racket")
        local moneyGiven = math.floor(math.random(var.winMin, var.winMax))
        TriggerClientEvent("vfw:showNotification", src, {
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez récupéré "..moneyGiven.."$ !"
        })
        local player = VFW.GetPlayerFromId(src)
        player.addMoney(moneyGiven)

        -- TODO :  add crew xp
    end
end

RegisterNetEvent("core:racket:give", racketGive)