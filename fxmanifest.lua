fx_version 'cerulean'
game 'gta5'

author "Lazzy Spring"
description "Lazzy SpawnSelector"
version '1.0.0'

shared_script { 'config.lua', '@ox_lib/init.lua' }

client_scripts {
	'client/main.lua',
	'client/open_client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/open_server.lua'
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
}

escrow_ignore {
	'config.lua'
  }

use_fxv2_oal 'yes'
lua54 'yes'