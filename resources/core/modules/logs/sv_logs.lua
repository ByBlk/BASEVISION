logs = {}


logs.config = Kipstz.Logs

local defaultUsername = "L'observateur"
local defaultAvatar = "https://cdnalkia.eltrane.cloud/assets/icons/ObserverStaring.webp"

function sendToDiscord(webhook, title, embedData, color)
    if not webhook or webhook == "" then
        print("^1[Logs]^7 Webhook invalide ou manquant pour : " .. tostring(title))
        return
    end

    local embed
    if type(embedData) == "table" and embedData[1] then
        embed = embedData
    else
        embed = {{
                     title = title or "Log",
                     description = embedData or "Aucune information",
                     color = color or 16777215,
                     footer = {
                         text = os.date("%d/%m/%Y à %H:%M:%S by Kipstz")
                     }
                 }}
    end

    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({
        username = defaultUsername,
        avatar_url = defaultAvatar,
        embeds = embed
    }), {
        ["Content-Type"] = "application/json"
    })
end
