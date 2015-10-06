customSchema = class({})

function customSchema:init(options)

    -- Set settings
    self.SCHEMA_KEY = statInfo.schemaID
    self.HAS_ROUNDS = tobool(statInfo.HAS_ROUNDS)
    self.GAME_WINNER = tobool(statInfo.GAME_WINNER)
    self.ANCIENT_EXPLOSION = tobool(statInfo.GAME_WINNER)

    -- Keep the options to reference later
    self.statCollection = options.statCollection

end

-------------------------------------

function customSchema:submitRound(args)
end

-------------------------------------