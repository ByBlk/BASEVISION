Citizen.CreateThread(function()
    while true do
        -- Configuration des NPC à pied
        SetPedDensityMultiplierThisFrame(Kipstz.NPCDensity.pedestrians) -- PNJ à pied
        SetScenarioPedDensityMultiplierThisFrame(Kipstz.NPCDensity.scenarios, Kipstz.NPCDensity.scenarios) -- Scénarios (PNJ statiques ou en animation)

        -- Configuration des véhicules
        SetVehicleDensityMultiplierThisFrame(Kipstz.NPCDensity.vehicles) -- Véhicules conduits par l'IA
        SetRandomVehicleDensityMultiplierThisFrame(Kipstz.NPCDensity.randomVehicles) -- Véhicules aléatoires
        SetParkedVehicleDensityMultiplierThisFrame(Kipstz.NPCDensity.parkedVehicles) -- Véhicules garés

        Wait(0)
    end
end)
