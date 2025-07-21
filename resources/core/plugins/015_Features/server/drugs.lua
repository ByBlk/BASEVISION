local DrugsConfig = exports["core"]:GetDrugsConfig()

local currentPoints = {}

local function randomPoint(points)
    return points[math.random(1, #points)]
end

local function refreshPoints(drugName)
    local drug = DrugsConfig[drugName]
    if not drug then return end
    currentPoints[drugName] = {
        harvest = randomPoint(drug.harvest.positions),
        process = randomPoint(drug.process.positions)
    }
    TriggerClientEvent('drugs:'..drugName..':refreshPoints', -1)
end

for drugName, drug in pairs(DrugsConfig) do
    RegisterCommand('refresh'..drugName..'Points', function(source)
        refreshPoints(drugName)
    end, true)

    AddEventHandler('onResourceStart', function(res)
        if res == GetCurrentResourceName() then
            refreshPoints(drugName)
        end
    end)

    RegisterNetEvent('drugs:'..drugName..':harvest')
    AddEventHandler('drugs:'..drugName..':harvest', function()
        local src = source
        local xPlayer = VFW.GetPlayerFromId(src)
        if xPlayer then
            local min = drug.harvest.min or 1
            local max = drug.harvest.max or 1
            local qty = math.random(min, max)
            xPlayer.addItem(drug.harvest.item, qty, {})
            xPlayer.updateInventory()
            xPlayer.showNotification({type = 'VERT', content = 'Vous avez récolté '..qty..' '..drug.harvest.label..'.'})
            TriggerClientEvent('drugs:'..drugName..':refreshPoints', src)
        end
    end)

    RegisterNetEvent('drugs:'..drugName..':process')
    AddEventHandler('drugs:'..drugName..':process', function()
        local src = source
        local xPlayer = VFW.GetPlayerFromId(src)
        if xPlayer and xPlayer.countItem(drug.process.itemIn, {}) > 0 then
            xPlayer.removeItem(drug.process.itemIn, 1, {})
            xPlayer.addItem(drug.process.itemOut, 1, {})
            xPlayer.updateInventory()
            xPlayer.showNotification({type = 'VERT', content = 'Vous avez traité '..drug.harvest.label..'.'})
        else
            xPlayer.showNotification({type = 'ROUGE', content = "Vous n\\'avez pas de "..drug.harvest.label..'.'})
            
        end
    end)
end