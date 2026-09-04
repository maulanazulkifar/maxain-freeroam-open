fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'QBCore (Freeroam)'
description 'QBCore Vehicle Spawner for Freeroam'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
