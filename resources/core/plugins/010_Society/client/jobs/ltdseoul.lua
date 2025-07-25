while not ConfigManager do Wait(100) end
while not ConfigManager.Config.society do Wait(100) end
if not ConfigManager.Config.society["ltdseoul"] then return end
Society.newJob("ltdseoul", {
    Blips = BLK.Jobs.LTDSeoul.Blips,
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
    Sonnette = BLK.Jobs.LTDSeoul.Sonnette,
    Gestion = BLK.Jobs.LTDSeoul.Gestion,
    Stockage = BLK.Jobs.LTDSeoul.Stockage,
    Casier = BLK.Jobs.LTDSeoul.Casier,
    Catalogue = {
        Position = BLK.Jobs.LTDSeoul.Catalogue,
        Items = {
            { model = "triangle" },
            { model = "lollipop" },
            { model = "glace" },
            { model = "BarreCereale" },
            { model = "laitchoco" },
            { model = "eaupetillante" },
            { model = "Chips" },
            { model = "gauffre" },
            { model = "beer" },
            { model = "cigar" },
            { model = "cig" },
            { model = "blocnote" },
            { model = "umbrella" },
            { model = "pince" },
            { model = "scissors" },
            { model = "sac" },
            { model = "can" },
        }
    },
    Vetement = BLK.Jobs.LTDSeoul.Vetement,
    Craft = {
        Position = BLK.Jobs.LTDSeoul.Craft,
        Items = {
            { name = "triangle", label = "Sandwich Triangle", timer = 10, recipe = {
                { name = "paindemie", label = "pain de mie", amount = 1 },
                { name = "jambon", label = "Jambon", amount = 1 },
                { name = "fromage", label = "Fromage", amount = 1 },
                { name = "butter", label = "Beurre", amount = 1},
            }},
            { name = "lollipop", label = "Sucette", timer = 10, recipe = {
                { name = "sucre", label = "Sucre", amount = 1 },
                { name = "aromefraise", label = "arome fraise", amount = 1 },
                { name = "colorantrose", label = "colorantrose", amount = 1 },
            }},
            { name = "glace", label = "Glaces", timer = 10, recipe = {
                { name = "cornetdeglace", label = "Cornet de Glace", amount = 1 },
                { name = "cremeliquide", label = "Crème liquide", amount = 1 },
                { name = "aromevanille", label = "Arome vanille", amount = 1 },
            }},
            { name = "BarreCereale", label = "Barre de Cereale", timer = 10, recipe = {
                { name = "cereales", label = "Céréales", amount = 1 },
                { name = "milk", label = "Lait", amount = 1 },
                { name = "chocolat", label = "Chocolat", amount = 1 },
            }},
            { name = "laitchoco", label = "Lait au Chocolat", timer = 10, recipe = {
                { name = "milk", label = "Lait", amount = 1 },
                { name = "cacao", label = "Cacao", amount = 1 },
            }},
            { name = "eaupetillante", label = "Eau Petillante", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "bicarbonatedesodium", label = "Bicarbonate de Sodium", amount = 1 },
            }},
            { name = "Chips", label = "Chips", timer = 10, recipe = {
                { name = "patate", label = "Patate", amount = 1 },
                { name = "huilearachide", label = "Huile Arachide", amount = 1 },
                { name = "fleurdesel", label = "Fleur de Sel", amount = 1 },
            }},
            { name = "gauffre", label = "Gauffre", timer = 10, recipe = {
                { name = "pateagauffre", label = "Pate a Gdsauffre", amount = 1 },
                { name = "sucre", label = "Sucre", amount = 1 },
            }},
            { name = "beer", label = "Bière", timer = 10, recipe = {
                { name = "water", label = "Eau", amount = 1 },
                { name = "cerealemalt", label = "Céréales Malt", amount = 1 },
            }},
            { name = "cigar", label = "Cigar", timer = 10, recipe = {
                { name = "feuillesdetabac", label = "Feuilles de Tabac", amount = 1 },
            }},
            { name = "cig", label = "Cigarettes", timer = 10, recipe = {
                { name = "tabac", label = "Tabac", amount = 1 },
                { name = "filtre", label = "Filtre", amount = 1 },
                { name = "tube", label = "Tube", amount = 1 },
            }},
            { name = "blocnote", label = "Bloc note", timer = 10, recipe = {
                { name = "papier", label = "Papier", amount = 1 },
                { name = "spiralesenalluminium", label = "spirales en alluminium", amount = 1 },
                { name = "carton", label = "Carton", amount = 1 },
            }},
            { name = "umbrella", label = "Parapluie", timer = 10, recipe = {
                { name = "tissu", label = "Tissu", amount = 1 },
                { name = "ressort", label = "Ressort", amount = 1 },
                { name = "mecanisme", label = "Mécanisme", amount = 1 },
            }},
            { name = "pince", label = "Pince à cheveux", timer = 10, recipe = {
                { name = "ressort", label = "Ressort", amount = 1 },
                { name = "plastique", label = "Plastique", amount = 1 },
                { name = "metal", label = "Métal", amount = 1 },
            }},
            { name = "scissors", label = "Ciseaux", timer = 10, recipe = {
                { name = "lames", label = "Lames", amount = 2 },
                { name = "plastique", label = "Plastique", amount = 1 },
                { name = "vis", label = "Vis", amount = 1 },
            }},
            { name = "sac", label = "Sac", timer = 10, recipe = {
                { name = "tissu", label = "Tissu", amount = 1 },
            }},
            { name = "can", label = "Canette Vide", timer = 10, recipe = {
                { name = "aluminium", label = "Alluminium", amount = 1 },
                { name = "peinture", label = "Peinture", amount = 1 },
            }},
        }
    }
})