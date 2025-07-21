Worlds.Interact = {}
Worlds.Interact.Input = {}

local interactions = {}
local pressedInteractions = {}
local isKeyPressed = false

function Worlds.Interact.Remove(name)
    if not interactions[name] then return end
    interactions[name] = nil
    console.debug("Removing interaction "..name)
end

Worlds.Interact.Create = function(name, onPress, condition)
    console.debug("Registering interaction "..name)
    interactions[name] = {
        condition = condition or function() return true end,
        onPress = onPress
    }
end

local disabledInteractions = false
function Worlds.Interact.Disable(state)
    disabledInteractions = state
end

function Worlds.Interact.Get()
    local hash = joaat('vfw_interact') | 0x80000000
    return GetControlInstructionalButton(0, hash, true):sub(3)
end

if VFW.IsInputRegistered and VFW.IsInputRegistered("vfw_interact") then
    VFW.RemoveInput("vfw_interact")
end


local function RegisterInput(command_name, label, input_group, key, on_press, on_release)
    local command = on_release and '+' .. command_name or command_name
    RegisterCommand(command, on_press, false)
    Worlds.Interact.Input[command_name] = GetHashKey(command)
    if on_release then
        RegisterCommand('-' .. command_name, on_release, false)
    end
    RegisterKeyMapping(command, label or '', input_group or 'keyboard', key or '')
end

RegisterInput("vfw_interact", "Interactions", "keyboard", "e", function()
    if not isKeyPressed then
        isKeyPressed = true
        for _, interaction in pairs(interactions) do
            local success, result = pcall(interaction.condition)
            if success and result and (not disabledInteractions) then
                console.debug("Interaction pressed ".._)
                pressedInteractions[#pressedInteractions+1] = interaction
                interaction.onPress()
            end
        end
    end
end)

RegisterInput("interact_release", "Interactions", "keyboard", "e", function()
    isKeyPressed = false
end)