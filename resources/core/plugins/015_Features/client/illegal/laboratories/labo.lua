VFW.Labs = {}
VFW.Labs.AllLabs = {}
VFW.Labs.Datas = {
    IsInProduction = false,
    MaxTimeProd = 120,
    LaboWeedStatus = 0,
    LaboItemsNeeded = {}
}
VFW.Labs.LabNames = {
    ["eaudechaux"] = "Eau de chaux",
    ["feuilledecoca"] = "Feuilles de coca",
    ["acidesulfurique"] = "Acide sulfurique",
    ["engrais"] = "Engrais",
    ["fertilisant"] = "Fertilisant",
    ["grainescannabis"] = "Graines de cannabis",
    ["ephedrine"] = "Ephedrine",
    ["lithium"] = "Lithium",
    ["phenylacetone"] = "phenylacetone",
    ["pavosomnifere"] = "Pavo somnifère",
    ["chlorureammonium"] = "Chlorure Ammonium",
    ["essence"] = "Essence",
    ["feuilledeweed"] = "Feuille de Weed" -- <3
}
VFW.Labs.LabsPos = {
    ["coke"] = {
        type = "Cocaine",
        entrance = vector3(1088.7307128906, -3187.763671875, -38.993450164795),
        gestion = vector3(1087.243, -3198.13, -38.993431091309),
        production = vector3(1087.3186035156, -3194.1750488281, -38.993431091309),
        ItemsNeeded = {
            "essence",
            "feuilledecoca",
            "acidesulfurique",
        }
    },
    ["weed"] = {
        type = "Weed",
        entrance = vector3(1066.2290039063, -3183.3837890625, -39.163497924805),
        gestion = vector3(1044.5041503906, -3194.7421875, -38.158142089844),
        production = vector3(1044.4807128906, -3196.7629394531, -38.157634735107),
        weedState = {
            small = {
                "weed_growtha_stage1",
                "weed_growthb_stage1",
                "weed_growthc_stage1",
                "weed_growthd_stage1",
                "weed_growthe_stage1",
                "weed_growthf_stage1",
                "weed_growthg_stage1",
                "weed_growthh_stage1",
                "weed_growthi_stage1",
            },
            medium = {
                "weed_growtha_stage2",
                "weed_growthb_stage2",
                "weed_growthc_stage2",
                "weed_growthd_stage2",
                "weed_growthe_stage2",
                "weed_growthf_stage2",
                "weed_growthg_stage2",
                "weed_growthh_stage2",
                "weed_growthi_stage2",
            },
            full = {
                "weed_growtha_stage3",
                "weed_growthb_stage3",
                "weed_growthc_stage3",
                "weed_growthd_stage3",
                "weed_growthe_stage3",
                "weed_growthf_stage3",
                "weed_growthg_stage3",
                "weed_growthh_stage3",
                "weed_growthi_stage3",
            }
        },
        ItemsNeeded = {
            "fertilisant",
            "grainescannabis",
            "engrais",
        }
    },
    ["meth"] = {
        type = "Meth",
        entrance = vector3(997.18542480469, -3200.7912597656, -36.39368057251),
        gestion = vector3(1003.7327270508, -3195.0615234375, -38.993125915527),
        production = vector3(1001.4822998047, -3194.8959960938, -38.993148803711),
        ItemsNeeded = {
            "ephedrine",
            "lithium",
            "phenylacetone",
        }
    },
    ["fentanyl"] = {
        type = "Fentanyl",
        entrance = vector3(997.18542480469, -3200.7912597656, -36.39368057251),
        gestion = vector3(1003.7327270508, -3195.0615234375, -38.993125915527),
        production = vector3(1001.4822998047, -3194.8959960938, -38.993148803711),
        ItemsNeeded = {
            "pavosomnifere",
            "chlorureammonium",
            "phenylacetone",
        }
    },
}

--[[
    DOCUMENTATION : 

    state = 0 -> Pas de production (on peux lancer la production)
    state = 1 -> Production en cours
    state = 2 -> Production terminée (on peux récolter)
]]

