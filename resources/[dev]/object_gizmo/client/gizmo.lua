local dataview = require 'client.dataview'

local enableScale = true -- allow scaling mode. doesnt scale collisions and resets when physics are applied it seems
local isCursorActive = false
local gizmoEnabled = false
local currentMode = 'translate'
local isRelative = false
local groundProtectionEnabled = true -- Variable pour activer/désactiver la protection du sol
local currentEntity

-- FUNCTIONS

local function normalize(x, y, z)
    local length = math.sqrt(x * x + y * y + z * z)
    if length == 0 then
        return 0, 0, 0
    end
    return x / length, y / length, z / length
end

local function makeEntityMatrix(entity)
    local f, r, u, a = GetEntityMatrix(entity)
    local view = dataview.ArrayBuffer(60)

    view:SetFloat32(0, r[1])
        :SetFloat32(4, r[2])
        :SetFloat32(8, r[3])
        :SetFloat32(12, 0)
        :SetFloat32(16, f[1])
        :SetFloat32(20, f[2])
        :SetFloat32(24, f[3])
        :SetFloat32(28, 0)
        :SetFloat32(32, u[1])
        :SetFloat32(36, u[2])
        :SetFloat32(40, u[3])
        :SetFloat32(44, 0)
        :SetFloat32(48, a[1])
        :SetFloat32(52, a[2])
        :SetFloat32(56, a[3])
        :SetFloat32(60, 1)

    return view
end

local function applyEntityMatrix(entity, view)
    local x1, y1, z1 = view:GetFloat32(16), view:GetFloat32(20), view:GetFloat32(24)
    local x2, y2, z2 = view:GetFloat32(0), view:GetFloat32(4), view:GetFloat32(8)
    local x3, y3, z3 = view:GetFloat32(32), view:GetFloat32(36), view:GetFloat32(40)
    local tx, ty, tz = view:GetFloat32(48), view:GetFloat32(52), view:GetFloat32(56)

    if not enableScale then
        x1, y1, z1 = normalize(x1, y1, z1)
        x2, y2, z2 = normalize(x2, y2, z2)
        x3, y3, z3 = normalize(x3, y3, z3)
    end

    SetEntityMatrix(entity,
        x1, y1, z1,
        x2, y2, z2,
        x3, y3, z3,
        tx, ty, tz
    )
end

-- LOOPS

local function gizmoLoop(entity)
    if not gizmoEnabled then
        return LeaveCursorMode()
    end

    EnterCursorMode()

    if IsEntityAPed(entity) then
        SetEntityAlpha(entity, 200)
    else
        SetEntityDrawOutline(entity, true)
    end
    isCursorActive = true
    while gizmoEnabled and DoesEntityExist(entity) do
        Wait(0)
        if IsControlJustPressed(0, 47) then -- G
            if isCursorActive then
                LeaveCursorMode()
            else
                EnterCursorMode()
            end
            isCursorActive = not isCursorActive
        end
        DisableControlAction(0, 24, true)  -- lmb
        DisableControlAction(0, 25, true)  -- rmb
        DisableControlAction(0, 140, true) -- r
        DisablePlayerFiring(cache.playerId, true)

        local matrixBuffer = makeEntityMatrix(entity)
        local changed = Citizen.InvokeNative(0xEB2EDCA2, matrixBuffer:Buffer(), 'Editor1',
            Citizen.ReturnResultAnyway())

        if changed then
            applyEntityMatrix(entity, matrixBuffer)

            -- PROTECTION ANTI-UNDERGROUND (activable/désactivable)
            if groundProtectionEnabled then
                local newCoords = GetEntityCoords(entity)
                local mustCorrect = false
                local correctedZ = newCoords.z

                local groundZ1, hasGround1 = GetGroundZFor_3dCoord(newCoords.x, newCoords.y, newCoords.z + 100.0, false)
                if hasGround1 and newCoords.z < groundZ1 then
                    mustCorrect = true
                    correctedZ = groundZ1 + 0.5
                end

                local hit, _, hitCoords = GetShapeTestResult(StartShapeTestRay(
                    newCoords.x, newCoords.y, newCoords.z + 10.0,
                    newCoords.x, newCoords.y, newCoords.z - 50.0,
                    1, -- Seulement le monde
                    entity, 4
                ))

                if hit then
                    local raycastGroundZ = hitCoords.z
                    if newCoords.z < raycastGroundZ then
                        mustCorrect = true
                        correctedZ = math.max(correctedZ, raycastGroundZ + 0.5)
                    end
                end

                if newCoords.z < -30.0 then
                    mustCorrect = true
                    correctedZ = math.max(correctedZ, 1.0)
                end

                local hit2, _, hitCoords2 = GetShapeTestResult(StartShapeTestRay(
                    newCoords.x, newCoords.y, 1000.0,
                    newCoords.x, newCoords.y, -1000.0,
                    1, -- Seulement le monde
                    entity, 4
                ))

                if hit2 then
                    local topDownGroundZ = hitCoords2.z
                    if newCoords.z < topDownGroundZ then
                        mustCorrect = true
                        correctedZ = math.max(correctedZ, topDownGroundZ + 0.5)
                    end
                end

                if mustCorrect then
                    SetEntityCoords(entity, newCoords.x, newCoords.y, correctedZ, false, false, false, true)
                end
            end
        end
    end
    isCursorActive = false
    LeaveCursorMode()

    if DoesEntityExist(entity) then
        if IsEntityAPed(entity) then SetEntityAlpha(entity, 255) end
        SetEntityDrawOutline(entity, false)
    end

    gizmoEnabled = false
    currentEntity = nil
