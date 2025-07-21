 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["yellowjack"] then return end
 Society.newJob("yellowjack", {
     Blips = {
         Position = vector3(1989.01, 3048.69, 46.22),
         Sprite = 93,
         Color = 5,
         Scale = 0.8,
         Name = "Yellow Jack"
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
     Sonnette = vector3(2000.54, 3049.42, 47.21),
     Gestion = vector3(1987.53, 3044.78, 50.89),
     Stockage = vector3(1977.07, 3054.85, 47.22),
     Casier = vector3(1985.91, 3048.42, 50.89),
     Catalogue = {
         Position = vector3(1985.48, 3048.81, 47.22),
         Items = {
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
             { model = "" },
         }
     },
     Vetement = {
         Position = vector3(1984.0, 3049.4, 50.89),
         Items = {
             male = {
                 { id = "Yellow Jack Homme", haut = 717, chaine = 0, varDecals = 0, varHaut = 25, varGpb = 0, sac = 0, bras = 0, varChaussures = 0, gpb = 0, decals = 0, pantalon = 264, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 1, varBras = 0, varPantalon = 3, chaussures = 43 }
             },
             female = {
                 { id = "Yellow Jack Femme", haut = 798, chaine = 0, varDecals = 0, varHaut = 9, varGpb = 0, sac = 0, bras = 31, varChaussures = 2, gpb = 0, decals = 0, pantalon = 297, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 1, varPantalon = 1, chaussures = 323 }
             }
         }
     },
     Garage = {
         Position = vector3(1982.23, 3060.38, 47.19),
         PositionSpawn = vector3(2011.92, 3055.5, 45.83),
         PositionSpawnH = 57.07,
         PositionDelete = vector3(2005.91, 3053.85, 47.05),
         Camera = { CamRot = { x = -2.44343900680542, y = 5.336084996088175e-8, z = -22.55881881713867 }, Animation = { anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a" }, CamCoords = { x = 1968.492919921875, y = 3031.744384765625, z = 47.05023574829101 }, Dof = true, Invisible = true, Freeze = false, COH = { x = 1971.8939208984376, y = 3035.386962890625, z = 46.83724594116211, w = 112.951416015625 }, Fov = 60.1, DofStrength = 0.8, },
         Items = {
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 21)
                 SetVehicleMod(vehicle, 48, 21)
             end},
             { model = "taco2", label = "Tacos Van", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end}
         }
     },
     Craft = {
         Position = vector3(-588.59, -1059.76, 22.36),
         Items = {
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
             { name = "", label = "", timer = 10, recipe = {
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1 },
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
                 { name = "", label = "", amount = 1},
             }},
         }
     }
 })