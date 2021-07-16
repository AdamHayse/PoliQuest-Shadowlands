**About**

PoliQuest is a Shadowlands questing addon that makes questing less cumbersome by reducing mouse button clicks and  
other quest-related actions.

**Commands**

Type "**/pq**" or "**/poliquest**" to open the configuration menu.

Type "**/pq toggle**" or "**/poliquest toggle**" to show/hide the PQButton and reposition it.

**Feature Summaries**

* Automatically accept and complete quests
* Automated quest reward selection that can be enhanced if Pawn is installed
* Automatically equip quest reward upgrades
* Automatically select correct quest dialog (English only)(Shadowlands level quests only)
* Automation for quests that require you to type emotes (Shadowlands only)
* Automatically track quests
* Automatically share zone dailies
* PQButton that automatically binds quest items to it
* Skip all skippable cutscenes
* Enhanced quest progress tracking
* Automatically set hearthstone at whitelisted innkeepers (not configurable yet)
* Automatically retrieve Radinax Gems from mailboxes

**Feature Overview**

<details><summary>Automation Features</summary><blockquote>

<details><summary>Quest Interaction Automation</summary>

This feature automates the accepting and completion of quests. It can be configured to exclude trivial (low level) quests and to set a modifier key (alt, ctrl, or shift) that, when held down, will temporarily suspend the automation done by this feature.
</details>

<details><summary>Quest Reward Selection Automation</summary>