-- RegisterCommand("createLabo", function()
--     local coords = GetEntityCoords(PlayerPedId())
--     TriggerServerEvent("core:CreateLaboratory", VFW.PlayerData.faction.name, {x = coords.x, y= coords.y, z= coords.z}, "weed")
-- end)

local InsideLabo = false

local blipWithName = {}

local function createLaboEnterPoint(k, v)
    VFW.CreateBlipAndPoint("enter_labo" .. k, vector3(v.coords.x, v.coords.y, v.coords.z), k, nil, nil, nil, nil, "Entrer", "E", "Entrer", { -- labo == "weed" and "bulleProduireWeed" or labo == "coke" and "bulleProduireCoke" or labo == "fentanyl" and "bulleProduireFentanyl" or labo == "meth" and "bulleProduireMeth"
        onPress = function()
            console.debug("Trying to enter", v.crew:upper(), VFW.PlayerData.faction.name:upper(), v.crew:upper() == VFW.PlayerData.faction.name:upper())
            if v.crew:upper() == VFW.PlayerData.faction.name:upper() then
                if (not v.attacked) then
                    enterLabo(v.id, v.crew, v.laboType, v.coords)
                else -- Attacked
                    playAmorcingBomb()
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "~s Vous avez désamorcé le dispositif",
                    })
                    TriggerServerEvent("core:lab:desamorce", v.id)
                    v.attacked = false
                    v.open = false
                end
            else
                if (not v.open) then
                    TriggerServerEvent("core:lab:ring", v.id,v.crew)
                else -- Door is open from an attack
                    enterLabo(v.id, v.crew, v.laboType, v.coords)
                end
            end
        end
    })
end

-- Load laboratory
local function loadLabs(ignoreblip)
    while not VFW do Wait(1000) end 
    while not VFW.PlayerData do Wait(1000) end
    while not VFW.PlayerData.faction do Wait(1000) end
    local laboratories = TriggerServerCallback("core:getLaboratory")
    VFW.Labs.AllLabs = {}
    while laboratories == nil do Wait(15) end
    --if (not next(laboratories)) then return end

    for k, v in pairs(laboratories) do
        VFW.Labs.AllLabs[v.id] = {
            id = v.id,
            crew = v.crew,
            laboType = v.laboType,
            state = v.state,
            minutes = v.minutes,
            blocked = v.blocked,
            quantityDrugs = v.quantityDrugs,
            percentages = v.percentages,
            inAction = v.InAction,
            coords = v.coords,
        }

        if blipWithName[v.crew] then
            RemoveBlip(blipWithName[v.crew])
            blipWithName[v.crew] = nil
        end

        if not ignoreblip then
            if VFW.PlayerData.faction.name == v.crew then
                local blips = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
                SetBlipSprite(blips, 40)
                SetBlipScale(blips, 0.75)
                SetBlipColour(blips, 39)
                SetBlipAsShortRange(blips, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName("Laboratoire " .. VFW.Labs.LabsPos[v.laboType].type)
                EndTextCommandSetBlipName(blips)
                blipWithName[v.crew] = blips
            end
        end
    end
end

-- Chek need if he load
CreateThread(function()
    Wait(2000)
    loadLabs()
end)

local function setIplState(interiorId, props, state, refresh)
    if type(props) == "table" then
        for key, value in pairs(props) do
            setIplState(interiorId, value, state, refresh)
        end
    else
        if state then
            if not IsInteriorEntitySetActive(interiorId, props) then
                ActivateInteriorEntitySet(interiorId, props)
            end
        else
            if IsInteriorEntitySetActive(interiorId, props) then
                DeactivateInteriorEntitySet(interiorId, props)
            end
        end
    end
    if refresh then
        RefreshInterior(interiorId)
    end
end

local function checkWeedProduction(production, forcesmall)
    local IsInProductione = (production or 0)
    local percentage = math.floor((IsInProductione/VFW.Labs.Datas.MaxTimeProd)*100)
    console.debug("[Labo] Pourcentage de la production de weed " .. (percentage) .. "%. Calcul : (" .. IsInProductione .. "/" .. VFW.Labs.Datas.MaxTimeProd ..")*100. Force small ? :" .. (forcesmall and "true" or "false"))
    if percentage == 0 or percentage < 0 then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        if forcesmall then
            Wait(50) -- Force to wait so the ipl can be loaded
            setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.small, true, true)
            VFW.Labs.Datas.LaboWeedStatus = 1
        else
            VFW.Labs.Datas.LaboWeedStatus = 0
        end
    elseif percentage > 0 and percentage < 25 then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.small, true, true)
        VFW.Labs.Datas.LaboWeedStatus = 1
    elseif percentage >= 25 and percentage <= 75 then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.medium, true, true)
        VFW.Labs.Datas.LaboWeedStatus = 2
    else
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.full, true, true)
        VFW.Labs.Datas.LaboWeedStatus = 3
    end
