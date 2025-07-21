StaffMenu.isInDevMode = true
StaffMenu.PrintPropsAndEntities = true
local invisible = false

function StaffMenu.BuildDevelopersMenu()
    xmenu.items(StaffMenu.developers, function()
        addCheckbox("MODE DEVELOPEUR", StaffMenu.isInDevMode, {}, {
            onChange = function(checked)
                StaffMenu.isInDevMode = checked
            end
        })

        addCheckbox("PRINT PROPS & ENTITIES", StaffMenu.PrintPropsAndEntities, {}, {
            onChange = function(checked)
                StaffMenu.PrintPropsAndEntities = checked
            end
        })

        addLine()

        addButton("CREATION DE CAMERA", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildCameraMenu()
            end
        }, StaffMenu.camera)

        addButton("ZONE SAFE", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildZoneSafeMenu()
            end
        }, StaffMenu.zoneSafe)

        addButton("COPOSENTS D'ARMES", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildCoponentsWeaponMenu()
            end
        }, StaffMenu.weapon)
    end)
end
