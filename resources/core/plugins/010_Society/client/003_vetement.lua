local LastVetement = nil
local Items = {}
local DefaultCategory = "male"

---MenuConfig
local function MenuConfig()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 2,
            bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(VFW.PlayerData.job.name),
            buyText = "Récupérer",
        },
        eventName = "jobvetement",
        showStats = { show = false },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Homme", id = "male" },
                { label = "Femme", id = "female" },
            }
        },
        mouseEvents = true,
        color = { show = false },
        items = Items[DefaultCategory],
    }
    return data
end

RegisterNuiCallback(("nui:newgrandcatalogue:jobvetement:selectGridType"), function(data)
    if (VFW.PlayerData.skin.sex == 1 and DefaultCategory == "female") or (VFW.PlayerData.skin.sex == 0 and DefaultCategory == "male") then
        TriggerEvent('skinchanger:change', "shoes_1", data.chaussures)
        TriggerEvent('skinchanger:change', "shoes_2", data.varChaussures)
        TriggerEvent('skinchanger:change', "bags_1", data.sac)
        TriggerEvent('skinchanger:change', "bags_2", data.varSac)
        TriggerEvent('skinchanger:change', "decals_1", data.decals)
        TriggerEvent('skinchanger:change', "decals_2", data.varDecals)
        TriggerEvent('skinchanger:change', "pants_1", data.pantalon)
        TriggerEvent('skinchanger:change', "pants_2", data.varPantalon)
        TriggerEvent('skinchanger:change', "chain_1", data.chaine)
        TriggerEvent('skinchanger:change', "chain_2", data.varChaine)
        TriggerEvent('skinchanger:change', "torso_1", data.haut)
        TriggerEvent('skinchanger:change', "torso_2", data.varHaut)
        TriggerEvent('skinchanger:change', "tshirt_1", data.sousHaut)
        TriggerEvent('skinchanger:change', "tshirt_2", data.varSousHaut)
        TriggerEvent('skinchanger:change', "mask_1", data.mask)
        TriggerEvent('skinchanger:change', "mask_2", data.varMask)
        if data.gpb ~= 0 then
            TriggerEvent('skinchanger:change', "bproof_1", data.gpb)
            TriggerEvent('skinchanger:change', "bproof_2", data.varGpb)
        else
            TriggerEvent('skinchanger:change', "bproof_1", 0)
            TriggerEvent('skinchanger:change', "bproof_2", 0)
        end
        TriggerEvent('skinchanger:change', "arms", data.bras)
        TriggerEvent('skinchanger:change', "arms_2", data.varBras)
    else
        console.debug("Vous ne pouvez pas récupérer cet item")
    end
end)

RegisterNuiCallback(("nui:newgrandcatalogue:jobvetement:selectBuy"), function(data)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent("society:jobvetement:recupItem", {
            renamed = data.id,
            sex = skin.sex == 1 and "w" or "m",
            image = "",
            skin = {
                ['tshirt_1'] = skin["tshirt_1"],
                ['tshirt_2'] = skin["tshirt_2"],
                ['torso_1'] = skin["torso_1"],
                ['torso_2'] = skin["torso_2"],
                ['decals_1'] = skin["decals_1"],
                ['decals_2'] = skin["decals_2"],
                ['arms'] = skin["arms"],
                ['arms_2'] = skin["arms_2"],
                ['pants_1'] = skin["pants_1"],
                ['pants_2'] = skin["pants_2"],
                ['shoes_1'] = skin["shoes_1"],
                ['shoes_2'] = skin["shoes_2"],
                ['bags_1'] = skin['bags_1'],
                ['bags_2'] = skin['bags_2'],
                ['chain_1'] = skin['chain_1'],
                ['chain_2'] = skin['chain_2'],
                ['helmet_1'] = skin['helmet_1'],
                ['helmet_2'] = skin['helmet_2'],
                ['ears_1'] = skin['ears_1'],
                ['ears_2'] = skin['ears_2'],
                ['mask_1'] = skin['mask_1'],
                ['mask_2'] = skin['mask_2'],
                ['glasses_1'] = skin['glasses_1'],
                ['glasses_2'] = skin['glasses_2'],
                ['bproof_1'] = skin['bproof_1'],
                ['bproof_2'] = skin['bproof_2'],
            }
        })
    end)
    VFW.Nui.NewGrandMenu(false)
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    TriggerEvent('skinchanger:loadSkin', skin or {})
end)

RegisterNuiCallback("nui:newgrandcatalogue:jobvetement:selectHeadCategory", function(data)
    DefaultCategory = data
    VFW.Nui.UpdateNewGrandMenu(MenuConfig())
end)

RegisterNUICallback("nui:newgrandcatalogue:jobvetement:close", function()
    VFW.Nui.NewGrandMenu(false)
    local skin = TriggerServerCallback("vfw:skin:getPlayerSkin")
    TriggerEvent('skinchanger:loadSkin', skin or {})
end)

---JobVetementOpen
local function JobVetementOpen()
    if VFW.PlayerData.job.name ~= "unemployed" then
        VFW.Nui.NewGrandMenu(true, MenuConfig())
    end
end

---loadVetement
---@param job string
function Society.loadVetement(job)
    if LastVetement then
        Worlds.Zone.Remove(LastVetement)
        LastVetement = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Vetement then
        return
    end

    for k, v in pairs(Society.Jobs[job].Vetement.Items) do
        Items[k] = {}
        for _, item in pairs(v) do
            table.insert(Items[k], {
                label = item.id,
                model = item,
                image = "outfits_greenscreener/"..k.."/clothing/torso2/"..item.haut.."_"..item.varHaut..".webp",
                price = false,
                premium = false
            })
        end
    end
    
    LastVetement = VFW.CreateBlipAndPoint("society:vetement:"..job, Society.Jobs[job].Vetement.Position, 1, false, false, false, false, "Vestiaire", "E", "Casier", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            JobVetementOpen()
        end
    })
    return true
end
