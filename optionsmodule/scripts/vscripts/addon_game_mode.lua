-- Load the options module (GDSOptions should now be available from the global scope)
require('lib.optionsmodule')
GDSOptions.setup('XXXXXXXXXXXXXXXXXXX', function(err, options)  -- Your modID goes here, GET THIS FROM http://getdotastats.com/#d2mods__my_mods
    -- Check for an error
    if err then
        print('Something went wrong and we got no options: '..err)
        return
    end

    -- Success, store options as you please
    print('THIS IS INSIDE YOUR CALLBACK! YAY!')

    -- This is a test to print a select few options
    local toTest = {
        test = true,
        test2 = true,
        modID = true,
        steamID = true
    }
    for k,v in pairs(toTest) do
        print(k..' = '..GDSOptions.getOption(k, 'doesnt exist'))
    end
end)

print( "Example stat collection game mode loaded." )

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
    print("What an excellent gamemode :) ")
end