end

RegisterNetEvent("core:labo:updateLabs", function(laboId, newCoords)
    loadLabs() -- PAS DE BLIP DECISION STAFF
end)

RegisterNetEvent("core:labo:changeState", function(state, idlab, min, shouldblock, percentages)
    VFW.Labs.AllLabs[idlab].state = state
    VFW.Labs.AllLabs[idlab].minutes = min
    VFW.Labs.AllLabs[idlab].blocked = shouldblock
    VFW.Labs.AllLabs[idlab].percentages = percentages
end)

RegisterNetEvent("core:createNewLab", function(id, crew, typeLab, entry)
    VFW.Labs.AllLabs[id] = {
        crew = crew,
        laboType = typeLab,
        coords = entry,
    }
    createLaboEnterPoint(id, {
        id = id,
        crew = crew,
        laboType = typeLab,
        coords = entry,
        open = false,
        attacked = false
    })
end)

RegisterNetEvent("core:labo:finished", function(id, percentages, quantity,labtype)
    VFW.Labs.AllLabs[id].state = 2
    VFW.Labs.AllLabs[id].percentages = percentages
    VFW.Labs.AllLabs[id].minutes = 0
    VFW.Labs.AllLabs[id].quantityDrugs = quantity
    VFW.Labs.Datas.LaboCrewLevel = Config.EnableDebug and 5 or TriggerServerCallback("core:crew:getCrewLevelByName", VFW.Labs.AllLabs[id].crew)
    if InsideLabo == id then
        if VFW.Labs.AllLabs[id].laboType == "weed" and VFW.Labs.Datas.LaboWeedStatus ~= 3 then
            checkWeedProduction(MaxTimeProductions[VFW.Labs.Datas.LaboCrewLevel])
        end
    end
end)

