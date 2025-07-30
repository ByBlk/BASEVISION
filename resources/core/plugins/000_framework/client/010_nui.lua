VFW.Nui = {}

local DisableControlAction <const> = DisableControlAction
local EnableControlAction <const> = EnableControlAction

VFW.Nui.Visible = function(visible)
    SendNUIMessage({
        action = "nui:visible",
        data = visible
    })
end

VFW.Nui.Close = function()
    SendNUIMessage({
        action = "nui:close"
    })
end

VFW.Nui.Focus = function(focus, keep)
    SetNuiFocus(focus, focus)
    SetNuiFocusKeepInput(keep or false)
end

local registered, radialopen = false, false
local REGISTERED_KEYS <const> = { 1, 2, 142, 18, 322, 106, 24, 25, 263, 264, 257, 140, 141, 142, 143 }
local function registerCloseRadial()
    radialopen = true
    CreateThread(function()
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        while radialopen do
            Wait(1)
            for i = 1, #REGISTERED_KEYS do
                DisableControlAction(0, REGISTERED_KEYS[i], true)
            end
        end
    end)
    if registered then
        return
    end
    registered = true
    RegisterNUICallback("nui:radial-menu:close", function()
        console.debug("Close radial menu")
        for i = 1, #REGISTERED_KEYS do
            EnableControlAction(0, REGISTERED_KEYS[i], true)
        end
        radialopen = false
        RadialOpen = false
        VFW.Nui.Radial(nil, false)
        VFW.Nui.Focus(false)
    end)
end

VFW.Nui.Radial = function(data, visible)
    if data then
        SendNUIMessage({
            action = "nui:radial-menu:data",
            data = data
        })
        registerCloseRadial()
    end
    SendNUIMessage({
        action = "nui:radial-menu:visible",
        data = visible
    })
    radialopen = visible
    VFW.Nui.Focus(visible)
    VFW.DisableEscapeMenu(visible)
    -- VFW.Nui.HudVisible(not visible)
end

RegisterNUICallback("nui:radial-menu:callback", function(data)
    local EXEC <const> = _G[data.button]
    if EXEC then
        if not data then return end
        if data.args then
            EXEC(data.args)
        else
            if RadialOpen then
                VFW.Nui.Radial(nil, false)
                RadialOpen = false
            end
            EXEC()
        end
    else
        console.debug("No callback found for radial action " .. (data.name or ""))
    end
end)

---@param name string
---@param data table
---@param visible boolean
VFW.Nui.PropertyHabitation = function(name, visiblename, data, visible)
    SendNUIMessage({
        action = name,
        data = data
    })
    SendNUIMessage({
        action = visiblename,
        data = visible
    })
    VFW.Nui.Focus(visible)
end

---@param target? table
---@param hud? table
VFW.Nui.UpdateInventory = function(target, hud)
    local INV <const> = {} -- trigger ?
    SendNUIMessage({
        action = "nui:inventory:update",
        data = {
            inventory = INV,
            target = target,
            hud = hud
        }
    })
end

VFW.Nui.HudVisible = function(visible, notHideTrade)
    SendNUIMessage({
        action = "nui:hud:visible",
        data = visible,
    })
    if not notHideTrade then
        SendNUIMessage({
            action = "nui:itemTrade:visible",
            data = visible,
        })
    end
    DisplayRadar(visible)
end

VFW.Nui.HudData = function(data)
    if data then
        SendNUIMessage({
            action = "nui:hud:visible:healthArmor",
            data = data
        })
    end
end

