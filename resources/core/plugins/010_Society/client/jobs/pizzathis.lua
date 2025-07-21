 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["pizzathis"] then return end
 Society.newJob("pizzathis", {
     Blips = {
         Position = vector3(799.15, -742.99, 25.78),
         Sprite = 267,
         Color = 1,
         Scale = 0.8,
         Name = "Pizza This"
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
     Sonnette = vector3(806.89, -745.51, 26.78),
     Gestion = vector3(797.22, -750.69, 31.27),
     Stockage = vector3(802.69, -758.23, 26.78),
     Casier = vector3(808.62, -759.12, 31.27),
     --Catalogue = {
     --    Position = vector3(810.04, -752.86, 26.78),
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
         Position = vector3(811.96, -758.93, 31.27),
         Items = {
             male = {
                 { id = "Pizza This Homme", haut = 580, chaine = 0, varDecals = 0, varHaut = 0, varGpb = 1, sac = 0, bras = 1, varChaussures = 0, gpb = 259, decals = 0, pantalon = 474, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 0, varPantalon = 4, chaussures = 15 }
             },
             female = {
                 { id = "PizzaThis", haut = 1126, chaine = 0, varDecals = 0, varHaut = 9, varGpb = 0, sac = 0, bras = 0, varChaussures = 2, gpb = 0, decals = 0, pantalon = 15, sousHaut = 14, varChaine = 0, varSac = 0, varSousHaut = 8, varBras = 0, varPantalon = 0, chaussures = 328 }
             }
         }
     },
     Garage = {
         Position = vector3(814.98, -761.7, 26.78),
         PositionSpawn = vector3(809.67, -732.67, 27.38),
         PositionSpawnH = 132.39,
         PositionDelete = vector3(809.67, -732.67, 27.38),
         Camera = { COH = { x = 795.36572265625, y = -727.494140625, z = 27.64427947998047, w = 12.73225784301757 }, Invisible = true, Fov = 40.1, Dof = true, Freeze = false, Animation = { dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle" }, CamCoords = { x = 791.6804809570313, y = -722.4861450195313, z = 27.92750358581543 }, DofStrength = 0.6, CamRot = { x = -1.35992908477783, y = -0.0, z = -130.6929168701172 } },
         Items = {
             { model = "nspeedo", label = "Speedo", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 20)
                 SetVehicleMod(vehicle, 48, 20)
             end},
             { model = "taco2", label = "Tacos Van", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 11)
                 SetVehicleMod(vehicle, 48, 11)
             end},
             { model = "foodbike", label = "Scooter", bonus = function(vehicle)
                 SetVehicleLivery(vehicle, 0)
                 SetVehicleMod(vehicle, 48, 0)
             end}
         }
     },
    --  Craft = {
    --     Position = vector3(807.6732, -761.3270, 26.7809),
    --     Items = {
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --         { name = "", label = "", timer = 10, recipe = {
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1 },
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --             { name = "", label = "", amount = 1},
    --         }},
    --     }
    --  }
 })