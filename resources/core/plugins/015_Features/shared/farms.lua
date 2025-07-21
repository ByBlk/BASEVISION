Config = Config or {}
Config.Farms = {
    ["skyblue"] = {
        recolte = {
            {
                label = "Récolte de raisin",
                coords = vector3(1999.8462, 4995.5508, 41.370),
                item = "bread",
                amount = 1,
                time = 2000,
                icon = "recolte"
            }
        },
        traitement = {
            {
                label = "Pressage du raisin",
                coords = vector3(2100.0, 5100.0, 45.0),
                itemIn = "bread",
                itemOut = "water",
                amount = 1,
                time = 3000,
                icon = "traitement"
            }
        },
        vente = {
            {
                label = "Vente de jus",
                coords = vector3(2199.7712, 5198.0654, 61.1029),
                item = "water",
                price = 50,
                amount = 1,
                time = 1000,
                icon = "vente"
            }
        }
    }
} 