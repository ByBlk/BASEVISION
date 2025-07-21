local ObjBoutique = {}
local pendingPurchases = {}

function GetMyVCoins(src)
    local xPlayer = VFW.GetPlayerFromId(src)
    return xPlayer:getVCoins()
end

function RemoveCoins(src, coins)
    local xPlayer = VFW.GetPlayerFromId(src)
    MySQL.Async.execute('UPDATE users SET vcoins = vcoins - @coins WHERE id = @id', {
        ['@id'] = xPlayer.id,
        ['@coins'] = coins
    }, function(rowsChanged)
        if rowsChanged > 0 then
            xPlayer.vcoins = xPlayer.vcoins - coins
        end
    end)
end

function GetPlayerByFiveMID(fmid)
    -- local fivem = 0

    -- for k,v in pairs(p) do
    --     -- print('ALL : ' .. v.fivemid)
    --     if v.fivemid == fmid then
    --         fivem = v
    --         break
    --     end
    -- end
    return p[fivemIds[fmid]] or 0;
end

function AddCoins(src, coins)
    local xPlayer = VFW.GetPlayerFromId(src)
    local getVCoins = VFW.GetVCoins(src)
    print(xPlayer.name.." a recu "..coins.." coins")
    MySQL.Async.execute('UPDATE users SET vcoins = vcoins + @coins WHERE id = @id', {
        ['@id'] = xPlayer.id,
        ['@coins'] = coins
    }, function(rowsChanged)
        if rowsChanged > 0 then
            getVCoins = getVCoins + coins
        end
    end)
end


RegisterServerCallback("vfw:getVCoins", function(source)
    local src = source
    local getVCoins = VFW.GetVCoins(src)
    print(getVCoins)
    return getVCoins
end)

-- RegisterCommand("AddCoins",function(source, args, rawCommand)
--     local src = source
--     local target = args[1]
--     local coins = tonumber(args[2])
--     local xPlayer = VFW.GetPlayerFromId(target)
--     if xPlayer then
--         AddCoins(target, coins)
--     end
-- end)

RegisterNetEvent("core:trybuyBoutiqueItem", function(data)
    local src = source
    local coins = GetMyVCoins(src)
    local price = 2500/2
    if data.price then 
        price = tonumber(data.price)
    end
    if data.category == 0 then 
        price = 3000/2
    elseif data.category == 1 then 
        price = 2500/2
    elseif data.category == 2 then 
        price = 5000/2
    elseif data.category == 3 then 
        price = 2000/2
    elseif data.category >= 4 then 
        price = 3500/2
    end
    --print("data", type(data))
    local ply = GetPlayer(src)
    if price ~= 0 then
        if data and type(data) == "table" and data.category then
            local nameCategory = idToNameCategory(tonumber(data.category))
            if ply:getBalance() >= price then 
                RemoveCoins(src, price)    
                local CustomToCreate, images, TicketMsg = IdsToCustom(data)
                print("Achat boutique de " .. GetPlayerName(src) .. " [" .. src .. "] : " .. CustomToCreate .. " au prix de " .. price .. "$")
                BoutiqueLogs("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat d'un item **CUSTOM** du joueur ".. GetPlayerName(src) .." ["..src.."].\nPr�nom Nom RP : **" .. ply:getFirstname() .. " " .. ply:getLastname() .. "**\nPrix de l'item boutique : **"..price.."**\nNombre de VCoins du joueur : "..ply:getBalance().."\nDiscord du joueur : " .. GetDiscord(src, true) .. "\n\n" .. CustomToCreate, images, true)
                SendBoutiquesInfo(GetDiscord(src, false)..".".. TicketMsg)

                TriggerClientEvent("core:boutique:validatedOrder", src)
                TriggerClientEvent("aeceoereasdqxdfgjd", src, ply:getBalance(), true, nil)
            else
                TriggerClientEvent("core:boutique:cancelledOrder", src)

            end
        end
    else
        TriggerClientEvent("core:boutique:cancelledOrder", src)
    end
end)

