local isServerSide = IsDuplicityVersion();

if isServerSide then 
    VFW.Variables = {
        Datas = {},
        NeedSaves = {},
        SaveID = {}
    }

    function VFW.Variables.GetVariable(name)
        return VFW.Variables.Datas[name] or {}
    end

    function VFW.Variables.SetVariable(name, value)
        VFW.Variables.Datas[name] = value
        VFW.Variables.NeedSaves[name] = true
        VFW.Variables.SaveID[name] = math.random(1, 9999)
    end

    -- lastid is used to check if the client has already the same version has the server, if so, no need to send again and flood the network
    Wait(1000)
    RegisterServerCallback("core:variables:getVariables", function(source, name, lastid)
        if VFW.Variables.SaveID[name] ~= lastid then 
            return VFW.Variables.Datas[name], VFW.Variables.SaveID[name]
        end
        return false
    end)

    -- Save system
    CreateThread(function()
        while true do 
            Wait(60000)
            for name in pairs(VFW.Variables.NeedSaves) do
                if VFW.Variables.NeedSaves[name] ~= nil then 
                    VFW.Variables.NeedSaves[name] = nil
                    local data = VFW.Variables.Datas[name]
                    if data then 
                        MySQL.Async.execute([[
                            INSERT INTO variables (name, data) 
                            VALUES (@name, @data)
                            ON DUPLICATE KEY UPDATE 
                            data = @data
                        ]], {
                            ["@data"] = json.encode(data),
                            ["@name"] = name
                        }, function()
                            VFW.Variables.NeedSaves[name] = nil
                            console.info(("Variable %s saved successfully"):format(name))
                        end)
                    end
                end
            end
        end
    end)

    -- Load system
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM variables", {}, function(result)
            if result ~= nil then
                for i = 1, #result do
                    local name = result[i].name
                    local data = json.decode(result[i].data)
                    VFW.Variables.Datas[name] = data
                    math.randomseed(os.time())
                    VFW.Variables.SaveID[name] = math.random(1, 9999)
                end
                console.debug("[^2INFO^7] Toutes les variables ont été chargées")
            else
                console.debug("[^2INFO^7] Couldn't load variables, ^1empty table or no sql^7")
            end
        end)
    end)

else
    VFW.Variables = {
        Datas = {},
        LastIds = {}
    }
    function VFW.Variables.GetVariable(name)
        -- If new data from the last time we checked, we update it otherwise we return the current data that is the same as the serverside since its the same lastid
        local newDatas, newId = TriggerServerCallback("core:variables:getVariables", name, VFW.Variables.LastIds[name])
        if newDatas then 
            VFW.Variables.Datas[name] = newDatas
            VFW.Variables.LastIds[name] = newId
        end
        return VFW.Variables.Datas[name]
    end
end