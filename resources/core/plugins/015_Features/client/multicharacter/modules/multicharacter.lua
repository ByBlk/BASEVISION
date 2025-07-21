Multicharacter = {}
Multicharacter._index = Multicharacter
Multicharacter.Characters = {}
Multicharacter.hidePlayers = false

function Multicharacter:AwaitFadeIn()
    while IsScreenFadingIn() do
        Wait(200)
    end
end

function Multicharacter:AwaitFadeOut()
    while IsScreenFadingOut() do
        Wait(200)
    end
end

local HiddenCompents = {}

local function HideComponents(hide)
    local components = {11, 12, 21}

    for i = 1, #components do
        if hide then
            local size = GetHudComponentSize(components[i])

            if size.x > 0 or size.y > 0 then
                HiddenCompents[components[i]] = size
                SetHudComponentSize(components[i], 0.0, 0.0)
            end
        else
            if HiddenCompents[components[i]] then
                local size = HiddenCompents[components[i]]

                SetHudComponentSize(components[i], size.x, size.z)
                HiddenCompents[components[i]] = nil
            end
        end
    end
    
    VFW.Nui.HudVisible(not hide)
end

function Multicharacter:HideHud(hide)
    self.hidePlayers = true

    MumbleSetVolumeOverride(VFW.PlayerId, 0.0)
    HideComponents(hide)
end

function Multicharacter:SetupCharacters()
    VFW.PlayerLoaded = false
    VFW.PlayerData = {}

    self.spawned = false
    self.playerPed = PlayerPedId()

    local randomIndex = VFW.Math.Random(1, #Config.Multicharacter.Spawn)
    local selectedSpawn = Config.Multicharacter.Spawn[randomIndex]

    self.spawnCoords = selectedSpawn.COH
    self.cameras = selectedSpawn

    self:HideHud(true)

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    TriggerServerEvent("vfw:multicharacter:SetupCharacters")
end

function Multicharacter:GetSkin()
    local character = self.Characters[self.tempIndex]
    local skin = character and character.skin or Config.Multicharacter.Default
    return skin
end

function Multicharacter:CreateCharacterClone()
    if self.characterClone then
        DeleteEntity(self.characterClone)
        self.characterClone = nil
    end

    self.characterClone = VFW.CreatePlayerClone(
            self:GetSkin(),
            self.Characters[self.tempIndex].tattoos,
            vector3(self.spawnCoords.x, self.spawnCoords.y, self.spawnCoords.z),
            self.spawnCoords.w
    )
end

function Multicharacter:SetupCharacter(index)
    self.tempIndex = index

    self:CreateCharacterClone()

    self.spawned = index

    local randomIndex = VFW.Math.Random(1, #Config.Multicharacter.Spawn)
    local selectedSpawn = Config.Multicharacter.Spawn[randomIndex]

    self.spawnCoords = selectedSpawn.COH
    self.cameras = selectedSpawn

    if self.characterClone then
        SetEntityCoords(self.characterClone, self.spawnCoords.x, self.spawnCoords.y, self.spawnCoords.z)
        SetEntityHeading(self.characterClone, self.spawnCoords.w)
    end

    if not self.cameraZAdjusted then
        for i = 1, #Config.Multicharacter.Spawn do
            local camera = Config.Multicharacter.Spawn[i]
            camera.CamCoords.z = camera.CamCoords.z + 1
        end
        self.cameraZAdjusted = true
    end

    ClearFocus()
    SetFocusArea(self.cameras.CamCoords.x, self.cameras.CamCoords.y, self.cameras.CamCoords.z)

    SetTimeout(100, function()
        VFW.Cam:Create("multichar", self.cameras, self.characterClone)
    end)
end

function Multicharacter:Cleanup()
    if self.characterClone then
        DeleteEntity(self.characterClone)
        self.characterClone = nil
    end
end

function Multicharacter:SetupUI(characters, slots)
    while VFW.PlayerGlobalData == nil do Wait(1000) end
    
    self.Characters = characters
    self.slots = slots

    local Character = next(self.Characters)

    NetworkOverrideClockTime(12, 0, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')

    if not Character then
        TriggerServerEvent("vfw:multicharacter:CharacterChosen", 1, true)
        Wait(50)
        LoadNewCharCreator()
    else
        self:SetupCharacter(1)
        Wait(50)

        local items = {}
        
        for i = 1, #self.Characters do
            items[i] = {
                id = i,
                info = self.Characters[i].info,
                firstName = self.Characters[i].firstname,
                lastName = self.Characters[i].lastname,
                img = self.Characters[i].mugshot
            }
        end
        
        VFW.Nui.Multicharacter(true, {
            visible = true,
            items = items,
            isPremium = VFW.PlayerGlobalData.permissions["premium"],
            isPremiumPlus = VFW.PlayerGlobalData.permissions["premiumplus"]
        })
    end
    DoScreenFadeIn(150)
end

function Multicharacter:Reset()
    self.Characters = {}
    self.tempIndex = nil
    self.playerPed = PlayerPedId()
    self.hidePlayers = false
    self.slots = nil
end

function Multicharacter:PlayerLoaded(playerData, isNew, skin)
    VFW.PlayerData = playerData

    local function finishLoading()
        TriggerEvent("vfw:client:playerLoaded")
        TriggerServerEvent("vfw:onPlayerLoaded")
        TriggerEvent("vfw:onPlayerLoaded")
        TriggerEvent("vfw:restoreLoadout")
        TriggerServerEvent("vfw:sync:onPlayerJoined")

        self:Reset()
    end

    if isNew or not skin or #skin == 1 then
        TriggerEvent("skinchanger:getSkin", function(cb)
            skin = cb
            finishLoading()

            TriggerServerEvent("core:server:startCreator")
        end)
    else
        local selectedSkin = skin or (self.spawned and self.Characters[self.spawned] and self.Characters[self.spawned].skin)

        VFW.SpawnPlayer(selectedSkin, playerData.coords, function()
            self.playerPed = PlayerPedId()

            self:HideHud(false)
            FreezeEntityPosition(self.playerPed, false)
            SetEntityCollision(self.playerPed, true, true)
            SetEntityVisible(self.playerPed, true)
            SetEntityAlpha(self.playerPed, 255, false)

            finishLoading()
        end)

        DoScreenFadeIn(0)
    end
end

RegisterNuiCallback("multicharacter:createNewPersonnage", function()
    for i = 1, Multicharacter.slots do
        if not Multicharacter.Characters[i] then
            TriggerServerEvent("vfw:multicharacter:CharacterChosen", i, true)
            VFW.Nui.Multicharacter(false)
            VFW.Cam:Destroy("multichar")
            ClearFocus()
            Multicharacter:Cleanup()
            LoadNewCharCreator()
            break
        end
    end
end)

RegisterNuiCallback("multicharacter:PlayerHovered", function(id)
    if not id or not Multicharacter.Characters[id] then return end
    Multicharacter:SetupCharacter(id)
end)

RegisterNuiCallback("multicharacter:PlayerSelected", function(id)
    if not id then return end
    VFW.Nui.Multicharacter(false)
    DoScreenFadeOut(0)
    Multicharacter:AwaitFadeOut()
    VFW.Cam:Destroy("multichar")
    ClearFocus()
    Multicharacter:Cleanup()
    TriggerServerEvent("vfw:multicharacter:CharacterChosen", id, false)
end)
