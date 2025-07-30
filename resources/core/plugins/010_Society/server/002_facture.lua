Society.account = {}

---@param job string
---@param amount number
Society.account.deposit = function(job, amount)
    if not job or not amount or amount <= 0 then return end
    exports.oxmysql:execute('UPDATE society SET account = JSON_SET(account, "$.money", COALESCE(JSON_EXTRACT(account, "$.money"), 0) + ?) WHERE job = ?', {amount, job})
    console.debug("Society", "Deposit", job, amount)
end

---@param job string
---@param amount number
Society.account.withdraw = function(job, amount)
    if not job or not amount or amount <= 0 then return end
    exports.oxmysql:execute('UPDATE society SET account = JSON_SET(account, "$.money", GREATEST(COALESCE(JSON_EXTRACT(account, "$.money"), 0) - ?, 0)) WHERE job = ?', {amount, job})
    console.debug("Society", "Withdraw", job, amount)
end

---@param job string
---@param cb fun(money: number)
Society.account.getMoney = function(job, cb)
    if not job then if cb then cb(0) end return end
    exports.oxmysql:scalar('SELECT JSON_UNQUOTE(JSON_EXTRACT(account, "$.money")) FROM society WHERE job = ?', {job}, function(result)
        local money = tonumber(result) or 0
        if cb then cb(money) end
    end)
end

---@param job string
---@param cb fun(turnover: number)
Society.account.getTurnover = function(job)
    if not job then cb(0) return end
    exports.oxmysql:scalar('SELECT turnover FROM society WHERE job = ?', {job}, function(result)
        return (tonumber(result) or 0)
    end)
end

---@param job string
---@param turnover number
Society.account.setTurnover = function(job, turnover)
    if not job or turnover == nil then return end
    exports.oxmysql:execute('UPDATE society SET turnover = ? WHERE job = ?', {turnover, job})
    console.debug("Society", "SetTurnover", job, turnover)
end

RegisterServerCallback("vfw:invoice:getName", function(source, id)
    local tPlayer = VFW.GetPlayerFromId(id)
    return tPlayer.name
end)

RegisterNetEvent("vfw:invoice:send")
AddEventHandler("vfw:invoice:send", function(data, id)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local job = xPlayer and xPlayer.getJob() and xPlayer.getJob().name or nil
    local IdB = VFW.GetIdentifier(id)
    local result = MySQL.query.await("SELECT id, firstname, lastname, job, job_grade, faction, faction_grade, accounts, mugshot, inventory FROM users WHERE identifier LIKE ?", { "%"..IdB })
    name = ("%s %s"):format(result[1].firstname, result[1].lastname)
    TriggerClientEvent("nui:invoice:receive", id, data, name, source, job)
end)

RegisterNetEvent("vfw:invoice:payment", function(data, sender, job)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local tPlayer = VFW.GetPlayerFromId(sender)
    local bank = xPlayer.getAccount("bank").money
    if bank >= data then
        xPlayer.removeAccountMoney("bank", data)
        xPlayer.showNotification({
            type = 'VERT',
            content = "Vous avez payé la facture de " .. data .. "$",
        })
        if job then
            Society.account.deposit(job, data)
            if tPlayer then
                tPlayer.showNotification({
                    type = 'VERT',
                    content = "Votre entreprise a reçu un paiement de " .. data .. "$",
                })
            end
        else
            if tPlayer then
                tPlayer.addAccountMoney("bank", data)
                tPlayer.showNotification({
                    type = 'VERT',
                    content = "Vous avez reçu un paiement de " .. data .. "$ (pas de job détecté)",
                })
            end
        end
        if tPlayer then
            TriggerClientEvent("vfw:invoice:sendRecu", tPlayer.source)
        end
    else
        xPlayer.showNotification({
            type = 'VERT',
            content = "Vous n'avez pas assez d'argent sur votre compte bancaire",
        })
        if tPlayer then
            tPlayer.showNotification({
                type = 'VERT',
                content = "Le joueur n'a pas assez d'argent sur son compte bancaire",
            })
        end
    end
end)


RegisterNetEvent("vfw:invoice:sendRecu", function(id, data)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local tPlayer = VFW.GetPlayerFromId(id)
    print("[DEBUG TYPE DATA]", type(data))
    
    if type(data) == "table" then
        data.date = os.date("%d/%m/%Y - %H:%M")
        data.employee = "Grossiste" -- employé fixe
        data.customer = tPlayer and tPlayer.getName() or "Inconnu" 
    end
    print("[DEBUG DATA AVANT AJOUT]", json.encode(data))
    tPlayer.showNotification({
        type = 'VERT',
        content = "Vous avez reçu une facture",
    })
    xPlayer.showNotification({
        type = 'VERT',
        content = "Vous avez envoyé une facture",
    })
    xPlayer.addItem("papier", 1, data)
    print("[DEBUG PAPIER] data envoyé à xPlayer : " .. json.encode(data))
    xPlayer.updateInventory()
    tPlayer.addItem("papier", 1, data)
    print("[DEBUG PAPIER] data envoyé à tPlayer : " .. json.encode(data))
    tPlayer.updateInventory()
end)

VFW.RegisterUsableItem("papier", function(xPlayer, deleteCallback, metaData)
    print(json.encode(metaData))
    TriggerClientEvent("vfw:invoice:open", xPlayer.source, metaData)
end)