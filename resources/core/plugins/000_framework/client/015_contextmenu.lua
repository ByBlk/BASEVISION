local ENTITY_TYPES_LIST <const> = {
    ['world'] = 0,
    ['ped'] = 1,
    ['vehicle'] = 2,
    ['object'] = 3
}

local lastsEntity
local lastWorldPosition
local suscribedButtonsNumber = 0
local suscribedButtons = {}
local mouseActive = false
function VFW.OpenContextMenu()
    mouseActive = not mouseActive
    
    SendNUIMessage({
        action = "nui:context-menu:visible",
        data = mouseActive,
    })
    SetNuiFocus(mouseActive, mouseActive)
    SetNuiFocusKeepInput(mouseActive)
    if mouseActive then
        SetCursorLocation(0.5, 0.5)
    end

    while mouseActive do
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        Wait(0)
    end
end




RegisterNUICallback("ContextMenuPosition", function(data, cb)
    local SCREEN_X <const>, SCREEN_Y <const> = GetActiveScreenResolution()
    local X <const>, Y <const> = data.x / SCREEN_X, data.y / SCREEN_Y
    local HIT <const>, WORLD_POSITION <const>, NORMAL_DIRECTION <const>, ENTITY <const> = RaycastScreen(vector2(X, Y), 100.0, nil)

    if HIT then
        lastsEntity = ENTITY
        lastWorldPosition = WORLD_POSITION
        local ENTITY_TYPE <const> = GetEntityType(ENTITY)
        local buttonList = {}
        
        local function AddChilds(buttonId)
            local childList = {}

            for id = 1, suscribedButtonsNumber do
                button = suscribedButtons[id]
                if button and (button.submenu == buttonId) and ((button.entitytype and (ENTITY_TYPES_LIST[button.entitytype] == ENTITY_TYPE)) or (ENTITY == button.entity)) 
                        and (button.condition and button.condition(ENTITY)) then
                    table.insert(childList, {
                        id = id,
                        name = button.name,
                        style = button.style,
                        value = (button.value and button.value(ENTITY) or nil)
                    })
                    if button.isSubmenu then
                        childList[#childList].child = AddChilds(id)
                    end
                end
            end

            return childList
        end

        for id = 1, suscribedButtonsNumber do
            button = suscribedButtons[id]
            if button and (not button.submenu) and ((button.entitytype and (ENTITY_TYPES_LIST[button.entitytype] == ENTITY_TYPE)) or (ENTITY == button.entity)) 
                    and (button.condition and button.condition(ENTITY)) then
                table.insert(buttonList, {
                    id = id,
                    name = button.name,
                    style = button.style,
                    value = (button.value and button.value(ENTITY) or nil)
                })
                if button.isSubmenu then
                    buttonList[#buttonList].child = AddChilds(id)
                end
            end
        end

        cb(buttonList)
        return
    end
    
    cb({})
end)

RegisterNUICallback("ContextMenuClose", function(data)
    mouseActive = false
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("ContextMenuButtonClick", function(data)
    if suscribedButtons[data.id].isSubmenu then return end
    suscribedButtons[data.id].callback(lastsEntity, lastWorldPosition)
end)

function VFW.ContextAddSubmenu(entity, name, condition, style, submenu)
    if type(entity) == 'string' then
        assert(entity == 'ped' or entity == 'vehicle' or entity == 'object' or entity == 'world', 'Invalid entity type (ped, vehicle, object)')
    end
    suscribedButtonsNumber += 1

    suscribedButtons[suscribedButtonsNumber] = {
        name = name,
        condition = condition,
        style = style or {},
        submenu = submenu,
        isSubmenu = true
    }
    
    if type(entity) == 'string' then
        suscribedButtons[suscribedButtonsNumber].entitytype = entity
    else
        suscribedButtons[suscribedButtonsNumber].entity = entity
    end

    return suscribedButtonsNumber
end

function VFW.ContextAddButton(entity, name, condition, callback, style, submenu)
    if type(entity) == 'string' then
        assert(entity == 'ped' or entity == 'vehicle' or entity == 'object' or entity == 'world', 'Invalid entity type (ped, vehicle, object)')
    end
    suscribedButtonsNumber += 1

    suscribedButtons[suscribedButtonsNumber] = {
        name = name,
        condition = condition,
        callback = callback,
        style = style or {},
        submenu = submenu
    }
    
    if type(entity) == 'string' then
        suscribedButtons[suscribedButtonsNumber].entitytype = entity
    else
        suscribedButtons[suscribedButtonsNumber].entity = entity
    end

    return suscribedButtonsNumber
end

function VFW.ContextAddInfo(entity, name, condition, value, style, submenu)
    if type(entity) == 'string' then
        assert(entity == 'ped' or entity == 'vehicle' or entity == 'object' or entity == 'world', 'Invalid entity type (ped, vehicle, object)')
    end
    suscribedButtonsNumber += 1

    suscribedButtons[suscribedButtonsNumber] = {
        name = name,
        condition = condition,
        value = value,
        style = style or {},
        submenu = submenu
    }
    
    if type(entity) == 'string' then
        suscribedButtons[suscribedButtonsNumber].entitytype = entity
    else
        suscribedButtons[suscribedButtonsNumber].entity = entity
    end

    return suscribedButtonsNumber
end

function VFW.ContextRemoveButton(buttonId)
    suscribedButtons[buttonId] = nil
end


local command = "openContext"
local key = "LMENU" -- Left Alt
local name = "Open context menu"

local function onPress()
    if mouseActive then return end
    VFW.OpenContextMenu()
end

local function onRelease()
    if not mouseActive then return end
    VFW.OpenContextMenu()
end

RegisterCommand("+vfw_" .. command, onPress, false)
RegisterCommand("-vfw_" .. command, onRelease, false)
RegisterKeyMapping("+vfw_" .. command, name, "keyboard", key)