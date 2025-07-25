local ItemsProd = {}

local function GetIntFromBlob(b, s, o)
    r = 0
    for i=1,s,1 do
        r = r | (string.byte(b,o+i)<<(i-1)*8)
    end
    return r
end

function GetWeaponStats(weaponHash, none)
    blob = '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
    retval = Citizen.InvokeNative(0xD92C739EE34C9EBA, weaponHash, blob, Citizen.ReturnResultAnyway())
    hudDamage = GetIntFromBlob(blob,8,0)
    hudSpeed = GetIntFromBlob(blob,8,8)
    hudCapacity = GetIntFromBlob(blob,8,16)
    hudAccuracy = GetIntFromBlob(blob,8,24)
    hudRange = GetIntFromBlob(blob,8,32)
    return {hudDamage, hudSpeed, hudAccuracy, hudRange, hudCapacity}
end

for _, weapon in ipairs(BLK.Shop.Ammunations.items) do
    local tempCatalogue = {}
    if string.find(weapon.model, "weapon") then
        tempCatalogue = {
            label = weapon.label or weapon.model,
            model = weapon.model,
            image = "items/"..weapon.model..".webp",
            price = VFW.Math.GroupDigits(weapon.price),
            premium = false,
            stats = {
                firstLabel = "Selection",
                secondLabel = weapon.label or weapon.model,
                info = {
                    { label = "Dégâts", value = GetWeaponStats(joaat(weapon.model))[1] },
                    { label = "Cadence de tir", value = GetWeaponStats(joaat(weapon.model))[2] },
                    { label = "Précision", value = GetWeaponStats(joaat(weapon.model))[3]*1.5 },
                    { label = "Portée", value = GetWeaponStats(joaat(weapon.model))[4]*1.5 },
                }
            }
        }
    else
        tempCatalogue = {
            label = weapon.label or weapon.model,
            model = weapon.model,
            image = "items/"..weapon.model..".webp",
            price = VFW.Math.GroupDigits(weapon.price),
            premium = weapon.premium
        }
    end
    table.insert(ItemsProd, tempCatalogue)
end

local function MenuConfig()
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 1,
            gridType = 1,
            buyType = 2,
            lineColor = "linear-gradient(to right, rgba(255, 56, 14, .6) 0%, rgba(255, 56, 14, .6) 56%, rgba(219, 200, 147, 0) 100%)",
            title = "AMMUNATION",
            buyTextType = "price",
        },
        eventName = "ammu",
        showStats = {
            show = true,
            showButton = false,
            default = true
        },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = { show = false },
        color = { show = false },
        items = ItemsProd
    }
    return data
end

RegisterNuiCallback("nui:newgrandcatalogue:ammu:selectBuy", function(data)
    TriggerServerEvent("vfw:ammu:buy", data)
end)


RegisterNUICallback("nui:newgrandcatalogue:ammu:close", function()
    VFW.Nui.NewGrandMenu(false)
end)

for k, v in pairs(BLK.Shop.Ammunations.Position) do
    VFW.CreateBlipAndPoint("ammu", v, k, BLK.Shop.Ammunations.Blips.Sprite, BLK.Shop.Ammunations.Blips.Color, BLK.Shop.Ammunations.Blips.Scale, BLK.Shop.Ammunations.Blips.Name, "AmmuNation", "E", "Ammunation",{
        onPress = function()
            VFW.Nui.NewGrandMenu(true, MenuConfig())
        end
    })
end