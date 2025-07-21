local Catalogue = {}
local Items = {}
local ItemsFarm = {}
local Farm = {
    ["PostOP"] = {
        Position = vector3(-414.0172, -2800.0823, 6.0004),
        Blips = {
            sprite = 476, 
            color = 66, 
            scale = 0.8, 
            label = "Grossiste - PostOP"
        },
        Items = {
            { model = "4fromage", pack = 1 },
            { model = "aromefraise", pack = 1 },
            { model = "aromevanille", pack = 1 },
            { model = "baguette", pack = 6 },
            { model = "barbeapapa", pack = 50 },
            { model = "barbamilk", pack = 1 },
            { model = "bicarbonatedesodium", pack = 50 },
            { model = "billemyrtille", pack = 50 },
            { model = "bidon", pack = 1 },
            { model = "biscuithi", pack = 20 },
            { model = "biscuit", pack = 20 },
            { model = "biscuitbaton", pack = 20 },
            { model = "biscuitchat", pack = 20 },
            { model = "biscuitlapin", pack = 20 },
            { model = "blancdoeuf", pack = 1 },
            { model = "boite", pack = 10 },
            { model = "bonbon", pack = 50 },
            { model = "bonbonenfleur", pack = 1 },
            { model = "bouteille", pack = 1 },
            { model = "bouteillesdegaz", pack = 1 },
            { model = "bread", pack = 6 },
            { model = "burrata", pack = 3 },
            { model = "butter", pack = 25 },
            { model = "cacahuetes", pack = 15 },
            { model = "catnuts", pack = 1 },
            { model = "caramel", pack = 25 },
            { model = "cheddar", pack = 20 },
            { model = "chevre", pack = 10 },
            { model = "chiffon", pack = 5 },
            { model = "chocolat", pack = 10 },
            { model = "cleamolette", pack = 5 },
            { model = "co2", pack = 1 },
            { model = "coffee", pack = 6 },
            { model = "coffeelate", pack = 6 },
            { model = "colorantnoir", pack = 20 },
            { model = "colorantrose", pack = 20 },
            { model = "colorantviolet", pack = 20 },
            { model = "colle", pack = 25 },
            { model = "connecteurs", pack = 2 },
            { model = "confettiscomestible", pack = 1 },
            { model = "coffretoutils", pack = 5 },
            { model = "cornetdeglace", pack = 12 },
            { model = "cordes", pack = 1 },
            { model = "couverture", pack = 5 },
            { model = "coulischocolat", pack = 1 },
            { model = "crackers", pack = 20 },
            { model = "cremebalsamique", pack = 6 },
            { model = "cremedecoco", pack = 6 },
            { model = "cremeliquide", pack = 6 },
            { model = "cremefouette", pack = 6 },
            { model = "ecola", pack = 24 },
            { model = "egg", pack = 32 },
            { model = "entonoir", pack = 1 },
            { model = "essence", pack = 1 },
            { model = "etauavecmachoires", pack = 1 },
            { model = "eaupetillante", pack = 6 },
            { model = "fajitas", pack = 6 },
            { model = "feuillesdetabac", pack = 25 },
            { model = "fleurdesel", pack = 50 },
            { model = "fleurdoranger", pack = 15 },
            { model = "filtre", pack = 100 },
            { model = "fromage", pack = 20 },
            { model = "fromageblanc", pack = 20 },
            { model = "gelatin", pack = 50 },
            { model = "glacechocolat", pack = 25 },
            { model = "glacevanille", pack = 25 },
            { model = "glacon", pack = 100 },
            { model = "graisseafrites", pack = 6 },
            { model = "huile", pack = 6 },
            { model = "huilearachide", pack = 50 },
            { model = "huilehydraulique", pack = 5 },
            { model = "huilemoteur", pack = 5 },
            { model = "jaunedoeuf", pack = 25 },
            { model = "ketchup", pack = 10 },
            { model = "laitentier", pack = 6 },
            { model = "laitlaitchaud", pack = 1 },
            { model = "levure", pack = 50 },
            { model = "mascarpone", pack = 25 },
            { model = "matcha", pack = 50 },
            { model = "miel", pack = 10 },
            { model = "milk", pack = 6 },
            { model = "mozza", pack = 6 },
            { model = "moutarde", pack = 10 },
            { model = "painahotdog", pack = 10 },
            { model = "painburger", pack = 10 },
            { model = "paindemie", pack = 6 },
            { model = "paillettescomestible", pack = 100 },
            { model = "panure", pack = 50 },
            { model = "papier", pack = 50 },
            { model = "patate", pack = 10 },
            { model = "pateabao", pack = 50 },
            { model = "pateagauffre", pack = 50 },
            { model = "pateapizza", pack = 10 },
            { model = "patederiz", pack = 50 },
            { model = "pepitechocolat", pack = 10 },
            { model = "peinture", pack = 12 },
            { model = "pince", pack = 5 },
            { model = "pincecrocodile", pack = 5 },
            { model = "pincecoupante", pack = 5 },
            { model = "plaquenegatives", pack = 5 },
            { model = "plaquepositives", pack = 5 },
            { model = "polyurethane", pack = 5 },
            { model = "pompeavide", pack = 1 },
            { model = "produit", pack = 5 },
            { model = "sac", pack = 10 },
            { model = "saucecesar", pack = 6 },
            { model = "saucesoja", pack = 6 },
            { model = "sel", pack = 50 },
            { model = "separateurs", pack = 2 },
            { model = "siropcola", pack = 20 },
            { model = "siropsprunk", pack = 20 },
            { model = "siropdesurcre", pack = 20 },
            { model = "sodaaupamplemousse", pack = 6 },
            { model = "sprunk", pack = 24 },
            { model = "sucre", pack = 50 },
            { model = "baosucre", pack = 1 },
            { model = "sucrevanille", pack = 50 },
            { model = "tabasco", pack = 25 },
            { model = "tea", pack = 10 },
            { model = "tissu", pack = 20 },
            { model = "tournevis", pack = 5 },
            { model = "tube", pack = 100 },
            { model = "vanille", pack = 10 },
            { model = "valvedesurcharge", pack = 5 },
            { model = "ventouse", pack = 1 },
            { model = "vaporisateur", pack = 5 },
            { model = "vinaigrebalsamique", pack = 6 },
            { model = "water", pack = 6 },
            { model = "chantilly", pack = 6},
            { model = "CatPat", pack = 1}
        }
    },
    ["Légume"] = {
        Position = vector3(2310.51, 4884.92, 41.81),
        Blips = {
            sprite = 285, 
            color = 1, 
            scale = 0.8,
            label = "Grossiste - Légume"
        },
        Items = {
            { model = "ail", pack = 6 },
            { model = "cucumber", pack = 6 },
            { model = "echalotte", pack = 6 },
            { model = "oignon", pack = 6 },
            { model = "patate", pack = 1 },
            { model = "poivron", pack = 6 },
            { model = "salade", pack = 10 },
            { model = "saucetomate", pack = 6 },
            { model = "tomate", pack = 6 },
            { model = "tomatecerise", pack = 20 }
        }
    },
    ["Céréale"] = {
        Position = vector3(-2107.72, 7147.27, 29.47),
        Blips = {
            sprite = 285,
            color = 1,
            scale = 0.8,
            label = "Grossiste - Céréale"
        },
        Items = {
            { model = "cacao", pack = 50 },
            { model = "cereales", pack = 5 },
            { model = "cerealemalt", pack = 5 },
            { model = "cerealemaltcaramel", pack = 5 },
            { model = "cerealemaltpale", pack = 5 },
            { model = "cerealemalttorrefies", pack = 5 },
            { model = "cerealemalttourbe", pack = 5 },
            { model = "chapelure", pack = 50 },
            { model = "ciboulette", pack = 15 },
            { model = "coriandre", pack = 50 },
            { model = "feculedemais", pack = 50 },
            { model = "flour", pack = 50 },
            { model = "gingembre", pack = 15 },
            { model = "menthe", pack = 20 },
            { model = "persil", pack = 6 },
            { model = "poivre", pack = 50 },
            { model = "tabac", pack = 100 }
        }
    },
    ["Fruit"] = {
        Position = vector3(408.12, 6498.51, 27.77),
        Blips = {
            sprite = 133, 
            color = 47, 
            scale = 0.8,
            label = "Grossiste - Fruit"
        },
        Items = {
            { model = "banane", pack = 6 },
            { model = "cornichon", pack = 25 },
            { model = "coulisdeframboise", pack = 1 },
            { model = "fraise", pack = 10 },
            { model = "framboise", pack = 15 },
            { model = "goyave", pack = 6 },
            { model = "greenlemon", pack = 6 },
            { model = "jusdananas", pack = 24 },
            { model = "jusdecanne", pack = 24 },
            { model = "jusdecitron", pack = 20 },
            { model = "jusdekiwi", pack = 6 },
            { model = "jusdepomme", pack = 24 },
            { model = "jusdorange", pack = 24 },
            { model = "jusdecitron", pack = 20 },
            { model = "kiwi", pack = 6 },
            { model = "lemon", pack = 6 },
            { model = "mangue", pack = 6 },
            { model = "myrtille", pack = 15 },
            { model = "olive", pack = 25 },
            { model = "pasteque", pack = 5 },
            { model = "siropbanane", pack = 20 },
            { model = "siropdeframboise", pack = 20 },
            { model = "siropderose", pack = 20 },
            { model = "siropdecresise", pack = 20 },
            { model = "siropmyrtille", pack = 20 },
            { model = "siroporange", pack = 20 },
            { model = "siroppeche", pack = 20 }
        }
    },
    ["Viande"] = {
        Position = vector3(969.39, -2107.95, 31.48),
        Blips = {
            sprite = 119, 
            color = 50, 
            scale = 0.8,
            label = "Grossiste - Viande"
        },
        Items = {
            { model = "bacon", pack = 12 },
            { model = "canard", pack = 12 },
            { model = "chorizo", pack = 10 },
            { model = "foiegras", pack = 5 },
            { model = "jambon", pack = 12 },
            { model = "jambonbayonne", pack = 1 },
            { model = "pepperoni", pack = 20 },
            { model = "pulledpork", pack = 12 },
            { model = "ribs", pack = 12 },
            { model = "saucisse", pack = 10 },
            { model = "saucisson", pack = 6 },
            { model = "steak", pack = 10 }
        }
    },
    ["Volaille"] = {
        Position = vector3(-86.61, 6237.47, 31.09),
        Blips = {
            sprite = 119, 
            color = 50, 
            scale = 0.8,
            label = "Grossiste - Volaille"
        },
        Items = {
            { model = "poulet", pack = 4 },
            { model = "pouletpanefrit", pack = 25 },
        }
    },
    ["Vigneron"] = {
        Position = vector3(-1928.4, 1779.44, 173.09),
        Blips = {
          sprite = 93, 
          color = 24, 
          scale = 0.8,
          label = "Grossiste - Vigneron"
        },
        Items = {
            { model = "alcool", pack = 6 },
            { model = "cognac", pack = 6 },
            { model = "curacaoblue", pack = 6 },
            { model = "fraise", pack = 1 },
            { model = "gin", pack = 6 },
            { model = "jusderaisin", pack = 24 },
            { model = "liqueurdeframbroise", pack = 12 },
            { model = "liqueurdepeche", pack = 12 },
            { model = "liqueurfleurdesureau", pack = 12 },
            { model = "pinacolada", pack = 6 },
            { model = "porto", pack = 6 },
            { model = "raisinrouge", pack = 6 },
            { model = "raisinvert", pack = 6 },
            { model = "rhum", pack = 6 },
            { model = "rhumblanc", pack = 6 },
            { model = "roser", pack = 6 },
            { model = "tequila", pack = 5 },
            { model = "vinblanc", pack = 6 },
            { model = "vinrouge", pack = 6 },
            { model = "vodka", pack = 6 }
        }
    },
    ["Poissonnerie"] = {
        Position = vector3(615.15, -3201.92, 6.07),
        Blips = {
            sprite = 410, 
            color = 0, 
            scale = 0.8,
            label = "Grossiste - Poissonnerie"
        },
        Items = {
            { model = "poissonpane", pack = 12 },
            { model = "Moules", pack = 20 },
            { model = "esturgeons", pack = 1 },
            { model = "oeufsdecabillaud", pack = 20 }
        }
    },
    ["Ferronnerie"] = {
        Position = vector3(1070.82, -2006.23, 32.08),
        Blips = {
            sprite = 477, 
            color = 13, 
            scale = 0.8,
            label = "Grossiste - Ferronnerie"
        },
        Items = {
            { model = "lotdevis", pack = 5 },
            { model = "attelage", pack = 1 },
            { model = "barrederemorquage", pack = 1 },
            { model = "metal", pack = 3 },
            { model = "acier", pack = 3 },
            { model = "aluminium", pack = 5 },
            { model = "cuivre", pack = 3 },
            { model = "tigemetallique", pack = 12 },
            { model = "cylindre", pack = 5 },
            { model = "vis", pack = 50 },
            { model = "lames", pack = 2 },
            { model = "ressort", pack = 10 },
            { model = "mecanisme", pack = 1 },
            { model = "spiralesenalluminium", pack = 5 }
        }
    },
    ["Décharge"] = {
        Position = vector3(2340.8, 3128.03, 47.21),
        Blips = {
            sprite = 527, 
            color = 65, 
            scale = 0.8,
            label = "Grossiste - Décharge"
        },
        Items = {
            { model = "tuyau", pack = 5 },
            { model = "bouchon", pack = 8 },
            { model = "verre", pack = 1 },
            { model = "jointdecalage", pack = 10 },
            { model = "garniture", pack = 10 },
            { model = "caoutchouc", pack = 5 },
            { model = "plastique", pack = 3 },
            { model = "joint", pack = 50 },
            { model = "carton", pack = 50 }
        }
    }
}

