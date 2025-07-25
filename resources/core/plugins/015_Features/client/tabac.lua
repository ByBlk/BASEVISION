while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["tabac"] then return end
Society.newJob("tabac", {
    Blips = BLK.Jobs.Tabac.Blips,
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
    Sonnette = BLK.Jobs.Tabac.Sonnette,
    Gestion = BLK.Jobs.Tabac.Gestion,
    Stockage = BLK.Jobs.Tabac.Stockage,
    Casier = BLK.Jobs.Tabac.Casier,
    Vetement = BLK.Jobs.Tabac.Vetement,
    Garage = BLK.Jobs.Tabac.Garage,
})
