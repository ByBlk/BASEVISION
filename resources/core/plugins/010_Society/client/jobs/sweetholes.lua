 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["sweetholes"] then return end
 Society.newJob("sweetholes", {
     Blips = {
         Position = vector3(-333.91, 7342.05, 6.6),
         Sprite = 355,
         Color = 48,
         Scale = 0.8,
         Name = "Sweet Holes"
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
     Sonnette = vector3(-334.91, 7342.39, 6.6),
     Gestion = vector3(-339.26, 7347.34, 6.57),
     Stockage = vector3(-343.14, 7356.98, 6.57),
     Casier = vector3(-340.65, 7352.87, 6.57),
     --Catalogue = {
     --    Position = vector3(0.0, 0.0, 0.0),
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
         Position = vector3(-343.45, 7352.75, 6.57),
         Items = {
             male = {
                 { id = "Sweet Holes", haut = 582, chaine = 0, varDecals = 0, varHaut = 12, varGpb = 0, sac = 0, bras = 11, varChaussures = 0, gpb = 0, decals = 0, pantalon = 474, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 0, varPantalon = 1, chaussures = 287 }
             },
             female = {
                 { id = "Sweet Holes", haut = 1126, chaine = 0, varDecals = 0, varHaut = 8, varGpb = 0, sac = 0, bras = 0, varChaussures = 0, gpb = 0, decals = 0, pantalon = 15, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 5, varBras = 0, varPantalon = 0, chaussures = 345 },
             }
         }
     },
     --Craft = {
     --    Position = vector3(-336.78, 7351.41, 6.57),
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