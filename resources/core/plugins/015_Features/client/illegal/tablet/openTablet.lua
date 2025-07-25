local receivedLastinfo = false

local info = {
    totalSpent = 0,
    totalCommands = 0,
    mostOrdered = ''
}

local store = {
    name = "",
    drogues = {},
    armes = {}
}
local crewLevel, crewXp = 1, 0

local function addWeaponOnStore(weapon, k)
    local v = weapon
    if v.status == "active" and tonumber(v.level) <= tonumber(crewLevel) then
        table.insert(store.armes, {
            id = k,
            price = tonumber(v.price),
            name = v.name,
            image = "https://cdn.eltrane.cloud/3838384859/items/" ..v.name.. ".webp",
            stock = tonumber(v.stock) or 999,
            type = "weapons",
            spawnName = v.name,
            level = tonumber(v.level) or 0
        })
    end
end

local function addDrugsOnStore(drugs, k)
    local v = drugs
    if v.status == "active" and tonumber(v.level) <= crewLevel then
        table.insert(store.drogues, {
            id = k,
            price = tonumber(v.price),
            name = v.name,
            image = "https://cdn.eltrane.cloud/3838384859/items/" ..v.name.. ".webp",
            stock = tonumber(v.stock) or 999,
            type = "utils",
            spawnName = v.name,
            level = tonumber(v.level) or 0
        })
    end
end

local defaultVar = {
    {
        itemType = "matierePremiere",
        img = "",
        crewRang = "c",
        status = "active",
        rang = "A",
        matierePremiere = true,
        level = 0,
        cooldown = 24,
        name = "bread",
        stock = 20,
        crewType = "gang",
        armes = false,
        price = 20
    },
    {
        itemType = "weapons",
        img = "",
        crewRang = "c",
        status = "active",
        rang = "A",
        matierePremiere = false,
        level = 0,
        cooldown = 24,
        name = "weapon_pistol",
        stock = 20,
        crewType = "gang",
        armes = true,
        price = 200
    }
}
function createStore(typeCrew, variable)
    store.name = typeCrew
    store.drogues = {}
    store.armes = {}
    for k, v in pairs(variable) do
        if v.itemType == "matierePremiere" then
            addDrugsOnStore(v, k)
        else
            addWeaponOnStore(v, k)
        end
    end
end

local crewName = ''
local crewDesc = ''
local crewInitials = 'FG'
local crewColor = "#FF0000"
local crewMotto = 'Flimar aime les hommes !'

local orders = {}

local hourlyVariable

local orderItems = {}

local function getCrewInfo()
    if not VFW.PlayerData or not VFW.PlayerData.faction or not VFW.PlayerData.faction.name then
        console.debug("Error: VFW.PlayerData.faction is nil in getCrewInfo")
        return false
    end

    crewName = VFW.PlayerData.faction.name
    crewInitials = string.sub(VFW.PlayerData.faction.name, 1, 1)
    hourlyVariable = VFW.Variables.GetVariable("hourly")
    local crewCommandsInfo = TriggerServerCallback("core:crew:getCrewOrders")
    info.totalCommands = #crewCommandsInfo
    for k, v in pairs(crewCommandsInfo) do
        info.totalSpent = info.totalSpent + v.total
        orders[k] = {
            date = v.date,
            price = v.total,
            items = {}
        }
        for i = 1, #v.order do
            local currentItem = v.order[i]
            if not orderItems[currentItem.name] then
                orderItems[currentItem.name] = {
                    total = 0
                }
            else
                orderItems[currentItem.name].total = orderItems[currentItem.name].total + currentItem.quantity
            end

            table.insert(orders[k].items, {
                name = currentItem.name,
                quantity = currentItem.quantity,
            })
        end
    end

    local mostOrderedItem = nil
    local mostOrderedQuantity = 0
    for k, v in pairs(orderItems) do
        if v.total > mostOrderedQuantity then
            mostOrderedItem = k
            mostOrderedQuantity = v.total
        end
    end

    info.mostOrdered = mostOrderedItem

    return true
end

RegisterNUICallback("nui:illegal-tablet:close", function()
    ExecuteCommand("e c")
    VFW.Nui.Tablet(false)

    VFW.Nui.HudVisible(true)
    TriggerScreenblurFadeOut(0)
end)

local function checkCooldowns()
    local result = TriggerServerCallback("core:tablet:getCooldowns")
    for k,v in pairs(store) do
        if type(v) == "table" then
            for i,j in pairs(v) do
                for l,m in pairs(result or {}) do
                    if j.spawnName == l then
                        j.cooldown = m.cooldown
                    end
                end
            end
        end
    end
end

