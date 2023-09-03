-- Overrides the original function. There is no other way
function RollForMilitiaPromotion(sector)
	sector = type(sector) == "table" and sector or gv_Sectors[sector]

	local squads = GetMilitiaSquads(sector)

	local promotedCount = 0
	for _, squad in ipairs(squads) do
		local unitIds = table.copy(squad.units)
		for _, id in ipairs(unitIds) do
			local chance = 10
			local roll = InteractionRand(100, "MilitiaPromotion")
			if chance > roll then
				local unitData = gv_UnitData[id]
				local copy = table.raw_copy(unitData)
				local oldUnits = table.copy(squad.units)

				if unitData.class == "MilitiaRookie" then
					CreateMilitiaUnitData("MilitiaVeteran", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				elseif unitData.class == "MilitiaVeteran" then
					CreateMilitiaUnitData("MilitiaElite", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				end

				local new_guy_id = HUDA_ArrayFind(squad.units, function(i, v)
					return not HUDA_ArrayContains(oldUnits, v)
				end)

				if new_guy_id then
					local new_guy = gv_UnitData[new_guy_id]

					if new_guy then
						HUDA_MergeMilitia(new_guy, copy)
					end
				end
			end
		end
	end
	if 0 < promotedCount then
		if 1 < promotedCount then
			CombatLog("important", T({
				293615811082,
				"<promotedCount> militia got promoted in <SectorName(sectorId)>",
				promotedCount = promotedCount,
				sectorId = sector.Id
			}))
		else
			CombatLog("important", T({
				488327770041,
				"A militia unit got promoted in <SectorName(sectorId)>",
				promotedCount = promotedCount,
				sectorId = sector.Id
			}))
		end
	end

	ObjModified("ui_player_squads")
end

local HUDAOriginalSpawnMilitia = SpawnMilitia

function SpawnMilitia(trainAmount, sector, bFromOperation)
	local militia_id = sector.militia_squad_id

	-- pushing the militia soldiers into a table so we can keep their stats and stuff
	local original_units = {}
	local session_id_array = {}

	if militia_id then
		local militia = gv_Squads[militia_id]

		if militia.units then
			local unit_data = gv_UnitData

			for index, value in ipairs(militia.units) do
				original_units[value] = table.raw_copy(unit_data[value])
				table.insert(session_id_array, value)
			end
		end
	end

	local militia_squad, count_trained = HUDAOriginalSpawnMilitia(trainAmount, sector, bFromOperation)

	HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

	local unit_data = gv_UnitData

	local upgraded_units = table.ifilter(militia_squad.units, function(i, v)
		return not string.find(v, "Rookie") and not HUDA_ArrayContains(session_id_array, v)
	end)

	local deleted_units = table.ifilter(session_id_array, function(i, v)
		return not HUDA_ArrayContains(militia_squad.units, v)
	end)

	for index, value in ipairs(upgraded_units) do
		if unit_data[value] then
			HUDA_MergeMilitia(unit_data[value], original_units[deleted_units[index]])
		end
	end

	HUDA_MilitiaPersonalization:Personalize(militia_squad.units)

	local is_squad_full = HUDA_IsSquadFull(militia_squad, sector)

	if is_squad_full then
		sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(sector, militia_squad.UniqueId)
	end

	ObjModified("ui_player_squads")

	return militia_squad, count_trained
end

function HUDA_MergeMilitia(new, original)
	local protected = {
		randomization_seed = true,
		session_id = true,
		ActionPoints = true,
		Experience = true,
		HitPoints = true,
		MaxHitPoints = true,
		MaxAttacks = true,
	}

	local stats = {
		'Health',
		'Agility',
		'Dexterity',
		'Strength',
		'Wisdom',
		'Leadership',
		'Marksmanship',
		'Mechanical',
		'Explosives',
		'Medical',
	}

	for k, v in pairs(original) do
		if not protected[k] then
			if HUDA_ArrayContains(stats, k) and HUDA_IsMilitiaPromoted(original, new) then
				new[k] = v + InteractionRandRange(1, 3, "MilitiaPromotion")
				new["base_" .. k] = new[k]
				if k == "Health" then
					new.HitPoints = new[k]
					new.MaxHitPoints = new[k]
				end
			else
				new[k] = v
			end
		end
	end
end

function HUDA_IsMilitiaPromoted(original, new)
	if (string.find(original.session_id, "Rookie") ~= nil and string.find(new.session_id, "Veteran") ~= nil) or
		(string.find(original.session_id, "Veteran") ~= nil and string.find(new.session_id, "Elite") ~= nil) then
		return true
	end
end
