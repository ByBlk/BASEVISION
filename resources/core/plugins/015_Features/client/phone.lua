function VFW.ForceClosePhone()
    if exports["lb-phone"]:IsOpen() then
        exports["lb-phone"]:ToggleOpen(false)
    end
end

RegisterNetEvent("vfw:openTablet", function()
    VFW.CloseInventory()
    exports["lb-tablet"]:ToggleOpen()
end)