function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(Config.PaycheckInterval)
            for _, xPlayer in pairs(VFW.Players) do
                if xPlayer and xPlayer ~= nil then
                    local salary = 0

                    if xPlayer.job.onDuty then
                        if VFW.GetPlayerGlobalFromId(xPlayer.source).permissions["premiumplus"] then
                            salary = 100
                        elseif VFW.GetPlayerGlobalFromId(xPlayer.source).permissions["premium"] then
                            salary = 50
                        end

                        if xPlayer.job.name ~= "unemployed" then
                            salary = salary + xPlayer.job.grade_salary
                        else
                            salary = salary
                        end

                        xPlayer.addAccountMoney("bank", salary, "Welfare Check")
                        xPlayer.showNotification({
                            type = 'ILLEGAL',
                            name = "SALAIRE",
                            label = salary .. " $",
                            labelColor = "#00210A",
                            mainColor = 'green',
                            logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
                            mainMessage = "Votre paye à été crédité sur votre compte bancaire.",
                            duration = 10,
                        })
                    end
                end
            end
        end
    end)
end
