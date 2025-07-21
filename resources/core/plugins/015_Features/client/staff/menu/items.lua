local itemQuery = nil

local function normalizeString(str)
    if not str then return "" end
    return string.lower(string.gsub(str, "[%s%-_%.]", ""))
end

local function levenshtein(str1, str2)
    local len1, len2 = #str1, #str2
    local matrix = {}

    for i = 0, len1 do
        matrix[i] = {[0] = i}
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    for i = 1, len1 do
        for j = 1, len2 do
            local cost = str1:sub(i, i) == str2:sub(j, j) and 0 or 1
            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
        end
    end

    return matrix[len1][len2]
end


local function fuzzySearch(query, text)
    if not query or not text then return false end

    local normQuery = normalizeString(query)
    local normText = normalizeString(text)

    if string.find(normText, normQuery) then
        return true
    end

    local maxDistance = math.max(1, math.floor(#normQuery * 0.3))
    local distance = levenshtein(normQuery, normText)

    return distance <= maxDistance
end

function StaffMenu.BuildItemsMenu()
    xmenu.items(StaffMenu.items, function()
        local firstLabel = itemQuery == nil and "RECHERCHER" or "RECHERCHER:"
        local lastLabel = itemQuery == nil and "UN ITEM" or itemQuery

        addButton(firstLabel .. " " .. lastLabel, { rightIcon = "search" }, {
            onSelected = function()
                if itemQuery ~= nil then
                    itemQuery = nil
                    StaffMenu.BuildItemsMenu()
                    return
                end

                itemQuery = VFW.Nui.KeyboardInput(true, "Entrez un Nom / Label")
                if itemQuery == nil or itemQuery == "" then return end
                StaffMenu.BuildItemsMenu()
            end,
        })

        addLine()

        while not VFW.Items do Wait(100) end

        for k, v in pairs(VFW.Items) do
            if itemQuery == nil or fuzzySearch(itemQuery, k) or fuzzySearch(itemQuery, v.label) then
                local name = (k == nil or k == "") and "AUCUN" or k
                local label = (v.label == nil or v.label == "") and name or v.label

                addButton(string.upper(label), { rightLabel = tostring(name) }, {
                    onSelected = function()
                        local count = VFW.Nui.KeyboardInput(true, "Quantité")

                        if tonumber(count) then
                            ExecuteCommand(("giveitem %s %s %s"):format(StaffMenu.data.playerInfo.id, k, count))
                            VFW.ShowNotification({
                                type = 'VERT',
                                content = "Vous venez de give l'item."
                            })
                        else
                            VFW.ShowNotification({
                                type = 'ROUGE',
                                content = "Veuillez entrer un nombre valide."
                            })
                        end
                    end,
                })
            end
        end

        onClose(function()
            itemQuery = nil
        end)
    end)
end
