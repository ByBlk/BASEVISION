VFW.Jobs.Catalogue.GarageBoat = {
    ["lspd"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {}
        },
        Vehicle = {
            servise = {
                {
                    label = 'Jet-ski',
                    name = 'lspdseashark',
                }, {
                    label = 'Gawarden 7',
                    name = 'gawarden7',
                }, {
                    label = 'Gawarden 8',
                    name = 'gawarden8',
                },
            },

            Spawn = {
                ["1"]  = { x = -799.92, y = -1502.8, z = -0.64, w = 112.27 },
            }
        },

        VehConfigs = {},

        Cam = {
            Dof = true,
            CamRot = { x = -3.67454767227172, y = -2.1344342826523644e-7, z = -45.3069839477539 },
            CamCoords = { x = -807.054443359375, y = -1508.3485107421876, z = 1.70180976390838 },
            Fov = 45.0,
            COH = { x = -799.9451293945313, y = -1502.8082275390626, z = 0.41961869597435, w = 112.2852554321289 },
            Freeze = true,
            DofStrength = 0.8
        },

        Point = {
            Ped = {
                { pedModel = "s_m_y_cop_01", coords = { x = -806.78, y = -1496.99, z = 0.6, w = 297.95 }, zone = {
                    name = "garage_boat_lspd",
                    interactLabel = "Garage",
                    interactKey = "E",
                    interactIcons = "Vehicule",
                    onPress = function()
                        if VFW.PlayerData.job.onDuty then
                            VFW.Jobs.Catalogue.GarageBoat.MenuGarage()
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous devez être en service pour accéder à cette fonctionnalité."
                            })
                        end
                    end
                }, blip = { sprite = 427, color = 29, scale = 0.8, label = "LSPD - Garage Bateaux"}},
            },
            Despawn = {
                { coords = { x = -799.92, y = -1502.8, z = -0.64 + 0.80 }, zone = {
                    name = "garageDespawn_boat_lspd",
                    interactLabel = "Rentrer",
                    interactKey = "E",
                    interactIcons = "Vehicule",
                    onPress = function()
                        if VFW.PlayerData.job.onDuty then
                            if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                                DeleteEntity(veh)
                            end
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous devez être en service pour accéder à cette fonctionnalité."
                            })
                        end
                    end
                }, blip = { sprite = 427, color = 29, scale = 0.8, label = "LSPD - Rentrer Bateaux"}},
            }
        }
    },
}
