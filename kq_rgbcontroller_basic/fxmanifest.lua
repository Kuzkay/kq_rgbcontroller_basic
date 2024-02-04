fx_version 'cerulean'
games      { 'gta5' }

author 'KuzQuality | Kuzkay'
description 'RGB Controller made by KuzQuality'
version '1.0.1'


ui_page 'html/index.html'

--
-- Files
--

files {
    'html/js/jquery.js',
    'html/farbtastic/farbtastic.js',
    'html/farbtastic/farbtastic.css',
    'html/fonts/bebasneue.ttf',
    'html/farbtastic/*.png',
    'html/index.html',
}


--
-- Server
--

server_scripts {
    'shared/config.lua',
    'server/server.lua',
}

--
-- Client
--

client_scripts {
    'shared/config.lua',
    'client/client.lua',
}
