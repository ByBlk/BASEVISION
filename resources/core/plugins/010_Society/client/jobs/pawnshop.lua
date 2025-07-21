while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["pawnshop"] then return end
Society.newJob("pawnshop", {
    Blips = {
        Position = vector3(1700.8258, 3781.7908, 34.7110),
        Sprite = 267,
        Color = 28,
        Scale = 0.8,
        Name = "Pawnshop"
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
    Sonnette = vector3(1703.0609, 3778.9514, 34.7537),
    Gestion = vector3(1706.0338, 3788.5249, 34.7110),
    Stockage = vector3(1696.1324, 3779.4307, 34.7114),
    Casier = vector3(1705.5525, 3790.9373, 34.7110),
    Vetement = {
        Position = vector3(1703.4377, 3790.0974, 34.8477-1),
        Items = {
            male = {
                { id = "Pawnshop", haut = 1050, chaine = 0, varDecals = 0, varHaut = 5, varGpb = 0, sac = 0, bras = 0, varChaussures = 0, gpb = 0, decals = 0, pantalon = 439, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 0, varBras = 0, varPantalon = 0, chaussures = 289 }
            },
            female = {
                { id = "Pawnshop", haut = 250, chaine = 0, varDecals = 0, varHaut = 0, varGpb = 0, sac = 0, bras = 14, varChaussures = 5, gpb = 0, decals = 0, pantalon = 251, sousHaut = 15, varChaine = 0, varSac = 0, varSousHaut = 9, varBras = 0, varPantalon = 6, chaussures = 343 }
            }
        }
    }
})