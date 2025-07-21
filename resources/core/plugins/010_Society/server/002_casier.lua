RegisterServerCallback("society:jobcasier:openChest", function(source, data, job)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local Job = xPlayer.getJob().name
    if not Job == job then return end
    VFW.CreateOrGetChest(string.upper(tostring(job.." "..data)), 50, string.upper(tostring(job.." "..data)))
    return {
        open = true,
        id = string.upper(tostring(job.." "..data))
    }
end)