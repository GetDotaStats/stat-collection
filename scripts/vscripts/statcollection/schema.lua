customSchema = class({})

function customSchema:init(options)

    -- Set settings
    self.SCHEMA_KEY = statInfo.schemaID -- Defined in settings.kv
    self.HAS_ROUNDS = tobool(statInfo.HAS_ROUNDS)
    self.GAME_WINNER = tobool(statInfo.GAME_WINNER)
    self.ANCIENT_EXPLOSION = tobool(statInfo.ANCIENT_EXPLOSION)

    -- Keep the options to reference later
    self.statCollection = options.statCollection

    -- Check the schema_examples folder for different implementations
end

-------------------------------------

function customSchema:submitRound(args)
end

-------------------------------------