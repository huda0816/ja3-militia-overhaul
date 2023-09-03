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

function HUDA_GetSupplyTravelInfo(start, goal)
	local route = GenerateRouteDijkstra(start, goal)

	if not route then
		return 0
	end

	local water_sectors = table.ifilter(route, function(i, v)
		return gv_Sectors[v].Passability == "Water"
	end)

	local previous = start
	local time = 0
	local breakdown = false
	for i, w in ipairs(route) do
		if previous then
			local nextTravel = GetSectorTravelTime(previous, w, route)
			if nextTravel then
				time = time + Max(nextTravel, lMinVisualTravelTime * 2)
			end
		end
		previous = w
	end
	return time, water_sectors
end

function HUDA_GetControlledCitySectors(city)
	local sectors = GetCitySectors(city)

	if sectors then
		local controlled_sectors = table.filter(sectors, function(i, v)
			local sector = gv_Sectors[v]
			return sector and (sector.Side == "player1" or sector.Side == "player2")
		end)

		return HUDA_ReindexTable(controlled_sectors)
	end
end

function HUDA_GetGuardposts(own) -- own = true, only own guardposts, false = only enemy guardposts, nil = all guardposts
	local guardposts = {}

	for k, sector in pairs(gv_Sectors) do
		if sector.Guardpost then
			if own == nil or sector.Side == "player1" or sector.Side == "player2" then
				table.insert(guardposts, sector)
			end
		end
	end

	return guardposts
end

function HUDA_GetShortestDistanceToCityAndBases(sectorId)
	local distance = 1000
	local closest_sector
	local closest_city

	for k, city in pairs(gv_Cities) do
		if (city.Loyalty > 30) then
			local city_sectors = HUDA_GetControlledCitySectors(k)

			for _, city_sector in ipairs(city_sectors) do
				local city_distance = GetSectorDistance(sectorId, city_sector)

				if city_distance == 0 then
					return 0, city_sector, k
				end

				if city_distance < distance then
					distance = city_distance
					closest_sector = city_sector
					closest_city = k
				end
			end
		end
	end

	local guardposts = HUDA_GetGuardposts(true)

	for _, guardpost in ipairs(guardposts) do
		local guardpost_distance = GetSectorDistance(sectorId, guardpost.Id)

		if guardpost_distance == 0 then
			return 0, guardpost.Id, nil
		end

		if guardpost_distance < distance then
			distance = guardpost_distance
			closest_sector = guardpost.Id
			closest_city = nil
		end
	end

	return distance, closest_sector, closest_city
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

function HUDA_TableFind(tbl, fn)
	for k, v in pairs(tbl) do
		if fn(k, v) then
			return v, k
		end
	end

	return nil
end

function HUDA_ArrayFind(array, fn)
	for i, v in ipairs(array) do
		if fn(i, v) then
			return v, i
		end
	end

	return nil
end

function HUDA_IsSquadFull(squad, sector)
	local militia_types = {
		MilitiaRookie = 0,
		MilitiaElite = 0,
		MilitiaVeteran = 0
	}
	for _, unit_id in ipairs(squad.units) do
		local unit = gv_UnitData[unit_id]
		militia_types[unit.class] = militia_types[unit.class] + 1
	end

	if militia_types.MilitiaVeteran >= sector.MaxMilitia - militia_types.MilitiaElite then
		return true
	end
	return false
end

function HUDA_GetTrainableMilitiaSquad(sector, exclude)
	exclude = exclude or 10000000000

	local squads = table.filter(gv_Squads, function(k, v)
		return v.CurrentSector == sector.Id and v.militia and v.UniqueId ~= exclude
	end)

	if next(squads) == nil then
		return false
	end

	local squad = HUDA_TableFind(squads, function(k, v)
		return not HUDA_IsSquadFull(v, sector)
	end)

	if not squad then
		return false
	end

	return squad.UniqueId
end

function HUDA_IsInventoryView()
	local dlg = GetDialog("FullscreenGameDialogs")

	if not dlg then
		return false
	end

	if dlg.Mode ~= "inventory" then
		return false
	end

	return true
end

function HUDA_GetModOptions(id, default, type)
	id = "huda_" .. id

	return CurrentModOptions[id] or default or 0
end

function OnMsg.ApplyModOptions(mod_id)
	if CurrentModOptions then
		for k, v in pairs(CurrentModOptions) do
			if string.starts_with(k, "huda_Militia") then
				HUDA_MilitiaFinances:UpdateProps(k, v)
			end
		end
	end
end