--laboratory = {
--    id = 0,
--    crew = nil,
--    laboType = nil,
--    coords = {},
--    state = 0,
--    minutes = 0,
--    maxTime = 120,
--    quantityDrugs = nil,
--    blocked = false,
--    percentages = {},
--}
--
--laboratory.__index = laboratory
--
classlabo = {} ---@type laboratory
local classlaboCrew = {} ---@type laboratory
--
---@return laboratory
function GetLabo(id)
    return classlabo[id]
end

---@return laboratory
function GetLaboByCrew(crew)
    return classlaboCrew[crew]
end
--
--function laboratory:setAttacked(bool)
--    self.attacked = bool
--end

--




---@class laboratory
---@field id number
---@field crew string
---@field laboType string
---@field coords vec3
---@field state number
---@field minutes number
---@field maxTime number
---@field quantityDrugs number
---@field blocked boolean
---@field percentages table
---@field needSave boolean
---@field open boolean
function CreateLaboratory(id, crew, laboType, coords, state, minutes, maxTime, quantityDrugs, blocked, percentages, needSave)
    local self = {}
    self.id = id or 0
    self.crew = crew or ""
    self.laboType = laboType or ""
    self.coords = coords or vec3(0.0, 0.0, 0.0)
    self.state = state or 0
    self.minutes = minutes or 0
    self.maxTime = maxTime or 120
    self.quantityDrugs = quantityDrugs
    self.blocked = blocked or false
    self.percentages = percentages or {}
    self.needSave = needSave or true
    self.attacked = false
    self.open = false

    console.debug("self.id = " .. self.id)
    classlabo[id] = self
    classlaboCrew[crew] = self

    function self.makeDrug(id, minutes, shouldUseNewInfo)
        CreateThread(function()
            if shouldUseNewInfo then
                self.minutes = minutes
            end
            while true do
                Citizen.Wait(60000)
                if self.minutes <= 1 then
                    if self.state ~= 2 then
                        if self.percentages[1] > 0 and self.percentages[2] > 0 and self.percentages[3] > 0 then
                            self.state = 2
                            self.minutes = 0
                            self.quantityDrugs = 180
                            TriggerClientEvent("core:labo:finished", -1, self.id, self.percentages, self.quantityDrugs, self.laboType)
                            TriggerClientEvent("core:labo:sendnotif", -1, self.crew, "Votre production de " .. self.laboType .. " est terminée", self.id)
                            break
                        end
                    end
                else
                    self.state = 1
                    if not self.blocked then
                        if not self.percentages then
                            self.minutes = self.minutes - 1
                        else
                            self.minutes = self.minutes - 1
                            self.sentNotif = false
                            if math.fmod(self.minutes, 2) == 0 then -- modulo
                                local percen = (self.minutes/self.maxTime)*100
                                self.percentages[1] = self.percentages[1]-2
                                self.percentages[2] = self.percentages[2]-2
                                self.percentages[3] = self.percentages[3]-2
                            end
                        end
                    end
                end
            end
        end)
    end

    if self.state == 1 then
        if self.minutes and self.minutes <= 1 then
            self.state = 2
        else
            self.makeDrug(self.id, self.minutes)
        end
    end

    function self.getId()
        return self.id
    end

    function self.getCrew()
        return self.crew
    end

    function self.getlaboType()
        return self.laboType
    end

    function self.deleteLabo()
        MySQL.Async.execute("DELETE FROM laboratory WHERE id = @laboid", { ['@laboid'] = self.id })
        classlaboCrew[self.crew] = nil
        classlabo[self.id] = nil
    end

    function self.updateQuantityDrugs(nbr)
        self.quantityDrugs = nbr
        self.needSave = true
    end

    function self.addEntity(ent)
        if not self.entities then
            self.entities = {}
        end
        table.insert(self.entities, ent)
    end

    function self.getEntities()
        return self.entities
    end

    function self.removeEntities()
        if self.entities and next(self.entities) then
            for k,v in pairs(self.entities) do
                local ent = NetworkGetEntityFromNetworkId(v)
                if ent then
                    DeleteEntity(ent)
                end
            end
        end
    end

    function self.getQuantityDrugs()
        return self.quantityDrugs
    end

    function self.updateState(state)
        self.state = state
        self.needSave = true
    end

    function self.getState()
        return self.state
    end

    function self.updateBlocked(bool)
        self.blocked = bool
    end

    function self.getBlocked()
        return self.blocked
    end

    function self.updateMinutes(minutes)
        self.minutes = minutes
        self.needSave = true
    end

    function self.getMinutes()
        return self.minutes
    end

    function self.getPercentages()
        return self.percentages
    end

    function self.updatePercentages(tbl)
        self.percentages = tbl
        self.needSave = true
    end

    function self.updateMaxTime(nbr)
        self.maxTime = nbr
        self.needSave = true
    end

    function self.setOpen(bool)
        self.open = bool
        self.needSave = true
    end

    function self.updateCoords(coords)
        self.coords = coords
    end

    function self.getOpen(bool)
        return self.open
    end

    function self.needSave(bool)
        if bool ~= nil then
            self.needSave = bool
        end
        return self.needSave
    end


    return self

end


CreateThread(function()
    while true do
        Wait(5 * 60000)
        local countLab = 0
        for k,v in pairs(classlabo) do
            if v.needSave then
                MySQL.Async.execute("UPDATE laboratories SET maxTime=@maxTime, drugs=@drugs, percentages=@percentages, minutes=@minutes, state=@state WHERE id=@id",
                {
                    ['@minutes'] = v.minutes,
                    ['@state'] = v.state,
                    ["@drugs"] = (v.quantityDrugs or 0),
                    ['@maxTime'] = v.maxTime,
                    ['@percentages'] = json.encode(v.percentages),
                    ["@id"] = v.id
                })
                countLab += 1
                v.needSave = false
                Wait(500)
            else
                Wait(250)
            end
        end
        if countLab > 0 then
            console.debug("Saved " .. countLab .. " labos.")
        end
    end
end)