RegisterNetEvent("core:boutique:buypack", function(data)
    
end)

RegisterNetEvent("core:boutique:buyprenium", function()
    local src = source
    local time = os.time()
    local endDate = time + (30 * 86400)
    local ply = GetPlayer(src)
    if ply:getBalance() >= PrixBoutique["Premium"] then 
        RemoveCoins(src, PrixBoutique["Premium"])    
        MySQL.Async.execute('UPDATE users SET subscription = 1, buyendDate = @buyendDate, discord = @discord WHERE identifier = @identifier', {
            ['@identifier'] = tostring(ply:getIdentifier()),
            ['@buyendDate'] = endDate,
            ['@discord'] = GetDiscord(src),
        }, function(rowsChange)
            print("Le joueur " .. GetPlayerName(src).. " [".. tostring(src) .."] a achet� le pack premium dans la boutique.")
            BoutiqueLogs("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat du **pack premium** du joueur ".. GetPlayerName(src) .." ["..src.."].\nPr�nom Nom RP : **" .. ply:getFirstname() .. " " .. ply:getLastname() .. "**\nDiscord du joueur : " .. GetDiscord(src, true))
            SendBoutiquesInfo(GetDiscord(src, false) .. ".\n\n**Nouvelle commande !**\n> **Cat�gorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
            ply:setSubscription(1)
            TriggerClientEvent("aeceoereasdqxdfgjd", src, ply:getBalance(), nil)
            TriggerClientEvent("core:boutique:validatedOrder", src)
        end)
    else
        TriggerClientEvent("core:boutique:cancelledOrder", src)
    end
end)





RegisterServerCallback("core:boutique:getElements", function()
    return ObjBoutique
end)

RegisterNetEvent("core:boutique:createNewElement", function(element)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        table.insert(ObjBoutique, element)
	    SaveResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json', json.encode(ObjBoutique))
    end
end)

RegisterNetEvent("core:boutique:update", function(catalogue)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        SaveResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json', json.encode(catalogue))
        ObjBoutique = catalogue
        TriggerLatentClientEvent("core:boutique:update", -1, 5000, catalogue)
    end
end)

RegisterNetEvent("core:boutique:getCatalogue", function()
    local src = source
    TriggerLatentClientEvent("core:boutique:update", src, 5000, ObjBoutique)
end)

local function getGoodDiscord(discord, mention)
    if discord and string.find(discord, "discord:") then 
        newdiscord = discord:gsub("discord:", "")
        if mention then
            newdiscord = discord .. " ( <@" .. newdiscord .. "> )"
        end
        return newdiscord
    end
    return discord
end

function BuyVehicleBoutique(player2, vehicle, liveries, typeachcat, perf, colors, category)
    local player = tonumber(player2)
    local model = vehicle
    local props = {}
    local plate = GenerateNotOwnedPlate()
    props.plate = plate
    props.modLivery = liveries or 0
    if perf then
        props.modEngine = perf
        props.modBrakes = perf
        props.modTransmission = perf
        if perf > 3 then props.modEngine = 3 end
        if perf > 2 then props.modBrakes = 2 end
        if perf > 2 then props.modTransmission = 2 end
        if perf == 5 then 
            props.modTurbo = true
        end
    end
    if colors then 
        if type(colors) == "table" then 
            props.rgbcolor1 = {colors[1], colors[2], colors[3]}
            props.rgbcolor2 = {colors[1], colors[2], colors[3]}
        end
    end
    local owner = GetPlayer(player):getId()
    MySQL.Async.execute("INSERT INTO vehicles (owner, plate, name, props, inventory, garage, vente, job, premium) VALUES (@1, @2, @3, @4, @5, @6, @7, @8, @prem)"
        , {
            ["1"] = owner,
            ["2"] = props.plate,
            ["3"] = tostring(model),
            ["4"] = json.encode(props),
            ["5"] = json.encode({}),
            ["6"] = "central",
            ["7"] = nil,
            ["8"] = nil,
            ["prem"] = typeachcat == "boutiquevehicule" and 1 or 0
        }, function(affectedRows)
        if affectedRows ~= 0 then
            local inv
            if coffre[GetHashKey(model)] ~= nil and coffre[GetHashKey(model)] / 1000 ~= nil then
                inv = json.encode({item={}, cloths={}, weapons={}, weight={max=coffre[GetHashKey(model)] / 1000, current=0}})
            else
                inv = json.encode({item={}, cloths={}, weapons={}, weight={max=100, current=0}})
            end
            local veh = carDealerCreateCar({
                plate = props.plate,
                owner = owner,
                name = model,
                props = json.encode(props),
                garage = nil,
                stored = 1,
                premium = typeachcat == "boutiquevehicule" and true or false,
                vente = nil,
                coowner = json.encode({}),
                job = nil,
                inventory = json.encode(inv),
                mileage = 0,
                fuel = 100,
                body = json.encode({}),
                currentPlate = props.plate
            })
            --GetPlayerVehicle(player, true)
            if typeachcat == "boutique" then
                TriggerClientEvent('core:spawnboutiquecar', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "casino" then 
                TriggerClientEvent('core:spawnboutiquecar', player, tostring(model), props.plate, 0, props.modLivery, "casino")
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "boutiquevehicule" then 
                print("Go", boutiquevehicule, category)
                TriggerClientEvent('core:spawnboutiqueVehiclePayant', player, tostring(model), props, category)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "bateau" then
                TriggerClientEvent('core:spawnbateauachat', player, tostring(model), props, category)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "premiumsud" then
                TriggerClientEvent('core:spawnpremiumcarSud', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "noJobSud" then
                TriggerClientEvent('core:spawnnojobcarSud', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), false)
            elseif typeachcat == "noJobNord" then
                TriggerClientEvent('core:spawnnojobcarNord', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), false)
            elseif typeachcat == "premiumnord" then
                TriggerClientEvent('core:spawnpremiumcarNorth', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "heliwave" then
                TriggerClientEvent('core:spawnpremiumcarheliwave', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model))
            end

            local vehName = TriggerClientCallback(player, "core:getVehicleNameFromModel", model)

			if vehName ~= "NULL" then
				local params = {
					plate = props.plate,
					model = vehName,
				}

				exports['knid-mdt']:api().people.vehicles.create(owner, params,
					function(cb)
						if cb == 201 then
							print("^2[" .. cb .. "]^0 MDT: (" .. string.upper(typeachcat) .. ") Vehicle created : ^6", owner, json.encode(params), "^0")
						else
							print("^8[" .. cb .. "]^0 MDT: (".. string.upper(typeachcat) ..") Error creating vehicle : ^6", owner, json.encode(params), "^0")
						end
					end)
			end
        else
            --[[TriggerClientEvent('core:ShowNotification', player, "~r~Erreur lors de l'achat du v�hicule")]]
            TriggerClientEvent("__kpz::createNotification", player, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Erreur lors de l'achat du v�hicule"
            })
        end
    end)
