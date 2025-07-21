local lastId = nil
local lastData = {}
local lastSender = nil
local lastJob = nil

RegisterNuiCallback("nui:invoice:close", function() -- sender & reicever
    VFW.Nui.Invoice(false)
    VFW.Nui.Focus(false)
end)

RegisterNuiCallback("nui:invoice:send", function(data, cb) -- sender
    VFW.Nui.Invoice(false)
    VFW.Nui.Focus(false)
    lastData = data
    TriggerServerEvent("vfw:invoice:send", lastData, lastId)
end)

RegisterNetEvent("vfw:invoice:sendRecu", function() -- sender)
    if lastData.receipt then
        TriggerServerEvent("vfw:invoice:sendRecu", lastId, lastData)
    end
end)

RegisterNuiCallback("nui:invoice:payment", function(data) -- receiver
    print("Payment: " .. data)
    VFW.Nui.Invoice(false)
    TriggerServerEvent("vfw:invoice:payment", data, lastSender, lastJob)
end)

RegisterNetEvent("nui:invoice:receive")
AddEventHandler("nui:invoice:receive", function(data, name, sender, job)
    print("name: " .. name)
    lastSender = sender
    lastJob = job
    VFW.Nui.Invoice(false)
    VFW.Nui.Focus(false)
    VFW.Nui.Invoice(true, {
        sender = name,
        receiver = data.receiver,
        date = data.date,
        reduce = data.reduce,
        items = data.items,
        total = data.total,
        isSender = false,
    })
end)


local function OpenInvoice()
    local playerId = VFW.StartSelect(5.0, true)
    if not playerId then return end
    lastId = GetPlayerServerId(playerId)
    console.debug("Player ID: " .. lastId)
    local tName = TriggerServerCallback("vfw:invoice:getName", lastId)
    VFW.Nui.Invoice(true, {
        sender = VFW.PlayerData.name,
        receiver = tName,
        date = "10/01/2025 - 23:12",
        reduce = 0,
        items = {},
        total = 0,
        isSender = true,
    })
end

RegisterNetEvent("vfw:radial:open:invoice", function()
    OpenInvoice()
end)

RegisterNetEvent("vfw:invoice:open", function(data)
    if data then
        VFW.CloseInventory()
        Wait(100)
        print(json.encode(data))
        VFW.Nui.Recu(true, data)
    end
end)