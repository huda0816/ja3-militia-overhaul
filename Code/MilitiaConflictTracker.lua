GameVar("gv_HUDA_ConflictTracker", {})

--------------------------------- hooks ---------------------------------
--------------------------------- hooks ---------------------------------
--------------------------------- hooks ---------------------------------

function OnMsg.ConflictStart(sectorId)
    HUDA_ConflictTracker:InitializeConflict(sectorId)
end

function OnMsg.ConflictEnd(sector, _, playerAttacked, playerWon, autoResolve, isRetreat)
    HUDA_ConflictTracker:ResolveConflict(sector, playerAttacked, playerWon, autoResolve, isRetreat)
end

function OnMsg.StatusEffectAdded(unit, statusEffect, stacks)
    HUDA_ConflictTracker:TrackStatusEffects(unit, statusEffect, stacks)
end

function OnMsg.MilitiaPromoted(unit, oldId)
    HUDA_ConflictTracker:TrackPromotions(unit, oldId)
end

function OnMsg.ReachSectorCenter(squadId, sectorId)
    HUDA_ConflictTracker:ExtendConflict(sectorId, squadId)
end

function OnMsg.OnAttack(unit, action, target, results, attack_args)
    HUDA_ConflictTracker:TrackActions(unit, results)
end

-- function OnMsg.AutoResolvedConflict(sectorId, player_outcome)

-- end

function OnMsg.UnitDiedOnSector(unit, sectorId)
    HUDA_ConflictTracker:TrackAutoresolveDeath(unit, sectorId)
end

--------------------------------- end of hooks ---------------------------------
--------------------------------- end of hooks ---------------------------------
--------------------------------- end of hooks ---------------------------------

DefineClass.HUDA_ConflictTracker = {
    TrackedEffects = {
        "Berserk",
        "BleedingOut",
        "Burning",
        "Focused",
        "Inspired",
        "Panicked",
        "Heroic"
    }
}

function HUDA_ConflictTracker:ResolveConflict(sector, playerAttacked, playerWon, autoResolve, isRetreat)
    local conflict = self:GetConflict(sector.Id)

    if not conflict then
        print("No unresolved conflict found for sector " .. sectorId .. ".")
        return
    end

    conflict.resolved = true
    conflict.playerWon = playerWon
    conflict.playerAttacked = playerAttacked
    conflict.autoResolve = autoResolve and true or false
    conflict.retreat = isRetreat
    conflict.endTime = Game.CampaignTime

    local aar = HUDA_AARGenerator:PrintAAR(conflict)

    local aarTitle = HUDA_AARGenerator:PrintAARTitle(conflict)

    conflict.aar = {
        title = aarTitle,
        text = aar
    }

    HUDA_AddNews({
        title = aarTitle,
        text = aar,
        date = Game.CampaignTime,
        sector = sector.Id,
        type = "AAR",
    })

end

function HUDA_ConflictTracker:InitializeConflict(sectorId)
    if self:GetConflict(sectorId) then
        print("Unresolved conflict already exists for sector " .. sectorId .. ".")
        return
    end

    local enemyLeader = self:GetLeader(sectorId, "enemy")
    local playerLeader = self:GetLeader(sectorId, "player")
    local allyLeader = self:GetLeader(sectorId, "ally")
    local militiaLeader = self:GetLeader(sectorId, "militia")

    local conflict = {
        sectorId = sectorId,
        civKilled = {},
        kills = {},
        wounds = {},
        specialEvents = {},
        promotions = {},
        playerWon = false,
        autoResolve = false,
        playerAttacked = false,
        retreat = false,
        resolved = false,
        startTime = Game.CampaignTime,
        endTime = 0,
        squads = self:GetConflictSquads(sectorId),
        militia = {
            units = self:GetUnitIds(sectorId, "militia"),
            leader = militiaLeader,
            killed = {},
            promotions = {},
            affiliation = militiaLeader and militiaLeader.affiliation or self:GetAffiliation(sectorId, "militia"),
        },
        enemy = {
            units = self:GetUnitIds(sectorId, "enemy"),
            leader = enemyLeader,
            killed = {},
            affiliation = enemyLeader and enemyLeader.affiliation or self:GetAffiliation(sectorId, "enemy"),
        },
        player = {
            units = self:GetUnitIds(sectorId, "player"),
            leader = playerLeader,
            killed = {},
            affiliation = playerLeader and playerLeader.affiliation or self:GetAffiliation(sectorId, "enemy"),
        },
        ally = {
            units = self:GetUnitIds(sectorId, "ally"),
            leader = allyLeader,
            killed = {},
            affiliation = allyLeader and allyLeader.affiliation or self:GetAffiliation(sectorId, "enemy"),
        }
    }

    table.insert(gv_HUDA_ConflictTracker, conflict)