end

local function GetVectorText(vectorType)
    if not currentEntity then return 'ERR_NO_ENTITY_' .. (vectorType or "UNK") end
    local label = (vectorType == "coords" and "Position" or "Rotation")
    local vec = (vectorType == "coords" and GetEntityCoords(currentEntity) or GetEntityRotation(currentEntity))
    return ('%s: %.2f, %.2f, %.2f'):format(label, vec.x, vec.y, vec.z)
end


local function textUILoop()
    TriggerEvent("VFW:Create:InfoKeys",gizmoEnabled, {
        {
            key = "R",
            desc = "Mode rotation"
        },
        {
            key = "E",
            desc = "Afficher / Masquer la zone "
        },
        -- z
        {
            key = "Z",
            desc = "Position"
        },
        {
            key = "enter",
            desc = "Terminer l'édition"
        },
    })
end


local function useGizmo(entity)
    gizmoEnabled = true
    currentEntity = entity
    textUILoop()
    gizmoLoop(entity)

    return {
        handle = entity,
        position = GetEntityCoords(entity),
        rotation = GetEntityRotation(entity)
    }
end

exports("useGizmo", useGizmo)

-- Exports pour contrôler la protection du sol
exports('setGroundProtection', function(enabled)
    groundProtectionEnabled = enabled
    return groundProtectionEnabled
end)

exports('getGroundProtection', function()
    return groundProtectionEnabled
end)

exports('toggleGroundProtection', function()
    groundProtectionEnabled = not groundProtectionEnabled
    return groundProtectionEnabled
end)

-- CONTROLS these execute the existing gizmo commands but allow me to add additional logic to update the mode display.

lib.addKeybind({
    name = '_gizmoSelect',
    description = 'Selects the currently highlighted gizmo',
    defaultMapper = 'MOUSE_BUTTON',
    defaultKey = 'MOUSE_LEFT',
    onPressed = function(self)
        if not gizmoEnabled then return end
        ExecuteCommand('+gizmoSelect')
    end,
    onReleased = function (self)
        ExecuteCommand('-gizmoSelect')
    end
})

lib.addKeybind({
    name = '_gizmoTranslation',
    description = 'Sets mode of the gizmo to translation',
    defaultKey = 'W',
    onPressed = function(self)
        if not gizmoEnabled then return end
        currentMode = 'Translate'
        ExecuteCommand('+gizmoTranslation')
    end,
    onReleased = function (self)
        ExecuteCommand('-gizmoTranslation')
    end
})

lib.addKeybind({
    name = '_gizmoRotation',
    description = 'Sets mode for the gizmo to rotation',
    defaultKey = 'R',
    onPressed = function(self)
        if not gizmoEnabled then return end
        currentMode = 'Rotate'
        ExecuteCommand('+gizmoRotation')
    end,
    onReleased = function (self)
        ExecuteCommand('-gizmoRotation')
    end
})

lib.addKeybind({
    name = '_gizmoLocal',
    description = 'toggle gizmo to be local to the entity instead of world',
    defaultKey = 'Q',
    onPressed = function(self)
        if not gizmoEnabled then return end
        isRelative = not isRelative
        ExecuteCommand('+gizmoLocal')
    end,
    onReleased = function (self)
        ExecuteCommand('-gizmoLocal')
    end
})

lib.addKeybind({
    name = 'gizmoclose',
    description = 'close gizmo',
    defaultKey = 'RETURN',
    onPressed = function(self)
        if not gizmoEnabled then return end
        gizmoEnabled = false
    end,
})

lib.addKeybind({
    name = 'gizmoSnapToGround',
    description = 'snap current gizmo object to floor/surface',
    defaultKey = 'F7',
    onPressed = function(self)
        if not gizmoEnabled then return end
        print("snap to ground")
        PlaceObjectOnGroundProperly_2(currentEntity)
    end,
})
RegisterCommand("caca", function()
        PlaceObjectOnGroundProperly_2(currentEntity)
end)

if enableScale then
    lib.addKeybind({
        name = '_gizmoScale',
        description = 'Sets mode for the gizmo to scale',
        defaultKey = 'S',
        onPressed = function(self)
            if not gizmoEnabled then return end
            currentMode = 'Scale'
            ExecuteCommand('+gizmoScale')
        end,
        onReleased = function (self)
            ExecuteCommand('-gizmoScale')
        end
    })
end
