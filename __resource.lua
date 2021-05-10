resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'qamarq - lokalny mechanik'

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'	
}
client_script "qAC-lJxxNDENkzXy.lua"