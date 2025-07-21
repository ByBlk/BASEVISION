local BLIP_MANAGER = {
    LIST = {};
};

function BLIP_MANAGER.getFromId(PLAYER_ID)
    PLAYER_ID = tonumber(PLAYER_ID)
    local SELECT_BLIP = BLIP_MANAGER["LIST"][PLAYER_ID]

    return (SELECT_BLIP ~= nil and DoesBlipExist(SELECT_BLIP) and SELECT_BLIP) or false
end

function BLIP_MANAGER.check(PLAYER_ID, PLAYER_VALUES)
    local BLIP_NAME = ("CORE:JOBS:BLIP:PLAYER#%s"):format(PLAYER_ID)
    local BLIP_REGISTERED = BLIP_MANAGER.getFromId(PLAYER_ID)
    local PLAYER_SELECTED = GetPlayerFromServerId(tonumber(PLAYER_ID))
    local PLAYER_PED = ((PLAYER_SELECTED ~= -1 and GetPlayerPed(PLAYER_SELECTED)) or false)
    local PLAYER_COORDS = ((PLAYER_PED ~= false and GetEntityCoords(PLAYER_PED)) or PLAYER_VALUES["COORDS"]["POS"])
    local PLAYER_ROTATION = ((PLAYER_PED ~= false and GetEntityHeading(PLAYER_PED)) or PLAYER_VALUES["COORDS"]["HEADING"])

    local BLIP_CREATED = (not BLIP_REGISTERED and (PLAYER_SELECTED ~= -1 and AddBlipForEntity(PLAYER_PED) or AddBlipForCoord(PLAYER_COORDS.x, PLAYER_COORDS.y, PLAYER_COORDS.z)) or BLIP_REGISTERED)
    BLIP_MANAGER["LIST"][tonumber(PLAYER_ID)] = BLIP_CREATED

    if (BLIP_REGISTERED and (PLAYER_SELECTED ~= -1) and GetBlipInfoIdEntityIndex(BLIP_REGISTERED) == 0) then
        if (DoesBlipExist(BLIP_CREATED)) then
            RemoveBlip(BLIP_CREATED)
        end

        BLIP_CREATED = AddBlipForEntity(PLAYER_PED)
        BLIP_MANAGER["LIST"][tonumber(PLAYER_ID)] = BLIP_CREATED
    end

    SetBlipCategory(BLIP_CREATED, 7)
    ShowHeadingIndicatorOnBlip(BLIP_CREATED, true)
    SetBlipShrink(BLIP_CREATED, (PLAYER_SELECTED ~= -1 and false) or true)
    SetBlipScale(BLIP_CREATED,  0.85)
    SetBlipSprite(BLIP_CREATED, 1)
    SetBlipColour(BLIP_CREATED, 0)
    SetBlipCoords(BLIP_CREATED, PLAYER_COORDS)
    SetBlipRotation(BLIP_CREATED, math.ceil(PLAYER_ROTATION))

    AddTextEntry(BLIP_NAME, ("Bracelet de : %s"):format(tostring(PLAYER_VALUES["NAME"])))
    BeginTextCommandSetBlipName(BLIP_NAME)
    EndTextCommandSetBlipName(BLIP_CREATED)
end

function BLIP_MANAGER.delete(PLAYER_ID)
    local SELECT_BLIP = BLIP_MANAGER.getFromId(PLAYER_ID)

    if (not SELECT_BLIP) then
        return false
    end

    if (DoesBlipExist(SELECT_BLIP)) then
        RemoveBlip(SELECT_BLIP)
    end

    BLIP_MANAGER["LIST"][tonumber(PLAYER_ID)] = nil
end

RegisterNetEvent("CORE:JOBS:BLIP:ACTIONS", function(DATA)
    if (DATA["ACTION"] == "LIST") then
        local myPLAYER_ID = GetPlayerServerId(PlayerId())
        local PLAYERS_REGISTERED = DATA["VALUE"]

        for PLAYER_ID, PLAYER_VALUES in pairs(PLAYERS_REGISTERED) do
            if ((tonumber(PLAYER_ID) ~= tonumber(myPLAYER_ID)) and type(PLAYER_VALUES) == "table") then
                BLIP_MANAGER.check(PLAYER_ID, PLAYER_VALUES)
            end
        end
    elseif (DATA["ACTION"] == "DELETE") then
        local BLIP_VALUE = DATA["VALUE"]

        if (BLIP_VALUE == "ALL") then
            for PLAYER_ID, _ in pairs(BLIP_MANAGER["LIST"]) do
                BLIP_MANAGER.delete(PLAYER_ID)
            end
            return
        end

        return BLIP_MANAGER.delete(DATA["VALUE"])
    end
end)

local lastZone = {}
local lastJob = nil

local function createZone(name, positions, interactLabel, interactKey, interactIcons, action, colors)
    local zone = Worlds.Zone.Create(positions, 2, false, function()
        if action.onEnter then
            action.onEnter()
        end
        if action.onPress then
            VFW.RegisterInteraction(name, action.onPress)
        end
    end, function()
        VFW.RemoveInteraction(name)
        if action.onExit then
            action.onExit()
        end
    end, interactLabel, interactKey, interactIcons, colors)

    return zone
end

local function loadBracelet()
    while not VFW.Jobs or not VFW.Jobs.Menu or not VFW.Jobs.Menu.Bracelet do
        Wait(100)
    end

    while not next(VFW.Jobs.Menu.Bracelet) do
        Wait(100)
    end

    if not lastJob or not VFW.Jobs.Menu.Bracelet[lastJob] then return end

    local config = VFW.Jobs.Menu.Bracelet[lastJob]

    lastZone = {}

    for _, pedData in ipairs(config.Point) do
        for _, coord in ipairs(pedData.coords) do
            local coords = vector(coord.x, coord.y, coord.z + 1.25)
            lastZone[#lastZone + 1] = createZone(
                    pedData.zone.name,
                    coords,
                    pedData.zone.interactLabel,
                    pedData.zone.interactKey,
                    pedData.zone.interactIcons,
                    { onPress = pedData.zone.onPress }
            )
            Wait(25)
        end
    end
end

local function deletingZone()
    for i, zone in ipairs(lastZone) do
        if zone then
            Worlds.Zone.Remove(zone)
            lastZone[i] = nil
        end
    end

    VFW.RemoveInteraction(("bracelet_%s"):format(lastJob))

    lastZone = {}
end

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    deletingZone()
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    Wait(1000)
    loadBracelet()
end)

local bracelet = {
    [0] = { 11, 0 },
    [1] = { 8, 0 },
}

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then
        deletingZone()
        lastJob = nil
    end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadBracelet()
    
    if not VFW.PlayerData.metadata.bracelet then return end
    
    if VFW.PlayerData.metadata.bracelet.isBracelet then
        CreateThread(function()
            while true do
                if VFW.PlayerData.metadata.bracelet.isBracelet then
                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerEvent("skinchanger:change", "chain_1", bracelet[skin.sex][1])
                        TriggerEvent("skinchanger:change", "chain_2", bracelet[skin.sex][2])
                    end)
                else
                    TriggerEvent("skinchanger:change", "chain_1", 0)
                    TriggerEvent("skinchanger:change", "chain_2", 0)
                    break
                end
                Wait(1000)
            end
        end)
    end
end)