RegisterNetEvent("vfw:ltd:buy", function(model)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = 0
    local label = ""
    console.debug(source, model)

    for _,category in pairs(VFW.LTD.Items) do
        for _,v in pairs(category) do
            if v.model == model then
                price = v.price
                label = v.label
                break
            end
        end
    end

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.createItem(model, 1)
        xPlayer.updateInventory()
        TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~"..price.."$")
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price.."$")
    end
end)