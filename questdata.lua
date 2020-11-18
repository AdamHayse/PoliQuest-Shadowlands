local _, addonTable = ...

addonTable.innWhitelist = {

    -- Bastion
    ["Caretaker Calisaphene"] = true,
    --["Caretaker Mirene"] = true,  -- Excluded due to quest
    ["Caretaker Theo"] = true,
    --["Inkiep"] = true, -- Excluded due to quest

    -- Maldraxxus
    ["Kere Kinblade"] = true,
    ["Slumbar Valorum"] = true,
    ["Odew Testan"] = true,
    
    -- Ardenweald
    ["Flitterbit"] = true,
    --["Flwngyrr"] = true, -- Excluded due to quest
    ["Kewarin"] = true,
    ["Llar'reth"] = true,
    ["Nolon"] = true,
    ["Sanna"] = true,
    ["Shelynn"] = true,
    ["Taiba"] = true,
    
    -- Revendreth
    ["Absolooshun"] = true,
    ["Delia"] = true,
    ["Ima"] = true,
    ["Mims"] = true,
    ["Roller"] = true,
    ["Soultrapper Valistra"] = true,
    ["Tavian"] = true,
    ["Tremen Winefang"] = true,
    
    -- Oribos
    ["Host Ta'rela"] = true
}

addonTable.itemEquipLocToEquipSlot = {
    ["INVTYPE_AMMO"] = 0,
    ["INVTYPE_HEAD"] = 1,
    ["INVTYPE_NECK"] = 2,
    ["INVTYPE_SHOULDER"] = 3,
    ["INVTYPE_BODY"] = 4,
    ["INVTYPE_CHEST"] = 5,
    ["INVTYPE_ROBE"] = 5,
    ["INVTYPE_WAIST"] = 6,
    ["INVTYPE_LEGS"] = 7,
    ["INVTYPE_FEET"] = 8,
    ["INVTYPE_WRIST"] = 9,
    ["INVTYPE_HAND"] = 10,
    ["INVTYPE_FINGER"] = { 11, 12 },
    ["INVTYPE_TRINKET"] = { 13, 14 },
    ["INVTYPE_CLOAK"] = 15,
    ["INVTYPE_WEAPON"] = { 16, 17 },
    ["INVTYPE_SHIELD"] = 17,
    ["INVTYPE_2HWEAPON"] = 16,
    ["INVTYPE_WEAPONMAINHAND"] = 16,
    ["INVTYPE_WEAPONOFFHAND"] = 17,
    ["INVTYPE_HOLDABLE"] = 17, --[[
    ["INVTYPE_RANGED"] = 18,
    ["INVTYPE_THROWN"] = 18,
    ["INVTYPE_RANGEDRIGHT"] = 18,
    ["INVTYPE_RELIC"] = 18,
    ["INVTYPE_TABARD"] = 19,
    ["INVTYPE_BAG"] = { 20, 21, 22, 23 }
    ["INVTYPE_QUIVER"] = { 20, 21, 22, 23 }  ]]
}

addonTable.levelingItems = {
    "Hunger of the Pack",
    "Boots of the Gilded Path"
}

addonTable.bonusToIlvl = {
    [168639] = 7.1,  -- Deadly Lava Lazuli
    [168637] = 49.3,  -- Leviathan's Eye of Agility
    [168638] = 49.3,  -- Leviathan's Eye of Intellect
    [168636] = 49.3,  -- Leviathan's Eye of Strength
    [168640] = 7.1,  -- Masterful Sea Currant
    [168641] = 7.1,  -- Quick Sand Spinel
    [169220] = 1000,  -- Straddling Sage Agate
    [168642] = 7.1,  -- Versatile Dark Opal
    [153708] = 32.9,  -- Kraken's Eye of Agility
    [153709] = 32.9,  -- Kraken's Eye of Intellect
    [153707] = 32.9,  -- Kraken's Eye of Strength
    [154126] = 6.1,  -- Deadly Amberblaze
    [154129] = 2,  -- Masterful Tidal Amethyst
    [154127] = 6.1,  -- Quick Owlseye
    [154128] = 6.1,  -- Versatile Royal Quartz
    [153710] = 4.1,  -- Deadly Solstone
    [153713] = 4.1,  -- Masterful Kubiline
    [153711] = 4.1,  -- Quick Golden Beryl
    [153715] = 1000,  -- Straddling Viridium
    [153712] = 4.1,  -- Versatile Kyanite
    [173130] = 16.2,  -- Masterful Jewel Cluster
    [173128] = 16.2,  -- Quick Jewel Cluster
    [173127] = 16.2,  -- Deadly Jewel Cluster
    [173129] = 16.2,  -- Versatile Jewel Cluster
    [173121] = 12.2,  -- Deadly Jewel Doublet
    [173124] = 12.2,  -- Masterful Jewel Doublet
    [173122] = 12.2,  -- Quick Jewel Doublet
    [173123] = 12.2,  -- Versatile Jewel Doublet
    [6212] = 27.4,  -- Agile Soulwalker
    [6213] = 54.8,  -- Eternal Bulwark
    [6204] = 54.8,  -- Fortified Leech
    [6211] = 41.1,  -- Eternal Agility
    [6220] = 41.1,  -- Eternal Intellect
    [6219] = 27.4,  -- Illuminated Soul
    [6222] = 1000,  -- Shaded Hearthing
    [6217] = 54.8,  -- Eternal Bounds
    [6214] = 54.8,  -- Eternal Skirmish
    [6230] = 121.8,  -- Eternal Stats
    [6265] = 54.8,  -- Eternal Insight
    [6216] = 81.2,  -- Sacred Stats
    [6208] = 82.2,  -- Soul Vitality
    [6203] = 82.2,  -- Fortified Avoidance
    [6202] = 82.2,  -- Fortified Speed
    [6210] = 41.1,  -- Eternal Strength
    [6209] = 27.4,  -- Strength of Soul
    [6205] = 1000,  -- Shadowlands Gathering
    [6164] = 16.2,  -- Tenet of Critical Strike
    [6166] = 16.2,  -- Tenet of Haste
    [6168] = 16.2,  -- Tenet of Mastery
    [6170] = 16.2,  -- Tenet of Versatility
    [6167] = 12.2,  -- Bargain of Mastery
    [6165] = 12.2,  -- Bargain of Haste
    [6169] = 12.2,  -- Bargain of Versatility
    [6163] = 12.2,  -- Bargain of Critical Strike
    [6227] = 20,  -- Ascended Vigor
    [6226] = 20,  -- Eternal Grace
    [6223] = 20,  -- Lightless Force
    [6228] = 20,  -- Sinful Revelation
    [6229] = 20,  -- Celestial Guidance
    [6108] = 9.1,  -- Accord of Critical Strike
    [6109] = 9.1,  -- Accord of Haste
    [6110] = 9.1,  -- Accord of Mastery
    [6111] = 9.1,  -- Accord of Versatility
    [5942] = 6.1,  -- Pact of Critical Strike
    [5943] = 6.1,  -- Pact of Haste
    [5944] = 6.1,  -- Pact of Mastery
    [5945] = 6.1,  -- Pact of Versatility
    [5938] = 4.1,  -- Seal of Critical Strike
    [5939] = 4.1,  -- Seal of Haste
    [5940] = 4.1,  -- Seal of Mastery
    [5941] = 4.1,  -- Seal of Versatility
    [6148] = 10,  -- Force Multiplier
    [6112] = 10,  -- Machinist's Brilliance
    [6150] = 10,  -- Naga Hide
    [6149] = 10,  -- Oceanic Restoration
    [5965] = 10,  -- Deadly Navigation
    [5964] = 10,  -- Masterful Navigation
    [5963] = 10,  -- Quick Navigation
    [5966] = 10,  -- Stalwart Navigation
    [5962] = 10,  -- Versatile Navigation
    [5946] = 10,  -- Coastal Surge
    [5950] = 10,  -- Gale-Force Striking
    [5948] = 10,  -- Siphoning
    [5949] = 10,  -- Torrent of Elements
    [911] = 1000,  -- Minor Speed
    [4428] = 1000,  -- Blurred Speed
    [4429] = 1000,  -- Pandaren's Step
    [4105] = 1000,  -- Assassin's Step
    [4104] = 1000,  -- Lavawalker
    [4062] = 1000,  -- Earthen Vitality
    [3232] = 1000,  -- Tuskarr's Vitality
    [2940] = 1000,  -- Boar's Speed
    [2939] = 1000,  -- Cat's Swiftness
}

setmetatable(addonTable.bonusToIlvl, {__index = function() return 0 end})