RegisterNetEvent("vfw:loadItems", function(myTableItems)
    Items = myTableItems
end)

---MenuConfig
---@param farm string
local function MenuConfig(farm)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 5,
            buyType = 2,
            buyText = "Acheter",
            bannerImg = ("assets/catalogues/headers/header_%s.png"):format(farm),
        },
        eventName = "catalogue:farm",
        showStats = { show = false },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Catalogues", id = 1 },
            }
        },
        color = { show = false },
        items = ItemsFarm[farm]
    }
    
    return data
end

RegisterNUICallback("nui:newgrandcatalogue:catalogue:farm:selectBuy", function(data)
    local recu = {
        totalPrice = 0,
        item = {},
    }
    for _,item in pairs (data) do
        for _,v in pairs (ItemsFarm) do
            for _,v2 in pairs (v) do
                if v2.model == item then
                    local itemData = Items[item]
                    local price = itemData.data and itemData.data.buyPrice or 0
                    local pack = v2.pack or 1
                    local totalPrice = price * pack
                    local itemName = itemData.label or item
                    recu.totalPrice = recu.totalPrice + totalPrice
                    table.insert(recu.item, {
                        name = itemName,
                        model = item,
                        quantity = pack,
                        price = VFW.Math.GroupDigits(price),
                        type = itemName,
                    })
                end
            end
        end
    end
    TriggerServerEvent("catalogue:farm:buy", {
        title = "Achat de "..#data.." articles",
        employee = "Grossiste",
        customer = "Client",
        date = "10/10/2023",
        items = recu.item,
        reduce = 0,
        total = recu.totalPrice,
    }, recu.totalPrice, recu.item)
end)

