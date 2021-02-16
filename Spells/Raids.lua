local addon, Engine = ...

local DE = Engine.Core
local L = Engine.L

local format, ipairs, min, pairs, select, strsplit, tonumber = format, ipairs, min, pairs, select, strsplit, tonumber

local RaidSpells = {

    -- Shriekwing
    [330711] = true, -- Earsplitting Shriek
    [340324] = true, -- Sanguine Ichor
    [343005] = true, -- Blind Swipe
    [343022] = true, -- Echoing Sonar

    -- Sludgefist
    [332572] = true, -- Falling Rubble
    [335361] = true, -- Stonequake
    [335371] = true, -- Stonequake (?)
    [341101] = true, -- Stonequake (?)

    -- Stone Legion Generals
    [344230] = {ignoreDebuffs = {[333377] = true}} -- Wicked Blade
}

-- TODO: remove this and iterate over RaidSpells identifying what needs to be tracked
local AurasToTrack = {
    -- Stone Legion Generals
    [333377] = {debuff = true} -- Wicked Mark debuff (for Wicked Blade)
}

DE:MergeTables(DE.RaidSpells, RaidSpells)
DE:MergeTables(DE.AuraTracker, AurasToTrack)
