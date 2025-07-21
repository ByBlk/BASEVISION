local translateSkin = {
    ["bottom"] = {
        "pants_1",
        "pants_2"
    },
    ["shoe"] = {
        "shoes_1",
        "shoes_2"
    },
    ["hat"] = {
        "helmet_1",
        "helmet_2"
    },
    ["glasses"] = {
        "glasses_1",
        "glasses_2"
    },
    ["bag"] = {
        "bags_1",
        "bags_2"
    },
    ["necklace"] = {
        "chain_1",
        "chain_2"
    },
    ["watch"] = {
        "watches_1",
        "watches_2"
    },
    ["mask"] = {
        "mask_1",
        "mask_2"
    },
    ["bracelet"] = {
        "bracelets_1",
        "bracelets_2"
    },
    ["earring"] = {
        "ears_1",
        "ears_2"
    },
    ["piercing"] = {
        "decals_1",
        "decals_2"
    },
    ["nails"] = {
        "decals_1",
        "decals_2"
    },
    -- ring ??
    -- bracelet ??
    -- earring ??
}
local nakedSkin = {
    ["m"] = {
        ["arms"] = 15,
        ["arms_2"] = 0,
        ["torso_1"] = 15,
        ["torso_2"] = 0,
        ["tshirt_1"] = 15,
        ["tshirt_2"] = 0,
        ["pants_1"] = 61,
        ["pants_2"] = 0,
        ["shoes_1"] = 34,
        ["shoes_2"] = 0,
        ["bproof_1"] = 0,
        ["bproof_2"] = 0,
        ["decals_1"] = 0,
        ["decals_2"] = 0,
        ["watches_1"] = -1,
        ["watches_2"] = -1,
        ["glasses_1"] = -1,
        ["chain_1"] = -1,
        ["chain_2"] = -1,
        ["bags_1"] = -1,
        ["bags_2"] = -1,
        ["helmet_1"] = -1,
        ["helmet_2"] = -1,
        ["bracelets_1"] = -1,
        ["bracelets_2"] = -1,
        ["ears_1"] = -1,
        ["ears_2"] = -1,
    },
    ["w"] = {
        ["arms"] = 15,
        ["arms_2"] = 0,
        ["torso_1"] = 15,
        ["torso_2"] = 0,
        ["tshirt_1"] = 15,
        ["tshirt_2"] = 0,
        ["pants_1"] = 15,
        ["pants_2"] = 0,
        ["shoes_1"] = 35,
        ["shoes_2"] = 0,
        ["bproof_1"] = 0,
        ["bproof_2"] = 0,
        ["decals_1"] = 0,
        ["decals_2"] = 0,
        ["watches_1"] = -1,
        ["watches_2"] = -1,
        ["glasses_1"] = -1,
        ["chain_1"] = -1,
        ["chain_2"] = -1,
        ["bags_1"] = -1,
        ["bags_2"] = -1,
        ["helmet_1"] = -1,
        ["helmet_2"] = -1,
        ["bracelets_1"] = -1,
        ["bracelets_2"] = -1,
        ["ears_1"] = -1,
        ["ears_2"] = -1,
    }
}

GetClothes = {
    ["bottom"] = false,
    ["shoe"] = false,
    ["hat"] = false,
    ["glasses"] = false,
    ["bag"] = false,
    ["necklace"] = false,
    ["watch"] = false,
    ["mask"] = false,
    ["bracelet"] = false,
    ["earring"] = false,
    ["piercing"] = false,
    ["nails"] = false,
    ["ring"] = false,
    ["outfit"] = false,
    ["top"] = false
}

RegisterNetEvent('vfw:clothes', function(itemName, meta)
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")

    if itemName ~= "outfit" and itemName ~= "top" then
        local typeItem = meta.type and meta.type or itemName
        
        if (skin[translateSkin[typeItem][1]] == meta.id) and (skin[translateSkin[typeItem][2]] == meta.var) then
            skin[translateSkin[typeItem][1]] = nakedSkin[meta.sex][translateSkin[typeItem][1]]
            skin[translateSkin[typeItem][2]] = nakedSkin[meta.sex][translateSkin[typeItem][2]]
            TriggerEvent("skinchanger:change", translateSkin[typeItem][1], nakedSkin[meta.sex][translateSkin[typeItem][1]])
            TriggerEvent("skinchanger:change", translateSkin[typeItem][2], nakedSkin[meta.sex][translateSkin[typeItem][2]])
            GetClothes[itemName] = false
        else
            skin[translateSkin[typeItem][1]] = meta.id
            skin[translateSkin[typeItem][2]] = meta.var
            TriggerEvent("skinchanger:change", translateSkin[typeItem][1], meta.id)
            TriggerEvent("skinchanger:change", translateSkin[typeItem][2], meta.var)
            GetClothes[itemName] = true
        end
    else
        local change = true
        for k, v in pairs(meta.skin) do
            if skin[k] ~= v then
                change = false
                break
            end
        end

        if change then
            if itemName == "outfit" then
                for k, v in pairs(nakedSkin[meta.sex]) do
                    skin[k] = v
                    TriggerEvent("skinchanger:change", k, v)
                    GetClothes[itemName] = false
                end
            else
                for k, v in pairs(meta.skin) do
                    skin[k] = nakedSkin[meta.sex][k]
                    TriggerEvent("skinchanger:change", k, nakedSkin[meta.sex][k])
                    GetClothes[itemName] = false
                end
            end
        else
            for k, v in pairs(meta.skin) do
                skin[k] = v
                TriggerEvent("skinchanger:change", k, v)
                GetClothes[itemName] = true
            end
        end
    end

    TriggerServerEvent("vfw:skin:save", skin)
end)