addonTable.dialogWhitelist = {
    ["Shadowlands: A Chilling Summons"] = {
        ["npc"] = {
            "Nazgrim",
            "High Inquisitor Whitemane",
        },
        ["dialog"] = "Tell me what happened."
    },
    ["A Flight from Darkness"] = {
        ["npc"] = "Lady Jaina Proudmoore",
        ["dialog"] = "I am ready."
    },
    ["A Moment's Respite"] = {
        ["npc"] = "Lady Jaina Proudmoore",
        ["dialog"] = {
            "Tell me about this place.",
            "Tell me more of the Jailer.",
            "What about the others who were taken?"
        }
    },
    ["The Lion's Cage"] = {
        ["npc"] = "Lady Jaina Proudmoore",
        ["dialog"] = "<Lie low and observe.>"
    },
    ["From the Mouths of Madness"] = {
        ["npc"] = "Highlord Darion Mograine",
        ["dialog"] = "Make it talk."
    },
    ["The Path to Salvation"] = {
        ["npc"] = "Lady Jaina Proudmoore",
        ["dialog"] = "I am ready."
    },
    ["Stranger in an Even Stranger Land"] = {
        ["npc"] = {
            "Protector Captain",
            "Overseer Kah-Delen"
        },
        ["dialog"] = {
            "Where am I? Have I escaped the Maw?",
            "Are you in charge here? Where am I?"
        }
    },
    ["No Place for the Living"] = {
        ["npc"] = "Overseer Kah-Delen",
        ["dialog"] = "Yes, I escaped the Maw."
    },
    ["Audience with the Arbiter"] = {
        ["npc"] = "Tal-Inara",
        ["dialog"] = {
            "I will join you.",
            "What is this place?",
            "I am ready to return."
        }
    },
    ["A Doorway Through the Veil"] = {
        ["npc"] = "Ebon Blade Acolyte",
        ["dialog"] = {
            "Let's head outside.",
            "Summon the portals here."
        }
    },
    ["The Eternal City"] = {
        ["npc"] = {
            "Foreman Au'brak",
            "Caretaker Kah-Rahm",
            "Fatescribe Roh-Tahl",
            "Host Ta'rela",
            "Overseer Ta'readon"
        },
        ["dialog"] = {
            "What is available here?",
            "What is this Hall of Holding?",
            "What is this place?",
            "Thank you for the kind welcome to your Inn.",
            "What is this bazaar?"
        }
    },
    ["Understanding the Shadowlands"] = {
        ["npc"] = {
            "Tal-Inara",
            "Overseer Kah-Sher"
        },
        ["dialog"] = {
            "Can you help us find answers?",
            "I will go with you."
        }
    },
     ["Seek the Ascended"] = {
        ["npc"] = "Pathscribe Roh-Avonavi",
        ["dialog"] = "I am ready. Send me to Bastion."
    },
    
    ["Welcome to Eternity"] = {
        ["npc"] = "Kleia",
        ["dialog"] = "Lead on, Kleia."
    },
    ["A Fate Most Noble"] = {
        ["npc"] = "Greeter Mnemis",
        ["dialog"] = {
            "I think there might have been a mistake.",
            "I am not dead.",
            "I come from Azeroth."
        }
    },
    ["Trouble in Paradise"] = {
        ["npc"] = "Kleia",
        ["dialog"] = "<Tell Kleia what you saw in the Maw.>"
    },
    ["The Work of One's Hands"] = {
        ["npc"] = "Sika",
        ["dialog"] = "Show me what to do, Sika."
    },
    ["Assessing Your Stamina"] = {
        ["npc"] = "Sparring Aspirant",
        ["dialog"] = {
            "Will you spar with me?",
            "I would like to challenge both of you to a spar."
        }
    },
    ["The First Cleansing"] = {
        ["npc"] = "Kleia",
        ["dialog"] = "I am ready to begin."
    },
    ["The Archon's Answer"] = {
        ["npc"] = "Kalisthene",
        ["dialog"] = "I wish to speak to the Archon."
    },
    ["A Temple in Need"] = {
        ["npc"] = {
            "Disciple Fotima",
            "Disciple Helene",
            "Disciple Lykaste"
        },
        ["dialog"] = {
            "I will help you.",
            "Tell me how I can help.",
            "Begin the cleansing. I am ready."
        }
    },
    ["On the Edge of a Revelation"] = {
        ["npc"] = "Vulnerable Aspirant",
        ["dialog"] = {
            "We will get through this together!",
            "You can do this. I believe in you.",
            "Trust in your teachings. They have not led you astray before."
        }
    },
    ["A Wayward Disciple?"] = {
        ["npc"] = "Disciple Nikolon",
        ["dialog"] = "Eridia asked me to find you."
    },
    ["Step Back From That Ledge, My Friend"] = {
        ["npc"] = {
            "Eridia",
            "Fallen Disciple Nikolon"
        },
        ["dialog"] = {
            "Yes, Eridia.",
            "Are you well?",
            "What is it? What is wrong?"
        }
    },
    ["The Enemy You Know"] = {
        ["npc"] = "Disciple Kosmas",
        ["dialog"] = "I am ready."
    },
    ["The Hand of Doubt"] = {
        ["npc"] = "Disciple Kosmas",
        ["dialog"] = "I will stand with you."
    },
    ["Purity's Prerogative"] = {
        ["npc"] = "Vesiphone",
        ["dialog"] = "I will fly with you."
    },
    ["What's In a Memory?"] = {
        ["npc"] = "Mikanikos",
        ["dialog"] = "I am ready."
    },
    ["I MADE You!"] = {
        ["npc"] = "Mikanikos",
        ["dialog"] = "I am ready."
    },
    ["The Vault of the Archon"] = {
        ["npc"] = "Mikanikos",
        ["dialog"] = "What do we do now?"
    },
    ["Your Personal Assistant"] = {
        ["npc"] = {
            "Gramilos", "Haka", "Pico", "Isilios", "Dafi",
            "Laratis", "Koukis", "Zenza", "Thima", "Ilapos",
            "Mupu", "Syla", "Abalus", "Tibo", "Farra",
            "Dintos", "Ipa", "Akiris", "Chaermi", "Bumos",
            "Asellia", "Bola", "Korinthe", "Apa", "Minta",
            "Kimos", "Toulis", "Deka"
        },
        ["dialog"] = "I need assistance."
    },
    ["Steward at Work"] = {
        ["npc"] = {
            "Gramilos", "Haka", "Pico", "Isilios", "Dafi",
            "Laratis", "Koukis", "Zenza", "Thima", "Ilapos",
            "Mupu", "Syla", "Abalus", "Tibo", "Farra",
            "Dintos", "Ipa", "Akiris", "Chaermi", "Bumos",
            "Asellia", "Bola", "Korinthe", "Apa", "Minta",
            "Kimos", "Toulis", "Deka"
        },
        ["dialog"] = "|cFF0000FF(Quest)|r I need you to fix the Beacon of Invocation."
    },
    ["On Swift Wings"] = {
        ["npc"] = "Polemarch Adrestes",
        ["dialog"] = "I am ready to go to Elysian Hold."
    },
    ["Kyrestia, the Firstborne"] = {
        ["npc"] = "Polemarch Adrestes",
        ["dialog"] = "I am ready to speak to the Archon."
    },
    ["Imminent Danger"] = {
        ["npc"] = "Cassius",
        ["dialog"] = "I need to go to the Temple of Courage."
    },
    ["Now or Never"] = {
        ["npc"] = "Thanikos",
        ["dialog"] = "I am with you."
    },
    ["The Final Countdown"] = {
        ["npc"] = "Thanikos",
        ["dialog"] = "I am ready."
    },
    ["A Time for Courage"] = {
        ["npc"] = "Thanikos",
        ["dialog"] = "I am ready."
    },
    ["If You Want Peace..."] = {
        ["npc"] = "Pathscribe Roh-Avonavi",
        ["dialog"] = "I am ready. Send me to Maldraxxus."
    },
    ["The House of the Chosen"] = {
        ["npc"] = "Baroness Draka",
        ["dialog"] = "Tell me your story."
    },
    ["The First Act of War"] = {
        ["npc"] = "Baron Vyraz",
        ["dialog"] = "Reporting for duty. I'm to prepare for war against the other houses."
    },
    ["The Hills Have Eyes"] = {
        ["npc"] = "Chosen Protector",
        ["dialog"] = "You're acting suspicious."
    },
    ["Maintaining Order"] = {
        ["npc"] = {
            "Head Summoner Perex",
            "Drill Sergeant Telice",
            "Secutor Mevix"
        },
        ["dialog"] = "I have orders from Baron Vyraz."
    },
    ["Forging a Champion"] = {
        ["npc"] = "Bonesmith Heirmir",
        ["dialog"] = "What do you know about this blade?"
    },
    ["The Blade of the Primus"] = {
        ["npc"] = "Bonesmith Heirmir",
        ["dialog"] = "I am ready to start forging a rune weapon."
    },
    ["The Seat of the Primus"] = {
        ["npc"] = "Baroness Draka",
        ["dialog"] = "I'm ready. Let's fly to the Seat of the Primus."
    },
    ["A Common Peril"] = {
        ["npc"] = "Baroness Vashj",
        ["dialog"] = "I have a summons from Draka."
    },
    ["Breaking Down Barriers"] = {
        ["npc"] = {
            "Aspirant Thales",
            "Salvaged Praetor",
        },
        ["dialog"] = {
            "How would you breach the barrier?",
            "I need you to follow my directions."
        },
    },
    ["War is Deception"] = {
        ["npc"] = "Baroness Vashj",
        ["dialog"] = "I'm ready. Begin the ritual."
    },
    ["Delving Deeper"] = {
        ["npc"] = "Ve'nari",
        ["dialog"] = "Let's go."
    },
    ["In Death We Are Truly Tested"] = {
        ["npc"] = "Alexandros Mograine",
        ["dialog"] = "I am ready."
    },
    ["I Moustache You to Lend a Hand"] = {
        ["npc"] = {
            "Featherlight",
            "Lady Moonberry"
        },
        ["dialog"] = {
            "I have the lily.",
            "Will you help me gain an audience with the Queen?"
        }
    },
    ["Wildseed Rescue"] = {
        ["npc"] = {
            "Korenth",
            "Featherlight"
        },
        ["dialog"] = {
            "I'm standing in for Lady Moonberry. What happened?",
            "What's a wildseed?",
            "I'll help you.",
            "<Hold still?>"
        }
    },
    ["Souls of the Forest"] = {
        ["npc"] = "Wagonmaster Derawyn",
        ["dialog"] = {
            "I will help you.",
            "You're welcome."
        }
    },
    ["Keep to the Path"] = {
        ["npc"] = {
            "Nelwyn",
            "\"Granny\"",
            "Lady Moonberry"
        },
        ["dialog"] ={
            "I'm going that way, too. I'll help.",
            "My, what big teeth you have Granny.",
            "Hey! What's the big idea?",
            "<Express your appreciation for her help.>"
        }
    },
    ["Nothing Left to Give"] = {
        ["npc"] = {
            "Slanknen",
            "Awool",
            "Rury"
        },
        ["dialog"] = {
            "Let's get you out of here.",
            "It's fine, you can leave with me now.",
            "The fuss is, it's time to leave."
        }
    },
    ["One Special Spirit"] = {
        ["npc"] = "Dreamweaver",
        ["dialog"] = "I'll take the animacones and infuse this wildseed with their anima."
    },
    ["Preparing for the Winter Queen"] = {
        ["npc"] = "Lady Moonberry",
        ["dialog"] = "I'm ready to be properly prepared to meet the Winter Queen."
    },
    ["Recovering the Heart"] = {
        ["npc"] = "Te'zan",
        ["dialog"] = "I need you to use some of your anima to destroy the droman's barrier."
    },
    ["Audience with the Winter Queen"] = {
        ["npc"] = "Lady Moonberry",
        ["dialog"] = {
            "I'm ready to meet the Winter Queen.",
            "Where do I go now?"
        }
    },
    ["The Missing Hunters"] = {
        ["npc"] = "Ara'lon",
        ["dialog"] = "Hunt-Captain Korayn says to report back to the grove."
    },
    ["I Know Your Face"] = {
        ["npc"] = "Hunt-Captain Korayn",
        ["dialog"] = "Who was that? What now?"
    },
    ["The Way to Hibernal Hollow"] = {
        ["npc"] = "Niya",
        ["dialog"] = "I'm taking the wildseed responsible for this to Hibernal Hollow. I could use your help bringing it there."
    },
    ["Soothing Song"] = {
        ["npc"] = "Dreamweaver",
        ["dialog"] = "I'm ready to take this wildseed to Hibernal Hollow."
    },
    ["Passage to Hibernal Hollow"] = {
        ["npc"] = "Ara'lon",
        ["dialog"] = "I'm ready to travel to the Hibernal Hollow."
    },
    ["Infusing the Wildseed"] = {
        ["npc"] = {
            "Proglo",
            "Dreamweaver"
        },
        ["dialog"] = {
            "Droman Aliothe said you were storing anima that we could use to help a wildseed.",
            "Thank you Proglo. I'll use this anima to help the wildseed.",
            "I'm ready to perform the ritual on the wildseed."
        }
    },
    ["Echoes of Tirna Noch"] = {
        ["npc"] = "Ara'lon",
        ["dialog"] = "<Listen to the tale of Tirna Noch.>"
    },
    ["Sparkles Rain from Above"] = {
        ["npc"] = "Lady Moonberry",
        ["dialog"] = "I'm ready to borrow some wings and rain sparkly terror."
    },
    ["Visions of the Dreamer: Origins"] = {
        ["npc"] = "Dreamer's Vision",
        ["dialog"] = "<Go back to the Dreamer's beginning.>"
    },
    ["Visions of the Dreamer: The Betrayal"] = {
        ["npc"] = "Dreamer's Vision",
        ["dialog"] = "<Face the Dreamer's great enemy in battle.>"
    },
    ["End of the Dream"] = {
        ["npc"] = "Dreamweaver",
        ["dialog"] = "|cFF0000FF(Quest)|r I am ready to relive the Dreamer's nightmare."
    },
    ["Battle for Hibernal Hollow"] = {
        ["npc"] = "Droman Aliothe",
        ["dialog"] = "I am ready to stand with you!"
    },
    ["Dying Dreams"] = {
        ["npc"] = "Lady Moonberry",
        ["dialog"] = "I am ready to go."
    },
    ["The Court of Winter"] = {
        ["npc"] = "Winter Queen",
        ["dialog"] = {
            "<Deliver the Primus's Message.>",
            "Yes, your majesty?"
        }
    },
    ["Bottom Feeders"] = {
        ["npc"] = "Lord Chamberlain",
        ["dialog"] = "Come with me."
    },
    ["To Darkhaven"] = {
        ["npc"] = "Lord Chamberlain",
        ["dialog"] = "Ready."
    },
    ["Bring Out Your Tithe"] = {
        ["npc"] = "Darkhaven Villager",
        ["dialog"] = "<Request tithe>"
    },
    ["Reason for the Treason"] = {
        ["npc"] = {
            "Globknob",
            "Courier Rokalai",
            "Soul of Keltesh",
            "Bela"
        },
        ["dialog"] = "|cFF0000FF(Quest)|r <Ask about suspicious activity>"
    },
    ["And Then There Were None"] = {
        ["npc"] = {
            "Ilka",
            "Samu"
        },
        ["dialog"] = "<Present Lajos's invitation>"
    },
    ["The Accuser's Secret"] = {
        ["npc"] = "Lord Chamberlain",
        ["dialog"] = "I'm ready to witness your ascension."
    },
    ["A Lesson in Humility"] = {
        ["npc"] = "Sire Denathrius",
        ["dialog"] = "I will witness the Accuser's judgment."
    },
    ["Dread Priming"] = {
        ["npc"] = "Sinreader Nicola",
        ["dialog"] = "Read this soul their sins."
    },
    ["The Penitent Hunt"] = {
        ["npc"] = "The Fearstalker",
        ["dialog"] = "Let's begin."
    },
    ["The Accuser"] = {
        ["npc"] = "The Accuser",
        ["dialog"] = "Show me."
    },
    ["A Reflection of Truth"] = {
        ["npc"] = "The Accuser",
        ["dialog"] = "I am ready."
    },
    ["The Fearstalker"] = {
        ["npc"] = "The Accuser",
        ["dialog"] = "I am ready."
    },
    ["Sign Your Own Death Warrant"] = {
        ["npc"] = {
            "Venthyr Writing Desk",
            "Lost Quill"
        },
        ["dialog"] = {
            "<Forge your Letter of Condemnation.>",
            "Greetings Stonehead,",
            "<Write your real name.>",
            "Insulting the Master",
            "As long as it pleases the Master",
            "Sincerely,\r\nThe Master",
            "Here, I found this ink bottle."
        }
    },
    ["Tubbins's Tea"] = {
        ["npc"] = "Tubbins",
        ["dialog"] = "I'll help you make the tea for Theotar."
    },
    ["An Uneventful Stroll"] = {
        ["npc"] = "Theotar",
        ["dialog"] = "I'm ready. Lead me to the sanctuary."
    },
    ["The Master of Lies"] = {
        ["npc"] = {
            "Projection of Prince Renathal",
            "Prince Renathal"
        },
        ["dialog"] = {
            "Begin the assault. (Queue for Scenario.)",
            "Ready to face the Master."
        }
    },
    
    -- Optional
    ["Suggested Reading"] = {
        ["npc"] = {
            "Aspirant Leda",
            "Aspirant Ikaran"
        },
        ["dialog"] = {
            "Do you have \"Worlds Beyond Counting\"?",
            "Do you have \"The Infinite Treatises\"?"
        }
    },
    ["Read Between the Lines"] = {
        ["npc"] = "Ta'eran",
        ["dialog"] = "Tell me about this opportunity."
    },
    ["...Even The Most Ridiculous Request!"] = {
        ["npc"] = {
            "Gunn Gorgebone",
            "Scrapper Minoire",
            "Rencissa the Dynamo"
        },
        ["dialog"] = {
            "Is there anything you need?",
            "Here--this is the biggest rock I could find."
        }
    },
    ["Side Effects"] = {
        ["npc"] = "Scrapper Minoire",
        ["dialog"] = "Here are the enhancers you wanted."
    },
    ["How to Get a Head"] = {
        ["npc"] = "Marcel Mullby",
        ["dialog"] = "I have some bloodtusk skulls for you."
    },
    ["Test Your Mettle"] = {
        ["npc"] = {
            "Valuator Malus",
            "Tester Sahaari"
        },
        ["dialog"] = "Very well. Let us fight."
    },
    ["Leave Me a Loan"] = {
        ["npc"] = "Arena Spectator",
        ["dialog"] = "Ad'narim claims you owe her anima."
    },
    ["A Plague on Your House"] = {
        ["npc"] = {
            "Vial Master Lurgy",
            "Foul-Tongue Cyrlix",
            "Boil Master Yetch"
        },
        ["dialog"] = {
            "Is there any way I can help?",
            "O.K."
        }
    },
    ["Ages-Echoing Wisdom"] = {
        ["npc"] = {
            "Elder Finnan",
            "Elder Gwenna",
            "Groonoomcrooek"
        },
        ["dialog"] = "The Lady of the Falls wanted to make sure you were safe."
    },
    ["A Curious Invitation"] = {
        ["npc"] = "Courier Araak",
        ["dialog"] = "Dimwiddle sent me."
    },
    ["Finders-Keepers, Sinners-Weepers"] = {
        ["npc"] = {
            "Cobwobble",
            "Dobwobble",
            "Slobwobble"
        },
            
        ["dialog"] = {
            "What are you all doing?",
            "Why are the ones with scribbles interesting?",
            "Where does the Taskmaster keep the sinstones?"
        }
    },
    ["Message for Matyas"] = {
        ["npc"] = "Courier Araak",
        ["dialog"] = "We are ready. Please tell the Taskmaster the Maw Walker is here."
    },
    ["Ritual of Absolution"] = {
        ["npc"] = "The Accuser",
        ["dialog"] = "I'm ready. Begin the ritual."
    },
    ["Ritual of Judgment"] = {
        ["npc"] = "The Accuser",
        ["dialog"] = "I'm ready. Begin the ritual."
    },
    ["Journey to Ardenweald"] = {
        ["npc"] = "Pathscribe Roh-Avonavi",
        ["dialog"] = "I am ready. Send me to Ardenweald."
    },
    ["A Plea to Revendreth"] = {
        ["npc"] = "Pathscribe Roh-Avonavi",
        ["dialog"] = "I am ready. Send me to Revendreth."
    },
    ["Into the Light"] = {
        ["npc"] = "Laurent",
        ["dialog"] = "I am ready."
    },
    ["We Can Rebuild Him"] = {
        ["npc"] = "Pelodis",
        ["dialog"] = "Everything is in place for the repair."
    },
    ["Follow the Path"] = {
        ["npc"] = "Tal-Inara",
        ["dialog"] = "Maldraxxus has attacked Bastion."
    }
}

