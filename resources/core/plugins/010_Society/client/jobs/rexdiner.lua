 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["rexdiner"] then return end
 Society.newJob("rexdiner", {
    --  Blips = {
    --      Position = vector3(2539.49, 2586.21, 37.5),
    --      Sprite = 488,
    --      Color = 3,
    --      Scale = 0.8,
    --      Name = "Rex Diner"
    --  },
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
     --Sonnette = vector3(2546.03, 2592.15, 38.1),
     Gestion = vector3(2543.18, 2579.72, 38.5),
     Stockage = vector3(2529.19, 2579.61, 38.5),
     Casier = vector3(2544.42, 2582.89, 38.5),
     --Catalogue = {
     --    Position = vector3(2542.79, 2588.17, 38.5),
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
         Position = vector3(2525.78, 2579.61, 38.07),
         Items = {
             male = {
                 { id = "Rex Diner", haut = 582, chaine = 0, varDecals = 0, varHaut = 14, varGpb = 0, sac = 0, bras = 11, varChaussures = 0, gpb = 0, decals = 0, pantalon = 474, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 0, varPantalon = 1, chaussures = 287 }
             },
             female = {
                 { id = "Rex 1", haut = 1126, chaine = 0, varDecals = 0, varHaut = 0, varGpb = 0, sac = 0, bras = 0, varChaussures = 12, gpb = 0, decals = 0, pantalon = 15, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 5, varBras = 0, varPantalon = 0, chaussures = 345 },
                 { id = "Rex 2", haut = 1126, chaine = 0, varDecals = 0, varHaut = 1, varGpb = 0, sac = 0, bras = 0, varChaussures = 0, gpb = 0, decals = 0, pantalon = 15, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 5, varBras = 0, varPantalon = 0, chaussures = 345 },
             }
         }
     },
     Garage = {
         Position = vector3(2539.4, 2593.02, 38.1),
         PositionSpawn = vector3(2558.7, 2596.36, 37.73),
         PositionSpawnH = 85.35,
         PositionDelete = vector3(2558.7, 2596.36, 37.73),
         Camera = { CamRot = { x = -1.35472679138183, y = -2.6680424980440877e-8, z = -172.43930053710938 }, Animation = { anim = "idle", dict = "anim@heists@heist_corona@team_idles@male_a" }, CamCoords = { x = 2535.441650390625, y = 2615.337646484375, z = 37.93829727172851 }, Dof = true, Invisible = true, Freeze = false, COH = { x = 2534.639404296875, y = 2609.624267578125, z = 37.72875595092773, w = 324.8380432128906 }, Fov = 50.1, DofStrength = 0.7 },
         Items = {
             { model = "boxville7", label = "Boxville", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 2)
                 SetVehicleMod(vehicle, 48, 2)
             end},
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 23)
                 SetVehicleMod(vehicle, 48, 23)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end}
         }
     },
     --Craft = {
     --    Position = vector3(2540.12, 2581.16, 38.51),
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