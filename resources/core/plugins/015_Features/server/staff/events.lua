VFW.ServerRole = {}

CreateThread(function()
    VFW.ServerRole = VFW.GetServerInfo().roles
end)

RegisterServerCallback("vfw:staff:getRoles", function(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal.permissions["gestion_perm"] then
        return
    end

    VFW.ServerRole = VFW.GetServerInfo().roles

    return Core.RolesList, VFW.ServerRole
end)

function VFW.GetPermissionColor(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    local highestLevel = -1
    local color = nil

    for _, role in ipairs(playerGlobal.roles) do
        if Core.RolesList[role] then
            local roleData = Core.RolesList[role]
            local currentLevel = roleData.level or 0

            if currentLevel > highestLevel then
                highestLevel = currentLevel

                for i = 1, #VFW.ServerRole do
                    if VFW.ServerRole[i].id == role then
                        color = VFW.ServerRole[i].color
                        break
                    end
                end
            end
        end
    end

    return color
end

function VFW.GetPermissionLabel(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    local highestLevel = -1
    local label = nil

    for _, role in ipairs(playerGlobal.roles) do
        if Core.RolesList[role] then
            local roleData = Core.RolesList[role]
            local currentLevel = roleData.level or 0

            if currentLevel > highestLevel then
                highestLevel = currentLevel

                for i = 1, #VFW.ServerRole do
                    if VFW.ServerRole[i].id == role then
                        label = VFW.ServerRole[i].name
                        break
                    end
                end
            end
        end
    end

    return label
end

RegisterNetEvent("vfw:staff:saveRole", function(roles)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)

    if not playerGlobal.permissions["gestion_perm"] then
        return
    end

    for i = 1, #roles do
        local role = roles[i]
        local permissions = {}
        for j = 1, #role.permissions do
            permissions[role.permissions[j]] = true
        end

        Core.RolesList[role.id] = {
            level = role.power,
            permissions = permissions
        }
        MySQL.update.await("UPDATE roles SET level = @level, permissions = @permissions WHERE id = @id", {
            ["@level"] = role.power,
            ["@permissions"] = json.encode(permissions),
            ["@id"] = role.id
        })
    end
    for k, _ in pairs(Core.RolesList) do
        local found = false
        for i = 1, #roles do
            if roles[i].id == k then
                found = true
                break
            end
        end
        if not found then
            MySQL.update.await("DELETE FROM roles WHERE id = ?", {
                k
            })
            Core.RolesList[k] = nil
        end
    end 
end)

RegisterServerCallback("vfw:staff:createRole", function(source, discordId)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal.permissions["gestion_perm"] then
        return
    end

    Core.RolesList[discordId] = {
        level = 1,
        permissions = {}
    }
    MySQL.insert.await("INSERT INTO roles (id, level, permissions) VALUES (@id, @level, @permissions)", {
        ["@id"] = discordId,
        ["@level"] = 1,
        ["@permissions"] = json.encode({})
    })
    return Core.RolesList, VFW.GetServerInfo().roles
end)

RegisterServerCallback("vfw:staff:createCopiedRole", function(source, discordId, role)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)
    if not playerGlobal.permissions["gestion_perm"] then
        return
    end

    local permissions = Core.RolesList[tostring(role)].permissions
    local power = Core.RolesList[tostring(role)].level
    Core.RolesList[discordId] = {
        level = power,
        permissions = permissions
    }
    MySQL.insert.await("INSERT INTO roles (id, level, permissions) VALUES (@id, @level, @permissions)", {
        ["@id"] = discordId,
        ["@level"] = power,
        ["@permissions"] = json.encode(permissions)
    })
    return Core.RolesList, VFW.GetServerInfo().roles
end)

RegisterNetEvent("vfw:staff:message", function(target, message)
    local targetPlayer = VFW.GetPlayerFromId(target)
    if not targetPlayer then
        return
    end
    targetPlayer.showNotification({ type = 'ROUGE', content = message})
end)

RegisterNetEvent("vfw:staff:saveItems", function(items)
    local xPlayer = VFW.GetPlayerFromId(source)
    local playerGlobal = VFW.GetPlayerGlobalFromId(source)

    if not playerGlobal.permissions["gestion_items"] then
        return
    end

    for name, item in pairs(items) do
        if item == "delete" then
            MySQL.update("DELETE FROM `items` WHERE `name` = ?", {
                name,
            })
            for _, xPlayer in pairs(VFW.Players) do
                if xPlayer and xPlayer ~= nil then
                    xPlayer.deleteItem(itemName)
                    xPlayer.updateInventory()
                end
            end
            
        else
            if not VFW.Items[name] then
                MySQL.insert.await("INSERT INTO items (name, label, weight, data, premium, perm) VALUES (@name, @label, @weight, @data, @premium, @perm)", {
                    ["@name"] = name,
                    ["@label"] = item.label or name,
                    ["@weight"] = item.weight or 0,
                    ["@data"] = json.encode(item.data) or {},
                    ["@premium"] = item.premium or 0,
                    ["@perm"] = item.perm or 0
                })
            else
                MySQL.update.await("UPDATE items SET label = @label, weight = @weight, data = @data, premium = @premium, perm = @perm WHERE name = @name", {
                    ["@name"] = name,
                    ["@label"] = item.label or name,
                    ["@weight"] = item.weight or 0,
                    ["@data"] = json.encode(item.data) or {},
                    ["@premium"] = item.premium or 0,
                    ["@perm"] = item.perm or 0
                })
            end
            VFW.Items[name] = item
        end
    end

    TriggerClientEvent("vfw:items:update", -1, items)
end)