addonTable.questIDToName = {
    [62473] = "what's old is new",
    [60428] = "the blade of the primus",
    [59426] = "your personal assistant",
    [60451] = "never enough",
    [59427] = "we need more power",
    [57380] = "sign your own death warrant",
    [60453] = "the path to glory",
    [57381] = "the greatest duelist",
    [59430] = "a plague on your house",
    [57386] = "if you want peace...",
    [60461] = "meet the margrave",
    [61486] = "the banshee's champion",
    [57390] = "to die by the sword",
    [61488] = "the banshee's champion",
    [60466] = "the old ways",
    [60467] = "a rousing aroma",
    [60468] = "rubble rummaging",
    [60469] = "safe in the shadows",
    [60470] = "setting sabina free",
    [57405] = "chasing madness",
    [58431] = "pool of potions",
    [60480] = "the endmire",
    [58433] = "anima attrition",
    [57414] = "mount up test",
    [60487] = "it used to be quiet here",
    [62536] = "the lost of teldrassil",
    [54349] = "darkshore donations: tidespray linen bandage",
    [62544] = "from a dark place",
    [57425] = "land of opportunity",
    [62546] = "no wisp left behind",
    [57426] = "my terrible morning",
    [57427] = "unbearable light",
    [61524] = "the ember court",
    [57428] = "theotar's mission",
    [62549] = "no wisp left behind",
    [62553] = "delaying their efforts",
    [60506] = "the accuser",
    [60509] = "not my job",
    [60514] = "hunting trophies",
    [57442] = "lost in the desiccation",
    [57444] = "an inspired moral inventory",
    [60517] = "the toll of the road",
    [57446] = "the enemy you know",
    [57447] = "purity's prerogative",
    [60519] = "audience with the winter queen",
    [60520] = "nightmares manifest",
    [60521] = "call of the hunt",
    [58473] = "echoes of tirna noch",
    [60522] = "return to tirna vaal",
    [58480] = "read the roots",
    [58483] = "mementos",
    [58484] = "take what you can",
    [57460] = "tubbins's tea",
    [57461] = "an uneventful stroll",
    [58486] = "he's drust in the way",
    [62584] = "frontline resupply",
    [58488] = "go for the heart",
    [60542] = "nathanos blightcaller",
    [57471] = "it's a dirty job",
    [59520] = "plaguefall: knee deep in it",
    [60545] = "shadowlands: a chilling summons",
    [62594] = "the safety of others",
    [57474] = "dredger duty",
    [62595] = "the safety of others",
    [57477] = "we're gonna need a bigger dredger",
    [57481] = "running a muck",
    [62605] = "broker business",
    [60557] = "first time? you have to fight!",
    [60563] = "tending to wildseeds",
    [60566] = "into the light",
    [60567] = "shooing wildlife",
    [60568] = "temp maw run",
    [51355] = "secretest fish",
    [58524] = "sparkles rain from above",
    [60572] = "for the sake of spirit",
    [60575] = "belly full of fae",
    [60577] = "hungry for animacones",
    [59554] = "a fine journey",
    [60578] = "visions of the dreamer: the betrayal",
    [57507] = "her story",
    [57511] = "arms for the poor",
    [57512] = "walk among death",
    [57513] = "enemy of my enemy",
    [57514] = "the first act of war",
    [57515] = "the house of the chosen",
    [57516] = "through the fire and flames",
    [60594] = "one special spirit",
    [62644] = "lfgdungeons - sl - normal random - 1st",
    [62645] = "lfgdungeons - sl - normal random - nth",
    [57525] = "those who death forgot",
    [57526] = "hungry for more",
    [60600] = "preparing for the winter queen",
    [57529] = "garden in turmoil",
    [57531] = "an unfortunate situation",
    [57532] = "foraging for fragments",
    [57533] = "light punishment",
    [62654] = "maw walker",
    [57534] = "when only ash remains",
    [57535] = "escaping the master",
    [57536] = "mirror making, not breaking",
    [57537] = "covering our tracks",
    [62658] = "shadowlands dungeon reward quest",
    [57538] = "disturbing the peace",
    [57539] = "first to market",
    [57545] = "distractions for kala",
    [57547] = "a test of courage",
    [57549] = "in agthia's memory",
    [60621] = "enemies at the gates",
    [57551] = "agthia's path",
    [58575] = "stuff we all get",
    [57552] = "warriors of the void",
    [60624] = "ride to heartwood grove",
    [57553] = "on wounded wings",
    [57554] = "wicked gateways",
    [57555] = "shadow's fall",
    [60628] = "the missing hunters",
    [59604] = "takin' down the beast",
    [60629] = "extreme recycling",
    [59605] = "takin' down the beast",
    [60630] = "totem eclipse",
    [60631] = "big problem, little vorkai",
    [59607] = "takin' down the beast",
    [60632] = "i know your face",
    [60637] = "the end of former friends",
    [58589] = "the restless dreamer",
    [60638] = "recovering wildseeds",
    [58590] = "visions of the dreamer: origins",
    [60639] = "heart of the grove",
    [58591] = "despoilers",
    [57568] = "tough love",
    [59616] = "army of one",
    [58592] = "caring for the caretakers",
    [58593] = "end of the dream",
    [57571] = "moving mirrors",
    [60644] = "draw out the darkness",
    [60645] = "gargantuan seeker",
    [59621] = "breaking a few eggs",
    [59622] = "tending to the tenders",
    [59623] = "what a buzzkill",
    [60647] = "recovering the animacones",
    [60648] = "survivors of heartwood grove",
    [60650] = "captain exposition says...",
    [62704] = "the threads of fate",
    [57584] = "a fate most noble",
    [62705] = "scour the temple",
    [62707] = "the elysian fields",
    [60661] = "dying dreams",
    [62712] = "war of attrition",
    [58616] = "forging a champion",
    [58617] = "maintaining order",
    [62714] = "a gift for an acolyte",
    [58618] = "ossein enchantment",
    [62715] = "more than a gift",
    [58619] = "read between the lines",
    [62716] = "re-introductions",
    [58620] = "slaylines",
    [60669] = "cause for distraction",
    [58621] = "repeat after me",
    [60670] = "return of the crusade",
    [62718] = "hero's rest",
    [58622] = "secrets among the shelves",
    [58623] = "a complete set",
    [60671] = "the sacrifices we must make",
    [62720] = "the fallen tree",
    [62721] = "deconstructing the problem",
    [58625] = "connecting the dots",
    [62723] = "bolstering bastion",
    [59656] = "well, tell the lady",
    [62729] = "return to oribos",
    [59657] = "voice of the arbiter",
    [62732] = "locus focus",
    [59662] = "nothing to drink!",
    [62735] = "hostile recollection",
    [62736] = "maldraxxi eviction notice",
    [62737] = "aspirant for a day",
    [62738] = "a fresh blade",
    [59666] = "ember court upgrade",
    [61715] = "request of the highlord",
    [62739] = "restoring balance",
    [59667] = "the ember court staff",
    [61716] = "a glimpse into darkness",
    [62740] = "dark aspirations",
    [62741] = "choice of action",
    [62742] = "avoid 'em like the plague",
    [62743] = "decaying situation",
    [59674] = "a friendly rivalry",
    [62748] = "rallying maldraxxus",
    [58654] = "a plea to the harvesters",
    [60709] = "recovering the heart",
    [61736] = "stolen away",
    [62761] = "return to oribos",
    [61737] = "stolen away",
    [62763] = "support the court",
    [57651] = "trouble in the banks",
    [57652] = "supplies needed: amber grease",
    [60724] = "heartless",
    [60725] = "field reports",
    [62773] = "dreamshrine basin",
    [57653] = "unsafe workplace",
    [62774] = "tranquil pools",
    [60727] = "a message from icecrown",
    [62775] = "the waning grove",
    [57655] = "supplies needed: more husks!",
    [62776] = "return to oribos",
    [57656] = "gifts of the forest",
    [57657] = "tied totem toter",
    [62778] = "reinforcing revendreth",
    [57658] = "the final leg",
    [62779] = "return to oribos",
    [62780] = "parasites of reality",
    [57660] = "the grove of creation",
    [62781] = "ash you like it",
    [60733] = "front and center",
    [62782] = "the banewood",
    [59710] = "a curious invitation",
    [62783] = "stalking fear",
    [60735] = "trouble in paradise",
    [62784] = "charlatans of ceremony",
    [60736] = "quest 02",
    [59712] = "the lay of the land",
    [62785] = "i could be a contender",
    [60737] = "the door to the unknown",
    [59713] = "active ingredients",
    [60738] = "the way to hibernal hollow",
    [59714] = "a fine vintage",
    [59715] = "message for matyas",
    [59716] = "comfortably numb",
    [57676] = "the things that haunt us",
    [59724] = "the field of honor",
    [57677] = "a soulbind in need",
    [59726] = "it's a trap",
    [62801] = "the call of fate",
    [57682] = "temple of wisdom",
    [59731] = "an expected guest",
    [57685] = "temple of purity",
    [60759] = "damned intruders",
    [62807] = "forest refugees",
    [60761] = "return of the scourge",
    [57689] = "prince renathal",
    [58714] = "the forest has eyes",
    [57690] = "cages for all occasions",
    [60763] = "i moustache you to lend a hand",
    [57691] = "a royal key",
    [60764] = "soothing song",
    [59740] = "repair and restore",
    [57692] = "prisoner transfers",
    [57693] = "torghast, tower of the damned",
    [60766] = "damned intruders",
    [57694] = "refuge of revendreth",
    [60767] = "return of the scourge",
    [58719] = "the droman's call",
    [58720] = "missing!",
    [58721] = "awaken the dreamer",
    [58723] = "the court of winter",
    [58724] = "the queen's request",
    [59750] = "how to get a head",
    [58726] = "thick skin",
    [59751] = "through the shattered sky",
    [59752] = "a fractured blade",
    [59753] = "ruiner's end",
    [59754] = "on blackened wings",
    [60778] = "wildseed rescue",
    [59755] = "a flight from darkness",
    [59756] = "a moment's respite",
    [59757] = "field seance",
    [57709] = "the aspirant's crucible",
    [59758] = "speaking to the dead",
    [57710] = "a life of service",
    [59759] = "the lion's cage",
    [57711] = "a forge gone cold",
    [59760] = "the afflictor's key",
    [57712] = "suggested reading",
    [59761] = "an undeserved fate",
    [57713] = "the work of one's hands",
    [59762] = "by and down the river",
    [57714] = "assessing your spirit",
    [57715] = "the archon's answer",
    [57716] = "a wayward disciple?",
    [59765] = "wounds beyond flesh",
    [57717] = "step back from that ledge, my friend",
    [59766] = "a good axe",
    [59767] = "the path to salvation",
    [57719] = "dangerous discourse",
    [59770] = "stand as one",
    [59772] = "research ruination",
    [57724] = "securing sinfall",
    [59773] = "seek the ascended",
    [59774] = "welcome to eternity",
    [58750] = "take the bull by the horns",
    [58751] = "a common peril",
    [59776] = "from the mouths of madness",
    [59781] = "the last guy",
    [59782] = "the deathspeaker's devout",
    [59783] = "cultist captors",
    [58771] = "directions not included",
    [59800] = "team spirit",
    [59801] = "take the power",
    [59802] = "the crumbling village",
    [60827] = "advancing the effort",
    [60828] = "a new foothold",
    [60831] = "fit for a margrave",
    [58785] = "smack and grab",
    [62882] = "setting the ground rules",
    [60839] = "remnants of the wild hunt",
    [60840] = "wild hunt offensive",
    [60841] = "evacuation effort",
    [58794] = "stabbing wasteward",
    [60843] = "cult couture",
    [61871] = "to current matters",
    [58799] = "the prime's directive",
    [61872] = "to current matters",
    [58800] = "the mnemonic locus",
    [61874] = "shadowlands: a chilling summons",
    [57779] = "mount up",
    [60856] = "toppling the brute",
    [60857] = "we can't save them all",
    [57787] = "keep to the path",
    [60859] = "souls of the forest",
    [60861] = "secrets in shadows",
    [59837] = "working for the living",
    [59838] = "scourge war machines",
    [59839] = "warning: this is only a test!",
    [60867] = "a message from above",
    [60869] = "with hope in hand",
    [58821] = "glorious pursuits",
    [59846] = "finders-keepers, sinners-weepers",
    [60871] = "with hope in hand",
    [59847] = "defending the rampart",
    [59851] = "frozen solid",
    [60881] = "ride of the wild hunt",
    [60886] = "the seat of the primus",
    [59863] = "combat nullifier 07-x",
    [57816] = "dreamweaver",
    [60889] = "favor: she had a stone heart",
    [57818] = "nothing goes to waste",
    [58843] = "the vault of the archon",
    [57820] = "diplomatic relations",
    [59868] = "offer of freedom",
    [57821] = "keeping the peace",
    [57824] = "collection day",
    [57825] = "delivery for guardian kota",
    [59874] = "the maw",
    [54755] = "not my table",
    [59876] = "field reports",
    [60900] = "archival protection",
    [59877] = "a message from icecrown",
    [60901] = "passage to hibernal hollow",
    [59878] = "too many whelps",
    [59879] = "this thing of ours",
    [60905] = "infusing the wildseed",
    [59882] = "sure bet",
    [58869] = "battle for hibernal hollow",
    [59897] = "seeking the baron",
    [56829] = "bottom feeders",
    [59903] = "split blob test",
    [59907] = "mawsworn menace",
    [60932] = "only shadows remain",
    [57865] = "ages-echoing wisdom",
    [59914] = "fear to tread",
    [57866] = "idle hands",
    [59915] = "soul in hand",
    [57867] = "the sweat of our brow",
    [57868] = "craftsman needs no tools",
    [59917] = "kill them, of course",
    [57869] = "spirit-gathering labor",
    [57870] = "the games we play",
    [57871] = "outplayed",
    [59920] = "light the forge, forgelite",
    [57872] = "bring more friends!",
    [58900] = "a sure bet",
    [58916] = "dread priming",
    [60972] = "the hunt for the baron",
    [62000] = "choosing your purpose",
    [58931] = "inquisitor stelia's sinstone",
    [57908] = "the true crucible awaits",
    [58932] = "temel, the sin herald",
    [57909] = "assessing your stamina",
    [59959] = "the brand holds the key",
    [57912] = "baron of the chosen",
    [59960] = "a cooling trail",
    [58936] = "beast control",
    [63034] = "the elysian fields",
    [59962] = "hope never dies",
    [63035] = "a fresh blade",
    [63036] = "restoring balance",
    [63037] = "dark aspirations",
    [58941] = "alpha bat",
    [59966] = "delving deeper",
    [57918] = "the absolution of souls",
    [57919] = "an abuse of power",
    [57920] = "the proper souls",
    [57921] = "the proper tools",
    [57922] = "the proper punishment",
    [58947] = "test your mettle",
    [57923] = "ritual of absolution",
    [57924] = "ritual of judgment",
    [59973] = "a bond beyond death",
    [57925] = "archivist fane",
    [59974] = "a soul saved",
    [57926] = "the sinstone archive",
    [57927] = "rebuilding temel",
    [57928] = "atonement crypt key",
    [57929] = "hunting an inquisitor",
    [58954] = "[ph] catch!",
    [57931] = "phalynx malfunction",
    [57932] = "resource drain",
    [57933] = "we can rebuild him",
    [57934] = "combat drills",
    [57935] = "laser location",
    [57936] = "superior programming",
    [57937] = "tactical formation",
    [59986] = "wide worlds of catalysts",
    [59994] = "trust fall",
    [57947] = "spirits of the glen",
    [63068] = "settling disputes",
    [57948] = "nothing left to give",
    [57949] = "they need to calm down",
    [57950] = "mizik the haughty",
    [57951] = "souls come home",
    [58976] = "chasing a memory",
    [57952] = "in need of gorm gris",
    [58977] = "what's in a memory?",
    [58978] = "lysonia's truth",
    [60003] = "a valiant effort",
    [58979] = "i made you!",
    [60004] = "a valiant effort",
    [58980] = "mnemis, at your service",
    [60005] = "imminent danger",
    [60006] = "now or never",
    [60007] = "stay scrappy",
    [60008] = "rip and tear",
    [60009] = "fight another day",
    [60013] = "leave it to mnemis",
    [56942] = "on the road again",
    [60020] = "an opportunistic strike",
    [58996] = "abel's fate",
    [60021] = "champion the cause",
    [62072] = "familiar faces",
    [57976] = "lead by example",
    [57977] = "a temple in need",
    [57979] = "offensive behavior",
    [61051] = "the absent-minded artisan",
    [56955] = "rebels on the road",
    [62077] = "to the chase",
    [57982] = "breaking down barriers",
    [57983] = "archon save us",
    [57984] = "the ones in charge",
    [59009] = "her rightful place",
    [57985] = "give them a hand",
    [57986] = "a burden worth bearing",
    [57987] = "a deadly distraction",
    [59011] = "in death we are truly tested",
    [62085] = "...why me?",
    [59014] = "king of the hill",
    [59015] = "hostile recollection",
    [57993] = "two of them, two of us",
    [57994] = "in the flesh",
    [59021] = "herald their demise",
    [59023] = "ending the inquisitor",
    [59025] = "straight to the heart",
    [56978] = "to darkhaven",
    [60052] = "double tap",
    [60053] = "clear as crystal",
    [60054] = "the final countdown",
    [60055] = "a time for courage",
    [60056] = "follow the path",
    [60057] = "necrotic wake: a paragon's plight",
    [58011] = "bug bites",
    [60060] = "mirror attunement: pridefall hamlet",
    [54943] = "the dark ranger's pupil",
    [61087] = "delayed delivery: old gate parcel",
    [54944] = "the dark ranger's pupil",
    [58016] = "spores galore",
    [58021] = "one big problem",
    [58022] = "finish what he started",
    [58023] = "one big problem",
    [61096] = "the arbiter's will",
    [58024] = "burrows away",
    [58025] = "queen of the underground",
    [58026] = "when a gorm eats a god",
    [58027] = "slime, anyone?",
    [58031] = "applied science",
    [57007] = "invitation of the master",
    [61107] = "a land of strife",
    [58036] = "hazardous waste collection",
    [58037] = "part of the pride",
    [58038] = "all natural chews",
    [58039] = "larion at large",
    [61112] = "a hunger for flesh",
    [58040] = "with lance and larion",
    [58041] = "providing for the pack",
    [61114] = "a hunger for flesh",
    [58042] = "on larion wings",
    [58045] = "plague is thicker than water",
    [57025] = "a plea to revendreth",
    [57026] = "the sinstone",
    [59076] = "the minions of mayhem",
    [54986] = "vision of n'zoth reward",
    [62157] = "scouting from a safe distance",
    [57037] = "a once sweet sound",
    [62159] = "aiding the shadowlands",
    [60113] = "an urgent request",
    [62162] = "a message from the justicar",
    [60115] = "an urgent request",
    [62163] = "a message from the justicar",
    [60116] = "cause for distraction",
    [58068] = "...even the most ridiculous request!",
    [60117] = "return of the crusade",
    [62165] = "tal-inara's call",
    [58069] = "favor: the venthyr diaries",
    [62166] = "tal-inara's call",
    [58070] = "favor: soul hunter blade",
    [58071] = "favor: vial of dredger muck",
    [62168] = "bonescript dispatches",
    [58072] = "favor: petrified stonefiend",
    [58073] = "favor: portrait of the sire",
    [62170] = "you'll never walk alone",
    [58074] = "favor: ledger of souls",
    [58075] = "favor: dredger's toolkit",
    [58077] = "favor: perfected hand mirror",
    [58078] = "favor: bottle of redelav wine",
    [60127] = "missing stone fiend",
    [58079] = "favor: pristine dredbat fang",
    [60128] = "ready to serve",
    [58080] = "favor: glittering primrose necklace",
    [60129] = "stranger in an even stranger land",
    [58081] = "favor: love and terror",
    [62182] = "a letter from nadja",
    [62183] = "a leaking box marked perishable",
    [63208] = "the next step",
    [58088] = "juicing up",
    [62184] = "a crate of synvir ore",
    [62185] = "fighting for attention",
    [63209] = "furthering the purpose",
    [63210] = "the last step",
    [58090] = "side effects",
    [62186] = "swollen anima seed",
    [62187] = "satchel of culexwood",
    [58092] = "halls of atonement: your absolution",
    [58093] = "our forgotten purpose",
    [62189] = "parasol components",
    [60147] = "mirror attunement: the eternal terrace",
    [60148] = "no place for the living",
    [60149] = "audience with the arbiter",
    [60150] = "tether to home",
    [60151] = "a doorway through the veil",
    [58103] = "pride or unit",
    [60152] = "the eternal city",
    [62200] = "functioning anima core",
    [60154] = "understanding the shadowlands",
    [59130] = "the house of plagues",
    [60156] = "the path to bastion",
    [60159] = "mirror attunement: halls of atonement",
    [60160] = "mirror attunement: the banewood",
    [60164] = "mirror attunement: dominance keep",
    [60165] = "mirror attunement: feeders' thicket",
    [61190] = "wake of ashes",
    [60169] = "securing the area",
    [57098] = "the grove of terror",
    [59147] = "the hand of purification",
    [57099] = "a dreadful roundup",
    [57100] = "feeding time is over",
    [57102] = "pardon our dust",
    [58127] = "inquisitor sinstone",
    [60176] = "bring out your tithe",
    [58128] = "high inquisitor sinstone",
    [62225] = "bursting the bubble",
    [60177] = "reason for the treason",
    [58129] = "grand inquisitor sinstone",
    [60178] = "and then there were none",
    [60179] = "memory of honor",
    [60180] = "a paragon's reflection",
    [60181] = "trench warfare",
    [60189] = "we strike now",
    [60190] = "assault on darkreach",
    [60191] = "ingra drif",
    [58143] = "a maldraxxian promenade",
    [60192] = "their last line of defense",
    [60193] = "unmasked",
    [60194] = "the call of the hunt",
    [59171] = "prey upon them",
    [59172] = "war is deception",
    [57125] = "time to reflect",
    [62246] = "a fallen friend",
    [62250] = "a new adventure awaits",
    [57131] = "let the hunt begin",
    [57136] = "the penitent hunt",
    [59185] = "entangling web",
    [58161] = "forest disappearances",
    [58162] = "mysterious masks",
    [62259] = "anima-laden dreamcatcher",
    [58163] = "a desperate solution",
    [59188] = "vaunted vengeance",
    [58164] = "cult of personality",
    [58165] = "cut the roots",
    [62262] = "fungal feeding",
    [59190] = "seek your mark",
    [58166] = "unknown assailants",
    [62265] = "a new adventure awaits",
    [60217] = "the archon's answer",
    [60218] = "the archon's answer",
    [60219] = "the archon's answer",
    [60220] = "the archon's answer",
    [59196] = "go in service",
    [60221] = "the archon's answer",
    [59197] = "steward at work",
    [58174] = "all an aspirant can do",
    [60222] = "the archon's answer",
    [59198] = "on swift wings",
    [60223] = "the archon's answer",
    [59199] = "kyrestia, the firstborne",
    [60224] = "the archon's answer",
    [59200] = "the wards of bastion",
    [60225] = "the archon's answer",
    [60226] = "the archon's answer",
    [59202] = "among the chosen",
    [62275] = "bastion",
    [59203] = "leave me a loan",
    [57156] = "blinding the eye",
    [62277] = "ardenweald",
    [60229] = "the archon's answer",
    [62278] = "maldraxxus",
    [59206] = "words of the primus",
    [62279] = "revendreth",
    [57159] = "a reflection of truth",
    [58184] = "antiquated methodology",
    [58185] = "success without soul",
    [57161] = "i don't get my hands dirty",
    [59209] = "rebel reinforcements",
    [59210] = "tainted cores",
    [60235] = "newfound power",
    [59211] = "forgotten village",
    [57164] = "devour this",
    [62292] = "pitch black scourgestones",
    [62293] = "darkened scourgestones",
    [57173] = "the accuser's sinstone",
    [57174] = "the stoneborn",
    [62295] = "cleaning out the vault",
    [59223] = "by any other name",
    [57175] = "inquisitor vilhelm's sinstone",
    [57176] = "sinstone delivery",
    [57177] = "a fresh start",
    [57178] = "the master awaits",
    [57179] = "the authority of revendreth",
    [57180] = "the accuser's secret",
    [62301] = "classic 50",
    [57181] = "rebellion",
    [62302] = "classic 50",
    [57182] = "the accuser's fate",
    [62303] = "classic 50",
    [59231] = "fathomless power",
    [59232] = "a lesson in humility",
    [57185] = "dutybound",
    [57189] = "breaking the hopebreakers",
    [57190] = "they won't know what hit them",
    [60276] = "wanted: summoner marcelis",
    [60277] = "wanted: aggregate of doom",
    [59256] = "the fearstalker",
    [60286] = "a token of our admiration",
    [60287] = "rule 1: have an escape plan",
    [60289] = "rule 3: trust is earned",
    [60292] = "dangerous discourse",
    [60296] = "pride or unit",
    [57228] = "the assault on dredhollow",
    [62351] = "classic 50",
    [62352] = "classic 50",
    [58261] = "what's the grub",
    [58264] = "wake up, get up, get out there",
    [57240] = "where is prince renathal?",
    [58265] = "blooming villains",
    [60313] = "dredhollow",
    [58266] = "break it down",
    [60315] = "wanted: gorgebeak",
    [58267] = "beneath the mask",
    [60316] = "wanted: altered sentinel",
    [58268] = "take the high ground",
    [62365] = "careful creations",
    [57245] = "ani-matter animator",
    [58272] = "words have power",
    [62371] = "tirna scithe: a warning silence",
    [61355] = "rule 2: keep a low profile",
    [57261] = "walk the path, aspirant",
    [57263] = "the cycle of anima: etherwyrms",
    [57264] = "on the edge of a revelation",
    [57265] = "the cycle of anima: drought conditions",
    [57266] = "the first cleansing",
    [60338] = "journey to ardenweald",
    [57267] = "the cycle of anima: flower power",
    [60339] = "the ember court",
    [57269] = "the hand of doubt",
    [60341] = "first on the agenda",
    [57270] = "the temple of purity",
    [57278] = "bring me their heads",
    [59327] = "in the ruin of rebellion",
    [62401] = "strange scourgestones",
    [57284] = "blade of blades",
    [57288] = "assessing your strength",
    [57291] = "the chamber of first reflection",
    [60366] = "wanted: darkwing",
    [61391] = "the eye of the jailer",
    [57316] = "the ladder",
    [58351] = "the hills have eyes",
    [61432] = "lost journals",
}

