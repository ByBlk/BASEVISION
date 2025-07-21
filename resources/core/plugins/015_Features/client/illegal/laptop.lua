local UsingComputer = false

function setUsingComputer(bool)
    UsingComputer = bool
end

RegisterNetEvent("core:UseLaptop", function()
    if UsingComputer then
        return
    end

    UsingComputer = true
    local plyPos = GetEntityCoords(VFW.PlayerData.ped)
    local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

    for k, v in pairs(Fleeca) do
        if #(plyPos - v.door[1].pos.xyz) <= 3.5 then
            if policeNumber and policeNumber >= 0 then
                if VFW.CanAccessAction("Fleeca") then
                    AnimationHackingOpenDoor(v, k)
                    return
                end
            end
        end
    end

    UsingComputer = false
end)

RemoveVangelicoBulle = false
RemoveFleecaBulle = false

VangelicoHack = nil
FleecaHack = {}

local hasLaptop = false

CreateThread(function()
    while not VFW.IsPlayerLoaded() do Wait(1) end

    if VFW.CanAccessAction("Vangelico") then
        VangelicoHack = VFW.CreateBlipAndPoint("vangelicoHack", vector3(-630.84014892578, -229.67807006836, 38.057033538818), 1, nil, nil, nil, nil,  "Hacker", "E", "Location",{
            onPress = function()
                local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

                if policeNumber and policeNumber >= 0 then
                    for i = 1, #VFW.PlayerData.inventory do
                        if VFW.PlayerData.inventory[i].name == "laptop" then
                            hasLaptop = true
                            break
                        end
                    end

                    if hasLaptop then
                        if not RemoveVangelicoBulle then
                            StartVangelicoHeist()

                            VFW.RemoveInteraction("vangelicoHack")
                            if VangelicoHack then
                                Worlds.Zone.Remove(VangelicoHack)
                                VangelicoHack = nil
                            end
                        end
                    end
                end
            end
        })
    end

    if VFW.CanAccessAction("Fleeca") then
        for k, v in pairs(Fleeca) do
            FleecaHack[k] = VFW.CreateBlipAndPoint("fleecaHack", vector3(v.door[1].pos.xyz), k, nil, nil, nil, nil,  "Hacker", "E", "Location",{
                onPress = function()
                    local policeNumber = (GlobalState['lspd'] or 0) + (GlobalState['lssd'] or 0)

                    if policeNumber and policeNumber >= 0 then
                        for i = 1, #VFW.PlayerData.inventory do
                            if VFW.PlayerData.inventory[i].name == "laptop" then
                                hasLaptop = true
                                break
                            end
                        end

                        if hasLaptop then
                            if not RemoveFleecaBulle then
                                AnimationHackingOpenDoor(v, k)
                            end
                        end
                    end
                end
            })
        end
    end
end)
