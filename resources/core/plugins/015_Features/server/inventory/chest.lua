function VFW.CreateChestClass(inventory, weight, maxWeight, name)
    local self = {}

    self.inventory = inventory
    self.weight = weight
    self.maxWeight = maxWeight
    self.name = name
    self.looking = {}

    local function saveChest()
        local serializedInventory = json.encode(self.inventory)
        MySQL.Async.execute('UPDATE chest SET inventory = @inventory, weight = @weight WHERE name = @name', {
            ['@inventory'] = serializedInventory,
            ['@weight'] = self.weight,
            ['@name'] = self.name
        })
    end

    function self.update()
        for i = 1, #self.looking do
            TriggerClientEvent("vfw:chest:update", self.looking[i], self.getInventory(), self.getWeight())
        end
        saveChest()
    end

    function self.addLooking(playerId)
        self.looking[#self.looking + 1] = playerId
    end

    function self.removeLooking(playerId)
        for i = 1, #self.looking do
            if self.looking[i] == playerId then
                table.remove(self.looking, i)
                return
            end
        end
    end

    function self.haveItem(itemName, metaData)
        for i = 1, #self.inventory do
            local item = self.inventory[i]
            if VFW.SameItem(item, { name = itemName, meta = (metaData or {}) }) then
                return i
            end
        end
        return false
    end

    function self.createItem(itemName, count)
        if not VFW.Items[itemName] then
            console.warn(('Item ^3"%s"^7 was created but does not exist!'):format(itemName))
            return
        end

        if VFW.Items[itemName].type == "weapons" then
            for i = 1, count  do
                local metaData = {}
                metaData.weaponId = VFW.WeaponID()
                metaData.ammo = 0

                self.addItem(itemName, 1, metaData)
            end
            return
        end

        self.addItem(itemName, count, {})
    end

    function self.addItem(itemName, count, metaData, separate)
        print("Attemp to add an item", itemName)
        if not VFW.Items[itemName] then
            console.warn(('Item ^3"%s"^7 was added but does not exist!'):format(itemName))
            return
        end

        self.weight = self.weight + (VFW.Items[itemName].weight * count)

        local taked = {}
        for i = 1, #self.inventory do
            if not separate and VFW.SameItem(self.inventory[i], { name = itemName, meta = metaData }) then
                self.inventory[i].count = self.inventory[i].count + count
                self.update() -- Sauvegarde après ajout
                return
            end
            local x, y = self.inventory[i].position.x+1, self.inventory[i].position.y+1
            if not taked[y] then
                taked[y] = {}
            end
            taked[y][x] = true
        end

        for i = 1, #taked do
            for j = 1, 4 do
                if not taked[i][j] then
                    self.inventory[#self.inventory + 1] = {
                        name = itemName,
                        count = count,
                        meta = metaData,
                        position = {
                            x = j-1,
                            y = i-1,
                        }
                    }
                    self.update()
                    return
                end
            end
        end

        self.inventory[#self.inventory + 1] = {
            name = itemName,
            count = count,
            meta = metaData,
            position = {
                x = 0,
                y = #taked,
            }
        }
        self.update()
    end

    function self.removeItem(itemName, count, metaData)
        for i = 1, #self.inventory do
            local item = self.inventory[i]
            if item.name == itemName then
                if metaData then
                    for key, value in pairs(metaData) do
                        if item.meta[key] ~= value then
                            goto after
                        end
                    end
                end
                if item.count >= count then
                    item.count = item.count - count
                    self.weight = self.weight - (VFW.Items[itemName].weight * count)
                    if item.count == 0 then
                        table.remove(self.inventory, i)
                    end
                    self.update()
                    return true
                end
            end
            :: after ::
        end
        return false
    end

    function self.moveItem(position, newPosition)
        for i = 1, #self.inventory do
            if position.x == self.inventory[i].position.x and position.y == self.inventory[i].position.y then
                for j = 1, #self.inventory do
                    if newPosition.x == self.inventory[j].position.x and newPosition.y == self.inventory[j].position.y then
                        if VFW.SameItem(self.inventory[i], self.inventory[j]) then
                            self.inventory[j].count = self.inventory[j].count + self.inventory[i].count
                            table.remove(self.inventory, i)
                            self.update()
                            return
                        else
                            self.inventory[j].position = position
                        end
                    end
                end

                self.inventory[i].position = newPosition
                self.update()
                return
            end
        end
    end

    function self.putItem(player, position, typeItem, quantity)
        for i = 1, #player.inventory do
            local item = player.inventory[i]
            if typeItem == VFW.Items[item.name].type and position.x == item.position.x and position.y == item.position.y then
                local count = quantity
                if (not quantity) or (quantity and (item.count < quantity)) then
                    count = item.count
                end
                self.addItem(item.name, count, item.meta)

                player.inventory[i].count = player.inventory[i].count - count
                player.weight = player.weight - (VFW.Items[item.name].weight * count)
                if player.inventory[i].count == 0 then
                    table.remove(player.inventory, i)
                end
                return
            end
        end
    end

    function self.takeItem(player, position, quantity)
        for i = 1, #self.inventory do
            local item = self.inventory[i]
            if position.x == item.position.x and position.y == item.position.y then
                local count = quantity
                if (not quantity) or (quantity and (item.count < quantity)) then
                    count = item.count
                end
                player.addItem(item.name, count, item.meta)

                self.inventory[i].count = self.inventory[i].count - count
                self.weight = self.weight - (VFW.Items[item.name].weight * count)
                if self.inventory[i].count == 0 then
                    table.remove(self.inventory, i)
                end
                self.update()
                return
            end
        end
    end

    function self.getInventory()
        return self.inventory
    end

    function self.getWeight()
        return self.weight
    end

    function self.getMaxWeight()
        return self.maxWeight
    end

    return self
end