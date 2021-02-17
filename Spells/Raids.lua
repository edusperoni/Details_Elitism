local addon, Engine = ...

local DE = Engine.Core
local L = Engine.L

local format, ipairs, min, pairs, select, strsplit, tonumber = format, ipairs, min, pairs, select, strsplit, tonumber

local RaidSpells = {

    -- Shriekwing
    [330711] = true, -- Earsplitting Shriek
    [336005] = true, -- Earsplitting Shriek (dot)
    [340324] = true, -- Sanguine Ichor
    [343005] = true, -- Blind Swipe
    [343022] = true, -- Echoing Sonar
    [342923] = {ignoreDebuffs = {[342077] = true}}, -- Descent (Echolocation)

    -- Huntsman Altimor
    [335116] = {ignoreDebuffs = {[335111] = true, [335112] = true, [335113] = true}}, -- Sinseeker (damage)
    [335304] = {ignoreDebuffs = {[335111] = true, [335112] = true, [335113] = true}, isDot = true}, -- Sinseeker (dot)

    -- Sun King's Salvation
    [328579] = true, -- Smoldering Remnants
    [329518] = true, -- Blazing Surge
    [341254] = true, -- Smoldering Plumage
    [326455] = {ignoreTanks = true}, -- Fiery Strike
    [326456] = {ignoreTanks = true}, -- Burning Remnants
    [328890] = {ignoreActiveDebuffs = {[328889] = true}}, -- Greater Castigation (will ignore debuffed targets, even if they take dmg from others)

    -- Artificer Xy'mox
    [329256] = true, -- Rift Blast
    [326302] = true, -- Stasis Trap
    [329107] = true, -- Extinction (Seed of Extinction)
    [328789] = true, -- Annihilate (Edge of Annihilation)

    -- Hungering Destroyer
    [329835] = true, -- Obliterating Rift

    -- Lady Inerva Darkvein
    [325713] = true, -- Lingering Anima
    [326538] = true, -- Anima Web
    [332668] = {ignoreDebuffs = {[342320] = true, [332664] = true, [340477] = true}}, -- Unleashed Shadow

    -- The Council of Blood
    [327610] = {ignoreTanks = true}, -- Evasive Lunge (Lord Stavros)
    -- [347425] = true, -- Dark Recital (should we even track this?)
    [330848] = true, -- Wrong Moves (Danse Macabre)

    -- Sludgefist
    [332572] = true, -- Falling Rubble
    [335361] = true, -- Stonequake
    [335371] = true, -- Stonequake (?)
    [341101] = true, -- Stonequake (?)

    -- Stone Legion Generals
    [333716] = {ignoreDebuffs = {[333377] = true}}, -- Wicked Blast (Wicked Blade)
    [336231] = true, -- Cluster Bombardment
    [334500] = true, -- Seismic Upheaval (General Grashaal)
    [339693] = {ignoreDebuffs = {[333913] = true, [343881] = true, [339690] = true}}, -- Crystalline Burst

    -- Sire Denathrius
    [336162] = true, -- Crescendo (Crimson Cabalist)
    [329974] = {ignoreDebuffs = {[329951] = true}}, -- Impale (Remornia)
    [327823] = {ignoreDebuffs = {[327796] = true}}, -- Insatiable Hunger (Night Hunter)
    [330137] = true, -- Massacre (Remornia)
    [335873] = true, -- Rancor
    [329181] = {ignoreTanks = true} -- Wracking Pain
}

-- TODO: remove this and iterate over RaidSpells identifying what needs to be tracked
local AurasToTrack = {

    -- Shriekwing
    [343024] = {debuff = true, isFail = true}, -- Horrified
    [342077] = {debuff = true}, -- Echolocation

    -- Huntsman Altimor
    [335111] = {debuff = true}, -- Huntsman's Mark
    [335112] = {debuff = true}, -- Huntsman's Mark
    [335113] = {debuff = true}, -- Huntsman's Mark
    [335304] = {debuff = true}, -- Sinseeker (dot)

    -- Sun King's Salvation
    [328889] = {debuff = true}, -- Greater Castigation debuff

    -- Artificer Xy'mox
    [326302] = {debuff = true, isFail = true}, -- Stasis Trap

    -- Lady Inerva Darkvein
    [342320] = {debuff = true}, -- Lightly Concentrated Anima
    [332664] = {debuff = true}, -- Concentrated Anima
    [340477] = {debuff = true}, -- Highly Concentrated Anima

    -- Stone Legion Generals
    [333377] = {debuff = true}, -- Wicked Mark debuff (for Wicked Blade)
    [333913] = {debuff = true}, -- Wicked Laceration
    [343881] = {debuff = true}, -- Serrated Tear
    [339690] = {debuff = true}, -- Crystalize
    [339693] = {debuff = true}, -- Crystalline Burst

    -- Sire Denathrius
    [329951] = {debuff = true}, -- Impale
    [327796] = {debuff = true}, -- Night Hunter
    [329181] = {debuff = true, isFail = true, ignoreTanks = true} -- Wracking Pain
}

DE:MergeTables(DE.RaidSpells, RaidSpells)
DE:MergeTables(DE.AuraTracker, AurasToTrack)
