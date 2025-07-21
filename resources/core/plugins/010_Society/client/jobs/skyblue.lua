 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["skyblue"] then return end
 Society.newJob("skyblue", {
     Blips = {
         Position = vector3(-1157.82, -178.75, 74.77),
         Sprite = 120,
         Color = 21,
         Scale = 0.8,
         Name = "Sky Blue"
     },
     Radial = {
         main = {
             {
                 name = "ANNONCE",
                 icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/megaphone.svg",
                 action = "CreateJobAdvert"
             },
             {
                 name = "FACTURE",
                 icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/billet.svg",
                 action = "OpenInvoice"
             },
             {
                 name = "PRISE DE SERVICE",
                 icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/checkmark.svg",
                 action = "SetJobDuty"
             }
         }
     },
     Sonnette = vector3(-1138.51, -199.94, 37.96),
     Gestion = vector3(-1169.5, -191.28, 75.76),
     Stockage = vector3(-1178.53, -174.9, 75.77),
     Casier = vector3(-1178.11, -177.66, 75.77),
     --Catalogue = {
     --    Position = vector3(-1174.7, -175.3, 75.77),
     --    Items = {
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --        { model = "" },
     --    }
     --},
     Vetement = {
         Position = vector3(-1178.86, -187.49, 75.77),
         Items = {
             male = {
                 { id = "Sky Blue Homme", haut = 294, chaine = 0, varDecals = 0, varHaut = 8, varGpb = 0, sac = 0, bras = 1, varChaussures = 1, gpb = 0, decals = 0, pantalon = 20, sousHaut = 443, varChaine = 0, varSac = 0, varSousHaut = 1, varBras = 0, varPantalon = 0, chaussures = 109 }
             },
             female = {
                 { id = "SkyBlue Femme", haut = 1128, chaine = -1, varDecals = 0, varHaut = 1, varGpb = 0, sac = 210, bras = 15, varChaussures = 2, gpb = 0, decals = 0, pantalon = 317, sousHaut = 14, varChaine = -1, varSac = 8, varSousHaut = 0, varBras = 0, varPantalon = 6, chaussures = 327 }
             }
         }
     },
     Garage = {
         Position = vector3(-1148.94, -202.58, 37.96),
         PositionSpawn = vector3(-1152.28, -230.79, 36.66),
         PositionSpawnH = 315.37,
         PositionDelete = vector3(-1152.28, -230.79, 36.66),
         Camera = { DofStrength = 0.8, Dof = true, Freeze = false, Animation = { dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle" }, CamRot = { x = -0.37928402423858, y = -0.0, z = 32.34727096557617 }, CamCoords = { x = -1143.8521728515626, y = -229.84693908691407, z = 37.84021377563476 }, COH = { x = -1145.3355712890626, y = -224.4745635986328, z = 37.70413589477539, w = 172.3531951904297 }, Invisible = true, Fov = 50.1 },
         Items = {
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 24)
                 SetVehicleMod(vehicle, 48, 24)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end}
         }
     },
     --Craft = {
     --    Position = vector3(-1176.31, -176.11, 75.77),
     --    Items = {
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --        { name = "", label = "", timer = 10, recipe = {
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1 },
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --            { name = "", label = "", amount = 1},
     --        }},
     --    }
     --}
 })