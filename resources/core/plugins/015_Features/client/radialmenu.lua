local cinemamod, minimapMod = false, false

local function OpenRadialF9()
    if RadialOpen then
        VFW.Nui.Radial(nil, false)
        RadialOpen = false
        return 
    end

    RadialOpen = true

    local ELEMENTS <const> = {
        {
            name = "MODE CINEMA",
            icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/cinema.svg",
            action = "CinemaMod"
        },
        {
            name = "MASQUER HUD",
            icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/crossed_eye.svg",
            action = "NoMoreATH"
        },
        {
            name = "REINITIALISER",
            icon = "https://cdn.eltrane.cloud/3838384859/assets/radialmenus/back.svg",
            action = "DefaultCamera"
        },
    }

    VFW.Nui.Radial({elements = ELEMENTS, title = "HUD"}, true)
end

RegisterCommand("+openmenucamera", OpenRadialF9)
RegisterKeyMapping("+openmenucamera", "Radial Menu Camera", "keyboard", "F9")

local w = 0
local minimap

local function DrawRects() -- [[Draw the Black Rects]]
    DrawRect(0.0, 0.0, 2.0, 0.2, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, 0.2, 0, 0, 0, 255)
end

local function DisplayHealthArmour(int)
    BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(int)
    EndScaleformMovieMethod()
end

function CinemaMod()
    cinemamod = not cinemamod

    SetRadarBigmapEnabled(false, false)
    if cinemamod then
        VFW.Nui.HudVisible(false)
        CreateThread(function() -- [[Requests the minimap scaleform and actually calls the rect function allong with the hud components function.]]
            while cinemamod do
                Wait(1)
                if cinemamod then
                    DrawRects()
                end
            end
        end)
    else
        VFW.Nui.HudVisible(true)
    end
end

function NoMoreATH()
    Wait(100)
    minimapMod = not minimapMod

    if minimapMod then
        DisplayHealthArmour(3)
        VFW.Nui.HudVisible(false)
    else
        DisplayHealthArmour(0)
        VFW.Nui.HudVisible(true)
    end
end


function DefaultCamera()
    if cinemamod then
        cinemamod = false
    end

    VFW.Nui.HudVisible(true)
end
