PawnshopConfig = {
    ped = {
        model = "s_m_m_highsec_01",
        coords = vector4(716.7160, -654.6350, 27.7838, 271.7490),
        scenario = "WORLD_HUMAN_CLIPBOARD"
    },

    items = {
        ["jewel"] = { price = 150, label = "Bijoux" },
        ["perfume"] = { price = 80, label = "Parfum" },
        ["enceinte"] = { price = 120, label = "Enceinte" },
        ["manettejv"] = { price = 90, label = "Manette de jeu" },
        ["weapon_bouteille"] = { price = 25, label = "Bouteille cassée" },
        ["guitar"] = { price = 200, label = "Guitare" },
        ["bouteille2"] = { price = 15, label = "Bouteille" },
        ["champagne_pack"] = { price = 180, label = "Pack champagne" },
        ["cig"] = { price = 20, label = "Cigarette" },
        ["can"] = { price = 10, label = "Canette" },
        ["penden"] = { price = 250, label = "Pendentif" },
        ["penden2"] = { price = 300, label = "Pendentif rare" },
        ["pince"] = { price = 60, label = "Pince" },
    },

    interaction = {
        distance = 2.0,
        key = "E",
        text = "Échanger des objets",
        icon = "Pawnshop"
    },

    messages = {
        noItems = "Vous n'avez aucun objet à échanger.",
        exchangeSuccess = "Échange effectué ! Vous avez reçu ~g~$%d~w~.",
        exchangeFailed = "Échange échoué.",
        notEnoughSpace = "Vous n'avez pas assez de place dans votre inventaire.",
        infoTitle = "Pawnshop",
        infoDescription = "Échangez vos objets volés contre de l'argent.",
        menuTitle = "Pawnshop - Échange d'objets",
        confirmExchange = "Confirmer l'échange",
        cancelExchange = "Annuler",
        totalLabel = "Total: ~g~$%d~w~",
        itemsToExchange = "Objets à échanger: %s"
    },

    ui = {
        colors = {
            success = "#4CAF50",
            error = "#F44336",
            warning = "#FF9800",
            info = "#2196F3",
            money = "#4CAF50",
            item = "#FFC107"
        },
        icons = {
            pawnshop = "Pawnshop",
            money = "Money",
            exchange = "Exchange"
        }
    },

    notifications = {
        success = {
            type = "SUCCES",
            title = "Pawnshop"
        },
        error = {
            type = "ROUGE",
            title = "Pawnshop"
        }
    }
}

function GetPawnshopItemPrice(itemName)
    if PawnshopConfig.items[itemName] then
        return PawnshopConfig.items[itemName].price
    end
    return 0
end

function GetPawnshopItemLabel(itemName)
    if PawnshopConfig.items[itemName] then
        return PawnshopConfig.items[itemName].label
    end
    return itemName
end

function GetPawnshopConfig()
    return PawnshopConfig
end

function UpdatePawnshopConfig(newConfig)
    if newConfig and type(newConfig) == "table" then
        for key, value in pairs(newConfig) do
            if PawnshopConfig[key] then
                PawnshopConfig[key] = value
            end
        end
        return true
    end
    return false
end

function AddPawnshopItem(itemName, price, label)
    if itemName and price and label then
        PawnshopConfig.items[itemName] = {
            price = price,
            label = label
        }
        return true
    end
    return false
end

function RemovePawnshopItem(itemName)
    if itemName and PawnshopConfig.items[itemName] then
        PawnshopConfig.items[itemName] = nil
        return true
    end
    return false
end

function UpdatePawnshopItemPrice(itemName, newPrice)
    if itemName and PawnshopConfig.items[itemName] and newPrice then
        PawnshopConfig.items[itemName].price = newPrice
        return true
    end
    return false
end

function CanExchangeItem(itemName)
    return PawnshopConfig.items[itemName] ~= nil
end

function CalculateExchangeTotal(inventory)
    local total = 0
    local itemsToExchange = {}
    
    for i = 1, #inventory do
        local item = inventory[i]
        if CanExchangeItem(item.name) then
            local itemPrice = GetPawnshopItemPrice(item.name)
            local itemTotal = item.count * itemPrice
            total = total + itemTotal
            
            table.insert(itemsToExchange, {
                name = item.name,
                label = GetPawnshopItemLabel(item.name),
                count = item.count,
                price = itemPrice,
                total = itemTotal
            })
        end
    end
    
    return total, itemsToExchange
end

exports("GetPawnshopConfig", GetPawnshopConfig)
exports("UpdatePawnshopConfig", UpdatePawnshopConfig)
exports("AddPawnshopItem", AddPawnshopItem)
exports("RemovePawnshopItem", RemovePawnshopItem)
exports("UpdatePawnshopItemPrice", UpdatePawnshopItemPrice)
exports("GetPawnshopItemPrice", GetPawnshopItemPrice)
exports("GetPawnshopItemLabel", GetPawnshopItemLabel)
exports("CanExchangeItem", CanExchangeItem)
exports("CalculateExchangeTotal", CalculateExchangeTotal) 