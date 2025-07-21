local pawnshopPed = nil
local pawnshopZone = nil
local PawnshopConfig = nil

local function CreatePawnshopPedClient()
    if PawnshopConfig and PawnshopConfig.ped then
        local hash = GetHashKey(PawnshopConfig.ped.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end
        pawnshopPed = CreatePed(4, hash, PawnshopConfig.ped.coords.x, PawnshopConfig.ped.coords.y, PawnshopConfig.ped.coords.z - 1.0, PawnshopConfig.ped.coords.w, false, true)
        SetEntityAsMissionEntity(pawnshopPed, true, true)
        SetEntityInvincible(pawnshopPed, true)
        SetBlockingOfNonTemporaryEvents(pawnshopPed, true)
        SetPedCanRagdoll(pawnshopPed, false)
        FreezeEntityPosition(pawnshopPed, true)
        TaskStartScenarioInPlace(pawnshopPed, PawnshopConfig.ped.scenario, 0, true)
        SetModelAsNoLongerNeeded(hash)
    end
end

local function DeletePawnshopPedClient()
    if pawnshopPed and DoesEntityExist(pawnshopPed) then
        DeleteEntity(pawnshopPed)
        pawnshopPed = nil
    end
end

local function CreatePawnshopZone()
    if PawnshopConfig and PawnshopConfig.ped then
        pawnshopZone = Worlds.Zone.Create(
            vector3(PawnshopConfig.ped.coords.x, PawnshopConfig.ped.coords.y, PawnshopConfig.ped.coords.z),
            PawnshopConfig.interaction.distance,
            false,
            function()
                VFW.RegisterInteraction("pawnshop_exchange", function()
                    TriggerServerEvent("pawnshop:exchangeItems")
                end)
            end,
            function()
                VFW.RemoveInteraction("pawnshop_exchange")
            end,
            PawnshopConfig.interaction.text, 
            PawnshopConfig.interaction.key, 
            PawnshopConfig.interaction.icon
        )
    end
end

local function DeletePawnshopZone()
    if pawnshopZone then
        Worlds.Zone.Remove(pawnshopZone)
        pawnshopZone = nil
        VFW.RemoveInteraction("pawnshop_exchange")
    end
end

CreateThread(function()
    while not VFW.PlayerData do
        Wait(100)
    end
    PawnshopConfig = exports["core"]:GetPawnshopConfig()
    if PawnshopConfig then
        CreatePawnshopPedClient()
        CreatePawnshopZone()
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeletePawnshopPedClient()
        DeletePawnshopZone()
    end
end)