This feature automates the quest reward selection process. It attempts to find upgrades for your current loot specialization (or current specialization if you don't have a loot specialization specified).

The process of selecting quest rewards is split into two separate phases:
* checking whether or not automation should happen
* calculating which quest reward to select given the configured reward selection logic

The check logic executes as follows:
* stop if one of the rewards is not an equippable item
* stop if the item level of the reward is above the configured item level threshold
* stop if the selection logic is not Vendor Price and none of the quest rewards fit your current loot specialization (current spec if loot specialization isn't selected)
* stop if the selection logic is not Vendor Price and the player doesn't have a specialization and no loot specialization is selected
* exit the check logic if the selection logic is not Vendor Price and only one of the rewards is a fit your current loot specialization (current spec if loot specialization isn't selected)
* stop if the selection logic is not Vendor Price and the player is missing an item from an equip slot of one of the rewards and the reward item level is greater than 50
* stop if the selection logic is not Vendor Price and one of the rewards has a socket
* stop if the selection logic is not Vendor Price and one of the rewards is a trinket
* stop if the selection logic is not Vendor Price and one of the rewards is a weapon
* stop if one of the rewards is a shirt
* stop if one of the rewards is a tabard

The selection logic executes as follows:
* select most valuable reward if selection logic is Vendor Price
* select reward if only one of the rewards fit your current loot specialization (current spec if loot specialization isn't selected)
* select reward that offers the highest relative item level upgrade if selection logic is Item Level
* select reward based on maximum relative Pawn score if selection logic is Pawn Weights and there were no unsuccessful Pawn comparisons
* select reward based on maximum relative Simple Weights score if selection logic is Simple Weights

The Simple Weights selection logic uses a system of comparison involving something called a class and a score. Quest rewards are assigned a class based on their category, the category of the equip slot items they are compared against, and the calculated score between them if their categories are equal. Quest rewards that fall into the highest present class are prioritized in the selection process with score only factoring in when there are multiple rewards in the highest present class. Below are two charts explaining the different item categories and comparison classes:

| Category | Description |
| --- | --- |
| stats | An item that has at least 1 primary or secondary stat |
| stam | An item that is missing primary and secondary stats, but has stamina |
| armor | An item that has only armor |

| Class | Reward Item | Equip Slot Item | Score |
| --- | --- | --- | --- |
| 9 | stats | none | N/A |
| 9 | stats | armor | N/A |
| 9 | stats | stam | N/A |
| 9 | stats | stats | positive |
| 8 | stam | none | N/A |
| 8 | stam | armor | N/A |
| 8 | stam | stam | positive |
| 7 | armor | none | N/A |
| 7 | armor | armor | positive |
| 6 | stats | stats | nonpositive |
| 5 | stam | stam | nonpositive |
| 4 | armor | armor | nonpositive |
| 3 | stam | stats | N/A |
| 2 | armor | stam | N/A |
| 1 | armor | stats | N/A |

The score itself is the simple part of the calculation. Primary stats (Intellect, Agility, Strength) are given a weight of 2 and secondary stats (Mastery, Critical Strike, Versatility, Haste) are given a weight of 1. For example, an item with a 2 Agility, 1 Haste, and 1 Mastery would have a score of 2 * 2 + 1 + 1 = 6. Items that fall into the category of stam only give Stamina a weight of 1 and armor has no weight. Items that fall into the category of armor only give Armor a weight of 1 because that is the only stat being compared.

It is possible for rewards in the lower classes to be upgrades due to the possibility of warforging. For example, a comparison in class 6 means that the quest reward is worse than the equip slot item, but warforging can easily make that nonpositive score positive, and then the quest reward equip automation would recognize the comparison as class 9.

The Pawn Weights, Simple Weights, and Item Level selection logics all attempt to find the largest upgrade regardless of whether or not the comparison currently shows the rewards as downgrades due to the possibility of warforging making them upgrades.
</details>

<details><summary>Quest Reward Equip Automation</summary>

This feature automates the quest reward equip process. It attempts to equip quest reward upgrades for your current specialization upon receipt if your character is able to (not in combat or dead).

The process of equipping a quest reward is split into two separate phases:
* checking whether or not automation should happen
* calculating whether or not the reward is an upgrade given the configured reward equip logic

The check logic executes as follows:
* stop if the reward is not an equippable item
* stop if the average item level of the player is above the configured average item level threshold
* stop if the reward is Bind on Equip
* stop if the player has a specialization selected and the item does not fit the player's current specialization
* stop if the Do Not Equip Over Heirlooms feature configuration is selected and the reward item type equip slot locations are all equipped with heirlooms
* stop if the Do Not Equip Over Speed Items feature configuration is selected and the reward item type equip slot locations are all equipped with speed items
* stop if Use Item Level Logic For Trinkets feature configuration is not selected and the reward is a trinket
* stop if the reward is a weapon and there is an item missing from the reward equip location(s)
* stop if the reward is a weapon and there is a discrepancy between the reward item type and the equipped item type in the reward equip slot location(s) (one handers shouldn't equip over 2 handers, etc.)

The equip logic executes as follows:
* equip reward if there is an item missing from the reward equip slot location(s)
* filter out heirloom/speed item equip slots for the reward item type if Do Not Equip Over Heirlooms and Do Not Equip Over Speed Items feature configurations are selected
* don't equip reward if the resulting filtered list of equip slots to compare against is empty
* equip reward if the equip logic is Pawn Weights and the player currently has a specialization and the Pawn comparison is successful and the Pawn score is positive
* equip reward if it is not a trinket or weapon and the equip logic is Simple Weights or Pawn Weights and the Simple Weights comparison determines the reward to be an upgrade
* equip reward if it is a trinket or a weapon or the equip logic is Item Level and the Item Level comparison determines the reward to be an upgrade

Speed items are items that speed levelers use to level faster. These tend to have weaker stats, but they should not be equipped over. The list of speed items is hard coded in the addon and is currently incomplete. I plan to add to this list in the future (probably during the beta of the next expansion). Here are the current items on the list:

In order for this feature to work, it needs to be able to locate the quest reward in your bags. If it can't find the reward for some reason, it will time out and proceed with searching for the next item in the reward buffer if there is one. The automation is paused if the player is dead or in combat, and it resumed when neither or those two things are true.
* Hunger of the Pack  
* Boots of the Gilded Path
</details>

<details><summary>Dialog Interaction Automation</summary>

This feature attempts to automate the selection of dialog required to complete quests. It currently only works for  
Shadowlands quests on an English client. It works off of a whitelist that I manually created.

In order to extend this functionality to more than just English clients and early Shadowlands quests, I'm considering creating some type of plugin compatibility and delegating the responsibility of data collection to plugins, and/or adding to the dialog frame the option to select a dialog option in the future for people who route speed leveling. I may even add the ability to export dialog whitelist profiles, but these things are still pretty far off in the future. 

This feature takes precedence over the Hearthstone Automation speed leveling feature.
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
    
Some progress tracking will be excluded. For example, mythic plus dungeon progress and quests that track progress in  
the form of an Alternative Power bar are not tracked by this feature.
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

**Debug Mode**

I added the ability to run each feature in debug mode. This is done by right clicking the check button for a feature in the configuration menu. Setting a feature to debug mode will print information to the player's chat window when the feature's event handler's execute code. I mainly added this for my own personal use since I don't get very much feedback, but it's sometimes interesting to see what is happening in the background. Feel free to use this functionality to assist with reporting bugs.

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
