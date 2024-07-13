-- fxmanifest.lua

fx_version 'bodacious'
game 'gta5'

author 'Grupo Multiverso'
description 'Car spawning menu'
version '1.0.0'

shared_script {
    '@es_extended/imports.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua'
}
