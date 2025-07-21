local program = 0
local scaleform = nil
local lives = 5
local ClickReturn
local SorF = false
local Hacking = false
local UsingComputer = false
local scoreIp = 0
local RouletteWords = {
    "AKYPUWXL",
    "UWPJOIMA",
    "WQPWSCHJ",
    "UGUENOBF",
}

function StartHack(key)
    scaleform = Initialize("HACKING_PC", key)
    UsingComputer = true
end

function Initialize(scaleform, key)
    local scaleform = RequestScaleformMovieInteractive(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    local CAT = 'hack'
    local CurrentSlot = 0

    while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
        Wait(0)
        if CurrentSlot < 18 then
            CurrentSlot = CurrentSlot + 1
        else
            break
        end
    end

    if CurrentSlot > 15 then
        CurrentSlot = 15
    end

    if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
        ClearAdditionalText(CurrentSlot, true)
        RequestAdditionalText(CAT, CurrentSlot)
        while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Wait(0)
        end
    end

    PushScaleformMovieFunction(scaleform, "SET_LABELS")
    ScaleformLabel("H_ICON_1")
    ScaleformLabel("H_ICON_2")
    ScaleformLabel("H_ICON_3")
    ScaleformLabel("H_ICON_4")
    ScaleformLabel("H_ICON_5")
    ScaleformLabel("H_ICON_6")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
    PushScaleformMovieFunctionParameterInt(4)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(1.0)
    PushScaleformMovieFunctionParameterFloat(4.0)
    PushScaleformMovieFunctionParameterString("My Computer")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterString("Power Off")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_LIVES")
    PushScaleformMovieFunctionParameterInt(lives)
    PushScaleformMovieFunctionParameterInt(5)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(30)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterInt(50)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(2)
    PushScaleformMovieFunctionParameterInt(60)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(3)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(4)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(5)
    PushScaleformMovieFunctionParameterInt(90)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(6)
    PushScaleformMovieFunctionParameterInt(100)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(7)
    PushScaleformMovieFunctionParameterInt(255)
    PopScaleformMovieFunctionVoid()
    local timer = GetGameTimer() + 120000
    local newTime
    local minutes
    local milliseconde
    local secondes

    CreateThread(function()
        while UsingComputer do
            VFW.RealWait(1)

            if GetGameTimer() <= timer then
                newTime = timer - GetGameTimer()
                minutes = math.floor(newTime / (1000 * 60) % 60)
                secondes = (newTime / 1000) % 60
                milliseconde = newTime % 1000
            elseif GetGameTimer() > timer then
                minutes = 0
                secondes = 00
                milliseconde = 000
                PlaySoundFrontend(-1, "HACKING_FAILURE", "", false)
                PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                PopScaleformMovieFunctionVoid()
                SetScaleformMovieAsNoLongerNeeded(scaleform)
                DisableControlAction(0, 24, false)
                DisableControlAction(0, 25, false)
                FreezeEntityPosition(VFW.PlayerData.ped, false)
                Hacking = false
                SorF = false
                InHack = false
                program = 0
                scaleform = nil
                lives = 5
                SorF = false
                Hacking = false
                Fleeca[key].ipFinished = false
                TriggerServerEvent("core:IpHacking", key, false)
                UsingComputer = false
                scoreIp = 0
                collectgarbage("collect")
            end

            PushScaleformMovieFunction(scaleform, "SET_COUNTDOWN")
            PushScaleformMovieFunctionParameterInt(minutes)
            PushScaleformMovieFunctionParameterInt(math.floor(secondes))
            PushScaleformMovieFunctionParameterInt(milliseconde)
            PopScaleformMovieFunctionVoid()
        end
    end)

    CreateThread(function()
        while UsingComputer do
            Wait(1)
            if UsingComputer then
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
                PushScaleformMovieFunction(scaleform, "SET_CURSOR")
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
                PopScaleformMovieFunctionVoid()

                if IsDisabledControlJustPressed(0, 24) and not SorF then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                    ClickReturn = PopScaleformMovieFunction()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 176) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                    ClickReturn = PopScaleformMovieFunction()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 172) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(8)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 173) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(9)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 174) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(10)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 175) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(11)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                end
            end
        end
    end)

    CreateThread(function()
        while UsingComputer do
            Wait(1)

            if HasScaleformMovieLoaded(scaleform) and UsingComputer then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)

                if GetScaleformMovieFunctionReturnBool(ClickReturn) then
                    program = GetScaleformMovieFunctionReturnInt(ClickReturn)

                    if program == 82 and not Hacking and not Fleeca[key].ipFinished then
                        lives = 5
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(scaleform, "OPEN_APP")
                        PushScaleformMovieFunctionParameterFloat(0.0)
                        PopScaleformMovieFunctionVoid()
                        Hacking = true
                    elseif program == 83 and not Hacking and Fleeca[key].ipFinished then
                        lives = 5
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(scaleform, "OPEN_APP")
                        PushScaleformMovieFunctionParameterFloat(1.0)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                        PushScaleformMovieFunctionParameterString(RouletteWords[math.random(#RouletteWords)])
                        PopScaleformMovieFunctionVoid()
                        Hacking = true
                    elseif Hacking and program == 87 then
                        lives = lives - 1
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    elseif Hacking and program == 84 then
                        PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                        scoreIp = scoreIp + 1

                        Hacking = true
                        if scoreIp >= 3 then
                            PushScaleformMovieFunction(scaleform, "SET_IP_OUTCOME")
                            PushScaleformMovieFunctionParameterBool(true)
                            PushScaleformMovieFunctionParameterString("HACKCONNECT.EXE SUCCESSFUL!")
                            PopScaleformMovieFunctionVoid()
                            Hacking = false
                            Fleeca[key].ipFinished = true
                            TriggerServerEvent("core:IpHacking", key, true)
                            Wait(2800)
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                            PushScaleformMovieFunctionParameterBool(true)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                            PushScaleformMovieFunctionParameterInt(35)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                            PushScaleformMovieFunctionParameterInt(35)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                            PushScaleformMovieFunctionParameterString("Writing data to buffer..")
                            PushScaleformMovieFunctionParameterFloat(2.0)
                            PopScaleformMovieFunctionVoid()
                            Wait(1500)

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                            PushScaleformMovieFunctionParameterString("Executing malicious code..")
                            PushScaleformMovieFunctionParameterFloat(2.0)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                            PushScaleformMovieFunctionParameterInt(15)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                            PushScaleformMovieFunctionParameterInt(75)
                            PopScaleformMovieFunctionVoid()

                            Wait(1500)
                            PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                            PushScaleformMovieFunctionParameterBool(false)
                            PopScaleformMovieFunctionVoid()

                            PushScaleformMovieFunction(scaleform, "OPEN_ERROR_POPUP")
                            PushScaleformMovieFunctionParameterBool(true)
                            PushScaleformMovieFunctionParameterString("MEMORY LEAK DETECTED, DEVICE SHUTTING DOWN")
                            PopScaleformMovieFunctionVoid()

                            Wait(3500)
                            SetScaleformMovieAsNoLongerNeeded(scaleform)
                            PopScaleformMovieFunctionVoid()
                            FreezeEntityPosition(VFW.PlayerData.ped, false)
                            UsingComputer = false
                        else
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            PushScaleformMovieFunction(scaleform, "OPEN_APP")
                            PushScaleformMovieFunctionParameterFloat(0.0)
                            PopScaleformMovieFunctionVoid()
                        end
                    elseif Hacking and program == 85 then
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", false)
                        lives = lives - 1
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        if lives <= 0 then
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            SetScaleformMovieAsNoLongerNeeded(scaleform)
                            DisableControlAction(0, 24, false)
                            DisableControlAction(0, 25, false)
                            FreezeEntityPosition(VFW.PlayerData.ped, false)
                            Hacking = false
                            SorF = false
                            InHack = false
                            UsingComputer = false
                        else
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            PushScaleformMovieFunction(scaleform, "OPEN_APP")
                            PushScaleformMovieFunctionParameterFloat(0.0)
                            PopScaleformMovieFunctionVoid()
                        end
                    elseif Hacking and program == 86 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(true)
                        ScaleformLabel("WINBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(0)
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                        PushScaleformMovieFunctionParameterBool(true)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                        PushScaleformMovieFunctionParameterInt(35)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                        PushScaleformMovieFunctionParameterInt(35)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                        PushScaleformMovieFunctionParameterString("Writing data to buffer..")
                        PushScaleformMovieFunctionParameterFloat(2.0)
                        PopScaleformMovieFunctionVoid()
                        Wait(1500)

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                        PushScaleformMovieFunctionParameterString("Executing malicious code..")
                        PushScaleformMovieFunctionParameterFloat(2.0)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                        PushScaleformMovieFunctionParameterInt(15)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                        PushScaleformMovieFunctionParameterInt(75)
                        PopScaleformMovieFunctionVoid()

                        Wait(1500)
                        PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                        PushScaleformMovieFunctionParameterBool(false)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "OPEN_ERROR_POPUP")
                        PushScaleformMovieFunctionParameterBool(true)
                        PushScaleformMovieFunctionParameterString("MEMORY LEAK DETECTED, DEVICE SHUTTING DOWN")
                        PopScaleformMovieFunctionVoid()

                        Wait(3500)
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        PopScaleformMovieFunctionVoid()
                        FreezeEntityPosition(VFW.PlayerData.ped, false)
                        UsingComputer = false
                        Hacking = false
                        SorF = false
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                        FreezeEntityPosition(VFW.PlayerData.ped, false)
                        InHack = false
                        Fleeca[key].HackSuccess = true
                        TriggerServerEvent("core:HackSuccess", key, true)
                        UsingComputer = false
                    elseif program == 6 then
                        UsingComputer = false
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                        FreezeEntityPosition(VFW.PlayerData.ped, false)
                        InHack = false
                    end

                    if Hacking then
                        PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                        PushScaleformMovieFunctionParameterBool(true)
                        PopScaleformMovieFunctionVoid()

                        if lives <= 0 then
                            SorF = true
                            PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                            PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                            PushScaleformMovieFunctionParameterBool(false)
                            ScaleformLabel("LOSEBRUTE")
                            PopScaleformMovieFunctionVoid()
                            Wait(1000)
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            Hacking = false
                            SorF = false
                            InHack = false
                            UsingComputer = false
                        end
                    end
                end
            else
                Wait(250)
            end
        end
    end)

    while UsingComputer do
        Wait(1)
    end
end

function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end

AnimationHackingOpenDoor = function(data, key)
    local animDict = "anim@heists@ornate_bank@hack"
    local playerLicenseKey = 'heistsLimitPerReboot_' .. VFW.PlayerData.identifier
    local fleecaLimitPerReboot = (GlobalState[playerLicenseKey] and GlobalState[playerLicenseKey].fleeca) or nil

    if fleecaLimitPerReboot == nil or fleecaLimitPerReboot < 1 then
        TriggerServerEvent("core:ChangeHeistsLimitByID", GetPlayerServerId(PlayerId()), 'fleeca')
    else
        print("Limite de fleeca jusqu'au reboot atteinte !")
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous ne pouvez pas faire la fleeca maintenant !"
        })
        return
    end

    RequestAnimDict(animDict)

    local bool = HackAnimation(true)
    while bool == nil do
        Wait(1)
    end

    if not bool then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = '~s Vous n\'avez pas réussi le hack.'
        })
        return
    end

    local ped = VFW.PlayerData.ped

    StartHack(key)

    while UsingComputer do Wait(1) end

    VFW.RealWait(1000)
    VFW.RealWait(4500)

    RemoveFleecaBulle = true

    VFW.RemoveInteraction("fleecaHack")
    if FleecaHack[key] then
        Worlds.Zone.Remove(FleecaHack[key])
        FleecaHack[key] = nil
    end

    ClearFocus()

    TriggerServerEvent("core:removeLaptop")

    DeleteObject(bag)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    DeleteObject(laptop)
    SetModelAsNoLongerNeeded(GetHashKey("hei_prop_hst_laptop"))
    DeleteObject(card)
    SetModelAsNoLongerNeeded(GetHashKey("hei_prop_heist_card_hack_02"))
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    if Fleeca[key].ipFinished and not Fleeca[key].HackSuccess then
        CreateThread(function()
            local pos = vector3(data.door[1].pos[1], data.door[1].pos[2], data.door[1].pos[3])

            TriggerSecurEvent('core:alert:makeCall', "lspd", pos, true, "Braquage de fleeca", false, "illegal")
            TriggerSecurEvent('core:alert:makeCall', "lssd", pos, true, "Braquage de fleeca", false, "illegal") -- FIX_LSSD_LSPD

            TriggerServerEvent('core:createDispatchCallOnMDT', "LSPD", "Braquage de fleeca", pos)
            TriggerServerEvent('core:createDispatchCallOnMDT', "LSSD", "Braquage de fleeca", pos)

            TriggerServerEvent("core:OpenTheFleecaDoor", data.door[1].pos, data.door[1].hash)
        end)
        SpawnTrolleys(data.trolley, data.cam.trolley, data.door[1].pos, key)
        local obj = GetClosestObjectOfType(data.door[1].pos.x, data.door[1].pos.y, data.door[1].pos.z, 10.0, -1591004109, false, false, false)
        TriggerServerEvent("core:LockDoorFleecaSync", data, false)
        FreezeEntityPosition(obj, false)
        TriggerServerEvent("core:FleecaDone", key)
        Fleeca[key].done = true
    elseif Fleeca[key].HackSuccess and Fleeca[key].ipFinished then
        local obj = GetClosestObjectOfType(data.door[1].pos.x, data.door[1].pos.y, data.door[1].pos.z, 5.0, -1591004109, false, false, false)
        TriggerServerEvent("core:LockDoorFleecaSync", data, false)
        FreezeEntityPosition(obj, false)
        TriggerServerEvent("core:FleecaDone", key)
        Fleeca[key].done = true
    end
