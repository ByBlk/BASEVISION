RegisterNetEvent("core:ChangeHeistsLimitByID")
AddEventHandler("core:ChangeHeistsLimitByID", function(id, action)
    local xPlayer = VFW.GetPlayerFromId(tonumber(id))

    if xPlayer then
        local playerLicense = xPlayer.identifiers
        local limitsKey = 'heistsLimitPerReboot_'..playerLicense

        if GlobalState[limitsKey] == nil or action == "reset" then
            GlobalState[limitsKey] = {
                fleeca = 0,
                gofast = 0,
                gofastMaritime = 0,
            }

            if action == "reset" then
                print("Resetting Heists Limit for ID: " .. playerLicense)
                TriggerClientEvent("__kpz::createNotification", xPlayer.source, {
                    type = 'VERT',
                    content = "Votre limite de braquage illégaux a été réinitialisé !"
                })
                return
            end
        end

        local actionMap = {
            fleeca = "fleeca",
            gofast = "gofast",
            gofastMaritime = "gofastMaritime",
        }

        if actionMap[action] then
            print("Change " .. actionMap[action] .. " Limit for ID: " .. playerLicense)
            local saveHeistsLimitPerReboot = GlobalState[limitsKey]
            saveHeistsLimitPerReboot[actionMap[action]] = saveHeistsLimitPerReboot[actionMap[action]] + 1
            GlobalState[limitsKey] = saveHeistsLimitPerReboot
        end
    end
end)

RegisterNetEvent("core:addMoney", function(moeny)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    xPlayer.addMoney(tonumber(moeny))
end)

RegisterNetEvent("core:addItemToInventory", function(item, amount)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    xPlayer.createItem(item, amount)
    xPlayer.updateInventory()
end)

RegisterNetEvent("core:removeItemFromInventory", function(item, amount)
    local src = source
    local xPlayer = VFW.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    xPlayer.removeItem(item, amount, {})
    xPlayer.updateInventory()
end)
