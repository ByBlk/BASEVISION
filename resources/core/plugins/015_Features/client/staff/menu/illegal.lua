function StaffMenu.BuildIllegalMenu()
    xmenu.items(StaffMenu.illegal, function()
        addButton("BRAQUAGE", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.BuildBraquageMenu()
            end
        }, StaffMenu.braquage)
    end)
end
