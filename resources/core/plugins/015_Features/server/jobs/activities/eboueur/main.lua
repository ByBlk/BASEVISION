
local garbageDuty = {}

RegisterNetEvent("core:activities:eboueurStartDuty")
AddEventHandler("core:activities:eboueurStartDuty", function()
    local _source = source 

    table.insert(garbageDuty, _source)
end)


RegisterServerCallback("core:activites:getIfAlrdyTakeService", function(source)
    for k,v in pairs(garbageDuty) do
        if v == source then
            return true
        end
    end

    return false
end)

RegisterNetEvent("core:activities:eboueurEndDuty")
AddEventHandler("core:activities:eboueurEndDuty", function(amount)
    local _source = source
    local xPlayer = VFW.GetPlayerFromId(_source)
    if not xPlayer then return end
    if not amount or amount < 1 then return end
    xPlayer.addMoney(math.floor(amount))
end)