function OpenIllegalTablet()
    if not VFW.PlayerData or not VFW.PlayerData.faction or not VFW.PlayerData.faction.name then
        console.debug("Error: VFW.PlayerData.faction is nil in OpenIllegalTablet")
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Erreur: Données de faction non disponibles."
        })
        return
    end

    local crew = VFW.PlayerData.faction.name
    if crew == "nocrew" then return end
    local crewData = TriggerServerCallback("core:crew:getCrewDataByName", crew)
    if crewData.type == "normal" then return end
    local crewVariable = VFW.Variables.GetVariable(crewData.type)


    VFW.Nui.Radial(nil, false)
    --crewLevel = Config.EnableDebug and 5 or TriggerServerCallback("core:crew:getCrewLevelByName", crew)
    --crewXp = Config.EnableDebug and 5000 or TriggerServerCallback("core:crew:getCrewXpByName", crew)
    crewLevel = crewData.level
    crewXp = crewData.xp
    crewColor = crewData.color or "#FF0000"
    crewDesc = crewData.devise or "Aucune devise"
    crewMotto = crewData.devise or "Aucune devise"
    createStore(crewData.type, crewData.itemsMarket)
    checkCooldowns()
    if not VFW.Items then
        console.debug("Error: VFW.Items is not loaded")
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Erreur: Base de données des items non chargée."
        })
        return
    end

    local canOpen = VFW.GetMyCrewPermission("orders")
    if canOpen then

        VFW.Nui.HudVisible(false)
          TriggerScreenblurFadeIn(0)
          VFW.Nui.Radial(nil, false)
          local crewInfoSuccess = getCrewInfo()
          if not crewInfoSuccess then
              VFW.Nui.HudVisible(true)
              TriggerScreenblurFadeOut(0)
              VFW.ShowNotification({
                  type = 'ROUGE',
                  content = "Erreur lors du chargement des informations de faction."
              })
              return
          end
          ExecuteCommand("e tablet2")
          console.debug("Open tablet")
          VFW.Nui.Tablet(true, {
              crewName = crewName,
              crewDesc = crewDesc,
              crewInitials = crewInitials,
              crewColor = crewColor,
              crewMotto = crewMotto,
              informations = info,
              crewXp = crewXp,
              crewLevel = crewLevel,
              orders = orders,
              shop = store,
              hourStart = tonumber(hourlyVariable.hourStart),
              minStart = tonumber(hourlyVariable.minStart),
              hourStop = tonumber(hourlyVariable.hourStop),
              minStop = tonumber(hourlyVariable.minStop)
          });
    else
        VFW.Nui.HudVisible(true)
        print("Vous n'avez pas la permission d'ouvrir la tablette.")

        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas la permission d'ouvrir la tablette."
        })
    end
end



RegisterNetEvent("core:tablet:open", function()
    VFW.CloseInventory()
    OpenIllegalTablet()
end)

RegisterCommand("openTablet", function()
    if Config.EnableDebug then
        TriggerEvent("core:tablet:open")
    end
end)

RegisterNetEvent('core:tablet:saveCommandReturn', function(value, order, total, typeObject)
    VFW.Nui.Tablet(false)
    if value == true then
        console.debug(math.tointeger(total))
        --console.debug(p:getCrew(), math.floor(math.tointeger(total)/100*2))
        TriggerServerEvent("core:crew:updateXp", math.floor(tonumber(total) / 100 * 2), "add", "tablet")

    else
        VFW.Nui.Tablet(true, {
            crewName = crewName,
            crewDesc = crewDesc,
            crewInitials = crewInitials,
            crewColor = crewColor,
            crewMotto = crewMotto,
            informations = info,
            crewLevel = crewLevel,
            orders = orders,
            shop = store,
            hourStart = tonumber(hourlyVariable.hourStart),
            minStart = tonumber(hourlyVariable.minStart),
            hourStop = tonumber(hourlyVariable.hourStop),
            minStop = tonumber(hourlyVariable.minStop),
            errorMessage = value,
            force = "Shop"
        });
    end
end)

RegisterNUICallback("nui:illegal-tablet", function(data)
    -- Vérifier que VFW.PlayerData.faction existe
    if not VFW.PlayerData or not VFW.PlayerData.faction or not VFW.PlayerData.faction.name then
        console.debug("Error: VFW.PlayerData.faction is nil in nui:illegal-tablet callback")
        ExecuteCommand("e c")
        VFW.Nui.Tablet(false)
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Erreur: Données de faction non disponibles."
        })
        return
    end

    local paid = TriggerServerCallback("core:tablet:saveCommand", data, VFW.PlayerData.faction.name )
    if (not paid) then
        ExecuteCommand("e c")
        VFW.Nui.Tablet(false)
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas assez d'argent pour effectuer cette commande."
        })
    end
end)


-- RegisterCommand("xpCrew", function(_, args)
--     if p:getCrew() == nil or p:getCrew() == "None" then return end
--     local xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", p:getCrew())
--     local xpCrewLevel = TriggerServerCallback("core:crew:getCrewLevelByName",  p:getCrew())
--     console.debug("xpCrew: " .. xpCrew .. ", crew level: " .. xpCrewLevel)
-- end)

-- RegisterCommand("getXpLevelGlobal", function(_, args)
--         local xpCrewLevel = TriggerServerCallback("core:crew:getGlobalXp")
--         console.debug(json.encode(xpCrewLevel, {indent=true}))
-- end)