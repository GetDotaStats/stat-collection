customSchema = class({})

function customSchema:init()

    -- Check the schema_examples folder for different implementations

    -- Flag Example
    -- statCollection:setFlags({version = GetVersion()})

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()

        -- Send custom stats when the game ends
        if state == DOTA_GAMERULES_STATE_POST_GAME then

            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            -- Print the schema data to the console
            if statCollection.TESTING then
                PrintSchema(game,players)
            end

            -- Send custom stats
            if statCollection.HAS_SCHEMA then
                statCollection:sendCustom({game=game, players=players})
            end
        end
    end, nil)
end

-------------------------------------

function customSchema:submitRound(args)
    winners = BuildRoundWinnerArray()
    game = BuildGameArray()
    players = BuildPlayersArray()

    statCollection:sendCustom({game=game, players=players})

    return {winners = winners, lastRound = false}
end

-------------------------------------

function BuildRoundWinnerArray()
    local winners = {}
    local current_winner_team = GameRules.Winner or 0
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
            end
        end
    end
    return winners
end

-- Returns a table with our custom game tracking.
function BuildGameArray()
    local game = {}
    game.rs = GetRoshanKills() -- This is an example of a function that returns how many times roshan was killed
    return game
end

-- Returns a table containing data for every player in the game
function BuildPlayersArray()
    local players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then

                local hero = PlayerResource:GetSelectedHeroEntity(playerID)

                table.insert(players, {
                    --steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),

                    -- Example functions of generic stats (keep, delete or change any that you don't need)
                    ph = GetHeroName(playerID), --Hero by its short name
                    pk = hero:GetKills(),   --Number of kills of this players hero
                    pd = hero:GetDeaths(),  --Number of deaths of this players hero
                    nt = GetNetworth(hero), --Sum of hero gold and item worth

                    -- Item List
                    il = GetItemList(hero),
                })
            end
        end
    end

    return players
end

-------------------------------------
--          Stat Functions         --
-------------------------------------

function PrintSchema( gameArray, playerArray )
    print("-------- GAME DATA --------")
    DeepPrintTable(gameArray)
    print("\n-------- PLAYER DATA --------")
    DeepPrintTable(playerArray)
    print("-------------------------------------")
end

function GetRoshanKills()
    local total_rosh_kills = 0
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local roshan_kills_player =  PlayerResource:GetRoshanKills(playerID)
            total_rosh_kills = total_rosh_kills + roshan_kills_player
        end
    end
end

function GetHeroName( playerID )
    local heroName = GetSelectedHeroName( playerID )
    heroName = string.gsub(heroName,"npc_dota_hero_","") --Cuts the npc_dota_hero_ prefix
    return heroName
end

function GetNetworth( hero )
    local gold = hero:GetGold()

    -- Iterate over item slots adding up its gold cost
    for i=0,15 do
        local item = hero:GetItemInSlot(i)
        if item then
            gold = gold + item:GetCost()
        end
    end
end

function GetItemList(hero)
    local itemTable = {}

    for i=0,5 do
        local item = hero:GetItemInSlot(i)
        if item then
            local itemName = string.gsub(item:GetAbilityName(),"item_","")
            table.insert(itemTable,itemName)
        end
    end

    table.sort(itemTable)
    local itemList = table.concat(itemTable, "_")

    return itemList
end

if Convars:GetBool('developer') then
    Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(),BuildPlayersArray()) end, "Test the custom schema arrays", 0)
end