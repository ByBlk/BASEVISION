local interactions = {}
local pressedInteractions = {}
local isKeyPressed = false

function VFW.RemoveInteraction(name)
    if not interactions[name] then return end
    interactions[name] = nil
    console.debug("Removing interaction "..name)
end

VFW.RegisterInteraction = function(name, onPress, condition)
    console.debug("Registering interaction "..name)
    interactions[name] = {
        condition = condition or function() return true end,
        onPress = onPress
    }
end

local disabledInteractions = false
function VFW.DisableInterations(state)
    disabledInteractions = state
end

function VFW.GetInteractKey()
    local hash = joaat('vfw_interact') | 0x80000000
    return GetControlInstructionalButton(0, hash, true):sub(3)
end

if VFW.IsInputRegistered and VFW.IsInputRegistered("vfw_interact") then
    VFW.RemoveInput("vfw_interact")
end

VFW.RegisterInput("vfw_interact", "Interactions", "keyboard", "e", function()
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

VFW.RegisterInput("vfw_interact_release", "Interactions", "keyboard", "e", function()
    isKeyPressed = false
end)