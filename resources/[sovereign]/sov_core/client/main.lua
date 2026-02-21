local cam = nil
local isCreating = false
local zoomOffset = 0.0
local currentCamTarget = 'body'
local cachedNation = 1 

-- ==============================================================================
-- 📍 CONFIGURAÇÃO DE SPAWN (SEM CUTSCENE)
-- ==============================================================================
local NationConfig = {
    -- 1: VALTÓRIA (Spawn Direto no Aeroporto)
    [1] = { 
        spawn = { x = -1037.74, y = -2738.04, z = 20.16, h = 328.0 } 
    },
    -- 2: KARVETH (Spawn Direto em Paleto Bay)
    [2] = { 
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
    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    TriggerServerEvent('sov_core:server:RequestChars')
end)

-- ==============================================================================
-- 🔧 SISTEMA DE SPAWN E LOGIN
-- ==============================================================================

RegisterNetEvent('sov_core:client:SpawnPlayer')
AddEventHandler('sov_core:client:SpawnPlayer', function(charData)
    local ped = PlayerPedId()
    cachedNation = charData.nation_id or 1
    
    -- MODO CRIAÇÃO (Novo Char)
    if not charData.skin then
        isCreating = true
        
        -- Teleporte para Sala de Criação (Aeroporto)
        SetEntityCoords(ped, -1037.0, -2737.0, 13.7)
        SetEntityHeading(ped, 330.0)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, true, false)
        SetNuiFocus(true, true)
        
        -- Aplica Skin Inicial Padrão
        TriggerEvent('sov_core:client:ApplyPreview', `mp_m_freemode_01`, {top=1,legs=1,shoes=1,hair=0}, {mix=0.0, features={}})
        
        SendNUIMessage({ action = 'openSkinCreator' })
        DoScreenFadeIn(500)
        UpdateCam() 
        return
    end

    -- LOGIN NORMAL (Char Existente)
    isCreating = false
    DoScreenFadeOut(500)
    Wait(1000)
    SendNUIMessage({ action = "closeUI" })
    SetNuiFocus(false, false)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1000, true, true)
    cam = nil
    
    -- Aplica Skin Salva
    if charData.skin then
        local data = json.decode(charData.skin)
        TriggerEvent('sov_core:client:ApplyPreview', data.model, data.appearance, data.features)
    end

    -- TELEPORTE FINAL (SEM CUTSCENE)
    local spawn = NationConfig[cachedNation].spawn or NationConfig[1].spawn
    
    -- Carrega o mapa antes de teleportar para não cair no limbo
    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
    local time = 0
    while not HasCollisionLoadedAroundEntity(ped) and time < 100 do
        Wait(10)
        time = time + 1
    end

    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z)
    SetEntityHeading(ped, spawn.h)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
    SetBlockingOfNonTemporaryEvents(ped, false)
    
    Wait(500)
    DoScreenFadeIn(1000)
    DisplayRadar(true)
end)

-- SETUP UI SELEÇÃO
RegisterNetEvent('sov_core:client:SetupUI')
AddEventHandler('sov_core:client:SetupUI', function(characters)
    DoScreenFadeOut(500)
    Wait(500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    
    local ped = PlayerPedId()
    SetEntityCoords(ped, -1037.0, -2737.0, 20.169)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    
    if cam then DestroyCam(cam, false) end
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, -1037.0, -2737.0, 200.0)
    SetCamRot(cam, -90.0, 0.0, 0.0, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    
    Wait(100)
    DoScreenFadeIn(1000)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openUI', characters = characters })
end)

-- ==============================================================================
-- 🛠️ HELPERS (CÂMERA, PREVIEW E NUI)
-- ==============================================================================

function UpdateCam()
    if not isCreating then return end
    local ped = PlayerPedId()
    if not DoesCamExist(cam) then 
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true) 
    end
    
    local pos = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local targetZ = (currentCamTarget == 'face') and 0.65 or 0.0
    local dist = ((currentCamTarget == 'face') and 0.6 or 2.5) + zoomOffset
    dist = dist < 0.35 and 0.35 or (dist > 4.0 and 4.0 or dist)
    
    local camPos = pos + (forward * dist) + vector3(0.0, 0.0, targetZ)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, pos.x, pos.y, pos.z + targetZ)
end

RegisterNUICallback('zoomCam', function(data, cb) zoomOffset = zoomOffset + (data.dir * -0.15); UpdateCam(); cb('ok') end)
RegisterNUICallback('toggleCamFocus', function(data, cb) currentCamTarget = data.force or (currentCamTarget == 'body' and 'face' or 'body'); zoomOffset = 0.0; UpdateCam(); cb('ok') end)

