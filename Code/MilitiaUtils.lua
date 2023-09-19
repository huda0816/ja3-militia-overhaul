function HUDA_TableValues(tbl)
	local values = {}

	for k, v in pairs(tbl) do
		table.insert(values, v)
	end

	return values
end

function HUDA_ArrayContains(array, value)
	for k, v in pairs(array) do
		if v == value then
			return true
		end
	end

	return false
end

function HUDA_GetArrayIndex(array, value)
	for i, v in ipairs(array) do
		if v.id == value.id then
			return i
		end
	end

	return nil
end

function HUDA_StringSplit(str, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	str:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
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

function HUDA_GetSectorNamePure(sector)
	if not IsKindOf(sector, "SatelliteSector") then
		sector = ResolvePropObj(sector)
		sector = IsKindOf(sector, "SatelliteSector") and sector
	end
	if sector then
		return sector.display_name or ""
	end
	return ""
end

function HUDA_GetMilitia(array)
	local soldiers = table.filter(gv_UnitData, function(k, v)
		return v.militia
	end)

	if array then
		return HUDA_ReindexTable(soldiers)
	else
		return soldiers
	end
end

function HUDA_keyOf(tbl, value)
	for k, v in pairs(tbl) do
		if v == value then
			return k
		end
	end
	return nil
end

function HUDA_GetRank(unit)
	if (string.gmatch(unit.session_id, "Elite")) then
		return "Elite"
	elseif (string.gmatch(unit.session_id, "Veteran")) then
		return "Veteran"
	elseif (string.gmatch(unit.session_id, "Rookie")) then
		return "Rookie"
	end
end

function HUDA_GetSectorById(sector_id)
	return gv_Sectors[sector_id]
end

function HUDA_GetSector(unit)
	local sector_id = HUDA_GetSectorId(unit)
	return gv_Sectors[sector_id]
end

function HUDA_GetSectorByUnitId(unit_id)
	local unit = gv_UnitData[unit_id]
	return HUDA_GetSector(unit)
end

function HUDA_GetSectorIdByUnitId(unit_id)
	local unit = gv_UnitData[unit_id]
	return HUDA_GetSectorId(unit)
end

function HUDA_GetEnglishString(v)

	if type(v) == "string" then
		return v
	else
		return TDevModeGetEnglishText(v)
	end

end

function HUDA_T(text, replace)

	for k, v in pairs(replace) do

		text = string.gsub(text,"<" .. k  .. ">", HUDA_GetEnglishString(v) )
	end

	return text

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

function HUDA_GetSpecializationName(specialization)
	if specialization == "AllRounder" then
		return "Rifleman"
	elseif specialization == "Marksmen" then
		return "Marksman"
	elseif specialization == "Doctor" then
		return "Medic"
	elseif specialization == "ExplosiveExpert" then
		return "Grenadier"
	end

	return specialization
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

function HUDA_GetClosestCity(sectorId)
	local distance = 1000
	local closest_sector
	local closest_city

	for k, city in pairs(gv_Cities) do
		local city_sectors = GetCitySectors(k)

		for _, city_sector in ipairs(city_sectors) do
			local city_distance = GetSectorDistance(sectorId, city_sector)

			if city_distance == 0 then
				return k, 0, city_sector
			end

			if city_distance < distance then
				distance = city_distance
				closest_sector = city_sector
				closest_city = k
			end
		end
	end

	return closest_city, distance, closest_sector
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

function HUDA_ArraySpreadAppend(array, value)
	for i, v in ipairs(value) do
		table.insert(array, v)
	end
end

function HUDA_ArrayMost(array)
	local uniqueValues = {}

	for i, v in ipairs(array) do
		if not uniqueValues[v] then
			uniqueValues[v] = 1
		else
			uniqueValues[v] = uniqueValues[v] + 1
		end
	end

	table.sort(uniqueValues, function(a, b) return a > b end)

	return HUDA_TableKeys(uniqueValues)[1], uniqueValues[HUDA_TableKeys(uniqueValues)[1]]
end

function HUDA_TableKeys(tbl)
	local keys = {}

	for k, v in pairs(tbl) do
		table.insert(keys, k)
	end

	return keys
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

function HUDA_IsSquadManagementView()
	local dlg = GetDialog("PDASquadManagement")

	if not dlg then
		return false
	end

	return true
end

function HUDA_GetDateFromTime(timeStamp)

	local t = GetTimeAsTable(timeStamp or 0)
	local month = string.format("%02d", t and t.month or 1)
	local day = string.format("%02d", t and t.day or 1)
	local year = tostring(t and t.year or 1)
	local systemDateFormat = GetDateTimeOrder()
	for i, unit in ipairs(systemDateFormat) do
		systemDateFormat[i] = "<u(" .. unit .. ")>"
	end
	systemDateFormat = table.concat(systemDateFormat, ".")
	return T({
		systemDateFormat,
		month = month,
		day = day,
		year = year
	})

end

function HUDA_GetDaysSinceTime(timeStamp)
	local dist = Game.CampaignTime - timeStamp

	local days = dist / 24 / 60 / 60

	return days
end

function HUDA_GetSquadLeader(units)
	table.sort(units, function(a, b)
		return gv_UnitData[a].Experience > gv_UnitData[b].Experience
	end)

	local leaders = HUDA_ReindexTable(table.filter(units, function(k, v)
		return gv_UnitData[v].Specialization == "Leader"
	end))

	if next(leaders) == nil then
		return gv_UnitData[units[1]]
	else
		return gv_UnitData[leaders[1]]
	end
end

function HUDA_GetSquadName(squadId)
	
	local squad = gv_Squads[squadId]
	
	if squad and squad.Name ~= "" then
		return squad.Name
	end

end
