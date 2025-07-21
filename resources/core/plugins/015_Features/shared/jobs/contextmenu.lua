VFW.Jobs.ContextMenu = {
    lspd = {
        veh = {
            { label = "Crocheter", callback = function(vehicle) VFW.Jobs.HookVehicle(vehicle) end },
            { label = "Inspecter", callback = function(vehicle) VFW.Jobs.InfoVeh(vehicle) end },
            { label = "Immatriculation", callback = function(vehicle) VFW.Jobs.GetVehiclePlate(vehicle) end },
            { label = "Sortir l'individu", callback = function()
                if VFW.Jobs.GetInVehicle() then
                    VFW.Jobs.OutVehicle()
                end
            end },
            { label = "Fourrière", callback = function(vehicle) VFW.Jobs.SetVehicleInFourriere(vehicle) end, style = { color = { 255, 100, 100 }}},
        },
        ped = {
            { label = "Vérifier l'identité", callback = function(ped) VFW.Jobs.GetPatientIdentityCard(ped) end },
            { label = "Fouiller", callback = function(ped) VFW.OpenShearch(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))) end },
            { label = "Menotter", callback = function(ped) VFW.Jobs.Cuff(ped, true) end },
            { label = "Démenotter", callback = function(ped) VFW.Jobs.Cuff(ped, false) end },
            { label = "Gérer les permis", callback = function(ped) console.debug("Gérer les permis") end },
            { label = "Déplacer", callback = function(ped)
                if not VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort(ped)
                end
            end },
        },
        world = {
            { label = "Déplacer", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort()
                end
            end },
            { label = "Mettre dans le véhicule", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.InVehicle()
                end
            end },
        }
    },

    lssd = {
        veh = {
            { label = "Crocheter", callback = function(vehicle) VFW.Jobs.HookVehicle(vehicle) end },
            { label = "Inspecter", callback = function(vehicle) VFW.Jobs.InfoVeh(vehicle) end },
            { label = "Immatriculation", callback = function(vehicle) VFW.Jobs.GetVehiclePlate(vehicle) end },
            { label = "Sortir l'individu", callback = function()
                if VFW.Jobs.GetInVehicle() then
                    VFW.Jobs.OutVehicle()
                end
            end },
            { label = "Fourrière", callback = function(vehicle) VFW.Jobs.SetVehicleInFourriere(vehicle) end, style = { color = { 255, 100, 100 }}},
        },
        ped = {
            { label = "Vérifier l'identité", callback = function(ped) VFW.Jobs.GetPatientIdentityCard(ped) end },
            { label = "Fouiller", callback = function(ped) VFW.OpenShearch(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))) end },
            { label = "Menotter", callback = function(ped) VFW.Jobs.Cuff(ped, true) end },
            { label = "Démenotter", callback = function(ped) VFW.Jobs.Cuff(ped, false) end },
            { label = "Gérer les permis", callback = function(ped) console.debug("Gérer les permis") end },
            { label = "Déplacer", callback = function(ped)
                if not VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort(ped)
                end
            end },
        },
        world = {
            { label = "Déplacer", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort()
                end
            end },
            { label = "Mettre dans le véhicule", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.InVehicle()
                end
            end },
        }
    },

    sams = {
        ped = {
            { label = "Vérifier l'identité", callback = function(ped) VFW.Jobs.GetPatientIdentityCard(ped) end },
            { label = "Soigner", callback = function(ped) VFW.Jobs.HealthPatient(ped) end },
            { label = "Identification coma", callback = function(ped) VFW.Jobs.IdentificationComa(ped) end },
            { label = "Réanimer", callback = function(ped) VFW.Jobs.RevivePatient(ped) end },
            { label = "Facture", callback = function(ped)console.debug("Facture")  end },
            { label = "Fouiller", callback = function(ped) VFW.OpenShearch(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))) end },
        },
    },

    lsfd = {
        ped = {
            { label = "Vérifier l'identité", callback = function(ped) VFW.Jobs.GetPatientIdentityCard(ped) end },
            { label = "Soigner", callback = function(ped) VFW.Jobs.HealthPatient(ped) end },
            { label = "Identification coma", callback = function(ped) VFW.Jobs.IdentificationComa(ped) end },
            { label = "Réanimer", callback = function(ped) VFW.Jobs.RevivePatient(ped) end },
            { label = "Facture", callback = function(ped)console.debug("Facture")  end },
            { label = "Fouiller", callback = function(ped) VFW.OpenShearch(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))) end },
        },
    },

    usss = {
        veh = {
            { label = "Crocheter", callback = function(vehicle) VFW.Jobs.HookVehicle(vehicle) end },
            { label = "Inspecter", callback = function(vehicle) VFW.Jobs.InfoVeh(vehicle) end },
            { label = "Immatriculation", callback = function(vehicle) VFW.Jobs.GetVehiclePlate(vehicle) end },
            { label = "Sortir l'individu", callback = function()
                if VFW.Jobs.GetInVehicle() then
                    VFW.Jobs.OutVehicle()
                end
            end },
            { label = "Fourrière", callback = function(vehicle) VFW.Jobs.SetVehicleInFourriere(vehicle) end, style = { color = { 255, 100, 100 }}},
        },
        ped = {
            { label = "Vérifier l'identité", callback = function(ped) VFW.Jobs.GetPatientIdentityCard(ped) end },
            { label = "Fouiller", callback = function(ped) VFW.OpenShearch(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))) end },
            { label = "Menotter", callback = function(ped) VFW.Jobs.Cuff(ped, true) end },
            { label = "Démenotter", callback = function(ped) VFW.Jobs.Cuff(ped, false) end },
            { label = "Gérer les permis", callback = function(ped) console.debug("Gérer les permis") end },
            { label = "Déplacer", callback = function(ped)
                if not VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort(ped)
                end
            end },
        },
        world = {
            { label = "Déplacer", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.Escort()
                end
            end },
            { label = "Mettre dans le véhicule", callback = function()
                if VFW.Jobs.GetEscort() then
                    VFW.Jobs.InVehicle()
                end
            end },
        }
    },

    bennys = {
        veh = {
            { label = "Nettoyer", callback = function(vehicle)  CleanVehicle() end },
            { label = "Réparer la Carrosserie", callback = function(vehicle) RepairCarroserieVehicle() end },
            { label = "Réparer le Moteur", callback = function(vehicle) RepairVehicle() end },
            { label = "Crocheter", callback = function(vehicle) CrochetVehicle() end },
            { label = "Mettre en fourrière", callback = function(vehicle) PoundVehicle() end, style = { color = { 255, 100, 100 }} },
        },
        ped = {
            { label = "Facture", callback = function(ped) console.debug("Facture to :"..ped) end },
        }
    },

    autoexotic = {
        veh = {
            { label = "Nettoyer", callback = function(vehicle)  CleanVehicle() end },
            { label = "Réparer la Carrosserie", callback = function(vehicle) RepairCarroserieVehicle() end },
            { label = "Réparer le Moteur", callback = function(vehicle) RepairVehicle() end },
            { label = "Crocheter", callback = function(vehicle) CrochetVehicle() end },
            { label = "Mettre en fourrière", callback = function(vehicle) PoundVehicle() end, style = { color = { 255, 100, 100 }} },
        },
        ped = {
            { label = "Facture", callback = function(ped) console.debug("Facture to :"..ped) end },
        }
    },


    beekers = {
        veh = {
            { label = "Nettoyer", callback = function(vehicle)  CleanVehicle() end },
            { label = "Réparer la Carrosserie", callback = function(vehicle) RepairCarroserieVehicle() end },
            { label = "Réparer le Moteur", callback = function(vehicle) RepairVehicle() end },
            { label = "Crocheter", callback = function(vehicle) CrochetVehicle() end },
            { label = "Mettre en fourrière", callback = function(vehicle) PoundVehicle() end, style = { color = { 255, 100, 100 }} },
        },
        ped = {
            { label = "Facture", callback = function(ped) print("Facture to :"..ped) end },
        }
    },

    harmony = {
        veh = {
            { label = "Nettoyer", callback = function(vehicle)  CleanVehicle() end },
            { label = "Réparer la Carrosserie", callback = function(vehicle) RepairCarroserieVehicle() end },
            { label = "Réparer le Moteur", callback = function(vehicle) RepairVehicle() end },
            { label = "Crocheter", callback = function(vehicle) CrochetVehicle() end },
            { label = "Mettre en fourrière", callback = function(vehicle) PoundVehicle() end, style = { color = { 255, 100, 100 }} },
        },
        ped = {
            { label = "Facture", callback = function(ped) print("Facture to :"..ped) end },
        }
    },

    hayes = {
        veh = {
            { label = "Nettoyer", callback = function(vehicle)  CleanVehicle() end },
            { label = "Réparer la Carrosserie", callback = function(vehicle) RepairCarroserieVehicle() end },
            { label = "Réparer le Moteur", callback = function(vehicle) RepairVehicle() end },
            { label = "Crocheter", callback = function(vehicle) CrochetVehicle() end },
            { label = "Mettre en fourrière", callback = function(vehicle) PoundVehicle() end, style = { color = { 255, 100, 100 }} },
        },
        ped = {
            { label = "Facture", callback = function(ped) print("Facture to :"..ped) end },
        }
    },
}