local function openLabProduction(id, laboType, getProduction)
    DisplayRadar(false)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(true, false)
    Wait(100)
    local state = 0
    local percentages = {0, 0, 0}
    if VFW.Labs.Datas.IsInProduction then
        state = VFW.Labs.Datas.IsInProduction == 100 and 2 or 1
    end
    local quantity = 140
    if VFW.Labs.Datas.CrewLevel == 4 then
        quantity = 160
    elseif VFW.Labs.Datas.CrewLevel >= 5 then
        quantity = 180
    end
    VFW.Labs.Datas.LaboQuantity = quantity
    VFW.Labs.Datas.LaboQuantityDrug = 0
    VFW.Labs.Datas.LaboType = laboType
    VFW.Labs.Datas.LaboCrewLevel = VFW.Labs.Datas.CrewLevel
    LaboImage = laboType
    LaboBlocked = false
    local shouldTakeDrug = TriggerServerCallback("core:IsFinishedLab", id)
    local MyLab = TriggerServerCallback("core:getMyLab", id)
    getProduction = MyLab.minutes
    state = MyLab.state
    percentages = MyLab.percentages
    LaboBlocked = MyLab.blocked
    VFW.Labs.Datas.LaboQuantityDrug = MyLab.quantityDrugs or 0
    if VFW.Labs.Datas.LaboQuantityDrug == 0 then
        if state == 2 then
            VFW.Labs.Datas.LaboQuantityDrug = 0
            state = 0
            TriggerServerEvent("core:labo:update", id, 0, 0, 0)
        end
    end
    if LaboBlocked == true then
        state = 0
    end
    if shouldTakeDrug then
        state = 2
        VFW.Labs.Datas.LaboQuantityDrug = shouldTakeDrug
    end
    VFW.Labs.Datas.LaboState = state
    console.debug("LAbo type items needed", laboType)
    VFW.Labs.Datas.LaboItemsNeeded = {VFW.Labs.LabsPos[laboType].ItemsNeeded[1], VFW.Labs.LabsPos[laboType].ItemsNeeded[2], VFW.Labs.LabsPos[laboType].ItemsNeeded[3]}
    if state == 1 then
        local getProductionTime, percentages2 = TriggerServerCallback("core:getLabProduction", id)
        if getProductionTime then getProduction = getProductionTime end
        if percentages2 then percentages = percentages2 end
    end
    if state == 1 then
        getProduction = getProduction or (VFW.Labs.Datas.MaxTimeProd - 1)
    else
        getProduction = false
    end
    VFW.Labs.Datas.LaboProduction = getProduction
    if percentages[1] and percentages[2] and percentages[3] then
        percentages[1] = math.floor(percentages[1])
        percentages[2] = math.floor(percentages[2])
        percentages[3] = math.floor(percentages[3])
        if percentages[1] > 100.0 then percentages[1] = 100.0 end
        if percentages[2] > 100.0 then percentages[2] = 100.0 end
        if percentages[3] > 100.0 then percentages[3] = 100.0 end
        if percentages[1] < 0 then percentages[1] = 0 end
        if percentages[2] < 0 then percentages[2] = 0 end
        if percentages[3] < 0 then percentages[3] = 0 end
        if percentages[1] == 0 or percentages[2] == 0 or percentages[3] == 0 then
            if state == 1 then
                state = 0
            end
        end
    else
        percentages = {0, 0, 0}
    end
    local firstNeedCount = 5
    local secondNeedCount = 5
    local thirdNeedCount = 5
    if VFW.Labs.Datas.CrewLevel <= 3 then
        print(FormattedDrugDataNeeds[laboType].levelthree[VFW.Labs.LabsPos[laboType].ItemsNeeded[3]])
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelthree[VFW.Labs.LabsPos[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelthree[VFW.Labs.LabsPos[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelthree[VFW.Labs.LabsPos[laboType].ItemsNeeded[3]]
        print("test 1")
    elseif VFW.Labs.Datas.CrewLevel == 4 then
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelfour[VFW.Labs.LabsPos[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelfour[VFW.Labs.LabsPos[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelfour[VFW.Labs.LabsPos[laboType].ItemsNeeded[3]]
        print("test 2")
    else
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelfive[VFW.Labs.LabsPos[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelfive[VFW.Labs.LabsPos[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelfive[VFW.Labs.LabsPos[laboType].ItemsNeeded[3]]
        print("test 3")
    end
    if VFW.Labs.Datas.LaboQuantityDrug > 180 then VFW.Labs.Datas.LaboQuantityDrug = 180 end
    if VFW.Labs.Datas.LaboQuantityDrug < 0 then VFW.Labs.Datas.LaboQuantityDrug = 0 end

    VFW.Nui.Laboratory(true, {
        type = 'updateLaboratoires',
        state = state,
        pourcentage = percentages,
        items = {VFW.Labs.LabNames[VFW.Labs.LabsPos[laboType].ItemsNeeded[1]] .. " (x".. firstNeedCount ..")", VFW.Labs.LabNames[VFW.Labs.LabsPos[laboType].ItemsNeeded[2]] .. " (x".. secondNeedCount ..")", VFW.Labs.LabNames[VFW.Labs.LabsPos[laboType].ItemsNeeded[3]] .. " (x".. thirdNeedCount ..")"},
        quantity = quantity,
        drugName = string.upper(laboType),
        paye = 0,
        quantityDrugs = VFW.Labs.Datas.LaboQuantityDrug,
        lvl = VFW.Labs.Datas.CrewLevel,

        stateOfButton = getProduction,
        stateOfButtonMax = VFW.Labs.Datas.MaxTimeProd,
        image = laboType
    })
end

RegisterNetEvent("core:labo:StartProduction", function(labid, percentages, minutes, state, quantityDrugs)
    if percentages[1] > 100 then percentages[1] = 100 end
    if percentages[2] > 100 then percentages[2] = 100 end
    if percentages[3] > 100 then percentages[3] = 100 end
    if percentages[1] < 0 then percentages[1] = 0 end
    if percentages[2] < 0 then percentages[2] = 0 end
    if percentages[3] < 0 then percentages[3] = 0 end
    VFW.Labs.AllLabs[labid].state = state
    VFW.Labs.AllLabs[labid].minutes = activityPercentage
    VFW.Labs.AllLabs[labid].percentages = {percentages[1], percentages[2], percentages[3]}
    VFW.Labs.AllLabs[labid].quantityDrugs = quantityDrugs
    VFW.Labs.AllLabs[labid].blocked = false
    if InsideLabo and InsideLabo == labid then
        LaboImage = VFW.Labs.Datas.LaboType
        VFW.ShowNotification({
            type = 'VERT',
            content = "La production a été lancée"
        })
        VFW.Nui.Laboratory(false)
        if VFW.Labs.Datas.LaboType == "weed" then
            local calc = activityPercentage == nil and 0 or VFW.Labs.Datas.MaxTimeProd - activityPercentage
            checkWeedProduction(calc, true)
        end
    end
end)

RegisterNUICallback("nui:laboratories:close", function()
    DisplayRadar(true)
    console.debug("Pressed nui:laboratories:close")
    VFW.Nui.Laboratory(false)
end)

RegisterNUICallback("nui:laboratories:start", function()
    local itemsNeeded = {}
    if Config.EnableDebug == false and VFW.PlayerData.faction.name == "nocrew" then
        VFW.ShowNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = 'Action impossible sans crew'
        })
        return
    end
    local crewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", VFW.PlayerData.faction.name)
    VFW.Labs.Datas.MaxTimeProd = MaxTimeProductions[crewLevel]
    VFW.Labs.Datas.LaboCrewLevel = crewLevel
    local MyLab = TriggerServerCallback("core:getMyLab", InsideLabo)
    local itemsBool = TriggerServerCallback("core:lab:launchProduction", InsideLabo, VFW.Labs.Datas.LaboItemsNeeded[1], VFW.Labs.Datas.LaboItemsNeeded[2], VFW.Labs.Datas.LaboItemsNeeded[3], GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[1], crewLevel, VFW.Labs.Datas.LaboType), GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[2], crewLevel, VFW.Labs.Datas.LaboType), GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[3], crewLevel, VFW.Labs.Datas.LaboType))
    if itemsBool then
        CreateLaboPeds(VFW.Labs.Datas.LaboType, InsideLabo)
        console.debug("Go for launch production")
        TriggerServerEvent("core:labo:LaunchProduction", VFW.Labs.Datas.LaboType, VFW.Labs.Datas.LaboQuantity, InsideLabo, VFW.Labs.Datas.LaboState, LaboImage, VFW.Labs.Datas.LaboCrewLevel, VFW.Labs.Datas.MaxTimeProd, MyLab.quantityDrugs, MyLab.minutes, MyLab.PosWork)
    else
        console.debug("Not enough items")
        VFW.Nui.Laboratory(false)
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Item(s) manquant(s) : " ..
    "<span style='color:#e74c3c'>" .. VFW.Labs.Datas.LaboItemsNeeded[1] .. " (x" .. GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[1], crewLevel, VFW.Labs.Datas.LaboType) .. ")</span>, " ..
    "<span style='color:#f39c12'>" .. VFW.Labs.Datas.LaboItemsNeeded[2] .. " (x" .. GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[2], crewLevel, VFW.Labs.Datas.LaboType) .. ")</span>, " ..
    "<span style='color:#8e44ad'>" .. VFW.Labs.Datas.LaboItemsNeeded[3] .. " (x" .. GetNeededAmountForItem(VFW.Labs.Datas.LaboItemsNeeded[3], crewLevel, VFW.Labs.Datas.LaboType) .. ")</span>"
        })
        return
    end
end)

RegisterNUICallback("nui:laboratories:gather", function(data, cb)
    if tonumber(data.quantity) > 0 and InsideLabo then
        TriggerServerEvent("core:lab:takeDrugs", InsideLabo, data.quantity)
        cb(true)
    else
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Montant invalide"
        })
        cb(false)
    end
end)

local function leaveLabo(id, oldCoords)
    DoScreenFadeOut(200)
    VFW.Nui.HudVisible(false)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    SetEntityCoords(VFW.PlayerData.ped, oldCoords.x, oldCoords.y, oldCoords.z)
    TriggerServerEvent("core:updateLastLabo", false, InsideLabo)
    InsideLabo = false
    while not HasCollisionLoadedAroundEntity(VFW.PlayerData.ped) do Wait(1) end
    SetEntityCoords(VFW.PlayerData.ped, oldCoords.x, oldCoords.y, oldCoords.z)
    Wait(1500)
    VFW.Nui.HudVisible(true)
    DoScreenFadeIn(1000)
end

RegisterNetEvent("core:lab:desamorce", function(id)
    if VFW.Labs.AllLabs[id] then
        VFW.Labs.AllLabs[id].attacked = false
        VFW.Labs.AllLabs[id].open = false
    end
end)

local handlePoints = {}

local function deleteHandles()
    for i = 1, 2 do
        if handlePoints[i] then
            Worlds.Zone.Remove(handlePoints[i])
            handlePoints[i] = nil
        end
    end
    VFW.RemoveInteraction("exit_laboE")
    VFW.RemoveInteraction("production_laboE")
end

local function startLoopLabo(id, crew, labo, oldCoords, production, isBlocked)
    InsideLabo = id
    if labo == "cocaine" then labo = "coke" end

    handlePoints[1] = Worlds.Zone.Create(VFW.Labs.LabsPos[labo].entrance, 2, false, function()
        VFW.RegisterInteraction("exit_laboE", function()
            deleteHandles()
            leaveLabo(id, oldCoords)
        end)
    end, function()
        VFW.RemoveInteraction("exit_laboE")
    end, "Sortir", "E", "Sortir")
    
    handlePoints[2] = Worlds.Zone.Create(VFW.Labs.LabsPos[labo].production, 2, false, function()
        VFW.RegisterInteraction("production_laboE", function()
            openLabProduction(id, labo, production)
        end)
    end, function()
        VFW.RemoveInteraction("production_laboE")
    end, "Production", "E", "Laboratoire")
end

 function enterLabo(id, crew, labo, oldCoords)
    -- Todo instance player
    -- Todo add player last property to sql
    local coords = VFW.Labs.LabsPos[labo].entrance
    local int = GetInteriorAtCoords(coords)
    DoScreenFadeOut(200)
    VFW.Nui.HudVisible(false)
    PinInteriorInMemory(int)
    Wait(500)
    SetEntityCoords(VFW.PlayerData.ped, coords)
    Wait(500)
    TriggerServerEvent("core:updateLastLabo", true, id)
    local Labos = TriggerServerCallback("core:getLaboratory")
    console.debug("Crew ", crew)
    crewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", crew) or 0

    console.debug("Crew level", crewLevel)
    VFW.Labs.Datas.MaxTimeProd = MaxTimeProductions[crewLevel]
    console.debug("Test")
    local crewXP = TriggerServerCallback("core:crew:getCrewXpByName", crew) or 0
    VFW.Labs.Datas.CrewLevel = crewLevel
    local WeedSend = 0
    local LabState = 0
    local IsBlocked = false
    local ShouldActualize = false
    local lab = VFW.Labs.AllLabs[id]
    if lab then 
        lab.state = tonumber(lab.state)
        if lab.state == nil or lab.state == false then
            lab.state = 0
        elseif lab.state and lab.state == 1 then
            WeedSend = VFW.Labs.Datas.MaxTimeProd - (tonumber(lab.minutes) or 0)
        elseif lab.state and lab.state == 2 then
            VFW.Labs.Datas.IsInProduction = VFW.Labs.Datas.MaxTimeProd
        end
        if lab.minutes and lab.minutes ~= 0 then
            ShouldActualize = VFW.Labs.Datas.MaxTimeProd - lab.minutes
        end
        if lab.minutes == nil then
            lab.minutes = VFW.Labs.Datas.MaxTimeProd
        end
        LabState = (lab.state or 1)
    end
    if LabState == nil or LabState == false then
        LabState = 0
    end
    if LabState == 1 or LabState == 2 then
        if labo == "coke" then labo = "cocaine" end
        if labo == "weed" then
            if LabState == 2 then
                checkWeedProduction(100)
            else
                checkWeedProduction(WeedSend, true)
            end
        end
    else
        if labo == "weed" then
            checkWeedProduction(ShouldActualize and ShouldActualize or 0)
        end
    end
    Wait(500)
    SetEntityCoords(VFW.PlayerData.ped, coords)
    console.debug("id, crew, labo, oldCoords, VFW.Labs.Datas.IsInProduction, IsBlocked", id, crew, labo, oldCoords, VFW.Labs.Datas.IsInProduction, IsBlocked)
    VFW.Nui.HudVisible(true)
    DoScreenFadeIn(200)
    startLoopLabo(id, crew, labo, oldCoords, VFW.Labs.Datas.IsInProduction, IsBlocked)
end

function playAmorcingBomb()
    RequestAnimDict("misstrevor2ig_7")
    while (not HasAnimDictLoaded("misstrevor2ig_7")) do
        Wait(5)
    end
    TaskPlayAnim(VFW.PlayerData.ped, "misstrevor2ig_7", "plant_bomb", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
    local time = GetAnimDuration("misstrevor2ig_7", "plant_bomb")*1000
    Wait(time)
    RemoveAnimDict("misstrevor2ig_7")
    StopAnimTask(VFW.PlayerData.ped, "misstrevor2ig_7", "plant_bomb", 1.0)
end

local Isclose = false
CreateThread(function()
    while (next(VFW.Labs.AllLabs) == nil) do Wait(100) end
    Wait(1000)
    for k,v in pairs(VFW.Labs.AllLabs) do
        createLaboEnterPoint(k, v)
    end
end)

RegisterNetEvent("core:labo:acceptedsonette", function(id)
    if VFW.Labs.AllLabs[id] then
        enterLabo(id, VFW.Labs.AllLabs[id].crew, VFW.Labs.AllLabs[id].laboType, VFW.Labs.AllLabs[id].coords)
    end
end)

RegisterNetEvent("core:lab:ring", function(id, plyid)
    if InsideLabo and InsideLabo == id then
        VFW.ShowNotification({
            type = 'JAUNE',
            duration = 10,
            content = "Une personne sonne au laboratoire"
        })
        Wait(50)
        VFW.ShowNotification({
            type = 'VERT',
            duration = 10,
            content = "Appuyer sur ~K Y pour ~s accepter"
        })
        VFW.ShowNotification({
            type = 'ROUGE',
            duration = 10,
            content = "Appuyer sur ~K N pour ~s ignorer"
        })
        local breakable = 1
        while true do
            Wait(1)
            if IsControlJustPressed(0, 246) then -- Y
                TriggerServerEvent("core:labo:acceptsonnette", id, plyid)
                break
            end
            if IsControlJustPressed(0, 306) then -- K
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous avez ignoré"
                })
                break
            end
            breakable = breakable + 1
            if breakable > 600 then
                VFW.ShowNotification({
                    type = 'ROUGE',
                    content = "~s Vous avez ignoré"
                })
                break
            end
        end
    end
end)

