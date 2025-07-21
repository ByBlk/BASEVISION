---@class ConfigManager
ConfigManager = {
    Loaded = false,
    Config = {}
}

CreateThread(function()
    while not (TriggerServerCallback) do Wait(100) end
    ConfigManager.Config = TriggerServerCallback("ConfigManager:getConfig")
    ConfigManager.Loaded = true
end)