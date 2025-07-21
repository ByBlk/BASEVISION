while not VFW do Wait(100) end
while not VFW.PlayerLoaded do Wait(100) end

local accountType = 1

RegisterNuiCallback("nui:banking:close", function(data)
    Web.Banking(false)
    Web.Focus(false)
end)

RegisterNuiCallback("nui:banking:withdraw", function(data)
    local amount = tonumber(data)
    console.debug("nui:banking:withdraw", amount)
    if amount then
        local valide = TriggerServerCallback('vfw:banking:withdraw', amount, accountType)
        if valide then
            if accountType == 2 then
                Citizen.SetTimeout(500, function()
                    Web.Banking(true)
                end)
            else
                Web.Banking(true)
            end
        end
    end
end)

RegisterNuiCallback("nui:banking:deposit", function(data)
    local amount = tonumber(data)
    console.debug("nui:banking:deposit", amount)
    if amount then
        local valide = TriggerServerCallback('vfw:banking:deposit', amount, accountType)
        if valide then
            if accountType == 2 then
                Citizen.SetTimeout(500, function()
                    Web.Banking(true)
                end)
            else
                Web.Banking(true)
            end
        end
    end
end)

RegisterNuiCallback("nui:banking:account", function(data)
    accountType = tonumber(data)
    Web.Banking(true)
end)

Web.Banking = function(visible)
    for k, v in pairs(VFW.PlayerData.accounts) do
        if v.name == "bank" then
            local societyMoney = 0
            if (accountType == 2) then
                print("vfw:banking:getSocietyMoney", VFW.PlayerData.job.name)
                societyMoney = TriggerServerCallback("vfw:banking:getSocietyMoney")
                while not societyMoney do Wait(100) end
            end
            Web.Send("nui:banking:visible", {
                visible = visible,
                navBar = {
                    visible = true,
                    name = (VFW.PlayerData.firstName .. " " .. VFW.PlayerData.lastName),
                    jobLabel = VFW.PlayerData.job.label,
                    isBoss = (VFW.PlayerData.job.grade == 4) or false,
                    mugshot = VFW.PlayerData.mugshot
                },
                myAccount = {
                    visible = true,
                    type = "account",
                    society = (accountType == 2) or false,
                    bank = (accountType == 1) and (VFW.Math.GroupDigits(v.money)) or (accountType == 2 and (societyMoney)),
                    card = {
                        number = (accountType == 1) and ("2185 5794 3487 8745") or (accountType == 2 and ("6784 2248 8715 5487")),
                        data = (accountType == 1) and ("07/27") or (accountType == 2 and ("07/28")),
                        name = (accountType == 1) and (VFW.PlayerData.firstName .. " " .. VFW.PlayerData.lastName) or (accountType == 2 and VFW.PlayerData.job.label or "")
                    }
                },
                statistiques = {
                    visible = false,
                    history = {}
                },
                transfer = {
                    visible = true,
                },
                transactions = {
                    visible = false,
                    history = {}
                }
            })
        end
    end
    Web.Focus(visible)
end

local atmModels = {
    [GetHashKey("prop_atm_01")] = "prop_atm_01",
    [GetHashKey("prop_atm_02")] = "prop_atm_02",
    [GetHashKey("prop_atm_03")] = "prop_atm_03",
    [GetHashKey("prop_fleeca_atm")] = "prop_fleeca_atm"
}

local atmPoints = {}


CreateThread(function()  
    while true do
        for _, entity in pairs(GetGamePool("CObject")) do
            local model = GetEntityModel(entity)
            local objectPos = GetEntityCoords(entity)
            if not atmPoints[objectPos] then
                if atmModels[model] then
                    atmPoints[objectPos] = Worlds.Zone.Create(vector3(objectPos.x, objectPos.y, objectPos.z + 0.7), 2, false, function()
                        VFW.RegisterInteraction("atm", function()
                            Web.Banking(true)
                        end)
                    end, function()
                        VFW.RemoveInteraction("atm")
                        accountType = 1
                    end, "ATM", "E", "Banque")
                end
            end
        end
        Wait(5000)    
    end
end)

local Position = {
    vector3(150.266, -1040.203, 29.374),
    vector3(-1212.980, -330.841, 37.787),
    vector3(-2962.582, 482.627, 15.703),
    vector3(-112.202, 6469.295, 31.626),
    vector3(314.187, -278.621, 54.170),
    vector3(-351.534, -49.529, 49.042),
    vector3(241.727, 220.706, 106.286),
    vector3(1175.064, 2706.643, 38.094),
    vector3(-2837.06, 6221.95, 8.77),
}

for k, v in pairs(Position) do
    VFW.CreateBlipAndPoint("bank", v, k, 108, 2, 0.8, "Banque", "Banque", "E", "Banque",{
        onPress = function()
            Web.Banking(true)
        end
    })
end