RegisterNetEvent('sov_core:client:ApplyPreview')
AddEventHandler('sov_core:client:ApplyPreview', function(model, appearance, skinData)
    local ped = PlayerPedId()
    
    -- CORREÇÃO DO BUG MASCULINO/FEMININO
    -- Verifica se 'model' veio como texto ("mp_f_freemode_01") ou Hash number
    local modelHash = model
    if type(model) == "string" then
        modelHash = GetHashKey(model)
    end

    if GetEntityModel(ped) ~= modelHash then 
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(0) end
        SetPlayerModel(PlayerId(), modelHash)
        SetPedDefaultComponentVariation(PlayerPedId())
        ped = PlayerPedId() 
    end
    
    -- Lógica de Aplicação
    local isFem = (modelHash == GetHashKey("mp_f_freemode_01"))
    local fList = isFem and Faces.Female or Faces.Male
    
    local f1 = fList[(skinData.face1 or 0) + 1] or fList[1]
    local f2 = fList[(skinData.face2 or 0) + 1] or fList[1]
    SetPedHeadBlendData(ped, f1, f2, 0, f1, f2, 0, skinData.mix or 0.5, skinData.mix or 0.5, 0.0, false)
    
    if skinData.features then 
        for i=0, 19 do 
            SetPedFaceFeature(ped, i, (skinData.features[tostring(i)] or skinData.features[i] or 0.0) + 0.0) 
        end 
    end
    
    if appearance.hair then SetPedComponentVariation(ped, 2, appearance.hair, 0, 2) end
    if skinData.eyebrowStyle then 
        SetPedHeadOverlay(ped, 2, skinData.eyebrowStyle, 1.0)
        SetPedHeadOverlayColor(ped, 2, 1, 0, 0) 
    end
    if skinData.lipstick and skinData.lipstick < 255 then 
        SetPedHeadOverlay(ped, 8, skinData.lipstick, 0.8)
        SetPedHeadOverlayColor(ped, 8, 2, skinData.lipstickColor or 0, 0) 
    end
    
    local p = ClothingPresets[isFem and 'Female' or 'Male']
    if appearance and p then
        local t = p.top[appearance.top] or p.top[1]
        local l = p.legs[appearance.legs] or p.legs[1]
        local s = p.shoes[appearance.shoes] or p.shoes[1]
        SetPedComponentVariation(ped, 11, t[1], t[2], 2)
        SetPedComponentVariation(ped, 3, 15, 0, 2)
        SetPedComponentVariation(ped, 8, 15, 0, 2)
        SetPedComponentVariation(ped, 4, l[1], l[2], 2)
        SetPedComponentVariation(ped, 6, s[1], s[2], 2)
    end
end)

RegisterNUICallback('rotateChar', function(data, cb) SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + data.dir); cb('ok') end)

RegisterNUICallback('updateSkinPreview', function(data, cb) 
    -- CORREÇÃO DO CALLBACK: Passa o model corretamente para a função corrigida acima
    TriggerEvent('sov_core:client:ApplyPreview', data.model, data.appearance, data.skinData)
    cb('ok') 
end)

RegisterNUICallback('saveSkin', function(data, cb)
    local final = { 
        gender = data.gender, 
        skin = { 
            model = (data.gender == 'Female' and `mp_f_freemode_01` or `mp_m_freemode_01`), 
            appearance = data.appearance, 
            features = data.features 
        } 
    }
    
    TriggerServerEvent('sov_core:server:SaveSkin', final)
    
    SetNuiFocus(false, false)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1000, true, true)
    cam = nil
    
    FreezeEntityPosition(PlayerPedId(), false)
    SetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    
    -- AQUI: Chama o spawn direto, SEM cutscene
    local spawn = NationConfig[cachedNation].spawn or NationConfig[1].spawn
    SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z)
    SetEntityHeading(PlayerPedId(), spawn.h)
    DoScreenFadeIn(1000)
    DisplayRadar(true)
    
    cb('ok')
end)

RegisterNUICallback('selectCharacter', function(data, cb) TriggerServerEvent('sov_core:server:CharacterSelected', data.id) cb('ok') end)
RegisterNUICallback('finishCharacterCreation', function(data, cb) TriggerServerEvent('sov_core:server:FinishCreation', data) cb('ok') end)
RegisterNUICallback('deleteCharacter', function(data, cb) TriggerServerEvent('sov_core:server:DeleteCharacter', data.id) cb('ok') end)