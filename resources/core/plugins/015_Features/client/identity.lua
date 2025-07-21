local pedPos = vector4(-553.65, -189.49, 37.22, 211.43)
local pedModel = `a_f_y_business_01`

RegisterNetEvent("vfw:playerLoaded", function()
    VFW.CreatePed(pedPos, pedModel)

    VFW.CreateBlipAndPoint("Identité", vector3(pedPos.x, pedPos.y, pedPos.z + 0.7), "identity", nil, 2, 0.8, nil, "Carte d'identité", "E", "Carte", {
        onPress = function()
            TriggerServerEvent("identity:givemycard")
        end
    })
end)

local function OpenIdentityCard(my_data)

    VFW.Nui.IdentityCard(true, {
        type = my_data.type,
        dl = my_data.dl,
        class = "B",
        expiration_date = "26/05/26",
        end_date = "none",
        lastName = my_data.lastName,
        firstName = my_data.firstName,
        date_of_birth = my_data.date_of_birth,
        rstr = "none",
        sex = my_data.sex,
        height = my_data.height,
        hair = "Brn",
        weight = "75",
        eye_color = "Blk",
        address = my_data.address,
        photo = my_data.photo
    })


    Citizen.SetTimeout(10000, function()
        VFW.Nui.IdentityCard(false)
    end)

end

RegisterNetEvent("identity:opencard", function(type)
    VFW.CloseInventory()
    local result = VFW.StartSelect(3.0, false)
    local idS = GetPlayerServerId(result)
    if result and idS then
        TriggerServerEvent("core:identity:display", idS, type)
    end


end)

RegisterNetEvent("core:identity:show", function(data)

    VFW.CloseInventory()
    OpenIdentityCard(data)
end)

RegisterNuiCallback("nui:identity:close", function()

    VFW.Nui.IdentityCard(false)
end)

RegisterCommand("opencard", function()
    local my_data = TriggerServerCallback("identity:getData")
    OpenIdentityCard(my_data)
end)