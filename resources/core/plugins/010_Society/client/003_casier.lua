local ItemsProd = {}
local LastCasier = nil

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
            buyText = "Ouvrir",
        },
        cdnURL = "items",
        eventName = "jobcasier",
        showStats = { show = false },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Casiers", id = 1 },
            }
        },
        mouseEvents = false,
        color = { show = false },
        items = ItemsProd
    }
    console.debug(json.encode(data.items))
    return data
end

RegisterNuiCallback("nui:newgrandcatalogue:jobcasier:selectBuy", function(data)
    local action = TriggerServerCallback("society:jobcasier:openChest", data, VFW.PlayerData.job.name)
    if action.open then
        VFW.Nui.NewGrandMenu(false)
        VFW.OpenChest(action.id)
    end
end)

RegisterNUICallback("nui:newgrandcatalogue:jobcasier:close", function()
    VFW.Nui.NewGrandMenu(false)
end)

---JobCasierOpen
local function JobCasierOpen()
    if VFW.PlayerData.job.name ~= "unemployed" then
        VFW.Nui.NewGrandMenu(true, MenuConfig())
    end
end

---loadCasier
---@param job string
function Society.loadCasier(job)
    if LastCasier then
        Worlds.Zone.Remove(LastCasier)
        LastCasier = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Casier then
        return
    end

    table.remove(ItemsProd)

    for i = 1, tonumber(Society.Jobs[job].NumberCasier) do
        local tempCatalogue = {
            model = i,
            number = true,
            premium = false
        }
        table.insert(ItemsProd, tempCatalogue)
    end

    if type(Society.Jobs[job].Gestion) == "table" then
        for key, position in ipairs(Society.Jobs[job].Casier) do
            LastCasier = VFW.CreateBlipAndPoint("society:casier:"..job..key, position, 1, false, false, false, false, "Casier", "E", "Casier", {
                onPress = function()
                    if not VFW.PlayerData.job.onDuty then
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "~s Vous n'êtes pas en service"
                        })
                        return
                    end
                    JobCasierOpen()
                end
            })
        end
    else
        LastCasier = VFW.CreateBlipAndPoint("society:casier:"..job, Society.Jobs[job].Casier, 1, false, false, false, false, "Casier", "E", "Casier", {
            onPress = function()
                if not VFW.PlayerData.job.onDuty then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Vous n'êtes pas en service"
                    })
                    return
                end
                JobCasierOpen()
            end
        })
    end

    return true
end
