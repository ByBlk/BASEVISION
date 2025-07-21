StaffMenu.data.banList = {}

function StaffMenu.BuildSanctionsMenu()
    xmenu.items(StaffMenu.sanctions, function()
        addButton("LIST DES BANS", { rightIcon = "chevron" }, {
            onSelected = function()
                StaffMenu.data.banList = TriggerServerCallback("core:ban:getbans") or {}
                StaffMenu.BuildBansMenu()
            end
        }, StaffMenu.bans)
    end)
end
