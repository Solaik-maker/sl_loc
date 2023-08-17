fx_version 'bodacious'
game 'gta5'
lua54 'yes'

author 'Solaik'

description 'Script de location de vhéicule'

version '1.0.0'

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config/config.lua',
    'config/keymapping.lua',
    'client/client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config/config.lua',
    'config/keymapping.lua',
    'server/server.lua'
}

dependencies {
	'es_extended'
}

shared_scripts { 
	'@ox_lib/init.lua',
	'@es_extended/imports.lua'
}