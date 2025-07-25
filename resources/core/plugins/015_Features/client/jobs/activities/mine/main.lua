local blipMine = nil
local Farmed = 0
local blipSellMine = nil
local spawnPlaces = {
    vector4(2836.6164550781, 2788.5651855469, 57.2653465271, 230.40905761719),
    vector4(2827.5290527344, 2797.6313476563, 56.676387786865, 174.06541442871),
}
local MineraisPos = {
    vector3(2925.2805175781, 2795.5004882813, 39.816257476807),
    vector3(2926.35, 2792.17, 39.21),
    vector3(2930.6560058594, 2787.1770019531, 39.225761413574),
    vector3(2934.3840332031, 2784.2463378906, 38.135757446289),
    vector3(2937.828125, 2774.8056640625, 38.228908538818),
    vector3(2938.9655761719, 2770.0649414063, 38.123588562012),
    vector3(2947.9494628906, 2766.7329101563, 38.1826171875),
    vector3(2952.9279785156, 2769.4438476563, 38.095897674561),
    vector3(2957.0073242188, 2773.4763183594, 38.842121124268),
    vector3(2968.4428710938, 2774.4914550781, 37.163333892822),
    vector3(2963.9797363281, 2774.6801757813, 38.475654602051),
    vector3(2980.4152832031, 2781.8859863281, 38.655368804932),
    vector3(2980.9919433594, 2786.7941894531, 39.391803741455),
    vector3(2977.7492675781, 2791.0603027344, 39.600025177002),
    vector3(2975.71484375, 2795.9372558594, 40.028232574463),
    vector3(2971.0729980469, 2799.107421875, 40.350330352783),
    vector3(2957.6865234375, 2819.1396484375, 41.601528167725),
    vector3(2950.5200195313, 2815.8869628906, 41.212207794189),
    vector3(2948.2314453125, 2819.4318847656, 41.661563873291),
    vector3(2944.0004882813, 2818.99609375, 42.505672454834),
    vector3(2937.4741210938, 2813.3364257813, 42.477264404297),
    vector3(2930.7114257813, 2816.419921875, 44.221382141113),
    vector3(2927.1694335938, 2813.1740722656, 43.584541320801),
    vector3(2919.685546875, 2799.6977539063, 40.254199981689),
}
local InJobMine = false
local ismining = false
local bulleMineCamionRendre = nil
local bulleMinePierre = {}
local stolenPaintings = {}
local vehs = nil

local function PlayAnim(dict, anim, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(1) end
    TaskPlayAnim(VFW.PlayerData.ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    RemoveAnimDict(dict)
end

local function mine_startMining()
    if Farmed >= 25 then
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous ne pouvez plus miner, allez vendre ce que vous avez sur vous"
        })
        return false
    else
        ismining = true
        Farmed += 1
        local miningAxe = CreateObject(GetHashKey('prop_tool_pickaxe'), GetEntityCoords(PlayerPedId()), true, false, false)
        FreezeEntityPosition(miningAxe, true)
        AttachEntityToEntity(miningAxe,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.09,0,0,-94.0,60.0,-10.0,1,1,0,1,0,1)
        PlayAnim('melee@large_wpn@streamed_core', 'ground_attack_on_spot', 1)
        VFW.RealWait(20000)
        ismining = false
        DeleteEntity(miningAxe)
        ClearPedTasksImmediately(PlayerPedId())
        return true
    end
end

local function funcStartMinerais()
    CreateThread(function()
        InJobMine = true

        while InJobMine do
            Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 2975.080078125, 2780.8583984375, 39.918369293213) < 60.0 then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    for k, v in pairs(MineraisPos) do
                        if not bulleMinePierre[k] and not stolenPaintings["bulleMinePierre:"..k] then
                            bulleMinePierre[k] = Worlds.Zone.Create(v + vector3(0.0, 0.0, 1.3), 2, false, function()
                                VFW.RegisterInteraction("bulleMinePierre", function()
                                    OpenStepCustom("Mine", "Une fois remplit, vendez vos pierres et rendez le camion.")
                                    SetTimeout(7500, function()
                                        HideStep()
                                    end)

                                    if not ismining then
                                        ismining = true
                                        local patchMine = mine_startMining()

                                        if patchMine then
                                            ismining = false
                                            local mineraiWin = nil

                                            math.randomseed(GetGameTimer())

                                            local randomNumber = math.random(1, 100)

                                            if randomNumber <= 70 then
                                                mineraiWin = 'de charbon'
                                                TriggerServerEvent("core:addItemToInventory", "charcoal", 1)
                                            elseif randomNumber <= 90 then
                                                mineraiWin = 'de fer'
                                                TriggerServerEvent("core:addItemToInventory", "iron", 1)
                                            elseif randomNumber <= 100 then
                                                mineraiWin = "d'or"
                                                TriggerServerEvent("core:addItemToInventory", "gold", 1)
                                            end

                                            if bulleMinePierre[k] then
                                                Worlds.Zone.Remove(bulleMinePierre[k])
                                                bulleMinePierre[k] = nil
                                            end

                                            stolenPaintings["bulleMinePierre:"..k] = true

                                            VFW.ShowNotification({
                                                type = 'VERT',
                                                duration = 5,
                                                content = "Vous avez récupéré un minerai "..mineraiWin.."."
                                            })
                                        end
                                    end
                                end)
                            end, function()
                                VFW.RemoveInteraction("bulleMinePierre")
                            end, "Pierre", "E", "vente")
                        end
                    end
                end
            else
                Wait(3000)
            end
        end
    end)
end

