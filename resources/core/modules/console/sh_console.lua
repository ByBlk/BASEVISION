---@class Console
---@field Level number
---@field infos table<string, string>
---@field typesLevel table<string, number>
console = {}

console.Level = 4

console.infos = {
    INFO = "^4INFO^7",
    WARN = "^3WARNING^7",
    SUCCESS = "^2SUCCESS^7",
    ERROR = "^1ERROR^7",
    DEBUG = "^6DEBUG^7"
}

console.typesLevel = {
    ERROR = 1,
    WARN = 2,
    SUCCESS = 3,
    INFO = 4,
    DEBUG = 4
}

---@param level number
function console.setLevel(level)
    if type(level) ~= "number" or level < 0 or level > 4 then
        console.send("ERROR", "Niveau de log invalide (" .. tostring(level) .. "), doit être entre 0 et 4.")
        return
    end
    console.Level = level
    console.send("SUCCESS", "Niveau de log défini sur : " .. level)
end

---@param types string
---@param info string|table
---@param ... any
function console.send(types, info, ...)
    if not console.typesLevel[types] then
        types = "DEBUG"
    end

    if console.Level == 0 or console.typesLevel[types] > console.Level then
        return
    end

    local sourceInfo = debug.getinfo(3, "Sl")
    local where = (sourceInfo and string.format("%s:%s", sourceInfo.short_src, sourceInfo.currentline)) or "unknown"

    local function dumpTable(tbl, indent)
        indent = indent or 0
        local toprint = string.rep(" ", indent).. "{\n"
        indent = indent + 2
        for k,v in pairs(tbl) do
            toprint = toprint .. string.rep(" ", indent)
            if type(k) == "string" then
                toprint = toprint .. string.format("^3\"%s\"^7", k) .. " = "
            else
                toprint = toprint .. string.format("^3[%s]^7", k) .. " = "
            end
            if type(v) == "table" then
                toprint = toprint .. dumpTable(v, indent + 2) .. ",\n"
            else
                toprint = toprint .. string.format("^2%s^7", tostring(v)) .. ",\n"
            end
        end
        toprint = toprint.. string.rep(" ", indent - 2).."}"
        return toprint
    end

    local message
    if type(info) == "string" then
        message = info
    elseif type(info) == "table" then
        message = dumpTable(info, 0)
    else
        message = tostring(info)
    end

    local label = console.infos[types] or console.infos["DEBUG"]
    local paddedLabel = string.format("%-8s", label)

    print(("[%s] [^6%-30s^7] %s"):format(paddedLabel, where, message), ...)
end

---@param message string
---@param ... any
function console.info(message, ...)
    console.send("INFO", message, ...)
end

---@param message string
---@param ... any
function console.warn(message, ...)
    console.send("WARN", message, ...)
end

---@param message string
---@param ... any
function console.success(message, ...)
    console.send("SUCCESS", message, ...)
end

---@param message string
---@param ... any
function console.error(message, ...)
    console.send("ERROR", message, ...)
end

---@param message string
---@param ... any
function console.debug(message, ...)
    console.send("DEBUG", message, ...)
end

---@param tbl table
function console.array(tbl)
    if type(tbl) ~= "table" or #tbl == 0 then
        console.error("La table est vide ou invalide.")
        return
    end

    local columns = {}
    for key in pairs(tbl[1]) do
        table.insert(columns, key)
    end

    local colWidths = {}
    for _, col in ipairs(columns) do
        colWidths[col] = #col
        for _, row in ipairs(tbl) do
            colWidths[col] = math.max(colWidths[col], #tostring(row[col] or ""))
        end
    end

    local function createLine(sep, left, right)
        local line = left
        for _, col in ipairs(columns) do
            line = line .. string.rep("─", colWidths[col] + 2) .. sep
        end
        return line:sub(1, -2) .. right
    end

    print(createLine("┬", "┌", "┐"))

    local header = "|"
    for _, col in ipairs(columns) do
        header = header .. " " .. col .. string.rep(" ", colWidths[col] - #col) .. " |"
    end
    print(header)
    print(createLine("┼", "├", "┤"))

    for _, row in ipairs(tbl) do
        local rowLine = "|"
        for _, col in ipairs(columns) do
            local value = tostring(row[col] or "")
            rowLine = rowLine .. " " .. value .. string.rep(" ", colWidths[col] - #value) .. " |"
        end
        print(rowLine)
    end

    print(createLine("┴", "└", "┘"))
end

console.setLevel(tonumber(GetConvar("consoleLogLevel", 0)))

