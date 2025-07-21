local props = {}

local function SpawnProps(object, name)
    local playerPed = VFW.PlayerData.ped
    local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objCoords = coords + forward * 2.5
    local heading = GetEntityHeading(playerPed)
    local isPlaced = false
    

    local objectSpawn = CreateObject(GetHashKey(object), objCoords.x, objCoords.y, objCoords.z, true, true, true)
    SetEntityHeading(objectSpawn, heading)
    PlaceObjectOnGroundProperly(objectSpawn)
    SetEntityCollision(objectSpawn, false, false)
    SetEntityAlpha(objectSpawn, 150, false)
    

    local networkId = ObjToNet(objectSpawn)
    SetNetworkIdExistsOnAllMachines(networkId, true)
    NetworkRegisterEntityAsNetworked(objectSpawn)
    SetNetworkIdCanMigrate(networkId, true)
    
    while not isPlaced do
        coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        objCoords = coords + forward * 2.5
        SetEntityCoords(objectSpawn, objCoords.x, objCoords.y, objCoords.z, false, false, false, true)
        PlaceObjectOnGroundProperly(objectSpawn)
        
        if IsControlPressed(0, 190) then
            heading = heading + 1.0
        elseif IsControlPressed(0, 189) then
            heading = heading - 1.0
        end
        
        SetEntityHeading(objectSpawn, heading)
        

        VFW.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ pour faire pivoter l'objet")
        

        if IsControlJustPressed(0, 38) then
            isPlaced = true
        end

        DisableControlAction(0, 22, true)

        Wait(0)
    end

    SetEntityCollision(objectSpawn, true, true)
    SetEntityInvincible(objectSpawn, true)
    FreezeEntityPosition(objectSpawn, true)
    ResetEntityAlpha(objectSpawn)

    table.insert(props, {prop = objectSpawn, nom = name})
    
    return networkId
end




local mainmenu = xmenu.create({subtitle = "Menu Props",banner = nil})
local submenu = xmenu.createSub(mainmenu, {})

function OpenMenuPropsWeazel()
    if not VFW.PlayerData.job.onDuty then 
        VFW.ShowNotification({
            type = 'ROUGE',
            content = "Vous devez être en service pour accéder à cette fonctionnalité."
        })
        return 
    end

    CreateThread(function()
        xmenu.render(mainmenu)
        while true do 
            xmenu.items(mainmenu, function()
                addButton("Supprimer mes props", {RightLabel = "→"}, {}, submenu)

                addLine()

                addButton("Fond vert", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_ld_greenscreen_01", "Fond vert")
                    end
                })

                addButton("Caméra fixe", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_tv_cam_02", "Caméra fixe")
                    end
                })

                addButton("Caméra épaule", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_v_cam_01", "Caméra épaule")
                    end
                })

                addButton("Lampe 1", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_worklight_03a", "Lampe 1")
                    end
                })

                addButton("Lampe 2", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_worklight_03b", "Lampe 2")
                    end
                })

                addButton("Lampe 3", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_worklight_04c_l1", "Lampe 3")
                    end
                })

                addButton("Lampe 4", {RightLabel = "→"}, {
                    onSelected = function()
                        SpawnProps("prop_worklight_04b_l1", "Lampe 4")
                    end
                })

                onClose(function()
                    xmenu.render(false)
                end)
            end)
            xmenu.items(submenu, function()
                for k,v in pairs(props) do 
                    addButton(v.nom, {RightLabel = "→"}, {
                        onActive = function()
                            DrawMarker(20, GetEntityCoords(v.prop) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 92, 173, 29, 255, true, 1, 0, 0)
                        end,

                        onSelected = function()
                            DeleteObject(v.prop)
                            table.remove(props, k)
                        end
                    })
                end
            end)
            Wait(500)
        end
    end)
end