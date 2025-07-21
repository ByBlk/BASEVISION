local DrugsConfig = {}

DrugsConfig.Khat = {
    label = "Khat",
    harvest = {
        positions = {
            vector3(2102.14, 5217.54, 55.79+1),
            vector3(2110.12, 5223.08, 56.1+1),
            vector3(2119.3, 5222.52, 56.73+1)
        },
        item = "khat",
        label = "Feuille de Khat",
        time = 5000, -- ms
        min = 3, -- quantité minimale récoltée
        max = 7  -- quantité maximale récoltée
    },
    process = {
        positions = {
            vector3(1500.0, 4500.0, 36.0),
            vector3(1400.0, 4400.0, 34.0),
            vector3(1300.0, 4300.0, 32.0)
        },
        itemIn = "khat",
        itemOut = "khat_traite",
        label = "Khat traité",
        time = 7000 -- ms
    }
}

exports("GetDrugsConfig", function()
    return DrugsConfig
end)
