g_LocalMilitia = {}

function RollForMilitiaPromotion(sector)
	local squads = GetMilitiaSquads(sector)

	local promotedCount = 0
	for _, squad in ipairs(squads) do
		local unitIds = table.copy(squad.units)
		for _, id in ipairs(unitIds) do
			local unitData = gv_UnitData[id]
			local chance = 30
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

				MergeMilitia(new_guy, copy)
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

	militia_squad.Side = "player1"
	militia_squad.OriginalSide = "ally"
	militia_squad.BornInSector = militia_squad.BornInSector or sector.Id

	-- HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

	if #original_array > 0 then
		local unit_data = gv_UnitData

		for index, value in ipairs(original_array) do
			if unit_data[militia_squad.units[index]] then
				MergeMilitia(unit_data[militia_squad.units[index]], value)
			end
		end
	end

	HUDA_MilitiaPersonalization:Personalize(militia_squad.units)

	ObjModified("ui_player_squads")

	return militia_squad, count_trained
end

function MergeMilitia(new, original)
	local protected = {
		randomization_seed = true,
		session_id = true,
		ActionPoints = true,
		Experience = true,
		HitPoints = true,
		MaxHitPoints = true,
		MaxAttacks = true,
	}

	for k, v in pairs(original) do
		if not protected[k] then
			new[k] = v
		end
	end
end
