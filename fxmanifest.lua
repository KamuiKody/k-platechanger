lua54 'yes'
fx_version 'cerulean'
game 'gta5'

name 'K-Platechanger'
description 'A resource for customizing vehicle plate text!'
author 'KamuiKody'
contact 'https://discord.gg/3j9b439TeY'

shared_script 'config.lua'

client_script 'client.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server.lua'
}


escrow_ignore {
    'client.lua',
    'server.lua',
    "config.lua"
}