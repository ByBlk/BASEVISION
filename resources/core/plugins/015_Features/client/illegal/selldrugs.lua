local DrugsType = {
    { name = "WEED", icon = "", item = "weed", action = "sell_weed" },
    { name = "METH", icon = "", item = "meth", action = "sell_meth" },
    { name = "COKE", icon = "", item = "coke", action = "sell_coke" },
    { name = "ECSTASY", icon = "", item = "ecstasy", action = "sell_ecstasy" },
    { name = "FENTANYL", icon = "", item = "fentanyl", action = "sell_fentanyl" }
}

local function RealRandom(x, y)
    math.randomseed(GetGameTimer())
    return math.random(x, y)
end

RegisterCommand("callpolice", function()
    CallPolice()
end, false)

local prices = {
    ['weed'] = RealRandom(22, 24),
    ['fentanyl'] = RealRandom(98, 102),
    ['coke'] = RealRandom(125, 129),  
    ['meth'] = RealRandom(54, 56),
    -- ['ecstasy'] = RealRandom(125, 128),
}

local lockedList = {}
local closestNPC = nil

local function ShowNotification(type, content)
    VFW.ShowNotification({ type = type, content = content })
end

local function GetPoliceService()
    return VFW.IsCoordsInSouth(GetEntityCoords(VFW.PlayerData.ped)) and "lspd" or "lssd"
end

function CallPolice()
    local service = GetPoliceService()
    print(service)
    TriggerServerEvent('core:alert:makeCall', service, GetEntityCoords(VFW.PlayerData.ped), true, "Trafic de drogue", false, "illegal")
end


local function GetNumberOfCopsInDuty()
    local service = GetPoliceService()
    local nbBolice = TriggerServerCallback("vfw:sellDrugs:getNbOfDuty", service)
    return nbBolice
end

local function HaveItem(item)
    for k, v in pairs(VFW.PlayerData.inventory) do
        if v.name == item then
            return true
        end
    end
    return false
end

local function GetItemCount(item)
    for k, v in pairs(VFW.PlayerData.inventory) do
        if v.name == item then
            return v.count or 0
        end
    end
    return 0
end

function VFW.HasMultipleDrugs()
    local drugCount = 0
    local drugTypes = {}

    for drug, _ in pairs(prices) do
        if HaveItem(drug) then
            drugCount = drugCount + 1
            table.insert(drugTypes, drug)
        end
    end

    return drugCount, drugTypes
end

local function LockPed(ped)
    local pedId = NetworkGetNetworkIdFromEntity(ped)
    local players = {}

    for _, player in pairs(GetActivePlayers()) do
        table.insert(players, GetPlayerServerId(player))
    end

    TriggerServerEvent("vfw:sellDrugs:pedLock", pedId, players)
end

local function AnimAndLoad(ped)
    TaskTurnPedToFaceEntity(ped, VFW.PlayerData.ped, -1)
    SetPedFleeAttributes(ped, 0, 0)
    TaskStandStill(ped, 1000000)
    SetEntityAsMissionEntity(ped)

    local pos = GetOffsetFromEntityInWorldCoords(VFW.PlayerData.ped, 0.0, 0.7, 0.0)
    local heading = GetEntityHeading(VFW.PlayerData.ped)
    SetEntityCoords(ped, pos.x, pos.y, pos.z - 1)
    SetEntityHeading(ped, heading - 180.0)
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(VFW.PlayerData.ped, true)

    Wait(500)

    RequestAnimDict("mp_ped_interaction")
    while not HasAnimDictLoaded("mp_ped_interaction") do Wait(0) end

    local pid = VFW.PlayerData.ped
    TaskPlayAnim(ped, "mp_ped_interaction", "handshake_guy_b", 2.0, 2.0, -1, 120, 0, false, false, false)
    TaskPlayAnim(pid, "mp_ped_interaction", "handshake_guy_a", 2.0, 2.0, -1, 120, 0, false, false, false)

    local duration = VFW.Nui.ProgressBar("Vente en cours...", 4 * 1000)

    if duration then
        StopAnimTask(pid, "mp_ped_interaction", "handshake_guy_b", 1.0)
        StopAnimTask(ped, "mp_ped_interaction", "handshake_guy_a", 1.0)
        FreezeEntityPosition(ped, false)
        TaskWanderStandard(ped, 10.0, 10)
        FreezeEntityPosition(VFW.PlayerData.ped, false)
        SetEntityAsNoLongerNeeded(ped)
    end
