while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["beekers"] then return end
Society.newJob("beekers", {
    Blips = Kipstz.Jobs.Beekers.Blips,
    Radial = {
        main = {
            {
                name = "ANNONCE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/megaphone.svg",
                action = "CreateJobAdvert",
            },
            {
                name = "FACTURE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/billet.svg",
                action = "OpenInvoice"
            },
            {
                name = "PRISE DE SERVICE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/checkmark.svg",
                action = "SetJobDuty",
            },
            {
                name = "REPARER",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/repair.svg",
                action = "OpenSubRadialJobs",
                args = "repair"
            },
        },
        repair = {
            {
                name = "NETTOYAGE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/sponge.svg",
                action = "CleanVehicle",
            },
            {
                name = "CARROSSERIE",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/car.svg",
                action = "RepairCarroserieVehicle"
            },
            {
                name = "RETOUR",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/leave.svg",
                action = "OpenSubRadialJobs",
                args = "main"
            },
            {
                name = "MOTEUR",
                icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/engine.svg",
                action = "RepairVehicle"
            }
        },
    },
    Sonnette = Kipstz.Jobs.Beekers.Sonnette,
    Gestion = Kipstz.Jobs.Beekers.Gestion,
    Stockage = Kipstz.Jobs.Beekers.Stockage,
    Casier = Kipstz.Jobs.Beekers.Casier,
    Catalogue = {
        Position = Kipstz.Jobs.Beekers.Catalogue,
        Items = {
            { model = "repairkit" },
            { model = "cleankit" },
            { model = "weapon_petrolcan" },
            { model = "cordes" },
        }
    },
    Vetement = Kipstz.Jobs.Beekers.Vetement,
    Craft = {
        Position = Kipstz.Jobs.Beekers.Craft,
        Items = {
            { name = "repairkit", label = "Kit de réparation", timer = 10, recipe = {
                { name = "coffretoutils", label = "Coffret à Outils", amount = 1 },
                { name = "cleamolette", label = "Clé à molette", amount = 1 },
                { name = "tournevis", label = "Tourne Vis", amount = 1 },
                { name = "lotdevis", label = "Lot de Vis", amount = 2},
                { name = "pincecoupante", label = "Pince Coupante", amount = 1},
                { name = "pincecrocodile", label = "Pince Crocodile", amount = 1},
            }},
            { name = "cleankit", label = "Kit de nettoyage", timer = 10, recipe = {
                { name = "vaporisateur", label = "Vaporisateur", amount = 1 },
                { name = "water", label = "Eau", amount = 1 },
                { name = "produit", label = "Produit", amount = 1 },
                { name = "chiffon", label = "Chiffon", amount = 1},
            }},
            { name = "weapon_petrolcan", label = "Bidon d essence", timer = 10, recipe = {
                { name = "bidon", label = "Bidon", amount = 1 },
                { name = "tuyau", label = "Tuyau", amount = 1 },
                { name = "bouchon", label = "Bouhcon", amount = 1 },
                { name = "essence", label = "Essence", amount = 1},
            }},
            { name = "cordes", label = "Cordes", timer = 10, recipe = {
                { name = "attelage", label = "Attelage", amount = 1 },
                { name = "barrederemorquage", label = "Barre de Remorquage", amount = 1 },
            }},
        }
    }
})