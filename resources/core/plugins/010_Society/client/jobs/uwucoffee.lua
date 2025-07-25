while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["uwucoffee"] then return end
Society.newJob("uwucoffee", {
    Blips = BLK.Jobs.UwUCoffee.Blips,
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
    Sonnette = BLK.Jobs.UwUCoffee.Sonnette,
    Gestion = BLK.Jobs.UwUCoffee.Gestion,
    Stockage = BLK.Jobs.UwUCoffee.Stockage,
    Casier = BLK.Jobs.UwUCoffee.Casier,
    Catalogue = {
        Position = BLK.Jobs.UwUCoffee.Catalogue,
        Items = {
            { model = 'barbamilk' },
            --{ model = 'BubbleTea' },
            { model = 'CatPat' },
            { model = 'ChatGourmand' },
            { model = 'chatmallow' },
            { model = 'IceCoffee' },
            { model = 'laitlaitchaud' },
            { model = 'Milkshake' },
            { model = 'mochi' },
            { model = 'Pocky' },
            { model = 'UwUBurger' },
            { model = 'melto' },
            { model = 'lapinut' },
            { model = 'LatteMatcha' },
            { model = 'catnuts' },
            { model = 'Limonade' },
            { model = 'baosucre' },
            { model = 'kitty' }
        }
    },
    Vetement = BLK.Jobs.UwUCoffee.Vetement,
    Garage = BLK.Jobs.UwUCoffee.Garage,
    Craft = {
        Position = BLK.Jobs.UwUCoffee.Craft,
        Items = {
            { name = "barbamilk", label = "Barba Milk", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "fraise", label = "Fraise", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
                { name = "chantilly", label = "Chantilly", amount = 1}
            }},
            -- { name = "BubbleTea", label = "Bubble Tea", timer = 10, recipe = {
            --     { name = "tea", label = "Thé", amount = 1 },
            --     { name = "billemyrtille", label = "Bille Myrtille", amount = 1 },
            --     { name = "siropdeframboise", label = "Sirop De Framboise", amount = 1 },
            -- }},
            { name = "CatPat", label = "Cat Pat", timer = 10, recipe = {
                { name = "steak", label = "Steak", amount = 1 },
                { name = "salade", label = "Salade", amount = 1 },
                { name = "tomate", label = "Tomate", amount = 1 },
                { name = "fromage", label = "Fromage", amount = 1}
            }},

            { name = "ChatGourmand", label = "Chat Gourmand", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "biscuit", label = "Biscuit", amount = 1 },
                { name = "egg", label = "Oeufs", amount = 1 },
                { name = "bonbon", label = "Bonbon", amount = 1},
                { name = "fraise", label = "Fraise", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
            }},
            { name = "chatmallow", label = "Chat'Mallow", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "fraise", label = "Fraise", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
                { name = "chantilly", label = "Chantilly", amount = 1},
                { name = "pepitechocolat", label = "Pepite Chocolat", amount = 1},
                { name = "biscuitchat", label = "Biscuit Chat", amount = 1},
            }},
            { name = "IceCoffee", label = "IceCoffee", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "coffee", label = "Café", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
            }},
            { name = "laitlaitchaud", label = "Laitlait Chaud", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "biscuithi", label = "Biscuit Hi", amount = 1},
                { name = "biscuitchat", label = "Biscuit Chat", amount = 1},
                { name = "colorantrose", label = "Colorant Rose", amount = 1}
            }},
            { name = "Milkshake", label = "Milkshake", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "fraise", label = "Fraise", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
                { name = "chantilly", label = "Chantilly", amount = 1}
            }},
            { name = "mochi", label = "Mochi", timer = 10, recipe = {
                { name = "patederiz", label = "Pate de riz", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
                { name = "water", label = "Eau", amount = 1 },
                { name = "feculedemais", label = "Fécule de mais", amount = 1},
                { name = "colorantrose", label = "Colorant Rose", amount = 1},
            }},
            { name = "Pocky", label = "Pocky", timer = 10, recipe = {
                { name = "biscuitbaton", label = "Biscuit Bâton", amount = 1 },
                { name = "framboise", label = "Framboise", amount = 1 },
                { name = "colorantrose", label = "Colorant Rose", amount = 1 },
            }},
            { name = "UwUBurger", label = "UwU Burger", timer = 10, recipe = {
                { name = "mochi", label = "Mochi", amount = 1 },
                { name = "painburger", label = "Pain Burger", amount = 1 },
                { name = "steak", label = "Steak", amount = 1 },
                { name = "salade", label = "Salade", amount = 1},
                { name = "tomate", label = "Tomate", amount = 1},
                { name = "fromage", label = "Fromage", amount = 1}
            }},
            { name = "melto", label = "Melto", timer = 10, recipe = {
                { name = "salade", label = "Salade", amount = 1},
                { name = "chocolat", label = "Chocolat", amount = 1},
                { name = "bonbonenfleur", label = "Bonbon en Fleur", amount = 1 },
                { name = "fraise", label = "Fraise", amount = 1 },
                { name = "biscuitlapin", label = "Biscuit Lapin", amount = 1 },
                { name = "colorantrose", label = "colorantrose", amount = 1},
            }},
            { name = "lapinut", label = "Lapinut", timer = 10, recipe = {
                { name = "bonbon", label = "Bonbon", amount = 1 },
                { name = "mochi", label = "Mochi", amount = 1 },
            }},
            { name = "LatteMatcha", label = "Latte Matcha", timer = 10, recipe = {
                { name = "coffeelate", label = "Café Latte", amount = 1 },
                { name = "milk", label = "Lait", amount = 1 },
                { name = "matcha", label = "Matcha", amount = 1 },
            }},
            { name = "catnuts", label = "Catnuts", timer = 10, recipe = {
                { name = "flour", label = "Farine", amount = 1 },
                { name = "egg", label = "Oeufs", amount = 1 },
                { name = "levure", label = "Levure", amount = 1 },
                { name = "butter", label = "Beurre", amount = 1 },
                { name = "milk", label = "Lait", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
            }},
            { name = "Limonade", label = "Limonade", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "jusdecitron", label = "Jus De Citron", amount = 1 },
                { name = "lemon", label = "Citron", amount = 1 },
                { name = "menthe", label = "Menthe", amount = 1 },
                { name = "glacon", label = "Glaçons", amount = 1 },
            }},
            { name = "baosucre", label = "Bao Sucré", timer = 10, recipe = {
                { name = "pateabao", label = "Pâte a Bao", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
                { name = "jaunedoeuf", label = "Jaune d'oeuf", amount = 1 },
            }},
            { name = "kitty", label = "Kitty Toy Rose", timer = 10, recipe = {
                { name = "peluche", label = "Peluche", amount = 1 },
                { name = "colorantrose", label = "Colorant Rose", amount = 1 },
            }},
        }
    }
})