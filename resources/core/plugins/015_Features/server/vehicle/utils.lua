local function randomChar()
    local choice = math.random(1, 2)
    if choice == 1 then
        return tostring(math.random(0, 9))
    else
        return string.char(math.random(65, 90))
    end
end

function VFW.CreatePlate()
    math.randomseed(GetGameTimer())
    local plate = ("%s%s%s%s%s%s%s%s"):format(randomChar(), randomChar(), randomChar(), randomChar(), randomChar(), randomChar(), randomChar(), randomChar())

    if VFW.GetVehicleByPlate(plate) then
        return VFW.CreatePlate()
    else
        local result = MySQL.scalar.await("SELECT 1 FROM vehicles WHERE plate = ?", { plate })
        if result then
            return VFW.CreatePlate()
        end
    end
    
    return plate
end