end

function SpawnTrolleys(data, cam, door, key)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Wait(1)
    end

    Trolley1 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data[1].pos.x, data[1].pos.y, data[1].pos.z, 1, 1, 0)
    Trolley2 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data[2].pos.x, data[2].pos.y, data[2].pos.z, 1, 1, 0)
    Trolley3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data[3].pos.x, data[3].pos.y, data[3].pos.z, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley1)
    local h2 = GetEntityHeading(Trolley2)
    local h3 = GetEntityHeading(Trolley3)

    SetEntityHeading(Trolley1, h1 + data[1].pos.w)
    SetEntityHeading(Trolley2, h2 + data[2].pos.w)
    SetEntityHeading(Trolley3, h3 + data[3].pos.w)

    TriggerServerEvent("core:StartBoucleGrab", data, cam, door, key)
end

function StartBoocleFleeca(data, cam, door, key)
    ActionInTerritoire(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), 600, 3, CoordsIsInSouth(GetEntityCoords(VFW.PlayerData.ped)))

    VFW.CreateBlipAndPoint("fleecaRamasse1", vector3(data[1].pos.x, data[1].pos.y, data[1].pos.z + 1), 1, nil, nil, nil, nil,  "Ramasser", "E", "Location",{
        onPress = function()
            VFW.RemoveInteraction("fleecaRamasse1")
            TriggerServerEvent("core:DisableGrabFleeca", key, 1)
            StartGrab("Trolley1", key)
            data[1].loot = true
        end
    })

    VFW.CreateBlipAndPoint("fleecaRamasse2", vector3(data[2].pos.x, data[2].pos.y, data[2].pos.z + 1), 1, nil, nil, nil, nil,  "Ramasser", "E", "Location",{
        onPress = function()
            VFW.RemoveInteraction("fleecaRamasse2")
            TriggerServerEvent("core:DisableGrabFleeca", key, 2)
            StartGrab("Trolley2", key)
            data[2].loot = true
        end
    })

    VFW.CreateBlipAndPoint("fleecaRamasse3", vector3(data[3].pos.x, data[3].pos.y, data[3].pos.z + 1), 1, nil, nil, nil, nil,  "Ramasser", "E", "Location",{
        onPress = function()
            VFW.RemoveInteraction("fleecaRamasse3")
            TriggerServerEvent("core:DisableGrabFleeca", key, 3)
            StartGrab("Trolley3", key)
            data[3].loot = true
        end
    })
