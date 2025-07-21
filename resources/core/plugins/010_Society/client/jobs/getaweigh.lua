while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["getaweigh"] then return end
Society.newJob("getaweigh", {
    Blips = Kipstz.Jobs.GetAweigh.Blips,
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
    Sonnette = Kipstz.Jobs.GetAweigh.Sonnette,
    Gestion = Kipstz.Jobs.GetAweigh.Gestion,
    Stockage = Kipstz.Jobs.GetAweigh.Stockage,
    Casier = Kipstz.Jobs.GetAweigh.Casier,
    Catalogue = {
        Position = Kipstz.Jobs.GetAweigh.Catalogue,
        Items = {
            { model = "repairkit" },
            { model = "cleankit" },
            { model = "weapon_petrolcan" },
            { model = "cordes" },
            { model = "recycleur" },
            { model = "gadget_parachute" },
        }
    },
    Vetement = Kipstz.Jobs.GetAweigh.Vetement,
    Craft = {
        Position = Kipstz.Jobs.GetAweigh.Craft,
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
            { name = "recycleur", label = "Recycleur", timer = 10, recipe = {
                { name = "bouteillesdegaz", label = "Bouteilles de Gaz", amount = 1 },
                { name = "co2", label = "CO2", amount = 1 },
                { name = "sac", label = "Sac", amount = 1 },
                { name = "caoutchouc", label = "Caoutchouc", amount = 1 },                                 
            }},
            { name = "gadget_parachute", label = "Parachute", timer = 10, recipe = {
                { name = "tissu", label = "Tissu", amount = 1 },
                { name = "cordes", label = "Cordes", amount = 1 },                            
            }},              
        }
    }
})