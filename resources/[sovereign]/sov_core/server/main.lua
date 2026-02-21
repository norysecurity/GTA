local RESOURCE = GetCurrentResourceName()

-- ==============================================================================
-- FUNÇÕES AUXILIARES (GERAÇÃO DE IDENTIDADE)
-- ==============================================================================
local function GeneratePhone()
    return "555-" .. math.random(1000, 9999)
end

local function GenerateSerial()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local s = ""
    for i = 1, 3 do
        local rand = math.random(#letters)
        s = s .. string.sub(letters, rand, rand)
    end
    s = s .. math.random(1000, 9999)
    return s
end

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

    -- Cria ou Atualiza conta (USANDO OXMYSQL DIRETO PARA NÃO TRAVAR)
    exports.oxmysql:execute('INSERT INTO sov_accounts (steam, license, last_login) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE steam = COALESCE(?, steam), last_login = NOW()', { steam, license, steam }, function()
        
        -- Verifica Banimento e Whitelist após criar/atualizar
        local account = exports.oxmysql:singleSync('SELECT id, whitelisted, banned FROM sov_accounts WHERE license = ?', { license })

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
            deferrals.done("❌ ERRO CRÍTICO: Falha ao comunicar com o Banco de Dados.")
        end
    end)
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

    local acc = exports.oxmysql:singleSync('SELECT id FROM sov_accounts WHERE license = ?', { license })
    if acc then
        local chars = exports.oxmysql:executeSync('SELECT * FROM sov_characters WHERE account_id = ? AND deleted = 0', { acc.id })
        TriggerClientEvent('sov_core:client:SetupUI', src, chars)
    else
        print("^1[ERRO] Conta não encontrada para a licença: "..tostring(license).."^0")
    end
end)

-- Deletar Personagem (Soft Delete)
RegisterNetEvent('sov_core:server:DeleteCharacter')
AddEventHandler('sov_core:server:DeleteCharacter', function(charId)
    local src = source
    print("^1[SOVEREIGN]^7 Deletando Cidadão ID: " .. charId)
    exports.oxmysql:execute('UPDATE sov_characters SET deleted = 1 WHERE id = ?', { charId })
    Wait(500)
    TriggerEvent('sov_core:server:RequestChars', src)
end)

-- Criar Registro Básico (Nome/Nacionalidade/Dados Civis)
RegisterNetEvent('sov_core:server:FinishCreation')
AddEventHandler('sov_core:server:FinishCreation', function(data)
    local src = source
    print("^3[DEBUG] Iniciando criação de personagem para Source: "..src.."^0")

    local license = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "license:" then license = v end
    end

    local acc = exports.oxmysql:singleSync('SELECT id FROM sov_accounts WHERE license = ?', { license })
    
    if acc and data.nation then
        -- Evita duplicidade
        local check = exports.oxmysql:singleSync('SELECT id FROM sov_characters WHERE account_id = ? AND name = ? AND surname = ? AND deleted = 0', { acc.id, data.firstname, data.lastname })
        
        if check then
            print("^1[SOVEREIGN]^7 ERRO: Nome duplicado ("..data.firstname.." "..data.lastname..")")
            TriggerEvent('sov_core:server:RequestChars', src)
            return
        end

        -- GERAÇÃO DE DADOS
        local phone = GeneratePhone()
        local serial = GenerateSerial()
        local blood = "A+" 
        -- Pega a idade do NUI ou define 20
        local age = data.age or 20 

        -- QUERY DE INSERÇÃO DIRETA
        -- Atenção: Se travar aqui, é porque você não rodou o código SQL que te mandei antes para criar as colunas 'phone', 'serial', etc.
        exports.oxmysql:insert('INSERT INTO sov_characters (account_id, name, surname, nation_id, bank, birthdate, phone, serial, blood, age) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        { acc.id, data.firstname, data.lastname, data.nation, 5000, data.birthdate, phone, serial, blood, age }, function(charId)
            
            if charId then
                print("^2[SUCESSO] Personagem criado! ID: "..charId.." - RG: "..serial.."^0")
                -- Manda abrir o Skin Creator para este novo char
                TriggerEvent('sov_core:server:CharacterSelected', charId, src)
            else
                print("^1[ERRO CRÍTICO SQL] O banco de dados recusou a criação! Verifique se as colunas 'phone', 'serial', 'age' existem na tabela sov_characters.^0")
            end
        end)
    else
        print("^1[ERRO] Dados inválidos recebidos do cliente.^0")
    end
end)

-- Selecionar Personagem e Spawnar
RegisterNetEvent('sov_core:server:CharacterSelected')
AddEventHandler('sov_core:server:CharacterSelected', function(charId, specificSource)
    local src = specificSource or source
    local charData = exports.oxmysql:singleSync('SELECT * FROM sov_characters WHERE id = ?', { charId })
    if charData then
        TriggerClientEvent('sov_core:client:SpawnPlayer', src, charData)
    else
        print("^1[ERRO] Falha ao recuperar dados do personagem ID: "..tostring(charId).."^0")
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
    
    local acc = exports.oxmysql:singleSync('SELECT id FROM sov_accounts WHERE license = ?', { license })
    
    if acc then
        local success, skinJson = pcall(json.encode, data.skin)
        
        if success and skinJson then
            exports.oxmysql:execute([[
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
            exports.oxmysql:execute('UPDATE sov_accounts SET whitelisted = 1 WHERE id = ?', { targetId })
            print("^2[ADMIN]^7 ID " .. targetId .. " aprovado na whitelist.")
        end
    end
end)