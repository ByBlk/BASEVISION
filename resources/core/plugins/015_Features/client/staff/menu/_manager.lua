StaffMenu.data = {
    playerList = {},
    staffList = {},
}
StaffMenu.open = false
StaffMenu.adminChecked = false

StaffMenu.main = xmenu.create({ subtitle = "MENU ADMINISTRATION", banner = "https://cdn.eltrane.cloud/alkiarp/assets/xmenu/headers/admin.png", itemsPerPage = 15 })

StaffMenu.reports = xmenu.createSub(StaffMenu.main, { subtitle = "REPORTS", itemsPerPage = 15 })
StaffMenu.report = xmenu.createSub(StaffMenu.reports, { subtitle = "REPORT", itemsPerPage = 15 })

StaffMenu.players = xmenu.createSub(StaffMenu.main, { subtitle = "PLAYERS", itemsPerPage = 15 })
StaffMenu.player = xmenu.createSub(StaffMenu.players, { subtitle = "PLAYER", itemsPerPage = 15 })
StaffMenu.wipe = xmenu.createSub(StaffMenu.player, { subtitle = "WIPE", itemsPerPage = 15 })
StaffMenu.items = xmenu.createSub(StaffMenu.player, { subtitle = "LISTE DES ITEMS", itemsPerPage = 15 })
StaffMenu.jobs = xmenu.createSub(StaffMenu.player, { subtitle = "LISTE DES JOBS", itemsPerPage = 15 })
StaffMenu.grades_jobs = xmenu.createSub(StaffMenu.jobs, { subtitle = "LISTE DES GRADES", itemsPerPage = 15 })
StaffMenu.crews = xmenu.createSub(StaffMenu.player, { subtitle = "LISTE DES CREWS", itemsPerPage = 15 })
StaffMenu.grades_crews = xmenu.createSub(StaffMenu.crews, { subtitle = "LISTE DES GRADES", itemsPerPage = 15 })
StaffMenu.vehs = xmenu.createSub(StaffMenu.player, { subtitle = "LISTE DES VÉHICULES", itemsPerPage = 15 })
StaffMenu.vehs_owned = xmenu.createSub(StaffMenu.vehs, { subtitle = "LISTE DES VÉHICULES DU OWNED", itemsPerPage = 15 })
StaffMenu.vehs_job = xmenu.createSub(StaffMenu.vehs, { subtitle = "LISTE DES VÉHICULES DU JOB", itemsPerPage = 15 })
StaffMenu.vehs_crew = xmenu.createSub(StaffMenu.vehs, { subtitle = "LISTE DES VÉHICULES DU CREW", itemsPerPage = 15 })
StaffMenu.wipe = xmenu.createSub(StaffMenu.player, { subtitle = "WIPE", itemsPerPage = 15 })
StaffMenu.warns = xmenu.createSub(StaffMenu.player, { subtitle = "LISTE DES WARNS", itemsPerPage = 15 })

StaffMenu.staff = xmenu.createSub(StaffMenu.main, { subtitle = "STAFF", itemsPerPage = 15 })

StaffMenu.outils = xmenu.createSub(StaffMenu.main, { subtitle = "OUTILS DE MODÉRATION", itemsPerPage = 15 })

