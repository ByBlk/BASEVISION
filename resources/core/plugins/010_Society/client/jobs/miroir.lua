 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["miroir"] then return end
 Society.newJob("miroir", {
    --  Blips = {
    --      Position = vector3(1122.21, -645.18, 55.81),
    --      Sprite = 78,
    --      Color = 18,
    --      Scale = 0.8,
    --      Name = "Miroir"
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
     --Sonnette = vector3(1124.01, -646.74, 56.7),
     Gestion = vector3(1121.69, -648.62, 56.81),
     Stockage = vector3(1114.34, -635.49, 56.82),
     Casier = vector3(1117.14, -636.83, 56.82),
     --Catalogue = {
     --    Position = vector3(1117.17, -641.44, 56.82),
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
         Position = vector3(1116.71, -634.68, 56.82),
         Items = {
             male = {
                 { id = "Miroir", haut = 348, chaine = 0, varDecals = 0, varHaut = 0, varGpb = 0, sac = 0, bras = 1, varChaussures = 2, gpb = 0, decals = 0, pantalon = 473, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 0, varPantalon = 1, chaussures = 164 }
             },
             female = {
                 { id = "Miroir", haut = 1003, chaine = 0, varDecals = 0, varHaut = 0, varGpb = 0, sac = 0, bras = 1, varChaussures = 9, gpb = 0, decals = 0, pantalon = 420, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 8, varBras = 0, varPantalon = 1, chaussures = 331 }
             }
         }
     },
     Garage = {
         Position = vector3(1119.61, -638.31, 56.77),
         PositionSpawn = vector3(1160.66, -619.47, 62.61),
         PositionSpawnH = 192.96,
         PositionDelete = vector3(1160.66, -619.47, 62.61),
         Camera = { DofStrength = 0.8, Dof = true, Freeze = false, Animation = { dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle" }, CamRot = { x = -2.46866130828857, y = -1.6675265612775548e-9, z = 89.63782501220703 }, CamCoords = { x = 1179.2557373046876, y = -645.9146728515625, z = 62.45953750610351 }, COH = { x = 1173.9639892578126, y = -644.1563110351563, z = 62.15414047241211, w = 226.15060424804688 }, Fov = 50.1 },
         Items = {
             { model = "boxville7", label = "Boxville", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 8)
                 SetVehicleMod(vehicle, 48, 8)
             end},
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 14)
                 SetVehicleMod(vehicle, 48, 14)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end},
         }
     },
     --Craft = {
     --    Position = vector3(1117.42, -639.06, 56.82),
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