local lastJob = nil

local function loadK9Menu()
    if not lastJob then return end

    local open = false
    local DOG_BREEDS = {
        'Rottweiler',
        'Husky',
        'Retriever',
        'Shepherd',
        'Berger',
        'Berger 2',
        'Berger LSFD',
        'Berger Civil',
        'Berger Civil 2'
    }
    local DOG_MODELS = {
        'a_c_rottweiler',
        'a_c_husky',
        'a_c_retriever',
        'a_c_shepherd',
        'a_c_berger',
        'a_c_berger1',
        'a_c_bergerlsfd',
        'a_c_bergerciv',
        'A_C_BergerCiv1'
    }
    local k9Dog = nil
    local k9DogName = nil
    local k9Blip = nil
    local currentDogIndex = 1
    local isAttacking = false
    local mainMenu = xmenu.create({ subtitle = "Actions Disponibles", banner = ("https://cdn.eltrane.cloud/alkiarp/assets/catalogues/headers/header_%s.webp"):format(lastJob) })

    local function ShowNotification(message, type)
        VFW.ShowNotification({
            type = type or 'INFO',
            content = message
        })
    end

    local function Command_Sit(ped)
        ClearPedTasks(ped)

        if not IsEntityPlayingAnim(ped, "creatures@rottweiler@amb@world_dog_sitting@idle_a", "idle_b", 3) then
            RequestAnimDict("creatures@rottweiler@amb@world_dog_sitting@idle_a")
            while not HasAnimDictLoaded("creatures@rottweiler@amb@world_dog_sitting@idle_a") do
                Wait(0)
            end
            TaskPlayAnim(ped, "creatures@rottweiler@amb@world_dog_sitting@idle_a", "idle_b", 8.0, -4.0, -1, 1, 0.0)
        end
    end

    local function Command_Stay(ped)
        ClearPedTasks(ped)
        RequestAnimDict("amb@lo_res_idles@")

        while not HasAnimDictLoaded("amb@lo_res_idles@") do
            Wait(0)
        end

        TaskPlayAnim(ped, "amb@lo_res_idles@", "creatures_world_rottweiler_standing_lo_res_base", 8.0, -4.0, -1, 1, 0.0)
    end

    local function Command_Paw(ped)
        ClearPedTasks(ped)
        RequestAnimDict("creatures@rottweiler@tricks@")

        while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
            Wait(0)
        end

        TaskPlayAnim(ped, "creatures@rottweiler@tricks@", "paw_right_loop", 8.0, -4.0, -1, 1, 0.0)
    end

    local function Command_Beg(ped)
        ClearPedTasks(ped)
        RequestAnimDict("creatures@rottweiler@tricks@")

        while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
            Wait(0)
        end

        TaskPlayAnim(ped, "creatures@rottweiler@tricks@", "beg_loop", 8.0, -4.0, -1, 1, 0.0)
    end

    local function Command_Follow(ped)
        ClearPedTasks(ped)
        DetachEntity(ped)
        TaskFollowToOffsetOfEntity(ped, VFW.PlayerData.ped, 0.5, 0.0, 0.0, 7.0, -1, 0.2, true)
    end

    local function Command_Bark(ped)
        ClearPedTasks(ped)

        if not IsEntityPlayingAnim(ped, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 3) then
            RequestAnimDict("creatures@rottweiler@amb@world_dog_barking@idle_a")
            while not HasAnimDictLoaded("creatures@rottweiler@amb@world_dog_barking@idle_a") do
                Wait(0)
            end

            TaskPlayAnim(ped, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 8.0, -4.0, -1, 1, 0.0)
        end
    end

    local function Command_Lay(ped)
        ClearPedTasks(ped)

        if not IsEntityPlayingAnim(ped, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 3) then
            RequestAnimDict("creatures@rottweiler@amb@sleep_in_kennel@")
            while not HasAnimDictLoaded("creatures@rottweiler@amb@sleep_in_kennel@") do
                Wait(0)
            end

            TaskPlayAnim(ped, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 8.0, -4.0, -1, 1, 0.0)
        end
    end

    local function Command_Attack(ped)
        DetachEntity(ped)
        local target = nil
        local selectedPlayer = VFW.StartSelect(5.0, true)

        if selectedPlayer ~= nil then
            target = GetPlayerPed(selectedPlayer)
        end

        ClearPedTasks(ped)

        if target and IsEntityAPed(target) then
            isAttacking = true
            TaskCombatPed(ped, target, 0, 16)

            CreateThread(function()
                while isAttacking and not IsPedDeadOrDying(target, true) do
                    SetPedMoveRateOverride(ped, 1.25)
                    Wait(0)
                end
            end)
        end
    end

    local function EnterVehicle(ped)
        if not IsPedInAnyVehicle(VFW.PlayerData.ped, false) then
            ShowNotification("Vous devez être dans un véhicule", "ROUGE")
            return
        end

        ClearPedTasks(ped)
        local vehicle = GetVehiclePedIsIn(VFW.PlayerData.ped, false)
        local vehHeading = GetEntityHeading(vehicle)

        TaskGoToEntity(ped, vehicle, -1, 0.5, 100, 1073741824, 0)
        TaskAchieveHeading(ped, vehHeading, -1)

        RequestAnimDict("creatures@rottweiler@in_vehicle@van")
        RequestAnimDict("creatures@rottweiler@amb@world_dog_sitting@base")

        while not HasAnimDictLoaded("creatures@rottweiler@in_vehicle@van") or
                not HasAnimDictLoaded("creatures@rottweiler@amb@world_dog_sitting@base") do
            Wait(0)
        end

        TaskPlayAnim(ped, "creatures@rottweiler@in_vehicle@van", "get_in", 8.0, -4.0, -1, 2, 0.0)
        Wait(700)
        ClearPedTasks(ped)
        AttachEntityToEntity(ped, vehicle, GetEntityBoneIndexByName(vehicle, "seat_pside_r"), 0.0, 0.0, 0.25)
        TaskPlayAnim(ped, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 8.0, -4.0, -1, 2, 0.0)
    end

    local function ExitVehicle(ped)
        local vehicle = GetEntityAttachedTo(ped)
        local vehPos = GetEntityCoords(vehicle)
        local forwardX = GetEntityForwardVector(vehicle).x * 3.7
        local forwardY = GetEntityForwardVector(vehicle).y * 3.7
        local _, groundZ = GetGroundZFor_3dCoord(vehPos.x, vehPos.y, vehPos.z, 0)

        ClearPedTasks(ped)
        DetachEntity(ped)
        SetEntityCoords(ped, vehPos.x - forwardX, vehPos.y - forwardY, groundZ)
        Command_Follow(ped)
    end

    local function DismissDog(ped)
        ClearPedTasks(ped)
        DeletePed(ped)
        RemoveBlip(k9Blip)

        k9Dog = nil
        k9DogName = nil
        k9Blip = nil
    end

    local function RefreshMenu()
        xmenu.items(mainMenu, function()
            if not k9Dog then
                addButton("Nom du chien", { rightLabel = k9DogName }, {
                    onSelected = function()
                        local result = VFW.Nui.KeyboardInput(true, "Nom du chien")
                        if result then
                            k9DogName = result
                        end
                    end
                })

                addList("Race du chien", DOG_BREEDS, currentDogIndex, {}, {
                    onChange = function(Index)
                        currentDogIndex = Index
                    end
                })

                addButton("Spawn le chien", {}, {
                    onSelected = function()
                        if not k9DogName then
                            ShowNotification("Vous devez donner un nom au chien !", "ROUGE")
                            return
                        end

                        local model = DOG_MODELS[currentDogIndex]
                        RequestModel(GetHashKey(model))
                        while not HasModelLoaded(GetHashKey(model)) do
                            Wait(0)
                        end

                        local pos = GetOffsetFromEntityInWorldCoords(VFW.PlayerData.ped, 0.0, 2.0, 0.0)
                        local heading = GetEntityHeading(VFW.PlayerData.ped)
                        local _, groundZ = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)

                        k9Dog = CreatePed(28, GetHashKey(model), pos.x, pos.y, groundZ, heading, true, true)

                        GiveWeaponToPed(k9Dog, GetHashKey('WEAPON_ANIMAL'), true, true)
                        SetBlockingOfNonTemporaryEvents(k9Dog, true)
                        SetPedFleeAttributes(k9Dog, 0, false)
                        SetPedCombatAttributes(k9Dog, 3, true)
                        SetPedCombatAttributes(k9Dog, 46, true)
                        SetPedCombatAttributes(k9Dog, 58, true)

                        k9Blip = AddBlipForEntity(k9Dog)
                        SetBlipAsFriendly(k9Blip, true)
                        SetBlipDisplay(k9Blip, 2)
                        SetBlipShowCone(k9Blip, true)
                        SetBlipAsShortRange(k9Blip, false)

                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(k9DogName)
                        EndTextCommandSetBlipName(k9Blip)

                        Command_Follow(k9Dog)

                        RefreshMenu()
                    end
                })
            else
                if IsPedDeadOrDying(k9Dog, true) then
                    ShowNotification(k9DogName .. " a été tué !", "JAUNE")
                    DismissDog(k9Dog)
                    return
                end

                addButton("Assis", {}, {
                    onSelected = function() Command_Sit(k9Dog) end
                })

                addButton("Suivre/Rappeler", {}, {
                    onSelected = function() Command_Follow(k9Dog) end
                })

                addButton("Pas bouger", {}, {
                    onSelected = function() Command_Stay(k9Dog) end
                })

                addButton("Aboyer", {}, {
                    onSelected = function() Command_Bark(k9Dog) end
                })

                addButton("Couché", {}, {
                    onSelected = function() Command_Lay(k9Dog) end
                })

                addButton("Réclamer", {}, {
                    onSelected = function() Command_Beg(k9Dog) end
                })

                addButton("Donner la patte", {}, {
                    onSelected = function() Command_Paw(k9Dog) end
                })

                addButton("Attaquer", {}, {
                    onSelected = function()
                        if isAttacking then
                            isAttacking = false
                            ClearPedTasksImmediately(k9Dog)
                        else
                            Command_Attack(k9Dog)
                        end
                    end
                })

                addButton("Entrer dans le véhicule", {}, {
                    onSelected = function()
                        EnterVehicle(k9Dog)
                    end
                })

                addButton("Sortir du véhicule", {}, {
                    onSelected = function()
                        ExitVehicle(k9Dog)
                    end
                })

                addButton("Despawn le chien", {}, {
                    onSelected = function()
                        DismissDog(k9Dog)
                        RefreshMenu()
                    end
                })
            end

            onClose(function()
                open = false
                xmenu.render(false)
            end)
        end)
    end

    RegisterKeyMapping("+OpenK9Menu", "Menu K9", "keyboard", "$")
    RegisterCommand("+OpenK9Menu", function()
        if VFW.PlayerData.job.onDuty and VFW.PlayerData.job.type == "faction" then
            if open then
                open = false
                xmenu.render(false)
            else
                open = true
                xmenu.render(mainMenu)
                RefreshMenu()
            end
        end
    end)
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    loadK9Menu()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then lastJob = nil end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadK9Menu()
end)