local function mine_startSell()
    local charcoalCount = 0
    local ironCount = 0
    local goldCount = 0
    local charcoalCount2 = 0
    local ironCount2 = 0
    local goldCount2 = 0
    local closestVehicle, _ = VFW.Game.GetClosestVehicle(vector3(2834.5, 2793.29, 56.67))
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
    local price = 0

    if bulleMineCamionRendre then
        Worlds.Zone.Remove(bulleMineCamionRendre)
        bulleMineCamionRendre = nil
    end

    if vehName == 'BISON' then
        --local invVeh = vehicle.GetVehicleInventory(vehicle.getPlate(closestVehicle))
        --
        --for k, v in pairs(invVeh) do
        --    if v.name == "charcoal" then
        --        charcoalCount = charcoalCount + v.count
        --    elseif v.name == "iron" then
        --        ironCount = ironCount + v.count
        --    elseif v.name == "gold" then
        --        goldCount = goldCount + v.count
        --    end
        --end
        --
        --TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'charcoal', charcoalCount)
        --TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'iron', ironCount)
        --TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'gold', goldCount)

        for k, v in pairs(VFW.PlayerData.inventory) do
            if v.name == "charcoal" then
                charcoalCount = charcoalCount + v.count
                charcoalCount2 = charcoalCount2 + v.count
            elseif v.name == "iron" then
                ironCount = ironCount + v.count
                ironCount2 = ironCount2 + v.count
            elseif v.name == "gold" then
                goldCount = goldCount + v.count
                goldCount2 = goldCount2 + v.count
            end
        end

        TriggerServerEvent("core:removeItemFromInventory", "charcoal", charcoalCount2)
        TriggerServerEvent("core:removeItemFromInventory", "iron", ironCount2)
        TriggerServerEvent("core:removeItemFromInventory", "gold", goldCount2)

        VFW.RealWait(500)

        InJobMine = false

        local charcoalPrice, ironPrice, goldPrice = 21, 28, 35
        local prices = {
            charcoal = "35",
            gold = "70",
            iron = "48"
        }

        if tonumber(prices.charcoal) and tonumber(prices.iron) and tonumber(prices.gold) then
            charcoalPrice = tonumber(prices.charcoal)
            ironPrice = tonumber(prices.iron)
            goldPrice = tonumber(prices.gold)
        end

        price = (charcoalCount * charcoalPrice + ironCount * ironPrice + goldCount * goldPrice)

        if VFW.PlayerGlobalData.permissions["premium"] then price = price * 1.25 end
        if VFW.PlayerGlobalData.permissions["premiumplus"] then price = price * 2 end

        if price ~= 0 then
            TriggerServerEvent("core:addItemToInventory", "money", price, {})
            VFW.ShowNotification({
                type = 'VERT',
                duration = 5,
                content = "Vous avez gagné "..price..'$'
            })
        else
            VFW.ShowNotification({
                type = 'ROUGE',
                duration = 5,
                content = "Vous n'avez rien gagné"
            })
        end

        Farmed = 0
        ismining = false

        HideStep()

        DeleteEntity(closestVehicle)
        RemoveBlip(blipSellMine)
        RemoveBlip(blipMine)
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            duration = 5,
            content = "Ce n'est pas le bon véhicule !"
        })
    end
end

local function spawnVeh()
    for k, v in pairs(spawnPlaces) do
        if VFW.Game.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                DeleteEntity(vehs)
                vehs = nil
            end

            vehs = VFW.Game.SpawnVehicle(GetHashKey("bison"), vector3(v.x, v.y, v.z), v.w, nil, true)

            return vehs
        else
            VFW.ShowNotification({type = 'ROUGE', content = "Il n'y a pas de place pour le véhicule"})
        end
    end

    return nil
end

function OpenMenuMine()
    VFW.Nui.JobMenu(true, {
        headerBanner = "https://cdn.eltrane.cloud/3838384859/old_a_trier/Discord/10493763812109926601206612668497006632MINE.webp",
        choice = {
            label = "Bison",
            isOptional = false,
            choices = {
                {
                    id = 1,
                    label = 'Bison',
                    name = 'bison',
                    img= "https://cdn.eltrane.cloud/3838384859/old_a_trier/Concessionnaire/Voiture/bison.webp",
                },
            },
        },
        participants = {{name = VFW.PlayerData.name, id = GetPlayerServerId(PlayerId())}},
        participantsNumber = 1,
        callbackName = "MetierMine",
    })
end

RegisterNUICallback("MetierMine", function(data)
    if data and data.button == "start" then
        spawnVeh()
        funcStartMinerais()
        OpenStepCustom("Mine", "Descends à la mine pour commencer à miner")
        SetTimeout(7500, function()
            HideStep()
        end)
        blipMine = AddBlipForRadius(2975.080078125, 2780.8583984375, 39.918369293213, 60.0)
        SetBlipSprite(blipMine, 9)
        SetBlipColour(blipMine, 1)
        SetBlipAlpha(blipMine, 100)
        blipSellMine = AddBlipForCoord(2834.5, 2793.29, 56.67)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Vente de minerai")
        EndTextCommandSetBlipName(blipSellMine)
        SetBlipColour(blipSellMine, 15)
        VFW.CreatePed(vector4(2834.5, 2793.29, 56.67, 188.72), "s_m_m_cntrybar_01")
        bulleMineCamionRendre = VFW.CreateBlipAndPoint("mine:sell", vector3(2834.5, 2793.29, 56.67 + 1.0), "mine:sell", nil, nil, nil, nil, "Vente", "E", "Stockage",{
            onPress = function()
                mine_startSell()
            end
        })
        VFW.Nui.JobMenu(false)
    elseif data.button == "stop" then

    end
end)

RegisterNuiCallback("nui:job-menu:close", function() VFW.Nui.JobMenu(false) end)
