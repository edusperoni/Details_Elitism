local addon, Engine = ...

local DE = Engine.Core
local L = Engine.L

local format, ipairs, min, pairs, select, strsplit, tonumber = format, ipairs, min, pairs, select, strsplit, tonumber

local Spells = {
    -- Debug
    -- [] = 20,        -- ()
    -- [252144] = 1,
    -- [190984] = 1,         -- DEBUG Druid Wrath
    -- [285452] = 1,         -- DEBUG Shaman Lava Burst
    -- [188389] = 1,         -- DEBUG Shaman Flame Shock

    -- Affixes
    [209862] = 20, -- Volcanic Plume (Environment)
    [226512] = 20, -- Sanguine Ichor (Environment)
    [240448] = 20, -- Quaking (Environment)
    [343520] = 20, -- Storming (Environment)
    [350163] = 20, -- Melee (Spiteful Shade)

    [394873] = 20, -- Lightning Strike (Season 1 Thundering)
    [396411] = 20, -- Primal Overload (Season 1 Thundering)


    -- Uldaman: Legacy of Tyr
    [369811] = 20, -- Brutal Slam (Hulking Berserker)
    [369854] = 20, -- Throw Rock (Burly Rock-Thrower)
    [382576] = 20, -- Scorn of Tyr (Earthen Guardian)
    --[369368] = 20, -- Stone Eruption (Earthen Warder) - TODO does this hit cursed player?

    [369573] = 20, -- Heavy Arrow (Baelog, The Lost Dwarves)
    [369792] = 20, -- Skullcracker (Eric "The Swift", The Lost Dwarves)
    [375286] = 20, -- Searing Cannonfire (The Lost Dwarves)
    [377825] = 20, -- Burning Pitch (The Lost Dwarves)
    [369703] = 20, -- Thundering Slam (Bromach)
    [368996] = 20, -- Purging Flames (Emberon)
    [369029] = 20, -- Heat Engine (Emberon)
    [369052] = 20, -- Seeking Flame (Vault Keeper, Emberon)
    [376319] = 20, -- Eternity Orb (Chrono-Lord Deios)
    [376325] = 20, -- Eternity Zone (Chrono-Lord Deios)


    -- Ruby Life Pools
    -- Neltharus
    -- The Nokhud Offensive
    -- Brackenhide Hollow
    -- The Azure Vault
    -- Halls of Infusion
    -- Algeth'ar Academy


    -- Court of Stars
    [209027] = 20, -- Quelling Strike (Duskwatch Guard)
    [209477] = 20, -- Wild Detonation (Mana Wyrm)
    [212031] = 20, -- Charged Blast (Bound Energy)
    [209404] = 20, -- Seal Magic (Duskwatch Arcanist)
    [211391] = 20, -- Felblaze Puddle (Legion Hound) - TODO is first tick avoidable?
    [214688] = 20, -- Carrion Swarm (Gerenth the Vile) - TODO removed?

    [206574] = 20, -- Resonant Slash, Front (Patrol Captain Gerdo)
    [206580] = 20, -- Resonant Slash, Back (Patrol Captain Gerdo)
    [219498] = 20, -- Streetsweeper (Patrol Captain Gerdo)
    [209378] = 20, -- Whirling Blades (Imacu'tya, Talixae Flamewreath)
    [207979] = 20, -- Shockwave (Jazshariu, Talixae Flamewreath)
    [397903] = 20, -- Crushing Leap (Jazshariu, Talixae Flamewreath)
    [207887] = 20, -- Infernal Eruption, Impact (Talixae Flamewreath)
    [211457] = 20, -- Infernal Eruption, Area (Talixae Flamewreath)
    [209628] = 20, -- Piercing Gale (Advisor Melandrus)
    [209630] = 20, -- Piercing Gale (Image of Advisor Melandrus, Advisor Melandrus)
    [209667] = 20, -- Blade Surge (Advisor Melandrus)


    -- Halls of Valor
    [198903] = 20, -- Crackling Storm (Storm Drake)
    [210875] = 20, -- Charged Pulse (Stormforged Sentinel)
    [199818] = 20, -- Crackle (Stormforged Sentinel)
    [199210] = 20, -- Penetrating Shot (Valarjar Marksman)
    --[192565] = 20, -- Cleansing Flames (Valarjar Purifier) - difficult to dodge reliably
    [191508] = 20, -- Blast of Light (Valarjar Aspirant)
    --[199033] = 20, -- Valkyra's Advance (Valarjar Aspirant) - TODO can this be dodged without movement skills?
    [199337] = 20, -- Bear Trap (Valarjar Trapper)
    [199146] = 20, -- Bucking Charge (Gildedfur Stag)
    [199090] = 20, -- Rumbling Stomp (Angerhoof Bull)

    [193234] = 20, -- Dancing Blade (Hymdall)
    [193260] = 20, -- Static Field (Storm Drake, Hymdall)
    [188395] = 20, -- Ball Lightning (Storm Drake, Hymdall)
    --[192206] = 20, -- Sanctify (Olmyr the Enlightened / Hyrja) - TODO dmg to whole group?
    [193827] = 20, -- Ragnarok (God-King Skovald)
    [193702] = 20, -- Infernal Flames (God-King Skovald)
    --[193660] = 20, -- Felblaze Rush (God-King Skovald) - TODO check ID, is this avoidable after changes?
    [198263] = 20, -- Radiant Tempest (Odyn)
    [198088] = 20, -- Glowing Fragment (Odyn)
    [198412] = 20, -- Feedback (Odyn)


    -- Shadowmoon Burial Grounds
    [152688] = 20, -- Shadow Rune (Environment)
    [152690] = 20, -- Shadow Rune (Environment)
    [152696] = 20, -- Shadow Rune (Environment)
    [394524] = 20, -- Void Eruptions (Void Spawn) - TODO check ID
    [153395] = 20, -- Body Slam (Carrion Worm)
    
    [153232] = 20, -- Daggerfall (Sadana Bloodfury)
    [153373] = 20, -- Daggerfall (Sadana Bloodfury) - TODO is this relevant?
    [153224] = 20, -- Shadow Burn (Sadana Bloodfury)
    [152800] = 20, -- Void Vortex (Nhallish) - TODO check ID
    [153070] = 20, -- Void Devastation (Nhallish)
    [153908] = 20, -- Inhale (Bonemaw)
    [153686] = 20, -- Body Slam (Bonemaw)
    --[153692] = 20, -- Necrotic Pitch (Bonemaw) - can be used to avoid Inhale
    [154442] = 20, -- Malevolence (Ner'zhul)
    [154468] = 20, -- Ritual of Bones (Ner'zhul)
    [154469] = 20, -- Ritual of Bones (Ner'zhul)


    -- Temple of the Jade Serpent
    [397881] = 20, -- Surging Deluge (Corrupt Living Water)
    [396003] = 20, -- Territorial Display (The Songbird Queen)
    [396010] = 20, -- Tears of Pain (The Crybaby Hozen)
    [397899] = 20, -- Leg Sweep (Sha-Touched Guardian)
    [110125] = 20, -- Shattered Resolve (Minion of Doubt) - TODO check ID
    --[??????] = 20, -- Flames of Doubt (Shambling Infester) - TODO

    [397785] = 20, -- Wash Away (Wise Mari)
    [397793] = 20, -- Corrupted Geyser (Wise Mari)
    --[115167] = 20, -- Corrupted Waters (Wise Mari) - TODO removed?
    [106856] = 20, -- Serpent Kick (Liu Flameheart)
    [106938] = 20, -- Serpent Wave (Liu Flameheart)
    [106864] = 20, -- Jade Serpent Kick (Liu Flameheart)
    [107053] = 20, -- Jade Serpent Wave, Projectile (Liu Flameheart)
    [118540] = 20, -- Jade Serpent Wave, Area (Liu Flameheart)
    [396907] = 20, -- Jade Fire Breath (Yu'lon, Liu Flameheart)
    [107103] = 20, -- Jade Fire, Impact (Yu'lon, Liu Flameheart)
    [107110] = 20 -- Jade Fire, Area (Yu'lon, Liu Flameheart)
}

local SpellsNoTank = {
    -- Uldaman: Legacy of Tyr
    [369409] = 20, -- Cleave (Earthen Custodian)
    [369563] = 20, -- Wild Cleave (Baelog, The Lost Dwarves)
    [369061] = 20, -- Searing Clap (Emberon)
    [375727] = 20, -- Sand Breath (Chrono-Lord Deios)

    -- Court of Stars
    [209036] = 20, -- Throw Torch (Duskwatch Sentry)
    [209495] = 20, -- Charged Smash (Guardian Construct)
    [209512] = 20, -- Disrupting Energy (Guardian Construct)

    -- Halls of Valor
    [198888] = 20, -- Lightning Breath (Storm Drake) - TODO is this avoidable by tank?
    [199050] = 20, -- Mortal Hew (Valarjar Shieldmaiden)
    [192018] = 20, -- Shield of Light (Hyrja)

    -- Shadowmoon Burial Grounds
    [152854] = 20, -- Void Sphere (Shadowmoon Loyalist) - TODO is this avoidable by tank?
    [153501] = 20 -- Void Blast (Nhallish)
}

local Auras = {
    -- Uldaman: Legacy of Tyr
    [369411] = true, -- Sonic Burst (Cavern Seeker) - 369412 seems to be variant with damage
    [372652] = true, -- Resonating Orb (Sentinel Talondras)

    -- Court of Stars
    [224333] = true -- Enveloping Winds (Advisor Melandrus)
}

local AurasNoTank = {}

local Swings = {
    -- [161917] = 20, -- DEBUG
    [174773] = 20 -- Spiteful Shade
}

DE:MergeTables(DE.Spells, Spells);
DE:MergeTables(DE.SpellsNoTank, SpellsNoTank);
DE:MergeTables(DE.Auras, Auras);
DE:MergeTables(DE.AurasNoTank, AurasNoTank);
DE:MergeTables(DE.Swings, Swings);
