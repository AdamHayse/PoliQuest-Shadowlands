**About**

PoliQuest is a Shadowlands questing addon that makes questing less cumbersome by reducing mouse button clicks and  
other quest-related actions.

**Commands**

Type "**/pq**" or "**/poliquest**" to open the configuration menu.

Type "**/pq toggle**" or "**/poliquest toggle**" to show/hide the PQButton and reposition it.

**Feature Summaries**

* PQButton that automatically binds quest items to it
* Skip all skippable cutscenes
* Enhanced quest progress tracking
* Automated quest reward selection that can be enhanced if Pawn is installed
* Automatically accept and complete quests
* Automatically select correct quest dialog (English only)(Shadowlands only)
* Automatically equip quest reward upgrades
* Automation for quests that require you to type emotes (Shadowlands only)
* Automatically track quests
* Automatically share zone dailies
* Automatically set hearthstone at whitelisted innkeepers (not configurable yet)
* Automatically retrieve Radinax Gems from mailboxes

**Feature Overview**

<details><summary>General Features</summary><blockquote>

<details><summary>Quest Item Button</summary>

The PQButton is a button that appears when you have a Shadowlands quest item in your bags. The addon automatically  
binds quest items to this button and allows you to effortlessly use quest items by giving you the option to keybind it.

The following macro keybinds the PQButton as well as the arrow button that allows you to cycle through the quest items  
in your bags. Using the macro while not holding ctrl, alt, or shift will use the quest item, and using the macro while  
holding alt will cycle through the quest items in your bags.  

`/click [nomod]PQButton;[mod:alt]PQNext`  

The PQButton only updates outside of combat. If you gain or lose a quest item while in combat, then the button will  
update once out of combat. Likewise, the quest item bound to the PQButton can only be changed while out of combat.  

The PQButton can be repositioned. It currently cannot be resized.

The PQButton currently only works for level 50-59 Shadowlands quests. I am planning to make it work for all usable quest  
items eventually. Currently, this button only shows quest items that are in the addon's whitelist. This whitelist was created  
and is currently maintained by scraping data from wowhead with a separate program that I wrote, and then formatting it  
so that it is usable by the addon.
</details>

<details><summary>Skip Cutscenes</summary>

This feature simply attempts to skip cutscenes. If the cutscene can't be skipped, then nothing will happen and the  
cutscene will continue to play.
</details>

<details><summary>Quest Progress Tracking</summary>

This feature enhances the existing quest progress tracking that the game provides by default (the yellow text in the  
upper center of the screen) by showing the percent completion for quests and world quests that have a progress bar.
    
Some progress tracking will be excluded.  For example, mythic plus dungeon progress and quests that track progress in  
the form of an Alternative Power bar are not tracked by this feature.
</details></blockquote>
</details>

<details><summary>Automation Features</summary><blockquote>

<details><summary>Quest Reward Selection Automation</summary>

