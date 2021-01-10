local addon, Engine = ...
local DE = LibStub('AceAddon-3.0'):NewAddon(addon, 'AceEvent-3.0', 'AceHook-3.0')
local L = Engine.L

Engine.Core = DE
_G[addon] = Engine

-- Lua functions
local _G = _G
local format, ipairs, min, pairs, select, strsplit, tonumber = format, ipairs, min, pairs, select, strsplit, tonumber

-- WoW API / Variables
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local UnitGUID = UnitGUID

local tContains = tContains

local Details = _G.Details

-- GLOBALS: ElitismLog

DE.debug = false
DE.debugFakeData = false
DE.CustomDisplay = {
    name = L["Avoidable Damage Taken"],
    icon = 2175503,
    source = false,
    attribute = false,
    spellid = false,
    target = false,
    author = "Bass",
    desc = L["Show how much avoidable damage was taken."],
    script_version = 1,
    script = [[
        local Combat, CustomContainer, Instance = ...
        local total, top, amount = 0, 0, 0

        if _G.Details_Elitism then
            local Container = Combat:GetActorList(DETAILS_ATTRIBUTE_MISC)
            for _, player in ipairs(Container) do
                if player:IsGroupPlayer() then
                    -- we only record the players in party
                    local damage, cnt = _G.Details_Elitism:GetRecord(Combat:GetCombatNumber(), player:guid())
                    if damage > 0 or cnt > 0 then
                        CustomContainer:AddValue(player, damage)
                    end
                end
            end

            total, top = CustomContainer:GetTotalAndHighestValue()
            amount = CustomContainer:GetNumActors()
        end

        return total, top, amount
    ]],
    tooltip = [[
        local Actor, Combat, Instance = ...
        local GameCooltip = GameCooltip

        if _G.Details_Elitism then
            local realCombat
            for i = -1, 25 do
                local current = Details:GetCombat(i)
                if current and current:GetCombatNumber() == Combat.combat_counter then
                    realCombat = current
                    break
                end
            end

            if not realCombat then return end

            local sortedList = {}
            _, _, spells = _G.Details_Elitism:GetRecord(Combat:GetCombatNumber(), realCombat[1]:GetActor(Actor.nome):guid())
            for spellID, spelldata in pairs(spells) do
                tinsert(sortedList, {spellID, spelldata.sum})
            end
            -- local spellList = realCombat[1]:GetActor(Actor.nome):GetSpellList()
            -- local orbName = _G.Details_Elitism:RequireOrbName()
            -- for spellID, spellTable in pairs(spellList) do
            --     local amount = spellTable.targets[orbName]
            --     if amount then
            --         tinsert(sortedList, {spellID, amount})
            --     end
            -- end
            sort(sortedList, Details.Sort2)

            local format_func = Details:GetCurrentToKFunction()
            for _, tbl in ipairs(sortedList) do
                local spellID, amount = unpack(tbl)
                local spellName, _, spellIcon = Details.GetSpellInfo(spellID)

                GameCooltip:AddLine(spellName, format_func(_, amount))
                Details:AddTooltipBackgroundStatusbar()
                GameCooltip:AddIcon(spellIcon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
            end
        end
    ]],
    total_script = [[
        local value, top, total, Combat, Instance, Actor = ...

        local format_func = Details:GetCurrentToKFunction()
        if _G.Details_Elitism then
            local damage, cnt = _G.Details_Elitism:GetRecord(Combat:GetCombatNumber(), Actor.my_actor.serial)
            return "" .. format_func(_, damage) .. " (" .. cnt .. ")"
            -- return _G.Details_Elitism:GetDisplayText(Combat:GetCombatNumber(), Actor.my_actor.serial)
        end
        return ""
    ]]
}

DE.CustomDisplayAuras = {
    name = L["Avoidable Abilities Taken"],
    icon = 2175503,
    source = false,
    attribute = false,
    spellid = false,
    target = false,
    author = "Bass",
    desc = L["Show how many avoidable abilities hit players."],
    script_version = 1,
    script = [[
        local Combat, CustomContainer, Instance = ...
        local total, top, amount = 0, 0, 0

        if _G.Details_Elitism then
            local Container = Combat:GetActorList(DETAILS_ATTRIBUTE_MISC)
            for _, player in ipairs(Container) do
                if player:IsGroupPlayer() then
                    -- we only record the players in party
                    local cnt, _ = _G.Details_Elitism:GetAuraRecord(Combat:GetCombatNumber(), player:guid())
                    -- _G.Details_Elitism:Debug("guid %s target %s hit %s", player:guid() or 0, target or 0,hit or 0)
                    if cnt > 0 then
                        CustomContainer:AddValue(player, cnt)
                    end
                end
            end

            total, top = CustomContainer:GetTotalAndHighestValue()
            amount = CustomContainer:GetNumActors()
        end

        return total, top, amount
    ]],
    tooltip = [[
        local Actor, Combat, Instance = ...
        local GameCooltip = GameCooltip

        if _G.Details_Elitism then
            local realCombat
            for i = -1, 25 do
                local current = Details:GetCombat(i)
                if current and current:GetCombatNumber() == Combat.combat_counter then
                    realCombat = current
                    break
                end
            end

            if not realCombat then return end

            local sortedList = {}
            _, spells = _G.Details_Elitism:GetAuraRecord(Combat:GetCombatNumber(), realCombat[1]:GetActor(Actor.nome):guid())
            for spellID, spelldata in pairs(spells) do
                tinsert(sortedList, {spellID, spelldata.cnt})
            end
            -- local spellList = realCombat[1]:GetActor(Actor.nome):GetSpellList()
            -- local orbName = _G.Details_Elitism:RequireOrbName()
            -- for spellID, spellTable in pairs(spellList) do
            --     local amount = spellTable.targets[orbName]
            --     if amount then
            --         tinsert(sortedList, {spellID, amount})
            --     end
            -- end
            sort(sortedList, Details.Sort2)

            local format_func = Details:GetCurrentToKFunction()
            for _, tbl in ipairs(sortedList) do
                local spellID, cnt = unpack(tbl)
                local spellName, _, spellIcon = Details.GetSpellInfo(spellID)

                GameCooltip:AddLine(spellName, format_func(_, cnt))
                Details:AddTooltipBackgroundStatusbar()
                GameCooltip:AddIcon(spellIcon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
            end
        end
    ]],
    total_script = [[
        local value, top, total, Combat, Instance, Actor = ...

        local format_func = Details:GetCurrentToKFunction()
        if _G.Details_Elitism then
            local cnt, _ = _G.Details_Elitism:GetAuraRecord(Combat:GetCombatNumber(), Actor.my_actor.serial)
            return "" .. cnt
        end
        return ""
    ]]
}

DE.Spells = {
    -- Debug
    -- [] = 20,      --  ()
    -- [252144] = 1,
    -- [252150] = 1,

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
    [324154] = 20, -- Dark Stride (Venturax)
    [323943] = 20, -- Run Through (Devos)
    [334625] = 20, -- Seed of the Abyss (Devos)

    -- The Necrotic Wakes
    [324391] = 20, -- Frigid Spikes (Skeletal Monstrosity)
    [324381] = 20, -- Chill Scythe (Skeletal Monstrosity)
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

DE.SpellsNoTank = {
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

DE.Auras = {
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

DE.AurasNoTank = {}

DE.Swings = {
    [161917] = 20, -- DEBUG
    [174773] = 20 -- Spiteful Shade
}

-- Public APIs

function Engine:GetRecord(combatID, playerGUID)
    if DE.db[combatID] and DE.db[combatID][playerGUID] then
        return DE.db[combatID][playerGUID].sum or 0, DE.db[combatID][playerGUID].cnt or 0, DE.db[combatID][playerGUID].spells
    end
    return 0, 0, {}
end

function Engine:GetAuraRecord(combatID, playerGUID)
    if DE.db[combatID] and DE.db[combatID][playerGUID] then
        return DE.db[combatID][playerGUID].auracnt or 0, DE.db[combatID][playerGUID].auras
    end
    return 0, {}
end

function Engine:GetDisplayText(combatID, playerGUID)
    if DE.db[combatID] and DE.db[combatID][playerGUID] then
        return L["Damage: "] .. (DE.db[combatID][playerGUID].sum or 0) .. " " .. L["Hits: "] .. (DE.db[combatID][playerGUID].cnt or 0)
    end
    return L["Damage: "] .. "0 " .. L["Hits: "] .. "0"
end

-- Private Functions

function DE:Debug(...)
    if self.debug then
        _G.DEFAULT_CHAT_FRAME:AddMessage("|cFF70B8FFDetails Elitism:|r " .. format(...))
    end
end

function DE:COMBAT_LOG_EVENT_UNFILTERED()
    if not self.current then
        return
    end
    local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
    local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
    if self.debugFakeData then
        DE:SpellDamage(0, 0, UnitGUID("player"), UnitName("player"), 0, UnitGUID("player"), UnitName("player"), 0, 324141, 0, 0, 30)
        DE:AuraApply(0, 0, UnitGUID("player"), UnitName("player"), 0, UnitGUID("player"), UnitName("player"), 0, 323137, 0, 0, 0, 0)
        -- only the second last number matters! "Creature-this-does-not-matter-174773-thisdoesnteither"
        DE:SwingDamage(0, 0, "Creature-0-1465-0-2105-174773-000043F59F", UnitName("player"), 0, UnitGUID("player"), UnitName("player"), 0, 100)
    end
    if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
        local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12, CombatLogGetCurrentEventInfo())
        DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
    elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
        local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12, CombatLogGetCurrentEventInfo())
        DE:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
    elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
        local spellId, spellName, spellSchool, missType, isOffHand, mAmount = select(12, CombatLogGetCurrentEventInfo())
        if mAmount then
            DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
        end
    elseif eventType == "SPELL_AURA_APPLIED" then
        local spellId, spellName, spellSchool, auraType = select(12, CombatLogGetCurrentEventInfo())
        DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
    elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
        local spellId, spellName, spellSchool, auraType, auraAmount = select(12, CombatLogGetCurrentEventInfo())
        DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
    end
end

function DE:EnsureUnitData(combatNumber, unitGUID)
    if not self.db[combatNumber] then
        self.db[combatNumber] = {}
    end
    if not self.db[combatNumber][unitGUID] then
        self.db[combatNumber][unitGUID] = {sum = 0, cnt = 0, spells = {}, auras = {}, auracnt = 0}
    end
end

function DE:EnsureSpellData(combatNumber, unitGUID, spellId)
    DE:EnsureUnitData(combatNumber, unitGUID)
    if not self.db[combatNumber][unitGUID].spells then
        self.db[combatNumber][unitGUID].spells = {}
    end
    if not self.db[combatNumber][unitGUID].spells[spellId] then
        self.db[combatNumber][unitGUID].spells[spellId] = {cnt = 0, sum = 0}
    end
end

function DE:EnsureAuraData(combatNumber, unitGUID, spellId)
    DE:EnsureUnitData(combatNumber, unitGUID)
    if not self.db[combatNumber][unitGUID].auras then
        self.db[combatNumber][unitGUID].auras = {}
    end
    if not self.db[combatNumber][unitGUID].auras[spellId] then
        self.db[combatNumber][unitGUID].auras[spellId] = {cnt = 0}
    end
end

function DE:RecordSpellDamage(unitGUID, spellId, aAmount)
    DE:EnsureSpellData(self.current, unitGUID, spellId)
    DE:EnsureSpellData(self.overall, unitGUID, spellId)

    local registerHit = function(where)
        where.sum = where.sum + aAmount
        where.cnt = where.cnt + 1
        where.spells[spellId].sum = where.spells[spellId].sum + aAmount
        where.spells[spellId].cnt = where.spells[spellId].cnt + 1
    end

    registerHit(self.db[self.overall][unitGUID])
    registerHit(self.db[self.current][unitGUID])
end

function DE:RecordAuraHit(unitGUID, spellId)
    DE:EnsureAuraData(self.current, unitGUID, spellId)
    DE:EnsureAuraData(self.overall, unitGUID, spellId)

    local registerHit = function(where)
        where.auracnt = where.auracnt + 1
        where.auras[spellId].cnt = where.auras[spellId].cnt + 1
    end

    registerHit(self.db[self.overall][unitGUID])
    registerHit(self.db[self.current][unitGUID])
end

function DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
    local unitGUID = dstGUID
    if (DE.Spells[spellId] or (DE.SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
        DE:RecordSpellDamage(unitGUID, spellId, aAmount)

    end
end

function DE:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
    local unitGUID = dstGUID
    local meleeSpellId = 260421

    if (DE.Swings[DE:srcGUIDtoID(srcGUID)] and UnitIsPlayer(dstName)) then
        DE:RecordSpellDamage(unitGUID, meleeSpellId, aAmount)
    end
end

function DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
    local unitGUID = dstGUID
    if (DE.Auras[spellId] or (DE.AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
        DE:RecordAuraHit(unitGUID, spellId)
        -- if auraAmount and ElitismHelperDB.Loud then
        --     maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
        -- elseif ElitismHelperDB.Loud then
        --     maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".")
        -- end
    end
end

function DE:InitDataCollection()
    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
end

function DE:MergeCombat(to, from)
    if self.db[from] then
        self:Debug("Merging combat %s into %s", from, to)
        if not self.db[to] then
            self.db[to] = {}
        end
        for playerGUID, tbl in pairs(self.db[from]) do
            if not self.db[to][playerGUID] then
                self.db[to][playerGUID] = {sum = 0, cnt = 0, spells = {}, auras = {}, auracnt = 0}
            end
            self.db[to][playerGUID].sum = self.db[to][playerGUID].sum + (tbl.sum or 0)
            self.db[to][playerGUID].cnt = self.db[to][playerGUID].cnt + (tbl.cnt or 0)

            self.db[to][playerGUID].auracnt = self.db[to][playerGUID].auracnt + (tbl.auracnt or 0)

            for spellId, spelltbl in pairs(tbl.spells) do

                if not self.db[to][playerGUID].spells[spellId] then
                    self.db[to][playerGUID].spells[spellId] = {cnt = 0, sum = 0}
                end
                self.db[to][playerGUID].spells[spellId].cnt = self.db[to][playerGUID].spells[spellId].cnt + spelltbl.cnt
                self.db[to][playerGUID].spells[spellId].sum = self.db[to][playerGUID].spells[spellId].sum + spelltbl.sum
            end

            for spellId, spelltbl in pairs(tbl.auras) do

                if not self.db[to][playerGUID].auras[spellId] then
                    self.db[to][playerGUID].auras[spellId] = {cnt = 0}
                end
                self.db[to][playerGUID].auras[spellId].cnt = self.db[to][playerGUID].auras[spellId].cnt + spelltbl.cnt
            end

        end
    end
end

function DE:MergeSegmentsOnEnd()
    self:Debug("on Details MergeSegmentsOnEnd")

    local overall = Details:GetCombat(1):GetCombatNumber()
    for i = 2, 25 do
        local combat = Details:GetCombat(i)
        if not combat or not combat:IsMythicDungeon() or combat:IsMythicDungeonOverall() then
            break
        end

        self:MergeCombat(overall, combat:GetCombatNumber())
    end

    self:CleanDiscardCombat()
end

function DE:MergeTrashCleanup()
    self:Debug("on Details MergeTrashCleanup")

    local baseCombat = Details:GetCombat(2)
    -- killed boss before any trash combats
    if not baseCombat or not baseCombat:IsMythicDungeon() or baseCombat:IsMythicDungeonOverall() then
        return
    end

    local base = baseCombat:GetCombatNumber()
    local prevCombat = Details:GetCombat(3)
    if prevCombat then
        local prev = prevCombat:GetCombatNumber()
        for i = prev + 1, base - 1 do
            if i ~= self.overall then
                self:MergeCombat(base, i)
            end
        end
    else
        local minCombat
        for combatID in pairs(self.db) do
            minCombat = minCombat and min(minCombat, combatID) or combatID
        end

        if minCombat then
            for i = minCombat, base - 1 do
                self:MergeCombat(base, i)
            end
        end
    end

    self:CleanDiscardCombat()
end

function DE:MergeRemainingTrashAfterAllBossesDone()
    self:Debug("on Details MergeRemainingTrashAfterAllBossesDone")

    local prevTrash = Details:GetCombat(2)
    if prevTrash then
        local prev = prevTrash:GetCombatNumber()
        self:MergeCombat(prev, self.current)
    end

    self:CleanDiscardCombat()
end

function DE:CleanDiscardCombat()
    local remain = {}

    for i = 1, 25 do
        local combat = Details:GetCombat(i)
        if not combat then
            break
        end

        remain[combat:GetCombatNumber()] = true
    end

    for key in pairs(self.db) do
        if not remain[key] then
            self.db[key] = nil
        end
    end
end

function DE:OnDetailsEvent(event, combat)
    -- self here is not DE, this function is called from DE.EventListener
    if event == 'COMBAT_PLAYER_ENTER' then
        DE.current = combat:GetCombatNumber()
        DE:Debug("COMBAT_PLAYER_ENTER: %s", DE.current)
    elseif event == 'COMBAT_PLAYER_LEAVE' then
        DE.current = combat:GetCombatNumber()
        DE:Debug("COMBAT_PLAYER_LEAVE: %s", DE.current)

        if not DE.current or not DE.db[DE.current] then
            return
        end
        -- for _, list in pairs(DE.db[DE.current]) do
        --     for key in pairs(list) do
        --         if key ~= 'target' and key ~= 'hit' then
        --             list[key] = nil
        --         end
        --     end
        -- end
    elseif event == 'DETAILS_DATA_RESET' then
        DE:Debug("DETAILS_DATA_RESET")
        self.overall = Details:GetCombat(-1):GetCombatNumber()
        DE:CleanDiscardCombat()
    end
end

function DE:ResetOverall()
    self:Debug("on Details Reset Overall (Details.historico.resetar_overall)")

    if self.overall and self.db[self.overall] then
        self.db[self.overall] = nil
    end
    self.overall = Details:GetCombat(-1):GetCombatNumber()
end

function DE:LoadHooks()
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeSegmentsOnEnd')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeTrashCleanup')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeRemainingTrashAfterAllBossesDone')

    self:SecureHook(Details.historico, 'resetar_overall', 'ResetOverall')
    self.overall = Details:GetCombat(-1):GetCombatNumber()

    self.EventListener = Details:CreateEventListener()
    self.EventListener:RegisterEvent('COMBAT_PLAYER_ENTER')
    self.EventListener:RegisterEvent('COMBAT_PLAYER_LEAVE')
    self.EventListener:RegisterEvent('DETAILS_DATA_RESET')
    self.EventListener.OnDetailsEvent = self.OnDetailsEvent

    Details:InstallCustomObject(self.CustomDisplay)
    Details:InstallCustomObject(self.CustomDisplayAuras)
    self:CleanDiscardCombat()
end

function DE:OnInitialize()
    -- load database
    self.db = ElitismLog or {}
    ElitismLog = self.db

    -- unit event frames
    -- self.eventFrames = {}
    -- for i = 1, 5 do
    --     self.eventFrames[i] = CreateFrame('frame')
    --     self.eventFrames[i]:SetScript('OnEvent', targetChanged)
    -- end

    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'InitDataCollection')
    self:RegisterEvent('CHALLENGE_MODE_START', 'InitDataCollection')

    self:SecureHook(Details, 'StartMeUp', 'LoadHooks')
end

function DE:srcGUIDtoID(srcGUID)
    local sep = "-"
    local t = {}
    for str in string.gmatch(srcGUID, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return tonumber(t[#t - 1])
end
