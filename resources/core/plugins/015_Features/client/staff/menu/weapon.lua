function StaffMenu.BuildCoponentsWeaponMenu()
    xmenu.items(StaffMenu.weapon, function()
        addSeparator("Composants d'armes")

        local ped = VFW.PlayerData.ped
        local currentWeapon = GetSelectedPedWeapon(ped)

        if currentWeapon and currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
            local weaponData = nil

            for _, weapon in ipairs(Config.Weapons) do
                if currentWeapon == GetHashKey(weapon.name) then
                    weaponData = weapon
                    break
                end
            end

            if weaponData then
                addSeparator(weaponData.label)

                if weaponData.components and #weaponData.components > 0 then
                    for _, component in ipairs(weaponData.components) do
                        addButton(component.label, { rightLabel = "Ajouter" }, {
                            onSelected = function()
                                if HasPedGotWeaponComponent(ped, currentWeapon, component.hash) then
                                    VFW.ShowNotification({
                                        type = 'ROUGE',
                                        content = "Ce composant est déjà équipé."
                                    })
                                else
                                    GiveWeaponComponentToPed(ped, currentWeapon, component.hash)
                                    TriggerServerEvent("vfw:staff:setComponent", component.hash)
                                    VFW.ShowNotification({
                                        type = 'VERT',
                                        content = component.label .. " ajouté avec succès."
                                    })
                                end
                            end
                        })
                    end
                else
                    addButton("Aucun composant disponible", { rightLabel = "N/A" })
                end

                if weaponData.tints then
                    for index, label in pairs(weaponData.tints) do
                        addButton(label, { rightLabel = "Appliquer" }, {
                            onSelected = function()
                                local currentTint = GetPedWeaponTintIndex(ped, currentWeapon)

                                if currentTint == index then
                                    VFW.ShowNotification({
                                        type = 'ROUGE',
                                        content = "Cette teinte est déjà appliquée."
                                    })
                                else
                                    SetPedWeaponTintIndex(ped, currentWeapon, index)
                                    TriggerServerEvent("vfw:staff:setTint", index)
                                    VFW.ShowNotification({
                                        type = 'VERT',
                                        content = label .. " appliquée avec succès."
                                    })
                                end
                            end
                        })
                    end
                end
            else
                addButton("Aucun composant disponible pour cette arme", { rightLabel = "N/A" })
            end
        else
            addButton("Aucune arme équipée", { rightLabel = "N/A" })
        end
    end)
end
