VFW.Jobs.Catalogue.GarageVeh = {
    ["lspd"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {
                show = true,
                items = {
                    { label = "Service",    id = "servise" },
                    { label = "Division",   id = "division" },
                    { label = "Utilitaire", id = "utilitaire" },
                }
            },
        },
        Vehicle = {
            servise = {
                { label = 'BCPD10', name = 'bcpd10' },
                { label = 'Pol Alamop 2', name = 'polalamop2' },
                { label = 'Police Bike B', name = 'polbikeb' },
                { label = 'Police Bike B2', name = 'polbikeb2' },
                { label = 'Police Buffalo P2', name = 'polbuffalop2' },
                { label = 'Police Carap', name = 'polcarap' },
                { label = 'Police Fugitive P', name = 'polfugitivep' },
                { label = 'Police Gauntlet P', name = 'polgauntletp' },
                { label = 'Police Scout P (État-Major)', name = 'polscoutp' },
                { label = 'Police Stalker P', name = 'polstalkerp' },
                { label = 'Police Stanier P', name = 'polstanierp' },
                { label = 'Police Torence P', name = 'poltorencep' },
                
            },

            division = {
                { label = 'Buf Sx Traf Pol', name = 'bufsxtrafpol' },
                { label = 'Halfback 2', name = 'halfback2' },
                { label = 'Inaugural 2', name = 'inaugural2' },
                { label = 'Nscout Traf Pol', name = 'nscouttrafpol' },
                { label = 'Swat Van R2', name = 'swatvanr2' },
                { label = 'Tru Alamo 3', name = 'trualamo3' },
                { label = 'Tru Alamo 4', name = 'trualamo4' },
                { label = 'Umk Alamo', name = 'umkalamo' },
                { label = 'Swat Insur', name = 'swatinsur' },
            },

            utilitaire = {
                { label = 'Coach 2', name = 'coach2' },
                { label = 'Command', name = 'command' },
                { label = 'Hazard 2', name = 'hazard2' },
                { label = 'Pol Speedo P', name = 'polspeedop' },
                { label = 'Roadrunner 3', name = 'roadrunner3' },
                { label = 'Swat Stoc', name = 'swatstoc' },
                { label = 'USSS Flag', name = 'usssflag' },
                { label = 'USSS SUV2', name = 'ussssuv2' },
            },


            Spawn = {
                Normal = {
                    -- {
                    --     ["1"]  = { x = -1061.66, y = -854.07, z = 4.47, w = 216.77 }, 
                    --     ["2"]  = { x = -1058.28, y = -851.35, z = 4.47, w = 215.81 },
                    -- },
                    {
                        ["1"] = {x = 480.4890, y = -991.3488, z = 30.2871, w = 91.9813},
                        ["2"] = { x = 480.1430, y = -994.5706, z = 30.2871, w = 85.7097},
                    },
                },

                Large = {
                    {
                        ["1"] = vector4(-1059.01, -857.03, 4.02, 218.86),
                    },
                    {
                        ["1"] = vector4(435.55, -1020.35, 27.88, 94.67),
                    }
                }
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Stanier LE"] = {
                    livery = 7,
                    extras = { { 1, 0 }, { 2, 1 } },
                    mods = { { 20, 1 }, { 0, 6 }, { 3, 0 }, { 5, 0 }, { 23, 53 }, { 6, 4 }, { 7, 9 }, { 10, 2 }, { 39, 4 } }
                },
                ["Alamo 20"] = {
                    livery = 7
                },
                ["Scout 16"] = {
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 9, 1 }, { 10, 1 }, { 11, 1 } }
                },
                ["Torrence"] = {
                    livery = 1,
                    extras = { { 4, 1 }, { 5, 1 }, { 6, 1 }, { 8, 1 }, { 10, 1 } }
                },
                ["Fugitive"] = {
                    livery = 4
                },
                ["Alamo 2700"] = {
                    livery = 7,
                    mods = { { 0, 6 }, { 6, 2 }, { 7, 4 }, { 33, 1 } }
                },
                ["Alamo 2700 ST"] = {
                    livery = 7,
                    mods = { { 0, 6 }, { 6, 2 }, { 7, 4 }, { 33, 1 } }
                },
                ["Buffalo 2009"] = {
                    livery = 2
                },
                ["Caracara"] = {
                    livery = 1
                },
                ["Buffalo 2013"] = {
                    livery = 1,
                    extras = { { 10, 1 }, { 11, 1 } }
                },
                ["Buffalo 13 ST"] = {
                    livery = 4
                },
                ["Sandstorm"] = {
                    livery = 8,
                    mods = { { 0, 3 }, { 5, 11 }, { 6, 11 }, { 7, 4 }, { 33, 1 } }
                },
                ["Buffalo STX ST"] = {
                    livery = 0
                },
                ["Aleutian"] = {
                    livery = 1,
                    extras = { { 1, 1 }, { 2, 1 } }
                },
            },
            ["division"] = {
                ["Torence ST"] = {
                    livery = 1
                },
                ["Stanier SWAT"] = {
                    livery = 7,
                    extras = { { 1, 0 }, { 2, 0 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 6, 1 }, { 7, 1 }, { 8, 1 } },
                    mods = { { 20, 1 }, { 23, 53 }, { 0, 6 }, { 3, 0 }, { 5, 0 }, { 6, 4 }, { 7, 9 }, { 10, 2 }, { 39, 4 } }
                },
                ["Gresley UMK"] = {
                    livery = 1
                },
                ["Buffalo STX UMK"] = {
                    livery = 1
                },
                ["Centurion"] = {
                    livery = 3
                },
                ["Alamo 2500 UMK"] = {
                    livery = 1
                },
                ["Scout 20 UMK"] = {
                    livery = 1,
                    extras = { { 1, 0 } }
                },
                ["Scout 20 K9"] = {
                    livery = 3
                },
                ["Alamo 2700 K9"] = {
                    livery = 1,
                    mods = { { 0, 6 }, { 6, 2 }, { 7, 4 }, { 32, 2 } }
                },
                ["Scout 16 UMK"] = {
                    livery = 1
                },
                ["Buffalo 13 UMK"] = {
                    livery = 6
                },
                ["Alamo 2700 UMK"] = {
                    livery = 6,
                    mods = { { 32, 3 } },
                    colours = { 6, 6 }
                },
                ["Sandstorm UMK"] = {
                    livery = 7,
                    extras = { { 2, 0 } },
                    mods = { { 32, 3 } },
                    colours = { 8, 8 }
                },
                ["Buffalo STX TD"] = {
                    livery = 3
                },
                ["Wintergreen TD"] = {
                    livery = 2,
                    extras = { { 1, 1 }, { 5, 1 } }
                },
                ["Trust"] = {
                    livery = 1
                },
            },
            ["utilitaire"] = {
                ["Speedo express"] = {
                    livery = 0
                },
                ["Bus"] = {
                    livery = 1
                },
                ["Parking pigeon"] = {
                    livery = 0
                },
                ["M.O.C"] = {
                    livery = 0
                },
            }
        },

        Cam = {
            Normal = {
                {
                    Dof = true,
                    Fov = 50.1,
                    COH = { x = 428.509765625, y = -1023.614501953125, z = 28.40568733215332, w = 129.51918029785157 },
                    CamCoords = { x = 425.9688720703125, y = -1027.8607177734376, z = 28.55756759643554 },
                    CamRot = { x = -1.06632792949676, y = 2.6680424980440877e-8, z = -15.1616153717041 },
                    DofStrength = 0.9,
                    Invisible = true,
                    Freeze = false
                }
            },

            Large = {
                {
                    Dof = true,
                    Fov = 50.1,
                    COH = { x = 428.5083923339844, y = -1023.6118774414063, z = 28.11827850341797, w = 127.64129638671875 },
                    Freeze = false,
                    CamCoords = { x = 425.87860107421877, y = -1028.8759765625, z = 28.98851013183593 },
                    DofStrength = 0.9,
                    CamRot = { x = -1.91294145584106, y = -2.6680424980440877e-8, z = -12.0333890914917 },
                    Invisible = true
                }
            },
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_m_y_cop_01",
                    coords = {
                        { x = 463.1260, y = -1002.5899, z =  30.2871-1, w = 264.4182 }
                    },
                    zone = {
                        name = "garage_lspd",
                        interactLabel = "Garage",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.GarageVeh.MenuGarage()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 29, scale = 0.8, label = "LSPD - Garage" }
                },
            },
            Despawn = {
                {
                    coords = {
                        { x = 480.0144,   y = -1007.3584, z = 30.2871 },
                    },
                    zone = {
                        name = "garageDespawn_lspd",
                        interactLabel = "Rentrer",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                    local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                                    TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", "job",
                                    VFW.Math.Trim(GetVehicleNumberPlateText(veh)))
                                    DeleteEntity(veh)
                                end
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 29, scale = 0.8, label = "LSPD - Rentrer" }
                },
            }
        }
    },
    ["lssd"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {
                show = true,
                items = {
                    { label = "Service",    id = "servise" },
                }
            }
        },
        Vehicle = {
            servise = {
                {
                    label = 'Félon LSSD',
                    name = 'saspfelon10',
                },
                {
                    label = 'Buffalo STX LSSD',
                    name = 'saspbuffalop',
                },
                {
                    label = 'Buffalo S LSSD',
                    name = 'saspbuffalop2',
                },
                {
                    label = 'Scout LSSD',
                    name = 'saspscoutp',
                },
                {
                    label = 'Torence LSSD',
                    name = 'sasptorencep',
                },
                {
                    label = 'Stanier LSSD',
                    name = 'saspstanierp',
                },
                {
                    label = 'Fugitive LSSD',
                    name = 'saspfugitivep',
                },
                {
                    label = 'CaraCara LSSD',
                    name = 'saspcarap',
                },
                {
                    label = 'Speedo LSSD',
                    name = 'saspspeedop',
                },
                {
                    label = 'Moto LSSD',
                    name = 'saspbretro',
                },
                {
                    label = 'Alamo LSSD',
                    name = 'saspalamop2',
                },
                {
                    label = 'Stalker LSSD',
                    name = 'saspstalkerp',
                },
                {
                    label = 'Bus LSSD',
                    name = 'saspcoach2',
                },
                {
                    label = 'Command LSSD',
                    name = 'saspcommand',
                },
                {
                    label = 'Swat Stoc LSSD',
                    name = 'saspswatstoc',
                },
                {
                    label = 'Swat Insurgent',
                    name = 'swatinsur',
                },
                {
                    label = 'Swat Van',
                    name = 'swatvanr2',
                },
            },

            Spawn = {
                Normal = {
                    {
                        ["1"] = { x = 1845.29, y = 3684.22, z = 33.62, w = 210.37 },
                        ["2"] = { x = 1848.01, y = 3685.74, z = 33.59, w = 211.61 },
                        ["3"] = { x = 1850.51, y = 3687.59, z = 33.59, w = 210.42 },
                        ["4"] = { x = 1853.2, y = 3689.28, z = 33.31, w = 210.09 },
                        ["5"] = { x = 1855.92, y = 3690.57, z = 33.31, w = 209.82 },
                    },
                    {
                        ["1"] = { x = -459.56, y = 7125.63, z = 19.97, w = 18.66 },
                        ["2"] = { x = -464.28, y = 7124.0, z = 19.97, w = 14.7 },
                        ["3"] = { x = -469.0, y = 7122.99, z = 19.97, w = 17.9 },
                    },
                },

                Large = {
                    {
                        ["1"] = vector4(1852.83, 3682.12, 33.06, 303.42),
                    },
                    {
                        ["1"] = vector4(-465.45, 7132.7, 20.69, 106.89),
                    }
                }
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Stanier LE"] = {
                    livery = 2,
                    extras = { { 1, 0 }, { 2, 1 } },
                    mods = { { 20, 1 }, { 0, 6 }, { 1, 1 }, { 3, 0 }, { 5, 0 }, { 6, 4 }, { 7, 9 }, { 10, 2 }, { 39, 4 } }
                },
                ["Scout 2016 Valor"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 7, 1 } }
                },
                ["Alamo 2500 LS"] = {
                    livery = 1
                },
                ["Fugitive"] = {
                    livery = 0
                },
                ["Alamo 2500LS Pushbar"] = {
                    livery = 4
                },
                ["Everon"] = {
                    livery = 4,
                    extras = { { 6, 1 }, { 11, 1 } }
                },
                ["Torrence"] = {
                    livery = 3,
                    extras = { { 4, 1 }, { 6, 1 }, { 8, 1 }, { 9, 1 } }
                },
                ["Landstalker XL"] = {
                    extras = { { 10, 1 } }
                },
                ["Caracara"] = {
                    livery = 2,
                    extras = { { 4, 1 } }
                },
                ["Scout 2020"] = {
                    livery = 1
                },
                ["Alamo 2700"] = {
                    livery = 7,
                    mods = { { 0, 6 }, { 6, 2 }, { 7, 4 }, { 33, 1 } }
                },
                ["Buffalo 2009"] = {
                    livery = 1,
                    extras = { { 11, 1 } }
                },
                ["Gresley Slicktop"] = {
                    livery = 1
                },
                ["Buffalo 2013"] = {
                    livery = 0
                },
                ["Sandstorm"] = {
                    livery = 3,
                    extras = {},
                    mods = {
                        { 0,  3 },
                        { 3,  1 },
                        { 5,  11 },
                        { 6,  11 },
                        { 7,  4 },
                        { 33, 1 }
                    }
                },
                ["Alamo 2700 ST"] = {
                    livery = 2,
                    extras = {},
                    mods = {
                        { 0,  6 },
                        { 1,  3 },
                        { 6,  2 },
                        { 7,  4 },
                        { 33, 1 }
                    }
                },
                ["Sandstorm ST"] = {
                    livery = 3,
                    extras = {},
                    mods = {
                        { 0,  3 },
                        { 3,  1 },
                        { 5,  11 },
                        { 6,  11 },
                        { 7,  4 },
                        { 33, 1 }
                    }
                },
                ["Buffalo 2013 ST"] = {
                    livery = 0
                },
                ["Torrence ST"] = {
                    livery = 2
                },
                ["Stanier ST"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 } }
                },
                ["Stanier LE ST"] = {
                    livery = 2,
                    extras = { { 1, 0 }, { 2, 0 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 6, 1 }, { 7, 1 }, { 8, 1 } },
                    mods = { { 20, 1 }, { 0, 6 }, { 3, 0 }, { 5, 0 }, { 6, 4 }, { 7, 9 }, { 10, 2 }, { 39, 4 } }
                },
                ["Scout 2020 ST"] = {
                    livery = 0,
                    extras = { { 1, 1 } }
                },
                ["Scout 2016 ST"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 }, { 7, 1 } }
                },
                ["STX ST"] = {
                    livery = 1,
                    extras = { { 1, 0 } }
                }
            },
            ["division"] = {
                ["Alamo 2700 K9"] = {
                    livery = 3,
                    extras = {},
                    mods = {
                        { 0,  6 },
                        { 1,  1 },
                        { 6,  2 },
                        { 7,  4 },
                        { 32, 2 }
                    }
                },
                ["Scout 2020 K9"] = {
                    livery = 2
                },
                ["Alamo 2500LS K9"] = {
                    livery = 2
                },
                ["Sandstorm K9"] = {
                    livery = 4,
                    extras = {
                        { 2, 1 }
                    },
                    mods = {
                        { 0,  3 },
                        { 3,  1 },
                        { 5,  11 },
                        { 6,  11 },
                        { 7,  4 },
                        { 32, 2 }
                    }
                },
                ["Buffalo 2013 ST"] = {
                    livery = 0
                },
                ["Alamo 2500 ST"] = {
                    livery = 2
                },
                ["Alamo 2700 ST SRG"] = {
                    livery = 2,
                    extras = {},
                    mods = {
                        { 0,  6 },
                        { 1,  2 },
                        { 6,  2 },
                        { 7,  4 },
                        { 33, 1 }
                    }
                },
                ["Gresley ST"] = {
                    livery = 0
                },
                ["Alamo 2500 UMK"] = {
                    livery = 1
                },
                ["Gresley UMK"] = {
                    livery = 1
                },
                ["STX UMK"] = {
                    livery = 1
                },
                ["Torrence ST"] = {
                    livery = 2
                },
                ["Stanier LE ST"] = {
                    livery = 2,
                    extras = { { 1, 0 }, { 2, 0 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 6, 1 }, { 7, 1 }, { 8, 1 } },
                    mods = { { 20, 1 }, { 0, 6 }, { 3, 0 }, { 5, 0 }, { 6, 4 }, { 7, 9 }, { 10, 2 }, { 39, 4 } }
                },
                ["Alamo 2700 UMK"] = {
                    livery = 6,
                    mods = {
                        { 32, 3 }
                    },
                    colours = {
                        { 6, 6 }
                    }
                },
                ["Sandstorm UMK"] = {
                    livery = 7,
                    extras = {
                        { 2, false }
                    },
                    mods = {
                        { 32, 3 }
                    },
                    colours = {
                        { 6, 6 }
                    }
                },
                ["Scout 2020 UMK"] = {
                    livery = 3
                },
                ["Scout 2016 UMK"] = {
                    livery = 0
                },
                ["Landstalker UMK"] = {
                    livery = 0
                },
                ["Stanier UMK"] = {
                    livery = 0
                },
                ["Greenwood"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 10, 1 }, { 11, 1 }, { 12, 1 } }
                },
                ["Buffalo 13 UMK"] = {
                    livery = 6
                },
                ["Buffalo 09 UMK"] = {
                    livery = 6,
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 10, 1 } }
                },
                ["Fugitive UMK"] = {
                    livery = 0
                },
                ["Caracara UMK"] = {
                    livery = 0
                },
                ["Sultan UMK"] = {
                    livery = 0
                },
                ["Impaler 1993 Vector"] = {
                    livery = 0,
                    extras = { { 5, 1 }, { 7, 1 }, { 9, 1 }, { 10, 1 } }
                },
                ["Roamer"] = {
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 11, 1 } }
                },
                ["Raiden Homelander"] = {
                    livery = 4
                },
                ["Alamo Old"] = {
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 5, 1 }, { 7, 1 }, { 9, 1 }, { 10, 1 }, { 11, 1 }, { 12, 1 } }
                },
                ["Brigham"] = {
                    extras = { { 1, 1 }, { 5, 1 }, { 7, 1 }, { 9, 1 } }
                },
                ["STX VALOR"] = {
                    livery = 2
                },
                ["Wintergreen"] = {
                    livery = 1,
                    extras = { { 1, 1 }, { 5, 1 } }
                },
                ["Torrence Valor"] = {
                    livery = 4,
                    extras = { { 10, 1 } }
                }
            },
            ["utilitaire"] = {
                ["SAR Utility"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 5, 1 } }
                },
                ["Riata SR"] = {
                    livery = 0,
                    extras = { { 1, 1 }, { 2, 1 } }
                },
                ["Enduro"] = {
                    extras = { { 1, 1 }, { 5, 1 }, { 6, 1 }, { 10, 1 }, { 11, 1 } }
                },
                ["Verus"] = {
                    extras = { { 1, 1 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 6, 1 } }
                },
                ["Sadler"] = {
                    extras = { { 1, 1 }, { 12, 1 } }
                },
                ["LSSD Speedo"] = {
                    livery = 3
                }
            }

        },

        Cam = {
            Normal = {
                {
                    Fov = 40.1,
                    Invisible = true,
                    CamCoords = { x = 1867.2088623046876, y = 3688.117431640625, z = 33.63390350341797 },
                    Freeze = false,
                    COH = { x = 1861.9163818359376, y = 3686.718505859375, z = 33.5775146484375, w = 306.8795471191406 },
                    Dof = true,
                    CamRot = { x = -1.05649816989898, y = 2.6680424980440877e-8, z = 106.8117446899414 },
                    DofStrength = 0.8,
                }
            },
            Large = {
                {
                    Dof = true,
                    Fov = 50.1,
                    COH = { x = 1862.0079345703126, y = 3686.79248046875, z = 33.1325798034668, w = 308.92364501953127 },
                    CamCoords = { x = 1867.6485595703126, y = 3688.2236328125, z = 33.75759506225586 },
                    CamRot = { x = 1.05454671382904, y = -0.0, z = 105.36466979980469 },
                    DofStrength = 0.8,
                    Invisible = true,
                    Freeze = false
                }
            },
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_m_y_sheriff_01",
                    coords = {
                        { x = 1841.14, y = 3673.38, z = 33.09, w = 303.8 },
                        { x = -454.47, y = 7122.84, z = 20.74, w = 8.74 }
                    },
                    zone = {
                        name = "garage_lssd",
                        interactLabel = "Garage",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.GarageVeh.MenuGarage()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 17, scale = 0.8, label = "LSSD - Garage" }
                },
            },
            Despawn = {
                {
                    coords = {
                        { x = 1866.44, y = 3695.67, z = 32.99 + 0.80 },
                        { x = -478.61, y = 7120.18, z = 19.98 + 0.80 }
                    },
                    zone = {
                        name = "garageDespawn_lssd",
                        interactLabel = "Rentrer",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                    local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                                    TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", "job",
                                        VFW.Math.Trim(GetVehicleNumberPlateText(veh)))
                                    DeleteEntity(veh)
                                end
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 17, scale = 0.8, label = "LSSD - Garage" }
                },
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
                { label = 'Coroner Utilitaire', name = "coroner" },
                { label = 'EMS Alamo Services', name = "emsalamo" },
                { label = 'EMS Ambulance Nord', name = "emsamb" },
                { label = 'EMS Ambulance Nord 2', name = "emsamb2" },
                { label = 'EMS Ambulance Nord 3', name = "emsamb3" },
                { label = 'EMS BF400', name = "emsbf400" },
                { label = 'EMS Buffalo Banalisé', name = "emsbuff" },
                { label = 'EMS Caracara', name = "emscara" },
                { label = 'EMS CMD Nord', name = "emscmd" },
                { label = 'EMS Fugitive', name = "emsfugitive" },
                { label = 'EMS Riata Sauveteur', name = "emsriata" },
                { label = 'EMS Scout', name = "emsscout" },
                { label = 'EMS Stalker', name = "emsstalker" },
                { label = 'EMS Verus Nord', name = "emsverus" },
            },
            Spawn = {
                Normal = {
                    {
                        ["1"] = { x = 331.76, y = -541.23, z = 27.38, w = 181.31 },
                        ["2"] = { x = 329.37, y = -542.45, z = 27.08, w = 181.18 },
                        ["3"] = { x = 326.76, y = -541.56, z = 27.38, w = 181.56 },
                        ["4"] = { x = 323.66, y = -541.39, z = 27.38, w = 180.0 },
                        ["5"] = { x = 359.52, y = -547.85, z = 28.58, w = 270.19 },
                    },
                    {
                        ["1"] = { x = -565.97, y = 7409.62, z = 11.84, w = 313.75 },
                        ["2"] = { x = -553.13, y = 7405.02, z = 11.78, w = 321.03 },
                        ["3"] = { x = -560.63, y = 7390.86, z = 11.84, w = 320.35 },
                    },
                },

                Large = {
                    {
                        ["1"] = vector4(326.09, -549.09, 27.85, 272.25),
                    },
                    {
                        ["1"] = vector4(-558.33, 7403.12, 12.97, 319.99),
                    }
                }
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Ambulance SAMS"] = {
                    livery = 1
                },
                ["Ambulance TEMS"] = {
                    livery = 5
                },
                ["Ambulance SAMS"] = {
                    livery = 2
                },
                ["Caracara SAMS"] = {
                    livery = 1
                },
                ["Stalker SAMS"] = {
                    livery = 0
                },
                ["Ambulance"] = {
                    livery = 1
                },
                ["Buffalo STX"] = {
                    livery = 1
                }
            }

        },

        Cam = {
            Normal = {
                {
                    Freeze = true,
                    CamCoords = { x = 327.9876403808594, y = -564.16650390625, z = 28.49025726318359 },
                    Dof = true,
                    COH = { x = 323.40679931640627, y = -568.7593994140625, z = 28.2700080871582, w = 338.2376403808594 },
                    Vehicle = -878436710,
                    DofStrength = 0.7,
                    Invisible = true,
                    Gamertags = true,
                    Fov = 31.0,
                    CamRot = { x = -1.17810106277465, y = -5.3360842855454396e-8, z = 137.39434814453126 }
                }
            },

            Large = {
                {
                    Freeze = true,
                    CamCoords = { x = 327.85546875, y = -563.7178344726563, z = 28.7839183807373 },
                    Dof = true,
                    COH = { x = 323.4048767089844, y = -568.76416015625, z = 28.38869094848632, w = 338.23529052734377 },
                    Vehicle = -1306912560,
                    DofStrength = 0.8,
                    Invisible = true,
                    Gamertags = true,
                    Fov = 41.0,
                    CamRot = { x = -0.82377105951309, y = -2.6680424980440877e-8, z = 139.7957763671875 }
                }
            },
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_f_y_scrubs_01",
                    coords = {
                        { x = 337.2411,   y = -574.0707, z = 28.7583-1, w = 70.6454 }
                        --{ x = -557.86, y = 7384.29, z = 11.84, w = 142.68 }
                    },
                    zone = {
                        name = "garage_sams",
                        interactLabel = "Garage",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.GarageVeh.MenuGarage()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 2, scale = 0.8, label = "SAMS - Garage" }
                },
            },
            Despawn = {
                {
                    coords = {
                        { x = 329.26,  y = -557.74, z = 27.75 + 0.80 }
                        --{ x = -558.67, y = 7380.22, z = 11.13 + 0.80 }
                    },
                    zone = {
                        name = "garageDespawn_sams",
                        interactLabel = "Rentrer",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                    local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                                    TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", "job",
                                        VFW.Math.Trim(GetVehicleNumberPlateText(veh)))
                                    DeleteEntity(veh)
                                end
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 2, scale = 0.8, label = "SAMS - Garage" }
                },
            }
        }
    },

    ["doj"] = {
        Nui = {
            defaultCategory = "servise",
            lastCategory = "servise",
            headCategory = {}
        },
        Vehicle = {
            servise = {
                { label = 'Washington', name = "washington" },
                { label = 'Scout Unmarked', name = "LSPDumkscout16" },
            },
            Spawn = {
                Normal = {
                    {
                        ["1"] = vector4(258.16, -377.33, 43.58, 244.95),
                    },
                },

                Large = {
                    {
                        ["1"] = vector4(258.16, -377.33, 43.58, 244.95),
                    },
                }
            }
        },

        VehConfigs = {
            ["servise"] = {
                ["Scout Unmarked"] = {
                    livery = 1
                },
            }
        },

        Cam = {
            Normal = {
                {
                    Invisible = true,
                    DofStrength = 0.8,
                    Freeze = true,
                    COH = { x = 258.9847412109375, y = -377.81201171875, z = 44.12955474853515, w = 247.74871826171876 },
                    Fov = 31.0,
                    CamCoords = { x = 263.5929260253906, y = -382.012939453125, z = 44.28305053710937 },
                    Dof = true,
                    CamRot = { x = -1.79789185523986, y = -5.336084996088175e-8, z = 50.70532989501953 },
                }
            }
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_f_y_scrubs_01",
                    coords = {
                        vector4(246.51, -412.3, 46.93, 31.15)
                    },
                    zone = {
                        name = "garage_doj",
                        interactLabel = "Garage",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.GarageVeh.MenuGarage()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 0, scale = 0.8, label = "DOJ - Garage" }
                },
            },
            Despawn = {
                {
                    coords = {
                        vector3(263.41, -379.27, 43.66 + 0.80)
                    },
                    zone = {
                        name = "garageDespawn_doj",
                        interactLabel = "Rentrer",
                        interactKey = "E",
                        interactIcons = "Vehicule",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                if IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
                                    local veh = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
                                    TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", "job",
                                            VFW.Math.Trim(GetVehicleNumberPlateText(veh)))
                                    DeleteEntity(veh)
                                end
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 50, color = 0, scale = 0.8, label = "DOJ - Garage" }
                },
            }
        }
    },
}
