VFW.InfoKey = {}

function VFW.InfoKey.Create(visible, data)
    SendNUIMessage({
        action = "nui:infokey:visible",
        data = visible
    })
    if data then
        SendNUIMessage({
            action = "nui:infokey:data",
            data = data
        })
    end
end


-- RegisterCommand("infokey", function(source, args, rawCommand)
--     local data = {
--         {
--             key = "E",
--             desc = "Ouvrir le menu"
--         },
--         {
--             key = "G",
--             desc = "test"
--         }
--     }
--     VFW.InfoKey.Create(true, data)
-- end)