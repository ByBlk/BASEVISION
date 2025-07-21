local function GetTrunkBone(veh)
    local bone = "platelight"
    if GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, bone)) == vector3(0, 0, 0) then
        if tostring(veh) == "826114" or tostring(veh) == "1377794" then -- stockade
            bone = "door_pside_r"
        elseif GetVehicleClass(veh) == 8 then
            bone = "swingarm"
        elseif GetVehicleClass(veh) == 20 then
            bone = "reversinglight_r"
        elseif GetVehicleClass(veh) == 14 then --boat
            bone = "engine"
        elseif GetVehicleClass(veh) == 16 then -- plane
            bone = "airbrake_l"
        elseif GetVehicleClass(veh) == 15 then -- plane
            bone = "engine"
        else
            bone = "boot"
        end
    end
    return bone
end

local function OpenTrunk(veh, bonePos)
    if VFW.StateInventory() then
        VFW.CloseInventory()
        return
    end
    if not VFW.Items then return end
    if not bonePos then
        bonePos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, GetTrunkBone(veh)))
    end
    TaskTurnPedToFaceCoord(VFW.PlayerData.ped, bonePos, 0)

    --@todo: /me and animation

    SetVehicleDoorOpen(veh, 5, false, false)

    VFW.OpenTrunk(GetVehicleNumberPlateText(veh))

    while VFW.StateInventory() do
        if #(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, GetTrunkBone(veh)))) > 2 then
            VFW.CloseInventory()
            break
        end
        Wait(0)
    end

    SetVehicleDoorShut(veh, 5, false)
end

VFW.ContextAddButton("vehicle", "Ouvrir le coffre", function(veh)
    return (GetVehicleDoorLockStatus(veh) < 2) and Entity(veh).state.VehicleProperties 
        and (#(GetEntityCoords(VFW.PlayerData.ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, GetTrunkBone(veh)))) < 2)
end, function(veh)
    ExecuteCommand("+opencontextmenu")

    OpenTrunk(veh)
end)

VFW.RegisterInput("opencartrunk", "Ouvrir le coffre véhicule", "keyboard", "K", function()
    local veh = VFW.Game.GetClosestVehicle()
    if veh and veh > 0 then
        local bone = GetTrunkBone(veh)
        local boneIndex = GetEntityBoneIndexByName(veh, bone)
        local bonePos = GetWorldPositionOfEntityBone(veh, boneIndex)
        local playerPos = GetEntityCoords(VFW.PlayerData.ped)

        if #(playerPos - bonePos) > 2 then
            if #(playerPos - bonePos) < 4 then
                local line = true
                SetTimeout(1000, function() line = false end)
                while line do
                    DrawLine(GetEntityCoords(VFW.PlayerData.ped), GetWorldPositionOfEntityBone(veh, boneIndex), 255, 255, 255, 170)
                    Wait(0)
                end
            end
            return
        end
        
        if (GetVehicleDoorLockStatus(veh) > 1) or (not Entity(veh).state.VehicleProperties) then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Le véhicule est verrouillé"
            })
            return
        end

        OpenTrunk(veh, bonePos)
    end
end)

function VFW.OpenTrunk(plate)
    local chestId, inventory, weight, maxWeight, name = TriggerServerCallback("vfw:trunk:get", plate)
    VFW.OpenInventory({
        chestId = chestId,
        inventory = inventory,
        name = name,
        maxWeight = maxWeight,
        weight = weight,
        search = false,
    })
end