local cam = nil
local isCreating = false
local zoomOffset = 0.0
local currentCamTarget = 'body'
local cachedNation = 1 

-- ==============================================================================
-- 📍 CONFIGURAÇÃO GEOGRÁFICA (TRAJETOS E SPAWNS)
-- ==============================================================================
local NationConfig = {
    -- 1: VALTÓRIA (Avião - Los Santos)
    [1] = { 
        type = "plane", 
        spawn = { x = -1037.74, y = -2738.04, z = 20.16, h = 328.0 } 
    },
    -- 2: KARVETH (Ônibus - Paleto Bay)
    [2] = { 
        type = "bus", 
        -- Ponto de início: Estrada de entrada de Paleto Bay (No asfalto)
        start = { x = -410.6, y = 6171.1, z = 31.4, h = 320.0 }, 
        -- Ponto de parada: Próximo à parada de ônibus central
        dest = { x = -151.7, y = 6265.9, z = 31.2 }, 
        -- Spawn final do player após descer
        spawn = { x = -151.7, y = 6265.9, z = 31.2, h = 320.0 }
    }
}

local Faces = {
    Male = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44},
    Female = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45}
}

local ClothingPresets = {
    Male = { top = {{1,0},{15,0},{16,0}}, legs = {{1,0},{3,0},{4,0}}, shoes = {{1,0},{10,0},{42,0}} },
    Female = { top = {{5,0},{3,0},{18,0}}, legs = {{0,0},{4,0},{10,0}}, shoes = {{1,0},{6,0},{20,0}} }
}

CreateThread(function()
    Wait(1000)
    DoScreenFadeIn(1000)
    TriggerServerEvent('sov_core:server:RequestChars')
end)

-- ==============================================================================
-- 🎬 SISTEMA DE CUTSCENES (AVIÃO - VALTÓRIA)
-- ==============================================================================

