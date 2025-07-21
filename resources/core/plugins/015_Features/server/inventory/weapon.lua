RegisterNetEvent("vfw:weapon:used", function(weapon)
    local weaponInfo = VFW.GetWeaponFromHash(weapon)

    if weaponInfo.throwable then
        local itemName = weaponInfo.name:lower()
        local xPlayer = VFW.GetPlayerFromId(source)

        xPlayer.removeItemBP(itemName, 1)
        xPlayer.updateInventory()
    else
        --@todo: durability
    end
end)