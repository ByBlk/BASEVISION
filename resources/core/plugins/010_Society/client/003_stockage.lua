local LastStockage = nil
local LastFactionStockage = nil

print("Loading Society Stockage")

---JobStockageOpen
---@param job string
local function JobStockageOpen(job)
    local action = TriggerServerCallback("society:jobstockage:openChest", job)
    if action.open then
        VFW.Nui.NewGrandMenu(false)
        VFW.OpenChest(action.id)
    end
end

---FactionStockageOpen
---@param faction string
local function FactionStockageOpen(faction)
    local action = TriggerServerCallback("society:factionstockage:openChest", faction)
    if action.open then
        VFW.Nui.NewGrandMenu(false)
        VFW.OpenChest(action.id)
    elseif action.message then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = action.message
        })
    end
end

---loadStockage
---@param job string
function Society.loadStockage(job)
    if LastStockage then
        console.debug("Removing LastStockage:", LastStockage)
        Worlds.Zone.Remove(LastStockage)
        LastStockage = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Stockage then
        return
    end
    LastStockage = VFW.CreateBlipAndPoint("society:stockage:"..job, Society.Jobs[job].Stockage, 1, false, false, false, false, "Stockage", "E", "Catalogue", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            JobStockageOpen(job)
        end
    })
    return true
end

---loadFactionStockage
---@param faction string
---@param position vector3
function Society.loadFactionStockage(faction, position)
    if LastFactionStockage then
        console.debug("Removing LastFactionStockage:", LastFactionStockage)
        Worlds.Zone.Remove(LastFactionStockage)
        LastFactionStockage = nil
    end
    
    local factionName = faction == "lspd" and "LSPD" or "LSSD"
    local blipColor = faction == "lspd" and 29 or 17
    
    LastFactionStockage = VFW.CreateBlipAndPoint("society:factionstockage:"..faction, position, 1, false, false, false, false, "Stockage " .. factionName, "E", "Catalogue", {
        onPress = function()
            if not VFW.PlayerData.job.onDuty then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous n'êtes pas en service"
                })
                return
            end
            FactionStockageOpen(faction)
        end
    })
    return true
end