RegisterNetEvent("core:attackLabo", function()
    for k,v in pairs(VFW.Labs.AllLabs) do
        local dista = #(GetEntityCoords(VFW.PlayerData.ped) - vector3(v.coords.x, v.coords.y, v.coords.z))
        if dista < 2.0 then
            TriggerServerEvent("core:lab:amorcing")
            local obj = GetHashKey("ch_prop_ch_ld_bomb_01a")
            RequestModel(obj)
            while not HasModelLoaded(obj) do
                Wait(1)
            end
            local coords, forward = GetEntityCoords(VFW.PlayerData.ped), GetEntityForwardVector(VFW.PlayerData.ped)
            local objCoords = (coords + forward * 0.5)
            local x,y,z = table.unpack(objCoords)
            local Obj = CreateObject(obj, x,y,z-0.98, 1)
            SetModelAsNoLongerNeeded(obj)
            SetEntityRotation(Obj, 90.0, 0.0, 90.0)
            SetEntityAsMissionEntity(Obj, true, true)
            PlaceObjectOnGroundProperly(Obj)
            playAmorcingBomb()
            VFW.ShowNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous avez amorcé la dynamite, elle explosera dans 10 minutes",
            })
            v.attacked = true
            TriggerServerEvent("core:labo:alertCrew", v.id, v.crew)
            Wait(10*60000)
            --xSound:PlayUrl("bip", "https://youtu.be/JmVub7sTpc0", 1.0)
            if v.attacked == true then
                xSound:PlayUrlPos('bip', 'https://youtu.be/JmVub7sTpc0', 0.45, vector3(x,y,z))
                while not xSound:soundExists("bip") do Wait(1) end
                Wait(6200)
                DeleteEntity(Obj)
                AddExplosion(x,y,z, 2, 10.0, true, false, 1.0)
                xSound:Destroy("bip")
                v.open = true
                TriggerServerEvent("core:labo:setOpen", v.id, true)
            end
        end
    end
