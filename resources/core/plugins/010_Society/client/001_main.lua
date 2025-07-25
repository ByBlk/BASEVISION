Society = {}
Society.Jobs = {}

local main = xmenu.create({ subtitle = "Gestion", banner = "https://cdn.eltrane.cloud/3838384859/assets/xmenu/headers/admin.png" })
local gestsociety = xmenu.createSub(main, { subtitle = "Gestion des Societé" })

local function BuildSocietyMenu()
    xmenu.items(gestsociety, function()
        for k, v in pairs(ConfigManager.Config.society) do
            addCheckbox(k, v, {}, {
                onChange = function()
                    ConfigManager.Config.society[k] = not v
                    TriggerServerEvent("GestionDev:saveSociety", k, ConfigManager.Config.society[k])
                end,
            })
        end
    end)
end

local function openGestionDev()
    xmenu.items(main, function()
        addButton("Gestion des Entreprise", { rightIcon = "chevron" }, {
            onSelected = function()
                BuildSocietyMenu()
            end
        }, gestsociety)
        onClose(function()
            xmenu.render(false)
        end)
    end)
    xmenu.render(main)
end

--RegisterCommand("gestionDev", function()
--    openGestionDev()
--end)
