local RESOURCE = GetCurrentResourceName()

-- ==============================================================================
-- AUTENTICAÇÃO E CONEXÃO
-- ==============================================================================
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local steam, license = nil, nil
    
    deferrals.defer()
    Wait(50)
    deferrals.update("🔄 [SOVEREIGN] Verificando credenciais...")

    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 6) == "steam:" then steam = v end
        if string.sub(v, 1, 8) == "license:" then license = v end
    end

    if not license then
        deferrals.done("❌ ERRO: Licença Rockstar não encontrada.")
        return
    end

    -- Cria ou Atualiza conta
    local query_insert = [[
        INSERT INTO sov_accounts (steam, license, last_login) 
        VALUES (?, ?, NOW()) 
        ON DUPLICATE KEY UPDATE steam = COALESCE(?, steam), last_login = NOW()
    ]]
    exports['sov_core']:ExecuteSQL(query_insert, { steam, license, steam })

    -- Verifica Banimento e Whitelist
    local account = exports['sov_core']:FetchOne('SELECT id, whitelisted, banned FROM sov_accounts WHERE license = ?', { license })

    if account then
        if tonumber(account.banned) == 1 then
            deferrals.done("❌ ACESSO NEGADO: Você foi deportado permanentemente.")
            return
        end

        if Config.Whitelist and Config.Whitelist.enabled then
            if tonumber(account.whitelisted) == 0 then
                deferrals.done("❌ VISTO NEGADO: Solicite aprovação no Discord.")
                return
            end
        end

        deferrals.update("✅ Identidade confirmada. Bem-vindo.")
        Wait(800)
        deferrals.done()
    else
        deferrals.done("❌ ERRO: Falha ao comunicar com o Banco de Dados.")
    end
end)

-- ==============================================================================
-- GESTÃO DE PERSONAGENS
-- ==============================================================================

-- Envia lista de personagens para o cliente
RegisterNetEvent('sov_core:server:RequestChars')
AddEventHandler('sov_core:server:RequestChars', function(specificSource)
    local src = specificSource or source
    local license = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "license:" then license = v end
    end

    local acc = exports['sov_core']:FetchOne('SELECT id FROM sov_accounts WHERE license = ?', { license })
    if acc then
        local chars = exports['sov_core']:ExecuteSQL('SELECT * FROM sov_characters WHERE account_id = ?', { acc.id })
        TriggerClientEvent('sov_core:client:SetupUI', src, chars)
    end
end)

-- Deletar Personagem (Permanente)
RegisterNetEvent('sov_core:server:DeleteCharacter')
AddEventHandler('sov_core:server:DeleteCharacter', function(charId)
    local src = source
    print("^1[SOVEREIGN]^7 Deletando Cidadão ID: " .. charId)
    exports['sov_core']:ExecuteSQL('DELETE FROM sov_characters WHERE id = ?', { charId })
    Wait(500)
    TriggerEvent('sov_core:server:RequestChars', src)
end)

-- Criar Registro Básico (Nome/Nacionalidade)
RegisterNetEvent('sov_core:server:FinishCreation')
AddEventHandler('sov_core:server:FinishCreation', function(data)
    local src = source
    local license = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "license:" then license = v end
    end

    local acc = exports['sov_core']:FetchOne('SELECT id FROM sov_accounts WHERE license = ?', { license })
    if acc and data.nation then
        -- Evita duplicidade de nome na mesma conta
        local check = exports['sov_core']:FetchOne('SELECT id FROM sov_characters WHERE account_id = ? AND name = ? AND surname = ?', { acc.id, data.firstname, data.lastname })
        
        if check then
            print("^1[SOVEREIGN]^7 ERRO: Nome duplicado ("..data.firstname.." "..data.lastname..")")
            TriggerEvent('sov_core:server:RequestChars', src)
            return
        end

        local query = "INSERT INTO sov_characters (account_id, name, surname, nation_id, bank, birthdate) VALUES (?, ?, ?, ?, ?, ?)"
        local charId = exports['sov_core']:InsertSQL(query, { acc.id, data.firstname, data.lastname, data.nation, 5000, data.birthdate })
        
        if charId then
            -- Manda abrir o Skin Creator para este novo char
            TriggerEvent('sov_core:server:CharacterSelected', charId, src)
        end
    end
end)

-- Selecionar Personagem e Spawnar
RegisterNetEvent('sov_core:server:CharacterSelected')
AddEventHandler('sov_core:server:CharacterSelected', function(charId, specificSource)
    local src = specificSource or source
    local charData = exports['sov_core']:FetchOne('SELECT * FROM sov_characters WHERE id = ?', { charId })
    if charData then
        TriggerClientEvent('sov_core:client:SpawnPlayer', src, charData)
    end
end)

-- ==============================================================================
-- SISTEMA DE APARÊNCIA (V4.0 - JSON BLINDADO)
-- ==============================================================================

RegisterNetEvent('sov_core:server:SaveSkin')
AddEventHandler('sov_core:server:SaveSkin', function(data)
    local src = source
    local license = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do if string.sub(v, 1, 8) == "license:" then license = v end end
    
    local acc = exports['sov_core']:FetchOne('SELECT id FROM sov_accounts WHERE license = ?', { license })
    
    if acc then
        -- Garante que o JSON seja válido
        local success, skinJson = pcall(json.encode, data.skin)
        
        if success and skinJson then
            -- Atualiza o personagem recém criado (que ainda tem skin NULL)
            exports['sov_core']:ExecuteSQL([[
                UPDATE sov_characters 
                SET gender = ?, skin = ? 
                WHERE account_id = ? AND skin IS NULL 
                ORDER BY id DESC LIMIT 1
            ]], { data.gender, skinJson, acc.id })
            
            print("^2[SOVEREIGN]^7 Biometria salva com sucesso para a conta ID: " .. acc.id)
        else
            print("^1[SOVEREIGN]^7 ERRO CRÍTICO: Falha ao codificar JSON da skin.")
        end
    end
end)

-- ==============================================================================
-- COMANDOS ADMIN
-- ==============================================================================
RegisterCommand('whitelist', function(source, args)
    if source == 0 or IsPlayerAceAllowed(source, "group.admin") then
        local targetId = args[1]
        if targetId then
            exports['sov_core']:ExecuteSQL('UPDATE sov_accounts SET whitelisted = 1 WHERE id = ?', { targetId })
            print("^2[ADMIN]^7 ID " .. targetId .. " aprovado na whitelist.")
        end
    end
end)