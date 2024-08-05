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


    -- Siege of Boralus


    -- Grim Batol
}


local SpellsNoTank = {
    -- The Necrotic Wake
    [324323] = 20, -- Gruesome Cleave (Skeletal Marauder)
    [323489] = 20, -- Throw Cleaver (Flesh Crafter / Stitching Assistant)
}

local Auras = {
    -- The Necrotic Wake
    [324293] = true, -- Rasping Scream (Skeletal Marauder)
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
