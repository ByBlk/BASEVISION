local Charset = {}

for i = 48, 57 do
    table.insert(Charset, string.char(i))
end
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

local weaponsByName = {}
local weaponsByHash = {}

CreateThread(function()
    for index, weapon in pairs(Config.Weapons) do
        weaponsByName[weapon.name] = index
        weaponsByHash[joaat(weapon.name)] = weapon
    end
end)

---@param length number
---@return string
function VFW.GetRandomString(length)
    math.randomseed(GetGameTimer())

    return length > 0 and VFW.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)] or ""
end

---@return table
function VFW.GetConfig()
    return Config
end

---@param weaponName string
---@return number, table
function VFW.GetWeapon(weaponName)
    weaponName = string.upper(weaponName)

    assert(weaponsByName[weaponName], "Invalid weapon name!")

    local index = weaponsByName[weaponName]
    return index, Config.Weapons[index]
end

---@param weaponHash number
---@return table
function VFW.GetWeaponFromHash(weaponHash)
    weaponHash = type(weaponHash) == "string" and joaat(weaponHash) or weaponHash

    return weaponsByHash[weaponHash]
end

---@param byHash boolean
---@return table
function VFW.GetWeaponList(byHash)
    return byHash and weaponsByHash or Config.Weapons
end

---@param weaponName string
---@return string
function VFW.GetWeaponLabel(weaponName)
    weaponName = string.upper(weaponName)

    assert(weaponsByName[weaponName], "Invalid weapon name!")

    local index = weaponsByName[weaponName]
    return Config.Weapons[index].label or ""
end

---@param weaponName string
---@param weaponComponent string
---@return table | nil
function VFW.GetWeaponComponent(weaponName, weaponComponent)
    weaponName = string.upper(weaponName)

    assert(weaponsByName[weaponName], "Invalid weapon name!")
    local weapon = Config.Weapons[weaponsByName[weaponName]]

    for _, component in ipairs(weapon.components) do
        if component.name == weaponComponent then
            return component
        end
    end
end

function VFW.DeepCopy(t)
    if type(t) ~= 'table' then
        return t
    end

    local meta = getmetatable(t)
    local target = {}

    for k, v in pairs(t) do
        if type(v) == 'table' then
            target[k] = VFW.DeepCopy(v)
        else
            target[k] = v
        end
    end

    setmetatable(target, meta)

    return target
end

