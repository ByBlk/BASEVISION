 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["unicorn"] then return end
 Society.newJob("unicorn", {
     Blips = {
         Position = vector3(129.31, -1299.89, 28.23),
         Sprite = 121,
         Color = 8,
         Scale = 0.8,
         Name = "Unicorn"
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
     Sonnette = vector3(130.03, -1298.45, 28.23+1),
     Gestion = vector3(112.23, -1320.47, 23.72+1),
     Stockage = vector3(132.14, -1325.14, 18.4+1),
     Casier = vector3(144.84, -1326.15, 18.42+1),
     Catalogue = {
        Position = vector3(132.14, -1325.14, 18.4+1),
        Items = {
            { model = "Jusdefruits" },
            { model = "Limonade" },
            { model = "ecola" },
            { model = "BloodyMary" },
            { model = "Blue-Mamas" },
            { model = "irishc" },
            { model = "mojito" },
            { model = "Punch" },
            { model = "WhiteLady" },
            { model = "tapas" },
        }
    },
     Vetement = {
         Position = vector3(126.85, -1296.53, 21.11),
         Items = {
             male = {
                 { id = "Unicorn Homme", haut = 717, chaine = 0, varDecals = 0, varHaut = 23, varGpb = 0, sac = 0, bras = 0, varChaussures = 1, gpb = 0, decals = 0, pantalon = 318, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 1, varBras = 0, varPantalon = 0, chaussures = 274 }
             },
             female = {
                 { id = "Unicorn F", haut = 1105, chaine = 0, varDecals = 0, varHaut = 10, varGpb = 0, sac = -1, bras = 373, varChaussures = 13, gpb = 0, decals = 0, pantalon = 309, sousHaut = 15, varChaine = -1, varSac = -1, varSousHaut = 0, varBras = 0, varPantalon = 0, chaussures = 327 }
             }
         }
     },
     Garage = {
         Position = vector3(135.85, -1279.1, 29.37),
         PositionSpawn = vector3(145.43, -1287.31, 29.07),
         PositionSpawnH = 300.16,
         PositionDelete = vector3(145.43, -1287.31, 29.07),
         Camera = { CamRot = { x = -0.47491267323493, y = -0.0, z = 126.04743194580078 }, Animation = { anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a" }, CamCoords = { x = 160.73593139648438, y = -1282.9072265625, z = 29.26998710632324 }, Dof = true, Invisible = true, Freeze = false, COH = { x = 155.62074279785157, y = -1284.7164306640626, z = 29.06590461730957, w = 264.99517822265627 }, Fov = 50.1, DofStrength = 0.7 },
         Items = {
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 12)
                 SetVehicleMod(vehicle, 48, 12)
             end},
             { model = "boxville7", label = "Boxville", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 4)
                 SetVehicleMod(vehicle, 48, 4)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end}
         }
     },
     Craft = {
        Position = vector3(133.07, -1324.12, 18.4+1),
        Items = {
            { name = "Jusdefruits", label = "Jus de fruits", timer = 10, recipe = {
                { name = "jusdorange", label = "Jus d'orange", amount = 1 },
                { name = "jusdananas", label = "Jus d'ananas", amount = 1 },
                { name = "jusdepomme", label = "Jus de pomme", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1},
            }},
            { name = "Limonade", label = "Limonade", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "jusdecitron", label = "Jus de Citron", amount = 1 },
                { name = "lemon", label = "Citron", amount = 1 },
                { name = "menthe", label = "Menthe", amount = 1},
                { name = "glaons", label = "Glaçons", amount = 1},
            }},
            { name = "ecola", label = "E-Cola", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "siropcola", label = "Sirop d'e-cola", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
            }},
            { name = "BloodyMary", label = "Bloody Mary", timer = 10, recipe = {
                { name = "vodka", label = "Vodka", amount = 1 },
                { name = "jusdecitron", label = "Jus de Citron", amount = 1 },
                { name = "jusdetomate", label = "Jus de Tomate", amount = 1 },
                { name = "tabasco", label = "Tabasco", amount = 1},
                { name = "sel", label = "Sel", amount = 1},
                { name = "poivre", label = "Poivre", amount = 1},
            }},
        }
     }
 })