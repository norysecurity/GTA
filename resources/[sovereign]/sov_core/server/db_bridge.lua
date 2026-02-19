local RESOURCE = GetCurrentResourceName()

MySQL.ready(function()
    print('^2[SOVEREIGN CORE] ^7Banco de Dados Conectado com Sucesso via OxMySQL.')
end)

function ExecuteSQL(query, params)
    local p = promise.new()
    MySQL.query(query, params, function(result) p:resolve(result) end)
    return Citizen.Await(p)
end

function FetchOne(query, params)
    local p = promise.new()
    MySQL.single(query, params, function(result) p:resolve(result) end)
    return Citizen.Await(p)
end

function InsertSQL(query, params)
    local p = promise.new()
    MySQL.insert(query, params, function(id) p:resolve(id) end)
    return Citizen.Await(p)
end

exports('ExecuteSQL', ExecuteSQL)
exports('FetchOne', FetchOne)
exports('InsertSQL', InsertSQL)