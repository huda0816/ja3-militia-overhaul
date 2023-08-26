HUDA_FindElement = CustomSettingsMod.Utils.XTemplate_FindElementsByProp

function HUDA_ArrayContains(array, value)
	for k, v in pairs(array) do
		if v == value then
			return true
		end
	end

	return false
end

function HUDA_IsContextMilitia(context)
	local militia = false

	if context.militia then
		militia = true
	elseif context.UniqueId then
		local squad = gv_Squads[context.UniqueId]

		if squad then
			militia = squad.militia
		end
	end

	return militia
end

function HUDA_GetAllMilitiaSoldiers()
	return table.filter(gv_UnitData, function(k, v)
        return v.militia
    end)
end

function HUDA_keyOf(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

function HUDA_GetSector(unit)
    local sector_id = HUDA_GetSectorId(unit)
    return gv_Sectors[sector_id]
end

function HUDA_GetSectorId(unit)
    local squad = gv_Squads[unit.Squad]
    return squad and squad.CurrentSector or "H2"    
end

function HUDA_GetSquadDistance(squad)
	local current_sector = squad.CurrentSector

	if not current_sector then
		return 0
	end

	local squad_home_sector = squad.BornInSector or current_sector

	return GetSectorDistance(current_sector, squad_home_sector)
end

function HUDA_GetUnitDistance(unit)

	local squad = gv_Squads[unit.Squad]

	local current_sector = squad.CurrentSector

	if not current_sector then
		return 0
	end

	local home_sector = unit.JoinSector or squad.BornInSector or current_sector

	return GetSectorDistance(current_sector, home_sector)
end

function HUDA_ReindexTable(tbl)
	local new_tbl = {}

	for k, v in pairs(tbl) do
		table.insert(new_tbl, v)
	end

	return new_tbl
end

function HUDA_TableColumn(tbl, column)
	local new_tbl = {}

	for k, v in pairs(tbl) do
		table.insert(new_tbl, v[column])
	end

	return new_tbl
end