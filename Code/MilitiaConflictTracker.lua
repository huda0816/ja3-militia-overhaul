GameVar("gv_HUDA_ConflictTracker", {})

function OnMsg.Start(sector_id)

    local sector = gv_Sectors[sector_id]

    local conflict = {
        sectorId = sector_id,
        squads = sector.all_squads,
        enemySquads = sector.enemy_squads,
        mercSquads = table.filter(sector.all_squads, function(k, v) return (v.Side == "player1" or v.Side == "player2") and not v.militia end),
        militiaSquads = sector.militia_squads,
        militiaUnits = {},
        enemyUnits = {},
        mercUnits = {},
        militiaDead = {},
        enemyDead = {},
        mercDead = {},
        initialDead = sector.dead_units,
        militia_won = false,
        enemy_won = false,
        auto_resolve = false,
        is_retreat = false,
    }

    table.insert(gv_HUDA_ConflictTracker, conflict)

end


function OnMsg.ConflictEnd(sector, _, playerAttacked, playerWon, autoResolve, isRetreat)

         




end


DefineClass.HUDA_ConfictTracker = {
}

function HUDA_ConflictTracker:GetMercSquads(sector_id) 
    local sector = gv_Sectors[sector_id]
    local mercSquads = table.filter(sector.all_squads, function(k, v) return (v.Side == "player1" or v.Side == "player2") and not v.militia end)
    return mercSquads
end

function HUDA_ConflictTracker:GetMilitiaUnits(sector_id) 
    local sector = gv_Sectors[sector_id]
    
    return militiaUnits
end