end

function HUDA_ConflictTracker:ExtendConflict(sectorId, squadId)
    local conflict = self:GetConflict(sectorId)

    if not conflict then
        return
    end

    local squad = gv_Squads[squadId]

    if not squad then
        return
    end

    if not table.find(conflict.squads, squad) then
        prepSquad = {
            id = squad.UniqueId,
            side = self:GetSquadSide(squad),
            units = table.copy(squad.units),
            name = squad.Name,
            joinedBattle = Game.CampaignTime,
        }

        table.insert(conflict.squads, prepSquad)

        if squad.militia then
            HUDA_ArraySpreadAppend(conflict.militia.units, squad.units)
            conflict.militia.leader = self:GetLeader(sectorId, "militia")
            conflict.militia.affiliation = conflict.militia.leader and conflict.militia.leader.affiliation or self:GetAffiliation(sectorId, "militia")
        elseif squad.Side == "enemy1" or squad.Side == "enemy2" then
            HUDA_ArraySpreadAppend(conflict.enemy.units, squad.units)
            conflict.enemy.leader = self:GetLeader(sectorId, "enemy")
            conflict.enemy.affiliation = conflict.enemy.leader and conflict.enemy.leader.affiliation or self:GetAffiliation(sectorId, "enemy")
        elseif squad.Side == "player1" or squad.Side == "player2" then
            HUDA_ArraySpreadAppend(conflict.player.units, squad.units)
            conflict.player.leader = self:GetLeader(sectorId, "player")
            conflict.player.affiliation = conflict.player.leader and conflict.player.leader.affiliation or self:GetAffiliation(sectorId, "player")
        elseif squad.Side == "ally" then
            HUDA_ArraySpreadAppend(conflict.ally.units, squad.units)
            conflict.ally.leader = self:GetLeader(sectorId, "ally")
            conflict.ally.affiliation = conflict.ally.leader and conflict.ally.leader.affiliation or self:GetAffiliation(sectorId, "ally")
        end
    end
end

function HUDA_ConflictTracker:GetSquads(sectorId, side)
    local sector = gv_Sectors[sectorId]

    if not sector then
        return
    end

    local squads = sector.all_squads

    local filteredSquads = table.ifilter(squads, function(i, v)
        if side == "militia" then
            return v.militia
        elseif side == "player" then
            return (v.Side == "player1" or v.Side == "player2") and not v.militia
        elseif side == "enemy" then
            return v.Side == "enemy1" or v.Side == "enemy2"
        elseif side == "ally" then
            return v.Side == "ally" and not v.militia
        end
    end)

    return filteredSquads
end

function HUDA_ConflictTracker:GetUnitIds(sectorId, side)
    local squads = self:GetSquads(sectorId, side)

    if not squads then
        return
    end

    local units = {}

    for i, squad in ipairs(squads) do
        for j, unit in ipairs(squad.units) do
            table.insert(units, unit)
        end
    end

    return units
end

function HUDA_ConflictTracker:GetAllUnits(sectorId, side)
    local squads = self:GetSquads(sectorId, side)

    if not squads then
        return
    end

    local units = {}

    for _, squad in ipairs(squads) do
        for _, unit_id in ipairs(squad.units) do
            local unit = getUnits and g_Units[unit_id] or gv_UnitData[unit_id]
            table.insert(units, unit)
        end
    end

    return units
end

