Core.RolesList = {}

VFW.Admin = {}

CreateThread(function()
    local result = MySQL.query.await("SELECT * FROM roles")
    for i = 1, #result do
        Core.RolesList[result[i].id] = {
            level = result[i].level,
            permissions = json.decode(result[i].permissions)
        }
    end
end)

function VFW.LoadPlayerRank(roles)
    local permissions = {}
    local role

    for i = 1, #roles do
        roleId = roles[i]

        if Core.RolesList[roleId] then
            if (not role) or (Core.RolesList[role].level > Core.RolesList[roleId].level) then
                role = roleId
            end

            for permission, value in pairs(Core.RolesList[roleId].permissions) do
                permissions[permission] = value
            end
        end
    end

    if not role then
        role = GetConvar('core_member_role', '992111793742807040')
    end

    return role, permissions
end

function VFW.Admin.Alert(title, message)
    -- alert all admins that have staff mode enabled
end

VFW.staffMode = {}
GlobalState["staffCount"] = 0
RegisterNetEvent("vfw:staff:mode", function(state)
    if state then
        table.insert(VFW.staffMode, source)
        TriggerClientEvent("vfw:staff:reports", source, VFW.GetMinifiedReports())
        GlobalState["staffCount"] = GlobalState["staffCount"] + 1
    else
        for i = 1, #VFW.staffMode do
            if VFW.staffMode[i] == source then
                table.remove(VFW.staffMode, i)
                GlobalState["staffCount"] = GlobalState["staffCount"] - 1
                break
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    for i = 1, #VFW.staffMode do
        if VFW.staffMode[i] == source then
            table.remove(VFW.staffMode, i)
            GlobalState["staffCount"] = GlobalState["staffCount"] - 1
            break
        end
    end
end)