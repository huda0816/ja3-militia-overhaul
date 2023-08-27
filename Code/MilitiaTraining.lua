-- Overrides the original function. There is no other way
function RollForMilitiaPromotion(sector)
	sector = type(sector) == "table" and sector or gv_Sectors[sector]

	local squads = GetMilitiaSquads(sector)

	local promotedCount = 0
	for _, squad in ipairs(squads) do
		local unitIds = table.copy(squad.units)
		for _, id in ipairs(unitIds) do
			local unitData = gv_UnitData[id]
			local chance = 10
			local roll = InteractionRand(100, "MilitiaPromotion")
			if chance > roll then
				local copy = table.raw_copy(unitData)

				if unitData.class == "MilitiaRookie" then
					CreateMilitiaUnitData("MilitiaVeteran", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				elseif unitData.class == "MilitiaVeteran" then
					CreateMilitiaUnitData("MilitiaElite", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				end

				local new_guy_id = squad.units[#squad.units]

				local new_guy = gv_UnitData[new_guy_id]

				HUDA_MergeMilitia(new_guy, copy)
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

	-- pushing the militia soldiers into a table so we can copy them later
	local original_array = {}

	if militia_id then
		local militia = gv_Squads[militia_id]

		if militia.units then
			local unit_data = gv_UnitData

			for index, value in ipairs(militia.units) do
				table.insert(original_array, table.raw_copy(unit_data[value]))
			end
		end
	end

	local militia_squad, count_trained = HUDAOriginalSpawnMilitia(trainAmount, sector, bFromOperation)

	HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

	if #original_array > 0 then
		local unit_data = gv_UnitData

		for index, value in ipairs(original_array) do
			if unit_data[militia_squad.units[index]] then
				HUDA_MergeMilitia(unit_data[militia_squad.units[index]], value)
			end
		end
	end

	HUDA_MilitiaPersonalization:Personalize(militia_squad.units)

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
		'Health ',
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
			if HUDA_ArrayContains(stats, k) then
				new[k] = v + InteractionRandRange(1, 3, "MilitiaPromotion")
				new["base_" .. k] = new[k]
				if k == "Health " then
					new.MaxHitPoints = new[k]
					new.HitPoints = new[k]
				end
			else
				new[k] = v
			end
		end
	end
end
