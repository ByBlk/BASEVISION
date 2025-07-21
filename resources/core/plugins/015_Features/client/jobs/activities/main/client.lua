RegisterNetEvent("core:activities:askJob", function(job, psource, name)
    local jobConfirmation = VFW.Nui.KeyboardInput(true, "Souhaitez vous rejoindre l'activité " .. job .. " avec " .. name .. " ?", nil)
    if jobConfirmation then 
        TriggerServerEvent("core:activities:acceptJob", psource)
    end
end)