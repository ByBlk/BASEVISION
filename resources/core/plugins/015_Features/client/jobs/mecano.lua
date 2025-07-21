function RepairVehicle()
    local vehicle = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped), 5.0, 0, 70)

    if VFW.PlayerData.job.onDuty then 
        if DoesEntityExist(vehicle) then
            local hasItem = TriggerServerCallback("core:mechanic:hasRepairKit")
    
            if hasItem then
                TaskStartScenarioInPlace(VFW.PlayerData.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                local duration = VFW.Nui.ProgressBar("Réparation en cours...", 10000)
    
                if duration then 
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    ClearPedTasksImmediately(VFW.PlayerData.ped)
                    
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Reparation terminée !"
                    })
                end
            else
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas de kit de réparation !"
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Aucun véhicule à proximité !"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end


function CleanVehicle()
    local vehicle = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped), 5.0, 0, 70)

    if VFW.PlayerData.job.onDuty then 
        if DoesEntityExist(vehicle) then 
            local hasItem = TriggerServerCallback("core:mechanic:hasCleanKit")
    
            if hasItem then 
                TaskStartScenarioInPlace(VFW.PlayerData.ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)
                local duration = VFW.Nui.ProgressBar("Nettoyage en cours...", 10000)
    
                if duration then 
                    SetVehicleDirtLevel(vehicle, 0.0)
                    ClearPedTasksImmediately(VFW.PlayerData.ped)
                    
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Nettoyage terminé !"
                    })
                end
            else
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas de kit de nettoyage !"
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Aucun véhicule à proximité !"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end

function RepairCarroserieVehicle()
    local vehicle = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped), 5.0, 0, 70)

    if VFW.PlayerData.job.onDuty then 
        if DoesEntityExist(vehicle) then 
            local hasItem = TriggerServerCallback("core:mechanic:hasCarroserieKit")
    
            if hasItem then 
                TaskStartScenarioInPlace(VFW.PlayerData.ped, "PROP_HUMAN_BUM_BIN", 0, true)
                local duration = VFW.Nui.ProgressBar("Réparation en cours...", 10000)
    
                if duration then 
                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    SetVehicleEngineOn(vehicle, true,  true)
                    ClearPedTasksImmediately(VFW.PlayerData.ped)
                    
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "Reparation terminée !"
                    })
                end
            else
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas de kit de carrosserie !"
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Aucun véhicule à proximité !"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end

function CrochetVehicle()
    local vehicle = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped), 5.0, 0, 70)

    if VFW.PlayerData.job.onDuty then
        local hasItem = TriggerServerCallback("core:mechanic:hasCrochetageKit")

        if hasItem then
            TaskStartScenarioInPlace(VFW.PlayerData.ped, "WORLD_HUMAN_WELDING", 0, true)
            local duration = VFW.Nui.ProgressBar("Crochetage en cours...", 10000)

            if duration then 
                SetVehicleDoorsLocked(vehicle, 1)
                ClearPedTasksImmediately(VFW.PlayerData.ped)

                VFW.ShowNotification({
                    type = 'VERT',
                    content = "Crochetage terminé !"
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas de kit de crochetage !"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end

function PoundVehicle()
    local vehicle = GetClosestVehicle(GetEntityCoords(VFW.PlayerData.ped), 5.0, 0, 70)

    if VFW.PlayerData.job.onDuty then
        if DoesEntityExist(vehicle) then 
            TaskStartScenarioInPlace(VFW.PlayerData.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
            
            local duration = VFW.Nui.ProgressBar("Mise en fourrière en cours...", 10000)

            if duration then
                TriggerServerEvent("vfw:vehicle:keyTemporarly:remove", nil, VFW.Math.Trim(GetVehicleNumberPlateText(vehicle)))
                VFW.Game.DeleteVehicle(vehicle)
                ClearPedTasksImmediately(VFW.PlayerData.ped)

                VFW.ShowNotification({
                    type = 'VERT',
                    content = "Véhicule mis en fourrière !"
                })
            end
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Aucun véhicule à proximité !"
            })
        end
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
    end
end