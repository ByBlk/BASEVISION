local LastGestion = nil

local cams = {
PlayerCam = {
    CamCoords = {
        x = -68.97504425048828,
        y = -805.3873291015625,
        z = 243.92337036132813
    },
    CamRot = {
        x = -0.58160853385925,
        y = 0.0,
        z = 67.77142333984375
    },
    Dof = true,
    DofStrength = 0.9,
    Freeze = true,
    Fov = 51.0,
    COH = {
        x = -69.6558609008789,
        y = -805.0010375976563,
        z = 243.40077209472657,
        w = 236.03646850585938
    },
    Animation = {
        dict = "anim@amb@casino@hangout@ped_male@stand@02b@idles",
        anim = "idle_a"
    }
},
    PedsCam = {
        CamCoords = {
        x = -68.97504425048828,
        y = -805.3873291015625,
        z = 243.92337036132813
    },
    CamRot = {
        x = -0.58160853385925,
        y = 0.0,
        z = 67.77142333984375
    },
    Dof = true,
    DofStrength = 0.9,
    Freeze = true,
    Fov = 51.0,
    COH = {
        x = -69.6558609008789,
        y = -805.0010375976563,
        z = 243.40077209472657,
        w = 236.03646850585938
    },
    Animation = {
        dict = "anim@amb@casino@hangout@ped_male@stand@02b@idles",
        anim = "idle_a"
    }
    },
    RandomPeds = {
        'g_m_importexport_01',
        'g_m_y_armgoon_02',
        'g_m_y_korean_02',
        'g_m_y_salvaboss_01',
        'g_f_y_vagos_01',
    },
}

local peds = {}

local function createPed(hash, x, y, z, h)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
    end
    local ped = CreatePed(4, hash, x, y, z, h)
    SetModelAsNoLongerNeeded(hash)
    return ped
end

local function deleteCams(name)
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    VFW.Cam:Destroy(name)
    

    if cams.Ped and DoesEntityExist(cams.Ped) then
        DeleteEntity(cams.Ped)
        cams.Ped = nil
    end

    if peds and next(peds) then
        for i = 1, #peds do
            if DoesEntityExist(peds[i]) then
                DeleteEntity(peds[i])
            end
        end
        peds = {}
    end

    ClearFocus()
    DoScreenFadeIn(1000)
    VFW.Nui.HudVisible(true)
end

