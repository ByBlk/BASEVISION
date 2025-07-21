local Items = {
    { label = "Batte de baseball",       price = 1015,  model = "weapon_bat",               premium = true },
    { label = "Clé anglaise",            price = 945,   model = "weapon_wrench",            premium = true },
    { label = "Club de golf",            price = 1015,  model = "weapon_golfclub",          premium = true },
    { label = "Couteau",                 price = 1225,  model = "weapon_knife",             premium = true },
    { label = "Pied de biche",           price = 1015,  model = "weapon_crowbar",           premium = true },
    { label = "Pelle",                   price = 945,   model = "weapon_pelle",             premium = true },
    { label = "Pioche",                  price = 945,   model = "weapon_pickaxe",           premium = true },
    { label = "Poing americain",         price = 2450,  model = "weapon_knuckle",           premium = true },
    { label = "Queue de billard",        price = 1015,  model = "weapon_poolcue",           premium = true },
    { label = "Extincteur",              price = 5250,  model = "weapon_fireextinguisher",  premium = true },
    { label = "Lampe",                   price = 700,   model = "weapon_flashlight",        premium = true },
    { label = "Marteau",                 price = 1015,  model = "weapon_hammer",            premium = true },
    { label = "Mousquet",                price = 8750,  model = "weapon_musket",            premium = true },
    { label = "Boite de munition (x30)", price = 300,   model = "ammo30",                   premium = true },
    { label = "Poignée d'arme",          price = 3150,  model = "components_grip",          premium = true },
    { label = "Silencieux",              price = 10500, model = "components_suppressor",    premium = true },
    { label = "Lampe torche Arme",       price = 4550,  model = "components_flashlight",    premium = true },
    { label = "Fusée de détresse",       price = 504,   model = "weapon_flare",             premium = true },
    { label = "Pistolet de détresse",    price = 4550,  model = "weapon_flaregun",          premium = true },
    { label = "Colt M45A1",              price = 23975, model = "weapon_heavypistol",       premium = true },
    { label = "H&K P7M10",               price = 11900, model = "weapon_snspistol",         premium = true },
    { label = "Beretta 92FS",            price = 3500,  model = "weapon_pistol",            premium = true },
    { label = "Glock 17",                price = 2450,  model = "weapon_combatpistol",      premium = true },
    { label = "Taurus Raging bull",      price = 29155, model = "weapon_revolver",          premium = true },
    { label = "FN Model 1922",           price = 14105, model = "weapon_vintagepistol",     premium = true },
}

RegisterNetEvent("vfw:ammu:buy", function(model)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    local price = 0
    local label = ""
    console.debug(source, model)

    for k,v in pairs(Items) do
        if model == v.model then
            price = v.price
            label = v.label
            break
        end
    end

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.createItem(model, 1)
        xPlayer.updateInventory()
        TriggerClientEvent("nui:newgrandmenu:notify", source, "vert", "Achat terminé", "~g~"..price.."$")
        logs.general.armurerieBuy(source, model, price)
    else
        TriggerClientEvent("nui:newgrandmenu:notify", source, "rouge", "Fonds insuffisants", "~r~"..price.."$")
    end
end)