function PlayPlaneArrival()
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(1000)

    -- FORÇAR CARREGAMENTO DO AEROPORTO
    SetEntityCoords(ped, -1037.74, -2738.04, 13.76)
    SetFocusPosAndVel(-1037.74, -2738.04, 13.76, 0.0, 0.0, 0.0)
    RequestCollisionAtCoord(-1037.74, -2738.04, 13.76)
    NewLoadSceneStart(-1037.74, -2738.04, 13.76, 0.0, 0.0, 0.0, 100.0, 0)
    
    local loadTimeout = 0
    while not HasCollisionLoadedAroundEntity(ped) and loadTimeout < 400 do Wait(10); loadTimeout = loadTimeout + 1 end

    -- ESCONDER O PLAYER REAL E CLONAR
    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    RequestCutsceneWithPlaybackList("mp_intro_concat", 31, 8)
    while not HasCutsceneLoaded() do Wait(10) end

    local clone = ClonePed(ped, false, false, false)
    local model = GetEntityModel(clone)
    local mainHandle = (model == `mp_m_freemode_01`) and "MP_Male_Character" or "MP_Female_Character"
    
    RegisterEntityForCutscene(clone, mainHandle, 0, model, 64)
    SetCutsceneEntityStreamingFlags(mainHandle, 0, 1)

    -- PASSAGEIROS ALEATÓRIOS
    local passengers = {}
    local ambientModels = { `a_m_y_business_01`, `a_f_y_business_01`, `a_m_y_bevhills_01`, `a_f_y_bevhills_01` }
    local passengerHandles = { "MP_Plane_Passenger_1", "MP_Plane_Passenger_2", "MP_Plane_Passenger_3", "MP_Plane_Passenger_4" }

    for i, handleName in ipairs(passengerHandles) do
        local rndModel = ambientModels[math.random(#ambientModels)]
        RequestModel(rndModel); while not HasModelLoaded(rndModel) do Wait(0) end
        local pPed = CreatePed(4, rndModel, 0, 0, 0, 0, false, false)
        RegisterEntityForCutscene(pPed, handleName, 0, rndModel, 64)
        table.insert(passengers, pPed)
    end

    StartCutscene(0)
    DoScreenFadeIn(1000)

    -- CORTAR ANTES DO LAMAR (Pular entrega da arma)
    while IsCutscenePlaying() do
        HideHudAndRadarThisFrame()
        if GetCutsceneTime() > 26500 or IsCutsceneSkipped() then break end
        Wait(0)
    end

    StopCutsceneImmediately()
    NewLoadSceneStop()
    ClearFocus()
    DeleteEntity(clone)
    for _, p in pairs(passengers) do DeleteEntity(p) end

    local spawn = NationConfig[1].spawn
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z)
    SetEntityHeading(ped, spawn.h)
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    DoScreenFadeIn(1500)
    DisplayRadar(true)
end

-- ==============================================================================
-- 🚌 SISTEMA DE CINEMÁTICA (ÔNIBUS - KARVETH)
-- ==============================================================================

function PlayBusArrival()
    local ped = PlayerPedId()
    local cfg = NationConfig[2]
    DoScreenFadeOut(500)
    Wait(1000)

    -- 1. CARREGAMENTO DO CHÃO DE PALETO (Prevenir cair do céu)
    SetEntityCoords(ped, cfg.start.x, cfg.start.y, cfg.start.z)
    RequestCollisionAtCoord(cfg.start.x, cfg.start.y, cfg.start.z)
    NewLoadSceneStart(cfg.start.x, cfg.start.y, cfg.start.z, 0.0, 0.0, 0.0, 50.0, 0)
    
    local lTimer = 0
    while not HasCollisionLoadedAroundEntity(ped) and lTimer < 300 do Wait(10); lTimer = lTimer + 1 end

    -- 2. SPAWN DOS ATIVOS
    local busHash = `bus`
    local driverHash = `s_m_m_autobus_01`
    RequestModel(busHash); RequestModel(driverHash)
    while not HasModelLoaded(busHash) or not HasModelLoaded(driverHash) do Wait(10) end
    
    local bus = CreateVehicle(busHash, cfg.start.x, cfg.start.y, cfg.start.z, cfg.start.h, true, false)
    SetVehicleOnGroundProperly(bus)
    SetEntityInvincible(bus, true)
    
    local driver = CreatePed(4, driverHash, cfg.start.x, cfg.start.y, cfg.start.z, cfg.start.h, true, false)
    SetPedIntoVehicle(driver, bus, -1)
    SetDriverAbility(driver, 1.0)
    SetDriverAggressiveness(driver, 0.0)
    SetBlockingOfNonTemporaryEvents(driver, true)

    -- Player invisível dentro
    SetPedIntoVehicle(ped, bus, 2)
    SetEntityVisible(ped, false, false) 
    
    -- 3. CÂMERA CINEMATOGRÁFICA
    local busCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(busCam, cfg.start.x - 20.0, cfg.start.y - 20.0, cfg.start.z + 10.0)
    PointCamAtEntity(busCam, bus, 0.0, 0.0, 0.0, true)
    SetCamActive(busCam, true)
    RenderScriptCams(true, false, 0, true, true)
    
    NewLoadSceneStop()
    DoScreenFadeIn(1000)

    -- 4. TAREFA DE DIREÇÃO (ANIMAÇÃO)
    -- O ônibus vai dirigir até a coordenada de destino
    TaskVehicleDriveToCoord(driver, bus, cfg.dest.x, cfg.dest.y, cfg.dest.z, 18.0, 0, busHash, 786603, 5.0, true)
    
    local driveTimer = 0
    while driveTimer < 1000 do
        local bPos = GetEntityCoords(bus)
        -- Atualiza câmera seguindo o bus
        SetCamCoord(busCam, bPos.x - 12.0, bPos.y + 12.0, bPos.z + 4.0)
        PointCamAtEntity(busCam, bus, 0.0, 0.0, 0.0, true)
        
        -- Verifica se chegou na rodoviária
        if #(bPos - vector3(cfg.dest.x, cfg.dest.y, cfg.dest.z)) < 6.0 then break end
        
        HideHudAndRadarThisFrame()
        driveTimer = driveTimer + 1
        Wait(10)
    end
    
    -- 5. FINALIZAÇÃO
    BringVehicleToHalt(bus, 5.0, 1, false)
    Wait(2000)
    DoScreenFadeOut(1000)
    Wait(1000)
    
    DeleteEntity(bus); DeleteEntity(driver)
    DestroyCam(busCam, false)
    RenderScriptCams(false, true, 1000, true, true)
    ClearFocus()

    SetEntityCoords(ped, cfg.spawn.x, cfg.spawn.y, cfg.spawn.z)
    SetEntityHeading(ped, cfg.spawn.h)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
    DoScreenFadeIn(2000)
    DisplayRadar(true)
end

-- ==============================================================================
-- 🔧 SISTEMA DE SPAWN E LOGIN
-- ==============================================================================

RegisterNetEvent('sov_core:client:SpawnPlayer')
AddEventHandler('sov_core:client:SpawnPlayer', function(charData)
    local ped = PlayerPedId()
    cachedNation = charData.nation_id or 1
    
    if not charData.skin then
        isCreating = true
        -- STUDIO DE CRIAÇÃO (Aeroporto ou Interior)
        SetEntityCoords(ped, -1037.0, -2737.0, 13.7)
        SetEntityHeading(ped, 330.0)
        FreezeEntityPosition(ped, true); SetEntityVisible(ped, true, false); SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openSkinCreator' })
        DoScreenFadeIn(500); UpdateCam() 
        TriggerEvent('sov_core:client:ApplyPreview', `mp_m_freemode_01`, {top=1,legs=1,shoes=1,hair=0}, {mix=0.0, features={}})
        return
    end

    -- Login Normal
    isCreating = false; DoScreenFadeOut(500); Wait(1000); SendNUIMessage({ action = "closeUI" }); SetNuiFocus(false, false)
    DestroyAllCams(true); RenderScriptCams(false, true, 1000, true, true); cam = nil
    
    if charData.skin then
        local data = json.decode(charData.skin)
        TriggerEvent('sov_core:client:ApplyPreview', data.model, data.appearance, data.features)
    end

    local spawn = NationConfig[cachedNation].spawn or NationConfig[1].spawn
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z); SetEntityHeading(ped, spawn.h)
    FreezeEntityPosition(ped, false); SetEntityVisible(ped, true, false); SetBlockingOfNonTemporaryEvents(ped, false)
    Wait(500); DoScreenFadeIn(1000); DisplayRadar(true)
end)

