local _, addonTable = ...

addonTable.data = {}
addonTable.data.innWhitelist = {

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

addonTable.data.questNameBlacklist = {}

addonTable.data.questIDBlacklist = {
    [62061] = true,  -- Prove Your Worth
    [62059] = true,  -- Prove Your Worth
    [62043] = true,  -- Prove Your Worth
    [62060] = true,  -- Prove Your Worth
    [62393] = true,  -- Rebuild Our Trust
    [62368] = true,  -- Rebuild Our Trust
    [62389] = true,  -- Rebuild Our Trust
    [62392] = true,  -- Rebuild Our Trust
    [60250] = true,  -- A Valuable Find: Theater of Pain
    [60251] = true,  -- A Valuable Find: Plaguefall
    [60252] = true,  -- A Valuable Find: Spires of Ascension
    [60253] = true,  -- A Valuable Find: Necrotic Wake
    [60254] = true,  -- A Valuable Find: Tirna Scithe
    [60255] = true,  -- A Valuable Find: De Other Side
    [60256] = true,  -- A Valuable Find: Halls of Atonement
    [60257] = true,  -- A Valuable Find: Sanguine Depths
}

addonTable.data.itemEquipLocToEquipSlot = {
    ["INVTYPE_AMMO"] = {0},
    ["INVTYPE_HEAD"] = {1},
    ["INVTYPE_NECK"] = {2},
    ["INVTYPE_SHOULDER"] = {3},
    ["INVTYPE_BODY"] = {4},
    ["INVTYPE_CHEST"] = {5},
    ["INVTYPE_ROBE"] = {5},
    ["INVTYPE_WAIST"] = {6},
    ["INVTYPE_LEGS"] = {7},
    ["INVTYPE_FEET"] = {8},
    ["INVTYPE_WRIST"] = {9},
    ["INVTYPE_HAND"] = {10},
    ["INVTYPE_FINGER"] = { 11, 12 },
    ["INVTYPE_TRINKET"] = { 13, 14 },
    ["INVTYPE_CLOAK"] = {15},
    ["INVTYPE_WEAPON"] = { 16, 17 },
    ["INVTYPE_SHIELD"] = {17},
    ["INVTYPE_2HWEAPON"] = {16},
    ["INVTYPE_WEAPONMAINHAND"] = {16},
    ["INVTYPE_WEAPONOFFHAND"] = {17},
    ["INVTYPE_HOLDABLE"] = {17}, --[[
    ["INVTYPE_RANGED"] = 18,
    ["INVTYPE_THROWN"] = 18,
    ["INVTYPE_RANGEDRIGHT"] = 18,
    ["INVTYPE_RELIC"] = 18,
    ["INVTYPE_TABARD"] = 19,
    ["INVTYPE_BAG"] = { 20, 21, 22, 23 }
    ["INVTYPE_QUIVER"] = { 20, 21, 22, 23 }  ]]
}

addonTable.data.levelingItems = {
    "Hunger of the Pack",
    "Boots of the Gilded Path"
}

addonTable.data.bonusToIlvl = {
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

setmetatable(addonTable.data.bonusToIlvl, {__index = function() return 0 end})

addonTable.data.dialogWhitelist = {
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


addonTable.data.questItems = {
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
