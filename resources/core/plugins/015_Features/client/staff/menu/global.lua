StaffMenu.BuildGlobalMenu = function()
    xmenu.items(StaffMenu.global, function()
        addButton("SERVEUR", { rightIcon = "chevron" }, {
            onSelected = function()
                xmenu.render(false)
                StaffMenu.open = false
                ExecuteCommand("gestion")
            end
        })

        addButton("DÉVELOPPEUR", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildDevelopersMenu()
            end
        }, StaffMenu.developers)

        addButton("SANCTIONS", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildSanctionsMenu()
            end
        }, StaffMenu.sanctions)

        addButton("LÉGAL", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildLegalMenu()
            end
        }, StaffMenu.legal)

        addButton("ILLÉGAL", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildIllegalMenu()
            end
        }, StaffMenu.illegal)

        addButton("BOUTIQUE", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildBoutiqueMenu()
            end
        }, StaffMenu.boutique)

        addButton("EVENTS", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildEventsMenu()
            end
        }, StaffMenu.events)
    end)
end
