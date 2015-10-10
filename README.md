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
3. Go into the scripts/vscripts/statcollection folder and inside the `settings.kv` file, change the modID XXXXX value with the modID key that was handed to you by an admin.
4. After this, you will be sending the default basic stats when a lobby is succesfully created, and after the match ends.
   You are encouraged to add your own gamemode-specific stats (such as a particular game setting or items being purchased). More about this soon.

If you'd like to store flags, for example, the amount of kills to win, it can be done like so:
 - statCollection:setFlags({FlagName = 'FlagValue'})