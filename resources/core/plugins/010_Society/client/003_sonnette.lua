local Sonnettes = {}

print("Loading Society Sonnette...")

---loadSonnette
---@param job string
function Society.loadSonnette()
    for _, job in pairs(Sonnettes) do
        Worlds.Zone.Remove(job)
    end
    for job, config in pairs(Society.Jobs) do
        if config.Sonnette and not Sonnettes[job] then
            Sonnettes[job] = VFW.CreateBlipAndPoint("society:sonnette:"..job..":"..math.random(0, 100), config.Sonnette, 1, false, false, false, false, "Sonnette", "E", "Catalogue", {
                onPress = function()
                    TriggerServerEvent("society:sonnette:sonne", job)
                end
            })
        end
    end
    return true
end