function HUDA_ConflictTracker:PrepareLeader(unit)
    local squad = gv_Squads[unit.Squad or unit.OldSquad]

    local leader = {
        name = unit.Nick or unit.Name,
        id = unit.session_id,
        squadId = unit.Squad or unit.OldSquad,
        squadName = squad and squad.Name or "",
        villain = unit.villain,
        affiliation = unit.Affiliation,
    }

    return leader
end

function HUDA_ConflictTracker:GetAffiliation(sectorId, side)
    local units = self:GetAllUnits(sectorId, side)

    if not units or not next(units) then
        return side
    end

    local affiliations = {}

    for _, unit in ipairs(units) do
        if unit.Affiliation then
            table.insert(affiliations, unit.Affiliation)
        end
    end

    return HUDA_ArrayMost(affiliations) or side
end

function HUDA_ConflictTracker:GetLeader(sectorId, side)
    local units = self:GetAllUnits(sectorId, side)

    if not units or not next(units) then
        return
    end

    local villains = table.ifilter(units, function(i, v)
        return v.villain
    end)

    if #villains > 0 then
        return self:PrepareLeader(villains[1])
    end

    table.sort(units, function(a, b)
        return a.Experience > b.Experience
    end)

    local potentialLeaders = table.ifilter(units, function(i, v)
        return (v.role and v.role == "Commander") or (v.Specialization and v.Specialization == "Leader") or
            string.find(v.session_id, "Leader")
    end)

    if #potentialLeaders > 0 then
        return self:PrepareLeader(potentialLeaders[1])
    end

    return self:PrepareLeader(units[1])
end

function HUDA_ConflictTracker:GetSquadSide(squad)
    if squad.militia then
        return "militia"
    elseif squad.Side == "enemy1" or squad.Side == "enemy2" then
        return "enemy"
    elseif squad.Side == "player1" or squad.Side == "player2" then
        return "player"
    elseif squad.Side == "ally" then
        return "ally"
    end
end

function HUDA_ConflictTracker:GetConflictSquads(sectorId)
    local sector = gv_Sectors[sectorId]

    local squads = sector.all_squads

    local conflictSquads = {}

    for i, squad in ipairs(squads) do
        local prepSquad = {
            id = squad.UniqueId,
            side = self:GetSquadSide(squad),
            units = table.copy(squad.units),
            name = squad.Name,
            joinedBattle = Game.CampaignTime,
        }

        table.insert(conflictSquads, prepSquad)
    end

    return conflictSquads
end

function HUDA_ConflictTracker:GetConflictByUnit(unit)
    local squad = gv_Squads[unit.Squad or unit.OldSquad]

    local sectorId = squad and squad.CurrentSector or false

    if not sectorId then
        print("No sector found for squad " .. squad.Id)

        return
    end

    return self:GetConflict(sectorId)
end

