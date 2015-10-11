GetDotaStats Stat-Collection
=====

###About###
 - The code and concept is very much a work in progress. Please refer to http://getdotastats.com/#s2__schema_matches for a protocol overview.
 - You can get in contact with us via Github issues, or via other methods http://getdotastats.com/#site__contact
 - This repo should contain all of the code required to get stats working. It should work out of the box, but will require modification if you want record additional stats.
 
###Credits###
 - Big thanks to SinZ163, mnoya, Ash47, BMD, and Tet for their contributions.

###Implementations###
 - Noya [PMP] - https://github.com/MNoya/PMP
 - Noya [Warchasers] - https://github.com/MNoya/Warchasers
 - Azarak [The Predator] - http://steamcommunity.com/sharedfiles/filedetails/?id=494708836

###Recent Games###
 - Reported on the site: http://getdotastats.com/#s2__recent_games
 - Reported in the IRC channel: https://kiwiirc.com/client/irc.gamesurge.net/?#getdotastats-announce

###Installation of Library###

Integrating the library into your scripts

1. Download the statcollection from github and merge the scripts folder into your game/YOUR_ADDON/ folder.
2. In your addon_game_mode.lua file, copy this line at the top: require('statcollection/init')
3. Go into the scripts/vscripts/statcollection folder and inside the `settings.kv` file, change the modID XXXXX value with the modID key from the site (when an admin has approved the mod). You can see the stats of your mod and the key here: http://getdotastats.com/#s2__my__mods
4. Test the game by playing through once. You can use the workshop tools, but don't panic when your playerName becomes ???? on the site (workshop tools don't send steamNames).
5. If the test is successful, you will have sent the default basic stats at the start and conclusion of the match. You can look for this game in the `Recent Games` section of the site. http://getdotastats.com/#s2__recent_games
6. You are encouraged to add your own gamemode-specific stats (such as particular game settings, player values such as end game items). More about this soon.

###Note###

We rely on GameRules:SetGameWinner(). Make sure to use this, instead of GameRules:MakeTeamLose()

If you'd like to store flags, for example, the amount of kills to win, it can be done like so:
 - statCollection:setFlags({FlagName = 'FlagValue'})