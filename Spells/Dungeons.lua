local addon, Engine = ...

local DE = Engine.Core
local L = Engine.L

local format, ipairs, min, pairs, select, strsplit, tonumber = format, ipairs, min, pairs, select, strsplit, tonumber

local Spells = {
    -- Debug
    -- [] = 20,      --  ()
    -- [252144] = 1,
    -- [190984] = 1,       -- DEBUG Druid Wrath
    -- [285452] = 1,       -- DEBUG Shaman Lava Burst
    -- [188389] = 1,       -- DEBUG Shaman Flame Shock

    -- Affixes
    [209862] = 20, -- Volcanic Plume (Environment)
    [226512] = 20, -- Sanguine Ichor (Environment)
    [240448] = 20, -- Quaking (Environment)
    [343520] = 20, -- Storming (Environment)
    [342494] = 20, -- Belligerent Boast(Season 1 Pridefull)

    -- Mists of Tirna Scythe
    [321968] = 20, -- Bewildering Pollen (tirnenn Villager)
    [323137] = 20, -- Bewildering Pollen (tirnenn Villager)
    [323250] = 20, -- Anima Puddle (Droman Oulfarran)
    [325027] = 20, -- Bramble Burst (Drust Boughbreaker)
    [326022] = 20, -- Acid Globule (Spinemaw Gorger)
    [340300] = 20, -- Tongue Lashing (Mistveil Gorgegullet)
    [340304] = 20, -- Poisonous Secretions (Mistveil Gorgegullet)
    [331743] = 20, -- Bucking Rampage (Mistveil Guardian)
    -- id ? [340160] = 20,        -- Radiant Breath (Mistveil Matriarch)

    -- id ? [323177] = 20,        -- Tears of the Forest(Ingra Maloch)
    [321834] = 20, -- Dodge Ball (Mistcaller)
    [336759] = 20, -- Dodge Ball (Mistcaller)
    [322655] = 20, -- Acid Expulsion (Tred'Ova)
    -- id ? [322450] = 20,        -- Consumption (Tred'Ova)

    -- De Other Side
    [334051] = 20, -- Erupting Darkness (Death Speaker)
    [328729] = 20, -- Dark Lotus (Risen Cultist)
    [333250] = 20, -- Reaver (Risen Warlord)
    [342869] = 20, -- Enraged Mask (Enraged Spirit)
    [333790] = 20, -- Enraged Mask (Enraged Spirit)
    [332672] = 20, -- Bladestorm (Atal'ai Deathwalker)
    [323118] = 20, -- Blood Barrage (Hakkar the Soulflayer)
    [331933] = 20, -- Haywire (Defunct Dental Drill)
    [332157] = 20, -- Spinning Up (Headless Client)
    [323569] = 20, -- Spilled Essence (Environement)
    [320830] = 20, -- Mechanical Bomb Squirrel
    [323136] = 20, -- Anima Starstorm (Runestag Elderhorn)
    [323992] = 20, -- Echo Finger Laser X-treme (Millificent Manastorm)

    [320723] = 20, -- Displaced Blastwave (Dealer Xy'exa)
    [320232] = 20, -- Explosive Contrivance (Dealer Xy'exa)
    [334913] = 20, -- Master of Death (Mueh'zala)
    [327427] = 20, -- Shattered Dominion (Mueh'zala)
    [325691] = 20, -- Cosmic Collapse (Mueh'zala)
    [335000] = 20, -- Stellar cloud (Mueh'zala)

    -- Spires of Ascension
    [331251] = 20, -- Deep Connection (Azules / Kin-Tara)
    [317626] = 20, -- Maw-Touched Venom (Azules)
    [323786] = 20, -- Swift Slice (Kyrian Dark-Praetor)
    [324662] = 20, -- Ionized Plasma (Multiple) Can this be avoided?
    [317943] = 20, -- Sweeping Blow (Frostsworn Vanguard)
    [324608] = 20, -- Charged Stomp (Oryphrion)
    [323740] = 20, -- Impact (Forsworn Squad-Leader)
    [336447] = 20, -- Crashing Strike (Forsworn Squad-Leader)
    [336444] = 20, -- Crescendo (Forsworn Helion)
    [328466] = 20, -- Charged Spear (Lakesis / Klotos)
    [336420] = 20, -- Diminuendo (Klotos / Lakesis)

    [321034] = 20, -- Charged Spear (Kin-Tara)
    [324370] = 20, -- Attenuated Barrage (Kin-Tara)
    [324141] = 20, -- Dark Bolt (Ventunax)
    [323943] = 20, -- Run Through (Devos)
    -- [] = 20,        -- Seed of the Abyss (Devos) ???

    -- The Necrotic Wakes
    [324391] = 20, -- Frigid Spikes (Skeletal Monstrosity)
    [324381] = 20, -- Chill Scythe (Skeletal Monstrosity)
    -- id ?[324372] = 20,        -- Reaping Winds (Skeletal Monstrosity)
    [320574] = 20, -- Shadow Well (Zolramus Sorcerer)
    [333477] = 20, -- Gut Slice (Goregrind)
    [345625] = 20, -- Death Burst (Nar'zudah)

    -- id ?[320637] = 20,         -- Fetid Gas (Blightbone)
    [333489] = 20, -- Necrotic Breath (Amarth)
    [333492] = 20, -- Necrotic Ichor (Amarth apply by Necrotic Breath)
    [320365] = 20, -- Embalming Ichor (Surgeon Stitchflesh)
    [320366] = 20, -- Embalming Ichor (Surgeon Stitchflesh)
    [327952] = 20, -- Meat Hook (Stitchflesh)
    [327100] = 20, -- Noxious Fog (Stitchflesh)
    [328212] = 20, -- Razorshard Ice (Nalthor the Rimebender)
    [320784] = 20, -- Comet Storm (Nalthor the Rimebinder)

    -- Plaguefall
    -- id ?[335882] = 20,         -- Clinging Infestation (Fen Hatchling)
    [330404] = 20, -- Wing Buffet (Plagueroc)
    -- id ?[320040] = 20,        -- Plagued Carrion (Decaying Flesh Giant)
    [320072] = 20, -- Toxic pool (Decaying Flesh Giant)
    [318949] = 20, -- Festering Belch (Blighted Spinebreaker)
    -- id ?[320576] = 20,      -- Obliterating Ooze (Virulax Blightweaver)
    [319120] = 20, -- Putrid Bile (Gushing Slime)
    [327233] = 20, -- Belch Plague (Plagebelcher)
    [320519] = 20, -- Jagged Spines (Blighted Spinebreaker)
    [328501] = 20, -- Plagued Bomb (Environement)
    [324667] = 20, -- Slime Wave (Globgrog)
    [626242] = 20, -- Slime Wave (Globgrog)
    [333808] = 20, -- Oozing Outbreak (Doctor Ickus)
    [329217] = 20, -- Slime Lunge (Doctor Ickus)
    [322475] = 20, -- Plague Crash (Environement Margrave Stradama)

    -- Theater of Pain
    [337037] = 20, -- Whirling Blade (Nekthara the Mangler)
    [332708] = 20, -- Ground Smash (Heavin the breaker)
    [333297] = 20, -- Death Winds (Nefarious Darkspeaker)
    [331243] = 20, -- Bone Spikes (Soulforged Bonereaver)
    [331224] = 20, -- Bonestorm (Soulforged Bonereaver)
    [330608] = 20, -- Vile Eruption (Rancind Gasbag)

    [317231] = 20, -- Crushing Slam (Xav the Unfallen)
    [339415] = 20, -- Deafening Crash (Xav the Unfallen)
    [320729] = 20, -- Massive Cleave (Xav the Unfallen)
    [318406] = 20, -- Tenderizing Smash (Gorechop)
    -- id ?[323542] = 20,        -- Oozing (Gorechop)
    [323681] = 20, -- Dark Devastation (Mordretha) 
    [339573] = 20, -- Echos of Carnage (Mordretha)
    [339759] = 20, -- Echos of Carnage (Mordretha)

    -- Sanguine Depths
    [334563] = 20, -- Volatile Trap (Dreadful Huntmaster)
    [320991] = 20, -- Echoing Thrust (Regal Mistdancer)
    [320999] = 20, -- Echoing Thrust (Regal Mistdancer Mirror)
    -- id ?[321019] = 20,        -- Sanctified Mists (Regal Mistcaller)
    [334921] = 20, -- Umbral Crash (Insatiable Brute)
    [322418] = 20, -- Craggy Fracture (Chamber Sentinel)
    [334378] = 20, -- Explosive Vellum (Research Scribe)
    [323573] = 20, -- Residue (Fleeting Manifestation)
    [325885] = 20, -- Anguished Cries (Z'rali)
    [334615] = 20, -- Sweeping Slash (Head Custodian Javlin)
    [322212] = 20, -- Growing Mistrust (Vestige of Doubt)
    [328494] = 20, -- Sintouched Anima (Environement)
    [323810] = 20, -- Piercing Blur (General Kaal)

    -- Hall of Atonement 
    [325523] = 20, -- Deadly Thrust (Depraved Darkblade)
    [325799] = 20, -- Rapid Fire (Depraved Houndmaster)
    [326440] = 20, -- Sin Quake (Shard of Halkias)

    [322945] = 20, -- Heave Debris (Halkias)
    [324044] = 20, -- Refracted Sinlight (Halkias)
    [319702] = 20, -- Blood Torrent (Echelon)
    [323126] = 20, -- Telekinetic Collision (Lord Chamberlain)
    [329113] = 20, -- Telekinteic Onslaught (Lord Chamberlain)
    [327885] = 20 -- Erupting Torment (Lord Chamberlain)
}

local SpellsNoTank = {
    -- Mists of Tirna Scythe
    [331721] = 20, --- Spear Flurry (Mistveil Defender)

    -- De Other Side

    -- Spires of Ascension
    [320966] = 20, -- Overhead Slash (Kin-Tara)
    [336444] = 20, -- Crescendo (Forsworn Helion)

    -- The Necrotic Wakes
    [324323] = 20, -- Gruesome Cleave (Skeletal Marauder)
    [323489] = 20, -- Throw Cleaver (Flesh Crafter, Stitching Assistant)
    -- Plaguefall

    -- Theater of Pain

    -- Sanguine Depths
    [322429] = 20, -- Severing Slice (Chamber Sentinel)

    -- Hall of Atonement 
    -- id ? [118459] = 20,        -- Beast Cleave (Loyal Stoneborn)
    [346866] = 20, -- Stone Breathe (Loyal Stoneborn)
    [326997] = 20 -- Powerful Swipe (Stoneborn Slasher)
}

local Auras = {
    -- Mists of Tirna Scythe
    [323137] = true, --- Bewildering Pollen (Drohman Oulfarran)
    [321893] = true, --- Freezing Burst (Illusionary Vulpin)

    -- De Other Side
    [331381] = 20, -- Slipped (Lubricator)

    -- Spires of Ascension

    -- The Necrotic Wakes
    [324293] = 20 -- Rasping Scream (Skeletal Marauder)

    -- Plaguefall

    -- Theater of Pain

    -- Sanguine Depths

    -- Hall of Atonement 
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
