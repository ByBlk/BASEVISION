-- VFW.TempChest(inventory, weight, maxWeight, name)

RegisterServerCallback("vfw:trunk:get", function(source, plate)
    local chestId
    local chest
    if VFW.GetVehicleByPlate(plate) then
        chestId = "veh:"..plate
        chest = VFW.CreateOrGetChest(chestId, 50, plate)
    else
        chestId = "tempVeh:"..plate
        chest = VFW.CreateOrGetChest(chestId, 50, plate)
        if not chest then
            chest = VFW.TempChest(chestId, 50, plate)
        end
    end

    chest.addLooking(source)
    -- Log Discord Coffre Véhicule
    if logs and logs.society and logs.society.vehicleSafe then
        logs.society.vehicleSafe(source, plate)
    end
    return chestId, chest.inventory, chest.weight, chest.maxWeight, chest.name
end)