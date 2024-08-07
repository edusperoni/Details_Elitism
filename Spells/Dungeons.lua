local addon, Engine = ...

local DE = Engine.Core

local Spells = {
    -- Debug
    -- [] = 20,        -- ()
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
    --[331748] = 20, -- Bucking Rampage / Back Kick (Mistveil Guardian) - TODO removed?
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


    -- Grim Batol
}


local SpellsNoTank = {
    -- The Necrotic Wake
    [324323] = 20, -- Gruesome Cleave (Skeletal Marauder)
    [323489] = 20, -- Throw Cleaver (Flesh Crafter / Stitching Assistant)

    -- Mists of Tirna Scithe
    [325163] = 20, -- Cleaving Strike (Mistveil Defender) - TODO removed?
}

local Auras = {
    -- The Necrotic Wake
    [324293] = true, -- Rasping Scream (Skeletal Marauder)

    -- Mists of Tirna Scithe
    [322968] = true, -- Dying Breath (Drust Spiteclaw)
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
