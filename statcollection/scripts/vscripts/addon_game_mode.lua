-- Load Stat collection (statcollection should be available from any script scope)
require('lib.statcollection')
statcollection.addStats({
	modID = 'XXXXXXXXXXXXXXXXXXX' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})

print( "Example stat collection game mode loaded." )

-- Note: Stats will be sent automatically sent to the server when the game ends
-- plesae see the top of lib/statcollection.lua for more details on how to override this behavior

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
    print("What an excellent gamemode :) ")
end
