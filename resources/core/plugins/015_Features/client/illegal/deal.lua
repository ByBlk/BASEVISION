local isDeal = false
local peds = {}

local config = {
    peds = {
        "a_m_m_beach_01",
        "a_m_m_beach_02",
        "a_m_y_beach_01",
        "a_m_y_beach_02",
        "a_m_y_beach_03",
        "a_m_y_beachvesp_01",
        "a_m_y_beachvesp_02",
        "a_m_y_mexthug_01",
        "a_m_y_soucent_02",
        "a_m_y_soucent_03"
    },
    dealCenter = vector4(-1099.94, -1500.24, 3.8, 215.43),
}

local function startDeal()
    for i = 1, #config.peds do
        peds[i] = cEntity.Manager:CreatePedLocal(config.peds[i], vector3(config.dealCenter.x, config.dealCenter.y, config.dealCenter.z), config.dealCenter.w)
        local pedId = peds[i]:getEntityId()
        TaskWanderStandard(pedId, 10.0, 10)
        SetPedAlertness(pedId, 2)
    end
end

local function stopDeal()
    for i = 1, #peds do
        if peds[i] then
            peds[i]:delete()
            peds[i] = nil
        end
    end
end

RegisterCommand("deal", function(source, args, rawCommand)
    isDeal = not isDeal

    if isDeal then
        startDeal()
    else
        stopDeal()
    end
end, false)
