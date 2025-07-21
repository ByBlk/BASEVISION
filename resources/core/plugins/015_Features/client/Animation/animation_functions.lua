local prop = {}
local lastEmote = {}
local clonePed = nil
local zoom = false
local id = 0
local lastAnimation = nil
local currentAction = {} -- Suivi des actions en cours par ped
local currentAnimationPlayed = nil
local currentAnimDict = nil
local emoteSelect = false
local previewMode = false
local function CleanUpProps(ped)
    if not ped or not prop[ped] then
        return
    end

    currentAction[ped] = 'cleaning'

    for i = 1, 2 do
        if prop[ped][i] and DoesEntityExist(prop[ped][i]) then
            DeleteEntity(prop[ped][i])
            local timeout = 0
            while DoesEntityExist(prop[ped][i]) and timeout < 50 do
                Wait(0)
                timeout = timeout + 1
            end
            prop[ped][i] = nil
        end
    end
    prop[ped] = nil

    currentAction[ped] = nil
end

local function StopAnimation(ped)
    if not DoesEntityExist(ped) then
        return
    end

    if lastEmote[ped] ~= nil then
        lastEmote[ped] = nil
        ClearPedTasks(ped)
        CleanUpProps(ped)
    end
end

local function PlayAnimation(ped, animationData)
    if not animationData or type(animationData) ~= "table" then
        return
    end

    while currentAction[ped] ~= nil do
        Wait(0)
    end

    currentAction[ped] = 'playing'

    StopAnimation(ped)

    local animDict = animationData[1]
    local animName = animationData[2]

    if not animName or not animDict then
        currentAction[ped] = nil
        return
    end

    local currentId = id
    lastEmote[ped] = currentId
    id = id + 1

    if not prop[ped] then
        prop[ped] = {}
    end

    RequestAnimDict(animDict)
    local timeout = 0
    while not HasAnimDictLoaded(animDict) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end


    if not HasAnimDictLoaded(animDict) then
        console.debug("Timeout while loading animation dictionary: " .. animDict)
        currentAction[ped] = nil
        return
    end

    if lastEmote[ped] ~= currentId then
        RemoveAnimDict(animDict)
        currentAction[ped] = nil
        return
    end

    local movementType = 0 -- Default movement type

    if VFW.PlayerData.vehicle ~= nil and VFW.PlayerData.vehicle ~= false then
        if animationData.AnimationOptions and animationData.AnimationOptions.FullBody then
            movementType = 35
        else
            movementType = 51
        end
    elseif animationData.AnimationOptions then
        movementType = animationData.AnimationOptions.EmoteMoving and 51
                or animationData.AnimationOptions.EmoteLoop and 1
                or animationData.AnimationOptions.EmoteStuck and 50
                or animationData.AnimationOptions.FullBody and 35
                or movementType
    end


    currentAnimDict = animDict
    currentAnimationPlayed = animName

    TaskPlayAnim(
            ped,
            animDict,
            animName,
            animationData.AnimationOptions?.BlendInSpeed or 5.0,
            animationData.AnimationOptions?.BlendOutSpeed or 5.0,
            animationData.AnimationOptions?.EmoteDuration or -1,
            movementType,
            0,
            false,
            false,
            false
    )

    RemoveAnimDict(animDict)

    local function AttachProp(propModel, boneIndex, placement, propId)
        if not propModel or type(placement) ~= "table" or #placement ~= 6 then
            return
        end

        if lastEmote[ped] ~= currentId then
            return
        end

        if prop[ped][propId] and DoesEntityExist(prop[ped][propId]) then
            DeleteEntity(prop[ped][propId])
            local timeout = 0
            while DoesEntityExist(prop[ped][propId]) and timeout < 50 do
                Wait(0)
                timeout = timeout + 1
            end
            prop[ped][propId] = nil
        end

        RequestModel(propModel)
        timeout = 0
        while not HasModelLoaded(propModel) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end

        if not HasModelLoaded(propModel) then
            console.debug("Timeout while loading prop model: " .. propModel)
            return
        end

        if lastEmote[ped] ~= currentId then
            SetModelAsNoLongerNeeded(propModel)
            return
        end

        prop[ped][propId] = CreateObject(propModel, GetEntityCoords(ped), not previewMode, not previewMode, not previewMode)
        SetModelAsNoLongerNeeded(propModel)

        if prop[ped][propId] and DoesEntityExist(prop[ped][propId]) then
            AttachEntityToEntity(
                    prop[ped][propId], ped, boneIndex,
                    placement[1], placement[2], placement[3],
                    placement[4], placement[5], placement[6],
                    true, true, false, true, 1, true
            )
        end
    end

    if animationData.AnimationOptions then
        if animationData.AnimationOptions.Prop and animationData.AnimationOptions.Prop ~= "" then
            local propModel = joaat(animationData.AnimationOptions.Prop)
            local boneIndex = animationData.AnimationOptions.PropBone and
                    GetPedBoneIndex(ped, animationData.AnimationOptions.PropBone) or
                    GetPedBoneIndex(ped, 57005)
            AttachProp(propModel, boneIndex, animationData.AnimationOptions.PropPlacement, 1)
        end

        if animationData.AnimationOptions.SecondProp and animationData.AnimationOptions.SecondProp ~= "" then
            local propModel = joaat(animationData.AnimationOptions.SecondProp)
            local boneIndex = animationData.AnimationOptions.SecondPropBone and
                    GetPedBoneIndex(ped, animationData.AnimationOptions.SecondPropBone) or
                    GetPedBoneIndex(ped, 57005)
            AttachProp(propModel, boneIndex, animationData.AnimationOptions.SecondPropPlacement, 2)
        end
    end

    lastAnimation = animationData
    currentAction[ped] = nil

