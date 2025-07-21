---@class ConfigManager
ConfigManager = {
    Loaded = false,
    Config = {}
}

exports.oxmysql:execute([[
    CREATE TABLE IF NOT EXISTS config_manager (
        name VARCHAR(50) NOT NULL PRIMARY KEY,
        data LONGTEXT NOT NULL
    )
]], {}, function()
    console.debug("Config table created or already exists.")
    ConfigManager.Loaded = true
end)

while not ConfigManager.Loaded do
    Wait(100)
end

---@param type string
---@param defaultConfig table
---@return void
function ConfigManager.loadConfig(type, defaultConfig)
    if not ConfigManager.Config[type] then
        ConfigManager.Config[type] = {}
    end
    local result = MySQL.query.await('SELECT data FROM config_manager WHERE name = ?', {type})
    if result and result[1] then
        local dbConfig = json.decode(result[1].data)
        local configTable = {}
        for k, v in pairs(dbConfig) do
            configTable[k] = v
        end
        dbConfig = configTable
        local needUpdate = false
        for key, defaultValue in pairs(defaultConfig) do
            if dbConfig[key] == nil then
                dbConfig[key] = defaultValue
                needUpdate = true
            end
        end
        if needUpdate then
            MySQL.update.await('UPDATE config_manager SET data = ? WHERE name = ?', {json.encode(dbConfig), type})
        end
        ConfigManager.Config[type] = dbConfig
    else
        MySQL.insert.await('INSERT INTO config_manager (name, data) VALUES (?, ?)', {type, json.encode(defaultConfig)})
        ConfigManager.Config[type] = defaultConfig
    end
end

---@param configType string
---@param configData table
---@return boolean
function ConfigManager.saveConfig(configType, configData)
    if not configType or configType == "" or not configData or type(configData) ~= "table" then
        return false
    end
    local serializedData = json.encode(configData)
    local result = MySQL.scalar.await('SELECT COUNT(*) FROM config_manager WHERE name = ?', {configType})
    if result and result > 0 then
        MySQL.update.await('UPDATE config_manager SET data = ? WHERE name = ?', {serializedData, configType})
    else
        MySQL.insert.await('INSERT INTO config_manager (name, data) VALUES (?, ?)', {configType, serializedData})
    end
    return true
end

RegisterServerCallback("ConfigManager:getConfig", function(source)
    return ConfigManager.Config
end)