while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["rockford"] then return end
Society.newJob("rockford", {
    Blips = BLK.Jobs.RockFord.Blips,
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
    Sonnette = BLK.Jobs.RockFord.Sonnette,
    Gestion = BLK.Jobs.RockFord.Gestion,
    Stockage = BLK.Jobs.RockFord.Stockage,
    Casier = BLK.Jobs.RockFord.Casier,
    Vetement = BLK.Jobs.RockFord.Vetement
})