addonTable.questNames = {
    ["unmasked"] = true,
    ["juicing up"] = true,
    ["tal-inara's call"] = true,
    ["mirror attunement: pridefall hamlet"] = true,
    ["to darkhaven"] = true,
    ["stuff we all get"] = true,
    ["arms for the poor"] = true,
    ["pardon our dust"] = true,
    ["cult of personality"] = true,
    ["maldraxxi eviction notice"] = true,
    ["...why me?"] = true,
    ["a token of our admiration"] = true,
    ["sparkles rain from above"] = true,
    ["if you want peace..."] = true,
    ["ossein enchantment"] = true,
    ["all an aspirant can do"] = true,
    ["seek your mark"] = true,
    ["one special spirit"] = true,
    ["a crate of synvir ore"] = true,
    ["the waning grove"] = true,
    ["moving mirrors"] = true,
    ["front and center"] = true,
    ["from a dark place"] = true,
    ["the work of one's hands"] = true,
    ["maintaining order"] = true,
    ["the cycle of anima: etherwyrms"] = true,
    ["where is prince renathal?"] = true,
    ["combat drills"] = true,
    ["spores galore"] = true,
    ["rebel reinforcements"] = true,
    ["devour this"] = true,
    ["the absent-minded artisan"] = true,
    ["the safety of others"] = true,
    ["break it down"] = true,
    ["a fresh start"] = true,
    ["blade of blades"] = true,
    ["shadow's fall"] = true,
    ["wounds beyond flesh"] = true,
    ["only shadows remain"] = true,
    ["larion at large"] = true,
    ["in the ruin of rebellion"] = true,
    ["deconstructing the problem"] = true,
    ["setting the ground rules"] = true,
    ["on the road again"] = true,
    ["temp maw run"] = true,
    ["the field of honor"] = true,
    ["the grove of terror"] = true,
    ["in the flesh"] = true,
    ["to current matters"] = true,
    ["breaking a few eggs"] = true,
    ["they won't know what hit them"] = true,
    ["strange scourgestones"] = true,
    ["the last guy"] = true,
    ["mnemis, at your service"] = true,
    ["let the hunt begin"] = true,
    ["wild hunt offensive"] = true,
    ["an unfortunate situation"] = true,
    ["speaking to the dead"] = true,
    ["vaunted vengeance"] = true,
    ["toppling the brute"] = true,
    ["the brand holds the key"] = true,
    ["delving deeper"] = true,
    ["the sacrifices we must make"] = true,
    ["tough love"] = true,
    ["baron of the chosen"] = true,
    ["ritual of judgment"] = true,
    ["temple of purity"] = true,
    ["secretest fish"] = true,
    ["leave it to mnemis"] = true,
    ["when a gorm eats a god"] = true,
    ["breaking down barriers"] = true,
    ["seeking the baron"] = true,
    ["dredhollow"] = true,
    ["keeping the peace"] = true,
    ["mirror attunement: feeders' thicket"] = true,
    ["bring more friends!"] = true,
    ["the house of plagues"] = true,
    ["mirror attunement: the banewood"] = true,
    ["test your mettle"] = true,
    ["we need more power"] = true,
    ["the eternal city"] = true,
    ["revendreth"] = true,
    ["quest 02"] = true,
    ["glorious pursuits"] = true,
    ["an opportunistic strike"] = true,
    ["hostile recollection"] = true,
    ["we strike now"] = true,
    ["double tap"] = true,
    ["follow the path"] = true,
    ["tirna scithe: a warning silence"] = true,
    ["atonement crypt key"] = true,
    ["the fearstalker"] = true,
    ["ani-matter animator"] = true,
    ["unknown assailants"] = true,
    ["the proper punishment"] = true,
    ["delaying their efforts"] = true,
    ["offensive behavior"] = true,
    ["pitch black scourgestones"] = true,
    ["the things that haunt us"] = true,
    ["the sinstone"] = true,
    ["locus focus"] = true,
    ["enemies at the gates"] = true,
    ["familiar faces"] = true,
    ["mount up"] = true,
    ["connecting the dots"] = true,
    ["hope never dies"] = true,
    ["vision of n'zoth reward"] = true,
    ["a rousing aroma"] = true,
    ["with hope in hand"] = true,
    ["a plea to revendreth"] = true,
    ["applied science"] = true,
    ["nothing to drink!"] = true,
    ["give them a hand"] = true,
    ["dreamshrine basin"] = true,
    ["mount up test"] = true,
    ["secrets among the shelves"] = true,
    ["your personal assistant"] = true,
    ["the house of the chosen"] = true,
    ["archon save us"] = true,
    ["return to oribos"] = true,
    ["superior programming"] = true,
    ["trust fall"] = true,
    ["on swift wings"] = true,
    ["burrows away"] = true,
    ["the stoneborn"] = true,
    ["in death we are truly tested"] = true,
    ["reason for the treason"] = true,
    ["a good axe"] = true,
    ["careful creations"] = true,
    ["ardenweald"] = true,
    ["a valiant effort"] = true,
    ["the missing hunters"] = true,
    ["trench warfare"] = true,
    ["gifts of the forest"] = true,
    ["the vault of the archon"] = true,
    ["lfgdungeons - sl - normal random - 1st"] = true,
    ["visions of the dreamer: the betrayal"] = true,
    ["secrets in shadows"] = true,
    ["our forgotten purpose"] = true,
    ["the arbiter's will"] = true,
    ["souls of the forest"] = true,
    ["what a buzzkill"] = true,
    ["finders-keepers, sinners-weepers"] = true,
    ["favor: pristine dredbat fang"] = true,
    ["visions of the dreamer: origins"] = true,
    ["slaylines"] = true,
    ["stalking fear"] = true,
    ["lost in the desiccation"] = true,
    ["archivist fane"] = true,
    ["a common peril"] = true,
    ["combat nullifier 07-x"] = true,
    ["darkened scourgestones"] = true,
    ["the wards of bastion"] = true,
    ["take what you can"] = true,
    ["straight to the heart"] = true,
    ["safe in the shadows"] = true,
    ["read the roots"] = true,
    ["favor: vial of dredger muck"] = true,
    ["satchel of culexwood"] = true,
    ["the court of winter"] = true,
    ["more than a gift"] = true,
    ["the call of fate"] = true,
    ["we can't save them all"] = true,
    ["the way to hibernal hollow"] = true,
    ["fit for a margrave"] = true,
    ["the first act of war"] = true,
    ["through the shattered sky"] = true,
    ["a cooling trail"] = true,
    ["wicked gateways"] = true,
    ["chasing madness"] = true,
    ["nothing goes to waste"] = true,
    ["dreamweaver"] = true,
    ["survivors of heartwood grove"] = true,
    ["the droman's call"] = true,
    ["anima-laden dreamcatcher"] = true,
    ["favor: glittering primrose necklace"] = true,
    ["the sweat of our brow"] = true,
    ["choice of action"] = true,
    ["ruiner's end"] = true,
    ["a sure bet"] = true,
    ["the cycle of anima: drought conditions"] = true,
    ["mirror attunement: halls of atonement"] = true,
    ["dredger duty"] = true,
    ["unbearable light"] = true,
    ["i know your face"] = true,
    ["bastion"] = true,
    ["on the edge of a revelation"] = true,
    ["missing stone fiend"] = true,
    ["stranger in an even stranger land"] = true,
    ["slime, anyone?"] = true,
    ["a leaking box marked perishable"] = true,
    ["bug bites"] = true,
    ["an uneventful stroll"] = true,
    ["the mnemonic locus"] = true,
    ["heartless"] = true,
    ["shadowlands dungeon reward quest"] = true,
    ["take the power"] = true,
    ["a doorway through the veil"] = true,
    ["light punishment"] = true,
    ["directions not included"] = true,
    ["it used to be quiet here"] = true,
    ["the ladder"] = true,
    ["recovering the heart"] = true,
    ["aiding the shadowlands"] = true,
    ["remnants of the wild hunt"] = true,
    ["dark aspirations"] = true,
    ["distractions for kala"] = true,
    ["the sinstone archive"] = true,
    ["a friendly rivalry"] = true,
    ["the archon's answer"] = true,
    ["stabbing wasteward"] = true,
    ["plague is thicker than water"] = true,
    ["tubbins's tea"] = true,
    ["stay scrappy"] = true,
    ["support the court"] = true,
    ["rip and tear"] = true,
    ["hero's rest"] = true,
    ["grand inquisitor sinstone"] = true,
    ["advancing the effort"] = true,
    ["army of one"] = true,
    ["settling disputes"] = true,
    ["a test of courage"] = true,
    ["a maldraxxian promenade"] = true,
    ["the threads of fate"] = true,
    ["mirror attunement: the eternal terrace"] = true,
    ["favor: portrait of the sire"] = true,
    ["temel, the sin herald"] = true,
    ["inquisitor sinstone"] = true,
    ["a plea to the harvesters"] = true,
    ["wake up, get up, get out there"] = true,
    ["refuge of revendreth"] = true,
    ["the proper tools"] = true,
    ["dutybound"] = true,
    ["bursting the bubble"] = true,
    ["wanted: summoner marcelis"] = true,
    ["blooming villains"] = true,
    ["take the high ground"] = true,
    ["the authority of revendreth"] = true,
    ["split blob test"] = true,
    ["collection day"] = true,
    ["for the sake of spirit"] = true,
    ["her rightful place"] = true,
    ["the enemy you know"] = true,
    ["the accuser"] = true,
    ["diplomatic relations"] = true,
    ["sign your own death warrant"] = true,
    ["fight another day"] = true,
    ["nothing left to give"] = true,
    ["the toll of the road"] = true,
    ["wildseed rescue"] = true,
    ["feeding time is over"] = true,
    ["captain exposition says..."] = true,
    ["a wayward disciple?"] = true,
    ["seek the ascended"] = true,
    ["words have power"] = true,
    ["decaying situation"] = true,
    ["breaking the hopebreakers"] = true,
    ["craftsman needs no tools"] = true,
    ["choosing your purpose"] = true,
    ["inquisitor vilhelm's sinstone"] = true,
    ["purity's prerogative"] = true,
    ["understanding the shadowlands"] = true,
    ["a royal key"] = true,
    ["rubble rummaging"] = true,
    ["sure bet"] = true,
    ["kill them, of course"] = true,
    ["cleaning out the vault"] = true,
    ["by and down the river"] = true,
    ["forest refugees"] = true,
    ["the path to salvation"] = true,
    ["forging a champion"] = true,
    ["prince renathal"] = true,
    ["lead by example"] = true,
    ["hungry for animacones"] = true,
    ["a curious invitation"] = true,
    ["hunting trophies"] = true,
    ["they need to calm down"] = true,
    ["cages for all occasions"] = true,
    ["an abuse of power"] = true,
    ["repeat after me"] = true,
    ["cultist captors"] = true,
    ["cult couture"] = true,
    ["i made you!"] = true,
    ["the final countdown"] = true,
    ["the door to the unknown"] = true,
    ["the absolution of souls"] = true,
    ["echoes of tirna noch"] = true,
    ["we're gonna need a bigger dredger"] = true,
    ["idle hands"] = true,
    ["the accuser's fate"] = true,
    ["meet the margrave"] = true,
    ["ember court upgrade"] = true,
    ["a dreadful roundup"] = true,
    ["assessing your strength"] = true,
    ["war is deception"] = true,
    ["a temple in need"] = true,
    ["lysonia's truth"] = true,
    ["a message from above"] = true,
    ["this thing of ours"] = true,
    ["king of the hill"] = true,
    ["the path to glory"] = true,
    ["foraging for fragments"] = true,
    ["what's in a memory?"] = true,
    ["a gift for an acolyte"] = true,
    ["land of opportunity"] = true,
    ["favor: petrified stonefiend"] = true,
    ["a reflection of truth"] = true,
    ["assault on darkreach"] = true,
    ["forest disappearances"] = true,
    ["what's old is new"] = true,
    ["blinding the eye"] = true,
    ["wake of ashes"] = true,
    ["into the light"] = true,
    ["evacuation effort"] = true,
    ["words of the primus"] = true,
    ["setting sabina free"] = true,
    ["warriors of the void"] = true,
    ["a desperate solution"] = true,
    ["in need of gorm gris"] = true,
    ["maw walker"] = true,
    ["first on the agenda"] = true,
    ["tactical formation"] = true,
    ["favor: ledger of souls"] = true,
    ["totem eclipse"] = true,
    ["a message from the justicar"] = true,
    ["a life of service"] = true,
    ["a fine vintage"] = true,
    ["lfgdungeons - sl - normal random - nth"] = true,
    ["the afflictor's key"] = true,
    ["the call of the hunt"] = true,
    ["the hand of purification"] = true,
    ["war of attrition"] = true,
    ["steward at work"] = true,
    ["agthia's path"] = true,
    ["a plague on your house"] = true,
    ["a fresh blade"] = true,
    ["a land of strife"] = true,
    ["the prime's directive"] = true,
    ["a flight from darkness"] = true,
    ["those who death forgot"] = true,
    ["mirror attunement: dominance keep"] = true,
    ["a fate most noble"] = true,
    ["the end of former friends"] = true,
    ["how to get a head"] = true,
    ["not my job"] = true,
    ["nathanos blightcaller"] = true,
    ["hazardous waste collection"] = true,
    ["plaguefall: knee deep in it"] = true,
    ["through the fire and flames"] = true,
    ["field reports"] = true,
    ["soothing song"] = true,
    ["mizik the haughty"] = true,
    ["cause for distraction"] = true,
    ["clear as crystal"] = true,
    ["takin' down the beast"] = true,
    ["tending to wildseeds"] = true,
    ["with lance and larion"] = true,
    ["the master awaits"] = true,
    ["the greatest duelist"] = true,
    ["scour the temple"] = true,
    ["a soulbind in need"] = true,
    ["read between the lines"] = true,
    ["parasol components"] = true,
    ["fungal feeding"] = true,
    ["side effects"] = true,
    ["the first cleansing"] = true,
    ["wanted: altered sentinel"] = true,
    ["awaken the dreamer"] = true,
    ["mementos"] = true,
    ["i don't get my hands dirty"] = true,
    ["ritual of absolution"] = true,
    ["reinforcing revendreth"] = true,
    ["thick skin"] = true,
    ["now or never"] = true,
    ["the forest has eyes"] = true,
    ["working for the living"] = true,
    ["among the chosen"] = true,
    ["no wisp left behind"] = true,
    ["infusing the wildseed"] = true,
    ["the lost of teldrassil"] = true,
    ["welcome to eternity"] = true,
    ["the hunt for the baron"] = true,
    ["too many whelps"] = true,
    ["re-introductions"] = true,
    ["a new foothold"] = true,
    ["call of the hunt"] = true,
    ["beneath the mask"] = true,
    ["their last line of defense"] = true,
    ["the blade of the primus"] = true,
    ["favor: dredger's toolkit"] = true,
    ["a fractured blade"] = true,
    ["the elysian fields"] = true,
    ["invitation of the master"] = true,
    ["inquisitor stelia's sinstone"] = true,
    ["shooing wildlife"] = true,
    ["tainted cores"] = true,
    ["a forge gone cold"] = true,
    ["ingra drif"] = true,
    ["smack and grab"] = true,
    ["ending the inquisitor"] = true,
    ["on larion wings"] = true,
    ["fighting for attention"] = true,
    ["recovering wildseeds"] = true,
    ["spirit-gathering labor"] = true,
    ["when only ash remains"] = true,
    ["prey upon them"] = true,
    ["research ruination"] = true,
    ["the last step"] = true,
    ["the ember court"] = true,
    ["the maw"] = true,
    ["forgotten village"] = true,
    ["journey to ardenweald"] = true,
    ["rebellion"] = true,
    ["active ingredients"] = true,
    ["favor: love and terror"] = true,
    ["the games we play"] = true,
    ["wanted: gorgebeak"] = true,
    ["rule 3: trust is earned"] = true,
    ["battle for hibernal hollow"] = true,
    ["assessing your stamina"] = true,
    ["the true crucible awaits"] = true,
    ["sinstone delivery"] = true,
    ["the lay of the land"] = true,
    ["kyrestia, the firstborne"] = true,
    ["the crumbling village"] = true,
    ["enemy of my enemy"] = true,
    ["to the chase"] = true,
    ["a once sweet sound"] = true,
    ["end of the dream"] = true,
    ["favor: the venthyr diaries"] = true,
    ["audience with the winter queen"] = true,
    ["the chamber of first reflection"] = true,
    ["outplayed"] = true,
    ["wanted: darkwing"] = true,
    ["the accuser's secret"] = true,
    ["lost journals"] = true,
    ["nightmares manifest"] = true,
    ["securing the area"] = true,
    ["shadowlands: a chilling summons"] = true,
    ["mysterious masks"] = true,
    ["pride or unit"] = true,
    ["a soul saved"] = true,
    ["torghast, tower of the damned"] = true,
    ["a new adventure awaits"] = true,
    ["a bond beyond death"] = true,
    ["a time for courage"] = true,
    ["never enough"] = true,
    ["bolstering bastion"] = true,
    ["i moustache you to lend a hand"] = true,
    ["herald their demise"] = true,
    ["voice of the arbiter"] = true,
    ["warning: this is only a test!"] = true,
    ["a fine journey"] = true,
    ["the temple of purity"] = true,
    ["go for the heart"] = true,
    ["all natural chews"] = true,
    ["and then there were none"] = true,
    ["rebuilding temel"] = true,
    ["a complete set"] = true,
    ["tranquil pools"] = true,
    ["a letter from nadja"] = true,
    ["no place for the living"] = true,
    ["favor: soul hunter blade"] = true,
    ["an expected guest"] = true,
    ["first time? you have to fight!"] = true,
    ["the queen's request"] = true,
    ["covering our tracks"] = true,
    ["unsafe workplace"] = true,
    ["comfortably numb"] = true,
    ["ride of the wild hunt"] = true,
    ["darkshore donations: tidespray linen bandage"] = true,
    ["theotar's mission"] = true,
    ["queen of the underground"] = true,
    ["the lion's cage"] = true,
    ["alpha bat"] = true,
    ["extreme recycling"] = true,
    ["resource drain"] = true,
    ["bottom feeders"] = true,
    ["mirror making, not breaking"] = true,
    ["bonescript dispatches"] = true,
    ["tied totem toter"] = true,
    ["delivery for guardian kota"] = true,
    ["the next step"] = true,
    ["offer of freedom"] = true,
    ["an urgent request"] = true,
    ["light the forge, forgelite"] = true,
    ["champion the cause"] = true,
    ["belly full of fae"] = true,
    ["take the bull by the horns"] = true,
    ["furthering the purpose"] = true,
    ["providing for the pack"] = true,
    ["high inquisitor sinstone"] = true,
    ["the accuser's sinstone"] = true,
    ["supplies needed: more husks!"] = true,
    ["assessing your spirit"] = true,
    ["one big problem"] = true,
    ["walk among death"] = true,
    ["audience with the arbiter"] = true,
    ["pool of potions"] = true,
    ["an inspired moral inventory"] = true,
    ["a deadly distraction"] = true,
    ["parasites of reality"] = true,
    ["the restless dreamer"] = true,
    ["swollen anima seed"] = true,
    ["garden in turmoil"] = true,
    ["cut the roots"] = true,
    ["recovering the animacones"] = true,
    ["from the mouths of madness"] = true,
    ["escaping the master"] = true,
    ["securing sinfall"] = true,
    ["mawsworn menace"] = true,
    ["draw out the darkness"] = true,
    ["ride to heartwood grove"] = true,
    ["dread priming"] = true,
    ["the seat of the primus"] = true,
    ["the dark ranger's pupil"] = true,
    ["the assault on dredhollow"] = true,
    ["return of the scourge"] = true,
    ["keep to the path"] = true,
    ["spirits of the glen"] = true,
    ["my terrible morning"] = true,
    ["part of the pride"] = true,
    ["not my table"] = true,
    ["[ph] catch!"] = true,
    ["he's drust in the way"] = true,
    ["two of them, two of us"] = true,
    ["newfound power"] = true,
    ["passage to hibernal hollow"] = true,
    ["success without soul"] = true,
    ["first to market"] = true,
    ["halls of atonement: your absolution"] = true,
    ["necrotic wake: a paragon's plight"] = true,
    ["step back from that ledge, my friend"] = true,
    ["what's the grub"] = true,
    ["favor: bottle of redelav wine"] = true,
    ["...even the most ridiculous request!"] = true,
    ["damned intruders"] = true,
    ["suggested reading"] = true,
    ["running a muck"] = true,
    ["stand as one"] = true,
    ["return of the crusade"] = true,
    ["fear to tread"] = true,
    ["ash you like it"] = true,
    ["big problem, little vorkai"] = true,
    ["dangerous discourse"] = true,
    ["dying dreams"] = true,
    ["finish what he started"] = true,
    ["favor: perfected hand mirror"] = true,
    ["ready to serve"] = true,
    ["abel's fate"] = true,
    ["it's a dirty job"] = true,
    ["beast control"] = true,
    ["maldraxxus"] = true,
    ["rule 2: keep a low profile"] = true,
    ["the banewood"] = true,
    ["missing!"] = true,
    ["the fallen tree"] = true,
    ["prisoner transfers"] = true,
    ["stolen away"] = true,
    ["a message from icecrown"] = true,
    ["functioning anima core"] = true,
    ["tending to the tenders"] = true,
    ["charlatans of ceremony"] = true,
    ["restoring balance"] = true,
    ["her story"] = true,
    ["chasing a memory"] = true,
    ["the final leg"] = true,
    ["rebels on the road"] = true,
    ["the path to bastion"] = true,
    ["on wounded wings"] = true,
    ["the aspirant's crucible"] = true,
    ["despoilers"] = true,
    ["anima attrition"] = true,
    ["a hunger for flesh"] = true,
    ["a burden worth bearing"] = true,
    ["hunting an inquisitor"] = true,
    ["antiquated methodology"] = true,
    ["delayed delivery: old gate parcel"] = true,
    ["leave me a loan"] = true,
    ["walk the path, aspirant"] = true,
    ["well, tell the lady"] = true,
    ["i could be a contender"] = true,
    ["a paragon's reflection"] = true,
    ["the grove of creation"] = true,
    ["the hills have eyes"] = true,
    ["the ember court staff"] = true,
    ["imminent danger"] = true,
    ["the endmire"] = true,
    ["caring for the caretakers"] = true,
    ["field seance"] = true,
    ["supplies needed: amber grease"] = true,
    ["trouble in the banks"] = true,
    ["the proper souls"] = true,
    ["phalynx malfunction"] = true,
    ["scouting from a safe distance"] = true,
    ["rule 1: have an escape plan"] = true,
    ["the eye of the jailer"] = true,
    ["gargantuan seeker"] = true,
    ["the cycle of anima: flower power"] = true,
    ["tether to home"] = true,
    ["go in service"] = true,
    ["archival protection"] = true,
    ["defending the rampart"] = true,
    ["laser location"] = true,
    ["frontline resupply"] = true,
    ["preparing for the winter queen"] = true,
    ["a fallen friend"] = true,
    ["wide worlds of catalysts"] = true,
    ["in agthia's memory"] = true,
    ["the deathspeaker's devout"] = true,
    ["trouble in paradise"] = true,
    ["the penitent hunt"] = true,
    ["repair and restore"] = true,
    ["scourge war machines"] = true,
    ["we can rebuild him"] = true,
    ["by any other name"] = true,
    ["message for matyas"] = true,
    ["request of the highlord"] = true,
    ["disturbing the peace"] = true,
    ["entangling web"] = true,
    ["hungry for more"] = true,
    ["broker business"] = true,
    ["an undeserved fate"] = true,
    ["the minions of mayhem"] = true,
    ["frozen solid"] = true,
    ["on blackened wings"] = true,
    ["the banshee's champion"] = true,
    ["it's a trap"] = true,
    ["souls come home"] = true,
    ["the old ways"] = true,
    ["rallying maldraxxus"] = true,
    ["team spirit"] = true,
    ["classic 50"] = true,
    ["memory of honor"] = true,
    ["fathomless power"] = true,
    ["a moment's respite"] = true,
    ["you'll never walk alone"] = true,
    ["bring me their heads"] = true,
    ["to die by the sword"] = true,
    ["a glimpse into darkness"] = true,
    ["aspirant for a day"] = true,
    ["bring out your tithe"] = true,
    ["time to reflect"] = true,
    ["temple of wisdom"] = true,
    ["ages-echoing wisdom"] = true,
    ["favor: she had a stone heart"] = true,
    ["heart of the grove"] = true,
    ["a lesson in humility"] = true,
    ["the ones in charge"] = true,
    ["the hand of doubt"] = true,
    ["avoid 'em like the plague"] = true,
    ["wanted: aggregate of doom"] = true,
    ["soul in hand"] = true,
    ["return to tirna vaal"] = true,
}