end

local function PlayWalk(ped, walk)
    if not walk then
        return
    end
    RequestWalking(walk)
    SetPedMovementClipset(ped, walk, 0.2)
    RemoveAnimSet(walk)
    if ped == VFW.PlayerData.ped then
        SetResourceKvp("walkstyle", walk)
    end
end

local function PlayExpression(ped, expression)
    if not expression then
        return
    end
    SetFacialIdleAnimOverride(ped, expression, 0)
    if ped == VFW.PlayerData.ped then
        SetResourceKvp("expression", expression)
    end
end


function EmoteCommandStart(data, ped, shared)
    local name = string.lower(data)
    local playerPed = ped and ped or VFW.PlayerData.ped

    if shared then
        if emoteSelect then
            local target = VFW.StartSelect(5.0, true)
            if not target then
                return
            end

            console.debug("Sended to " .. target)
            TriggerServerEvent("vfw:anim:requestShared", GetPlayerServerId(target), name)
            emoteSelect = false
        end
        return
    end

    if RP.Emotes[name] ~= nil then
        PlayAnimation(playerPed, RP.Emotes[name])
    elseif RP.Dances[name] ~= nil then
        PlayAnimation(playerPed, RP.Dances[name])
    elseif RP.PropEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.PropEmotes[name])
    elseif RP.ActivitesEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.ActivitesEmotes[name])
    elseif RP.GestesEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.GestesEmotes[name])
    elseif RP.PositionsEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.PositionsEmotes[name])
    elseif RP.SportEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.SportEmotes[name])
    elseif RP.GangEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.GangEmotes[name])
    elseif RP.AutresEmotes[name] ~= nil then
        PlayAnimation(playerPed, RP.AutresEmotes[name])
    elseif RP.Vehicules[name] ~= nil then
        PlayAnimation(playerPed, RP.Vehicules[name])
    end
end

function EmoteCancel()
    ClearPedTasks(VFW.PlayerData.ped)
end

