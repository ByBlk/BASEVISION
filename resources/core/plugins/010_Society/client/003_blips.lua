local Blips = {}
local AllBlips = {}

---loadBlips
function Society.loadBlips()
    for job, _ in pairs(Society.Jobs) do
        if Blips[job] then
            VFW.RemoveBlipInternal(Blips[job])
        end
    end
    for job, config in pairs(Society.Jobs) do
        if config.Blips then
            Blips[job] = VFW.CreateBlipInternal(config.Blips.Position, config.Blips.Sprite, config.Blips.Color, config.Blips.Scale, config.Blips.Name)
        end
    end
    return true
end

Blips.Map = {
  {name = "LSPD", color = 29, id = 60, pos = vector3(460.56, -986.13, 44.9)},
  {name = "Concessionnaire", color = 0, id = 225, pos = vector3(-42.5, -1094.41, 26.27)},
  {name = "SAMS", color = 1, id = 61, pos = vector3(318.08, -591.34, 42.28)},
  {name = "LSSD", color = 17, id = 60, pos = vector3(1819.18, 3673.95, 33.71)},
}

Citizen.CreateThread(function()
      Citizen.Wait(1000)
    for _,v in pairs(Blips.Map) do
        local blipMap = AddBlipForCoord(v.pos)
        SetBlipSprite(blipMap, v.id)
        SetBlipDisplay(blipMap, 4)
        SetBlipScale(blipMap, 0.8)
        SetBlipColour(blipMap, v.color)
        SetBlipAsShortRange(blipMap, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blipMap)
        SetBlipPriority(blipMap, 5)
    end
end)