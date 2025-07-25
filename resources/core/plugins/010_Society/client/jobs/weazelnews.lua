while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["weazelnews"] then return end
Society.newJob("weazelnews", {
    Blips = BLK.Jobs.WeazelNews.Blips,
    Radial = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "ANNONCE WEAZELS",
                icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/megaphone.svg",
                action = "OpenMenuAnnonceWeazel"
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
    Sonnette = BLK.Jobs.WeazelNews.Sonnette,
    Gestion = BLK.Jobs.WeazelNews.Gestion,
    Stockage = BLK.Jobs.WeazelNews.Stockage,
    Casier = BLK.Jobs.WeazelNews.Casier,
    Vetement = BLK.Jobs.WeazelNews.Vetement,
    Garage = BLK.Jobs.WeazelNews.Garage
})