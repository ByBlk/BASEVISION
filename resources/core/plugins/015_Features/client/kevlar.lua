local kevlarConfigs = {
    --- LSPD ---
    lspdgiletj = {male = {76, 0}, female = {72, 0}},
    lspdkevle1 = {male = {62, 0}, female = {63, 0}},
    lspdkevle2 = {male = {62, 5}, female = {63, 5}},
    lspdkevle3 = {male = {62, 6}, female = {63, 6}},
    lspdriot = {male = {63, 2}, female = {62, 2}},
    lspdkevm1 = {male = {85, 0}, female = {70, 0}},
    lspdkevlo1 = {male = {83, 1}, female = {87, 2}},
    lspdkevlo2 = {male = {84, 1}, female = {86, 2}},
    lspdkevlo3 = {male = {74, 2}, female = {89, 0}},
    lspdswat = {male = {127, 0}, female = {116, 0}},
    lspdswat2 = {male = {90, 0}, female = {90, 0}},
    lspdcnt1 = {male = {90, 1}, female = {90, 2}},
    lspdkevpc = {male = {73, 10}, female = {71, 10}},
    lspdgnd = {male = {87, 0}, female = {88, 1}},
    lspdgnd2 = {male = {84, 2}, female = {86, 3}},

    --- USSS ---
    insigneKevUsss = {male = {77, 3}, female = {76, 7}},
    ussskev1 = {male = {71, 0}, female = {86, 1}},
    ussskev2 = {male = {72, 0}, female = {87, 1}},
    ussskev3 = {male = {74, 0}, female = {90, 1}},
    ussskev4 = {male = {133, 0}, female = {63, 7}},

    --- LSSD ---
    lssdgiletj = {male = {76, 1}, female = {72, 1}},
    lssdkevle1 = {male = {62, 1}, female = {63, 2}},
    lssdkevle2 = {male = {73, 1}, female = {74, 1}},
    lssdkevlo1 = {male = {74, 1}, female = {87, 4}},
    lssdkevlo2 = {male = {83, 0}, female = {87, 0}},
    lssdkevlo3 = {male = {84, 0}, female = {86, 0}},
    lssdkevlo4 = {male = {83, 2}, female = {87, 3}},
    lssdkevlo5 = {male = {106, 0}, female = {106, 0}},
    lssdkevlo6 = {male = {106, 1}, female = {106, 1}},
    lssdkevlo7 = {male = {106, 2}, female = {106, 2}},
    lssdinsigne = {male = {78, 1}, female = {77, 1}},
    lssdriot = {male = {63, 3}, female = {62, 3}},

    --- USBP ---
    usbpkevlo1 = {male = {82, 10}, female = {81, 10}},
    usbpkevlo2 = {male = {64, 8}, female = {64, 8}},
    usbpkevlo3 = {male = {75, 6}, female = {75, 6}},
    usbpkevlo4 = {male = {75, 7}, female = {75, 7}},
    usbpkevlo5 = {male = {80, 10}, female = {79, 10}},
    usbpkevpc = {male = {73, 12}, female = {74, 12}},
    usbpgiletb = {male = {65, 3}, female = {65, 5}},
    usbpgiletj = {male = {76, 8}, female = {72, 8}},
    usbpinsigne = {male = {77, 1}, female = {76, 1}},

    --- SAMS ---
    samskev = {male = {98, 0}, female = {97, 1}},
    samskev2 = {male = {99, 1}, female = {98, 1}},
    samskev3 = {male = {99, 3}, female = {98, 3}},
    samskev4 = {male = {98, 2}, female = {97, 1}},
    -- samskev5 = {male = {73, 6}, female = {95, 4}},

    --- LSFD ---
    lsfdkev = {male = {99, 0}, female = {97, 2}},
    lsfdkev2 = {male = {99, 2}, female = {98, 0}},
    lsfdkev3 = {male = {100, 1}, female = {98, 2}},
    lsfdkev4 = {male = {73, 5}, female = {95, 3}},
    lsfdkev5 = {male = {73, 2}, female = {95, 4}},
    lsfdradio = {male = {120, 0}, female = {112, 0}},

    --- GOUV  & AUTRES
    gouvkev = {male = {101, 2}, female = {100, 2}},
    gouvernorkev = {male = {102, 2}, female = {120, 0}},
    irskev = {male = {106, 4}, female = {106, 3}},
    irscikev = {male = {106, 5}, female = {106, 4}},
    dojkev = {male = {73, 3}, female = {63, 8}},
    boikev = {male = {74, 5}, female = {63, 9}},
    wzkev = {male = {98, 4}, female = {97, 4}},
    lstcard = {male = {114, 0}, nil},

    --- ILLÉGAL ---
    keville1 = {male = {139, 0}, female = {120, 0}},
    keville2 = {male = {130, 0}, female = {131, 0}},
    keville3 = {male = {130, 1}, female = {131, 1}},
    keville4 = {male = {130, 2}, female = {131, 2}},
    keville5 = {male = {135, 0}, female = {132, 0}},
    keville6 = {male = {135, 1}, female = {132, 1}},
    keville7 = {male = {135, 2}, female = {132, 2}},
    keville8 = {male = {135, 3}, female = {132, 3}},
    keville9 = {male = {136, 0}, female = {133, 2}},
    keville10 = {male = {136, 2}, female = {133, 0}},
    keville11 = {male = {136, 3}, female = {133, 1}},
    keville12 = {male = {136, 1}, female = {133, 2}},
    giletc4 = {male = {150, 0}, female = {150, 0}},
}

local inUse = false

local function PlayAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(VFW.PlayerData.ped, animDict, animName, 8.0, -8.0, duration, 51, 0, false, false, false)
    RemoveAnimDict(animDict)
    Wait(duration)
end

RegisterNetEvent("vfw:kevlar", function(item, shield)
    if VFW.PlayerData.vehicle then return end
    if inUse then
        inUse = false
        PlayAnim("clothingtrousers", "try_trousers_positive_d", 2500)
        TriggerEvent("skinchanger:change", "bproof_1", 0)
        TriggerEvent("skinchanger:change", "bproof_2", 0)
        if not inUse and GetPedArmour(VFW.PlayerData.ped) > 0 then
            TriggerServerEvent("vfw:kevlar:setMeta", item, GetPedArmour(VFW.PlayerData.ped))
        end
        SetPedArmour(VFW.PlayerData.ped, 0)
        return
    else
        inUse = true
        PlayAnim("clothingtrousers", "try_trousers_positive_d", 2500)
        local gender = VFW.PlayerData.skin.sex == 0 and "male" or "female"
        TriggerEvent("skinchanger:change", "bproof_1", kevlarConfigs[item][gender][1])
        TriggerEvent("skinchanger:change", "bproof_2", kevlarConfigs[item][gender][2])
        SetPedArmour(VFW.PlayerData.ped, tonumber(shield))
        while inUse do
            if GetPedArmour(VFW.PlayerData.ped) == 0 then
                TriggerEvent("skinchanger:change", "bproof_1", 0)
                TriggerEvent("skinchanger:change", "bproof_2", 0)
                TriggerServerEvent("vfw:kevlar:remove", item)
                inUse = false
                break
            end
            Wait(1000)
        end
    end
end)
