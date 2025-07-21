function VFW.CreateBlipAndPoint(name, positions, key, blipSprite, blipColor, blipScale, blipLabel, interactLabel, interactKey, interactIcons, action, colors)
    if blipSprite then
        VFW.CreateBlipInternal(positions, blipSprite, blipColor, blipScale, blipLabel)
    end
    print(interactIcons)
    console.debug("Creating point "..name.." "..key)

    local handler = Worlds.Zone.Create(positions, 2, false, function()
        console.debug("Entering interaction zone "..name.." "..key)
        if action.onEnter then
            action.onEnter()
        end
        if action.onPress then
            VFW.RegisterInteraction(name .. key, action.onPress)
        end
    end, function()
        console.debug("Exiting interaction zone "..name.." "..key)
        VFW.RemoveInteraction(name .. key)
        if action.onExit then
            action.onExit()
        end
    end, interactLabel, interactKey, interactIcons, colors)

    return handler
end