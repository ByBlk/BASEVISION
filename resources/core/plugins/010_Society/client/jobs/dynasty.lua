 while not ConfigManager do Wait(100) end
 while not ConfigManager.Config.society do Wait(100) end
 if not ConfigManager.Config.society["dynasty"] then return end
 Society.newJob("dynasty", {
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
             },
             {
                 name = "PROPRIÉTÉ",
                 icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/house.svg",
                 action = "OpenPropertyCreationMenu"
             }
         }
     },
     Sonnette = Kipstz.Jobs.Dynasty.Sonnette,
     Gestion = Kipstz.Jobs.Dynasty.Gestion,
     Stockage = Kipstz.Jobs.Dynasty.Stockage,
     Casier = Kipstz.Jobs.Dynasty.Casier,
     Vetement = Kipstz.Jobs.Dynasty.Vetement,
     Garage = Kipstz.Jobs.Dynasty.Garage
 })