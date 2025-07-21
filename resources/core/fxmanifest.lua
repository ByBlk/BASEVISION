shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'cerulean'

game 'gta5'
lua54 'yes'

ui_page "interface/build/index.html"

escrow_ignore {
    "config.lua",
    "config_server.lua",
}

files {
    "interface/build/index.html",
    "interface/build/**/*",
    'modules/dui/index.html',
    'modules/dui/script.js',
    'modules/dui/style.css',
}

shared_scripts {
    "config.lua",
    "modules/**/sh_*.lua",
    "modules/**/submodules/sh_*.lua",
    "plugins/**/shared/**/**",
}

server_scripts {
    "items.lua",
    "config_server.lua",
    '@oxmysql/lib/MySQL.lua',
    "endernative/server/*.lua",
    "modules/**/sv_*",
    "modules/**/submodules/sv_*",
    "plugins/**/server/**/**"
}

client_scripts {
    "endernative/client/*.lua",
    "modules/**/cl_*",
    "modules/**/submodules/cl_*",
    "plugins/**/client/**/**"
}

dependencies {'/native:0x6AE51D4B', '/native:0xA61C8FC6'}
dependency '/assetpacks'