VFW.Nui.Tablet = function(visible, data)
    SendNUIMessage({
        action = "nui:illegal-tablet:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:illegal-tablet:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
end

VFW.Nui.Creator = function(visible, data)
    SendNUIMessage({
        action = "nui:char-creator:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:char-creator:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
end

VFW.Nui.SecuroServ = function(data, visible)
    SendNUIMessage({
        action = "nui:securoserv:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:securoserv:data",
            data = data,
        })
    end
end

VFW.Nui.FactionGestion = function(visible, data)
    SendNUIMessage({
        action = "nui:orgaManagement:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:orgaManagement:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.FactionCreation = function(visible, data)
    SendNUIMessage({
        action = "nui:activity-creation:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:activity-creation:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.OpenTutorial = function(text, visible)
    -- TODO : Ajouter le front du tuto-fa
    --
end

VFW.Nui.Multicharacter = function(visible, data)
    SendNUIMessage({
        action = "nui:multichar:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:multichar:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
end

VFW.Nui.EscapeMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:escape-menu:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:escape-menu:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
end

VFW.Nui.animation = function(visible, data)
    SendNUIMessage({
        action = "nui:animation:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:animation:data",
            data = data
        })
    end
    VFW.Nui.Focus(visible, visible)
    VFW.DisableEscapeMenu(visible)
end

VFW.Nui.deathScreen = function(visible, secToWait)
    secToWait = 600
    local playerdata = VFW.PlayerGlobalData
    SendNUIMessage({
        action = "nui:deathscreen:visible",
        data = {
            visible = visible,
            secToWait = secToWait
        }
    })

    SendNUIMessage({
        action = 'nui:deathscreen:data',
        data = {
            timer = secToWait,
            id = playerdata.id
        }
    })

    SetNuiFocus(visible, visible)
end

VFW.Nui.updateDeathScreen = function(data)
    SendNUIMessage({
        action = "nui:deathscreen:update",
        data = data
    })
end

RegisterNUICallback("nui:deathscreen:action", function(data, cb)
    if data.action == "DeathscreenRespawn" and secLeft <= 0 then
        TriggerEvent("nui:deathscreen:hide")
        TriggerServerEvent("deathscreen:respawnPlayer")
    elseif data.action == "DeathscreenCallEmergency" then
        TriggerServerEvent("deathscreen:callEmergency")
    end
    cb("ok")
end)

RegisterNetEvent("nui:deathscreen:hide")
AddEventHandler("nui:deathscreen:hide", function()
    isDead = false
    VFW.Nui.deathScreen(false)
end)

VFW.Nui.NewGrandMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:newgrandmenu:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:newgrandmenu:setData",
            data = data
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
    VFW.DisableEscapeMenu(visible)
end

VFW.Nui.UpdateNewGrandMenu = function(data)
    SendNUIMessage({
        action = "nui:newgrandmenu:setData",
        data = data
    })
end

VFW.Nui.SendNotifToNewGrandMenu = function(data)
    SendNUIMessage({
        action = "nui:newgrandmenu:notify",
        data = data
    })
end

RegisterNetEvent("nui:newgrandmenu:notify", function(type, message, secondText)
    VFW.Nui.SendNotifToNewGrandMenu({
        type = type,
        message = message,
        secondText = secondText
    })
end)

VFW.Nui.BlipsBuilder = function(visible)

    local blips = {}
    for k, v in pairs(VFW.GetBlipGroups()) do
        table.insert(blips, {
            numero = v.sprite,
            nom = v.name,
            taille = v.scale,
            couleur = v.color,
            image = v.sprite,
            positions = v.coords,
        })
    end
    VFW.Nui.HudVisible(not visible)
    SendNUIMessage({
        action = "nui:blips:visible",
        data = visible
    })
    Wait(10)
    SendNUIMessage({
        action = "nui:blips:blips",
        data = blips
    })
    VFW.Nui.Focus(visible)
end

--RegisterCommand("blips", function()
--    VFW.Nui.BlipsBuilder(true)
--end)

VFW.Nui.Laboratory = function(visible, data)
    SendNUIMessage({
        action = "nui:laboratories:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:laboratories:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.TerritoriesMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:territories:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:territories:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.TerritoriesInfluence = function(data)
    SendNUIMessage({
        action = "server-gestion-illegal:setInfluences",
        data = data,
    })
end

VFW.Nui.TerritoriesGestion = function(data)
    SendNUIMessage({
        action = "server-gestion-illegal:setTerritories",
        data = data,
    })
end

local kbd_input = nil

function VFW.Nui.KeyboardInputVisible(visible)
    SendNUIMessage({
        action = "nui:keyboardinput:visible",
        data = visible,
    })
    VFW.Nui.Focus(visible)
end

function VFW.Nui.KeyboardInput(visible, text, defaultValue)
    kbd_input = nil

    VFW.Nui.KeyboardInputVisible(visible)

    if text then
        SendNUIMessage({
            action = "nui:keyboardinput:setData",
            data = {
                title = text,
                defaultValue = defaultValue or "",
            }
        })
    end

    while kbd_input == nil do
        Wait(100)
    end

    if kbd_input == "KBD_CANCEL" then
        return ""
    end

    return kbd_input
end

RegisterNUICallback('nui:keyboardinput:response', function(data, cb)
    if not data.value then
        kbd_input = "KBD_CANCEL"
    else
        kbd_input = data.value
    end

    VFW.Nui.KeyboardInputVisible(false)

    cb('ok')
end)

VFW.Nui.VehiclesMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:vehicleMenu:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:vehicleMenu:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible, visible)
    VFW.Nui.HudVisible(not visible)
    VFW.DisableEscapeMenu(visible)
end

local progressstate = nil
RegisterNUICallback("nui:progress:finish", function(state)
    console.debug(state)
    progressstate = state
end)

VFW.Nui.ProgressBar = function(title, milliseconds)
    VFW.DisableEscapeMenu(true)
    SendNUIMessage({
        action = "nui:progress:start",
        data = {
            milliseconds = milliseconds,
            title = title,
        },
    })
    while progressstate == nil do
        Wait(100)
    end
    VFW.DisableEscapeMenu(false)
    tempProgressstate = progressstate
    progressstate = nil
    return tempProgressstate
end

RegisterCommand("progress", function()
    local test = VFW.Nui.ProgressBar("Chargement en cours...", 5000)
end)

VFW.Nui.FuelMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:menu-ltd:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:menu-ltd:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.ElevatorMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:elevator:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:elevator:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.SafeZoneVisible = function(visible)
    SendNUIMessage({
        action = "nui:safezone:visible",
        data = { visible = visible },
    })
end

VFW.Nui.JobMenu = function(visible, data)
    SendNUIMessage({
        action = "nui:job:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:job:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible)
    VFW.Nui.HudVisible(not visible)
    Worlds.Zone.HideInteract(not visible)
end

VFW.Nui.IdentityCard = function(visible, data)
    SendNUIMessage({
        action = "nui:identity:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:identity:data",
            data = data,
        })
    end
end

VFW.Nui.Invoice = function(visible, data)
    SendNUIMessage({
        action = "nui:invoice:visible",
        data = visible
    })
    if data then
        SendNUIMessage({
            action = "nui:invoice:data",
            data = data
        })
    end
    VFW.Nui.Focus(visible)
end

VFW.Nui.Radio = function(visible, data)
    SendNUIMessage({
        action = "nui:radio:visible",
        data = visible,
    })
    if data then
        SendNUIMessage({
            action = "nui:radio:data",
            data = data,
        })
    end
    VFW.Nui.Focus(visible, visible)
end

VFW.Nui.Craft = function(visible, items, inventory, title)
    SendNUIMessage({
        action = "nui:craft:visible",
        data = visible,
    })
    if visible then
        TriggerScreenblurFadeIn(1000)
        SendNUIMessage({
            action = "nui:craft:data",
            data = {
                craft = items,
                recipePossible = {},
                inventory = inventory,
                title = title,
            }
        })
    else
        TriggerScreenblurFadeOut(1000)
    end
    Worlds.Zone.HideInteract(not visible)
    VFW.Nui.HudVisible(not visible)
    VFW.Nui.Focus(visible)
end

VFW.Nui.CraftUpdateInventory = function(inventory)
    SendNUIMessage({
        action = "nui:craft:updateInventory",
        data = inventory
    })
end

VFW.Nui.Recu = function(visible, data)
    SendNUIMessage({
        action = "nui:recu:visible",
        data = visible
    })
    if data then
        SendNUIMessage({
            action = "nui:recu:data",
            data = data
        })
    end
    VFW.Nui.Focus(visible)
end

RegisterNuiCallback("nui:recu:close", function()
    VFW.Nui.Recu(false)
    VFW.Nui.Focus(false)
end)

VFW.Nui.DMVSchool = function(visible)
    if visible then
        SendNUIMessage({
            action = "nui:autoecole:data",
            data = VFW.DMVSchool.questions
        })
    end

    SendNUIMessage({
        action = "nui:autoecole:visible",
        data = visible
    })

    VFW.Nui.Focus(visible)
end

VFW.Nui.PoliceID = function(visible, data)
    SendNUIMessage({
        action = "nui:PoliceID:visible",
        data = visible
    })
    if data then
        SendNUIMessage({
            action = "nui:PoliceID:data",
            data = data
        })
    end
    VFW.Nui.Focus(visible)
end
