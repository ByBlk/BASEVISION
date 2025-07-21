print("Loading Faction Stockage")

local FactionStockagePositions = {
    lspd = vector3(465.55, -992.46, 25.09),
    lssd = vector3(1824.09, 3659.33, 29.31),
}

local lspdStockagePoint = nil
local lssdStockagePoint = nil

local function OpenLSPDStockage()
    if not VFW.PlayerData.job.onDuty then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Vous n'êtes pas en service"
        })
        return
    end
    
    if VFW.PlayerData.job.name ~= "lspd" then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Vous devez être LSPD pour accéder à ce stockage"
        })
        return
    end
    
    local action = TriggerServerCallback("society:factionstockage:openChest", "lspd")
    if action.open then
        VFW.Nui.NewGrandMenu(false)
        VFW.OpenChest(action.id)
    elseif action.message then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = action.message
        })
    end
end

local function OpenLSSDStockage()
    if not VFW.PlayerData.job.onDuty then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Vous n'êtes pas en service"
        })
        return
    end
    
    if VFW.PlayerData.job.name ~= "lssd" then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "~s Vous devez être LSSD pour accéder à ce stockage"
        })
        return
    end
    
    local action = TriggerServerCallback("society:factionstockage:openChest", "lssd")
    if action.open then
        VFW.Nui.NewGrandMenu(false)
        VFW.OpenChest(action.id)
    elseif action.message then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = action.message
        })
    end
end

Citizen.CreateThread(function()
    while not VFW do
        Wait(100)
    end
    
    while not VFW.PlayerData do
        Wait(100)
    end
    
    print("Initializing faction stockages...")
    
    lspdStockagePoint = VFW.CreateBlipAndPoint(
        "faction_stockage_lspd", 
        FactionStockagePositions.lspd, 
        1, 
        false, 
        false, 
        false, 
        false, 
        "Stockage LSPD", 
        "E", 
        "Coffre", 
        {
            onPress = OpenLSPDStockage
        }
    )
    
    lssdStockagePoint = VFW.CreateBlipAndPoint(
        "faction_stockage_lssd", 
        FactionStockagePositions.lssd, 
        1, 
        false, 
        false, 
        false, 
        false, 
        "Stockage LSSD", 
        "E", 
        "Coffre", 
        {
            onPress = OpenLSSDStockage
        }
    )
    
    print("Faction stockages loaded!")
end)

RegisterNetEvent('vfw:setJob')
AddEventHandler('vfw:setJob', function(job)
    print("Job changed to: " .. job.name)
end)