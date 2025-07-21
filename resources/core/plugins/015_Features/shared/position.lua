--while not VFW.Ammu do
--    Wait(1000)
--end

Config.Features = {
    Dynasty = {
        pos = vec3(-700.78, 269.04, 82.15)
    },
    Binco = {
        {
            Title = "BINCO",
            Pos = {
                vector4(9.3566675186157, 6513.3623046875, 31.175296783447 + 1.0, 43.09),
                vector4(1192.5355224609, 2712.8466796875, 37.520057678223 + 1.0, 179.34),
                vector4(1695.4506835938, 4827.203125, 41.360538482666 + 1.0, 100.52),
                vector4(-827.47521972656, -1073.2615966797, 10.625560760498 + 1.0, 208.37),
                vector4(427.23721313477, -802.21069335938, 28.788589477539 + 1.0, 91.55),
                vector4(72.824851989746, -1396.9686279297, 28.673580169678 + 1.0, 278.36),
                vector4(-333.2, 7209.87, 5.8 + 1.0, 5.08),
                vector4(1780.95, 3641.22, 34.19 + 1.0, 145.43)
            },
            Cam = {
                { -- MENU
                    Fov = 50.1,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    Freeze = true,
                    COH = {x = -825.3751831054688, y = -1074.766845703125, z = 11.6255521774292, w = 227.33267211914063},
                    CamRot = {x = -1.05770254135131, y = -0.0, z = 51.78014373779297},
                    Dof = true,
                    OffsetLook = {x = 0.39293873310089, y = -3.99436092376709, z = 0.4042272567749},
                    OffsetPlayer = {x = 0.0052872300148, y = 0.98975151777267, z = 0.49652385711669},
                    DofStrength = 1.0,
                },
                { -- HAUT
                    Fov = 40.1,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    Freeze = true,
                    COH = {x = -825.4904174804688, y = -1074.7392578125, z = 11.62556648254394, w = 236.37974548339845},
                    CamRot = {x = -1.06203091144561, y = -2.6680424980440877e-8, z = 67.81495666503906},
                    Dof = true,
                    OffsetLook = {x = 0.70129871368408, y = -3.25081658363342, z = 0.2615737915039},
                    OffsetPlayer = {x = -0.2897977232933, y = 1.64908421039581, z = 0.354248046875},
                    DofStrength = 1.0,
                },
                { -- BAS
                    Fov = 50.1,
                    Animation = {dict = "anim@mp_corona_idles@female_b@idle_a", anim = "idle_a"},
                    Invisible = false,
                    Freeze = true,
                    COH = {x = -825.6673583984375, y = -1074.376953125, z = 11.62556648254394, w = 207.00218200683595},
                    CamRot = {x = 0.01268535107374, y = -0.0, z = 65.92857360839844},
                    Dof = true,
                    OffsetLook = {x = 2.38864064216613, y = -2.62943887710571, z = -0.59259128570556},
                    OffsetPlayer = {x = -0.75294041633605, y = 1.26037573814392, z = -0.59369850158691},
                    DofStrength = 1.0,
                },
                { -- LUNETTE & CHAPEAU
                    Fov = 50.1,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    Invisible = false,
                    Freeze = true,
                    COH = {x = -825.6544189453125, y = -1074.4072265625, z = 11.62556648254394, w = 227.9362335205078},
                    CamRot = {x = -2.57776808738708, y = -0.0, z = 64.9322738647461},
                    Dof = true,
                    OffsetLook = {x = 1.2377164363861, y = -3.85811686515808, z = 0.36722660064697},
                    OffsetPlayer = {x = -0.2223242521286, y = 0.91870462894439, z = 0.59210300445556},
                    DofStrength = 1.0,
                },
                { -- CHAUSSURE
                    Fov = 40.1,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    Invisible = false,
                    Freeze = true,
                    COH = {x = -825.4957885742188, y = -1074.583984375, z = 11.62561702728271, w = 214.96072387695313},
                    CamRot = {x = 2.20075440406799, y = 5.336084996088175e-8, z = -26.33539581298828},
                    Dof = true,
                    OffsetLook = {x = -3.59793996810913, y = -2.01464939117431, z = -0.71857261657714},
                    OffsetPlayer = {x = 0.78441023826599, y = 0.38501358032226, z = -0.91057777404785},
                    DofStrength = 1.0,
                },
                { -- PRET A PORTET
                    OffsetPlayer = {x = 0.01346480846405, y = 1.99262654781341, z = 0.18364143371582},
                    Dof = true,
                    Freeze = true,
                    DofStrength = 1.0,
                    COH = {x = -825.4904174804688, y = -1074.7392578125, z = 11.63069915771484, w = 236.37974548339845},
                    CamRot = {x = -6.85216236114501, y = -0.0, z = 55.5584487915039},
                    Fov = 60.1,
                    OffsetLook = {x = -0.05768823623657, y = -2.9711365699768, z = -0.41289806365966},
                    Animation = {anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a"}
                },
           }
        }
    },
    Ponsobys = {
        {
            Title = "PONSOBYS",
            Pos = {
                vector4(-1449.7152099609, -236.90982055664, 48.810829162598 + 1.0, 146.19),
                vector4(-710.27197265625, -152.66871643066, 36.415199279785 + 1.0, 211.63),
                vector4(-163.90074157715, -303.93368530273, 38.73335647583 + 1.0, 340.45),
            },
            Cam = {
                { -- MENU
                    OffsetLook = {x = 1.25885665416717, y = -3.64309549331665, z = 0.39255905151367},
                    COH = {x = -1449.7838134765626, y = -236.97662353515626, z = 49.81081390380859, w = 117.64564514160156},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.24440202116966, y = 1.12350487709045, z = 0.53340148925781},
                    CamRot = {x = -1.61414635181427, y = 5.336084996088175e-8, z = -44.85033798217773},
                },
                { -- HAUT
                    OffsetLook = {x = 0.83707022666931, y = -3.18942713737487, z = 0.22953414916992},
                    COH = {x = -1449.46240234375, y = -236.65231323242188, z = 49.81082534790039, w = 140.7312469482422},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@female_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.35409474372863, y = 1.66603410243988, z = 0.30511474609375},
                    CamRot = {x = -0.86613845825195, y = 2.6680424980440877e-8, z = -25.48456954956054},
                },
                { -- BAS
                    OffsetLook = {x = 1.43726849555969, y = -2.92743110656738, z = -0.5703125},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@female_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.62950789928436, y = 1.62538123130798, z = -0.54969787597656},
                    CamRot = {x = -0.23623064160346, y = 6.670106245110219e-9, z = -14.69839000701904},
                },
                { -- LUNETTE & CHAPEAU
                    OffsetLook = {x = 1.74889063835144, y = -3.65122985839843, z = 0.62282562255859},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.3428937792778, y = 0.89015740156173, z = 0.60908508300781},
                    CamRot = {x = 0.15746854245662, y = -0.0, z = -14.3837661743164},
                },
                { -- CHAUSSURE
                    OffsetLook = {x = -3.13594341278076, y = -2.44359254837036, z = -0.86665344238281},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = 0.85854911804199, y = 0.56365132331848, z = -0.87009048461914},
                    CamRot = {x = 0.03939429298043, y = 1.0422042395763498e-10, z = -92.1405258178711},
                },
                { -- PRET A PORTET
                    OffsetPlayer = {x = 0.01346480846405, y = 1.99262654781341, z = 0.18364143371582},
                    Dof = true,
                    Freeze = true,
                    DofStrength = 1.0,
                    COH = {x = -825.4904174804688, y = -1074.7392578125, z = 11.63069915771484, w = 236.37974548339845},
                    CamRot = {x = -6.85216236114501, y = -0.0, z = 55.5584487915039},
                    Fov = 60.1,
                    OffsetLook = {x = -0.05768823623657, y = -2.9711365699768, z = -0.41289806365966},
                    Animation = {anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a"}
                },
            }
        }
    },
    Suburban = {
        {
            Title = "SUBURBAN",
            Pos = {
                vector4(614.87774658203, 2763.5773925781, 41.090072631836 + 1.0, 188.21),
                vector4(-3171.6140136719, 1043.1887207031, 19.863344192505 + 1.0, 334.91),
                vector4(-1192.7514648438, -768.39971923828, 16.31972694397 + 1.0, 134.62),
                vector4(125.54372406006, -224.21081542969, 53.557678222656 + 1.0, 337.62),
            },
            Cam = {
                { -- MENU
                    OffsetLook = {x = 1.25885665416717, y = -3.64309549331665, z = 0.39255905151367},
                    COH = {x = -1449.7838134765626, y = -236.97662353515626, z = 49.81081390380859, w = 117.64564514160156},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.24440202116966, y = 1.12350487709045, z = 0.53340148925781},
                    CamRot = {x = -1.61414635181427, y = 5.336084996088175e-8, z = -44.85033798217773}
                },
                { -- HAUT
                    OffsetLook = {x = 0.83707022666931, y = -3.18942713737487, z = 0.22953414916992},
                    COH = {x = -1449.46240234375, y = -236.65231323242188, z = 49.81082534790039, w = 140.7312469482422},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@female_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.35409474372863, y = 1.66603410243988, z = 0.30511474609375},
                    CamRot = {x = -0.86613845825195, y = 2.6680424980440877e-8, z = -25.48456954956054}
                },
                { -- BAS
                    OffsetLook = {x = 1.43726849555969, y = -2.92743110656738, z = -0.5703125},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@female_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.62950789928436, y = 1.62538123130798, z = -0.54969787597656},
                    CamRot = {x = -0.23623064160346, y = 6.670106245110219e-9, z = -14.69839000701904}
                },
                { -- LUNETTE & CHAPEAU
                    OffsetLook = {x = 1.74889063835144, y = -3.65122985839843, z = 0.62282562255859},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = -0.3428937792778, y = 0.89015740156173, z = 0.60908508300781},
                    CamRot = {x = 0.15746854245662, y = -0.0, z = -14.3837661743164}
                },
                { -- CHAUSSURE
                    OffsetLook = {x = -3.13594341278076, y = -2.44359254837036, z = -0.86665344238281},
                    COH = {x = -1449.4600830078126, y = -236.6514129638672, z = 49.81082534790039, w = 140.88528442382813},
                    Fov = 40.1,
                    Dof = true,
                    Freeze = true,
                    Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                    DofStrength = 1.0,
                    OffsetPlayer = {x = 0.85854911804199, y = 0.56365132331848, z = -0.87009048461914},
                    CamRot = {x = 0.03939429298043, y = 1.0422042395763498e-10, z = -92.1405258178711}
                },
                { -- PRET A PORTET
                    OffsetPlayer = {x = 0.01346480846405, y = 1.99262654781341, z = 0.18364143371582},
                    Dof = true,
                    Freeze = true,
                    DofStrength = 1.0,
                    COH = {x = -825.4904174804688, y = -1074.7392578125, z = 11.63069915771484, w = 236.37974548339845},
                    CamRot = {x = -6.85216236114501, y = -0.0, z = 55.5584487915039},
                    Fov = 60.1,
                    OffsetLook = {x = -0.05768823623657, y = -2.9711365699768, z = -0.41289806365966},
                    Animation = {anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a"}
                },
            }
        }
    },
    Masque = {
        {
            {
                CamEffects = "Aucun",
                Gamertags = true,
                CamRot = { x = -2.08265137672424, y = -1.6675265612775548e-9, z = -0.40482893586158 },
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.1,
                Animation = { dict = "anim@mp_corona_idles@female_b@idle_a", anim = "idle_a" },
                CamCoords = { x = -1216.422119140625, y = -1434.2913818359376, z = 5.01528358459472 },
                Fov = 45.0,
                DofStrength = 1.0,
                COH = { x = -1216.41064453125, y = -1433.58447265625, z = 4.37388658523559, w = 149.61122131347657 }, Transition = 1000
            },
            {
                CamEffects = "HAND_SHAKE",
                Gamertags = true,
                CamRot = { x = -2.23340964317321, y = -0.07023026049137, z = 25.86861419677734 },
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = { dict = "anim@mp_corona_idles@female_b@idle_a", anim = "idle_a" },
                CamCoords = { x = -1216.1837158203126, y = -1434.236328125, z = 5.00330400466918 },
                Fov = 45.0,
                DofStrength = 1.0,
                COH = { x = -1216.41064453125, y = -1433.58447265625, z = 4.37661933898925, w = 149.61122131347657 }, Transition = 1000
            },
            {
                CamEffects = "HAND_SHAKE",
                Gamertags = true,
                CamRot = { x = -5.75284671783447, y = -0.11086299270391, z = 12.26088714599609 },
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = { dict = "anim@mp_corona_idles@female_b@idle_a", anim = "idle_a" },
                CamCoords = { x = -1216.2255859375, y = -1435.0673828125, z = 4.82452487945556 },
                Fov = 45.0,
                DofStrength = 1.0,
                COH = { x = -1216.41064453125, y = -1433.58447265625, z = 4.37661933898925, w = 149.61122131347657 }, Transition = 1000
            }
        }
    },
    Boatdealer = {
        Position = {
            vector3(-796.87, -1362.83, 9.0),
            vector3(-805.45, -1366.23, 9.0),
            vector3(-812.77, -1360.13, 9.0),
            vector3(-810.92, -1350.82, 9.0),
            vector3(-802.07, -1347.77, 9.0),
            vector3(-795.45, -1352.28, 9.0),
        }
    },
    Boatdealer = {
        Position = {
            vector3(-796.87, -1362.83, 9.0),
            vector3(-805.45, -1366.23, 9.0),
            vector3(-812.77, -1360.13, 9.0),
            vector3(-810.92, -1350.82, 9.0),
            vector3(-802.07, -1347.77, 9.0),
            vector3(-795.45, -1352.28, 9.0),
        }
    },
    Barber = {
        Pos = {
            vector3(-814.3, -183.8, 36.6),
            vector3(136.8, -1708.4, 28.3),
            vector3(-1282.6, -1116.8, 6.0),
            vector3(1931.5, 3729.7, 31.8),
            vector3(1212.8, -472.9, 65.2),
            vector3(-32.9, -152.3, 56.1),
            vector3(-278.1, 6228.5, 30.7)
        },
        Cam = {
            {
                Freeze = true,
                Fov = 40.1,
                COH = {x = 140.13185119628907, y = -1707.2742919921876, z = 29.49160957336425, w = 228.21365356445313},
                Invisible = false,
                OffsetPlayer = {x = 0.37426489591598, y = 0.9421340227127, z = 0.33111757040023},
                Dof = true,
                CamRot = {x = 0.1194382160902, y = -3.3350531225551096e-9, z = 28.45210838317871},
                DofStrength = 1.0,
                OffsetLook = {x = -1.31630218029022, y = -3.76342630386352, z = 0.34154152870178}
            },
            {
                Freeze = true,
                Fov = 40.1,
                COH = {x = 140.13185119628907, y = -1707.2742919921876, z = 29.49160957336425, w = 228.21365356445313},
                Invisible = false,
                OffsetPlayer = {x = 0.03935396671295, y = 0.89683377742767, z = 0.33128550648689},
                Dof = true,
                CamRot = {x = 0.70998924970626, y = 2.6680424980440877e-8, z = 48.5701675415039},
                DofStrength = 1.0,
                OffsetLook = {x = 0.07049010694026, y = -4.1026701927185, z = 0.3932417333126}
            },
            {
                Freeze = true,
                Fov = 40.1,
                COH = {x = 140.13185119628907, y = -1707.2742919921876, z = 29.49160957336425, w = 228.21365356445313},
                Invisible = false,
                OffsetPlayer = {x = 0.38583824038505, y = -0.78585177659988, z = 0.29384982585906},
                Dof = true,
                CamRot = {x = 0.31628832221031, y = -0.0, z = -105.3663558959961},
                DofStrength = 1.0,
                OffsetLook = {x = -1.83885133266448, y = 3.6918773651123, z = 0.32145178318023}
            },
            {
                Freeze = true,
                Fov = 50.1,
                COH = {x = 140.13185119628907, y = -1707.2742919921876, z = 29.49160957336425, w = 228.21365356445313},
                Invisible = false,
                OffsetPlayer = {x = 0.26875299215316, y = 0.5778568983078, z = 0.33802980184555},
                Dof = true,
                CamRot = {x = 0.51314014196395, y = 1.3340212490220438e-8, z = 28.01959800720215},
                DofStrength = 1.0,
                OffsetLook = {x = -1.4572285413742, y = -4.11463832855224, z = 0.38280895352363}
            }
        }
    },
    Vangelico = {
        {
        { -- MENU VANGELICO
                CamEffects = "Aucun",
                Gamertags = true,
                CamRot = {x = -3.02042269706726, y = -2.13443399843527e-7, z = -48.87252807617187},
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                CamCoords = {x = -628.091064453125, y = -233.64903259277345, z = 38.61730575561523},
                Fov = 45.0,
                DofStrength = 1.0,
                COH = {x = -627.2680053710938, y = -233.08656311035157, z = 38.05704879760742, w = 113.23944854736328}, Transition = 1000
            },
        { -- MONTRE
                CamEffects = "Aucun",
                Gamertags = true,
                CamRot = {x = -2.90231275558471, y = 0.0, z = -64.38384246826172},
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = {dict = "anim@random@shop_clothes@watches", anim = "idle_d"},
                CamCoords = {x = -628.1018676757813, y = -233.4064483642578, z = 38.60229110717773},
                Fov = 45.0,
                DofStrength = 1.0,
                COH = {x = -627.2680053710938, y = -233.08656311035157, z = 38.05704879760742, w = 113.23944854736328}, Transition = 1000
            },
        { -- COLIER
                CamEffects = "Aucun",
                Gamertags = true,
                CamRot = {x = -2.46924209594726, y = 1.0672168571090879e-7, z = -38.63675689697265},
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = {dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle"},
                CamCoords = {x = -627.8486328125, y = -233.69639587402345, z = 38.62655258178711},
                Fov = 45.0,
                DofStrength = 1.0,
                COH = {x = -627.2680053710938, y = -233.08656311035157, z = 38.05704879760742, w = 113.2623062133789}, Transition = 1000
            },
        { -- BRACELET
                CamEffects = "Aucun",
                Gamertags = false,
                CamRot = {x = -1.99696624279022, y = 1.0672168571090879e-7, z = -48.30508041381836},
                Dof = true,
                Freeze = true,
                CamEffectsAmplitude = 0.4,
                Animation = {dict = "rcmnigel1a", anim = "base"},
                CamCoords = {x = -627.9057006835938, y = -233.63735961914063, z = 38.13111877441406},
                Fov = 45.0,
                DofStrength = 1.0,
                COH = {x = -627.0817260742188, y = -232.98941040039063, z = 38.05706024169922, w = 109.83356475830078}, Transition = 1000
            },
            { -- BOUCLE D’OREILLES
                DofStrength = 1.0,
                COH = {x = -627.0865, y = -232.9988, z = 38.0570, w = 91.7881},
                Fov = 45.0,
                Dof = true,
                Animation = {dict = "anim@mp_corona_idles@female_b@idle_a", anim = "idle_a"},
                Gamertags = false,
                CamEffects = "Aucun",
                CamEffectsAmplitude = 0.4,
                Freeze = true,
                CamCoords = {x = -627.6658, y = -233.3594, z = 38.6944},
                CamRot = {x = -2.9019, y = 0.0, z = -51.4781}, Transition = 1000
            },
            { -- BAGUE
                DofStrength = 0.9,
                COH = {x = -627.1011, y = -232.7053, z = 38.0570, w = 124.9844},
                Fov = 45.0,
                Dof = true,
                Animation = {dict = "anim@holding_siege_vest_side", anim = "holding_siege_vest_side_clip"},
                Gamertags = false,
                CamEffects = "Aucun",
                CamEffectsAmplitude = 0.4,
                Freeze = true,
                CamCoords = {x = -627.7251, y = -233.0908, z = 38.4361},
                CamRot = {x = -5.6764, y = 0.0, z = -48.6355}, Transition = 1000
            },
        }
    },
    Tattoo = {
        {
            Pos = {
                vec4(1321.61, -1654.2, 51.28, 28.5),
                vec4(-1154.91, -1427.71, 3.96, 36.02),
                vec4(324.37, 180.98, 102.59, 160.86),
                vec4(-3170.18, 1077.44, 19.83, 251.3),
                -- vec4(1864.6, 3747.7, 33.0, 0.0),
                vec4(-294.7, 6200.08, 30.49, 314.4),
                vec4(-332.73, 7188.69, 5.48, 358.42)
            },
            Cam = {
                {
                    CamRot = {x = -1.6743459701538, y = 5.336084996088175e-8, z = -21.59906768798828},
                    OffsetPlayer = {x = -0.69243109226226, y = 1.18538689613342, z = 0.4349136352539},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = 2.02996492385864, y = -3.00593566894531, z = 0.288818359375},
                    COH = {x = 324.46502685546877, y = 180.65878295898438, z = 103.58799743652344, w = 125.39602661132813}
                },
                {
                    CamRot = {x = 0.43418571352958, y = -0.0, z = -23.41614532470703},
                    OffsetPlayer = {x = 0.597660779953, y = -1.15319108963012, z = 0.38662719726562},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = -2.05702233314514, y = 3.08370208740234, z = 0.42451477050781},
                    COH = {x = 324.4768371582031, y = 180.63380432128907, z = 103.58799743652344, w = 304.5141906738281}
                },
                {
                    CamRot = {x = -0.3058163523674, y = 6.670106245110219e-9, z = -19.62139892578125},
                    OffsetPlayer = {x = -0.28032481670379, y = 0.64682102203369, z = 0.63617706298828},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = 1.79512155055999, y = -3.90200281143188, z = 0.60948944091796},
                    COH = {x = 324.5083312988281, y = 180.69992065429688, z = 103.58799743652344, w = 135.85336303710938}
                },
                {
                    CamRot = {x = -2.24845790863037, y = -0.0, z = -17.12493896484375},
                    OffsetPlayer = {x = -1.2745703458786, y = -0.38534078001976, z = 0.17813110351562},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = 3.35022211074829, y = 1.50485134124755, z = -0.01803588867187},
                    COH = {x = 324.6710205078125, y = 180.37136840820313, z = 103.58799743652344, w = 50.64465713500976}
                },
                {
                    CamRot = {x = -2.24845790863037, y = -0.0, z = -17.12493896484375},
                    OffsetPlayer = {x = -1.2745703458786, y = -0.38534078001976, z = -0.55202484130859},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = 3.35022211074829, y = 1.50485134124755, z = -0.74819183349609},
                    COH = {x = 324.6710205078125, y = 180.37136840820313, z = 103.58799743652344, w = 50.64465713500976}
                },
                {
                    CamRot = {x = -2.89569544792175, y = -1.067216999217635e-7, z = -20.47140502929687},
                    OffsetPlayer = {x = 1.21778917312622, y = 0.63555037975311, z = 0.18068695068359},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = -3.1022081375122, y = -1.86920535564422, z = -0.0718994140625},
                    COH = {x = 324.5834045410156, y = 180.44293212890626, z = 103.58799743652344, w = 219.42330932617188}
                },
                {
                    CamRot = {x = -2.58073472976684, y = -0.0, z = -20.51077270507812},
                    OffsetPlayer = {x = 1.38171029090881, y = 0.73085689544677, z = -0.57991027832031},
                    Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"},
                    Dof = true,
                    Freeze = true,
                    Fov = 40.1,
                    DofStrength = 1.0,
                    OffsetLook = {x = -2.94115900993347, y = -1.77157759666442, z = -0.80504608154296},
                    COH = {x = 324.5834045410156, y = 180.44293212890626, z = 103.58799743652344, w = 219.42330932617188}
                }
            }
        }
    },
    Bike = {
        {
            Cam = {
                CamCoords = {x = -1270.8445, y = -1421.6431, z = 3.9344},
                Dof = true,
                Freeze = true,
                DofStrength = 1.0,
                COH = {x = -1268.8669, y = -1422.0693, z = 4.0342, w = 111.0683},
                Vehicle = -186537451,
                CamRot = {x = -1.5574, y = -2.668e-8, z = -99.6747},
                Fov = 51.0
            },
            Ped = { x = -1265.71, y = -1420.06, z = 3.37, w = 129.97 },
        },
    },
    SheNails = {
        {
            {
                DofStrength = 1.0,
                Dof = true,
                Fov = 45.0,
                CamRot = {x = -3.35272479057312, y = 2.1344337142181758e-7, z = 124.60067749023438},
                Freeze = true,
                CamCoords = {x = 219.08229064941407, y = -1545.7576904296876, z = 29.84988784790039},
                COH = {x = 218.22927856445313, y = -1546.255859375, z = 29.28751182556152, w = 292.0688171386719},
                Freeze = true,
                Animation = {anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a"}, Transition = 1000
            },
            {
                DofStrength = 1.0,
                Dof = true,
                Fov = 45.0,
                CamRot = {x = -3.29146075248718, y = 0.0, z = 121.6447982788086},
                Freeze = true,
                CamCoords = {x = 218.8724365234375, y = -1545.8934326171876, z = 29.90232467651367},
                COH = {x = 218.18789672851563, y = -1546.2568359375, z = 29.28751182556152, w = 270.22552490234377},
                Freeze = true,
                Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"}, Transition = 1000
            },
            {
                DofStrength = 0.0,
                Dof = false,
                Fov = 45.0,
                CamRot = {x = -6.11323308944702, y = -1.0672171413261822e-7, z = 101.34315490722656},
                Freeze = true,
                CamCoords = {x = 220.22039794921876, y = -1546.009033203125, z = 29.5639533996582},
                COH = {x = 219.06214904785157, y = -1546.2652587890626, z = 29.28765487670898, w = 307.1322937011719},
                Freeze = true,
                Animation = {anim = "idle_a_bartender", dict = "anim@amb@clubhouse@bar@drink@idle_a"}, Transition = 1000
            },
            {
                DofStrength = 0.9,
                Dof = true,
                Fov = 40.1,
                CamRot = {x = -2.2653374671936, y = -0.0, z = 120.01429748535156},
                CamCoords = {x = 219.3555450439453, y = -1545.6234130859376, z = 29.70855712890625},
                COH = {x = 218.22918701171876, y = -1546.255859375, z = 29.28751182556152, w = 292.06805419921877},
                Freeze = true,
                Animation = {anim = "idle_a", dict = "anim@mp_corona_idles@female_b@idle_a"}, Transition = 1000
            },
        }
    },
    Fuel = {
        PumpModels = {
            [-2007231801] = true,
            [1339433404] = true,
            [1694452750] = true,
            [1933174915] = true,
            [-462817101] = true,
            [-469694731] = true,
            [-164877493] = true
        },
        GasStations = {
            vector3(49.4187, 2778.793, 58.043),
            vector3(263.894, 2606.463, 44.983),
            vector3(1039.958, 2671.134, 39.550),
            vector3(1207.260, 2660.175, 37.899),
            vector3(2539.685, 2594.192, 37.944),
            vector3(2679.858, 3263.946, 55.240),
            vector3(2005.055, 3773.887, 32.403),
            vector3(1687.156, 4929.392, 42.078),
            vector3(1701.314, 6416.028, 32.763),
            vector3(179.857, 6602.839, 31.868),
            vector3(-94.4619, 6419.594, 31.489),
            vector3(-2554.996, 2334.40, 33.078),
            vector3(-1800.375, 803.661, 138.651),
            vector3(-1437.622, -276.747, 46.207),
            vector3(-2096.243, -320.286, 13.168),
            vector3(-724.619, -935.1631, 19.213),
            vector3(-526.019, -1211.003, 18.184),
            vector3(-70.2148, -1761.792, 29.534),
            vector3(265.648, -1261.309, 29.292),
            vector3(819.653, -1028.846, 26.403),
            vector3(1208.951, -1402.567,35.224),
            vector3(1181.381, -330.847, 69.316),
            vector3(620.843, 269.100, 103.089),
            vector3(2581.321, 362.039, 108.468),
            vector3(176.631, -1562.025, 29.263),
            vector3(176.631, -1562.025, 29.263),
            vector3(-319.292, -1471.715, 30.549),
            vector3(1784.324, 3330.55, 41.253),
            vector3(-3277.28, 6179.1, 12.65),
            vector3(-2746.72, 7034.69, 27.64),
            vector3(-1229.47, 6915.64, 19.46),
            vector3(-500.13, 7569.82, 5.42),
        }
    },
    Elevators = {
        {
            entries = {
                {label = "Sous-sol 3", floor = -3, pos = vector3(-1094.31, -848.0, 2.73), heading = 36.76},
                {label = "Sous-sol 1", floor = -1, pos = vector3(-1094.23, -848.02, 10.55), heading = 33.9},
                {label = "Étage 1", floor = 1, pos = vector3(-1094.57, -847.75, 18.37), heading = 38.61},
                {label = "Étage 2", floor = 2, pos = vector3(-1094.19, -847.81, 22.29), heading = 34.97},
                {label = "Étage 3", floor = 3, pos = vector3(-1094.4, -847.7, 26.2), heading = 39.76},
                {label = "Étage 4", floor = 4, pos = vector3(-1094.43, -847.9, 30.11), heading = 39.72},
                {label = "Étage 5", floor = 5, pos = vector3(-1094.26, -847.73, 34.02), heading = 42.48},
                {label = "Étage 6", floor = 6, pos = vector3(-1094.31, -848.03, 37.88), heading = 37.14}
            },
        },
        {
            entries = {
                {label = "Garage", floor = -1, pos = vector3(326.75, -578.51, 27.76), heading = 339.66},
                {label = "Étage 1", floor = 1, pos = vector3(306.32, -591.75, 42.27), heading = 65.55},
                {label = "Étage 2", floor = 2, pos = vector3(306.14, -591.61, 46.28), heading = 69.68},
                {label = "Héliport", floor = 3, pos = vector3(329.8, -582.05, 73.18), heading = 242.31},
            },
        },
        {
            entries = {
                {label = "A1", floor = 1, pos = vector3(314.45, -562.04, 27.78), heading = 161.28},
                {label = "A3", floor = 2, pos = vector3(329.44, -568.47, 42.26), heading = 190.37},
                {label = "A11", floor = 3, pos = vector3(322.41, -573.28, 73.16), heading = 158.94},
            },
        },
    },

    Sonnette = {
        ["lspd"] = {
            pos = {
                vector4(420.9854, -985.1433, 30.7168-1, 91.2043),
            },
            ped = "s_m_y_cop_01",
            msg = "Un agent est demandé à l'accueil du poste"
        },
        ["lssd"] = {
            pos = { vector4(1818.37, 3672.65, 33.71, 121.62) },
            ped = "s_m_y_sheriff_01",
            msg = "Un agent est demandé à l'accueil du poste"
        },
        ["lsfd"] = {
            pos = { vector4(-1037.58, -1400.5, 4.08, 68.98) },
            ped = "s_m_y_fireman_01",
            msg = "Un patient sonne à l'acceuil"
        },
        ["sams"] = {
            pos = { vector4(298.2863, -587.2980, 43.2608-1, 69.5055) },
            ped = "s_f_y_scrubs_01",
            msg = "Un patient sonne à l'acceuil"
        },
    }
}