This feature automates the quest reward selection process. It attempts to find upgrades for your current loot  
specialization (or current specialization if you don't have a loot specialization specified).

Automation will not happen if one of the quest rewards is not an equippable item or if the item's item level is above the  
item level threshold specified on the configuration menu. The default item level threshold is 171.

After that initial check, the number of items for your current loot specialization/current specialization is counted. If there  
is only one item, then the automation ends right there and that item is selected. If there are multiple, then the checks  
continue.

At this point, automation is aborted if any of the following are true:
* item is missing from equip slot
* a quest reward has a socket
* a quest reward is a trinket
* a quest reward is a weapon
* a quest reward is a shirt
* a quest reward is a tabard

In general, trinkets and weapons will not be automated due to difficulties in determining whether or not they are  
upgrades. However, there is an exception when the weapon or trinket is the only quest reward among many for the  
current loot specialization/current specialization.

Once all of the above conditions have been met, the selection logic executes. The reward selection automation can use  
one of two different selection algorithms: Dumb and Pawn.

The Dumb selection logic calculates scores for all loot specialization/current specialization quest rewards and the items in  
the equip slots that these quest rewards would equip over. Then, it finds the greatest difference in score between the  
quest reward and the item in the corresponding equip slot, and selects that item as the quest reward.

The score is calculated by giving primary stats a value of 2 and seconary stats a value of 1. For example, if a piece of gear  
has 7 primary stat, 8 crit, and 7 mastery, then it will have a score of 2 * 7 + 8 + 7 = 29.  There is no value placed on  
stamina unless the items being compared do not have primary or secondary stats.  There is also no value placed on  
armor unless the items being compared do not have primary stats, secondary stats, or stamina.

The Pawn selection logic can only be used if you have Pawn installed. This feature is disabled in the configuration menu if  
Pawn is not installed. The Pawn selection logic simply uses Pawn to calculate upgrades. If Pawn fails to calculate a score  
using its smarter weights, then the reward selection automation will default to the Dumb logic.

Automation will happen even if none of the quest rewards are considered upgrades. The reward that is closest to being  
an upgrade will be selected because of the possibility of warforging.

I may add a configuration to this feature to select the quest reward that vendors for the highest amount in the future.
</details>

<details><summary>Quest Interaction Automation</summary>

This feature automates the accepting and completion of quests. It was recently updated to work for all quests rather than  
only Shadowlands quests, so let me know if you see any strange behaviors.

There is currently no ability to configure which quest types get accepted. I plan to add this in the future. 
</details>

<details><summary>Dialog Interaction Automation</summary>

This feature attempts to automate the selection of dialog required to complete quests. It currently only works for  
Shadowlands quests on an English client. It works off of a whitelist that I manually created. I don't know how to extend  
this to all quests and other languages, but if I can think of a way, then I'll implement it eventually.

If the NPC with the quest dialog is an innkeeper, and the Hearthstone Automation feature is enabled, then this feature  
will take precedence.
</details>

<details><summary>Quest Reward Equip Automation</summary>

This feature automatically equips quest loot upgrades for your current spec. After a quest is completed and a BOP  
equippable quest reward is received, a flag is set to indicate that quest loot is pending review for equipping. If you are  
not in combat when the quest loot is received, then the review process starts immediately. If you are in combat or you are  
dead when the quest loot is received, then the review process is postponed until after you are neither in combat nor  
dead.

Once the review process starts, the addon attempts to locate the item in the bag every 1 second. Once it finds the item,  
it can determine if it is an upgrade and equip it if it is. This review process is necessary because it is not possible to detect  
if the item is an upgrade before the quest is completed due to the fact that warforge is possible.  

This feature handles edge case scenarios where multiple quest rewards are received at the same time by utilizing a buffer.  
It also attempts to factor in gems, enchants, and the mechagon ring set bonus when deciding whether or not a piece of  
loot is an upgrade. This is done by ascribing an item level value to gems and enchants in a whitelist, with internal logic to  
check to see if you have mechagon rings, and with another whitelist that prevents low item level speed leveling items  
from being replaced. This same method is used to give a high value to speed leveling enchants, gems, and items.  

<blockquote><details><summary>Here is the list of gems and enchants and their rough item level equivalents that I have determined. If anyone wants to<br/>
do more research into this in order to come up with better numbers, then send me a message in my discord linked on<br/>
this page.</summary>

Deadly Lava Lazuli = 7.1  
Leviathan's Eye of Agility = 49.3  
Leviathan's Eye of Intellect = 49.3  
Leviathan's Eye of Strength = 49.3  
Masterful Sea Currant = 7.1  
Quick Sand Spinel = 7.1  
Straddling Sage Agate = 1000  
Versatile Dark Opal = 7.1  
Kraken's Eye of Agility = 32.9  
Kraken's Eye of Intellect = 32.9  
Kraken's Eye of Strength = 32.9  
Deadly Amberblaze = 6.1  
Masterful Tidal Amethyst = 2  
Quick Owlseye = 6.1  
Versatile Royal Quartz = 6.1  
Deadly Solstone = 4.1  
Masterful Kubiline = 4.1  
Quick Golden Beryl = 4.1  
Straddling Viridium = 1000  
Versatile Kyanite = 4.1  
Masterful Jewel Cluster = 16.2  
Quick Jewel Cluster = 16.2  
Deadly Jewel Cluster = 16.2  
Versatile Jewel Cluster = 16.2  
Deadly Jewel Doublet = 12.2  
Masterful Jewel Doublet = 12.2  
Quick Jewel Doublet = 12.2  
Versatile Jewel Doublet = 12.2  
Agile Soulwalker = 27.4  
Eternal Bulwark = 54.8  
Fortified Leech = 54.8  
Eternal Agility = 41.1  
Eternal Intellect = 41.1  
Illuminated Soul = 27.4  
Shaded Hearthing = 1000  
Eternal Bounds = 54.8  
Eternal Skirmish = 54.8  
Eternal Stats = 121.8  
Eternal Insight = 54.8  
Sacred Stats = 81.2  
Soul Vitality = 82.2  
Fortified Avoidance = 82.2  
Fortified Speed = 82.2  
Eternal Strength = 41.1  
Strength of Soul = 27.4  
Shadowlands Gathering = 1000  
Tenet of Critical Strike = 16.2  
Tenet of Haste = 16.2  
Tenet of Mastery = 16.2  
Tenet of Versatility = 16.2  
Bargain of Mastery = 12.2  
Bargain of Haste = 12.2  
Bargain of Versatility = 12.2  
Bargain of Critical Strike = 12.2  
Ascended Vigor = 20  
Eternal Grace = 20  
Lightless Force = 20  
Sinful Revelation = 20  
Celestial Guidance = 20  
Accord of Critical Strike = 9.1  
Accord of Haste = 9.1  
Accord of Mastery = 9.1  
Accord of Versatility = 9.1  
Pact of Critical Strike = 6.1  
Pact of Haste = 6.1  
Pact of Mastery = 6.1  
Pact of Versatility = 6.1  
Seal of Critical Strike = 4.1  
Seal of Haste = 4.1  
Seal of Mastery = 4.1  
Seal of Versatility = 4.1  
Force Multiplier = 10  
Machinist's Brilliance = 10  
Naga Hide = 10  
Oceanic Restoration = 10  
Deadly Navigation = 10  
Masterful Navigation = 10  
Quick Navigation = 10  
Stalwart Navigation = 10  
Versatile Navigation = 10  
Coastal Surge = 10  
Gale-Force Striking = 10  
Siphoning = 10  
Torrent of Elements = 10  
Minor Speed = 1000  
Blurred Speed = 1000  
Pandaren's Step = 1000  
Assassin's Step = 1000  
Lavawalker = 1000  
Earthen Vitality = 1000  
Tuskarr's Vitality = 1000  
Boar's Speed = 1000  
Cat's Swiftness = 1000
</details></blockquote>

<blockquote><details><summary>Here is the small whitelist of items that will not be equipped over. If you want me to add an item to the list, then send<br/>
me a message in my discord linked on this page.</summary>

Hunger of the Pack  
Boots of the Gilded Path
</details></blockquote>

On a final note, the reward detection logic for this feature isn't up to date with the most recent quest reward selection  
logic changes. It works off of item level rather than stats, and Pawn selection logic is not an option here. I will probably  
make changes to this logic in the future.
</details>

<details><summary>Quest Emote Automation</summary>

There are two quests that require you to perform an emote. One is a quest in Maldraxxus called Repeat After Me. It  
requires you to target 5 stones and then perform an emote to summon a creature. This feature will perform the correct  
emote when you are on the quest and you target the stones.  

The second quest is in Ardenweald and is called The Games We Play. It requires you to target the Playful Trickster and  
perform the correct emote when it gives you a riddle. This feature will automate the entire quest. Just stand in place and  
target the Playful Trickster.  

Some of the emotes performed by this feature require that you stand still for a moment, so it is a good idea to stop for a  
moment and then target the unit to perform the emote.
</details>

<details><summary>Quest Tracking Automation</summary>

This feature simply tracks quests the moment a quest is accepted. It produces the same outcome as if you went to the  
quest log, selected the accepted quest, and clicked Track.
    
It currently does not have the option to select which quest types to automatically track, but this is a feature that would be  
relatively simple to implement and I will probably add it in the near future.
</details>

<details><summary>Quest Sharing Automation</summary>

This feature is currently experimental. I tried designing this feature in a way that adds convenience to questing in a group.  
It currently only works for zone dailies, but I will probably add some configurability to work for multi-player leveling in  
the future.

Quests will be shared if you have dailies in your quest log that can be shared, you are in the zone for those dailies, and  
you join a party or a person joins your party. Automation does not happen if the group is a raid. Quests will also be  
shared if you are in a party and you accept a daily.

If you have multiple dailies in the first scenario above, then all of these dailies will be put into a buffer to be shared. The  
featue will await the responses of all party members before attempting to share the next quest in the buffer.

This feature tends to be a little awkward if you are queueing for mythic plus dungeons while doing dailies in The Maw.  
Every time a new person joins the group, the feature will attempt to share all dailies again. This isn't a problem for people  
who accept those dailies. However, for the people who don't want the dailies and decline it, they might get annoyed that  
you are spamming them with quests that they don't want.
</details></blockquote>
</details>

<details><summary>Speed Leveling Features</summary><blockquote>

<details><summary>Hearthstone Automation</summary>

This feature saves 2 button clicks when setting the hearthstone at Shadowlands innkeeper. It is only meant to speed up  
leveling by a tiny bit, and it is disabled once the player reaches level 60.  

The configuration menu will still show this feature as enabled at level 60, but the addon's internal logic will have it  
disabled. This makes it so that you don't have to switch this configuration on and off between alts.  

Some Shadowlands innkeepers are necessary to talk to for quests. This feature will not set your hearthstone when  
interacting with these innkeepers (with the exception of the innkeeper when you first reach Oribos).  

<blockquote><details><summary>Here is a list of the innkeepers for which this feature will work:</summary>

Caretaker Calisaphene  
Caretaker Theo  
Inkiep  
Kere Kinblade  
Slumbar Valorum  
Odew Testan  
Flitterbit  
Kewarin  
Llar'reth  
Nolon  
Sanna  
Shelynn  
Taiba  
Absolooshun  
Delia  
Ima  
Mims  
Roller  
Soultrapper Valistra  
Tavian  
Tremen Winefang  
Host Ta'rela
</details></blockquote>

This feature is only meant for people who want to trim seconds off of the leveling process and it is disabled by default. I  
may make it configurable if there is another wow expansion or if there is interest in it currently.
</details>

<details><summary>Automatically Retrieve Radinax Gems</summary>
    
This feature will loot Cracked Radinax Control Gems from your mailbox automatically when you click on it. This is an item  
that is currently essential for speed leveling. The item is unique, meaning that you can only have one in your bags at a  
time. However, the mailbox can be abused to store multiple Cracked Radinax Control Gems at once.

If a new expansion comes out and I have access to the beta, then I will probably develop this feature further to allow  
players to more easily load the mailbox with these gems for speed leveling practice.

This feature is disabled by default.
</details></blockquote>
</details>

**Feature Demo Video**

[![PoliQuest video thumbnail](https://img.youtube.com/vi/xXrAWhFgX7s/0.jpg)](https://www.youtube.com/watch?v=xXrAWhFgX7s)

**Author's Note**

This is my first addon. I learned a lot while making it, and I plan to make more addons in the future. I hope you like it!

[Discord Link](https://discord.gg/nc4ECEw "Discord")

[Curseforge Link](https://www.curseforge.com/wow/addons/poliquest-shadowlands)

**Contribute**

If you want to support my work, you can share it with your friends or offer constructive feedback or propose features that  
you think you and other people would like.

If you want to contribute more, you can create pull requests for this addon, or you can donate to my PayPal.

[![PayPal Button](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_LG.gif "Donate")](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=WW4YMCEMJMWVW&item_name=Polihayse+WoW+addon+development&currency_code=USD&source=url)
