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
    ]],
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
    ]],
}

DE.Spells = {
	-- Debug
	--[252144] = 1,
	--[252150] = 1,

  -- Reaping
	--[290085] = 20,          -- Expel Soul (Environment)
	[296142] = 20,          -- Shadow Smash (Lost Soul)
	-- [288693] = 20,          -- Grave Bolt (Tormented Soul) Is this really avoidable?
	
	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 20,		-- Sanguine Ichor (Environment)

	-- Freehold
	[272046] = 20,		--- Dive Bomb (Sharkbait)
	[257426] = 20,		--- Brutal Backhand (Irontide Enforcer)
	[258352] = 20,		--- Grapeshot (Captain Eudora)
	[256594] = 20,		--- Barrel Smash (Captain Raoul)
	[272374] = 20,		--- Whirlpool of Blades (Captain Jolly)
	[256546] = 20,		--- Shark Tornado (Trothak)
	[257310] = 20,		--- Cannon Barrage (Harlan Sweete)
	[257784] = 20,		--- Frost Blast (Bilge Rat Brinescale)
	[257902] = 20,		--- Shell Bounce (Ludwig Von Tortollan)
	[258199] = 20,		--- Ground Shatter (Irontide Crusher)
	[276061] = 20,		--- Boulder Throw (Irontide Crusher)
	[258779] = 20,		--- Sea Spout (Irontide Oarsman)
	[274400] = 20,		--- Duelist Dash (Cutwater Duelist)
	[257274] = 20,		--- Vile Coating (Environment)
	[258673] = 20,		--- Azerite Grenade (Irontide Crackshot)
	[274389] = 20,		--- Rat Traps (Vermin Trapper)
	[257460] = 20,		--- Fiery Debris (Harlan Sweete)
	--[257871] = 20,		--- Blade Barrage (Irontide Buccaneer)
	--[257757] = 20,		--- Goin' Bananas (Bilge Rat Buccaneer)
	
	-- Shrine of the Storm
	[276268] = 20,		--- Heaving Blow (Shrine Templar)
	[267973] = 20,		--- Wash Away (Temple Attendant)
	[268059] = 20,		--- Anchor of Binding (Tidesage Spiritualist)
	[264155] = 20,		--- Surging Rush (Aqu'sirr)
	[267841] = 20,		--- Blowback (Galecaller Faye)
	[267899] = 20,		--- Hindering Cleave (Brother Ironhull)
	[268280] = 20,		--- Tidal Pod (Tidesage Enforcer)
	[276286] = 20,		--- Slicing Hurricane (Galecaller Apprentice)
	[276292] = 20,		--- Whirlign Slam (Ironhull Apprentice)
	[267385] = 20,		--- Tentacle Slam (Vol'zith the Whisperer)
	
	-- Siege of Boralus
	[256627] = 20,		--- Slobber Knocker (Kul Tiran Halberd)
	[256663] = 20,		--- Burning Tar (Blacktar Bomber)
	[275775] = 20,		--- Savage Tempest (Irontide Raider)
	[257292] = 20,		--- Heavy Slash (Kul Tiran Vanguard)
	[272426] = 20,		--- Sighted Artillery (Ashvane Spotter)
	[257069] = 20,		--- Watertight Shell (Kul Tiran Wavetender)
	[273681] = 20,		--- Heavy Hitter (Chopper Redhook)
	[272874] = 20,		--- Trample (Ashvane Commander)
	[268260] = 20,		--- Broadside (Ashvane Cannoneer)
	[269029] = 20,		--- Clear the Deck (Dread Captain Lockwood)
	[268443] = 20,		--- Dread Volley (Dread Captain Lockwood)
	[272713] = 20,		--- Crushing Slam (Bilge Rat Demolisher)
	[274941] = 20,		--- Banana Rampage swirlies(Bilge Rat Buccaneer)
	[257883] = 20,		--- Break Water (Hadal Darkfathom)
	[276068] = 20,		--- Tidal Surge (Hadal Darkfathom)
	[257886] = 20,		--- Brine Pool (Hadal Darkfathom)
	[261565] = 20,		--- Crashing Tide (Hadal Darkfathom)
	[277535] = 20,		--- Viq'Goth's Wrath (Viq'Goth)
	
	-- Tol Dagor
	[257119] = 20,		--- Sand Trap (The Sand Queen)
	[257785] = 20,		--- Flashing Daggers (Jes Howlis)
	[256976] = 20,		--- Ignition (Knight Captain Valyri)
	[256955] = 20,		--- Cinderflame (Knight Captain Valyri)
	[256083] = 20,		--- Cross Ignition (Overseer Korgus)
	[263345] = 20,		--- Massive Blast (Overseer Korgus)
	[258364] = 20,		--- Fuselighter (Ashvane Flamecaster)
	[259711] = 20,		--- Lockdown (Ashvane Warden)
	[256710] = 20,		--- Burning Arsenal (Knight Captain Valyri)
	
	-- Waycrest Manor
	[264531] = 20,		--- Shrapnel Trap (Maddened Survivalist)
	[264476] = 20,		--- Tracking Explosive (Crazed Marksman)
	[260569] = 20,		--- Wildfire (Soulbound Goliath)
	[265407] = 20,		--- Dinner Bell (Banquet Steward)
	[264923] = 20,		--- Tenderize (Raal the Gluttonous)
	[264712] = 20,		--- Rotten Expulsion (Raal the Gluttonous)
	[272669] = 20,		--- Burning Fists (Soulbound Goliath)
	[278849] = 20,		--- Uproot (Coven Thornshaper)
	[264040] = 20,		--- Uprooted Thorns (Coven Thornshaper)
	[265757] = 20,		--- Splinter Spike (Matron Bryndle)
	[264150] = 20,		--- Shatter (Thornguard)
	[268387] = 20,		--- Contagious Remnants (Lord Waycrest)
	[268308] = 20,		--- Discordant Cadenza (Lady Waycrest

	-- Atal'Dazar
	[253666] = 20,		--- Fiery Bolt (Dazar'ai Juggernaught)
	[257692] = 20,		--- Tiki Blaze (Environment)
	[255620] = 20,		--- Festering Eruption (Reanimated Honor Guard)
	[258723] = 20,		--- Grotesque Pool (Renaimated Honor Guard)
	[250259] = 20,		--- Toxic Leap (Vol'kaal)
	[250022] = 20,		--- Echoes of Shadra (Yazma)
	[250585] = 20, 		--- Toxic Pool (Vol'kaal)
	[250036] = 20,		--- Shadowy Remains (Echoes of Shadra)
	[255567] = 20,		--- Frenzied Charge (T'lonja)

	-- King's Rest
	[270003] = 20,		--- Suppression Slam (Animated Guardian)
	[269932] = 20,		--- Ghust Slash (Shadow-Borne Warrior)
	[265781] = 20,		--- Serpentine Gust (The Golden Serpent)
	[265914] = 20,		--- Molten Gold (The Golden Serpent)
	[270928] = 20,		--- Bladestorm (King Timalji)
	[270931] = 20,		--- Darkshot (Queen Patlaa)
	[270891] = 20,		--- Channel Lightning (King Rahu'ai)
	[266191] = 20,		--- Whirling Axe (Council of Tribes)
	[270292] = 20,		--- Purifying Flame (Purification Construct)
	[270503] = 20,		--- Hunting Leap (Honored Raptor)
	[270514] = 20,		--- Ground Crush (Spectral Brute)
	[271564] = 20,		--- Embalming Fluid (Embalming Fluid)
	[270485] = 20,		--- Blooded Leap (Spectral Berserker)
	[267639] = 20,		--- Burn Corruption (Mchimba the Embalmer)
	[268419] = 20,		--- Gale Slash (King Dazar)
	[268796] = 20,		--- Impaling Spear (King Dazar)
	
	-- The MOTHERLODE!!
	[257371] = 20,		--- Gas Can (Mechanized Peace Keeper)
	[262287] = 20,		--- Concussion Charge (Mech Jockey / Venture Co. Skyscorcher)
	[268365] = 20,		--- Mining Charge (Wanton Sapper)
	[269313] = 20,		--- Final Blast (Wanton Sapper)
	[275907] = 20,		--- Tectonic Smash (Azerokk)
	[259533] = 20,		--- Azerite Catalyst (Rixxa Fluxflame)
	[260103] = 20,		--- Propellant Blast (Rixxa Fluxflame)
	[260279] = 20,		--- Gattling Gun (Mogul Razdunk)
	[276234] = 20, 		--- Micro Missiles (Mogul Razdunk)
	[270277] = 20,		--- Big Red Rocket (Mogul Razdunk)
	[271432] = 20,		--- Test Missile (Venture Co. War Machine)
	--[262348] = 20,		--- Mine Blast (Crawler Mine)
	[257337] = 20,		--- Shocking Claw (Coin-Operated Pummeler)
	[268417] = 20,		--- Power Through (Azerite Extractor)
	[268704] = 20,		--- Furious Quake (Stonefury)
	[258628] = 20,		--- Resonant Quake (Earthrager)
	[269092] = 20,		--- Artillery Barrage (Ordnance Specialist)
	[271583] = 20,		--- Black Powder Special (Mines near the track)
	[269831] = 20,		--- Toxic Sludge (Oil Environment)

	-- Temple of Sethraliss
	[263425] = 20,		--- Arc Dash (Adderis)
	[268851] = 20,		--- Lightning Shield (Aspix and Adderis)
	[263573] = 20,		--- Cyclone Strike (Adderis)
	[273225] = 20,		--- Volley (Sandswept Marksman)
	[272655] = 20,		--- Scouring Sand (Mature Krolusk)
	[273995] = 20,		--- Pyrrhic Blast (Crazed Incubator)
	[272696] = 20,		--- Lightning in a Bottle (Crazed Incubator)
	[264206] = 20,		--- Burrow (Merektha)
	[272657] = 20,		--- Noxious Breath (Merektha)
	[272821] = 20,		--- Call Lightning (Imbued Stormcaller)
	[264763] = 20,		--- Spark (Static-charged Dervish)
	[279014] = 20,		--- Cardiac Shock (Avatar, Environment)
	
	-- Underrot
	[265542] = 20,		--- Rotten Bile (Fetid Maggot)
	[265019] = 20,		--- Savage Cleave (Chosen Blood Matron)
	[261498] = 20,		--- Creeping Rot (Elder Leaxa)
	[264757] = 20,		--- Sanguine Feast (Elder Leaxa)
	[265665] = 20,		--- Foul Sludge (Living Rot)
	[260312] = 20,		--- Charge (Cragmaw the Infested)
	[265511] = 20,		--- Spirit Drain (Spirit Drain Totem)
	[259720] = 20,		--- Upheaval (Sporecaller Zancha)
	[270108] = 20,		--- Rotting Spore (Unbound Abomination)
	[272609] = 20,		--- Maddenin Gaze (Faceless Corruptor)
	[272469] = 20,		--- Abyssal Slam (Faceless Corruptor)
	[270108] = 20,		--- Rotting Spore (Unbound Abomination)
	
	-- Mechagon Workshop
	[294128] = 20,		--- Rocket Barrage (Rocket Tonk)
	[285020] = 20,		--- Whirling Edge (The Platinum Pummeler)
	[294291] = 20,		--- Process Waste ()
	[291930] = 20,		--- Air Drop (K.U-J.0)
	[294324] = 20,		--- Mega Drill (Waste Processing Unit)
	[293861] = 20,		--- Anti-Personnel Squirrel (Anti-Personnel Squirrel)
	[295168] = 20,		--- Capacitor Discharge (Blastatron X-80)
	[294954] = 20,		--- Self-Trimming Hedge (Head Machinist Sparkflux)
	
	
	-- Mechagon Junkyard
	[300816] = 20,		--- Slimewave (Slime Elemental)
	[300188] = 20,		--- Scrap Cannon (Weaponized Crawler)
	[300427] = 20,		--- Shockwave (Scrapbone Bully)
	[294890] = 20,		--- Gryro-Scrap (Malfunctioning Scrapbot)
	[300129] = 20,		--- Self-Destruct Protocol (Malfunctioning Scrapbot)
	[300561] = 20,		--- Explosion (Scrapbone Trashtosser)
	[299475] = 20,		--- B.O.R.K. (Scraphound)
	[299535] = 20,		--- Scrap Blast (Pistonhead Blaster)
	[298940] = 20,		--- Bolt Buster (Naeno Megacrash)
	[297283] = 20,		--- Cave In (King Gobbamak)
	
	
	--- Awakened Lieutenant
	[314309] = 20,		--- Dark Fury (Urg'roth, Breaker of Heroes)
	[314467] = 20,		--- Volatile Rupture (Voidweaver Mal'thir)
	[314565] = 20,		--- Defiled Ground (Blood of the Corruptor)
}

DE.SpellsNoTank = {
	-- Freehold

	-- Shrine of the Storm
	
	-- Siege of Boralus
	[268230] = 20,		--- Crimson Swipe (Ashvane Deckhand)
	
	-- Tol Dagor
	[258864] = 20,		--- Suppression Fire (Ashvane Marine/Spotter)
	
	-- Waycrest Manor
	[263905] = 20,		--- Marking Cleave (Heartsbane Runeweaver)
	[265372] = 20,		---	Shadow Cleave (Enthralled Guard)
	[271174] = 20,		--- Retch (Pallid Gorger)
	
	-- Atal'Dazar

	-- King's Rest
	[270289] = 20,		--- Purification Beam (Purification Construct)
	
	-- The MOTHERLODE!!
	[268846] = 20,		--- Echo Blade (Weapons Tester)
	[263105] = 20,		--- Blowtorch (Feckless Assistant)
	[263583] = 20,		--- Broad Slash (Taskmaster Askari)
		
	-- Temple of Sethraliss
	[255741] = 20,		--- Cleave (Scaled Krolusk Rider)

	-- Underrot
	[272457] = 20,		--- Shockwave (Sporecaller Zancha)
	[260793] = 20,		--- Indigestion (Cragmaw the Infested)
	
}

DE.Auras = {
	-- Freehold
	[274516] = true,		-- Slippery Suds
	
	-- Shrine of the Storm
	[268391] = true,		-- Mental Assault (Abyssal Cultist)
	[269104] = true,		-- Explosive Void (Lord Stormsong)
	[267956] = true,		-- Zap (Jellyfish)
	
	-- Siege of Boralus
	[274942] = true,		-- Banana Stun
	[257169] = true,		-- Fear

	-- Tol Dagor
	[256474] = true,		-- Heartstopper Venom (Overseer Korgus)

	-- Waycrest Manor
	[265352] = true,		-- Toad Blight (Toad)
	[278468] = true,		-- Freezing Trap
	
	-- Atal'Dazar
	[255371] = true,		-- Terrifying Visage (Rezan)

	-- King's Rest
	[276031] = true,		-- Pit of Despair (Minion of Zul)

	-- The MOTHERLODE!!
	
	-- Temple of Sethraliss
	[269970] = true,		-- Blinding Sand (Merektha)

	-- Underrot
	
	-- Mechagon Workshop
	[293986] = true,		--- Sonic Pulse (Blastatron X-80)
	
	-- Mechaton Junkyard
	[398529] = true,		-- Gooped (Gunker)
	[300659] = true,		-- Consuming Slime (Toxic Monstrosity)
}

DE.AurasNoTank = {
	[272140] = true,		--- Iron Volley
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
    DE:SpellDamage(0, 0, UnitGUID("player"), "Bass", 0, UnitGUID("player"), "Bass", 0, 296142, 0, 0, 30)
    DE:AuraApply(0, 0, UnitGUID("player"), "Bass", 0, UnitGUID("player"), "Bass", 0, 274516, 0, 0, 0, 0)
	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		DE:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount  = select(12,CombatLogGetCurrentEventInfo())
		if mAmount then
			DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,CombatLogGetCurrentEventInfo())
		DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,CombatLogGetCurrentEventInfo())
		DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	end
end

function DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
    local unitGUID = dstGUID
    if (DE.Spells[spellId] or (DE.SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
        if not self.db[self.current] then self.db[self.current] = {} end
        if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {
            sum = 0,
            cnt = 0,
            spells = {},
            auras = {},
            auracnt = 0
        } end
        if not self.db[self.current][unitGUID].spells then
            self.db[self.current][unitGUID].spells = {}
        end
        if not self.db[self.current][unitGUID].spells[spellId] then self.db[self.current][unitGUID].spells[spellId] = {
            cnt = 0,
            sum = 0
        } end

        self.db[self.current][unitGUID].sum = self.db[self.current][unitGUID].sum + aAmount
        self.db[self.current][unitGUID].cnt = self.db[self.current][unitGUID].cnt + 1
        self.db[self.current][unitGUID].spells[spellId].sum = self.db[self.current][unitGUID].spells[spellId].sum + aAmount
        self.db[self.current][unitGUID].spells[spellId].cnt = self.db[self.current][unitGUID].spells[spellId].cnt + 1
	end
end

function DE:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
end

function DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
    local unitGUID = dstGUID
    if (DE.Auras[spellId] or (DE.AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName)  then
        if not self.db[self.current] then self.db[self.current] = {} end
        if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {
            sum = 0,
            cnt = 0,
            spells = {},
            auras = {},
            auracnt = 0
        } end
        if not self.db[self.current][unitGUID].auras[spellId] then self.db[self.current][unitGUID].auras[spellId] = {
            cnt = 0
        } end
        self.db[self.current][unitGUID].auracnt = self.db[self.current][unitGUID].auracnt + 1
        self.db[self.current][unitGUID].auras[spellId].cnt = self.db[self.current][unitGUID].auras[spellId].cnt + 1
		-- if auraAmount and ElitismHelperDB.Loud then
		-- 	maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
		-- elseif ElitismHelperDB.Loud then
		-- 	maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".")
		-- end
	end
end

function DE:RecordTarget(unitGUID, targetGUID)
    if not self.current then return end

    -- self:Debug("%s target %s in combat %s", unitGUID, targetGUID, self.current)

    if not self.db[self.current] then self.db[self.current] = {} end
    if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {} end
    if not self.db[self.current][unitGUID][targetGUID] then self.db[self.current][unitGUID][targetGUID] = 0 end

    if self.db[self.current][unitGUID][targetGUID] ~= 1 and self.db[self.current][unitGUID][targetGUID] ~= 3 then
        self.db[self.current][unitGUID][targetGUID] = self.db[self.current][unitGUID][targetGUID] + 1
        self.db[self.current][unitGUID].target = (self.db[self.current][unitGUID].target or 0) + 1
    end
end

function DE:RecordHit(unitGUID, targetGUID)
    if not self.current then return end

    -- self:Debug("%s hit %s in combat %s", unitGUID, targetGUID, self.current)

    if not self.db[self.current] then self.db[self.current] = {} end
    if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {} end
    if not self.db[self.current][unitGUID][targetGUID] then self.db[self.current][unitGUID][targetGUID] = 0 end

    if self.db[self.current][unitGUID][targetGUID] ~= 2 and self.db[self.current][unitGUID][targetGUID] ~= 3 then
        self.db[self.current][unitGUID][targetGUID] = self.db[self.current][unitGUID][targetGUID] + 2
        self.db[self.current][unitGUID].hit = (self.db[self.current][unitGUID].hit or 0) + 1
    end
end

function DE:InitDataCollection()
    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
end

function DE:MergeCombat(to, from)
    if self.db[from] then
        self:Debug("Merging combat %s into %s", from, to)
        if not self.db[to] then self.db[to] = {} end
        for playerGUID, tbl in pairs(self.db[from]) do
            if not self.db[to][playerGUID] then
                self.db[to][playerGUID] = {
                    sum = 0,
                    cnt = 0,
                    spells = {},
                    auras = {},
                    auracnt = 0
                }
            end
            self.db[to][playerGUID].sum = self.db[to][playerGUID].sum + (tbl.sum or 0)
            self.db[to][playerGUID].cnt = self.db[to][playerGUID].cnt + (tbl.cnt or 0)

            self.db[to][playerGUID].auracnt = self.db[to][playerGUID].auracnt + (tbl.auracnt or 0)

            for spellId, spelltbl in pairs(tbl.spells) do
                
                if not self.db[to][playerGUID].spells[spellId] then self.db[to][playerGUID].spells[spellId] = {
                    cnt = 0,
                    sum = 0
                } end
                self.db[to][playerGUID].spells[spellId].cnt = self.db[to][playerGUID].spells[spellId].cnt + spelltbl.cnt
                self.db[to][playerGUID].spells[spellId].sum = self.db[to][playerGUID].spells[spellId].sum + spelltbl.sum
            end

            for spellId, spelltbl in pairs(tbl.auras) do
                
                if not self.db[to][playerGUID].auras[spellId] then self.db[to][playerGUID].auras[spellId] = {
                    cnt = 0
                } end
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
        if not combat or not combat:IsMythicDungeon() or combat:IsMythicDungeonOverall() then break end

        self:MergeCombat(overall, combat:GetCombatNumber())
    end

    self:CleanDiscardCombat()
end

function DE:MergeTrashCleanup()
    self:Debug("on Details MergeTrashCleanup")

    local baseCombat = Details:GetCombat(2)
    -- killed boss before any trash combats
    if not baseCombat or not baseCombat:IsMythicDungeon() or baseCombat:IsMythicDungeonOverall() then return end

    local base = baseCombat:GetCombatNumber()
    local prevCombat = Details:GetCombat(3)
    if prevCombat then
        local prev = prevCombat:GetCombatNumber()
        for i = prev + 1, base - 1 do
            self:MergeCombat(base, i)
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
        if not combat then break end

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

        if not DE.current or not DE.db[DE.current] then return end
        -- for _, list in pairs(DE.db[DE.current]) do
        --     for key in pairs(list) do
        --         if key ~= 'target' and key ~= 'hit' then
        --             list[key] = nil
        --         end
        --     end
        -- end
    elseif event == 'DETAILS_DATA_RESET' then
        DE:Debug("DETAILS_DATA_RESET")
        DE:CleanDiscardCombat()
    end
end

function DE:LoadHooks()
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeSegmentsOnEnd')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeTrashCleanup')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeRemainingTrashAfterAllBossesDone')

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

    self:SecureHook(Details, 'Start', 'LoadHooks')
end
