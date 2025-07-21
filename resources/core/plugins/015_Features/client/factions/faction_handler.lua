MyFaction = {}

local LEVELS <const> = {
    { rank = "D", level = 5, xpRequired = 0 },
    { rank = "C", level = 10, xpRequired = 1000  },
    { rank = "B", level = 25, xpRequired = 3000   },
    { rank = "A", level = 50, xpRequired = 7000  },
    { rank = "S", level = 100, xpRequired = 14000  }
}


function HasFactionPermission(permission)
    local faction = VFW.PlayerData.faction
    if not faction or not faction.permissions then return false end

    local gradeName = string.lower(faction.grade_name or "")
    local gradePermissions = faction.permissions[gradeName]

    if not gradePermissions then return false end

    return gradePermissions[permission] == true
end

local nextLevelXpTarget = 0

---@param xp number
---@return number T
local function getProgressionPercentage(xp)
    -- Si l'XP est supérieure ou égale à celle du dernier niveau, retourner 100%
    if xp >= LEVELS[#LEVELS].xpRequired then
        return 100
    end

    local nextLevelTarget = 0

    -- Trouver le prochain niveau d'XP requis
    for i = 1, #LEVELS do
        if xp < LEVELS[i].xpRequired then
            nextLevelTarget = LEVELS[i].xpRequired
            nextLevelXpTarget = LEVELS[i].xpRequired
            break
        end
    end

    -- Si aucun niveau suivant n'a été trouvé (cas impossible normalement)
    if nextLevelTarget == 0 then
        return 100
    end

    -- Calcul simple: (XP actuelle / XP requise pour le prochain niveau) * 100
    local percentage = (xp / nextLevelTarget) * 100

    return percentage
end

function GetCrewRank()
    local xp = MyFaction.MyCrewLevel
    local rank = "D"
    if xp == nil then
        xp = 0
    end

    for i = 1, #LEVELS do
        local levelInfo = LEVELS[i]
        if xp < levelInfo.xpRequired then
            rank = levelInfo.rank
            if i > 1 then
                rank = LEVELS[i - 1].rank
            end
            break
        elseif i == #LEVELS then
            rank = levelInfo.rank
        end
    end

    return rank
end

function subRadialGestion()
    local ELEMENTS <const> = {}

    table.insert(ELEMENTS, {
        name = "QUITTER LE CREW",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/leave.svg",
        action = "LeaveCrew"
    })
    
    if HasFactionPermission("manage_permissions") then
        table.insert(ELEMENTS, {
            name = "GESTION",
            icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/gestion.svg",
            action = "OpenCrewGestion"
        })
    end


    table.insert(ELEMENTS, {
        name = "RETOUR",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/leave.svg",
        action = "OpenRadialFaction"
    })

    table.insert(ELEMENTS, {
        name = "INVITER",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/gestion.svg",
        action = "InviteCrew"
    })

    VFW.Nui.Radial({ elements = ELEMENTS, title = "Gestion", key = "F2" }, true)
end

function OpenRadialFaction()
    local MY_CREW <const> = VFW.PlayerData.faction.name
    local MyCrewLabel = VFW.PlayerData.faction.label
    MyFaction.MyCrewLevel, MyFaction.MyCrewColor = TriggerServerCallback('core:faction:getCrewInfosForRadial', MY_CREW)

    if RadialOpen then
        VFW.Nui.Radial(nil, false)
        RadialOpen = false
        return
    end

    if MY_CREW == "nocrew" then
        return
    end
    local ELEMENTS <const> = {}

    table.insert(ELEMENTS, {
        name = "TERRITOIRE",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/territoire.svg",
        action = "OpenMenuTerrioire"
    })

        table.insert(ELEMENTS, {
            name = "GESTION",
            icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/gestion.svg",
            action = "subRadialGestion"
        })

    table.insert(ELEMENTS, {
        name = "TABLETTE",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/Tablette.svg",
        action = "OpenIllegalTablet"
    })

    table.insert(ELEMENTS, {
        name = "MISSION",
        icon = "https://cdn.eltrane.cloud/alkiarp/assets/radialmenus/mission.svg",
        action = "OpenSecuroServCenter"
    })


    local CREW_INFOS <const> = {
        crew = MyCrewLabel,
        time = "0",
        color = MyFaction.MyCrewColor or "#33963C",
        value = getProgressionPercentage(MyFaction.MyCrewLevel),
        valueString = MyFaction.MyCrewLevel .. "/" .. nextLevelXpTarget,
        rank = GetCrewRank(),
        image = MyFaction.image,
        postAsync = { -- Required otherwise the front does not receive the data
            url = "test",
            data = {},
        }
    }

    VFW.Nui.Radial({ elements = ELEMENTS, title = "CREW", key = "F2", bar = CREW_INFOS }, true)
    RadialOpen = true
end

function VFW.LoadMyFaction()
    while (not VFW.PlayerData) do
        Wait(1000)
    end
    while (not VFW.PlayerData.faction) do
        Wait(1000)
    end
    local FACTION <const> = VFW.PlayerData.faction.name

    console.debug("Faction name : ", FACTION)

    VFW.RegisterInput("radialcrew", "Menu radial faction", "keyboard", "F2", OpenRadialFaction)
    console.debug("Loaded faction " .. FACTION)
end

VFW.LoadMyFaction()


RegisterCommand("GetCrew",function()
    local FACTION <const> = VFW.PlayerData.faction.name
    if FACTION == "nocrew" then
        print("Vous n'avez pas de crew", "error")
    else
        print("Vous avez le crew : " .. FACTION, "success")
    end
end)
RegisterNetEvent("vfw:setFaction", function(Faction)
    VFW.LoadMyFaction()
end)

RegisterNetEvent("core:faction:updateFaction", function(name, data)
    VFW.Factions.Cache.Factions = nil
    if name == VFW.PlayerData.faction.name then
        MyFaction.MyCrewLevel = data.xp
        MyFaction.MyCrewColor = data.color
        VFW.PlayerData.faction.devise = data.devise
    end
end)


local function IsTargetLowerRank(ped)
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local targetData = TriggerServerCallback("vfw:IsTargetLowerRank",targetServerId)
    return targetData
end


VFW.Crew = VFW.ContextAddSubmenu("ped", "Crew" , function(ped)
    local FACTION <const> = VFW.PlayerData.faction.name
    return IsPedAPlayer(ped) and VFW.PlayerGlobalData.permissions["contextmenu"] and FACTION ~= "nocrew" 
end, { color = {123, 255, 123} }, nil)




VFW.ContextAddButton("ped", "Invité", function(ped)
    return IsPedAPlayer(ped) and HasFactionPermission("kick") 
end, function(ped)
    if ped then
        TriggerServerEvent("core:faction:invitePlayer", GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
        VFW.ShowNotification({  
            type = 'ROUGE',
            content = "Vous avez invité " .. GetPlayerName(NetworkGetPlayerIndexFromPed(ped))
        })
    end
end, {}, VFW.Crew)

VFW.ContextAddButton("ped", "Promouvoir", function(ped)
    return IsPedAPlayer(ped) and HasFactionPermission("promote") and IsTargetLowerRank(ped)     
end, function(ped)
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    TriggerServerCallback("core:crew:UpToNewRoles", targetServerId, 'promote')
end, {}, VFW.Crew)

VFW.ContextAddButton("ped", "Rétrograder", function(ped)
    return IsPedAPlayer(ped) and HasFactionPermission("demote") and IsTargetLowerRank(ped) 
end, function(ped)
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    TriggerServerCallback("core:crew:UpToNewRoles", targetServerId, 'demote')
end, {}, VFW.Crew)

VFW.ContextAddButton("ped", "Exclure", function(ped)
    return IsPedAPlayer(ped) and HasFactionPermission("kick") and IsTargetLowerRank(ped)    
end, function(ped)
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    TriggerServerCallback("core:crew:UpToNewRoles", targetServerId, 'kick')
end, { color = {255, 64, 64} }, VFW.Crew)