StaffMenu.global = xmenu.createSub(StaffMenu.main, { subtitle = "GESTION DE GLOBAL", itemsPerPage = 15 })
StaffMenu.developers = xmenu.createSub(StaffMenu.global, { subtitle = "DÉVELOPPEURS", itemsPerPage = 15 })
StaffMenu.camera = xmenu.createSub(StaffMenu.developers, { subtitle = "CRÉATION DE CAM", itemsPerPage = 15 })
StaffMenu.zoneSafe = xmenu.createSub(StaffMenu.developers, { subtitle = "CRÉATION DE ZONESAFE", itemsPerPage = 15 })
StaffMenu.CreateZoneSafe = xmenu.createSub(StaffMenu.zoneSafe, { subtitle = "CRÉATION DE ZONESAFE", itemsPerPage = 15 })
StaffMenu.ListZoneSafe = xmenu.createSub(StaffMenu.zoneSafe, { subtitle = "LISTE DES ZONESAFE", itemsPerPage = 15 })
StaffMenu.weapon = xmenu.createSub(StaffMenu.developers, { subtitle = "COMPOSANTS D'ARMES", itemsPerPage = 15 })
StaffMenu.legal = xmenu.createSub(StaffMenu.global, { subtitle = "LÉGAL", itemsPerPage = 15 })
StaffMenu.illegal = xmenu.createSub(StaffMenu.global, { subtitle = "ILLÉGAL", itemsPerPage = 15 })
StaffMenu.braquage = xmenu.createSub(StaffMenu.illegal, { subtitle = "BRAQUAGE", itemsPerPage = 15 })
StaffMenu.braquageCreation = xmenu.createSub(StaffMenu.braquage, { subtitle = "CREATION", itemsPerPage = 15 })
StaffMenu.boutique = xmenu.createSub(StaffMenu.global, { subtitle = "BOUTIQUE", itemsPerPage = 15 })
StaffMenu.events = xmenu.createSub(StaffMenu.global, { subtitle = "OUTILS D'EVENTS", itemsPerPage = 15 })
StaffMenu.eventsIpl = xmenu.createSub(StaffMenu.events, { subtitle = "OUTILS D'EVENTS", itemsPerPage = 15 })
StaffMenu.eventsIplSelect = xmenu.createSub(StaffMenu.eventsIpl, { subtitle = "CRÉATION D'IPL", itemsPerPage = 15 })
StaffMenu.mapeditor = xmenu.createSub(StaffMenu.events, { subtitle = "MAP EDITOR", itemsPerPage = 15 })
StaffMenu.objectListPlaced = xmenu.createSub(StaffMenu.mapeditor, { subtitle = "OBJETS PLACÉS", itemsPerPage = 15 })

StaffMenu.sanctions = xmenu.createSub(StaffMenu.main, { subtitle = "SANCTIONS", itemsPerPage = 15 })
StaffMenu.bans = xmenu.createSub(StaffMenu.sanctions, { subtitle = "LISTE DES BANS", itemsPerPage = 15 })

local function buildMainMenu()
    xmenu.items(StaffMenu.main, function()
        addCheckbox("MODE ADMINISTRATION", StaffMenu.adminChecked, {}, {
            onChange = function(checked)
                StaffMenu.adminChecked = checked
                TriggerServerEvent("vfw:staff:mode", checked)
                buildMainMenu()
                if checked then
                    TriggerServerEvent("Admin:activeBlips", true)
                    TriggerServerEvent("Admin:gamerTag", true)
                    VFW.AdminOverley()
                else
                    TriggerServerEvent("Admin:activeBlips", false)
                    TriggerServerEvent("Admin:gamerTag", false)
                end
            end
        })

        if StaffMenu.adminChecked then
            addLine()

            addButton("REPORTS", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildReportsMenu()
                end
            }, StaffMenu.reports)

            addButton("JOUEURS", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.data.playerList = {}
                    StaffMenu.data.playerList = TriggerServerCallback("vfw:staff:getPlayerList") or {}
                    StaffMenu.BuildPlayersMenu()
                end
            }, StaffMenu.players)

            addButton("STAFF EN LIGNE", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.data.staffList = {}
                    StaffMenu.data.staffList = TriggerServerCallback("vfw:staff:getStaffList") or {}
                    StaffMenu.BuildStaffMenu()
                end
            }, StaffMenu.staff)

            addButton("MODERATION", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildOutilsMenu()
                end
            }, StaffMenu.outils)

            addButton("GESTION", { rightIcon = "chevron" }, {
                onSelected = function()
                    StaffMenu.BuildGlobalMenu()
                end
            }, StaffMenu.global)
        end

        onClose(function()
            xmenu.render(false)
            StaffMenu.open = false
        end)
    end)
end

function VFW.AdminOverley()
    CreateThread(function()
        while true do
            SendNUIMessage({
                action = "nui:hud:visible:staffboard",
                data = {
                    visible = StaffMenu.adminChecked,
                    players = tostring(GlobalState.playerCount),
                    staff = tostring(GlobalState.staffCount),
                    reports = tonumber(GlobalState.reportCount)
                },
            })
            if not StaffMenu.adminChecked then break end
            Wait(1000)
        end
    end)
end

function VFW.OpenStaffMenu()
    if not VFW.PlayerData or not VFW.PlayerGlobalData.permissions or not VFW.PlayerGlobalData.permissions["staff_menu"] then
        console.debug("Vous n'avez pas la permission d'utiliser le menu staff.")
        return
    end

    StaffMenu.open = not StaffMenu.open

    if StaffMenu.open then
        xmenu.render(StaffMenu.main)
        buildMainMenu()
    else
        xmenu.render(false)
    end
end
