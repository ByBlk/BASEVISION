local Catalogue = {}
local Items = {}
local ItemsProd = {}

RegisterNetEvent("vfw:loadItems", function(myTableItems)
    Items = myTableItems
end)

---MenuConfig
---@param job string
local function MenuConfig(job)
    console.debug(("assets/catalogues/headers/header_%s.webp"):format(job))
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 1,
            buyType = 0,
            bannerImg = ("assets/catalogues/headers/header_%s.webp"):format(job),
        },
        eventName = "catalogue:produits",
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
        items = ItemsProd[job]
    }
    return data
end

RegisterNUICallback("nui:newgrandcatalogue:catalogue:produits:close", function()
    VFW.Nui.NewGrandMenu(false)
end)

---Open
---@param job string
local function Open(job)
    VFW.Nui.NewGrandMenu(true, MenuConfig(job))
end

---loadCatalogue
function Society.loadCatalogue()
    for _, job in pairs(Catalogue) do
        Worlds.Zone.Remove(job)
    end
    for job, config in pairs(Society.Jobs) do
        if config.Catalogue and not Catalogue[job] then
            Catalogue[job] = VFW.CreateBlipAndPoint("society:catalogue:"..job..":"..math.random(0, 100), config.Catalogue.Position, 1, false, false, false, false, "Catalogues", "E", "Catalogue", {
                onPress = function()
                    Open(job)
                end
            })
            if not ItemsProd[job] then ItemsProd[job] = {} end
            for k, v in pairs(config.Catalogue.Items) do
                if Items[v.model] then
                    local tempCatalogue = {
                        label = Items[v.model].label or v.model,
                        model = v.model,
                        image = "items/"..v.model..".webp",
                        price = VFW.Math.GroupDigits(Items[v.model].buyPrice or 0),
                        premium = false
                    }
                    table.insert(ItemsProd[job], tempCatalogue)
                else
                    console.error("Item not found ", v.model)
                end

            end
        end
    end
    return true
end