 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["dynasty"] then return end
 Society.newJob("dynasty", {
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
             },
             {
                 name = "PROPRIÉTÉ",
                 icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/house.svg",
                 action = "OpenPropertyCreationMenu"
             }
         }
     },
     Sonnette = BLK.Jobs.Dynasty.Sonnette,
     Gestion = BLK.Jobs.Dynasty.Gestion,
     Stockage = BLK.Jobs.Dynasty.Stockage,
     Casier = BLK.Jobs.Dynasty.Casier,
     Vetement = BLK.Jobs.Dynasty.Vetement,
     Garage = BLK.Jobs.Dynasty.Garage
 })