end


RegisterNetEvent("core:boutiquevehicule:buyCar", function(name, price, performance, colors, category)
    local src = source 
    local getVCoins = VFW.GetVCoins(src)
    if not price then return end
    if price == 0 then return end
    if getVCoins >= price then
        RemoveCoins(src, price)
        TriggerClientEvent("__kpz::createNotification", src, {
            type = 'VERT',
            content = "Vous avez achet� " .. name .. " pour " .. price .. " Coins , votre v�hicule est disponible dans votre garage"
        })
        -- Todo : Give the vehicle to the player a finir razv4
    end
end)

RegisterNetEvent("core:boutiquevehicule:tryCar", function(name, category, oldcoords, colors, perf)
    local src = source 
    SetPlayerRoutingBucket(src, src)
    TriggerClientEvent("core:boutiqueveh:try", src, name, category, oldcoords, colors, perf)
end)

RegisterNetEvent("core:boutique:finishedtest", function()
    local src = source 
    SetPlayerRoutingBucket(src, 0)
end)

RegisterNetEvent("core:boutique:buyCar", function(id, veh, liveri)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        BuyVehicleBoutique(id, veh, liveri, "boutique")
        TriggerClientEvent("__kpz::createNotification", src, {
            type = 'VERT',
            content = "~s V�hicule give avec succ�s"
        })
    end
end)