function HUDA_ConflictTracker:GetConflict(sectorId)
    if not sectorId then
        print("No sector found for squad " .. squad.Id)

        return
    end

    local conflict = table.ifilter(gv_HUDA_ConflictTracker,
        function(k, v) return v.sectorId == sectorId and not v.resolved end)

    if conflict then
        if (#conflict > 1) then
            print("More than one conflict found for sector " .. sectorId)
        end

        conflict = conflict[1]
    else
        print("No conflict found for sector " .. sectorId)

        return
    end

    return conflict
end

function HUDA_ConflictTracker:TrackActions(attacker, results)
    local kill = 0 < #(results.killed_units or empty_table)
    if kill then
        self:TrackKills(attacker, results)
    end
end

function HUDA_ConflictTracker:GetMilitiaRank(unitId)
    if string.find(unitId, "Elite") then
        return "Elite"
    end

    if string.find(unitId, "Veteran") then
        return "Veteran"
    end

    return "Rookie"
end

function HUDA_ConflictTracker:TrackPromotions(unit, oldId)
    local conflict = self:GetConflictByUnit(unit)

    if not conflict then
        return
    end

    local promotion = {
        unit = oldId,
        name = unit.Nick or unit.Name,
        time = Game.CampaignTime,
        newId = unit.session_id,
        oldRank = self:GetMilitiaRank(oldId),
        newRank = self:GetMilitiaRank(unit.session_id)
    }

    table.insert(conflict.militia.promotions, promotion)
end

function HUDA_ConflictTracker:TrackSpecialEvents(unit, event)
    local conflict = self:GetConflictByUnit(unit)

    if not conflict then
        return
    end

    local time = Game.CampaignTime

    local specialEvent = {
        unit = unit.session_id,
        name = unit.Nick or unit.Name,
        side = self:GetUnitSide(unit),
        time = time,
        event = event,
    }

    table.insert(conflict.specialEvents, specialEvent)
end

function HUDA_ConflictTracker:TrackStatusEffects(unit, effect, stack)
    if effect == "Wounded" then
        self:TrackWounds(unit, stack)
    elseif table.find(self.TrackedEffects, effect) then
        self:TrackSpecialEvents(unit, effect)
    end
end

function HUDA_ConflictTracker:TrackWounds(unit, stack)
    local conflict = self:GetConflictByUnit(unit)

    if not conflict then
        return
    end

    local wound = {
        unit = unit.session_id,
        name = unit.Nick or unit.Name,
        side = self:GetUnitSide(unit),
        time = Game.CampaignTime,
        stack = stack,
    }

    table.insert(conflict.wounds, wound)
end

function HUDA_ConflictTracker:TrackKills(attacker, results)
    local conflict = self:GetConflictByUnit(attacker)

    if not conflict then
        return
    end

    local multikill = 0 < #(results.killed_units or empty_table)

    local time = Game.CampaignTime

    local killedUnits = results.killed_units or empty_table

    for _, unit in ipairs(killedUnits) do
        local existingKills = table.ifilter(conflict.kills, function(k, v) return v.target == unit.session_id end)

        if next(existingKills) then
            local existingKill = existingKills[1]

            existingKill.multikill = multikill
            existingKill.attacker = attacker.session_id
            existingKill.attackerName = attacker.Nick or attacker.Name
            existingKill.weapon = results.weapon.DisplayName
        else
            self:AddKill(unit, conflict, attacker.session_id, results.weapon.DisplayName, multikill, time)

            self:AddSideKill(unit, conflict)
        end
    end
end

function HUDA_ConflictTracker:TrackAutoresolveDeath(victim, sectorId)
    local conflict = self:GetConflict(sectorId)

    if not conflict then
        return
    end

    self:AddKill(victim, conflict)

    self:AddSideKill(victim, conflict)
end

function HUDA_ConflictTracker:AddKill(unit, conflict, attacker, weaponName, multikill, time)
    local time = time or Game.CampaignTime

    local kill = {
        attacker = attacker and attacker.session_id or nil,
        attackerName = attacker and (attacker.Nick or attacker.Name) or nil,
        target = unit.session_id,
        targetName = unit.Nick or unit.Name,
        affiliation = unit.Affiliation,
        side = self:GetUnitSide(unit),
        role = unit.role or unit.Specialization,
        time = time,
        weapon = weaponName,
        multikill = multikill,
    }

    table.insert(conflict.kills, kill)
end

function HUDA_ConflictTracker:AddSideKill(unit, conflict)
    local side = self:GetUnitSide(unit)

    if unit.militia then
        table.insert(conflict.militia.killed, unit.session_id)
    elseif side == "player" then
        table.insert(conflict.player.killed, unit.session_id)
    elseif side == "enemy" then
        table.insert(conflict.enemy.killed, unit.session_id)
    elseif side == "ally" then
        table.insert(conflict.ally.killed, unit.session_id)
    elseif unit:IsCivilian() then
        table.insert(conflict.civKilled, unit.session_id)
    end
end

function HUDA_ConflictTracker:GetUnitSide(unit)
    if unit.militia then
        return "militia"
    end

    local squad = gv_Squads[unit.Squad or unit.OldSquad]

    if not squad then
        return
    end

    if squad.Side == "player1" or squad.Side == "player2" then
        return "player"
    elseif squad.Side == "ally" then
        return "ally"
    elseif squad.Side == "enemy1" or squad.Side == "enemy2" then
        return "enemy"
    end
end
