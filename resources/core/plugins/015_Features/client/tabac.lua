while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["tabac"] then return end
Society.newJob("tabac", {
    Blips = Kipstz.Jobs.Tabac.Blips,
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
    Sonnette = Kipstz.Jobs.Tabac.Sonnette,
    Gestion = Kipstz.Jobs.Tabac.Gestion,
    Stockage = Kipstz.Jobs.Tabac.Stockage,
    Casier = Kipstz.Jobs.Tabac.Casier,
    Vetement = Kipstz.Jobs.Tabac.Vetement,
    Garage = Kipstz.Jobs.Tabac.Garage,
})
