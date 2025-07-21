while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["weazelnews"] then return end
Society.newJob("weazelnews", {
    Blips = Kipstz.Jobs.WeazelNews.Blips,
    Radial = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert"
            },
            {
                name = "ANNONCE WEAZELS",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/megaphone.svg",
                action = "OpenMenuAnnonceWeazel"
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
    Sonnette = Kipstz.Jobs.WeazelNews.Sonnette,
    Gestion = Kipstz.Jobs.WeazelNews.Gestion,
    Stockage = Kipstz.Jobs.WeazelNews.Stockage,
    Casier = Kipstz.Jobs.WeazelNews.Casier,
    Vetement = Kipstz.Jobs.WeazelNews.Vetement,
    Garage = Kipstz.Jobs.WeazelNews.Garage
})