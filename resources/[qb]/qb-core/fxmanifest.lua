fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'QBCore Framework (Freeroam)'
description 'QBCore Framework - Lightweight Freeroam Edition'
version '1.3.0'

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'locales/en.lua',
    'shared/main.lua',
    'shared/player.lua',
    'shared/vehicles.lua',
    'shared/items.lua',
    'shared/jobs.lua',
    'shared/gangs.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/events.lua',
    'client/loops.lua',
    'client/drawtext.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/player.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/exports.lua'
}

exports {
    'GetCoreObject',
    'GetFunctions',
    'GetPlayerData'
}
