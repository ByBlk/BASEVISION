VFW.Players = {}
VFW.PlayerGlobal = {}
VFW.PlayerFromId = {}
VFW.Jobs = {}
VFW.Factions = {}
VFW.Items = {}
Core = {}
Core.JobsPlayerCount = {}
Core.FactionsPlayerCount = {}
Core.UsableItemsCallbacks = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}

Core.vehicleTypesByModel = {}

RegisterNetEvent("vfw:onPlayerLoaded", function()
    VFW.Players[source].spawned = true

    local insideProperty = VFW.Players[source].getMeta("insideProperty")
    if insideProperty and insideProperty > 0 then
        local property = VFW.GetProperty(insideProperty)

        if property then
            property.enterProperty(source)
            TriggerClientEvent("vfw:property:forceEnter", source, property.id, property.data.nameProperty)
        else
            VFW.Players[source].setMeta("insideProperty", 0)
            local pos = json.decode(VFW.Players[source].getMeta("lastOutside"))
            SetEntityCoords(GetPlayerPed(source), pos.x, pos.y, pos.z)
        end
    end

    local xPlayer = VFW.GetPlayerFromId(source)
    local playerCrew = VFW.GetCrewByName(xPlayer.getFaction().name)
    if not playerCrew then return end
    playerCrew.startSession(xPlayer.identifier)
end)

local function StartDBSync()
    CreateThread(function()
        local interval <const> = 10 * 60 * 1000
        while true do
            Wait(interval)
            Core.SavePlayers()
        end
    end)
end

local function getTypeInventory(type)
    if type == "weapon" then
        return "weapons"
    elseif type == "objects" or type == "gpb" or type == "ammo" or type == "drugs" or type == "consumable" then
        return "items"
    else
        return type
    end
end

MySQL.ready(function()
    Core.DatabaseConnected = true
    if ConfigItemsBrut then
        for k, v in pairs(ConfigItemsBrut) do
            VFW.Items[k] = { label = v.label, type = getTypeInventory(v.data.type), weight = v.weight, image = "https://cdn.eltrane.cloud/alkiarp/items/"..k..".webp", data = v.data, premium = v.premium, perm = v.perm }
        end
    else
        print("[^1ERROR^7] ConfigItemsBrut is nil - items not loaded")
    end
    VFW.Items["keys"] = { label = "Cl�s", weight = 0.10, type = "keys", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["outfit"] = { label = "Tenue", weight = 0.50, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["hat"] = { label = "Chapeau", weight = 0.25, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["top"] = { label = "Haut", weight = 0.40, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["accessory"] = { label = "Accessoire", weight = 0.25, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["bottom"] = { label = "Pantalon", weight = 0.50, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.Items["shoe"] = { label = "Chaussures", weight = 0.30, type = "clothes", image = "", data = {}, premium = 0, perm = 0 }
    VFW.RefreshJobs()
    VFW.RefreshFactions()
    VFW.InitProperty()
    console.debug("[^2INFO^7] Framework ^3initialized!^7")
    StartDBSync()
    StartPayCheck()
end)

RegisterNetEvent("vfw:ReturnVehicleType", function(Type, Request)
    if Core.ClientCallbacks[Request] then
        Core.ClientCallbacks[Request](Type)
        Core.ClientCallbacks[Request] = nil
    end
end)

RegisterCommand("id", function(source)
    local xPlayer = VFW.GetPlayerFromId(source)
    xPlayer.showNotification({
        type = "JAUNE",
        content = ("Votre ID: ~s %s ~c\nID personnage: ~s %s"):format(VFW.GetPermId(source), xPlayer.id)
    })
end)

GlobalState.playerCount = 0

local version = "0.0.8"

print("[^2CORE^7] : Version : " .. version)
print("[^2CORE^7] : Framework charg� avec succ�s !")



