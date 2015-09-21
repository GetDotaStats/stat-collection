--[[
Usage:

This is an example custom schema. You must assemble your game and players tables, which
are submitted to the library via a call like:

statCollection:sendCustom(schemaAuthKey, game, players)

The schemaAuthKey is important, and can only be obtained via site admins.

Come bug us in our IRC channel or get in contact via the site chatbox. http://getdotastats.com/#contact

]]
local customSchema = class({
    -- The schema version we are currently using
    SCHEMA_KEY = 'XXXXXXXXX', -- GET THIS FROM AN ADMIN ON THE SITE, THAT APPROVES YOUR SCHEMA
    -- Do we need to enable the round API or not.
    HAS_ROUNDS = false,
    -- Do we want statCollection to use team winner for game victory?
    GAME_WINNER = true,
    -- Do we want statCollection to use ancient explosions for game victory?
    ANCIENT_EXPLOSION = true
})
function customSchema:init(options)
    self.statCollection = options.statCollection
    -- Grab the current state
    local state = GameRules:State_Get()

    if state >= DOTA_GAMERULES_STATE_POST_GAME then

        -- Build game array
        local game = {}
        table.insert(game, {
            game_duration = GameRules:GetGameTime(),
            game_picks_num = tonumber(Options.getOption('lod', MAX_REGULAR, maxSkills))
        })


        -- Build players array
        local players = {}
        for i = 1, (PlayerResource:GetPlayerCount() or 1) do
            table.insert(players, {
                player_hero_id = PlayerResource:GetSelectedHeroID(i - 1),
                player_kills = PlayerResource:GetKills(i - 1),
                player_assists = PlayerResource:GetAssists(i - 1),
                player_deaths = PlayerResource:GetDeaths(i - 1)
            })
        end

        -- Send custom stats
        statCollection:sendCustom(game, players)
    end
end
function customSchema:submitRound(args)
end
return customSchema
