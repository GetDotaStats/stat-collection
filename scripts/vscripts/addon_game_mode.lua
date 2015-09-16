-- Load Stat collection module (Just require it again if you dont want to parse the reference around)
local statCollection = require('lib.statcollection')

-- Are we testing / building the mod?
-- TODO: Make this check addon_id when that exists
local Testing = false

-- Check if we are testing / building the mod
if not Testing then
    -- We are not testing, do the actual stat collection

    -- Init stat collection
    statCollection:init({
        modIdentifier = 'XXXXXXXXXXXXXXXXXXX', -- GET THIS FROM http://getdotastats.com/#d2mods__my_mods
        customSchema = 'example' --This will make StatsCollection load statcollection/example.lua as the custom schema
    })
end

print( "Example stat collection game mode loaded." )

-- Note: Stats will be sent automatically sent to the server when the game ends
-- please see the top of lib/statcollection.lua for more details on how to override this behavior

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
    print("What an excellent gamemode :) ")
end
