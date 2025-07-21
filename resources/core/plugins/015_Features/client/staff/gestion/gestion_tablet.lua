RegisterNUICallback("nui:server-gestion-illegal:sendTabletItems", function(data)
    print("nui:server-gestion-illegal:sendTabletItems", json.encode(data, {indent = true}))
    TriggerServerEvent("core:gestion-tablet:newTabletItems", data)
end)

RegisterNUICallback("nui:server-gestion-illegal:sendTabletXP", function(data)
    console.debug("nui:server-gestion-illegal:sendTabletXP", json.encode(data, {indent = true}))
    TriggerServerEvent("core:gestion-tablet:sendTabletXP", json.encode(data))
end)

VFW.Variables.GestionSent = false

function VFW.Variables.SendGestionData()
    if (not VFW.Variables.GestionSent) then 
        VFW.Variables.GestionSent = true
        local allFactionsVariables = TriggerServerCallback("core:gestion-tablet:getAllFactionsVariables")
        console.debug("Sending all factions variables to NUI")
        --console.debug(json.encode(allFactionsVariables, {indent = true}))
        SendNUIMessage({
            action = "nui:server-gestion-illegal:tabletItems",
            data = allFactionsVariables
        })
    end
end