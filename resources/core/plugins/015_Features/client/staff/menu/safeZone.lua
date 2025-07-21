function StaffMenu.BuildZoneSafeMenu()
    xmenu.items(StaffMenu.zoneSafe, function()
        addButton("CRÉATION DE ZONESAFE", {}, {
            onSelected = function()
                StaffMenu.BuildCreateZoneSafeMenu()
            end
        }, StaffMenu.CreateZoneSafe)
        addButton("LISTE DES ZONESAFE", {}, {
            onSelected = function()
                StaffMenu.BuildListZoneSafeMenu()
            end
        }, StaffMenu.ListZoneSafe)
    end)
end

local terName = "Aucun"
local nbPoint = 0
local coords = nil
local showZone = false
local zonePoints = {}
local x1, y1, z1, x2, y2, z2 = nil, nil, nil, nil, nil, nil
local j = 0

local function DrawWall(x1, y1, z1, x2, y2, z2, r, g, b, a)
    local color = {r, g, b, a}
    local a = {x = x1, y = y1, z = z1}
    local b = {x = x1, y = y1, z = z1+50.0}
    local c = {x = x2, y = y2, z = z2}
    local d = {x = x2, y = y2, z = z2+50.0}

    DrawPoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, color[1], color[2], color[3], color[4])
    DrawPoly(c.x, c.y, c.z, b.x, b.y, b.z, a.x, a.y, a.z, color[1], color[2], color[3], color[4])
    DrawPoly(b.x, b.y, b.z, c.x, c.y, c.z, d.x, d.y, d.z, color[1], color[2], color[3], color[4])
    DrawPoly(d.x, d.y, d.z, c.x, c.y, c.z, b.x, b.y, b.z, color[1], color[2], color[3], color[4])
end

function StaffMenu.BuildCreateZoneSafeMenu()
    xmenu.items(StaffMenu.CreateZoneSafe, function()
        addSeparator("Nom : " .. terName)

        addButton("NOM DE LA ZONE", { rightIcon = "chevron" }, {
            onSelected = function()
                terName = VFW.Nui.KeyboardInput(true, "Entrer un nom de zone")
                if terName and terName ~= nil then
                    terName = tostring(terName)
                end
            end
        })

        addCheckbox("AFFICHER LA ZONE", showZone, {}, {
            onChange = function(checked)
                showZone = checked
                if showZone then
                    DrawZoneValue = true
                    CreateThread(function()
                        while DrawZoneValue do
                            Wait(0)
                            for i = 1, #zonePoints do
                                j = i + 1
                                if j > #zonePoints then
                                    j = 1
                                end

                                x1, y1, z1 = zonePoints[i].x, zonePoints[i].y, zonePoints[i].z-20.0
                                x2, y2, z2 = zonePoints[j].x, zonePoints[j].y, zonePoints[j].z-20.0
                                DrawWall(x1, y1, z1, x2, y2, z2, 0, 255, 0, 180)
                            end
                        end
                    end)
                else
                    DrawZoneValue = false
                end
            end
        })

        addButton("AJOUTER UN POINT", { rightIcon = "chevron" }, {
            onSelected = function()
                nbPoint += 1
                coords = GetEntityCoords(PlayerPedId())
                zonePoints[nbPoint] = coords
            end
        })

        addButton("SUPPRIMER LE DERNIER POINT", { rightIcon = "chevron" }, {
            onSelected = function()
                zonePoints[nbPoint] = nil
                nbPoint -= 1
            end
        })

        addLine()

        addButton("CRÉER LA ZONE SAFE", { rightIcon = "chevron" }, {
            onSelected = function()
                if terName ~= "Aucun" and #zonePoints >=3 then
                    DrawZoneValue = false
                    showZone = false
                    TriggerServerEvent("core:admin:createZoneSafe", terName, zonePoints)
                    Wait(200)
                    nbPoint = 0
                    terName = "Aucun"
                    zonePoints = {}
                    VFW.ShowNotification({
                        type = 'VERT',
                        content = "~c La zone safe a été créé"
                    })
                else
                    VFW.ShowNotification({
                        type = 'ROUGE',
                        content = "~c Impossible de créer, il manque un titre ou des points (minimum 3)"
                    })
                end
            end
        })
    end)
end

function StaffMenu.BuildListZoneSafeMenu()
    xmenu.items(StaffMenu.ListZoneSafe, function()
        for k,v in pairs(AllSafeZone) do
            addButton("SUPPRIMER : " .. string.upper(k), { rightIcon = "chevron" }, {
                onSelected = function()
                    local name = VFW.Nui.KeyboardInput(true, "Êtes vous sur de supprimer cette zone safe ? (écrivez oui)", "")
                    if name and string.lower(name) == "oui" then
                        TriggerServerEvent("core:admin:deleteZoneSafe", k)
                        VFW.ShowNotification({
                            type = 'VERT',
                            content = "Zone supprimée avec succès"
                        })
                        xmenu.render(StaffMenu.zoneSafe)
                        StaffMenu.BuildZoneSafeMenu()
                    end
                end
            })
        end
    end)
end