RegisterNetEvent("core:boutique:buyBateau", function(veh)
    local src = source 
    BuyVehicleBoutique(src, veh, 0, "bateau")
end)


RegisterNetEvent("core:nojob:buyCar", function(veh, job)
    local src = source 
    if DoesPlayerHaveItemCount(src, "money", veh.price) then
        for key, value in pairs(GetPlayer(src):getInventaire()) do
            if value.name == "money" then
                if RemoveItemToPlayer(src, "money", veh.price, value.metadatas) then
                    if job == "noJobSud" then
                        AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                    elseif job == "noJobNord" then
                        AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                    elseif job == "noJobHeliwave" then
                        AddMoneyToSociety(veh.price*0,15, "heliwave")
                    end
                    BuyVehicleBoutique(src, veh.name, 0, job)
                else
                    TriggerClientEvent("__kpz::createNotification", src, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous n'avez pas assez d'argent en banque"
                    })
                end
            end
        end
    else
        local account = getBankPlayerFromSrc(src)
        local hasmoney = bankPlayerUpdate(src, "remove", veh.price, "player")
        if hasmoney then
            if job == "noJobSud" then
                AddMoneyToSociety(veh.price*0,15, "cardealerSud")
            elseif job == "noJobNord" then
                AddMoneyToSociety(veh.price*0,15, "cardealerNord")
            elseif job == "noJobHeliwave" then
                AddMoneyToSociety(veh.price*0,15, "heliwave")
            end
            BuyVehicleBoutique(src, veh.name, 0, job)
        end
    end
end)

RegisterNetEvent("core:premium:buyCar", function(veh, endroit)
    local src = source 
    if GetPlayer(src):getSubscription() ~= 0 then
        if DoesPlayerHaveItemCount(src, "money", veh.price) then
            for key, value in pairs(GetPlayer(src):getInventaire()) do
                if value.name == "money" then
                    if RemoveItemToPlayer(src, "money", veh.price, value.metadatas) then
                        if endroit == "sud" then
                            AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                            BuyVehicleBoutique(src, veh.name, 0, "premiumsud")
                        elseif endroit == "nord" then
                            AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                            BuyVehicleBoutique(src, veh.name, 0, "premiumnord")
                        elseif endroit == "heliwave" then
                            AddMoneyToSociety(veh.price*0,15, "heliwave")
                            BuyVehicleBoutique(src, veh.name, 0, "heliwave")
                        end
                    else
                        TriggerClientEvent("__kpz::createNotification", src, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Vous n'avez pas assez d'argent en banque"
                        })
                    end
                end
            end
        else
            local account = getBankPlayerFromSrc(src)
            local hasmoney = bankPlayerUpdate(src, "remove", veh.price, "player")
            if hasmoney then
                if endroit == "sud" then
                    AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                    BuyVehicleBoutique(src, veh.name, 0, "premiumsud")
                elseif endroit == "nord" then
                    AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                    BuyVehicleBoutique(src, veh.name, 0, "premiumnord")
                elseif endroit == "heliwave" then
                    AddMoneyToSociety(veh.price*0,15, "heliwave")
                    BuyVehicleBoutique(src, veh.name, 0, "heliwave")
                end
            end
        end
    else
        TriggerClientEvent("__kpz::createNotification", src, {
            type = 'ROUGE',
            content = "~s Vous devez avoir l'abonnement premium pour pouvoir acheter ce v�hicule"
        })
    end
end)
