VFW.Jobs.Catalogue.GarageHel = {
    ["lspd"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {}
        },
        Vehicle = {
            servise = {
                {
                    label = 'Maverick',
                    name = 'maverick2',
                }, {
                    label = 'Police JP Heli',
                    name = 'policejpheli',
                }
            },

            Spawn = {
                { x = 467.0315, y = -996.1644, z = 47.7894-1, w = 182.6038}
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Maverick"] = {
                    livery = 1,
                },
                ["AS332"] = {
                    livery = 4,
                }
            }
        },

        Cam = {
            {
                Fov = 50.1,
                Dof = true,
                CamCoords = { x = 476.1877, y = -994.3154, z = 51.9948-3 },
                CamRot = { x = -0.90386396646499, y = -0.0, z = 101.02008056640625 },
                COH = { x = 467.0315, y = -996.1644, z = 47.7894-1, w = 182.6038},
                Freeze = false,
                DofStrength = 0.7
            }
        },

        Point = {
            Ped = {
                { pedModel = "s_m_y_cop_01", coords = { x = 465.2003, y = -975.3123, z = 46.1041-1, w = 178.5025 }, zone = {
                    name = "garage_hel_lspd",
                    interactLabel = "Garage",
                    interactKey = "E",
                    interactIcons = "Vehicule",
                    onPress = function()
                        if VFW.PlayerData.job.onDuty then
                            VFW.Jobs.Catalogue.GarageHel.MenuGarage()
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous devez être en service pour accéder à cette fonctionnalité."
                            })
                        end
                    end
                }, blip = { sprite = 43, color = 29, scale = 0.8, label = "LSPD - Garage Hélicoptère" } },
            },
            Despawn = {
                { coords = { x = 467.0315, y = -996.1644, z = 47.7894 + 0.80 }, zone = {
                    name = "garageDespawn_hel_lspd",
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
                }, blip = { sprite = 43, color = 29, scale = 0.8, label = "LSPD - Rentrer Hélicoptère" } },
            }
        }
    },
    ["lssd"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {}
        },
        Vehicle = {
            servise = {
                {
                    label = 'Volto LSSD',
                    name = 'saspjpheli',
                },
                {
                    label = 'Maverick LSSD',
                    name = 'saspmaverick2',
                },
            },

            Spawn = {
                { x = 1825.25, y = 3685.03, z = 42.87, w = 30.88 },
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Volto LSSD"] = {
                    livery = 4,
                },
                ["Maverick LSSD"] = {
                    livery = 0,
                },
            }
        },

        Cam = {
            {
                Fov = 40.1,
                Dof = true,
                CamCoords = { x = 1822.98828125, y = 3695.282470703125, z = 43.40241241455078 },
                CamRot = { x = -0.9666736125946, y = -0.0, z = -164.47340393066407 },
                COH = { x = 1823.69921875, y = 3687.490234375, z = 43.37338638305664, w = 338.72216796875 },
                Freeze = false,
                DofStrength = 0.7
            }
        },

        Point = {
            Ped = {
                { pedModel = "s_m_y_sheriff_01", coords = { x = 1822.71, y = 3677.66, z = 41.98, w = 296.94 }, zone = {
                    name = "garage_hel_lssd",
                    interactLabel = "Garage",
                    interactKey = "E",
                    interactIcons = "Vehicule",
                    onPress = function()
                        if VFW.PlayerData.job.onDuty then
                            VFW.Jobs.Catalogue.GarageHel.MenuGarage()
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous devez être en service pour accéder à cette fonctionnalité."
                            })
                        end
                    end
                }, blip = { sprite = 50, color = 17, scale = 0.8, label = "LSSD - Garage Hélicoptère" } },
            },
            Despawn = {
                { coords = { x = 1824.16, y = 3686.22, z = 41.98 + 0.80 }, zone = {
                    name = "garageDespawn_hel_lssd",
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
                }, blip = { sprite = 50, color = 17, scale = 0.8, label = "LSSD - Garage Hélicoptère" } },
            }
        }
    },
    ["sams"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {}
        },
        Vehicle = {
            servise = {
                {
                    label = 'Maverick SAMS',
                    name = 'emsmav',
                }, {
                    label = 'Swift SAMS',
                    name = 'emsswift',  
                }
            },

            Spawn = {
                { x = 351.98, y = -588.66, z = 74.16, w = 69.30 },
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Maverick SAMS"] = {
                    livery = 3,
                },
                ["Swift SAMS"] = {
                    livery = 0,
                }
            }
        },

        Cam = {
            {
                Fov = 40.1,
                Dof = true,
                CamCoords = { x = 362.0368347167969, y = -593.1119384765625, z = 74.46080017089844 },
                CamRot = { x = -2.10841965675354, y = -0.0, z = 81.50050354003906 },
                COH = { x = 355.0647888183594, y = -590.6515502929688, z = 74.55223846435547, w = 226.61802673339845 },
                Freeze = false,
                DofStrength = 0.7
            }
        },

        Point = {
            Ped = {
                { pedModel = "s_f_y_scrubs_01", coords = { x = 339.73, y = -580.76, z = 73.16, w = 251.9 }, zone = {
                    name = "garage_hel_sams",
                    interactLabel = "Garage",
                    interactKey = "E",
                    interactIcons = "Vehicule",
                    onPress = function()
                        if VFW.PlayerData.job.onDuty then
                            VFW.Jobs.Catalogue.GarageHel.MenuGarage()
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Vous devez être en service pour accéder à cette fonctionnalité."
                            })
                        end
                    end
                }, blip = { sprite = 50, color = 2, scale = 0.8, label = "SAMS - Garage Hélicoptère" } },
            },
            Despawn = {
                { coords = { x = 351.98, y = -588.66, z = 74.16 + 0.80 }, zone = {
                    name = "garageDespawn_hel_sams",
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
                }, blip = { sprite = 50, color = 2, scale = 0.8, label = "SAMS - Garage Hélicoptère" } },
            }
        }
    },
}
