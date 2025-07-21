while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["burgershot"] then return end
Society.newJob("burgershot", {
    Blips = Kipstz.Jobs.Burgershot.Blips,
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
    Sonnette = Kipstz.Jobs.Burgershot.Sonnette,
    Gestion = Kipstz.Jobs.Burgershot.Gestion,
    Stockage = Kipstz.Jobs.Burgershot.Stockage,
    Casier = Kipstz.Jobs.Burgershot.Casier,
    Catalogue = {
        Position = Kipstz.Jobs.Burgershot.Catalogue,
        Items = {
            { model = "friesbox" },
            { model = "wrapp" },
            { model = "goatcheesewrap" },
            { model = "fishburger" },
            { model = "thegloriousburger" },
            { model = "doubleshotburger" },
            { model = "bleederburger" },
            { model = "pricklyburger" },
            { model = "thefabulous6lbburger" },
            { model = "tacos" },
            { model = "bssoda" },
            { model = "Limonade" },
            { model = "Jusdefruits" },
            { model = "meteoriteicecream" },
            { model = "orangotangicecream" },
            { model = "granita" },
            { model = "Milkshake" },
            { model = "cookie" },
        }
    },
    Vetement = Kipstz.Jobs.Burgershot.Vetement,
    Garage = Kipstz.Jobs.Burgershot.Garage,
    Craft = {
        Position = Kipstz.Jobs.Burgershot.Craft,
        Items = {
            { name = "friesbox", label = "Frites", timer = 10, recipe = {
                { name = "patate", label = "Patate", amount = 1 },
                { name = "graisseafrites", label = "Graisse a Frites", amount = 1 },
            }},
            { name = "wrapp", label = "Wrap Poulet", timer = 10, recipe = {
                { name = "fajitas", label = "Fajitas", amount = 1 },
                { name = "poulet", label = "Poulet", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "oignon", label = "Oignon", amount = 1},
                { name = "cheddar", label = "Cheddar", amount = 1},
            }},
            { name = "goatcheesewrap", label = "Wrap Chèvre", timer = 10, recipe = {
                { name = "fajitas", label = "Fajitas", amount = 1 },
                { name = "poulet", label = "Poulet", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "oignon", label = "Oignon", amount = 1},
                { name = "chevre", label = "Chèvre", amount = 1},
            }},
            { name = "fishburger", label = "Fish Burger", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "poissonpane", label = "Poisson Pané", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "oignon", label = "Oignons", amount = 1},
                { name = "cheddar", label = "Cheddar", amount = 1},
            }},
            { name = "thegloriousburger", label = "Cheese Burger", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "steak", label = "Steak", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1 },
                { name = "oignon", label = "Oignons", amount = 1 },
                { name = "cheddar", label = "Cheddar", amount = 1 },
            }},
            { name = "doubleshotburger", label = "Double Cheese", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "steak", label = "Steak", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 2 },
                { name = "oignon", label = "Oignons", amount = 1 },
                { name = "cheddar", label = "Cheddar", amount = 2 },
            }},
            { name = "bleederburger", label = "Bleeder Burger", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "steak", label = "Steak", amount = 2 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1 },
                { name = "oignon", label = "Oignons", amount = 1 },
                { name = "cheddar", label = "Cheddar", amount = 1 },
            }},
            { name = "pricklyburger", label = "Prickly Burger", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "pouletpanefrit", label = "Poulet Pané frit", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "oignon", label = "Oignons", amount = 1},
                { name = "cheddar", label = "Cheddar", amount = 1},
            }},
            { name = "thefabulous6lbburger", label = "Fabulous Burger", timer = 10, recipe = {
                { name = "painburger", label = "Pain Burger", amount = 2 },
                { name = "steak", label = "Steak", amount = 6 },
                { name = "salade", label = "Salade", amount = 6 },
                { name = "tomate", label = "Tomate", amount = 6 },
                { name = "oignon", label = "Oignons", amount = 6 },
                { name = "cheddar", label = "Cheddar", amount = 6 },
            }},
            { name = "tacos", label = "Tacos", timer = 10, recipe = {
                { name = "fajitas", label = "Fajitas", amount = 1 },
                { name = "poulet", label = "Poulet", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "oignon", label = "Oignons", amount = 1},
            }},
            { name = "bssoda", label = "Soda", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "siropcola", label = "Sirop E-Cola", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
            }},
            { name = "Limonade", label = "Limonade", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "jusdecitron", label = "Jus de Citron", amount = 1 },
                { name = "lemon", label = "Citron", amount = 1 },
                { name = "menthe", label = "Menthe", amount = 1},
                { name = "glacon", label = "Glaçons", amount = 1},
            }},
            { name = "Jusdefruits", label = "Jus de fruits", timer = 10, recipe = {
                { name = "jusdorange", label = "Jus d'orange", amount = 1 },
                { name = "jusdananas", label = "Jus d'ananas", amount = 1 },
                { name = "jusdepomme", label = "Jus de pomme", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1}
            }},
            { name = "meteoriteicecream", label = "Meteorite Ice Cream", timer = 10, recipe = {
                { name = "chocolateicecream", label = "Glace Chocolat", amount = 1 },
                { name = "cacahuetes", label = "Cacahuetes", amount = 1 },
            }},
            { name = "orangotangicecream", label = "Orangotang Ice Cream", timer = 10, recipe = {
                { name = "vanilaicecream", label = "Glace Vanille", amount = 1 },
                { name = "coulischocolat", label = "Coulis de Chocolat", amount = 1 },
            }},
            { name = "granita", label = "Granita", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
                { name = "siropmyrtille", label = "Sirop de Myrtille", amount = 1},
            }},
            { name = "Milkshake", label = "Milkshake", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "vanille", label = "Vanille", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
                { name = "chantilly", label = "", amount = 1},
                { name = "", label = "Chantilly", amount = 1},
                { name = "", label = "", amount = 1},
            }},
            { name = "cookie", label = "Cookie", timer = 10, recipe = {
                { name = "egg", label = "Oeufs", amount = 1 },
                { name = "flour", label = "Farine", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
                { name = "pepitechocolat", label = "Pepite de Chocolat", amount = 1},
                { name = "butter", label = "Beurre", amount = 1},
                { name = "sel", label = "Sel", amount = 1},
            }},
        }
    }
})