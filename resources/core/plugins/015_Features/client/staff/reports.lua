VFW.Reports = {}
RegisterNetEvent("vfw:staff:reports", function(reports)
    VFW.Reports = reports
end)

RegisterNetEvent("vfw:staff:report", function(report)
    table.insert(VFW.Reports, report)
    VFW.lastReport = report.id

    SetTimeout(10000, function()
        if VFW.lastReport == report.id then
            VFW.lastReport = nil
        end
    end)
end)

RegisterNetEvent("vfw:staff:deleteReport", function(id)
    for i = 1, #VFW.Reports do
        if VFW.Reports[i].id == id then
            table.remove(VFW.Reports, i)
            break
        end
    end
end)

RegisterNetEvent("vfw:staff:updateReport", function(report)
    for i = 1, #VFW.Reports do
        if VFW.Reports[i].id == report.id then
            VFW.Reports[i] = report
            break
        end
    end
end)