RegisterNetEvent("core:server:jobs:vestiaireOutfit", function(meta)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end
    xPlayer.addItem("outfit", 1, meta)
    xPlayer.updateInventory()
end)