-- SETUP UI SELEÇÃO
RegisterNetEvent('sov_core:client:SetupUI')
AddEventHandler('sov_core:client:SetupUI', function(characters)
    DoScreenFadeOut(500); Wait(500); ShutdownLoadingScreen(); ShutdownLoadingScreenNui()
    local ped = PlayerPedId()
    SetEntityCoords(ped, -1037.0, -2737.0, 20.169)
    FreezeEntityPosition(ped, true); SetEntityVisible(ped, false, false)
    
    if cam then DestroyCam(cam, false) end
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, -1037.0, -2737.0, 200.0)
    SetCamRot(cam, -90.0, 0.0, 0.0, 2)
    SetCamActive(cam, true); RenderScriptCams(true, false, 0, true, true)
    
    Wait(100); DoScreenFadeIn(1000); SetNuiFocus(true, true); SendNUIMessage({ action = 'openUI', characters = characters })
end)

-- ==============================================================================
-- 🛠️ HELPERS (CÂMERA, PREVIEW E NUI)
-- ==============================================================================

function UpdateCam()
    if not isCreating then return end
    local ped = PlayerPedId()
    if not DoesCamExist(cam) then cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true); SetCamActive(cam, true); RenderScriptCams(true, true, 500, true, true) end
    local pos = GetEntityCoords(ped); local forward = GetEntityForwardVector(ped); local targetZ = (currentCamTarget == 'face') and 0.65 or 0.0
    local dist = ((currentCamTarget == 'face') and 0.6 or 2.5) + zoomOffset
    dist = dist < 0.35 and 0.35 or (dist > 4.0 and 4.0 or dist)
    local camPos = pos + (forward * dist) + vector3(0.0, 0.0, targetZ)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z); PointCamAtCoord(cam, pos.x, pos.y, pos.z + targetZ)
