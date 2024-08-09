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


    -- The Stonevault


    -- Darkflame Cleft


    -- Priory of the Sacred Flame


    -- The Dawnbreaker


    -- City of Threads


    -- Ara-Kara, City of Echoes


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
    [461513] = 20, -- Shadow Gale, shrinking (Erudax) - TODO check
    [449985] = 20, -- Shadow Gale, formed (Erudax)
}


local SpellsNoTank = {
    -- The Necrotic Wake
    [324323] = 20, -- Gruesome Cleave (Skeletal Marauder)
    [323489] = 20, -- Throw Cleaver (Flesh Crafter / Stitching Assistant)

    -- Mists of Tirna Scithe
    [325163] = 20, -- Cleaving Strike (Mistveil Defender) - TODO removed?

    -- Siege of Boralus
    --[273720] = 20, -- Heavy Ordnance, Contact (Chopper Redhook) - is this reasonable?
}

local Auras = {
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
