local statusMenu = false
local disabled = false
RegisterKeyMapping("+openescapemenu", "Open Escape Menu", "keyboard", "escape")
RegisterCommand("+openescapemenu", function()
    if not statusMenu and not IsPauseMenuActive() and not disabled then
        statusMenu = true
        TriggerScreenblurFadeIn(1000)
        VFW.Nui.HudVisible(false)
        local vcoins = TriggerServerCallback("vfw:getVCoins")
        print(vcoins)
        VFW.Nui.EscapeMenu(true, {
            premium = true,
            premiumEndDate = 1451564,
            credit =vcoins ,
            unique_id = VFW.PlayerGlobalData.id,
            serverType = 'FA',
            cfx = 1,
        })
    end
end, false)

local function closeUI()
    if not statusMenu then return end
    statusMenu = false
    VFW.Nui.EscapeMenu(false)
    VFW.Nui.HudVisible(true)
    TriggerScreenblurFadeOut(1000)
end

RegisterCommand("debug", function()
    SetNuiFocus(false, false)
    VFW.Nui.Visible(false)
    Wait(50)
    VFW.Nui.Visible(true)
    Wait(50)
    closeUI()
end, false)

RegisterNuiCallback("nui:escape-menu:close", function()
    print("close escape menu")
    closeUI()
end)

RegisterNetEvent("__razv4::closeEscapeMenu", function()
    closeUI()
end)

RegisterNuiCallback("nui:escape-menu:open-map", function()
    statusMenu = false
    VFW.Nui.EscapeMenu(false)
    TriggerScreenblurFadeOut(1000)
    ActivateFrontendMenu(`FE_MENU_VERSION_MP_PAUSE`, false, -1)
    Wait(100)
    PauseMenuceptionGoDeeper(0)
    while (not IsControlJustPressed(0, 200)) and IsPauseMenuActive() do
        Wait(0)
    end
    SetFrontendActive(0)
    TriggerScreenblurFadeIn(1000)
    statusMenu = true
    VFW.Nui.EscapeMenu(true, {
        premium = true,
        premiumEndDate = 1709691273,
        credit = 1000,
        unique_id = "69",
        serverType = 'FA',
        cfx = VFW.PlayerGlobalData.id
    })
end)

RegisterNuiCallback("nui:escape-menu:open-options", function()
    statusMenu = false
    VFW.Nui.EscapeMenu(false)
    TriggerScreenblurFadeOut(1000)
    ActivateFrontendMenu(`FE_MENU_VERSION_LANDING_MENU`, false, -1)
    Wait(100)
    while IsPauseMenuActive() do
        Wait(0)
    end
    TriggerScreenblurFadeIn(1000)
    statusMenu = true
    VFW.Nui.EscapeMenu(true, {
        premium = true,
        premiumEndDate = 1709691273,
        credit = 1000,
        unique_id = "69",
        serverType = 'FA',
        cfx = VFW.PlayerGlobalData.id
    })
end)

RegisterNuiCallback("nui:escape-menu:open-personnage", function()
    closeUI()
    ExecuteCommand('relog')
end)

RegisterNuiCallback("nui:escape-menu:send-report", function(data)
    console.debug("Report", json.encode(data))
    ExecuteCommand('report ' .. data.report)
end)

function VFW.IsOpenEscapeMenu()
    return statusMenu
end

RegisterNetEvent("vfw:openEscapeMenuBoutique", function()
    if not statusMenu and not IsPauseMenuActive() and not disabled then
        statusMenu = true
        TriggerScreenblurFadeIn(1000)
        VFW.Nui.HudVisible(false)
        VFW.Nui.EscapeMenu(true, {
            premium = true,
            premiumEndDate = 1709691273,
            credit = 1000,
            unique_id = "69",
            serverType = 'FA',
            pageBoutique = true
        })
    end
end)

function VFW.DisableEscapeMenu(state)
    disabled = state
end

RegisterNUICallback("__razv:web:boutiqueVehBuy", function(data)
    print("on recois lachat")
    if data then
        closeUI()
        CleanupBoutiqueCamera()
        BuyVehBoutique(data)
    end
end)


RegisterNUICallback("__razv:web:boutiqueVehTry", function(data)
    if not data then return end
    closeUI()
    CleanupBoutiqueCamera()
    DoScreenFadeOut(500)
    Wait(500)
    TryVehBoutique(data)
    Wait(750)
    DoScreenFadeIn(700)
end)
