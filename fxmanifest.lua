fx_version 'cerulean'
game 'gta5'

author 'HabitualDeep (Armaan)'
description 'Armaan ka blip creator for daddy KRP'
version '1.0.0'

-- Specify the resource scripts
client_scripts {
    'client/main.js',
}

server_script 'server/main.lua'

-- Specify any dependencies
dependencies {
    'mysql-async',
    'es_extended' -- Adjust this based on your ESX version
}

