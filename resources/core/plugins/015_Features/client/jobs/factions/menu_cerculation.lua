local lastJob = nil

local function loadCerciculationMenu()
    local open = false
    local traficList = {}
    local speed = 0.0
    local radius = 0.0
    local show = false
    local zoneName = ""
    local zonePos = vector3(0, 0, 0)
    local mainmenu = xmenu.create({ subtitle = "Historique des appels", banner = ("https://cdn.eltrane.cloud/alkiarp/assets/catalogues/headers/header_%s.webp"):format(lastJob) })
    local traffic_add = xmenu.createSub(mainmenu, { subtitle = "Ajouter une zone de circulation" })
    local traffic_view = xmenu.createSub(mainmenu, { subtitle = "Voir les zones de circulation" })

    local function Marcker(data)
        CreateThread(function()
            while show do
                local distance = data.zoneRadius + .0
                DrawMarker(1, data.zonePos + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0, distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                Wait(0)
            end
        end)
    end

    function OpenCerculationenu()
        if open then
            open = false
            xmenu.render(false)
        else
            open = true
            CreateThread(function()
                xmenu.render(mainmenu)

                while open do
                    xmenu.items(mainmenu, function()
                        addButton("Ajouter une zone", {}, {
                            onSelected = function()
                                zonePos = GetEntityCoords(VFW.PlayerData.ped)
                            end
                        }, traffic_add)

                        addButton("Voir les zones", {}, {
                            onSelected = function()
                                traficList = TriggerServerCallback("core:jobs:traffic:get")
                            end
                        }, traffic_view)

                        onClose(function()
                            open = false
                            traficList = {}
                            speed = 0.0
                            radius = 0.0
                            show = false
                            zoneName = ""
                            zonePos = vector3(0, 0, 0)
                            xmenu.render(false)
                        end)
                    end)

                    xmenu.items(traffic_add, function()
                        addButton("Vitesse", { rightLabel = speed .. " km/h" }, {
                            onSelected = function()
                                speed = tonumber(VFW.Nui.KeyboardInput(true, "Vitesse")) + .0
                                if speed == nil then
                                    speed = 0.0
                                end
                            end
                        })

                        addButton("Rayon", { rightLabel = radius .. " m" }, {
                            onSelected = function()
                                radius = tonumber(VFW.Nui.KeyboardInput(true, "Rayon")) + .0
                                if radius == nil then
                                    radius = 0.0
                                end
                            end
                        })

                        addCheckbox("Afficher", show, {}, {
                            onChange = function(checked)
                                show = checked
                                if show then
                                    Marcker({
                                        zonePos = zonePos,
                                        zoneRadius = radius,
                                    })
                                else
                                    show = false
                                end
                            end
                        })

                        addButton("Nom de la zone", { rightLabel = zoneName }, {
                            onSelected = function()
                                zoneName = VFW.Nui.KeyboardInput(true, "Nom de la zone")
                            end
                        })

                        addButton("Ajouter la zone", { rightLabel = "" }, {
                            onSelected = function()
                                if radius ~= 0 and zoneName ~= "" then
                                    local id = AddRoadNodeSpeedZone(zonePos, radius, speed, true)
                                    local newZone = {
                                        zoneName = zoneName,
                                        zonePos = zonePos,
                                        zoneRadius = radius,
                                        zoneSpeed = speed,
                                        zoneId = id
                                    }
                                    show = false
                                    TriggerServerEvent("core:jobs:traffic:add", newZone)
                                    VFW.ShowNotification({
                                        type = 'VERT',
                                        content = "~s Zone ajoutée"
                                    })
                                    open = false
                                    xmenu.render(false)
                                else
                                    VFW.ShowNotification({
                                        type = 'ROUGE',
                                        content = "~s Veuillez remplir tous les champs"
                                    })
                                end
                            end
                        })
                    end)

                    xmenu.items(traffic_view, function()
                        for k, v in pairs(traficList) do
                            addButton(v.zoneId .. " | " .. v.zoneName, { rightLabel = "~r~ Supprimer" }, {
                                onSelected = function()
                                    RemoveRoadNodeSpeedZone(v.zoneId)
                                    TriggerServerEvent("core:jobs:traffic:remove", v.zoneId)
                                    VFW.ShowNotification({
                                        type = 'VERT',
                                        content = "~s Zone supprimée"
                                    })
                                    xmenu.render(false)
                                end,
                            })
                        end
                    end)

                    Wait(500)
                end
            end)
        end
    end
end

RegisterNetEvent("core:jobs:traffic:addclient", function(zone)
    AddRoadNodeSpeedZone(zone.zonePos, zone.zoneRadius, zone.zoneSpeed, true)
end)

RegisterNetEvent("core:jobs:traffic:removeclient", function(zone)
    RemoveRoadNodeSpeedZone(zone)
end)

RegisterNetEvent("vfw:setJob", function(Job)
    if Job.name == lastJob then return end
    if Job.name == "unemployed" then
        lastJob = nil
        return
    end
    lastJob = Job.name
    loadCerciculationMenu()
end)

RegisterNetEvent("vfw:playerReady", function()
    if lastJob then lastJob = nil end
    if VFW.PlayerData.job.name == "unemployed" then return end
    lastJob = VFW.PlayerData.job.name
    loadCerciculationMenu()
end)
