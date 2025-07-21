local kevlarConfigs = {
    --- LSPD ---
    lspdgiletj = { shield = 10 },
    lspdkevle1 = { shield = 33 },
    lspdkevle2 = { shield = 33 },
    lspdkevle3 = { shield = 33 },
    lspdriot = { shield = 100 },
    lspdkevm1 = { shield = 66 },
    lspdkevlo1 = { shield = 100 },
    lspdkevlo2 = { shield = 100 },
    lspdkevlo3 = { shield = 100 },
    lspdkevlo4 = { shield = 100 },
    lspdkevlourd = { shield = 100 },
    lspdkevsupervisor = { shield = 100 },
    lspdkevdb = { shield = 100 },
    lspdkevnegotiator = { shield = 100 },
    lspdkevswat = { shield = 100 },
    lspdkevcs = { shield = 100 },
    lspdkevco = { shield = 100 },
    lspdkevfieldsup = { shield = 100 },
    lspdkeviad = { shield = 100 },
    lspdswat = { shield = 100 },
    lspdswat2 = { shield = 100 },
    lspdmetro = { shield = 100 },
    lspdmetrole = { shield = 100 },
    lspdk9 = { shield = 100 },
    lspdtd = { shield = 100 },
    lspdtdj = { shield = 100 },
    lspdcnt1 = { shield = 50 },
    lspdgnd = { shield = 50 },
    lspdkevpc2 = { shield = 100 },
    lspdkevpc = { shield = 50 },

    --- USSS ---
    insigneKevUsss = { shield = 10 },
    ussskev1 = { shield = 100 },
    ussskev2 = { shield = 100 },
    ussskev3 = { shield = 100 },
    ussskev4 = { shield = 50 },

    --- LSSD ---
    lssdgiletj = { shield = 10 },
    lssdkevle1 = { shield = 33 },
    lssdkevle2 = { shield = 20 },
    lssdkevlo1 = { shield = 100 },
    lssdkevlo2 = { shield = 100 },
    lssdkevlo3 = { shield = 100 },
    lssdkevlo4 = { shield = 100 },
    lssdkevlo5 = { shield = 100 },
    lssdkevlo6 = { shield = 100 },
    lssdkevlo7 = { shield = 100 },
    lssdinsigne = { shield = 10 },
    lssdriot = { shield = 100 },

    --- G6 ---
    g6kev = { shield = 100 },
    g6kev2 = { shield = 100 },

    --- USBP ---
    usbpkevlo1 = { shield = 100 },
    usbpkevlo2 = { shield = 100 },
    usbpkevlo3 = { shield = 100 },
    usbpkevlo4 = { shield = 100 },
    usbpkevlo5 = { shield = 100 },
    usbpkevpc = { shield = 50 },
    usbpgiletb = { shield = 10 },
    usbpgiletj = { shield = 10 },
    usbpinsigne = { shield = 10 },

    --- SAMS ---
    samskev = { shield = 200 },
    samskev2 = { shield = 200 },
    samskev3 = { shield = 200 },
    samskev4 = { shield = 200 },
    samskev5 = { shield = 200 },

    --- LSFD ---
    lsfdkev = { shield = 100 },
    lsfdkev2 = { shield = 100 },
    lsfdkev3 = { shield = 100 },
    lsfdkev4 = { shield = 100 },
    lsfdkev5 = { shield = 100 },
    lsfdradio = { shield = 100 },

    --- GOUV  & AUTRES
    gouvkev = { shield = 100 },
    gouvernorkev = { shield = 100 },
    irskev = { shield = 100 },
    irscikev = { shield = 100 },
    dojkev = { shield = 100 },
    boikev = { shield = 100 },
    wzkev = { shield = 200 },
    lstcard = { shield = 10 },

    --- ILLÉGAL ---
    keville1 = { shield = 50 },
    keville2 = { shield = 50 },
    keville3 = { shield = 50 },
    keville4 = { shield = 50 },
    keville5 = { shield = 100 },
    keville6 = { shield = 100 },
    keville7 = { shield = 100 },
    keville8 = { shield = 100 },
    keville9 = { shield = 75 },
    keville10 = { shield = 75 },
    keville11 = { shield = 75 },
    keville12 = { shield = 75 },
    giletc4 = { shield = 25 },
}


function string.startWith(str, start)
    print("string.startWith", str, start)
    return str:sub(1, #start) == start
end

RegisterNetEvent("core:server:jobs:items", function(items)
    local source = source
    local xPlayer = VFW.GetPlayerFromId(source)
    if not xPlayer then return end
    local job = xPlayer.getJob().name
    if job == "unemployed" then return end
    if not xPlayer.job.onDuty then return end

    if type(items) == "table" then
        for _, item in ipairs(items) do
            if not kevlarConfigs[item] then
                if string.startWith(item, "badge") then
                    if xPlayer.haveItem(item, {}) then
                        goto continue
                    end
                end
                xPlayer.createItem(item, 1)
            else
                if string.startWith(item, "badge") then
                    if xPlayer.haveItem(item, {}) then
                        goto continue
                    end
                end
                xPlayer.addItem(item, 1, kevlarConfigs[item])
            end
            ::continue::
        end
    else
        if not kevlarConfigs[items] then
            if string.startWith(items, "badge") then
                if xPlayer.haveItem(items, {}) then
                    goto continue
                end
            end
            xPlayer.createItem(items, 1)
        else
            if string.startWith(items, "badge") then
                if xPlayer.haveItem(items, {}) then
                    goto continue
                end
            end
            xPlayer.addItem(items, 1, kevlarConfigs[items])
        end
        :: continue ::
    end

    xPlayer.updateInventory()
end)
