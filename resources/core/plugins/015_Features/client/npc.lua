Citizen.CreateThread(function()
    while true do
        -- Configuration des NPC à pied
        SetPedDensityMultiplierThisFrame(BLK.NPCDensity.pedestrians) -- PNJ à pied
        SetScenarioPedDensityMultiplierThisFrame(BLK.NPCDensity.scenarios, BLK.NPCDensity.scenarios) -- Scénarios (PNJ statiques ou en animation)

        -- Configuration des véhicules
        SetVehicleDensityMultiplierThisFrame(BLK.NPCDensity.vehicles) -- Véhicules conduits par l'IA
        SetRandomVehicleDensityMultiplierThisFrame(BLK.NPCDensity.randomVehicles) -- Véhicules aléatoires
        SetParkedVehicleDensityMultiplierThisFrame(BLK.NPCDensity.parkedVehicles) -- Véhicules garés

        Wait(0)
    end
end)
