local pedModel = {
    ["m"] = 0,
    ["w"] = 1
}
---@class xPlayer
---@field accounts table
---@field coords table
---@field group string
---@field identifier string
---@field inventory table
---@field job table
---@field faction table
---@field loadout table
---@field name string
---@field playerId number
---@field source number
---@field variables table
---@field weight number
---@field maxWeight number
---@field metadata table
---@field lastPlaytime number
---@field admin boolean
---@field license string

---@param playerId number
---@param identifier string
---@param group string
---@param accounts table
---@param inventory table
---@param weight number
---@param job table
---@param faction table
---@param loadout table
---@param name string
---@param coords table | vector4
---@param metadata table
function CreateExtendedPlayer(id, playerId, identifier, accounts, inventory, weight, job, faction, name, coords, metadata, skin, mugshot, tattoos, vcoins)
    ---@class xPlayer
    local self = {}

    self.id = id
    self.accounts = accounts
    self.coords = coords
    self.identifier = identifier
    self.inventory = inventory
    self.job = job
    self.faction = faction
    self.name = name
    self.playerId = playerId
    self.source = playerId
    self.variables = {}
    self.weight = weight
    self.maxWeight = VFW.GetPlayerGlobalFromId(playerId).permissions["staff_menu"] and 1000 or Config.MaxWeight
    self.metadata = metadata
    self.lastPlaytime = self.metadata.lastPlaytime or 0
    self.paycheckEnabled = true
    self.admin = Core.IsPlayerAdmin(playerId)
    self.skin = skin
    self.mugshot = mugshot
    self.tattoos = tattoos
    self.search = {}
    self.lastWeaponId = nil
    self.vcoins = vcoins or 0

    if Config.Multichar then
        local startIndex = identifier:find(":", 1)
        if startIndex then
            self.license = ("license%s"):format(identifier:sub(startIndex, identifier:len()))
        end
    else
        self.license = ("license:%s"):format(identifier)
    end

    if type(self.metadata.jobDuty) ~= "boolean" then
        self.metadata.jobDuty = self.job.name ~= "unemployed" and Config.DefaultJobDuty or false
    end
    job.onDuty = self.metadata.jobDuty

    if type(self.metadata.factionDuty) ~= "boolean" then
        self.metadata.factionDuty = self.faction.name ~= "nofaction" and Config.DefaultFactionDuty or false
    end
    faction.onDuty = self.metadata.factionDuty

    if type(self.metadata.factionDuty) ~= "boolean" then
        self.metadata.factionDuty = self.faction.name ~= "nofaction" and Config.DefaultFactionDuty or false
    end
    faction.onDuty = self.metadata.factionDuty

    --ExecuteCommand(("add_principal identifier.%s group.%s"):format(self.license, self.group))

    local stateBag = Player(self.source).state
    stateBag:set("identifier", self.identifier, false)
    stateBag:set("license", self.license, false)
    stateBag:set("job", self.job, true)
    stateBag:set("faction", self.faction, true)
    stateBag:set("name", self.name, true)

    ---@param eventName string
    ---@param ... any
    ---@return nil
    function self.triggerEvent(eventName, ...)
        assert(type(eventName) == "string", "eventName should be string!")
        TriggerClientEvent(eventName, self.source, ...)
    end

    function self.getVCoins()
        return self.vcoins
    end
    ---@param toggle boolean
    ---@return nil
    function self.togglePaycheck(toggle)
        self.paycheckEnabled = toggle
    end

    ---@return boolean
    function self.isPaycheckEnabled()
        return self.paycheckEnabled
    end

    ---@param coordinates vector4 | vector3 | table
    ---@return nil
    function self.setCoords(coordinates)
        local ped <const> = GetPlayerPed(self.source)

        SetEntityCoords(ped, coordinates.x, coordinates.y, coordinates.z, false, false, false, false)
        SetEntityHeading(ped, coordinates.w or coordinates.heading or 0.0)
    end

    ---@param vector boolean
    ---@param heading boolean
    ---@return vector3 | vector4 | table
    function self.getCoords(vector, heading)
        local ped <const> = GetPlayerPed(self.source)
        local entityCoords <const> = GetEntityCoords(ped)
        local entityHeading <const> = GetEntityHeading(ped)

        local coordinates = { x = entityCoords.x, y = entityCoords.y, z = entityCoords.z }

        if vector then
            coordinates = (heading and vector4(entityCoords.x, entityCoords.y, entityCoords.z, entityHeading) or entityCoords)
        else
            if heading then
                coordinates.heading = entityHeading
            end
        end

        return coordinates
    end

    ---@param reason string
    ---@return nil
    function self.kick(reason)
        local source <const> = tostring(self.source)
        DropPlayer(source, reason)
    end

      ---@return number
    function self.getPlayTime()
        -- luacheck: ignore
        return self.lastPlaytime + GetPlayerTimeOnline(self.source)
    end

    ---@param money number
    ---@return nil
    function self.setMoney(money)
        assert(type(money) == "number", "money should be number!")
        
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == "money" then
                table.remove(self.inventory, i)
            end
        end

        self.addMoney(money)
    end

    ---@return number
    function self.getMoney()
        local count = 0
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == "money" then
                count += item.count
            end
        end

        return count
    end

    ---@param money number
    ---@param reason string
    ---@return nil
    function self.addMoney(money)
        self.createItem("money", money)
        self.updateInventory()
    end

    ---@param money number
    ---@param reason string
    ---@return nil
    function self.removeMoney(money)
        local count = money
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == "money" then
                if item.count > count then
                    item.count -= count
                    self.weight -= (VFW.Items["money"].weight * count)
                    break
                else
                    self.weight -= (VFW.Items["money"].weight * item.count)
                    count -= item.count
                    table.remove(self.inventory, i)
                end
            end
        end

        self.updateInventory()
    end

    ---@return string
    function self.getIdentifier()
        return self.identifier
    end

    ---@param k string
    ---@param v any
    ---@return nil
    function self.set(k, v)
        self.variables[k] = v
    end

    ---@param k string
    ---@return any
    function self.get(k)
        return self.variables[k]
    end

    ---@param minimal boolean
    ---@return table
    function self.getAccounts(minimal)
        if not minimal then
            return self.accounts
        end

        local minimalAccounts = {}

        for i = 1, #self.accounts do
            minimalAccounts[self.accounts[i].name] = self.accounts[i].money
        end

        return minimalAccounts
    end

    ---@param account string
    ---@return table | nil
    function self.getAccount(account)
        account = string.lower(account)
        for i = 1, #self.accounts do
            local accountName = string.lower(self.accounts[i].name)
            if accountName == account then
                return self.accounts[i]
            end
        end
        return nil
    end

    ---@param minimal boolean
    ---@return table
    function self.getInventory()
        return self.inventory
    end

    ---@return table
    function self.getJob()
        return self.job
    end

    ---@return table
    function self.getFaction()
        return self.faction
    end

    ---@return string
    function self.getName()
        return self.name
    end

    ---@param newName string
    ---@return nil
    function self.setName(newName)
        self.name = newName
        Player(self.source).state:set("name", self.name, true)
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string | nil
    ---@return nil
    function self.setAccountMoney(accountName, money, reason)
        reason = reason or "unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money >= 0 then
            local account = self.getAccount(accountName)

            if account then
                money = account.round and VFW.Math.Round(money) or money
                self.accounts[account.index].money = money

                self.triggerEvent("vfw:setAccountMoney", account)
                TriggerEvent("vfw:setAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Invalid Account ^3%s^1 For Player ^3%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
        end
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string | nil
    ---@return nil
    function self.addAccountMoney(accountName, money, reason)
        reason = reason or "Unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money > 0 then
            local account = self.getAccount(accountName)
            if account then
                money = account.round and VFW.Math.Round(money) or money
                self.accounts[account.index].money = self.accounts[account.index].money + money

                self.triggerEvent("vfw:setAccountMoney", account)
                TriggerEvent("vfw:addAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Add To Invalid Account ^3%s^1 For Player ^3%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
        end
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string | nil
    ---@return nil
    function self.removeAccountMoney(accountName, money, reason)
        reason = reason or "Unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money > 0 then
            local account = self.getAccount(accountName)

            if account then
                money = account.round and VFW.Math.Round(money) or money
                if self.accounts[account.index].money - money > self.accounts[account.index].money then
                    error(("Tried To Underflow Account ^3%s^1 For Player ^3%s^1!"):format(accountName, self.playerId))
                    return
                end
                self.accounts[account.index].money = self.accounts[account.index].money - money

                self.triggerEvent("vfw:setAccountMoney", account)
                TriggerEvent("vfw:removeAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Add To Invalid Account ^3%s^1 For Player ^3%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^3%s^1 For Player ^3%s^1 To An Invalid Number -> ^3%s^1"):format(accountName, self.playerId, money))
        end
    end

    function self.haveItem(itemName, metaData)
        for i = 1, #self.inventory do
            local item = self.inventory[i]
            if VFW.SameItem(item, { name = itemName, meta = (metaData or {}) }, true) then
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

        if (VFW.Items[itemName].type == "weapons") and string.find(itemName, "weapon_") then
            local _, weapon = VFW.GetWeapon(itemName)
            if not weapon.throwable then
                for i = 1, count do
                    local metaData = {}
                    metaData.weaponId = VFW.WeaponID()
                    metaData.ammo = 0
    
                    self.addItem(itemName, 1, metaData)
                end
            else
                self.addItem(itemName, count, {})
            end
            return
        end

        self.addItem(itemName, count, {})
    end

    function self.renameItem(position, typeItem, name)
        for i = 1, #self.inventory do
            if VFW.Items[self.inventory[i].name].type == typeItem and self.inventory[i].position.x == position.x and self.inventory[i].position.y == position.y then
                self.inventory[i].meta.renamed = name
                return
            end
        end
    end
    
    function self.addItem(itemName, count, metaData, separate)
        if not VFW.Items[itemName] then
            console.warn(('Item ^3"%s"^7 was added but does not exist!'):format(itemName))
            return
        end
        
        self.weight += (VFW.Items[itemName].weight * count)

        local taked = {}
        for i = 1, #self.inventory do
            if VFW.Items[self.inventory[i].name].type == VFW.Items[itemName].type then
                if not separate and VFW.SameItem(self.inventory[i], { name = itemName, meta = metaData }) then
                    self.inventory[i].count += count
                    return
                end
                local x, y = self.inventory[i].position.x+1, self.inventory[i].position.y+1
                if not taked[y] then
                    taked[y] = {}
                end
                taked[y][x] = true
            end
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
    end

    function self.hasItem(itemName, count)
        for _, v in ipairs(self.inventory) do
            if v.name == itemName and v.count >= 1 then
                return v, v.count
            end
        end

        return false
    end

    function self.getPhones()
        local phones = {}
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == "phone" then
                phones[#phones + 1] = item
            end
        end

        return phones
    end

    function self.changeMeta(itemName, oldMeta, newMeta)
        local count = 0
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if VFW.SameItem(item, { name = itemName, meta = oldMeta }) then
                item.meta = newMeta

                return true
            end
        end

        return false
    end

    function self.setComponent(weaponComponent)
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.meta.weaponId == self.lastWeaponId then
                item.meta.components = item.meta.components or {}
                table.insert(item.meta.components, weaponComponent)
                return true
            end
        end

        return false
    end

    function self.setTint(weaponTint)
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.meta.weaponId == self.lastWeaponId then
                item.meta.tint = weaponTint
                return true
            end
        end

        return false
    end

    function self.setKevlar(kevlarName, kevlarShield)
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == kevlarName then
                item.meta.shield = kevlarShield
                return true
            end
        end

        return false
    end

    function self.registerPhone(position, newMeta)
        local count = 0
        for i = 1, #self.inventory do
            if self.inventory[i].name == "phone" and position.x == self.inventory[i].position.x and position.y == self.inventory[i].position.y then
                if self.inventory[i].count > 1 then
                    self.inventory[i].count -= 1
                    self.addItem(itemName, 1, newMeta)
                else
                    self.inventory[i].meta = newMeta
                end

                return true
            end
        end

        return false
    end

    function self.countItem(itemName, metaData)
        local count = 0
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if VFW.SameItem(item, { name = itemName, meta = metaData }) then
                count += item.count
            end
        end

        return count
    end

    function self.countItemBP(itemName)
        local count = 0
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item.name == itemName then
                count += item.count
            end
        end

        return count
    end

    function self.removeItem(itemName, count, metaData)
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item == nil then
                return 
            end

            if VFW.SameItem(item, { name = itemName, meta = metaData or {} }, true) then
                if item.count > count then
                    item.count -= count
                    self.weight -= (VFW.Items[itemName].weight * count)
                    return
                else
                    self.weight -= (VFW.Items[itemName].weight * item.count)
                    count -= item.count
                    table.remove(self.inventory, i)
                end
            end
        end
    end

    function self.removeItemBP(itemName, count)
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            if item == nil then
                return 
            end

            if item.name == itemName then
                if item.count > count then
                    item.count -= count
                    self.weight -= (VFW.Items[itemName].weight * count)
                    return
                else
                    self.weight -= (VFW.Items[itemName].weight * item.count)
                    count -= item.count
                    table.remove(self.inventory, i)
                end
            end
        end
    end

    function self.syncWeight()
        local weight = 0
        for i = 1, #self.inventory do
            local item = self.inventory[i]

            weight += VFW.Items[item.name].weight * item.count
        end

        self.weight = weight
    end

    function self.deleteItem(itemName)
        for i = 1, #self.inventory do
            if self.inventory[i].name == itemName then
                table.remove(self.inventory, i)
            end
        end
        self.syncWeight()
    end

    function self.checkDeleteItem()
        for i = 1, #self.inventory do
            if not VFW.Items[self.inventory[i].name] then
                table.remove(self.inventory, i)
            end
        end
        self.syncWeight()
    end

    function self.moveItem(position, newPosition, typeItem)
        for i = 1, #self.inventory do
            if VFW.Items[self.inventory[i].name].type == typeItem then
                if position.x == self.inventory[i].position.x and position.y == self.inventory[i].position.y then
                    for j = 1, #self.inventory do
                        if VFW.Items[self.inventory[j].name].type == typeItem then
                            if newPosition.x == self.inventory[j].position.x and newPosition.y == self.inventory[j].position.y then
                                if VFW.SameItem(self.inventory[i], self.inventory[j]) then
                                    self.inventory[j].count += self.inventory[i].count
                                    table.remove(self.inventory, i)
                                    return
                                else
                                    self.inventory[j].position = position
                                end
                            end
                        end
                    end

                    self.inventory[i].position = newPosition
                    return
                end
            end
        end
    end

    function self.splitItem(position, typeItem, count)
        for i = 1, #self.inventory do
            if VFW.Items[self.inventory[i].name].type == typeItem and self.inventory[i].position.x == position.x and self.inventory[i].position.y == position.y then
                if self.inventory[i].count > count then
                    self.inventory[i].count -= count
                    self.addItem(self.inventory[i].name, count, self.inventory[i].meta, true)
                end
                return
            end
        end
    end

    function self.updateInventory()
        self.triggerEvent("vfw:updateInventory", self.getInventory(), self.getWeight())

        for i = 1, #self.search do
            TriggerClientEvent("vfw:search:update", self.search[i], self.getInventory(), self.getWeight())
        end
    end

    function self.addSearch(target)
        self.search[#self.search + 1] = target
    end

    function self.removeSearch(target)
        for i = 1, #self.search do
            if self.search[i] == target then
                table.remove(self.search, i)
                return
            end
        end
    end

    function self.useItem(itemName, metaData)
        local item = self.haveItem(itemName, metaData)

        if item then
            local function deleteCallback()
                self.removeItem(itemName, 1, metaData)
                self.updateInventory()
            end

            if (VFW.Items[itemName].type == "weapons") and string.find(itemName, "weapon_") then
                local ped = GetPlayerPed(self.source)
                local hash = GetHashKey(itemName)
                local weapon = GetCurrentPedWeapon(ped)

                -- S'assurer que les métadonnées existent avant tout traitement
                if not metaData then
                    metaData = {
                        weaponId = VFW.WeaponID(),
                        ammo = 0
                    }
                    self.inventory[item].meta = metaData
                end
                if not metaData.weaponId then
                    metaData.weaponId = VFW.WeaponID()
                    self.inventory[item].meta.weaponId = metaData.weaponId
                end

                if weapon == hash then
                    local ammo = TriggerClientCallback(self.source, "vfw:getAmmoInPedWeapon", hash)
                    self.inventory[item].meta.ammo = ammo
                    RemoveWeaponFromPed(ped, hash)
                    SetPedAmmo(ped, hash, 0)
                    self.lastWeaponId = nil
                else
                    if weapon ~= -1569615261 then
                        SetPedAmmo(ped, weapon, 0)
                        RemoveWeaponFromPed(ped, weapon)
                    end

                    local _, weapon = VFW.GetWeapon(itemName)
                    local ammo = 0
                    if not weapon.throwable then
                        if not metaData.ammo then
                            self.inventory[item].meta.ammo = 0
                            metaData.ammo = 0
                        end
                        ammo = metaData.ammo
                    else
                        ammo = self.countItemBP(itemName)
                    end
                    GiveWeaponToPed(ped, hash, ammo, false, true)
                    if metaData.components then
                        for _, component in ipairs(metaData.components) do
                            GiveWeaponComponentToPed(ped, hash, component)
                        end
                    end
                    if metaData.tint then
                        self.triggerEvent("vfw:setWeaponTint", hash, metaData.tint)
                    end
                    self.lastWeaponId = metaData.weaponId
                end

                -- Déclencher l'événement weaponChange avec un weaponId valide
                self.triggerEvent("vfw:weaponChange", metaData.weaponId)

                if itemName == "weapon_petrolcan" then
                    self.triggerEvent("vfw:usePetrolCan")
                end
            elseif (VFW.Items[itemName].data.type == "ammo") then
                local weapon, ammo = TriggerClientCallback(self.source, "vfw:getMaxAmmo")

                if (not weapon) or (VFW.Items[weapon].data.ammoType ~= itemName) then
                    console.warn(("[VFW] Item ^3%s^7 was used but does not exist!"):format(itemName))
                    return
                end

                deleteCallback()
                SetPedAmmo(GetPlayerPed(self.source), joaat(weapon), ammo)
            elseif VFW.Items[itemName].type == "clothes" then
                if self.skin.sex == pedModel[metaData.sex] then
                    self.triggerEvent("vfw:clothes", itemName, metaData)
                else
                    self.showNotification({
                        type = 'ROUGE',
                        content = "Vous ne pouvez pas utiliser des vêtements qui ne sont pas de votre sexe."
                    })
                end
            elseif VFW.Items[itemName].data.type == "consumable" then
                TriggerClientEvent("vfw:eat", self.source, itemName)
                local hunger = tonumber(self.getMeta("hunger")) or 0
                local thirst = tonumber(self.getMeta("thirst")) or 0
                local newHunger = hunger + (VFW.Items[itemName].data.hunger or 0)
                local newThirst = thirst + (VFW.Items[itemName].data.thirst or 0)
                self.setMeta("hunger", newHunger > 100 and 100 or newHunger)
                self.setMeta("thirst", newThirst > 100 and 100 or newThirst)
                deleteCallback()
            elseif VFW.Items[itemName].data.type == "component" then
                local weapon = GetCurrentPedWeapon(GetPlayerPed(self.source))

                if weapon then
                    local componentHash = joaat(VFW.Items[itemName].name)

                    if HasPedGotWeaponComponent(GetPlayerPed(self.source), weapon, componentHash) then
                        self.showNotification({
                            type = 'ROUGE',
                            content = "Vous avez déjà ce composant sur votre arme"
                        })
                    else
                        local check = self.setComponent(componentHash)

                        if check then
                            self.updateInventory()
                            GiveWeaponComponentToPed(GetPlayerPed(self.source), weapon, componentHash)
                            self.showNotification({
                                type = 'VERT',
                                content = ("Composant %s ajouté"):format(VFW.Items[itemName].label)
                            })
                            deleteCallback()
                        else
                            self.showNotification({
                                type = 'ROUGE',
                                content = "Vous devez posséder l'arme correspondante pour utiliser ce composant"
                            })
                            return
                        end
                    end
                end
            elseif VFW.Items[itemName].data.type == "tint" then
                local weapon = GetCurrentPedWeapon(GetPlayerPed(self.source))

                if weapon then
                    local _, weaponObject = VFW.GetWeapon(VFW.GetWeaponFromHash(weapon).name)

                    if weaponObject.tints and weaponObject.tints[itemName] then
                        local check = self.setTint(itemName)

                        if check then
                            self.updateInventory()
                            self.triggerEvent("vfw:setWeaponTint", weapon, itemName)
                            self.showNotification({
                                type = 'VERT',
                                content = ("Teinte %s appliquée"):format(VFW.Items[itemName].label)
                            })
                            deleteCallback()
                        else
                            self.showNotification({
                                type = 'ROUGE',
                                content = "Vous devez posséder l'arme correspondante pour utiliser cette teinte"
                            })
                            return
                        end
                    end
                end
            elseif Core.UsableItemsCallbacks[itemName] then
                Core.UsableItemsCallbacks[itemName](self, deleteCallback, metaData)
            end
        end
    end

    function self.giveItem(targetPlayer, position, typeItem, count)
        for i = 1, #self.inventory do
            if (VFW.Items[self.inventory[i].name].type == typeItem) and (position.x == self.inventory[i].position.x) and (position.y == self.inventory[i].position.y) then
                self.weight -= (VFW.Items[self.inventory[i].name].weight * count)
                if count >= self.inventory[i].count then
                    targetPlayer.addItem(self.inventory[i].name, self.inventory[i].count, self.inventory[i].meta)
                    table.remove(self.inventory, i)
                else
                    targetPlayer.addItem(self.inventory[i].name, count, self.inventory[i].meta)
                    self.inventory[i].count -= count
                end
                return
            end
        end
    end

    ---@return number
    function self.getWeight()
        return self.weight
    end

    ---@return number
    function self.getMaxWeight()
        return self.maxWeight
    end

    ---@param itemName string
    ---@param count number
    ---@return boolean
    function self.canCarryItem(itemName, count)
        if VFW.Items[itemName] then
            local currentWeight, itemWeight = self.weight, VFW.Items[itemName].weight
            local newWeight = currentWeight + (itemWeight * count)

            return newWeight <= self.maxWeight
        else
            console.warn(('Item ^3"%s"^7 was used but does not exist!'):format(itemName))
            return false
        end
    end

    ---@param newWeight number
    ---@return nil
    function self.setMaxWeight(newWeight)
        self.maxWeight = newWeight
        self.triggerEvent("vfw:setMaxWeight", self.maxWeight)
    end

    ---@param newJob string
    ---@param grade string
    ---@param onDuty? boolean
    ---@return nil
    function self.setJob(newJob, grade, onDuty)
        grade = tostring(grade)
        local lastJob = self.job

        if not VFW.DoesJobExist(newJob, grade) then
            return console.warn(("[VFW] Ignoring invalid ^3.setJob()^7 usage for ID: ^3%s^7, Job: ^3%s^7"):format(self.source, newJob))
        end

        if newJob == "unemployed" then
            onDuty = false
        end

        if type(onDuty) ~= "boolean" then
            onDuty = Config.DefaultJobDuty
        end

        local jobObject, gradeObject = VFW.Jobs[newJob], VFW.Jobs[newJob].grades[grade]

        self.job = {
            id = jobObject.id,
            name = jobObject.name,
            label = jobObject.label,
            type = jobObject.type,
            onDuty = onDuty,
            perms = jobObject.perms,
            devise = jobObject.devise,
            color = jobObject.color,

            grade = tonumber(grade),
            grade_name = gradeObject.name,
            grade_label = gradeObject.label,
            grade_salary = gradeObject.salary,
        }

        VFW.UpdateJobMembers(self.job.name, self.identifier, grade, jobObject.type == "faction" and "faction" or "job")
        self.metadata.jobDuty = onDuty
        TriggerEvent("vfw:setJob", self.source, self.job, lastJob)
        self.triggerEvent("vfw:setJob", self.job, lastJob)
        Player(self.source).state:set("job", self.job, true)
    end

    ---@param newFaction string
    ---@param grade string
    ---@param onDuty? boolean
    ---@return nil
    function self.setFaction(newFaction, grade, onDuty)
        grade = tostring(grade)
        local lastFaction = self.faction

        if not VFW.DoesFactionExist(newFaction, grade) then
            console.warn(("[VFW] Ignoring invalid ^3.setFaction()^7 usage for ID: ^3%s^7, Faction: ^3%s^7"):format(self.source, newFaction))
            return 
        end

        if newFaction == "nocrew" then
            onDuty = false
            local query = "DELETE FROM crew_members WHERE identifier = @identifier"
            MySQL.Async.execute(query, {
                ["@identifier"] = self.identifier
            }, function() end)
        else
            local query = [[
                INSERT INTO crew_members
                    (identifier, faction, firstname, lastname, faction_grade) 
                VALUES 
                    (@identifier, @faction, @firstname, @lastname, @faction_grade)
                ON DUPLICATE KEY UPDATE 
                    faction = @faction, 
                    faction_grade = @faction_grade
            ]]
            MySQL.Async.execute(query, {
                ["@identifier"] = self.identifier,
                ["@faction"] = newFaction,
                ["@firstname"] = self.get("firstName"),
                ["@lastname"] = self.get("lastName"),
                ["@faction_grade"] = grade
            }, function() end)
        end

        if type(onDuty) ~= "boolean" then
            onDuty = Config.DefaultFactionDuty
        end

        -- Récupère l'objet de la faction
        local factionObject = VFW.GetCrewByName(newFaction)
        local gradeObject = nil
        for _, gradeInfo in ipairs(factionObject and factionObject.grades or {}) do
            if gradeInfo.grade == tonumber(grade) then
                gradeObject = gradeInfo
                break
            end
        end



        if not gradeObject then
            console.debug("DEBUG: Le grade " .. tostring(grade) .. " n'existe pas pour la faction " .. tostring(newFaction))
            return false
        end

        self.faction = {
            id = factionObject.id,
            name = factionObject.name,
            label = factionObject.label,
            onDuty = onDuty,
            permissions = factionObject.perms,
            devise = factionObject.devise,
            type = factionObject.type,
            grade = tonumber(grade),
            grade_name = gradeObject.name,
            grade_label = gradeObject.label,
            grade_salary = gradeObject.salary or 0,
        }
        factionObject.addMember(self.identifier, self.getName(), self.mugshot, tonumber(grade))
        if factionObject.name and factionObject.name ~= "nocrew" then
            local grade = tonumber(grade)
            local crew = VFW.GetCrewByName(factionObject.name)
            local perms = crew.getPerms() or {}
            if grade and perms[grade+1] then
                self.faction.permissions = perms[grade+1]
            end
        end

        self.metadata.factionDuty = onDuty
        TriggerEvent("vfw:setFaction", self.source, self.faction, lastFaction)
        self.triggerEvent("vfw:setFaction", self.faction, lastFaction)
        Player(self.source).state:set("faction", self.faction, true)
    end

    function self.canUseCrewPermission(permission)
        local crew = VFW.GetCrewByName(self.faction.name)
        return crew.canUse(self.faction.grade_name, permission)
    end

    function self.canUseJobPermission(permission)
        return self.job.perms[VFW.Jobs[self.job.name].grades[tostring(self.job.grade)].name][permission]
    end

    ---@param notification table
    ---@return nil
    function self.showNotification(notification)
        self.triggerEvent("vfw:showNotification", notification)
    end

    ---@param msg string
    ---@param thisFrame boolean
    ---@param beep boolean
    ---@param duration number
    ---@return nil
    function self.showHelpNotification(msg, thisFrame, beep, duration)
        self.triggerEvent("vfw:showHelpNotification", msg, thisFrame, beep, duration)
    end

    ---@param index any
    ---@param subIndex any
    ---@return table | nil
    function self.getMeta(index, subIndex)
        if not index then
            return self.metadata
        end

        if type(index) ~= "string" then
            return
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return false
        end

        if subIndex and type(metaData) == "table" then
            local _type = type(subIndex)

            if _type == "string" then
                local value = metaData[subIndex]
                return value
            end

            if _type == "table" then
                local returnValues = {}

                for i = 1, #subIndex do
                    local key = subIndex[i]
                    if type(key) == "string" then
                        returnValues[key] = self.getMeta(index, key)
                    else
                        error(("xPlayer.getMeta subIndex should be ^3string^1 or ^3table^1! that contains ^3string^1, received ^3%s^1!, skipping..."):format(type(key)))
                    end
                end

                return returnValues
            end

            error(("xPlayer.getMeta subIndex should be ^3string^1 or ^3table^1!, received ^3%s^1!"):format(_type))
            return
        end

        return metaData
    end

    ---@param index any
    ---@param value any
    ---@param subValue any
    ---@return nil
    function self.setMeta(index, value, subValue)
        if not index then
            return error("xPlayer.setMeta ^3index^1 is Missing!")
        end

        if type(index) ~= "string" then
            return error("xPlayer.setMeta ^3index^1 should be ^3string^1!")
        end

        if value == nil then
            return error("xPlayer.setMeta value is missing!")
        end

        local _type = type(value)

        if not subValue then
            if _type ~= "number" and _type ~= "string" and _type ~= "table" then
                return error(("xPlayer.setMeta ^3%s^1 should be ^3number^1 or ^3string^1 or ^3table^1!"):format(value))
            end

            self.metadata[index] = value
        else
            if _type ~= "string" then
                return error(("xPlayer.setMeta ^3value^1 should be ^3string^1 as a subIndex!"):format(value))
            end

            if not self.metadata[index] or type(self.metadata[index]) ~= "table" then
                self.metadata[index] = {}
            end

            self.metadata[index] = type(self.metadata[index]) == "table" and self.metadata[index] or {}
            self.metadata[index][value] = subValue
        end
        self.triggerEvent('vfw:updatePlayerData', 'metadata', self.metadata)
    end

    function self.clearMeta(index, subValues)
        if not index then
            return error("xPlayer.clearMeta ^3index^1 is Missing!")
        end

        if type(index) ~= "string" then
            return error("xPlayer.clearMeta ^3index^1 should be ^3string^1!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return Config.EnableDebug and error(("xPlayer.clearMeta ^3%s^1 does not exist!"):format(index)) or nil
        end

        if not subValues then
            -- If no subValues is provided, we will clear the entire value in the metaData table
            self.metadata[index] = nil
        elseif type(subValues) == "string" then
            -- If subValues is a string, we will clear the specific subValue within the table
            if type(metaData) == "table" then
                metaData[subValues] = nil
            else
                return error(("xPlayer.clearMeta ^3%s^1 is not a table! Cannot clear subValue ^3%s^1."):format(index, subValues))
            end
        elseif type(subValues) == "table" then
            -- If subValues is a table, we will clear multiple subValues within the table
            for i = 1, #subValues do
                local subValue = subValues[i]
                if type(subValue) == "string" then
                    if type(metaData) == "table" then
                        metaData[subValue] = nil
                    else
                        error(("xPlayer.clearMeta ^3%s^1 is not a table! Cannot clear subValue ^3%s^1."):format(index, subValue))
                    end
                else
                    error(("xPlayer.clearMeta subValues should contain ^3string^1, received ^3%s^1, skipping..."):format(type(subValue)))
                end
            end
        else
            return error(("xPlayer.clearMeta ^3subValues^1 should be ^3string^1 or ^3table^1, received ^3%s^1!"):format(type(subValues)))
        end
        self.triggerEvent('vfw:updatePlayerData', 'metadata', self.metadata)
    end

    for _, funcs in pairs(Core.PlayerFunctionOverrides) do
        for fnName, fn in pairs(funcs) do
            self[fnName] = fn(self)
        end
    end

    return self
end
