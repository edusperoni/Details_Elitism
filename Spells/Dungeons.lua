local addon, Engine = ...

local DE = Engine.Core

local Spells = {
    -- Debug
    -- [252144] = 1,
    -- [190984] = 1,         -- DEBUG Druid Wrath
    -- [285452] = 1,         -- DEBUG Shaman Lava Burst
    -- [188389] = 1,         -- DEBUG Shaman Flame Shock

    -- Affixes

    -- The Rookery


    -- Cinderbrew Meadery
    [437965] = 20, -- Pulsing Flames (Venture Co. Pyromaniac)
    [434707] = 20, -- Cinderbrew Toss (Tasting Room Attendant)
    [435000] = 20, -- High Steaks (Chef Chewie)
    [448920] = 20, -- Reckless Delivery, Charge (Careless Hopgoblin)
    [441179] = 20, -- Oozing Honey (Brew Drop)
    [442589] = 20, -- Beeswax (Venture Co. Honey Harvester)
    [440887] = 20, -- Rain of Honey (Royal Jelly Purveyor)
    [448855] = 20, -- Drop Shipment (Environment)
    [439468] = 20, -- Downward Trend (Yes Man / Assent Bloke / Agree Gentleman / Concur Sir)

    [432196] = 20, -- Hot Honey (Brew Master Aldryr)
    [432198] = 20, -- Blazing Belch (Brew Master Aldryr)
    [445180] = 20, -- Crawling Brawl (Brew Master Aldryr)
    [439991] = 20, -- Spouting Stout, Swirly (I'pa)
    [440087] = 20, -- Oozing Honey (Brew Drop, I'pa)
    [438651] = 20, -- Snack Time (Benk Buzzbee)
    [440141] = 20, -- Honey Marinade, Area (Benk Buzzbee)
    [438933] = 20, -- Sticky Situation (Benk Buzzbee) - TODO check ID
    [438931] = 20, -- Sticky Situation (Benk Buzzbee) - TODO check ID
    [435788] = 20, -- Cinder-BOOM!, Waves (Goldie Baronbottom)


    -- The Stonevault
    [425027] = 20, -- Seismic Wave (Earth Infused Golem)
    [447145] = 20, -- Pulverizing Pounce (Repurposed Loaderbot)
    [449070] = 20, -- Crystal Salvo (Void Touched Elemental)
    [449129] = 20, -- Lava Cannon (Forge Loader)
    [448975] = 20, -- Shield Stampede (Cursedforge Honor Guard)
    [428709] = 20, -- Granite Eruption (Rock Smasher)

    [422261] = 20, -- Crystal Shard, Impact (Skarmorak)
    [423538] = 20, -- Unstable Crash (Skarmorak)
    [443405] = 20, -- Unstable Fragments, Impact (Skarmorak)
    [428547] = 20, -- Scrap Cube (Speaker Brokk, Forge Speakers)
    [428819] = 20, -- Exhaust Vents, Vents (Speaker Brokk, Forge Speakers)
    [429999] = 20, -- Flaming Scrap (Speaker Brokk, Forge Speakers)
    [449169] = 20, -- Lava Cannon (Speaker Dorlita, Forge Speakers)
    [464392] = 20, -- Blazing Shrapnel (Speaker Dorlita, Forge Speakers)
    [463145] = 20, -- Magma Wave (Speaker Dorlita, Forge Speakers)
    [427869] = 20, -- Unbridled Void (Void Speaker Eirich)
    [457465] = 20, -- Entropy (Void Speaker Eirich)


    -- Darkflame Cleft
    [423501] = 20, -- Wild Wallop (Rank Overseer)
    [426883] = 20, -- Bonk! (Kobold Taskworker)
    [426779] = 20, -- Explosive Flame (Blazing Fiend)
    [440652] = 20, -- Surging Wax, Impact (Wandering Candle)
    [440653] = 20, -- Surging Wax, Area (Wandering Candle)
    [428650] = 20, -- Burning Backlash (Environment)
    [426265] = 20, -- Ceaseless Flame (Sootsnout) - TODO always towards One-Hand Headlock stunned player?
    [426259] = 20, -- Pyro-Pummel (Torchsnarl)
    [422393] = 20, -- Suffocating Darkness (Skittering Darkness)
    [422414] = 20, -- Shadow Smash (Shuffling Horror)

    [422125] = 20, -- Reckless Charge (Ol' Waxbeard)
    [422274] = 20, -- Cave-In (Ol' Waxbeard)
    [424821] = 20, -- High Speed Collision (Ol' Waxbeard)
    [429093] = 20, -- Underhanded Track-tics, Explosion (Ol' Waxbeard)
    [421638] = 20, -- Wicklighter Barrage (Blazikon)
    [424223] = 20, -- Incite Flames (Blazikon)
    [422700] = 20, -- Extinguishing Gust (Blazikon)
    [443969] = 20, -- Enkindling Inferno (Blazikon)
    [421067] = 20, -- Molten Wax (The Candle King)
    [427100] = 20, -- Umbral Slash (The Darkness)
    [426943] = 20, -- Rising Gloom (The Darkness) - is this reasonable?


    -- Priory of the Sacred Flame
    [453461] = 20, -- Caltrops (Fervent Sharpshooter)
    [427472] = 20, -- Flamestrike, Swirly (Fanatical Conjuror)
    [427473] = 20, -- Flamestrike, Area (Fanatical Conjuror)
    [427601] = 20, -- Burst of Light (Lightspawn)
    [448492] = 20, -- Thunderclap (Guard Captain Suleyman) - TODO is this reasonable?
    [428151] = 20, -- Reflective Shield (High Priest Aemya) - is this reasonable?
    [427900] = 20, -- Molten Pool (Forge Master Damian)
    [444705] = 20, -- Divine Storm (Zealous Templar) - TODO is this reasonable?
    [424430] = 20, -- Consecration (Ardent Paladin)

    [424621] = 20, -- Brutal Smash (Sergeant Shaynemail, Captain Dailcry)
    [424460] = 20, -- Ember Storm (Taener Duelmal, Captain Dailcry)
    [447272] = 20, -- Hurl Spear (Captain Dailcry)
    [423076] = 20, -- Hammer of Purity, Swirly (Baron Braunpyke)
    [423121] = 20, -- Hammer of Purity, Hammer (Baron Braunpyke)
    [423019] = 20, -- Castigator's Detonation (Baron Braunpyke)
    --[xxxx] = 20, -- Sacrificial Pyre (Baron Braunpyke) - check Mythic-only mechanic
    [451606] = 20, -- Holy Flame (Prioress Murrpray)
    [425554] = 20, -- Purify (Prioress Murrpray)
    [425556] = 20, -- Sanctified Ground (Prioress Murrpray)
    [428170] = 20, -- Blinding Light, Disorient (Prioress Murrpray)
    --[xxxx] = 20, -- ongoing dmg after Stoke the Flame (Prioress Murrpray) - TODO ID?


    -- The Dawnbreaker
    [432454] = 20, -- Stygian Seed, Explosion (Nightfall Ritualist)
    [430655] = 20, -- Arathi Ariship Cannon (Environment)
    [451093] = 20, -- Arathi Bomb (Environment)
    [431494] = 20, -- Black Edge (Nightfall Tactician)
    [432606] = 20, -- Black Hail (Manifested Shadow)
    [451098] = 20, -- Tacky Nova (Sureki Militant)
    [451115] = 20, -- Terrifying Slam, Area (Ixkreten the Unbreakable)
    [460135] = 20, -- Dark Scars (Deathscreamer Iken'tak)
    [431352] = 20, -- Tormenting Eruption, Splash (Nightfall Dark Architect)

    [453214] = 20, -- Obsidian Beam, Beams (Speaker Shadowcrown)
    [453173] = 20, -- Collapsing Night, Area (Speaker Shadowcrown)
    [451032] = 20, -- Darkness Comes (Speaker Shadowcrown)
    [427007] = 20, -- Terrifying Slam, Area (Anub'ikkaj)
    [427378] = 20, -- Dark Scars (Anub'ikkaj)
    [434655] = 20, -- Arathi Bomb, Explosion (Rasha'nan)
    [448215] = 20, -- Expel Webs (Rasha'nan)
    [434579] = 20, -- Rolling Acid, Corrosion (Rasha'nan)
    [449335] = 20, -- Encroaching Shadows (Environment)
    [434096] = 20, -- Sticky Web (Rasha'nan)
    [438956] = 20, -- Acid Pools (Rasha'nan)
    [438957] = 20, -- Acid Pools (Rasha'nan)


    -- City of Threads
    [443500] = 20, -- Earthshatter (Royal Swarmguard / Royal Venomshell / Retired Lord Vul'azak)
    [443438] = 20, -- Doubt (Herald of Ansurek)
    [443435] = 20, -- Twist Thoughts, Area (Herald of Ansurek)
    [451426] = 20, -- Gossamer Barrage (Xeph'itik)
    [450783] = 20, -- Perfume Toss (Xeph'itik)
    [451543] = 20, -- Null Slam (Eye of the Queen)
    [448047] = 20, -- Web Wrap (Pale Priest)
    [441792] = 20, -- Dark Slam (Reposing Knight)
    -- TODO additional mob types around High Hollows Market (Loyal Attendant, Royal Acolyte, etc)
    [434133] = 20, -- Venomous Spray, Swirlies (Royal Venomshell)
    [445838] = 20, -- Dark Barrage (Unstable Test Subject)
    [453841] = 20, -- Awakening Calling (Sureki Unnaturaler) - TODO removed?
    --[447271] = 20, -- Tremor Slam (Hulking Warshell) - always does damage to party as well

    [434710] = 20, -- Chains of Oppression (Orator Krix'vizk)
    [434779] = 20, -- Terrorize (Orator Krix'vizk)
    [448562] = 20, -- Doubt (Orator Krix'vizk)
    [434926] = 20, -- Lingering Influence (Orator Krix'vizk)
    [440049] = 20, -- Synergic Step (Nx / Vx, Fangs of the Queen)
    [439686] = 20, -- Shade Slash, Physical (Nx, Fangs of the Queen)
    [439687] = 20, -- Shade Slash, Shadow (Nx, Fangs of the Queen)
    [439696] = 20, -- Duskbringer, Area (Nx, Fangs of the Queen)
    [458741] = 20, -- Frozen Solid (Vx, Fangs of the Queen)
    [443311] = 20, -- Black Blood (The Coaglamation) - TODO check ID
    [462439] = 20, -- Black Blood (The Coaglamation) - TODO check ID
    [461825] = 20, -- Black Blood (The Coaglamation) - TODO check ID
    [461880] = 20, -- Blood Surge, Area (The Coaglamation)
    [439481] = 20, -- Shifting Anomalies (Izo the Grand Splicer)
    --[437700] = 20, -- Tremor Slam (Izo the Grand Splicer) - always does damage to party as well


    -- Ara-Kara, City of Echoes
    [438623] = 20, -- Toxic Rupture (Engorged Crawler)
    [434830] = 20, -- Vile Webbing (Environment / Ixin / Nakt / Atik / Avanoxx)
    [434824] = 20, -- Web Spray, Cone (Ixin / Nakt / Atik)
    [439469] = 20, -- Web Spray, Swirly (Ixin / Nakt / Atik)
    [438832] = 20, -- Poisonous Cloud, Impact (Atik)
    [438825] = 20, -- Poisonous Cloud, Area (Atik)
    [453160] = 20, -- Impale (Hulking Bloodguard)
    [433843] = 20, -- Erupting Webs (Blood Overseer)
    [432031] = 20, -- Grasping Blood (Black Blood) - TODO necessary for Ki'katal Cosmic Singularity?

    [438966] = 20, -- Gossamer Onslaught, Swirly (Avanoxx)
    [433443] = 20, -- Impale (Anub'zekt)
    [433781] = 20, -- Ceaseless Swarm (Anub'zekt)
    [434284] = 20, -- Burrow Charge, Dash (Anub'zekt) - TODO difficult for target to avoid, impossible without dash?
    [433731] = 20, -- Burrow Charge, End (Anub'zekt)
    [432132] = 20, -- Erupting Webs (Ki'katal the Harvester)
    [461507] = 20, -- Cultivated Poisons, Wave (Ki'katal the Harvester)
    [432117] = 20, -- Cosmic Singularity (Ki'katal the Harvester)


    -- The Necrotic Wake
    [323957] = 20, -- Animate Dead, Warrior (Zolramus Necromancer)
    [324026] = 20, -- Animate Dead, Crossbowman (Zolramus Necromancer)
    [324027] = 20, -- Animate Dead, Mage (Zolramus Necromancer)
    [320574] = 20, -- Shadow Well (Zolramus Sorcerer)
    [345625] = 20, -- Death Burst (Nar'zudah)
    [324391] = 20, -- Frigid Spikes (Skeletal Monstrosity)
    [324381] = 20, -- Reaping Winds / Chill Scythe (Skeletal Monstrosity)
    [327240] = 20, -- Spine Crush (Loyal Creation)
    [333477] = 20, -- Gut Slice (Goregrind)

    [320646] = 20, -- Fetid Gas (Blightbone)
    [319897] = 20, -- Land of the Dead, Crossbowman (Amarth)
    [319902] = 20, -- Land of the Dead, Warrior (Amarth)
    [333627] = 20, -- Land of the Dead, Mage (Amarth)
    [321253] = 20, -- Final Harvest, Swirly (Amarth)
    [333489] = 20, -- Necrotic Breath (Amarth)
    [333492] = 20, -- Necrotic Ichor (Amarth)
    [320365] = 20, -- Embalming Ichor, Swirly (Surgeon Stitchflesh)
    [320366] = 20, -- Embalming Ichor, Area (Surgeon Stitchflesh)
    [327952] = 20, -- Meat Hook (Stitchflesh's Creation, Surgeon Stitchflesh)
    [327100] = 20, -- Noxious Fog (Environment, Surgeon Stitchflesh)
    [320784] = 20, -- Comet Storm (Nalthor the Rimebinder)
    [321956] = 20, -- Comet Storm, Dark Exile (Nalthor the Rimebinder)
    [322793] = 20, -- Blizzard, Dark Exile (Nalthor the Rimebinder)
    [327875] = 20, -- Blizzard, Dark Exile (Nalthor the Rimebinder)
    [328212] = 20, -- Razorshard Ice (Nalthor the Rimebinder)


    -- Mists of Tirna Scithe
    [321968] = 20, -- Bewildering Pollen (Tirnenn Villager)
    [325027] = 20, -- Bramble Burst (Drust Boughbreaker)
    [463257] = 20, -- Mist Ward (Mistveil Defender)
    [340300] = 20, -- Tongue Lashing (Mistveil Gorgegullet)
    [340304] = 20, -- Poisonous Secretions (Mistveil Gorgegullet)
    [340311] = 20, -- Crushing Leap (Mistveil Gorgegullet)
    [340160] = 20, -- Radiant Breath (Mistveil Matriarch)
    [340283] = 20, -- Poisonous Discharge (Mistveil Nightblossom)
    [326022] = 20, -- Acid Globule (Spinemaw Gorger)
    [326017] = 20, -- Decomposing Acid (Spinemaw Larva)

    [323263] = 20, -- Tears of the Forest (Droman Oulfarran, Ingra Maloch)
    [323250] = 20, -- Anima Puddle (Droman Oulfarran, Ingra Maloch)
    [323137] = 20, -- Bewildering Pollen (Droman Oulfarran, Ingra Maloch)
    [321834] = 20, -- Dodge Ball (Mistcaller)
    [336759] = 20, -- Dodge Ball (Mistcaller)
    [321893] = 20, -- Freezing Burst (Mistcaller)
    [321828] = 20, -- Patty Cake (Mistcaller)
    [322655] = 20, -- Acid Expulsion (Tred'ova)
    [326309] = 20, -- Decomposing Acid (Tred'ova)
    [463603] = 20, -- Coalescing Poison (Tred'ova)
    [326263] = 20, -- Anima Shedding (Tred'ova)


    -- Siege of Boralus
    [256627] = 20, -- Slobber Knocker (Scrimshaw Enforcer)
    [275775] = 20, -- Savage Tempest (Irontide Raider)
    [257069] = 20, -- Watertight Shell, Explosion (Irontide Waveshaper)
    [256660] = 20, -- Burning Tar, Impact (Blacktar Bomber)
    [256663] = 20, -- Burning Tar, Area (Blacktar Bomber)
    [272140] = 20, -- Iron Volley (Irontide Powdershot, Gauntlet)
    [272426] = 20, -- Sighted Artillery (Ashvane Spotter / Dread Captain Lockwood)
    [280679] = 20, -- Cannon Barrage (Environment)
    [268260] = 20, -- Broadside (Ashvane Canoneer)
    [277432] = 20, -- Iron Volley (Ashvane Sniper, Gauntlet)
    [272546] = 20, -- Banana Rampage (Bilge Rat Buccaneer)
    [277535] = 20, -- Viq'Goth's Wrath (Environment)

    [273681] = 20, -- Heavy Hitter (Chopper Redhook) - is this reasonable?
    [257585] = 20, -- Cannon Barrage (Chopper Redhook)
    [273716] = 20, -- Heavy Ordnance, Impact (Chopper Redhook)
    [273718] = 20, -- Heavy Ordnance, Explosion (Chopper Redhook) - is this reasonable?
    --[257326] = 20, -- Gore Crash (Chopper Redhook) - always does damage to party as well
    [257292] = 20, -- Heavy Slash (Irontide Cleaver, Chopper Redhook)
    [269029] = 20, -- Clear the Deck (Dread Captain Lockwood)
    [268443] = 20, -- Dread Volley (Dread Captain Lockwood)
    [261565] = 20, -- Crashing Tide (Hadal Darkfathom)
    [257886] = 20, -- Brine Pool (Hadal Darkfathom)
    --[257883] = 20, -- Break Water (Hadal Darkfathom) - always does damage to party as well
    [276042] = 20, -- Tidal Surge (Hadal Darkfathom)
    [270187] = 20, -- Call of the Deep (Viq'Goth)
    [270484] = 20, -- Call of the Deep (Viq'Goth)
    [275051] = 20, -- Putrid Waters, Dispel (Viq'Goth)
    [280485] = 20, -- Terror from Below / Crushing Embrace (Viq'Goth)
    [269484] = 20, -- Eradication (Viq'Goth)


    -- Grim Batol
    [456701] = 20, -- Obsidian Stomp (Twilight Brute)
    [451614] = 20, -- Twilight Ember (Twilight Destroyer)
    [454216] = 20, -- Boiling Lava (Environment)
    [462219] = 20, -- Blazing Shadowflame, Frontal (Twilight Flamerender)
    [462220] = 20, -- Blazing Shadowflame, Area (Twilight Flamerender)
    [456711] = 20, -- Shadowlava Blast (Twilight Lavabender)
    [451389] = 20, -- Ascension, Swirly (Twilight Lavabender)
    [451394] = 20, -- Mind Piercer (Faceless Corruptor)

    [448566] = 20, -- Shadowflame Breath (Twilight Drake, General Umbriss)
    [448953] = 20, -- Rumbling Earth (General Umbriss)
    [449536] = 20, -- Molten Pool (Forgemaster Throngus)
    [447395] = 20, -- Fiery Cleave (Forgemaster Throngus)
    [448028] = 20, -- Invocation of Shadowflame, Swirly (Drahga Shadowburner)
    [75238] = 20, -- Shadowflame Nova (Invoked Shadowflame Spirit, Drahga Shadowburner) - is this reasonable?
    [448105] = 20, -- Devouring Flame (Valiona, Drahga Shadowburner)
    [456773] = 20, -- Twilight Wind (Valiona, Drahga Shadowburner)
    [450087] = 20, -- Depth's Grasp (Void Tendril, Erudax)
    [461513] = 20, -- Shadow Gale, shrinking (Erudax)
    [449985] = 20, -- Shadow Gale, formed (Erudax)
}


local SpellsNoTank = {
    -- Cinderbrew Meadery
    [440138] = 20, -- Honey Marinade, Explosion (Benk Buzzbee)
    [436592] = 20, -- Cash Cannon (Goldie Baronbottom)

    -- Darkflame Cleft
    [421282] = 20, -- Darkflame Pickaxe (The Candle King)

    -- City of Threads
    [439764] = 20, -- Process of Elimination, Physical (Izo the Grand Splicer)
    [439763] = 20, -- Process of Elimination, Shadow (Izo the Grand Splicer)
    [450055] = 20, -- Gutburst (Ravenous Scarab, Izo the Grand Splicer) - is this reasonable?

    -- The Necrotic Wake
    [324323] = 20, -- Gruesome Cleave (Skeletal Marauder)
    [323489] = 20, -- Throw Cleaver (Flesh Crafter / Stitching Assistant)

    -- Siege of Boralus
    [273720] = 20, -- Heavy Ordnance, Contact (Chopper Redhook) - is this reasonable?
}

local Auras = {
    -- Darkflame Cleft
    [421653] = true, -- Cursed Wax (The Candle King)

    -- The Dawnbreaker
    [451104] = true, -- Bursting Cocoon, Explosion (Sureki Webmage)

    -- Ara-Kara, City of Echoes
    [436614] = true, -- Web Wrap (Environment / Ixin / Nakt / Atik / Avanoxx)

    -- The Necrotic Wake
    [324293] = true, -- Rasping Scream (Skeletal Marauder)

    -- Mists of Tirna Scithe
    [322968] = true, -- Dying Breath (Drust Spiteclaw)

    -- Siege of Boralus
    [257169] = true, -- Terrifying Roar (Bilge Rat Demolisher)
    [274942] = true, -- Banana Rampage (Bilge Rat Buccaneer)
}

local AurasNoTank = {}

local Swings = {
    -- [161917] = 20, -- DEBUG
}

DE:MergeTables(DE.Spells, Spells);
DE:MergeTables(DE.SpellsNoTank, SpellsNoTank);
DE:MergeTables(DE.Auras, Auras);
DE:MergeTables(DE.AurasNoTank, AurasNoTank);
DE:MergeTables(DE.Swings, Swings);
