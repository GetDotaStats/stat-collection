print("Game mode started to load...")

-- Called when LoD starts
function main:InitGameMode()
    print('Main started!')
    GameRules:GetGameModeEntity():SetThink('OnThink', self, 'GlobalThink', 0.25)
end

-- Run to handle
function main:OnThink()
    -- Decide what to do
    if currentStage == STAGE_WAITING then
		-- STUFF
    end

    if currentStage == STAGE_VOTING then
		-- STUFF
    end

    if currentStage == STAGE_BANNING then
		-- STUFF
    end

    if currentStage == STAGE_PICKING then
		-- STUFF
    end

    if currentStage == STAGE_PLAYING then
        if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
            -- Send stats
            statcollection.sendStats()

            -- Finally done!
            return
        else
            -- Sleep again
            return 1
        end
    end

    -- We should never get here
    print('WARNING: Unknown stage: '+currentStage)
end

print('Game mode has loaded!')
