-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------
fx_version 'cerulean'

game 'gta5'

description "ESX Skill Based Fishing"

author 'wasabirobby#5110'
lua54 'yes'
version '1.1.2'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/main.js'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}
server_scripts {
	'server/**.lua'
}

client_scripts {
	'client/**.lua'
}

