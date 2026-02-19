fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Sovereign Core: Authentication & Multicharacter'
version '1.1.0'

ui_page 'web/index.html' -- Define a página principal

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/*.ttf' -- Se for usar fontes locais
}

shared_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua'
}

server_scripts {
    'server/db_bridge.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'oxmysql'
}