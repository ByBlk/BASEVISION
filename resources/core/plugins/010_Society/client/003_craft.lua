local LastCraft = nil
local LastRecipe = nil

local function GetInventoryRecipe(Items)
    local filteredInventory = {}
    local addedItems = {}
    for _, mI in pairs(VFW.PlayerData.inventory) do
        for _, recipe in pairs(Items) do
            for _, item in pairs(recipe.recipe) do
                if mI.name == item.name and not addedItems[mI.name] then
                    table.insert(filteredInventory, { name = mI.name, label = VFW.Items[mI.name].label, amount = mI.count })
                    addedItems[mI.name] = true
                end
            end
        end
    end
    return filteredInventory
end

---JobCraftOpen
---@param job string
local function JobCraftOpen(Items)
    local filteredInventory = GetInventoryRecipe(Items)
    VFW.Nui.Craft(true, Items, filteredInventory)
end

RegisterNUICallback("nui:craft:close", function()
    VFW.Nui.Craft(false)
end)

RegisterNUICallback("nui:craft:craft", function(data, cb)
    local found = {}
    for _, mI in pairs(VFW.PlayerData.inventory) do
        for _, rI in pairs(data.recipe) do
            if mI.name == rI.name then
                if mI.count >= rI.amount * data.quantity then
                    table.insert(found, { name = rI.name, amount = rI.amount * data.quantity })
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Vous n'avez pas assez d'items"
                    })
                    cb(false)
                    return
                end
            end  
        end
    end
    TriggerServerEvent("society:craft:startLogs", data.name, data.quantity)
    cb(TriggerServerCallback("society:craft:removeitem", found))
    VFW.Nui.CraftUpdateInventory(GetInventoryRecipe(LastRecipe))
    return
end)

VFW.SetLastRecipe = function(recipe)
    LastRecipe = recipe
end

RegisterNUICallback("nui:craft:recup", function(data)
    for _, rI in pairs(LastRecipe) do
        if rI.name == data.name then
            TriggerServerEvent("society:craft:additem", data.name, data.quantity)
        end
    end
end)

---loadCraft
---@param job string
function Society.loadCraft(job)
    if LastCraft then
        console.debug("Removing LastCraft:", LastCraft)
        Worlds.Zone.Remove(LastCraft)
        LastCraft = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Craft then
        return
    end
    LastCraft = VFW.CreateBlipAndPoint("society:craft:"..job, Society.Jobs[job].Craft.Position, 1, false, false, false, false, "Craft", "E", "Catalogue", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            LastRecipe = Society.Jobs[job].Craft.Items
            JobCraftOpen(LastRecipe)
        end
    })
    return true
end
