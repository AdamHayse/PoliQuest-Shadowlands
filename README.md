**About**

PoliQuest is a Shadowlands questing addon that makes leveling less cumbersome by providing tools that reduce mouse button clicks and automating quest interactions.

**Commands**

Type "**/pq**" or "**/poliquest**" to open the configuration menu.

Type "**/pq toggle**" or "**/poliquest toggle**" to show/hide the PQButton and reposition it.

**Feature Summaries**

*   PQButton that automatically binds Shadowlands quest items to it
*   Quest emote automation
*   Automatically accept and complete quests (level 50-59 quests only)
*   Automatically select correct quest dialog (level 50-59 quests only)
*   Automatically track quests when accepted (all quests)
*   Track quest progress percent in quest info display (all quests)
*   Quest reward automation (level 50-59 quests only)
*   Automatically equip quest loot upgrades (all quests. non-BOE items only)
*   Automatically set hearthstone (less than level 60 only)

**Feature Overview**

PQ Button

<div class="spoiler">The PQButton is a button that appears when you have a Shadowlands quest item in your bags. The addon automatically binds quest items to this button and allows you to effortlessly use quest items by giving you the option to keybind it.  

![PQButton image](https://media.forgecdn.net/attachments/314/709/poliquest-curse-img1.png "PQButton")  

The following macro keybinds the PQButton as well as the arrow button that allows you to cycle through the quest items in your bags. Using the macro while not holding ctrl, alt, or shift will use the quest item, and using the macro while holding alt will cycle through the quest items in your bags.  

`/click [nomod]PQButton;[mod:alt]PQNext`  

The PQButton only updates outside of combat. If you gain or lose a quest item while in combat, then the button will update once out of combat. Likewise, the quest item bound to the PQButton can only be changed while out of combat.  

The PQButton can be repositioned. It currently cannot be resized. I'm going to try implementing that before the code cutoff date that I set before Shadowland's release (Nov. 20, 2020).  

The PQButton currently only works for level 50-59 Shadowlands quests. I may expand this to include other quests as well, but I haven't looked into it yet. Currently, this button only shows quest items that are in the addon's whitelist. This whitelist was created and is currently maintained by scraping data from wowhead with a separate program that I wrote, and then formatting it so that it is usable by the addon. I'll probably need to take a separate approach to make it work for all quests.</div>

Quest and Dialog Automation

<div class="spoiler">This feature automates interactions with quest givers and units with quest-related dialog options.  

Shadowlands quests will automatically be accepted and turned in. This feature works off of a whitelist that I generate with a separate program that scrapes data from wowhead. If a quest giver's quest is not contained in this whitelist, then these interactions will not be automated.  

In some edge cases, the quest automation can be buggy if Blizzard's quest frame breaks due to quick interactions and/or poor coding on their end (and maybe poor coding on my end?). I may be able to make changes in the future to account for these edge case scenarios, but for now it's as simple as hitting ESC or closing the quest frame and then interacting with the quest giver again.  

The dialog automation also works off of a whitelist. Unlike the quest automation, the dialog automation's whitelist isn't generated. I manually typed it out, and it took a very long time. Only dialog that I have manually whitelisted will be automated.  

This also means that this feature does not work for non-English clients. Also, if a patch changes the dialog text or the quest's name, then the dialog will not be automated in that specific instance.  

Included in this feature is also the quest progress percent tracking. For quests and bonus objectives that have a progress bar, increases in quest progress will be displayed in addition to existing quest progress text.  

I'll probably separate this feature from the Quest and Dialog Automation at some point since it isn't too difficult and it doesn't really make sense having it as part of this feature.</div>

Quest Reward Selection Automation

<div class="spoiler">This is a configuration for the Quest and Dialog Automation feature. The addon will choose quest rewards for you based on the following logic:  

`1\. If there is only 1 quest item reward, then select that one.  
    Stop automation if:  
        The "Automatically select quest rewards" switch is disabled.  
        Any of the quest rewards is not equippable.  

2\. Get the player's current loot spec, or current spec if they don't have one.  
    Stop automation if:  
        Item is missing from the equip slot for one of the quest loot items.  
        None of the items are for your preferred spec.  

3\. Find the largest potential ilvl upgrade for this spec based on your equipped gear (factoring in sockets and considering that warforge is possible).  

4\. If there is only one largest spec upgrade, then select that one.  
    Stop automation if:  
        The "Strict Automation" switch is enabled.  
        One of the largest upgrades is a trinket.  

5\. Find the item that yields the largest increase in stats and choose that one. (For example, legs have more stats than gloves at equal ilvl, so legs get chosen.`</div>

Strict Automation

<div class="spoiler">This is a configuration of the Quest Reward Selection Automation configuration. It simply stops the automation when there isn't a clear ilvl upgrade among the quest rewards.</div>

Hearthstone Automation

<div class="spoiler">This feature saves 2 button clicks when setting the hearthstone at Shadowlands innkeeper. It is only meant to speed up leveling by a tiny bit, and it is disabled once the player reaches level 60\.  

The configuration menu will still show this feature as enabled at level 60, but the addon's internal logic will have it disabled. This makes it so that you don't have to switch this configuration on and off between alts.  

Some Shadowlands innkeepers are necessary to talk to for quests. This feature will not set your hearthstone when interacting with these innkeepers (with the exception of the innkeeper when you first reach Oribos).  

Here is a list of the innkeepers for which this feature will work:

<div class="spoiler">Caretaker Calisaphene  
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
Host Ta'rela</div>

</div>

Quest Reward Equip Automation

<div class="spoiler">This feature automatically equips quest loot upgrades for your current spec. After a quest is completed and a BOP equippable quest reward is received, a flag is set to indicate that quest loot is pending review for equipping. If you are not in combat when the quest loot is received, then the review process starts immediately. If you are in combat when the quest loot is received, then the review process is postponed until after you leave combat.  

Once the review process starts, the addon attempts to locate the item in the bag every 1 second. Once it finds the item, it can determine if it is an upgrade and equip it if it is. This review process is necessary because it is not possible to detect if the item is an upgrade before the quest is completed due to the fact that warforge is possible.  

This feature handles edge case scenarios where multiple quest rewards are received at the same time by utilizing a buffer. It also attempts to factor in gems, enchants, and the mechagon ring set bonus when deciding whether or not a piece of loot is an upgrade. This is done by ascribing an item level value to gems and enchants in a whitelist, with internal logic to check to see if you have mechagon rings, and with another whitelist that prevents low item level speed leveling items from being replaced. This same method is used to give a high value to speed leveling enchants, gems, and items.  

Below is the list of gems and enchants and their rough item level equivalents that I have determined. If anyone wants to do more research into this in order to come up with better numbers, then send me a message in my discord linked on this page.

<div class="spoiler">Deadly Lava Lazuli = 7.1  
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
Cat's Swiftness = 1000</div>

Here is the small whitelist of items that will not be equipped over. If you want me to add an item to the list, then send me a message in my discord linked on this page.

<div class="spoiler">Hunger of the Pack  
Boots of the Gilded Path</div>

</div>

Quest Emote Automation

<div class="spoiler">There are two quests that require you to perform an emote. One is a quest in Maldraxxus called Repeat After Me. It requires you to target 5 stones and then perform an emote to summon a creature. This feature will perform the correct emote when you are on the quest and you target the stones.  

The second quest is in Ardenweald and is called The Games We Play. It requires you to target the Playful Trickster and perform the correct emote when it gives you a riddle. This feature will automate the entire quest. Just stand in place and target the Playful Trickster.  

Some of the emotes performed by this feature require that you stand still for a moment, so it is a good idea to stop for a moment and then target the unit to perform the emote.</div>

**Feature Demo Video**

[![PoliQuest video thumbnail](https://img.youtube.com/vi/xXrAWhFgX7s/0.jpg)](https://www.youtube.com/watch?v=xXrAWhFgX7s)

**Author's Note**

This is my first addon. I learned a lot while making it, and I plan to make more addons in the future. I hope you like it!

[Discord Link](https://discord.gg/nc4ECEw "Discord")

[Curseforge Link](https://www.curseforge.com/wow/addons/poliquest-shadowlands)

**Contribute**

If you want to support my work, you can share it with your friends or offer constructive feedback or propose features that you think you and other people would like.

If you want to contribute more, you can create pull requests for this addon (which I don't recommend because it is a spaghetti code mess), or you can donate to my PayPal.

[![PayPal Button](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_LG.gif "Donate")](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=WW4YMCEMJMWVW&item_name=Polihayse+WoW+addon+development&currency_code=USD&source=url)