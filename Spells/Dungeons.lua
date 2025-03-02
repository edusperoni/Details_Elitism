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
    [474017] = 20, -- Wild Lightning (Voidrider / Kyrioss)
    [426968] = 20, -- Bounding Void (Quartermaster Koratite)
    [420679] = 20, -- Tornado Winds (Environment)
    [452932] = 20, -- Attracting Shadows, Explosion (Coalescing Void Diffuser)
    [430186] = 20, -- Seeping Corruption, Area (Corrupted Oracle)
    [443847] = 20, -- Instability (Afflicted Civilian)
    [442192] = 20, -- Oppressive Void (Environment)
    [1214550] = 20, -- Umbral Wave (Void Ascendant)
    [1214645] = 20, -- Erupting Darkness (Consuming Voidstone)

    [444250] = 20, -- Lightning Torrent, Beams (Kyrioss)
    [1214318] = 20, -- Grounding Bolt (Kyrioss)
    [419871] = 20, -- Lightning Dash (Kyrioss)
    [426136] = 20, -- Reality Tear (Stormguard Gorren)
    [424966] = 20, -- Lingering Void (Stormguard Gorren)
    [425052] = 20, -- Dark Gravity, Explosion (Stormguard Gorren)
    [423356] = 20, -- Null Upheaval, Swirlies (Voidstone Monstrosity)
    [433067] = 20, -- Seeping Corruption (Voidstone Monstrosity)


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
    [438933] = 20, -- Sticky Situation (Benk Buzzbee) - TODO check
    [438931] = 20, -- Sticky Situation (Benk Buzzbee) - TODO check
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
    [440652] = 20, -- Surging Flame, Impact (Wandering Candle)
    [440653] = 20, -- Surging Flame, Area (Wandering Candle)
    [428650] = 20, -- Burning Backlash (Environment)
    --[426265] = 20, -- Ceaseless Flame (Sootsnout) - TODO is this reasonable?
    [1218133] = 20, -- Burning Candles (Sootsnout)
    [422393] = 20, -- Suffocating Darkness (Skittering Darkness)

    [422125] = 20, -- Reckless Charge (Ol' Waxbeard)
    [422274] = 20, -- Cave-In (Ol' Waxbeard)
    [424821] = 20, -- High Speed Collision (Ol' Waxbeard)
    [429093] = 20, -- Underhanded Track-tics, Explosion (Ol' Waxbeard) - TODO is this reasonable?
    [421638] = 20, -- Wicklighter Barrage (Blazikon)
    [443969] = 20, -- Enkindling Inferno (Blazikon)
    [422700] = 20, -- Extinguishing Gust (Blazikon)
    [424223] = 20, -- Incite Flames (Blazikon)
    [421282] = 20, -- Darkflame Pickaxe (The Candle King)
    [421067] = 20, -- Molten Wax (The Candle King)
    [427100] = 20, -- Umbral Slash (The Darkness)
    [426943] = 20, -- Rising Gloom (The Darkness)


    -- Priory of the Sacred Flame
    [453461] = 20, -- Caltrops (Fervent Sharpshooter)
    [427472] = 20, -- Flamestrike, Swirly (Fanatical Conjuror)
    [427473] = 20, -- Flamestrike, Area (Fanatical Conjuror)
    [427601] = 20, -- Burst of Light (Lightspawn)
    [427900] = 20, -- Molten Pool (Forge Master Damian)
    [424430] = 20, -- Consecration (Ardent Paladin)

    [424621] = 20, -- Brutal Smash (Sergeant Shaynemail, Captain Dailcry)
    [424460] = 20, -- Ember Storm (Taener Duelmal, Captain Dailcry)
    [447272] = 20, -- Hurl Spear (Captain Dailcry)
    [423076] = 20, -- Hammer of Purity, Swirly (Baron Braunpyke)
    [423121] = 20, -- Hammer of Purity, Hammer (Baron Braunpyke)
    [423019] = 20, -- Castigator's Detonation (Baron Braunpyke)
    [451606] = 20, -- Holy Flame (Prioress Murrpray)
    [425554] = 20, -- Purify (Prioress Murrpray)
    [425556] = 20, -- Sanctified Ground (Prioress Murrpray)
    [428170] = 20, -- Blinding Light, Disorient (Prioress Murrpray)


    -- The Dawnbreaker
    [432454] = 20, -- Stygian Seed, Explosion (Nightfall Ritualist)
    [430655] = 20, -- Arathi Ariship Cannon (Environment)
    [451093] = 20, -- Arathi Bomb (Environment)
    [431494] = 20, -- Black Edge (Nightfall Tactician)
    [432606] = 20, -- Black Hail (Manifested Shadow)
    [451098] = 20, -- Tacky Nova (Sureki Militant)
    [460135] = 20, -- Dark Scars (Deathscreamer Iken'tak)
    [431352] = 20, -- Tormenting Eruption, Splash (Nightfall Dark Architect)

    [453214] = 20, -- Obsidian Beam, Beams (Speaker Shadowcrown)
    [453173] = 20, -- Collapsing Night, Area (Speaker Shadowcrown)
    [451032] = 20, -- Darkness Comes (Speaker Shadowcrown)
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
    [446084] = 20, -- Toxic Fumes (Environment)
    [434133] = 20, -- Venomous Spray, Swirlies (Royal Venomshell)
    [445838] = 20, -- Dark Barrage (Unstable Test Subject)
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
    [443311] = 20, -- Black Blood, Arena (The Coaglamation)
    [462439] = 20, -- Black Blood, Arena (The Coaglamation)
    [438601] = 20, -- Black Blood, Mechanic (The Coaglamation)
    [461825] = 20, -- Black Blood, Mechanic (The Coaglamation)
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
    --[432031] = 20, -- Grasping Blood (Black Blood) - necessary for Ki'katal Cosmic Singularity

    [438966] = 20, -- Gossamer Onslaught, Swirly (Avanoxx)
    [433443] = 20, -- Impale (Anub'zekt)
    [433781] = 20, -- Ceaseless Swarm (Anub'zekt)
    [434284] = 20, -- Burrow Charge, Dash (Anub'zekt)
    [433731] = 20, -- Burrow Charge, End (Anub'zekt)
    [432132] = 20, -- Erupting Webs (Ki'katal the Harvester)
    [461507] = 20, -- Cultivated Poisons, Wave (Ki'katal the Harvester)
    [432117] = 20, -- Cosmic Singularity (Ki'katal the Harvester)


    -- Operation: Floodgate
    [464294] = 20, -- Weapons Stockpile Explosion (Environment)
    [465682] = 20, -- Surprise Inspection (Darkfuse Inspector)
    [465128] = 20, -- Wind Up (Loaderbot)
    [461793] = 20, -- R.P.G.G. (Darkfuse Demolitionist)
    [1215071] = 20, -- Electrified Water (Environment)
    [472338] = 20, -- Surveyed Ground (Venture Co. Surveyor)
    [474350] = 20, -- Shreddation Sawblade (Shreddinator 3000)
    [474388] = 20, -- Flamethrower (Shreddinator 3000)
    [468727] = 20, -- Seaforium Charge (Venture Co. Diver)
    [1213790] = 20, -- Zeppelin Barrage, Swirly (Environment)
    [1214341] = 20, -- Bomb Pile Explosion (Environment)
    [465487] = 20, -- Bubbles Smash (Bubbles)
    [469819] = 20, -- Bubble (Bubbles)
    [1217496] = 20, -- Splish Splash (Bubbles)
    [465604] = 20, -- Battery Bolt (Darkfuse Jumpstarter)

    [473224] = 20, -- Sonic Boom, Wave (Big M.O.M.M.A.)
    [473240] = 20, -- Sonic Boom, Explosion (Big M.O.M.M.A.)
    [473287] = 20, -- Excessive Electrification (Big M.O.M.M.A.)
    [472454] = 20, -- Doom Storm (Darkfuse Mechadrone, Big M.O.M.M.A.)
    [473526] = 20, -- Big Bada BOOM! (Keeza Quickfuse, Demolition Duo)
    [460787] = 20, -- Deflagration (Keeza Quickfuse, Demolition Duo) - TODO is this reasonable?
    [472755] = 20, -- Shrapnel (Keeza Quickfuse, Demolition Duo)
    [1217751] = 20, -- B.B.B.F.G. (Keeza Quickfuse, Demolition Duo)
    [460965] = 20, -- Barreling Charge (Bront, Demolition Duo)
    [473126] = 20, -- Mudslide (Swampface)
    [473046] = 20, -- Skewering Root (Swampface)
    [473051] = 20, -- Rushing Tide (Swampface)
    [465982] = 20, -- Turbo Bolt (Geezle Gigazap)
    [468604] = 20, -- Dam Rubble (Geezle Gigazap)
    [468741] = 20, -- Shock Water, Impact (Geezle Gigazap)
    [468723] = 20, -- Shock Water, Area (Geezle Gigazap)
    [468647] = 20, -- Leaping Spark (Geezle Gigazap)


    -- Theater of Pain
    [317605] = 20, -- Whirlwind (Dokigg the Brutalizer / Nekthara the Mangler / Rek the Hardened) - Champions in Halls of Might have had their abilities redistributed
    [1213695] = 20, -- Earthcrusher, Swirlies (Dokigg the Brutalizer) - Champions in Halls of Might have had their abilities redistributed
    [337037] = 20, -- Whirling Blade (Nekthara the Mangler) - Champions in Halls of Might have had their abilities redistributed
    [332708] = 20, -- Ground Smash (Heavin the Breaker) - Champions in Halls of Might have had their abilities redistributed
    [334025] = 20, -- Bloodthirsty Charge (Haruga the Bloodthirsty) - Champions in Halls of Might have had their abilities redistributed
    [317367] = 20, -- Necrotic Volley (Environment)
    [333301] = 20, -- Curse of Desolation (Nefarious Darkspeaker)
    [333297] = 20, -- Death Winds (Nefarious Darkspeaker)
    [331243] = 20, -- Bone Spikes (Soulforged Bonereaver)
    [331224] = 20, -- Bonestorm (Soulforged Bonereaver)
    [321041] = 20, -- Disgusting Burst (Disgusting Refuse / Blighted Sludge-Spewer)
    [330592] = 20, -- Vile Eruption (Rancid Gasbag)
    [330608] = 20, -- Vile Eruption (Rancid Gasbag)
    [342103] = 20, -- Rancid Bile (Rancid Gasbag)

    [1215738] = 20, -- Decaying Breath (Paceran the Virulent, An Affront of Challengers)
    [1215636] = 20, -- Necrotic Spores, Swirlies (Paceran the Virulent, An Affront of Challengers)
    [320180] = 20, -- Necrotic Spores, Area (Paceran the Virulent, An Affront of Challengers)
    [317231] = 20, -- Crushing Slam (Xav the Unfallen)
    [339415] = 20, -- Deafening Crash (Xav the Unfallen)
    [320729] = 20, -- Massive Cleave (Xav the Unfallen)
    [473519] = 20, -- Death Spiral, Orb (Kul'tharok)
    [1223240] = 20, -- Death Spiral, Area (Kul'tharok)
    [318406] = 20, -- Tenderizing Smash (Gorechop)
    [323406] = 20, -- Jagged Gash (Gorechop)
    [323750] = 20, -- Vile Gas (Gorechop)
    [323130] = 20, -- Coagulating Ooze (Oozing Leftover, Gorechop)
    [323681] = 20, -- Dark Devastation (Mordretha)
    [323831] = 20, -- Death Grasp (Mordretha)
    [339550] = 20, -- Echo of Battle (Mordretha)
    [339751] = 20, -- Ghostly Charge (Mordretha)


    -- The MOTHERLODE!!
    [257371] = 20, -- Tear Gas, Swirly (Mechanized Peacekeeper)
    [1217283] = 20, -- Tear Gas, Area (Mechanized Peacekeeper)
    [269831] = 20, -- Toxic Sludge (Environment)
    [473198] = 20, -- Azerite Eruption (Azerite Extractor)
    [269313] = 20, -- Final Blast (Wanton Sapper)
    [268365] = 20, -- Mining Charge (Wanton Sapper)
    [1214754] = 20, -- Massive Slam (Taskmaster Askari)
    [271583] = 20, -- Black Powder Special (Environment)
    [1215424] = 20, -- Brainstorm, Swirly (Venture Co. Mastermind)
    [1214748] = 20, -- Brainstorm, Tornado (Venture Co. Mastermind)
    [271432] = 20, -- Test Missile (Environment)
    [262348] = 20, -- Mine Blast (Crawler Mine)
    [269092] = 20, -- Artillery Barrage (Ordnance Specialist)

    [1217286] = 20, -- Throw Coins (Footbomb Hooligan, Coin-Operated Crowd Pummeler)
    [256137] = 20, -- Timed Detonation (Coin-Operated Crowd Pummeler)
    [1217296] = 20, -- Shocking Claw (Coin-Operated Crowd Pummeler)
    [275907] = 20, -- Tectonic Smash (Azerokk)
    [258628] = 20, -- Resonant Quake, Area (Azerokk)
    [1214673] = 20, -- Azerite Aftershock (Azerokk) - TODO is this reasonable?
    [259533] = 20, -- Azerite Catalyst (Rixxa Fluxflame)
    [260279] = 20, -- Gatling Gun (Mogul Razdunk)
    [276234] = 20, -- Micro Missiles (B.O.O.M.B.A., Mogul Razdunk)
    [270277] = 20, -- Big Red Rocket (Mogul Razdunk)
    [270926] = 20, -- Drill Smash, Swirly (Mogul Razdunk)


    -- Operation: Mechagon - Workshop
    [282943] = 20, -- Piston Smasher (Environment)
    [282945] = 20, -- Buzz Saw (Environment)
    [294128] = 20, -- Rocket Barrage (Rocket Tonk)
    [301299] = 20, -- Furnace Flames (Environment)
    [294549] = 20, -- Furnace Flames (Environment)
    [293861] = 20, -- Anti-Personnel Squirrel (Anti-Personnel Squirrel)
    [295168] = 20, -- Capacitor Discharge (Blastatron X-80)
    [293986] = 20, -- Sonic Pulse (Spider Tank / Blastatron X-80)
    [1213154] = 20, -- Electrified Floor (Environment)

    [1215039] = 20, -- B.4.T.T.L.3. Mine, Swirly (Gnomercy 4.U., Tussle Tonks)
    [285377] = 20, -- B.4.T.T.L.3. Mine, Mine (Gnomercy 4.U., Tussle Tonks)
    [283422] = 20, -- Maximum Thrust (Gnomercy 4.U., Tussle Tonks)
    [291930] = 20, -- Air Drop (K.U-J.0.)
    [291953] = 20, -- Junk Bomb (K.U.-J.0.)
    [291949] = 20, -- Venting Flames (K.U-J.0.)
    [294954] = 20, -- Self-Trimming Hedge (Head Machinist Sparkflux, Machinist's Garden)
    [285443] = 20, -- "Hidden" Flame Cannon (Head Machinist Sparkflux, Machinist's Garden)
    [285460] = 20, -- Discom-BOMB-ulator (Head Machinist Sparkflux, Machinist's Garden)
    [294869] = 20, -- Roaring Flame (Inconspicuous Plant, Machinist's Garden)
    [291915] = 20, -- Plasma Orb (King Mechagon)
    [291856] = 20, -- Recalibrate (King Mechagon)
    [291613] = 20, -- Take Off! (Aerial Unit R-21/X, King Mechagon)
    [291914] = 20, -- Cutting Beam, Beam (Aerial Unit R-21/X, King Mechagon)
}


local SpellsNoTank = {
    -- The Rookery
    [472549] = 20, -- Volatile Void (Consuming Voidstone)
    [445537] = 20, -- Oblivion Wave (Voidstone Monstrosity)

    -- Cinderbrew Meadery
    [440138] = 20, -- Honey Marinade, Explosion (Benk Buzzbee)
    [436592] = 20, -- Cash Cannon (Goldie Baronbottom)

	-- The Dawnbreaker
	[451115] = 20, -- Terrifying Slam, Area (Ixkreten the Unbreakable)
	[427007] = 20, -- Terrifying Slam, Area (Anub'ikkaj)

    -- City of Threads
    [439764] = 20, -- Process of Elimination, Physical (Izo the Grand Splicer)
    [439763] = 20, -- Process of Elimination, Shadow (Izo the Grand Splicer)
    [450055] = 20, -- Gutburst (Ravenous Scarab, Izo the Grand Splicer)

    -- Theater of Pain
    [474084] = 20, -- Necrotic Eruption (Kul'tharok)

    -- The MOTHERLODE!!
    [258674] = 20, -- Throw Wrench (Off-Duty Laborer) - TODO is this reasonable?
    [257544] = 20, -- Jagged Cut (Earthrager, Azerokk) - TODO is this reasonable?

    -- Operation: Mechagon - Workshop
    [1215065] = 20, -- Platinum Pummel (The Platinum Pummeler, Tussle Tonks)
}

local Auras = {
    -- Darkflame Cleft
    --[426277] = true, -- One-Hand Headlock (Sootsnout) - TODO is this avoidable?
    [421653] = true, -- Cursed Wax (The Candle King)

    -- The Dawnbreaker
    [451104] = true, -- Bursting Cocoon, Explosion (Sureki Webmage)

    -- Ara-Kara, City of Echoes
    [436614] = true, -- Web Wrap (Environment / Ixin / Nakt / Atik / Avanoxx)

    -- Operation: Floodgate
    [1215089] = true, -- Electrified Water (Environment)
    [1213704] = true, -- Zeppelin Barrage, Spotlight (Environment)

    -- Operation: Mechagon - Workshop
    [295130] = true, -- Neutralize Threat (Detect-o-bot)
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