end

RegisterNUICallback('zoomCam', function(data, cb) zoomOffset = zoomOffset + (data.dir * -0.15); UpdateCam(); cb('ok') end)
RegisterNUICallback('toggleCamFocus', function(data, cb) currentCamTarget = data.force or (currentCamTarget == 'body' and 'face' or 'body'); zoomOffset = 0.0; UpdateCam(); cb('ok') end)

RegisterNetEvent('sov_core:client:ApplyPreview')
AddEventHandler('sov_core:client:ApplyPreview', function(model, appearance, skinData)
    local ped = PlayerPedId()
    if GetEntityModel(ped) ~= model then 
        RequestModel(model); while not HasModelLoaded(model) do Wait(0) end; 
        SetPlayerModel(PlayerId(), model); SetPedDefaultComponentVariation(PlayerPedId()); 
        ped = PlayerPedId() 
    end
    local isFem = (model == `mp_f_freemode_01`); local fList = isFem and Faces.Female or Faces.Male
    local f1 = fList[(skinData.face1 or 0) + 1] or fList[1]; local f2 = fList[(skinData.face2 or 0) + 1] or fList[1]
    SetPedHeadBlendData(ped, f1, f2, 0, f1, f2, 0, skinData.mix or 0.5, skinData.mix or 0.5, 0.0, false)
    if skinData.features then for i=0, 19 do SetPedFaceFeature(ped, i, (skinData.features[tostring(i)] or skinData.features[i] or 0.0) + 0.0) end end
    if appearance.hair then SetPedComponentVariation(ped, 2, appearance.hair, 0, 2) end
    if skinData.eyebrowStyle then SetPedHeadOverlay(ped, 2, skinData.eyebrowStyle, 1.0); SetPedHeadOverlayColor(ped, 2, 1, 0, 0) end
    if skinData.lipstick and skinData.lipstick < 255 then SetPedHeadOverlay(ped, 8, skinData.lipstick, 0.8); SetPedHeadOverlayColor(ped, 8, 2, skinData.lipstickColor or 0, 0) end
    local p = ClothingPresets[isFem and 'Female' or 'Male']
    if appearance and p then
        local t = p.top[appearance.top] or p.top[1]; local l = p.legs[appearance.legs] or p.legs[1]; local s = p.shoes[appearance.shoes] or p.shoes[1]
        SetPedComponentVariation(ped, 11, t[1], t[2], 2); SetPedComponentVariation(ped, 3, 15, 0, 2); SetPedComponentVariation(ped, 8, 15, 0, 2); SetPedComponentVariation(ped, 4, l[1], l[2], 2); SetPedComponentVariation(ped, 6, s[1], s[2], 2)
    end
end)

RegisterNUICallback('rotateChar', function(data, cb) SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + data.dir); cb('ok') end)
RegisterNUICallback('updateSkinPreview', function(data, cb) TriggerEvent('sov_core:client:ApplyPreview', GetHashKey(data.model), data.appearance, data.skinData); cb('ok') end)

RegisterNUICallback('saveSkin', function(data, cb)
    local final = { gender = data.gender, skin = { model = (data.gender == 'Female' and `mp_f_freemode_01` or `mp_m_freemode_01`), appearance = data.appearance, features = data.features } }
    TriggerServerEvent('sov_core:server:SaveSkin', final); SetNuiFocus(false, false); DestroyAllCams(true); RenderScriptCams(false, true, 1000, true, true); cam = nil; FreezeEntityPosition(PlayerPedId(), false); SetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    if cachedNation == 1 then PlayPlaneArrival() else PlayBusArrival() end
    cb('ok')
end)

RegisterNUICallback('selectCharacter', function(data, cb) TriggerServerEvent('sov_core:server:CharacterSelected', data.id) cb('ok') end)
RegisterNUICallback('finishCharacterCreation', function(data, cb) TriggerServerEvent('sov_core:server:FinishCreation', data) cb('ok') end)
RegisterNUICallback('deleteCharacter', function(data, cb) TriggerServerEvent('sov_core:server:DeleteCharacter', data.id) cb('ok') end)