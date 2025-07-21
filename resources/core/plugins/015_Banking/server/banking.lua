RegisterServerCallback("vfw:banking:getSocietyMoney", function(source)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local money
    Society.account.getMoney(xPlayer.job.name, function(result)
        money = tonumber(result) or 0
    end)
    while not money do Wait(100) end
    return money
end)

RegisterServerCallback('vfw:banking:withdraw', function(source, amount, accountType)
    local xPlayer = VFW.GetPlayerFromId(source)
    accountType = tonumber(accountType) or 1
    if accountType == 2 then -- Compte entreprise
        local job = xPlayer.job.name
        local societyMoney
        Society.account.getMoney(job, function(result)
            societyMoney = tonumber(result) or 0
        end)
        while societyMoney == nil do Wait(10) end
        if societyMoney >= amount then
            Society.account.withdraw(job, amount)
            xPlayer.addMoney(amount)
            xPlayer.showNotification({
                type = 'VERT',
                content = "Vous avez retiré " .. amount .. "$ du compte entreprise."
            })
            logs.banking.withdraw(source, amount)
            return true
        else
            xPlayer.showNotification({
                type = 'ROUGE',
                content = "Il n'y a pas assez d'argent sur le compte entreprise."
            })
            return false
        end
    else -- Compte perso
        local bank = xPlayer.getAccount("bank").money
        console.debug("vfw:banking:withdraw", amount, bank)
        if bank >= amount then
            xPlayer.removeAccountMoney("bank", amount)
            xPlayer.addMoney(amount)
            xPlayer.showNotification({
                type = 'VERT',
                content = "Vous avez retiré " .. amount .. "$ de votre compte bancaire."
            })
            logs.banking.withdraw(source, amount)
            return true
        else
            xPlayer.showNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas assez d'argent sur votre compte bancaire."
            })
            return false
        end
    end
end)

RegisterServerCallback('vfw:banking:deposit', function(source, amount, accountType)
    local xPlayer = VFW.GetPlayerFromId(source)
    accountType = tonumber(accountType) or 1
    local money = xPlayer.getMoney()
    console.debug("vfw:banking:deposit", amount, money)
    if money >= amount then
        if accountType == 2 then -- Dépôt entreprise
            local job = xPlayer.job.name
            xPlayer.removeMoney(amount)
            Society.account.deposit(job, amount)
            xPlayer.showNotification({
                type = 'VERT',
                content = "Vous avez déposé " .. amount .. "$ sur le compte entreprise."
            })
            logs.banking.deposit(source, amount)
            return true
        else -- Dépôt perso
            xPlayer.removeMoney(amount)
            xPlayer.addAccountMoney("bank", amount)
            xPlayer.showNotification({
                type = 'VERT',
                content = "Vous avez déposé " .. amount .. "$ sur votre compte bancaire."
            })
            logs.banking.deposit(source, amount)
            return true
        end
    else
        xPlayer.showNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas assez d'argent sur vous."
        })
        return false
    end
end)