local function ConvertDancesToSubcategories()
    local subcategories = {
        emotes = {
            Danses = {},
            Objets = {},
            ["Activités"] = {},
            Gestes = {},
            Sports = {},
            Gangs = {},
            --Animal = {},
            Positions = {},
            ["Véhicules"] = {},
            Autres = {},
            ["Partager"] = {},
            Emotes = {},  -- Ajout de la catégorie manquante
            ["Visée"] = {},
        },
        walk = {
            styles = {}
        },
        expresion = {
            moods = {}
        }
    }

    for key, v in pairs(RP.Dances) do
        table.insert(subcategories["emotes"].Danses, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    table.insert(subcategories.expresion.moods, {
        name = "Reset",
        dist = "aucun",
        label = "Aucun",
        category = "expresion",
    })

    for key, v in pairs(RP.Expressions) do
        table.insert(subcategories.expresion.moods, {
            name = v[2] or key,
            dist = v[1],
            label = v[3] or key,
            category = "expresion",
        })
    end

    table.insert(subcategories.walk.styles, {
        name = "Reset",
        dist = "aucun",
        label = "Aucun",
        category = "walk",
    })

    for key, v in pairs(RP.Walks) do
        table.insert(subcategories.walk.styles, {
            name = v[3] or key,
            dist = v[1],
            label = v[2] or key,
            category = "walk",
        })
    end

    for key, v in pairs(RP.Emotes) do
        table.insert(subcategories.emotes.Emotes, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.PropEmotes) do
        table.insert(subcategories.emotes.Objets, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.ActivitesEmotes) do
        table.insert(subcategories["emotes"]["Activités"], {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.GestesEmotes) do
        table.insert(subcategories["emotes"].Gestes, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.SportEmotes) do
        table.insert(subcategories["emotes"].Sports, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.GangEmotes) do
        table.insert(subcategories["emotes"].Gangs, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.AutresEmotes) do
        table.insert(subcategories["emotes"].Autres, {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.Shared) do
        table.insert(subcategories["emotes"]["Partager"], {
            name = key,
            label = v[3] or key,
            category = "emotes",
            shared = true
        })
    end

    for key, v in pairs(RP.Vehicules) do
        table.insert(subcategories["emotes"]["Véhicules"], {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    for key, v in pairs(RP.PositionsEmotes) do
        table.insert(subcategories["emotes"]["Positions"], {
            name = key,
            label = v[3] or key,
            category = "emotes",
        })
    end

    --for key, v in pairs(RP.AnimalEmotes) do
    --    table.insert(subcategories["emotes"]["Animal"], {
    --        name = key,
    --        label = v[3] or key,
    --        category = "emotes",
    --    })
    --end

    local animWeapon = {
        "Normal",
        "Cowboy",
        "Gangster",
    }

    for _, v in pairs(animWeapon) do
        table.insert(subcategories["emotes"]["Visée"], {
            name = v,
            label = v,
            category = "emotes",
        })
    end

    return subcategories
end

local open = false

VFW.RegisterInput("openAnimation", "Emote menu", "keyboard", "F4", function()
    if not open then
        open = true

        local convertedSubcategories = ConvertDancesToSubcategories()

        Wait(200)

        VFW.Nui.animation(true, { subcategories = convertedSubcategories })

        if open then
            SetCursorLocation(0.5, 0.5)
        end

        clonePed = ClonePed(VFW.PlayerData.ped, false, true, true)
        SetPedAudioFootstepLoud(clonePed, false)
        SetPedAudioFootstepQuiet(clonePed, false)
        SetPedFleeAttributes(clonePed, 0, 0)
        SetBlockingOfNonTemporaryEvents(clonePed, true)
        SetPedCanRagdollFromPlayerImpact(clonePed, false)
        SetPedCanRagdoll(clonePed, false)
        SetPedDiesWhenInjured(clonePed, false)
        FreezeEntityPosition(clonePed, true)
        SetEntityInvincible(clonePed, true)
        DisablePedPainAudio(clonePed, true)
        SetEntityCompletelyDisableCollision(clonePed, false, false)
        SetEntityVisible(clonePed, false)

        CreateThread(function()
            while open do
                Wait(0)
                local scoords, ncoords = GetWorldCoordFromScreenCoord(0.7, (zoom and 1.75 or 0.85))
                local pos = scoords + ncoords * (zoom and 2.0 or 5.0)
                local heading = GetGameplayCamRot(0).z - 180.0

                local groundZ = nil
                local attempts = 0
                while not groundZ and attempts < 10 do
                    local success, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z + 50.0, false)
                    if success then
                        groundZ = z
                    else
                        attempts = attempts + 1
                        Wait(10)
                    end
                end

                if groundZ then
                    pos = vector3(pos.x, pos.y, groundZ)
                end

                SetEntityAlpha(clonePed, 204, false)
                SetEntityCoords(clonePed, pos.x, pos.y, pos.z, false, false, false, true)
                SetEntityHeading(clonePed, heading)

                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 142, open)
                DisableControlAction(0, 18, open)
                DisableControlAction(0, 322, open)
                DisableControlAction(0, 106, open)
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
    else
        if clonePed then
            StopAnimation(clonePed)
            DeletePed(clonePed)
            clonePed = nil
        end
        open = false
        VFW.Nui.animation(false)
    end
end)

RegisterNUICallback('nui:animation:preview', function(data)
    if pendingPropCreation then
        -- Si une création de prop est en cours, on attend qu'elle se termine
        Wait(50)
    end

    SetEntityVisible(clonePed, true)
    StopAnimation(clonePed)
    ClearPedTasks(clonePed)
    ResetPedMovementClipset(clonePed, 0.0)
    ClearFacialIdleAnimOverride(clonePed)

    zoom = (data[4] == "expresion")

    previewMode = true

    if data[4] == "walk" and data[2] ~= "aucun" then
        PlayWalk(clonePed, data[2])
        TaskGoStraightToCoord(clonePed, 0, 0, 0, 1.0, -1, 0, 0)
    elseif data[4] == "expresion" and data[2] ~= "aucun" then
        PlayExpression(clonePed, data[2])
    else
        EmoteCommandStart(data[1], clonePed)
    end
end)

RegisterNUICallback("nui:animation:stopPreview", function()
    if pendingPropCreation then
        -- Si une création de prop est en cours, on attend qu'elle se termine
        Wait(50)
    end

    StopAnimation(clonePed)
    ClearPedTasks(clonePed)
    ResetPedMovementClipset(clonePed, 0.0)
    ClearFacialIdleAnimOverride(clonePed)
end)

RegisterNUICallback("nui:animation:input", function(data)
    if (data.value) then
        VFW.Nui.Focus(true, false)
    else
        VFW.Nui.Focus(true, true)
    end

    if not open then
        VFW.Nui.Focus(false, false)
    end
end)

VFW.CopyAnimations = function(targetId)
    local target = nil

    if not targetId then
        local playerId, playerPed, distance = VFW.Game.GetClosestPlayer(GetEntityCoords(VFW.PlayerData.ped), 2.5, false)

        if not playerId or playerId < 1 then
            --VFW.ShowNotification({
            --    type = "error",
            --    content = "Aucun joueur à proximité"
            --})
            return
        end

        target = playerId
    end

    local animName = TriggerServerCallback("vfw:anim:copy", target and GetPlayerServerId(target) or targetId)

    if not animName then
        return
    end

    EmoteCommandStart(animName, nil, false)
end

local hillbillyAS = false
local gangsterAS = false

local function Thread()
    CreateThread(function()
        while hillbillyAS or gangsterAS do
            Wait(80)

            local inVeh = IsPedInVehicle(VFW.PlayerData.ped, GetVehiclePedIsIn(VFW.PlayerData.ped, false), false)

            if gangsterAS then
                local ped = VFW.PlayerData.ped, DecorGetInt(VFW.PlayerData.ped)
                local _, hash = GetCurrentPedWeapon(ped, 1)

                if not inVeh then
                    VFW.Streaming.RequestAnimDict("combat@aim_variations@1h@gang")

                    if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                        if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                            TaskPlayAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                            SetEnableHandcuffs(ped, true)
                        end
                    elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                        ClearPedTasks(ped)
                        SetEnableHandcuffs(ped, false)
                    end
                end
            elseif hillbillyAS then
                local ped = VFW.PlayerData.ped, DecorGetInt(VFW.PlayerData.ped)
                local _, hash = GetCurrentPedWeapon(ped, 1)

                if not inVeh then
                    VFW.Streaming.RequestAnimDict("combat@aim_variations@1h@hillbilly")

                    if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                        if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                            TaskPlayAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                            SetEnableHandcuffs(ped, true)
                        end
                    elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                        ClearPedTasks(ped)
                        SetEnableHandcuffs(ped, false)
                    end
                end
            end
        end
    end)
end

RegisterNUICallback('nui:animation:select', function(data)
    if not open then
        return
    end

    if pendingPropCreation then
        -- Si une création de prop est en cours, on attend qu'elle se termine
        Wait(50)
    end

    StopAnimation(VFW.PlayerData.ped)

    previewMode = false

    if data[4] == "walk" then
        if data[2] ~= "aucun" then
            PlayWalk(VFW.PlayerData.ped, data[2])
        else
            ResetPedMovementClipset(VFW.PlayerData.ped)
            DeleteResourceKvp("walkstyle")
        end
    elseif data[4] == "expresion" then
        if data[2] ~= "aucun" then
            PlayExpression(VFW.PlayerData.ped, data[2])
        else
            ClearFacialIdleAnimOverride(VFW.PlayerData.ped)
            DeleteResourceKvp("expression")
        end
    elseif data[1] == "Normal" or data[1] == "Cowboy" or data[1] == "Gangster" then
        if data[1] == "Normal" then
            hillbillyAS = false
            gangsterAS = false
        elseif data[1] == "Cowboy" then
            hillbillyAS = true
            gangsterAS = false
        elseif data[1] == "Gangster" then
            hillbillyAS = false
            gangsterAS = true
        end
        Thread()
    else
        emoteSelect = true
        EmoteCommandStart(data[1], VFW.PlayerData.ped, data[5] or nil)
        TriggerServerEvent("vfw:anim:sync", data[1])
    end
end)

RegisterNUICallback('nui:animation:close', function(data)
    if not open then
        return
    end

    if pendingPropCreation then
        -- Si une création de prop est en cours, on attend qu'elle se termine
        Wait(50)
    end

    if clonePed then
        StopAnimation(clonePed)
        DeletePed(clonePed)
        clonePed = nil
    end
    open = false
    VFW.Nui.animation(false)
end)

RegisterNetEvent("vfw:anim:askShared", function(ask, askName, emote)
    local choice = false
    VFW.ShowNotification({
        title = "ANIMATION  ",
        mainMessage = askName .. " : " .. emote,
        type = "INVITE_NOTIFICATION",
        duration = 30
    })
    CreateThread(function()
        while not choice do
            Wait(0)
            if IsControlJustPressed(0, 246) then
                TriggerServerEvent("vfw:anim:acceptShared", ask, emote)
                choice = true
                VFW.RemoveNotification()
            elseif IsControlJustPressed(0, 249) then
                TriggerServerEvent("vfw:anim:refuseShared", ask)
                choice = true
                VFW.RemoveNotification()
            end
        end
    end)
end)

RegisterNetEvent("SyncPlayEmote")
AddEventHandler("SyncPlayEmote", function(emote, player)
    EmoteCancel()
    Wait(300)
    targetPlayerId = player
    if RP.Shared[emote] ~= nil then
        if RP.Shared[emote].AnimationOptions and RP.Shared[emote].AnimationOptions.Attachto then
            local targetEmote = RP.Shared[emote][4]
            if not targetEmote or not RP.Shared[targetEmote] or not RP.Shared[targetEmote].AnimationOptions or
                    not RP.Shared[targetEmote].AnimationOptions.Attachto then
                local plyServerId = GetPlayerFromServerId(player)
                local ply = VFW.PlayerData.ped
                local pedInFront = GetPlayerPed(plyServerId ~= 0 and plyServerId or GetClosestPlayer())
                local bone = RP.Shared[emote].AnimationOptions.bone or -1 -- No bone
                local xPos = RP.Shared[emote].AnimationOptions.xPos or 0.0
                local yPos = RP.Shared[emote].AnimationOptions.yPos or 0.0
                local zPos = RP.Shared[emote].AnimationOptions.zPos or 0.0
                local xRot = RP.Shared[emote].AnimationOptions.xRot or 0.0
                local yRot = RP.Shared[emote].AnimationOptions.yRot or 0.0
                local zRot = RP.Shared[emote].AnimationOptions.zRot or 0.0
                AttachEntityToEntity(ply, pedInFront, GetPedBoneIndex(pedInFront, bone), xPos, yPos, zPos, xRot, yRot,
                        zRot, false, false, false, true, 1, true)
            end
        end

        PlayAnimation(VFW.PlayerData.ped, RP.Shared[emote])
        return
    elseif RP.Dances[emote] ~= nil then
        PlayAnimation(VFW.PlayerData.ped, RP.Dances[emote])
        return
    else
        DebugPrint("SyncPlayEmote : Emote not found")
    end
end)

RegisterNetEvent("SyncPlayEmoteSource")
AddEventHandler("SyncPlayEmoteSource", function(emote, player)
    local ply = VFW.PlayerData.ped
    local plyServerId = GetPlayerFromServerId(player)
    local pedInFront = GetPlayerPed(plyServerId ~= 0 and plyServerId or GetClosestPlayer())

    local SyncOffsetFront = 1.0
    local SyncOffsetSide = 0.0
    local SyncOffsetHeight = 0.0
    local SyncOffsetHeading = 180.1

    local AnimationOptions = RP.Shared[emote] and RP.Shared[emote].AnimationOptions
    if AnimationOptions then
        if AnimationOptions.SyncOffsetFront then
            SyncOffsetFront = AnimationOptions.SyncOffsetFront + 0.0
        end
        if AnimationOptions.SyncOffsetSide then
            SyncOffsetSide = AnimationOptions.SyncOffsetSide + 0.0
        end
        if AnimationOptions.SyncOffsetHeight then
            SyncOffsetHeight = AnimationOptions.SyncOffsetHeight + 0.0
        end
        if AnimationOptions.SyncOffsetHeading then
            SyncOffsetHeading = AnimationOptions.SyncOffsetHeading + 0.0
        end

        if (AnimationOptions.Attachto) then
            local bone = AnimationOptions.bone or -1
            local xPos = AnimationOptions.xPos or 0.0
            local yPos = AnimationOptions.yPos or 0.0
            local zPos = AnimationOptions.zPos or 0.0
            local xRot = AnimationOptions.xRot or 0.0
            local yRot = AnimationOptions.yRot or 0.0
            local zRot = AnimationOptions.zRot or 0.0
            AttachEntityToEntity(ply, pedInFront, GetPedBoneIndex(pedInFront, bone), xPos, yPos, zPos, xRot, yRot, zRot,
                    false, false, false, true, 1, true)
        end
    end
    local coords = GetOffsetFromEntityInWorldCoords(pedInFront, SyncOffsetSide, SyncOffsetFront, SyncOffsetHeight)
    local heading = GetEntityHeading(pedInFront)
    SetEntityHeading(ply, heading - SyncOffsetHeading)
    SetEntityCoordsNoOffset(ply, coords.x, coords.y, coords.z, 0)
    EmoteCancel()
    Wait(300)
    targetPlayerId = player
    if RP.Shared[emote] ~= nil then
        PlayAnimation(ply, RP.Shared[emote])
        return
    elseif RP.Dances[emote] ~= nil then
        PlayAnimation(ply, RP.Dances[emote])
        return
    end
end)

RegisterKeyMapping("+clearAnim", "Anuler l'emote", "keyboard", "X")
RegisterCommand("+clearAnim", function()
    StopAnimation(VFW.PlayerData.ped)
    TriggerServerEvent("removeLastAnim")
end)

RegisterKeyMapping("+copyAnim", "Copier l'emote", "keyboard", "U")
RegisterCommand("+copyAnim", function()
    VFW.CopyAnimations(nil)
end)

RegisterCommand('e', function(source, args, raw)
    StopAnimation(VFW.PlayerData.ped)
    EmoteCommandStart(args[1], VFW.PlayerData.ped)
end, false)

function VFW.GetPedAnimationIsPlaying()
    return lastAnimation
end


function GetPlayingEmote()
    return {
        dict = currentAnimDict,
        anim = currentAnimationPlayed
    }
end

exports("GetPlayingEmote", GetPlayingEmote)