RegisterNUICallback("nui:newgrandcatalogue:catalogue:farm:close", function()
    VFW.Nui.NewGrandMenu(false)
end)

---Open
---@param job string
local function Open(job)
    VFW.Nui.NewGrandMenu(true, MenuConfig(job))
end

---loadFarm
---@param job string
function Society.loadFarm(job)
    ItemsFarm = {}
    local itemnotfound = {}
    for _, v in pairs(Catalogue) do
        Worlds.Zone.Remove(v)
        Worlds.Blips.Remove(v)
    end
    if Society.Jobs[job] then
        for farmType, config in pairs(Farm) do
            Catalogue[farmType] = VFW.CreateBlipAndPoint("society:farm:"..farmType..":"..math.random(0, 100), config.Position, "society:farm:"..farmType..":"..math.random(0, 100), config.Blips.sprite, config.Blips.color, config.Blips.scale, config.Blips.label, "Grossiste", "E", "Stockage", {
                onPress = function()
                    Open(farmType)
                end
            })
            if not ItemsFarm[farmType] then ItemsFarm[farmType] = {} end
            for k,v in pairs(config.Items) do
                if Items[v.model] then
                    local price = Items[v.model].data and Items[v.model].data.buyPrice or 0
                    local tempCatalogue = {
                        label = Items[v.model].label .. " x"..v.pack,
                        model = v.model,
                        pack = v.pack,
                        image = "items/"..v.model..".webp",
                        price = VFW.Math.GroupDigits(price * v.pack),
                        premium = false
                    }
                    table.insert(ItemsFarm[farmType], tempCatalogue)
                else
                    table.insert(itemnotfound, v.model)
                end
            end
        end

        for k,v in pairs (itemnotfound) do
            console.debug("[^1ERROR^7] Item "..k.." not found in farm catalogue: ^1"..v)
        end
    end
    return true
end