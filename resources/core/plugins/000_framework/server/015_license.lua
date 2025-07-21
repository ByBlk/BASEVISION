local licenses = {}

MySQL.ready(function()
    MySQL.query('SELECT type, label FROM licenses', function(result)
        licenses = result
    end)
end)

local function isValidLicense(licenseType)
    local flag = false
    
    for i=1,#licenses do
        if licenses[i].type == licenseType then
            flag = true
            break
        end
    end
    
    return flag
end

RegisterNetEvent('vfw:license:addLicense', function(target, licenseType)
    local xPlayer = VFW.GetPlayerFromId(target)
    if not xPlayer then
        return
    end
    if not isValidLicense(licenseType) then
        return
    end

    MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', { licenseType, xPlayer.identifier })

    print("^2[LICENSE DEBUG]^7 Type de licence reçu: " .. licenseType)

    if licenseType == "driver" or licenseType == "moto" or licenseType == "camion" or licenseType == "avion" or licenseType == "helicoptere" or licenseType == "bateau" or licenseType == "dmvschool" then
        print("Don de l'item driverlicense pour le type: " .. licenseType)
        xPlayer.createItem("driverlicense", 1)
        xPlayer.updateInventory()
        print("^2Item driverlicense donné avec succès!")
    else
        print("^1Type de licence non reconnu pour l'item: " .. licenseType)
    end

    TriggerClientEvent("vfw:license:load", target)
end)

RegisterNetEvent('vfw:license:removeLicense', function(target, licenseType)
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    if xPlayer.getJob().type ~= "faction" then
        return
    end
    local xTarget = VFW.GetPlayerFromId(target)
    if not xTarget then
        return
    end

    MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ?', { licenseType, xPlayer.identifier })

    TriggerClientEvent("vfw:license:load", target)
end)

RegisterServerCallback('vfw:license:checkLicense', function(source, target, licenseType)
    local xPlayer = VFW.GetPlayerFromId(target)
    if not xPlayer then
        return
    end

    local checkLicense

    MySQL.scalar('SELECT type FROM user_licenses WHERE type = ? AND owner = ?', { licenseType, xPlayer.identifier }, function(result)
        checkLicense = result
    end)

    Wait(150)

    return checkLicense
end)

RegisterServerCallback('vfw:license:checkAllLicense', function(source, target)
    local xPlayer = VFW.GetPlayerFromId(target)
    if not xPlayer then
        return {}
    end

    local playerLicenses = {}

    local result = MySQL.query.await('SELECT type FROM user_licenses WHERE owner = ?', { xPlayer.identifier })

    for i = 1, #result do
        playerLicenses[result[i].type] = true
    end

    return playerLicenses
end)

RegisterServerCallback('vfw:license:getLicensesList', function(source)
    return licenses
end)