end

local function SellDrugs(drug, count, price)
    if HaveItem(drug) then
        print(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), 15, 14, VFW.IsCoordsInSouth(GetEntityCoords(PlayerPedId())))
        ActionInTerritoire(VFW.PlayerData.faction.name, VFW.Territories.GetZoneByPlayer(), 15, 14, VFW.IsCoordsInSouth(GetEntityCoords(PlayerPedId())))
        TriggerServerEvent("vfw:sellDrugs:sell", drug, count, price)
        ShowNotification('VERT', "Vous avez vendu ~s "..count.." "..drug.."~c pour ~s "..price.."$")
    end
end



local function sell_drug(drug)
    if RadialOpen then
        VFW.Nui.Radial(nil, false)
        RadialOpen = false
        return
    end
    local pedId = NetworkGetNetworkIdFromEntity(closestNPC)
    for _, id in pairs(lockedList) do
        if id == pedId then
            CallPolice()
            ShowNotification('ROUGE', "Désolé je ne suis pas intéressé")
            return
        end
    end
    LockPed(closestNPC)
    local count = GetItemCount(drug)
    if not count or count < 1 then
        CallPolice()
        ShowNotification('ROUGE', "Désolé je ne suis pas intéressé")
        return
    end

    -- Système de refus hyper aléatoire (1 sur 2, 1 sur 3, 1 sur 4, etc.)
    local randomPatterns = {
        {chance = 1, total = 2},  -- 1 sur 2 (50%)
        {chance = 1, total = 3},  -- 1 sur 3 (33%)
        {chance = 1, total = 4},  -- 1 sur 4 (25%)
        {chance = 2, total = 5},  -- 2 sur 5 (40%)
        {chance = 1, total = 5},  -- 1 sur 5 (20%)
        {chance = 3, total = 7},  -- 3 sur 7 (43%)
        {chance = 2, total = 7},  -- 2 sur 7 (29%)
        {chance = 1, total = 6},  -- 1 sur 6 (17%)
        {chance = 3, total = 8},  -- 3 sur 8 (38%)
        {chance = 3, total = 5},  -- 3 sur 5 (60%)
        {chance = 4, total = 7},  -- 4 sur 7 (57%)
        {chance = 2, total = 3},  -- 2 sur 3 (67%)
        {chance = 5, total = 9},  -- 5 sur 9 (56%)
    }

    local selectedPattern = randomPatterns[math.random(1, #randomPatterns)]
    local randomRoll = math.random(1, selectedPattern.total)

    if randomRoll <= selectedPattern.chance then
        -- Messages de refus variés
        local refuseMessages = {
            "Désolé je ne suis pas intéressé",
            "Non merci, pas aujourd'hui",
            "Je ne fais pas ce genre de choses",
            "Vous vous trompez de personne",
            "Allez voir ailleurs",
        }

        local message = refuseMessages[math.random(1, #refuseMessages)]

        if math.random(2, 3) == 1 then
            CallPolice()
        end

        ShowNotification('ROUGE', message)
        return
    end
    count = math.random(1, math.min(4, count))
    local price = prices[drug]
    local totalPrice = price * count
    AnimAndLoad(closestNPC)
    SellDrugs(drug, 1, math.floor(totalPrice))
end

function sell_weed() sell_drug("weed") end
function sell_meth() sell_drug("meth") end
function sell_coke() sell_drug("coke") end
function sell_ecstasy() sell_drug("ecstasy") end
function sell_fentanyl() sell_drug("fentanyl") end

local function OpenDrugsRadial(elements)
    VFW.Nui.Radial({ elements = elements, title = "DROGUES" }, true)
    RadialOpen = true
end

local boucle = false

local function loadSellDrugs()
    local pedpoints = {}

    CreateThread(function()
        while boucle do
            Wait(1)

            local drugCount, drugTypes = VFW.HasMultipleDrugs()

            if drugCount > 0 then
                for _, e in pairs(GetGamePool("CPed")) do
                    if GetEntityPopulationType(e) == 5 and GetEntityHealth(e) ~= 0 and GetVehiclePedIsIn(e) == 0 and DoesEntityExist(e) and drugCount > 0 then
                        local pedPos = GetEntityCoords(e)

                        if not pedpoints[e] then
                            pedpoints[e] = Worlds.Zone.Create(vector3(pedPos.x, pedPos.y, pedPos.z + 0.5), 2, false, function()
                                VFW.RegisterInteraction("selldrugs", function()
                                    local copsMax = 0
                                    local copsOnDuty = GetNumberOfCopsInDuty()

                                    if tonumber(copsOnDuty) < copsMax then
                                        local service = GetPoliceService()
                                        local msg = service == "lssd" and "Il n'y a pas assez de policiers en service, essaie dans le nord !" or "Il n'y a pas assez de policiers en service"
                                        ShowNotification('ROUGE', msg)
                                    elseif IsPedInAnyVehicle(VFW.PlayerData.ped, true) then
                                        ShowNotification('ROUGE', "Vous ne pouvez pas vendre de drogues en étant dans un véhicule")
                                    else
                                        if drugCount > 1 then
                                            local elements = {}

                                            for _, drug in pairs(DrugsType) do
                                                for _, hasDrug in pairs(drugTypes) do
                                                    if hasDrug == drug.item then
                                                        table.insert(elements, drug)
                                                        break
                                                    end
                                                end
                                            end

                                            closestNPC = e
                                            OpenDrugsRadial(elements)
                                            VFW.RemoveInteraction("selldrugs")
                                        else
                                            closestNPC = e
                                            sell_drug(drugTypes[1])
                                            VFW.RemoveInteraction("selldrugs")
                                        end
                                    end
                                end)
                            end, function()
                                VFW.RemoveInteraction("selldrugs")
                            end, "vente", "E", "vente")
                        elseif pedpoints[e] then
                            Worlds.Zone.UpdateCoords(pedpoints[e], vector3(pedPos.x, pedPos.y, pedPos.z + 0.5))
                        end
                    else
                        if pedpoints[e] then
                            Worlds.Zone.Remove(pedpoints[e])
                            pedpoints[e] = nil
                        end
                    end
                end

                for ped, _ in pairs(pedpoints) do
                    if not DoesEntityExist(ped) then
                        Worlds.Zone.Remove(pedpoints[ped])
                        pedpoints[ped] = nil
                    end
                end 
            else
                for ped, _ in pairs(pedpoints) do
                    if pedpoints[ped] then
                        Worlds.Zone.Remove(pedpoints[ped])
                        pedpoints[ped] = nil
                    end
                end
                Wait(5000)
            end
        end
    end)
end

RegisterNetEvent("vfw:sellDrugs:pedLock", function(newLockedPed)
    table.insert(lockedList, newLockedPed)
end)

RegisterNetEvent("vfw:sellDrugs:loadPedLock", function(lockList)
    lockedList = lockList
end)

RegisterNetEvent("vfw:sellDrugs:notifDrugs", function(lieux)
    ShowNotification('JAUNE', "Quelqu'un est entrain de vendre sur votre zone ~s (" .. lieux .. ")")
end)

local lastJob = nil

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.type == "faction" then
        lastJob = nil
        boucle = false
        return
    end
    lastJob = Job.type
    boucle = true
    loadSellDrugs()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob == VFW.PlayerData.job.type then return end
    if VFW.PlayerData.job.type == "faction" then
        boucle = false
        return
    end
    boucle = true
    loadSellDrugs()
end)
