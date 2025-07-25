


fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Stanley Development Studios'
version '1.0.3'


shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_main.lua',
}

files {
	'data/vehicles.meta',
	'data/carvariations.meta',
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

dependencies {
    'core',
}
