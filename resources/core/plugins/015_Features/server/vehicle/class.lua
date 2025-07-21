function VFW.CreateVehicleClass(plate, owner, model, prop, state)
    local self = {}

    self.plate = plate
    self.owner = owner
    self.model = model
    self.prop = prop or {}
    self.prop.plate = self.plate
    self.locked = false
    self.state = state

    function self.spawnVehicle(pos)
        if self.vehicle then
            self.dispawnVehicle()
        end
        local id = VFW.OneSync.SpawnVehicle(self.model, pos.xyz, pos.w, self.prop)
        self.vehicle = id
        self.changeLock(true)
    end

    function self.changeLock(status)
        local veh = NetworkGetEntityFromNetworkId(self.vehicle)
        self.locked = status
        if status then
            SetVehicleDoorsLocked(veh, 2)
        else
            SetVehicleDoorsLocked(veh, 1)
        end
    end

    function self.exist()
        if not self.vehicle then
            return false
        end
        local vehicle = NetworkGetEntityFromNetworkId(self.vehicle)
        if not DoesEntityExist(vehicle) then
            self.vehicle = nil
            return false
        end
        return true
    end

    function self.getVehiclePos()
        if not self.vehicle then
            return nil
        end
        local vehicle = NetworkGetEntityFromNetworkId(self.vehicle)
        if not DoesEntityExist(vehicle) then
            self.vehicle = nil
            return nil
        end
        return GetEntityCoords(vehicle)
    end

    function self.dispawnVehicle()
        if self.vehicle then
            DeleteEntity(NetworkGetEntityFromNetworkId(self.vehicle))
            self.vehicle = nil
        end
    end

    function self.addKey(player, manufacture)
        player.addItem("keys", 1, {
            renamed = ("Clés %s"):format(self.plate),
            manufacture = manufacture or "AUCUN",
            plate = self.plate
        })
        player.updateInventory()
    end

    function self.changeState(state)
        self.state = state
        MySQL.update.await("UPDATE vehicles SET state = ? WHERE plate = ?", {state, self.plate})
    end

    function self.changePlate(plate)
        local result = MySQL.scalar.await("SELECT 1 FROM vehicles WHERE plate = ?", { plate })
        if result then
            return false
        end
        self.plate = plate
        self.prop.plate = plate
        MySQL.update.await("UPDATE vehicles SET plate = ? WHERE plate = ?", {plate, self.plate})
        if self.vehicle then
            SetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(self.vehicle), plate)
        end
        return true
    end

    function self.changeProp(prop)
        self.prop = prop
        self.prop.plate = self.plate
        MySQL.update.await("UPDATE vehicles SET prop = ? WHERE plate = ?", {json.encode(prop), self.plate})
    end

    return self
end