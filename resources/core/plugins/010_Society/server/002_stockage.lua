RegisterServerCallback("society:jobstockage:openChest", function(source, job)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local Job = xPlayer.getJob().name
    if not Job == job then return end
    VFW.CreateOrGetChest(string.upper(tostring(job)), 50, string.upper(tostring(job)))
    -- Log Discord Coffre Entreprise
    if logs and logs.society and logs.society.companySafe then
        logs.society.companySafe(source, job)
    end
    return {
        open = true,
        id = string.upper(tostring(job))
    }
end)

RegisterServerCallback("society:factionstockage:openChest", function(source, faction)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local Job = xPlayer.getJob().name
    
    if faction == "lspd" and Job ~= "lspd" then 
        return { open = false, message = "Vous devez être LSPD pour accéder à ce stockage" }
    elseif faction == "lssd" and Job ~= "lssd" then 
        return { open = false, message = "Vous devez être LSSD pour accéder à ce stockage" }
    end
    
    local chestName = string.upper(tostring(faction)) .. "_STOCKAGE"
    VFW.CreateOrGetChest(chestName, 100, chestName)
    
    return {
        open = true,
        id = chestName
    }
end)