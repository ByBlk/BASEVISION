while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["rockford"] then return end
Society.newJob("rockford", {
    Blips = Kipstz.Jobs.RockFord.Blips,
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
    Sonnette = Kipstz.Jobs.RockFord.Sonnette,
    Gestion = Kipstz.Jobs.RockFord.Gestion,
    Stockage = Kipstz.Jobs.RockFord.Stockage,
    Casier = Kipstz.Jobs.RockFord.Casier,
    Vetement = Kipstz.Jobs.RockFord.Vetement
})