---@param table table
---@param nb? number
---@return string
function VFW.DumpTable(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == "table" then
        local s = ""
        for _ = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = "{\n"
        for k, v in pairs(table) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            for _ = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. "[" .. k .. "] = " .. VFW.DumpTable(v, nb + 1) .. ",\n"
        end

        for _ = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. "}"
    else
        return tostring(table)
    end
end

---@param value any
---@param numDecimalPlaces? number
---@return number
function VFW.Round(value, numDecimalPlaces)
    return VFW.Math.Round(value, numDecimalPlaces)
end

---@param value string
---@param ... any
---@return boolean, string?
function VFW.ValidateType(value, ...)
    local types = { ... }
    if #types == 0 then
        return true
    end

    local mapType = {}
    for i = 1, #types, 1 do
        local validateType = types[i]
        assert(type(validateType) == "string", "bad argument types, only expected string") -- should never use anyhing else than string
        mapType[validateType] = true
    end

    local valueType = type(value)

    local matches = mapType[valueType] ~= nil

    if not matches then
        local requireTypes = table.concat(types, " or ")
        local errorMessage = ("bad value (%s expected, got %s)"):format(requireTypes, valueType)

        return false, errorMessage
    end

    return true
end

---@param ... any
---@return boolean
function VFW.AssertType(...)
    local matches, errorMessage = VFW.ValidateType(...)

    assert(matches, errorMessage)

    return matches
end

function VFW.DisplayTime(time)
    local hours = math.floor(math.fmod(time, 86400) / 3600)
    local minutes = math.floor(math.fmod(time, 3600) / 60)
    local seconds = math.floor(math.fmod(time, 60))
    local minutesStr = minutes < 10 and "0" .. minutes or minutes
    local secondsStr = seconds < 10 and "0" .. seconds or seconds
    return hours > 0
            and hours .. ":" .. minutesStr .. ":" .. secondsStr
            or minutesStr .. ":" .. secondsStr
end

---@param zonePoints table Liste des points définissant le polygone
---@param x number Coordonnée x du point à vérifier
---@param y number Coordonnée y du point à vérifier
---@return boolean Indique si le point est à l'intérieur de la zone
function VFW.IsPlayerInsideZone(zonePoints, x, y)
    if not zonePoints or #zonePoints < 3 then
        return false
    end

    -- Vérifier que x et y sont des nombres valides
    if not x or not y or type(x) ~= "number" or type(y) ~= "number" then
        return false
    end

    local inside = false
    local j = #zonePoints

    for i = 1, #zonePoints do
        -- Vérifier que les points sont valides et ont des coordonnées x,y
        if zonePoints[i] and zonePoints[j] and
           zonePoints[i].x and zonePoints[i].y and
           zonePoints[j].x and zonePoints[j].y and
           type(zonePoints[i].x) == "number" and type(zonePoints[i].y) == "number" and
           type(zonePoints[j].x) == "number" and type(zonePoints[j].y) == "number" then

            -- Vérification des intersections avec les côtés du polygone
            local intersect = (
                    (zonePoints[i].y > y) ~= (zonePoints[j].y > y) and
                            x < (zonePoints[j].x - zonePoints[i].x) * (y - zonePoints[i].y) /
                                    (zonePoints[j].y - zonePoints[i].y) + zonePoints[i].x
            )

            if intersect then
                inside = not inside
            end
        end

        j = i
    end

    return inside
end

local yLimitation = 1490
function VFW.IsCoordsInSouth(coords)

    if type(coords) == "number" then
        return coords < yLimitation
    end

    if type(coords) == "table" and coords.y then
        return coords.y < yLimitation
    end

    return false
end

---@param val any
function VFW.IsFunctionReference(val)
    local typeVal = type(val)
    local metatable = getmetatable(val)
    return typeVal == "function" or (typeVal == "table" and metatable and type(metatable.__call) == "function")
end

---@param conditionFunc function A function that is repeatedly called until it returns a truthy value or the timeout is exceeded.
---@param errorMessage? string Optional. If set, an error will be thrown with this message if the condition is not met within the timeout. If not set, no error will be thrown.
---@param timeoutMs? number Optional. The maximum time to wait (in milliseconds) for the condition to be met. Defaults to 1000ms.
---@return boolean, any: Returns success status and the returned value of the condition function.
function VFW.Await(conditionFunc, errorMessage, timeoutMs)
    timeoutMs = timeoutMs or 1000

    if timeoutMs < 0 then
        error("Timeout should be a positive number.")
    end

    if not VFW.IsFunctionReference(conditionFunc) then
        error("Condition Function should be a function reference.")
    end

    -- since errorMessage is optional, we only validate it if the user provided it.
    if errorMessage then
        VFW.AssertType(errorMessage, "string", "errorMessage should be a string.")
    end

    local invokingResource = GetInvokingResource()
    local startTimeMs = GetGameTimer()
    while GetGameTimer() - startTimeMs < timeoutMs do
        local result = conditionFunc()

        if result then
            return true, result
        end

        Wait(0)
    end

    if errorMessage then
        error(("[%s] -> %s"):format(invokingResource, errorMessage))
    end

    return false
end

local ignore = { ["ammo"] = true }
local bypassT = { ["weaponId"] = true, ["renamed"] = true }
local function deepCompare(t1, t2, bypass)
    if t1 == t2 then
        return true
    end
    if type(t1) ~= type(t2) then
        return false
    end
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end

    for k, v in pairs(t1) do
        if not ignore[k] and not (bypass and bypassT[k]) and not deepCompare(v, t2[k]) then
            return false
        end
    end
    for k, v in pairs(t2) do
        if not ignore[k] and not (bypass and bypassT[k]) and not deepCompare(v, t1[k]) then
            return false
        end
    end

    return true
end

function VFW.SameItem(item, itemCompare, bypass)
    if item.name ~= itemCompare.name then
        return false
    end
    return deepCompare(item.meta, itemCompare.meta, bypass)
end

function VFW.GenerateUUID()
    local random = math.random;
    local _template = type(template) == "string" and template or 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
    return string.gsub(_template, '[xy]', function(index)
        local value = (index == 'x') and random(0, 0xf) or random(8, 0xb);
        return string.format('%x', value);
    end);
end