end

function OpenTheDoor(door, hash)
    local obj = GetClosestObjectOfType(door.x, door.y, door.z, 5.0, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
    local count = 0

    repeat
        local heading = GetEntityHeading(obj) - 0.10

        SetEntityHeading(obj, heading)
        count = count + 1
        Wait(10)
    until count == 900
end

function StartGrab(Cams, key)
    local ped = VFW.PlayerData.ped
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)

    local CashAppear = function()
        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end

        local grabobj = CreateObject(grabmodel, pedCoords, true)

        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        local startedGrabbing = GetGameTimer()

        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Wait(1)

                DisableControlAction(0, 73, true)

                if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end

                if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        local money = math.random(1111, 3333)

                        TriggerServerEvent("core:addItemToInventory", 'money', money, {})
                        VFW.ShowNotification({
                            type = 'DOLLAR',
                            content = ("Vous avez récupéré ~s %s$"):format(money)
                        })
                    end
                end
            end

            DeleteObject(grabobj)
        end)
    end

    local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

    if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end

    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)

    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and
            not HasModelLoaded(baghash) do
        Wait(100)
    end

    while not NetworkHasControlOfEntity(trollyobj) do
        Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end

    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(VFW.PlayerData.ped), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(scene1)

    Wait(1500)

    CashAppear()

    local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene2)

    Wait(37000)

    local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)

    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, -0.985), true)

    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))

    while not NetworkHasControlOfEntity(trollyobj) do
        Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end

    DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)

    Wait(1800)

    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
end

RegisterNetEvent("core:StartBoucleGrab")
AddEventHandler("core:StartBoucleGrab", function(data, cam, door, key)
    StartBoocleFleeca(data, cam, door, key)
end)

RegisterNetEvent("core:IpHacking")
AddEventHandler("core:IpHacking", function(key, bool)
    Fleeca[key].ipFinished = bool
end)

RegisterNetEvent("core:HackSuccess")
AddEventHandler("core:HackSuccess", function(key, bool)
    Fleeca[key].HackSuccess = bool
end)
