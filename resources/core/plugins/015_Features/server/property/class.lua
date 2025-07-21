--@todo: check si permissions de gérer les instances
local function check(xPlayer, access)
    if string.find(access, "player:") then
        local ownerId = string.gsub(access, "player:", "")

        return xPlayer.id == tonumber(ownerId)
    elseif string.find(access, "job:") then
        local jobName = string.gsub(access, "job:", "")

        return xPlayer.job.name == jobName
    elseif string.find(access, "crew:") then
        local crewName = string.gsub(access, "crew:", "")

        return crewName == xPlayer.faction.name
    end
    return false
end
local typeList = {
    "Habitation",
    "Garage",
    "Stockage"
}

function VFW.CreatePropertyClass(id, typeProperty, owner, name, access, pos, data, rental)
    local self = {}

    self.id = id
    self.type = typeList[typeProperty]
    self.owner = owner
    self.name = name
    self.accessList = access
    self.pos = pos
    self.data = data
    self.rental = rental
    self.hide = false
    self.accessInfo = {}

    self.state = "sonnette"
    
    function self.isOwner(playerId)
        local xPlayer = VFW.GetPlayerFromId(playerId)

        return check(xPlayer, self.owner)
    end

    function self.updatePosition(newPos)
        self.pos = newPos
        MySQL.update.await('UPDATE property SET pos = ? WHERE id = ?', {
            json.encode(newPos), self.id
        })
    end

    function self.canAccess(playerId)
        if self.isOwner(playerId) then
            return true
        end

        local xPlayer = VFW.GetPlayerFromId(playerId)
        for i = 1, #self.accessList do
            if check(xPlayer, self.accessList[i]) then
                return true
            end
        end

        return (self.state == "ouvert")
    end

    function self.getOwnerInfo()
        if self.ownerName then
            return self.ownerName, self.ownerFace, self.ownerIdentifier
        end
        if string.find(self.owner, "player:") then
            local ownerId = string.gsub(self.owner, "player:", "") --@todo: check if player exists
            local result = MySQL.single.await("SELECT firstname, lastname, mugshot, identifier FROM users WHERE id = @id", {["@id"] = tonumber(ownerId)})
            self.ownerIdentifier = result.identifier
            print("identifier find ", identifierTarget)
            self.ownerFace = result?.mugshot or "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
            self.ownerName = result and ("%s %s"):format(result.firstname, result.lastname) or "Inconnu"
            if not result then
                self.hide = true
            end
        elseif string.find(self.owner, "job:") then
            local jobName = string.gsub(self.owner, "job:", "")
            self.ownerFace = "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
            self.ownerName = VFW.Jobs[jobName].label
            self.hide = false
        else
            self.ownerFace = "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
            self.ownerName = "Inconnu"
            self.hide = true
        end
        return self.ownerName, self.ownerFace, self.ownerIdentifier
    end

    function self.getAccessInfo()
        for i = 1, #self.accessList do
            if not self.accessInfo[i] then
                self.accessInfo[i] = {
                    id = self.accessList[i]
                }
                if string.find(self.accessList[i], "player:") then
                    local ownerId = string.gsub(self.accessList[i], "player:", "") --@todo: check if player exists
                    local result = MySQL.single.await("SELECT firstname, lastname, mugshot FROM users WHERE id = @id", {["@id"] = tonumber(ownerId)})
                    self.accessInfo[i].face = result?.mugshot or "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
                    self.accessInfo[i].name = result and ("%s %s"):format(result.firstname, result.lastname) or "Inconnu"
                    if not result then
                        self.accessInfo[i].hide = true
                    end
                elseif string.find(self.accessList[i], "job:") then
                    local jobName = string.gsub(self.accessList[i], "job:", "")
                    self.accessInfo[i].face = "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
                    self.accessInfo[i].name = VFW.Jobs[jobName].label
                elseif string.find(self.accessList[i], "crew:") then
                    self.accessInfo[i].face = "https://cdn.eltrane.cloud/alkiarp/characterCreator/parents/Adrian.png"
                    self.accessInfo[i].name = "Inconnu"
                end
            end
        end
        return self.accessInfo
    end

    function self.addAccess(access)
        table.insert(self.accessList, access)
    end

    function self.removeAccess(access)
        for i = 1, #self.accessList do
            if self.accessList[i] == access then
                if self.accessInfo[i].id == self.accessList[i] then
                    table.remove(self.accessInfo, i)
                end
                table.remove(self.accessList, i)
                return
            end
        end
    end

    function self.save()
        MySQL.update.await('UPDATE property SET name = ?, access = ? WHERE id = ?', {
            self.name, json.encode(self.accessList), self.id
        })
    end
    
    if self.type == "Garage" then
        function self.addVehicle(plate)
            local vehicle = VFW.GetVehicleByPlate(plate)
            if not vehicle then
                console.debug(("Vehicle %s not found"):format(plate))
                return
            end

            self.data.vehicles[plate] = vehicle.model
            MySQL.update.await('UPDATE property SET data = ? WHERE id = ?', {
                json.encode(self.data), self.id
            })

            VFW.GetVehicleByPlate(plate).changeState(self.id)
        end

        function self.removeVehicle(plate)
            self.data.vehicles[plate] = nil
            MySQL.update.await('UPDATE property SET data = ? WHERE id = ?', {
                json.encode(self.data), self.id
            })

            VFW.GetVehicleByPlate(plate).changeState(0)
        end
    else
        function self.enterProperty(playerId)
            local xPlayer = VFW.GetPlayerFromId(playerId)
            xPlayer.setMeta("insideProperty", self.id)
            xPlayer.setMeta("lastOutside", json.encode(self.pos))
            SetPlayerRoutingBucket(playerId, 0)
        end

        function self.leaveProperty(playerId)
            local xPlayer = VFW.GetPlayerFromId(playerId)
            xPlayer.setMeta("insideProperty", 0)
            SetPlayerRoutingBucket(playerId, 0)
            SetEntityCoords(GetPlayerPed(playerId), self.pos.x, self.pos.y, self.pos.z-0.9)
        end        
    end

    return self
end