end)

RegisterNetEvent("core:labo:alertCrew", function(id,crew)
    if crew == VFW.PlayerData.faction.name then
        VFW.ShowNotification({
            type = 'JAUNE',
            duration = 15,
            content = "Votre laboratoire est en train d'être attaqué !"
        })
        PlaySoundFrontend(-1,'Boss_Message_Orange','GTAO_Boss_Goons_FM_Soundset',1)
    end
    if VFW.Labs.AllLabs[id] then 
        VFW.Labs.AllLabs[id].attacked = true
    end
end)

RegisterNetEvent("core:labo:setOpen", function(id, bool)
    if VFW.Labs.AllLabs[id] then 
        VFW.Labs.AllLabs[id].open = bool
    end
end)

RegisterNetEvent("core:labo:gotDeleted", function(id)
    RemoveInteractPoint("enter_labo", id)
    VFW.Labs.AllLabs[id] = nil
end)

RegisterNetEvent("core:labo:sendnotif", function(crew, msg, id)
    if crew ~= VFW.PlayerData.faction.name then
        return 
    end
    if type(msg) ~= "string" and type(msg) == "number" then
        if VFW.Labs.AllLabs[id] then 
            VFW.Labs.AllLabs[id].percentages[1] = 0
            VFW.Labs.AllLabs[id].percentages[2] = 0
            VFW.Labs.AllLabs[id].percentages[3] = 0
            VFW.Labs.AllLabs[id].minutes = nil
            VFW.Labs.AllLabs[id].state = 0
            VFW.Labs.AllLabs[id].blocked = true
        end
    else
        local labotype = "weed"
        if VFW.Labs.AllLabs[id] then 
            labotype = VFW.Labs.AllLabs[id].laboType
        end
        ColorsLab = {
            ["weed"] = "#0E8313",
            ["coke"] = "#D12410",
            ["fentanyl"] = "#D1C810",
            ["meth"] = "#10A8D1",
        }
        VFW.ShowNotification({
            type = 'ILLEGAL',
            name = "Lester",
            label = "Laboratoire",
            labelColor = ColorsLab[labotype],
            logo = "https://cdn.eltrane.cloud/3838384859/Discord/11871954819531448521187719957442744320image.webp",
            mainMessage = msg,
            duration = 10,
        })
    end

    setIplState(247297,     VFW.Labs.LabsPos["weed"].weedState.full, false, true)
end)



-- WEED IPL

RegisterCommand("propweedipl", function(source, args)
    if args[1] == "full" then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.full, true, true)
    elseif args[1] == "medium" then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.medium, true, true)
    elseif args[1] == "small" then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
        Wait(20)
        setIplState(247297, VFW.Labs.LabsPos["weed"].weedState.small, true, true)
    elseif args[1] == "empty" then
        setIplState(247297, {VFW.Labs.LabsPos["weed"].weedState.small, VFW.Labs.LabsPos["weed"].weedState.medium, VFW.Labs.LabsPos["weed"].weedState.full}, false, true)
    end
end)