addonTable.questItems = {
    [179719] = {
        ["count"] = 0,
        ["spellID"] = 329037,
        ["cooldown"] = 15
    },
    [183045] = {
        ["count"] = 0,
        ["spellID"] = 340484,
        ["cooldown"] = 3
    },
    [179978] = {
        ["count"] = 0,
        ["spellID"] = 329328,
        ["cooldown"] = 10
    },
    [171146] = {
        ["count"] = 0,
        ["spellID"] = 305824,
        ["cooldown"] = 15
    },
    [183689] = {
        ["count"] = 0,
        ["spellID"] = 342600,
        ["cooldown"] = nil
    },
    [179983] = {
        ["count"] = 0,
        ["spellID"] = 329337,
        ["cooldown"] = 10
    },
    [183698] = {
        ["count"] = 0,
        ["spellID"] = 340096,
        ["cooldown"] = nil
    },
    [174864] = {
        ["count"] = 0,
        ["spellID"] = 316914,
        ["cooldown"] = 4
    },
    [172950] = {
        ["count"] = 0,
        ["spellID"] = 309343,
        ["cooldown"] = 3
    },
    [174998] = {
        ["count"] = 0,
        ["spellID"] = 318045,
        ["cooldown"] = nil
    },
    [172955] = {
        ["count"] = 0,
        ["spellID"] = 310105,
        ["cooldown"] = 6
    },
    [180120] = {
        ["count"] = 0,
        ["spellID"] = 330485,
        ["cooldown"] = 5
    },
    [179359] = {
        ["count"] = 0,
        ["spellID"] = 328524,
        ["cooldown"] = 15
    },
    [174749] = {
        ["count"] = 0,
        ["spellID"] = 316317,
        ["cooldown"] = nil
    },
    [177835] = {
        ["count"] = 0,
        ["spellID"] = 323959,
        ["cooldown"] = 4
    },
    [173355] = {
        ["count"] = 0,
        ["spellID"] = 311385,
        ["cooldown"] = 6
    },
    [178994] = {
        ["count"] = 0,
        ["spellID"] = 328192,
        ["cooldown"] = nil
    },
    [175409] = {
        ["count"] = 0,
        ["spellID"] = 319892,
        ["cooldown"] = 5
    },
    [181174] = {
        ["count"] = 0,
        ["spellID"] = 335785,
        ["cooldown"] = 20
    },
    [182199] = {
        ["count"] = 0,
        ["spellID"] = 338502,
        ["cooldown"] = 5
    },
    [178873] = {
        ["count"] = 0,
        ["spellID"] = 327271,
        ["cooldown"] = 15
    },
    [174655] = {
        ["count"] = 0,
        ["spellID"] = 315988,
        ["cooldown"] = nil
    },
    [178495] = {
        ["count"] = 0,
        ["spellID"] = 326260,
        ["cooldown"] = nil
    },
    [176445] = {
        ["count"] = 0,
        ["spellID"] = 322065,
        ["cooldown"] = 4
    },
    [178496] = {
        ["count"] = 0,
        ["spellID"] = 326315,
        ["cooldown"] = 15
    },
    [179923] = {
        ["count"] = 0,
        ["spellID"] = 329690,
        ["cooldown"] = 8
    },
    [175827] = {
        ["count"] = 0,
        ["spellID"] = 306318,
        ["cooldown"] = 5
    },
    [179921] = {
        ["count"] = 0,
        ["spellID"] = 329074,
        ["cooldown"] = 2
    },
    [177877] = {
        ["count"] = 0,
        ["spellID"] = 324038,
        ["cooldown"] = 5
    },
    [174042] = {
        ["count"] = 0,
        ["spellID"] = 313053,
        ["cooldown"] = nil
    },
    [173534] = {
        ["count"] = 0,
        ["spellID"] = 311721,
        ["cooldown"] = 6
    },
    [171103] = {
        ["count"] = 0,
        ["spellID"] = 306069,
        ["cooldown"] = 15
    },
    [178140] = {
        ["count"] = 0,
        ["spellID"] = 325651,
        ["cooldown"] = 3
    },
    [172513] = {
        ["count"] = 0,
        ["spellID"] = 309460,
        ["cooldown"] = nil
    },
    [178150] = {
        ["count"] = 0,
        ["spellID"] = 325786,
        ["cooldown"] = nil
    },
    [181350] = {
        ["count"] = 0,
        ["spellID"] = 336178,
        ["cooldown"] = 30
    },
    [178791] = {
        ["count"] = 0,
        ["spellID"] = 327618,
        ["cooldown"] = 30
    },
    [172517] = {
        ["count"] = 0,
        ["spellID"] = 309678,
        ["cooldown"] = nil
    },
    [179958] = {
        ["count"] = 0,
        ["spellID"] = 321451,
        ["cooldown"] = 3
    },
    [172020] = {
        ["count"] = 0,
        ["spellID"] = 326069,
        ["cooldown"] = 5
    },
    [183797] = {
        ["count"] = 0,
        ["spellID"] = 342600,
        ["cooldown"] = nil
    },
    [184314] = {
        ["count"] = 0,
        ["spellID"] = 336010,
        ["cooldown"] = 8
    },
    [173691] = {
        ["count"] = 0,
        ["spellID"] = 310984,
        ["cooldown"] = nil
    },
    [184313] = {
        ["count"] = 0,
        ["spellID"] = 345180,
        ["cooldown"] = nil
    },
    [181497] = {
        ["count"] = 0,
        ["spellID"] = 336784,
        ["cooldown"] = nil
    },
    [174078] = {
        ["count"] = 0,
        ["spellID"] = 313712,
        ["cooldown"] = 10
    },
    [178940] = {
        ["count"] = 0,
        ["spellID"] = 327923,
        ["cooldown"] = 30
    },
    [173692] = {
        ["count"] = 0,
        ["spellID"] = 311792,
        ["cooldown"] = 10
    },
}
