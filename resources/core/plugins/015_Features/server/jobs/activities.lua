RegisterNetEvent("core:activities:pizza:addPizza")
AddEventHandler("core:activities:pizza:addPizza", function(typejob, amount)
    local _source = source 
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return
    end

    if typejob ~= "pizza" then
        return
    end

    xPlayer.addItem("pizza-7945", 1, {})
    xPlayer.updateInventory()
end)

RegisterNetEvent("core:activities:pizza:removePizza", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return
    end

    if typejob ~= "pizza" then
        return
    end

    xPlayer.removeItem("pizza-7945", 1, {})
    xPlayer.updateInventory()

    local amount = 10

    xPlayer.addMoney(amount)
end)

RegisterNetEvent("core:activities:gopostal:finish", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return
    end

    if typejob ~= "gopostal" then
        return
    end

    xPlayer.addMoney(amount)
end)

RegisterNetEvent("core:activities:train:finish", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return 
    end

    if typejob ~= "train" then
        return
    end

    xPlayer.addMoney(amount)
end) 

RegisterNetEvent("core:activities:tramway:finish", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return 
    end

    if typejob ~= "tram" then
        return
    end

    xPlayer.addMoney(amount)
end)

RegisterNetEvent("core:activities:tramway:finish", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return 
    end

    if typejob ~= "tramway" then
        return
    end

    xPlayer.addMoney(amount)
end)

RegisterNetEvent("core:activities:eboueur:finish", function(typejob, amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)

    if not xPlayer then
        return 
    end

    if typejob ~= "eboueur" then
        return
    end

    xPlayer.addMoney(amount)
end)