GetDotaStats Stat-Collection
=====
## Integrating Stat Collection

### Quick Start
There are three stages of integration. For a fast integration, please follow these instructions in the correct order.

### Stage 1 - Before you begin

1. Grab a copy of the library via our public repo [GetDotaStats/stat-collection](https://github.com/GetDotaStats/stat-collection).
2. Login to [http://getdotastats.com](http://getdotastats.com/), by clicking the big green button at the top of this page.
3. Register your mod on the site by navigating to `Custom Games -> Mods (My Section) -> Add a new mod`, or by going straight to the [registration form](http://getdotastats.com/#s2__my__mod_request).
4. Go back to your list of mods by navigating to `Custom Games -> Mods (My Section)`, or by going straight to the [My Mods](http://getdotastats.com/#s2__my__mods) page. You should now see a new entry there, that matches the mod your just registered.
5. Take note of your *modID* key of 32characters. If you lose this string, refer back to this page.
6. Make sure not to share this key, as it is unique to your mod and is used when recording stats!<br>If you use Github, add a `.gitignore` file to the root of your project. Adding **`settings.kv`** to it will prevent from accidentally leaking your *modID*.
7. An Admin will review your mod registration and approve it if it meets the submission guidelines outlined on the registration page and has a few completed games recorded. While your mod is reviewed, you can continue following this guide.

### Stage 2 - Basic Integration

Now that you have the library and have completed the sign-up process, we can start the actual integration.

1. Merge the files downloaded in (Stage 1 - Step 1). If done successfully, you will see a statcollection folder in your **`game/YOUR_ADDON/scripts/vscripts`** folder. Pay attention to the included panorama files. They should be merged into content/YOUR_ADDON/panorama folder.
2. In your **`addon_game_mode.lua`** file, add a require statement at the top of your code that points at our library initialiser file. **`require("statcollection/init")`**
3. Go into the **`scripts/vscripts/`** folder and inside the settings.kv file, change the modID XXXXXXX value to the modID key you noted above (Stage 1 - Step 4). If your mod requires rounds, skip to Stage 2.5 in these instructions. If you can possibly help it, we advise modders to avoid using rounds.
4. Check your game logic to ensure you set player win conditions nicely. This library hooks the SetGameWinner() function, so make sure to convert all of your MakeTeamLose() calls into SetGameWinner() calls. Also make sure to check every win and lose condition, as this library will only send stats at POST_GAME after a winner has been declared.
5. Test your custom game (via workshop tools is fine), and see if stats were recorded. You can find games recently recorded against your steamID by navigating to `Custom Games -> Public Profile (My Section)`, or by going straight to your Public Profile.
6. You have completed the basic integration successfully if the games recorded under your mod on the [RECENT GAMES](http://getdotastats.com/#s2__recent_games) page (or in your public profile) have a green phase value. If you don't see any recorded games, or they are not reaching the green phase, refer to the troubleshooting section below. 
7. Update your settings.kv by setting TESTING to false, and the "MIN_PLAYERS" to the minimum number of players you believe are required to have an interesting (playable) game. Only set TESTING to true, when troubleshooting stats in your workshop tools.

### Stage 2.5 - Basic Integration for Round Based Games

Skip this section if your game is not round based. Implementing round based stats is not for the faint of heart. You will need the ability to think critically, and hopefully understand how the logic in your game works.

1. Your mod should already have our library files merged from Stage 2 - Step 1. If not, go back and do that now.
2. Go into the **`scripts/vscripts/statcollection`** folder and inside the settings.kv file. Set HAS_ROUNDS to true and both of the win conditions (GAME_WINNER and ANCIENT_EXPLOSION) to false.
3. In your game logic, call statCollection:submitRound(false) at the end of every round. At the end of the final round, call statCollection:submitRound(true). Make sure to update line 108 in the schema.lua (for local current_winner_team), as we have no generic way of determining who won your arbitrary round.
4. Double check your game logic to ensure you properly indicate which teams won each round, and that it is recorded in line 108 of **`schema.lua`**
5. Test your custom game (via workshop tools is fine), and see if stats were recorded. You will need to play your game all the way through (up to your win or lose condition), unless you created a way to skip to the end of the game. You can find games recently recorded against your steamID by navigating to `Custom Games -> Public Profile (My Section)`, or by going straight to your Public Profile.
6. You have completed the basic integration (for rounds) successfully if the games recorded under your mod on the [RECENT GAMES](http://getdotastats.com/#s2__recent_games) page (or in your public profile) have a green phase value. If you don't see any recorded games, or they are not reaching the green phase, refer to the troubleshooting section below.
7. Update your **`settings.kv`** by setting TESTING to false, and the "MIN_PLAYERS" to the minimum number of players you believe are required to have an interesting (playable) game. For most games, this will be a value of 2 or 4. Only set TESTING to true, when troubleshooting stats in your workshop tools, as this setting overrides MIN_PLAYERS to 0 and prints your schema stats (Stage 3) to console.

### Stage 3 - Advanced Integration **OPTIONAL**

* Now that you have basic stats, you are encouraged to create game-specific stats. Having a schema is the best way to acquire relevant stats about your custom game, such as pick and winrates of different heroes, keeping track of special game events, many other things that you might find appropriate to register and track. This information can help you decide what changes or additions to make.
* Keep in mind that all stats that you send need to form a snapshot of the end game results. Time Series data that attempts to match player actions to timings (like an array of item purchase times) do not belong in this library (we plan to release a solution for this soon). Data that you send us must not be too unique either (like an item build order that is slot sensitive). The data must be aggregatable given a large enough sample. The last thing to keep in mind is that values can not be longer than 100characters. We are working towards improving this in the near future.
* Making a custom schema requires that you build your own custom array of stats and write your own Lua functions to put data into them. In the `scripts/vscripts/statcollection/schema_examples` folder we provide examples of how various mods implemented their tracking.
* If your game uses a Round system (where progress is reset between rounds) and you would like to treat each round as a separate match, the library can handle it! You will need to get in contact with us for implementation concerns, but you would need to manually invoke the stat sending function and update your settings.kv to enable rounds.
* Sending custom data is done inside `schema.lua`. The data to send is split into 3 parts: **Flags**, **Game**, and **Players**.

#### Flags
* The Flags array contains general information about the game, determined before the PRE_GAME phase.
* Flags are recorded by calling the `setFlags()` function any where you can access the library class from.
* The recommended place to set flags is near the top of your schema file in the init() function.
* You can set the same flag multiple times. If the flag is already defined, it will be overwritten.
* You can set a flag at any point of time, up until PRE_GAME.
* A code example of setting a flag: `statCollection:setFlags({version = '4.20'})`
* Some examples of potential values are:
  * Mod version (manually incremented by the mod developer)
  * Map name (tracked by default)
  * Victory condition (e.g. 50kills, 10mins, etc.)
  * Lobby options
  * Hero selection options

#### Game
* The Game array should contain general info about the game session, determined after the PRE_GAME phase.
* Refer to the default or example schemas (inside the [schema_examples folder](https://github.com/GetDotaStats/stat-collection/tree/master/scripts/vscripts/statcollection/schema_examples)) for implementation, specifically the lines in the BuildGameArray().
* Some examples of potential values are:
  * The number of Roshan kills
  * The number of remaining towers for Team #1
  * Any settings decided after the pre-game phase

#### Players
* The Players array should contain information specific to each player.
* Refer to the default or example schemas (inside the [schema_examples folder](https://github.com/GetDotaStats/stat-collection/tree/master/scripts/vscripts/statcollection/schema_examples)) for implementation, specifically the lines in the BuildPlayersArray().
* Some examples of potential values are:
  * Hero name (you could use custom names)
  * Kills
  * Level
  * Item list (a comma delimited string of the item held at the end of the game)
  * Ability name
  * Ability level
  * Wood farmed
  * Buildings created
  * Trees planted

#### Schema Implementation steps
1. Create your schema after reading the above.
2 Ensure that your `settings.kv` has **"TESTING"** set to true.
3. Clear your console log and play a single match of your custom game.
4. Save the console log to a pastebin, hastebin, or other text hosting service.
5. Create a new issue in [our issue tracker](https://github.com/GetDotaStats/stat-collection/issues), with the following in it:
  * Issue Title: [SCHEMA] Mod name
  * Issue Body:
    * Link to your console log
    * Link to your `settings.kv` (censor the modID)
    * Link to your `schema.lua`
    * Link to your `addon_game_mode.lua` and any other Lua file that defines the functions you pull stats from
6. When an admin has accepted or looked at your schema, they will post back to that issue. There will likely be multiple iterations of your schema, as the admin will likely have suggestions for improvement.
7. When your schema is accepted, go back to your mod list by navigating to `Custom Games -> Mods (My Section)`, or by going straight to the My Mods page. Note your new *schemaID*, and update your `settings.kv` accordingly.

## Troubleshooting FAQ

**It's not working!**
* Look in your console log, and do a search for lines starting with "Stat Collection:"
**My Mod Stats (Stage 2) stopped working!**
* Have a look in your console log for an error.
* Check that your modID matches the one in your Mod page.
**My Schema Stats (Stage 3) stopped working!**
* Have a look in your console log for an error.
* Check that your schemaID matches the one in your Mod page.
**My custom game never reaches Phase 3!**
* Have a look in your console log for an error.
* Check your win conditions. We hook SetGameWinner(), so make sure you don't use MakeTeamLose().
**I am in despair! Help me!**
* Contact us via one of our numerous channels of contact. You can find the official list on [our site](http://getdotastats.com/#site__contact)

### Implementations
 - Noya [PMP] - https://github.com/MNoya/PMP
 - Noya [Warchasers] - https://github.com/MNoya/Warchasers

### Recent Games
 - Reported on the site: http://getdotastats.com/#s2__recent_games
 - Reported in the IRC channel: https://kiwiirc.com/client/irc.gamesurge.net/?#getdotastats-announce
 
### Credits
 - Big thanks to [SinZ163](https://github.com/SinZ163), [Noya](https://github.com/MNoya/), [Ash47](https://github.com/Ash47), [BMD](https://github.com/bmddota), and [Tet](https://github.com/tetl) for their contributions.is

### Contact
 - You can get in contact with us via Github issues, or via other methods http://getdotastats.com/#site__contact
 - This repo should contain all of the code required to get stats working. It should work out of the box, but will require modification if you want record additional stats.

