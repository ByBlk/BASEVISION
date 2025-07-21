function StaffMenu.BuildBraquageMenu()
    xmenu.items(StaffMenu.braquage, function()
        addButton("CREATION", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildBraquageCreationMenu()
            end
        }, StaffMenu.braquageCreation)
    end)
end

local braquage = {
    typeValue = { "Barber", "Binco", "Supérette", "Ammunation", "Heliwave", "Tattoo" },
    typeModel = { "barber", "binco", "sup", "ammu", "heliwave", "tattoo" },
    typeIndex = 1,
    ped_model = nil,
    ped_position = nil,
    cops_required = nil,
    levelValue = { "A", "B", "C", "D" },
    xp_reward = nil,
    levelIndex = 1,
    max_reward = nil,
    daily_limit = nil,
    isSud = false,
}

function StaffMenu.BuildBraquageCreationMenu()
    xmenu.items(StaffMenu.braquageCreation, function()
        addList("TYPE", braquage.typeValue, braquage.typeIndex, {}, {
            onChange = function(value)
                braquage.typeIndex = value + 1
                VFW.ShowNotification({
                    type = "info",
                    content = "Type de braquage: " .. braquage.typeValue[braquage.typeIndex],
                })
            end
        })

        addButton("PED", { rightIcon = "chevron" }, {
            onSelected = function()
                local ped = VFW.Nui.KeyboardInput(true, "Model du ped", "")

                if not IsModelAPed(GetHashKey(ped)) then
                    VFW.ShowNotification({
                        type = "error",
                        content = "Ce n'est pas un model de ped valide.",
                    })
                    return
                end

                if ped and ped ~= "" then
                    braquage.ped_model = ped
                    VFW.ShowNotification({
                        type = "info",
                        content = "Model du ped: " .. braquage.ped_model,
                    })
                end
            end
        })

        addButton("POSITION", { rightIcon = "chevron" }, {
            onSelected = function()
                local pos  = GetEntityCoords(VFW.PlayerData.ped)
                local heading = GetEntityHeading(VFW.PlayerData.ped)

                braquage.ped_position = {
                    x = pos.x,
                    y = pos.y,
                    z = pos.z,
                    w = heading
                }

                VFW.ShowNotification({
                    type = "info",
                    content = "Position du ped: mis à jour",
                })
            end
        })

        addCheckbox("EST DANS LE SUD", braquage.isSud, {}, {
            onChange = function(value)
                braquage.isSud = value
                VFW.ShowNotification({
                    type = "info",
                    content = "Est dans le sud: " .. tostring(braquage.isSud),
                })
            end
        })

        addButton("NOMBRE DE POLICIER", { rightIcon = "chevron" }, {
            onSelected = function()
                local cops = VFW.Nui.KeyboardInput(true, "Nombre de policier requis", "")

                if cops and cops ~= "" then
                    braquage.cops_required = tonumber(cops)
                    VFW.ShowNotification({
                        type = "info",
                        content = "Nombre de policier requis: " .. braquage.cops_required,
                    })
                end
            end
        })

        addButton("XP RECOMPENSE", { rightIcon = "chevron" }, {
            onSelected = function()
                local xp = VFW.Nui.KeyboardInput(true, "XP recompense", "")

                if xp and xp ~= "" then
                    braquage.xp_reward = tonumber(xp)
                    VFW.ShowNotification({
                        type = "info",
                        content = "XP recompense: " .. braquage.xp_reward,
                    })
                end
            end
        })

        addList("LEVEL", braquage.levelValue, braquage.levelIndex, {}, {
            onChange = function(value)
                braquage.levelIndex = value + 1
                VFW.ShowNotification({
                    type = "info",
                    content = "Niveau requis: " .. braquage.levelValue[braquage.levelIndex],
                })
            end
        })


        addButton("MONTANT MAX", { rightIcon = "chevron" }, {
            onSelected = function()
                local max = VFW.Nui.KeyboardInput(true, "Montant max", "")

                if max and max ~= "" then
                    braquage.max_reward = tonumber(max)
                    VFW.ShowNotification({
                        type = "info",
                        content = "Montant max: " .. braquage.max_reward,
                    })
                end
            end
        })

        addButton("VALIDER", { rightIcon = "chevron" }, {
            onSelected = function()

                if braquage.ped_model == nil or braquage.ped_position == nil or braquage.cops_required == nil or braquage.max_reward == nil then
                    VFW.ShowNotification({
                        type = "error",
                        content = "Veuillez remplir tous les champs.",
                    })
                    return
                end

                if not IsModelAPed(GetHashKey(braquage.ped_model)) then
                    VFW.ShowNotification({
                        type = "error",
                        content = "Ce n'est pas un model de ped valide.",
                    })
                    return
                end

                if braquage.xp_reward == nil then
                    VFW.ShowNotification({
                        type = "error",
                        content = "Veuillez entrer un montant d'xp valide.",
                    })
                    return
                end


                local data = {
                    heist_type = braquage.typeModel[braquage.typeIndex],
                    heist_label = braquage.typeValue[braquage.typeIndex],
                    ped_model = braquage.ped_model,
                    ped_position = braquage.ped_position,
                    cops_required = braquage.cops_required,
                    crew_level_required = braquage.levelValue[braquage.levelIndex],
                    max_reward = braquage.max_reward,
                    heist_location = braquage.isSud,
                    xp_reward = braquage.xp_reward,
                }
                xmenu.render(false)

                TriggerServerEvent("vfw:heists:add", data)
            end
        })
    end)
end
