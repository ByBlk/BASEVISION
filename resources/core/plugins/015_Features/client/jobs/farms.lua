local ConfigFarms = Config.Farms or {}
local pointOccupe = {}

local function getJob()
    return VFW and VFW.PlayerData and VFW.PlayerData.job and VFW.PlayerData.job.name or nil
end

local function creerPointDeFarm(metier, typePoint, donnees)
    local nom = (metier.."_"..typePoint.."_"..donnees.label):gsub(" ", "_")
    local action = {}
    action.onPress = function()
        if getJob() ~= metier then
            return
        end
        local cle = nom
        if pointOccupe[cle] then
            return
        end
        pointOccupe[cle] = true
        local texte = donnees.label or "Action en cours..."
        local duree = 3000
        local anim = "WORLD_HUMAN_CLIPBOARD"
        if typePoint == "recolte" then
            anim = "WORLD_HUMAN_GARDENER_PLANT"
        elseif typePoint == "traitement" then
            anim = "PROP_HUMAN_BBQ"
        elseif typePoint == "vente" then
            anim = "WORLD_HUMAN_CLIPBOARD"
            duree = 100000
        end
        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, anim, 0, true)
        local progress = VFW.Nui.ProgressBar(texte, duree)
        ClearPedTasks(ped)
        if progress == true then
            if typePoint == "recolte" then
                TriggerServerEvent("core:farms:recolte", metier, donnees)
            elseif typePoint == "traitement" then
                TriggerServerEvent("core:farms:traitement", metier, donnees)
            elseif typePoint == "vente" then
                TriggerServerEvent("core:farms:vente", metier, donnees)
            end
        end
        pointOccupe[cle] = false
    end
    VFW.CreateBlipAndPoint(
        nom,
        donnees.coords,
        nom,
        237,
        3,
        1.0,
        donnees.label,
        donnees.label,
        "E",
        donnees.icon or "recolte",
        action,
        {"#FFFFFF", "#AAAAAA", "#FFFFFF", 1.0}
    )
end

CreateThread(function()
    while not VFW or not VFW.PlayerData or not VFW.PlayerData.job do
        Wait(100)
    end
    local job = VFW.PlayerData.job.name
    for metier, donneesMetier in pairs(ConfigFarms) do
        if job == metier then
            for _, v in ipairs(donneesMetier.recolte or {}) do
                creerPointDeFarm(metier, "recolte", v)
            end
            for _, v in ipairs(donneesMetier.traitement or {}) do
                creerPointDeFarm(metier, "traitement", v)
            end
            for _, v in ipairs(donneesMetier.vente or {}) do
                creerPointDeFarm(metier, "vente", v)
            end
        end
    end
end) 