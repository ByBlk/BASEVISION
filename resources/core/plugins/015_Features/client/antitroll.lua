VFW.AntiTroll = {}
VFW.AntiTroll.__index = VFW.AntiTroll
VFW.AntiTroll.firstSpawn = false

function VFW.AntiTroll:AntiCarKill()
    CreateThread(function()
        while self.firstSpawn do
            Wait(500)
            if IsPedOnFoot(VFW.PlayerData.ped) then
                local vehicles, dist = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped))

                if vehicles ~= 0 and dist < 10.0 then
                    local v = GetVehiclePedIsIn(VFW.PlayerData.ped, false)

                    if vehicles == v then
                        SetEntityNoCollisionEntity(vehicles, VFW.PlayerData.ped)
                    end
                end
            else
                Wait(1000)
            end
        end
    end)
end

function VFW.AntiTroll:DisableControl()
    CreateThread(function()
        if self.firstSpawn then
            --todo: Add hud limited actions
        end

        while self.firstSpawn do
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            Wait(1)
        end
    end)
end

function VFW.AntiTroll:GetItsMyFirstSpawn()
    return self.firstSpawn
end

function VFW.AntiTroll:Load()
    self:AntiCarKill()
    self:DisableControl()

    if self.firstSpawn then
        CreateThread(function()
            while true do
                local new = TriggerServerCallback("core:antitroll:check")

                if not new then
                    self.firstSpawn = false
                    break
                end

                Wait(5 * 1000 * 60) -- 5 minutes
            end
        end)
    end
end

RegisterNetEvent("core:antitroll:load", function(new)
    VFW.AntiTroll.firstSpawn = new
    VFW.AntiTroll:Load()
end)
