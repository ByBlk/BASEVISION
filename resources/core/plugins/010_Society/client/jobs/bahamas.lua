 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["bahamas"] then return end
 Society.newJob("bahamas", {
     Blips = BLK.Jobs.Bahamas.Blips,
     Radial = {
         main = {
             {
                 name = "ANNONCE",
                 icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                 action = "CreateJobAdvert"
             },
             {
                 name = "FACTURE",
                 icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/billet.svg",
                 action = "OpenInvoice"
             },
             {
                 name = "PRISE DE SERVICE",
                 icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/checkmark.svg",
                 action = "SetJobDuty"
             }
         }
     },
     Sonnette = BLK.Jobs.Bahamas.Sonnette,
     Gestion = BLK.Jobs.Bahamas.Gestion,
     Stockage = BLK.Jobs.Bahamas.Stockage,
     Casier = BLK.Jobs.Bahamas.Casier,
     Catalogue = {
         Position = BLK.Jobs.Bahamas.Catalogue,
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
     Vetement = BLK.Jobs.Bahamas.Vetement,
     Garage = BLK.Jobs.Bahamas.Garage,
     Craft = {
         Position = BLK.Jobs.Bahamas.Craft,
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
             { name = "Blue-Mamas", label = "Blue-Mamas", timer = 10, recipe = {
                 { name = "rhum", label = "Rhum", amount = 1 },
                 { name = "jusdorange", label = "Jus d'orange", amount = 1 },
                 { name = "jusdananas", label = "Jus d'ananas", amount = 1 },
                 { name = "jusdecitron", label = "Jus de citron", amount = 1},
                 { name = "siropdecresise", label = "Sirop de cerise", amount = 1},
             }},
             { name = "irishc", label = "Irish Coffee", timer = 10, recipe = {
                 { name = "Whisky", label = "Whisky", amount = 1 },
                 { name = "sucre", label = "Sucre", amount = 1 },
                 { name = "coffee", label = "Café", amount = 1 },
                 { name = "cremefouette", label = "Crème Fouettée", amount = 1},
             }},
             { name = "mojito", label = "Mojito", timer = 10, recipe = {
                 { name = "eaupetillante", label = "Eau Petillante", amount = 1 },
                 { name = "rhum", label = "Rhum", amount = 1 },
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