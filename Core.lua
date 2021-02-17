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

DE.Spells = {}

DE.SpellsNoTank = {}

DE.Auras = {}

DE.AurasNoTank = {}

DE.Swings = {}

DE.RaidSpells = {}

DE.AuraTracker = {}

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

function Engine:PrintDebugInfo()
    local oldDebug = DE.debug
    DE.debug = true
    DE:Debug("Overall Combat ID: %s", tostring(DE.overall))
    -- TODO: add more debug information
    DE.debug = oldDebug
end

function Engine:setDebug(enabled)
    DE.debug = enabled
end

function Engine:setDebugFakeData(enabled)
    DE.debugFakeData = enabled
end

-- Private Functions

function DE:MergeTables(t1, t2, replace)
    local force_replace = (replace ~= false)
    for k, v in pairs(t2) do
        if force_replace or t1[k] ~= nil then
            t1[k] = v
        end
    end
    return t1
end

function DE:MergeTableImmmutable(t1, t2)
    local result = {}
    DE.MergeTables(result, t2)
    DE.MergeTables(result, t1, false)
    return result
end

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
        -- raid test
        -- Wicked Blade
        DE:SpellDamage(0, 0, UnitGUID("player"), UnitName("player"), 0, UnitGUID("player"), UnitName("player"), 0, 344230, 0, 0, 30)
        -- Wicked Blade debuff
        DE:AuraApply(0, 0, UnitGUID("player"), UnitName("player"), 0, UnitGUID("player"), UnitName("player"), 0, 333377, 0, 0, 0, 0)

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
    elseif eventType == "SPELL_AURA_REMOVED" then
        local spellId, spellName, spellSchool, auraType = select(12, CombatLogGetCurrentEventInfo())
        DE:AuraRemove(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
    elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
        local spellId, spellName, spellSchool, auraType, auraAmount = select(12, CombatLogGetCurrentEventInfo())
        DE:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
    elseif eventType == "UNIT_DIED" then
        DE:ResetTracking(dstGUID)
    end
end

function DE:EnsureTrackingData(unitGUID)
    if not self.tracker[unitGUID] then
        self.tracker[unitGUID] = {debuffs = {}}
    end
end

function DE:EnsureDebuffTrackingData(unitGUID, spellId)
    DE:EnsureTrackingData(unitGUID)
    if not self.tracker[unitGUID].debuffs[spellId] then
        self.tracker[unitGUID].debuffs[spellId] = {hits = 0, active = false, spellTracker = {}}
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

function DE:ResetTracking(unitGUID)
    -- TODO: what if a debuff persists after death?
    self.tracker[unitGUID] = nil
end

function DE:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
    local unitGUID = dstGUID
    if DE.RaidSpells[spellId] then
        local recordHit = true
        if type(DE.RaidSpells[spellId]) == "table" and DE.RaidSpells[spellId].ignoreDebuffs then
            for debuffId, _ in pairs(DE.RaidSpells[spellId].ignoreDebuffs) do
                DE:EnsureDebuffTrackingData(unitGUID, debuffId)
                local lastHitCount = (self.tracker[unitGUID].debuffs[debuffId].spellTracker[spellId] or {hits = 0}).hits
                local currentHitCount = self.tracker[unitGUID].debuffs[debuffId].hits
                -- if we were hit by the debuff since the last spell hit (or the start of the fight), this hit should be ignored
                if (lastHitCount ~= currentHitCount) then
                    recordHit = false
                end
                self.tracker[unitGUID].debuffs[debuffId].spellTracker[spellId] = {hits = self.tracker[unitGUID].debuffs[debuffId].hits}

            end
        end
        if recordHit then
            DE:RecordSpellDamage(unitGUID, spellId, aAmount)
        end
    end
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
    if (DE.AuraTracker[spellId]) then
        if DE.AuraTracker[spellId].debuff then
            DE:EnsureDebuffTrackingData(unitGUID, spellId)
            local debuffs = self.tracker[unitGUID].debuffs[spellId]
            debuffs.hits = debuffs.hits + 1
            debuffs.active = true
        end
    end
    if (DE.Auras[spellId] or (DE.AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
        DE:RecordAuraHit(unitGUID, spellId)
        -- if auraAmount and ElitismHelperDB.Loud then
        --     maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
        -- elseif ElitismHelperDB.Loud then
        --     maybeSendChatMessage("<EH> "..dstName.." got hit by "..GetSpellLink(spellId)..".")
        -- end
    end
end

function DE:AuraRemove(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
    local unitGUID = dstGUID
    if (DE.AuraTracker[spellId]) then
        if DE.AuraTracker[spellId].debuff then
            DE:EnsureDebuffTrackingData(unitGUID, spellId)
            local debuffs = self.tracker[unitGUID].debuffs[spellId]
            debuffs.active = false
        end
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
    if self.overall then
        remain[self.overall] = true
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
        DE:UpdateOverall()
        DE:CleanDiscardCombat()
    end
end

function DE:ResetOverall()
    self:Debug("on Details Reset Overall (Details.historico.resetar_overall)")
    DE:UpdateOverall()
end

function DE:UpdateOverall()
    local newOverall = Details:GetCombat(-1):GetCombatNumber()

    if self.overall and self.overall ~= newOverall and self.db[self.overall] then
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

    self.tracker = {}

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