local function createCam(gestionTable, multipleTable, data)
    local ped
    local clonePlayer1, tattooPlayer1, clonePlayer2, tattooPlayer2 = TriggerServerCallback("core:jobs:getClonePed", VFW.PlayerData.job.name)
    
    -- Debug prints
    print("Données des membres du job:")
    print("clonePlayer1:", json.encode(clonePlayer1))
    print("tattooPlayer1:", json.encode(tattooPlayer1))
    print("clonePlayer2:", json.encode(clonePlayer2))
    print("tattooPlayer2:", json.encode(tattooPlayer2))
    
    local randomPeds = cams.RandomPeds

    if Society.Jobs and Society.Jobs[VFW.PlayerData.job.name] and Society.Jobs[VFW.PlayerData.job.name].CamGestion then
        randomPeds = Society.Jobs[VFW.PlayerData.job.name].CamGestion.RandomPeds
    elseif Config.Faction.Gestion[VFW.PlayerData.job.name] and Config.Faction.Gestion[VFW.PlayerData.job.name].cams then
        randomPeds = Config.Faction.Gestion[VFW.PlayerData.job.name].cams.RandomPeds
    else
        randomPeds = cams.RandomPeds
    end

    if (not data) then
        cams.Ped = ClonePed(VFW.PlayerData.ped, false, false)
        VFW.Cam:Create("camGestion", gestionTable, cams.Ped)
        ped = cams.Ped
    elseif data and data.ped == "random" then
        math.randomseed(GetGameTimer())
        local randomizedPed = randomPeds[math.random(1, #randomPeds)]
        peds[#peds + 1] = createPed(randomizedPed, gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z, gestionTable.COH.w)
        SetModelAsNoLongerNeeded(randomizedPed)
        VFW.Cam:UpdateAnim("camGestion", gestionTable.Animation, peds[#peds])
        ped = peds[#peds]
    elseif data and data.ped == "player1" then
        if clonePlayer1 then
            peds[#peds + 1] = VFW.CreatePlayerClone(clonePlayer1, tattooPlayer1, vector3(gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z), gestionTable.COH.w)
            VFW.Cam:UpdateAnim("camGestion", gestionTable.Animation, peds[#peds])
            ped = peds[#peds]
        else
            return createCam(gestionTable, multipleTable, {ped = "random"})
        end
    elseif data and data.ped == "player2" then
        if clonePlayer2 then
            peds[#peds + 1] = VFW.CreatePlayerClone(clonePlayer2, tattooPlayer2, vector3(gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z), gestionTable.COH.w)
            VFW.Cam:UpdateAnim("camGestion", gestionTable.Animation, peds[#peds])
            ped = peds[#peds]
        else
            return createCam(gestionTable, multipleTable, {ped = "random"})
        end
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetEntityVisible(ped, false, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetFocusPosAndVel(gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z - 1.0)
    SetEntityCoords(ped, gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z)
    Wait(100)
    SetEntityVisible(ped, true, false)
    SetEntityHeading(ped, gestionTable.COH.w)
    SetEntityCoords(ped, gestionTable.COH.x, gestionTable.COH.y, gestionTable.COH.z - 1.0)

    if not clonePlayer1 then
        if multipleTable then
            for i = 1, #multipleTable do
                createCam(multipleTable[i], nil, { ped = "random" })
            end
        end
    else
        if multipleTable then
            for i = 1, #multipleTable do
                if i == 1 then
                    createCam(multipleTable[i], nil, { ped = "player1" })
                else
                    if clonePlayer2 then
                        createCam(multipleTable[i], nil, { ped = "player2" })
                    else
                        createCam(multipleTable[i], nil, { ped = "random" })
                    end
                end
            end
        end
    end

    DoScreenFadeIn(1000)
end

function JobGestionOpen()
    local permissions = VFW.PlayerData.job.perms
    print(json.encode(permissions))
    local members = TriggerServerCallback("core:jobs:getMembers") or {}
    local numberService = TriggerServerCallback("core:jobs:getNumberMembers") or 0
    local properties = TriggerServerCallback("core:jobs:getProperties") or {}

    local vehicles = {}

    for k, v in pairs (properties) do
        if v.type == "Garage" then
            for i = 1, #v.vehicles do
                local vehicle = v.vehicles[i]
                if vehicle then
                     table.insert(vehicles,{model = vehicle.name, plate = vehicle.plate})
                end
            end
        end
    end

    if VFW.PlayerData.job.type == "faction" then
        local numberSup = TriggerServerCallback("core:jobs:getNumberSup") or 0

        VFW.Nui.FactionGestion(true, {
            type = "faction",
            name = VFW.PlayerData.job.label,
            label = VFW.PlayerData.job.label,
            devise = VFW.PlayerData.job.devise,
            colorsList = VFW.Factions.faction.Colors,
            infos = {
                { label = "Membres", value = #members },
                { label = "En services", value = numberService },
                { label = "Superviseur", value = numberSup },
            },
            color = VFW.PlayerData.job.color,
            menuColor = VFW.Factions.faction.menuColor,
            permissions = {
                {
                    edit = true,
                    id = 1,
                    fname = "Chief Office",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Command Staff",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Supervisor",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Officer",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Rookie",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].custom or false,
                        },
                    },
                },
            },
            members = members,
            properties = properties,
            vehs = vehicles,
        })
    elseif VFW.PlayerData.job.type == "job" then
        VFW.Nui.FactionGestion(true, {
            type = "company",
            name = VFW.PlayerData.job.label,
            label = VFW.PlayerData.job.label,
            devise = VFW.PlayerData.job.devise,
            colorsList = VFW.Factions.faction.Colors,
            infos = {
                { label = "Membres", value = #members },
                { label = "En services", value = numberService },
                { label = "Chiffre d'affaire", value = 0 },
            },
            color = VFW.PlayerData.job.color,
            menuColor = VFW.Factions.company.menuColor,
            permissions = {
                {
                    edit = true,
                    id = 1,
                    fname = "Patron",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["boss"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["boss"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Co Patron",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["copatron"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["copatron"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "DRH",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["drh"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["drh"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Employée Experimenté",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["exp"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["exp"].custom or false,
                        },
                    },
                },
                {
                    edit = true,
                    id = 1,
                    fname = "Novice",
                    lname = "",
                    permission = {
                        {
                            fname = "Recruter un joueur",
                            idname = "recruit",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].recruit or false,
                        },
                        {
                            fname = "Promouvoir un joueur",
                            idname = "promote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].promote or false,
                        },
                        {
                            fname = "Rétrogader un joueur",
                            idname = "demote",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].demote or false,
                        },
                        {
                            fname = "Exclure un joueur",
                            idname = "kick",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].kick or false,
                        },
                        {
                            fname = "Gérer les permissions",
                            idname = "manage_permissions",
                            lname = "",
                            id = 2,
                            IsAcces = permissions["novice"].manage_permissions or false,
                        },
                        {
                            fname = "Annonce",
                            idname = "announce",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].announce or false,
                        },
                        {
                            fname = "Facture",
                            idname = "billing",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].billing or false,
                        },
                        {
                            fname = "Comptabilité",
                            idname = "accounting",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].accounting or false,
                        },
                        {
                            fname = "Customiser",
                            idname = "custom",
                            lname = "",
                            id = 3,
                            IsAcces = permissions["novice"].custom or false,
                        },
                    },
                },
            },
            members = members,
            properties = properties,
            vehs = vehicles,
        })
    end
end

open = false
local ped = nil

RegisterNUICallback("nui:orgaManagement:close", function()
    if not open then return end
    VFW.Nui.FactionGestion(false)
    open = false
    deleteCams("camGestion")
    VFW.Cam:Destroy("requestMemberCam")
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
    end
end)

local function RequestMemberCam(skin, tattoos, data)
    ped = VFW.CreatePlayerClone(skin, tattoos, vector3(data.COH.x, data.COH.y, data.COH.z), data.COH.w)
    VFW.Cam:Create("requestMemberCam", data, ped)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityVisible(ped, false, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetFocusPosAndVel(data.COH.x, data.COH.y, data.COH.z - 1.0)
    SetEntityCoords(ped, data.COH.x, data.COH.y, data.COH.z)
    Wait(100)
    SetEntityVisible(ped, true, false)
    SetEntityHeading(ped, data.COH.w)
    SetEntityCoords(ped, data.COH.x, data.COH.y, data.COH.z - 1.0)
    VFW.Cam:UpdateAnim("requestMemberCam", data.Animation, ped)
    DoScreenFadeIn(1000)
end

RegisterNUICallback("nui:orgaManagement:requestMemberCam", function(data)
    if not Society.Jobs[VFW.PlayerData.job.name] or Society.Jobs[VFW.PlayerData.job.name].CamGestion.MemberCam then return end
    if not open then return end
    local identifier = data.identifier

    if (identifier) then
        SetNuiFocus(false, false)

        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        local skin, tattoos = TriggerServerCallback("core:jobs:requestMemberCam", identifier)

        deleteCams("camGestion")
        VFW.Nui.HudVisible(false)

        RequestMemberCam(skin, tattoos, Society.Jobs[VFW.PlayerData.job.name].CamGestion.MemberCam)

        SetNuiFocus(true, true)
    else
        SetNuiFocus(false, false)

        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        VFW.Cam:Destroy("requestMemberCam")

        DeleteEntity(ped)

        if Society.Jobs[VFW.PlayerData.job.name].CamGestion then
            createCam(Society.Jobs[VFW.PlayerData.job.name].CamGestion.PlayerCam, Society.Jobs[VFW.PlayerData.job.name].CamGestion.PedsCam)
        else
            createCam(cams.PlayerCam, cams.PedsCam)
        end

        SetNuiFocus(true, true)
    end
end)

function Society.loadGestion(job)
    if LastGestion then
        console.debug("Removing LastGestion:", LastGestion)
        Worlds.Zone.Remove(LastGestion)
        LastGestion = nil
    end
    if not Society.Jobs[job] or not Society.Jobs[job].Gestion then
        return
    end

    if type(Society.Jobs[job].Gestion) == "table" then
        for key, position in ipairs(Society.Jobs[job].Gestion) do
            LastGestion = VFW.CreateBlipAndPoint("society:gestion:"..job..key, position, 1, false, false, false, false, "Gestion", "E", "Catalogue", {
                onPress = function()
                    if VFW.PlayerData.job.grade < 2 then
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "~s Vous n'avez pas accès à cette action"
                        })
                        return
                    end

                    if not VFW.PlayerData.job.onDuty then
                        VFW.ShowNotification({
                            type = 'ROUGE',
                            content = "~s Vous n'êtes pas en service"
                        })
                        return
                    end
                    open = true
                    DoScreenFadeOut(1000)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(0)
                    end
                    if Society.Jobs[job].CamGestion then
                        print("il utilise celle de la config")
                        createCam(Society.Jobs[job].CamGestion.PlayerCam, Society.Jobs[job].CamGestion.PedsCam)
                    else
                        print("il utilise celle par défaut # la ")
                        createCam(cams.PlayerCam, cams.PedsCam)
                    end
                    JobGestionOpen()
                end
            })
        end
    else
        LastGestion = VFW.CreateBlipAndPoint("society:gestion:"..job, Society.Jobs[job].Gestion, 1, false, false, false, false, "Gestion", "E", "Catalogue", {
            onPress = function()
                if VFW.PlayerData.job.grade < 2 then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Vous n'avez pas accès à cette action"
                    })
                    return
                end

                if not VFW.PlayerData.job.onDuty then
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~s Vous n'êtes pas en service"
                    })
                    return
                end
                open = true
                DoScreenFadeOut(1000)
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end
                if Society.Jobs[job].CamGestion then
                    print("il utilise celle de la config # caca")
                    createCam(Society.Jobs[job].CamGestion.PlayerCam, Society.Jobs[job].CamGestion.PedsCam)
                else
                    print("il utilise celle par défaut # ici")
                    createCam(cams.PlayerCam, cams.PedsCam)
                end
                JobGestionOpen()
            end
        })
    end

    return true
end




CreateThread(function()
    for k, v in pairs(Config.Faction.Gestion) do
    VFW.CreateBlipAndPoint("society:gestion:"..k, v.pos, 1, false, false, false, false, "Gestion", "E", "Catalogue", {
            onPress = function()
                if VFW.PlayerData.job.name ~= k then
                    VFW.ShowNotification({
                        type = "ROUGE",
                        content = "Vous n'avez pas accès à la gestion de cette faction.",
                    })
                    return
                end

                if not VFW.PlayerData.job.perms or not VFW.PlayerData.job.perms[VFW.PlayerData.job.grade_name] or not VFW.PlayerData.job.perms[VFW.PlayerData.job.grade_name].manage_permissions then
                    VFW.ShowNotification({
                        type = "ROUGE",
                        content = "Vous n'avez pas les permissions nécessaires pour accéder à la gestion.",
                    })
                    return
                end

                DoScreenFadeOut(1000)
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end
                open = true
                if Config.Faction.Gestion[k] and Config.Faction.Gestion[k].cams and Config.Faction.Gestion[k].cams.PlayerCam and Config.Faction.Gestion[k].cams.PedsCam then
                    createCam(Config.Faction.Gestion[k].cams.PlayerCam, Config.Faction.Gestion[k].cams.PedsCam)
                else
                    print("Configuration de caméra non trouvée pour le job: " .. k .. ", utilisation de la configuration par défaut")
                    createCam(cams.PlayerCam, cams.PedsCam)
                end
                JobGestionOpen()
                DoScreenFadeIn(1000)
                while not IsScreenFadedIn() do
                    Citizen.Wait(0)
                end
            end
        })
    end
end)    
