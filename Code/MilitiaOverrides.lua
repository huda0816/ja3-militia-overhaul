local HUDA_OriginalGetSquadsInSector = GetSquadsInSector

function GetSquadsInSector(sector_id, excludeTravelling, includeMilitia, excludeArriving, excludeRetreating)
	includeMilitia = includeMilitia == nil and true or includeMilitia

	return HUDA_OriginalGetSquadsInSector(sector_id, excludeTravelling, includeMilitia, excludeArriving,
		excludeRetreating)
end

local HUDA_OriginalGiveCombatTask = GiveCombatTask

function GiveCombatTask(preset, unitId)
	local unit = g_Units[unitId]

	if unit.militia then
		return
	end

	HUDA_OriginalGiveCombatTask(preset, unitId)
end

function GetSectorOperationResource(sector, item_id)
	local amount = { count = 0 }
	local squads = GetSquadsInSector(sector.Id, nil, false)
	for _, s in ipairs(squads or empty_table) do
		local bag = GetSquadBag(s.UniqueId)
		for i, item in ipairs(bag or empty_table) do
			if item.class == item_id then
				amount.count = amount.count + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
			end
		end
	end
	local mercs = GetPlayerMercsInSector(sector.Id)
	for _, id in ipairs(mercs) do
		local unit = gv_UnitData[id]
		unit:ForEachItemDef(item_id, function(item, slot, amount)
			amount.count = amount.count + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
		end, amount)
	end
	return amount.count
end

function GetPlayerMercsInSector(sector_id)
	local mercs = {}
	local squads = GetSquadsInSector(sector_id, nil, false)
	for i, s in ipairs(squads) do
		table.iappend(mercs, s.units)
	end
	return mercs
end

local HUDA_Original_Get_Personal_Morale = UnitProperties.GetPersonalMorale

function UnitProperties:GetPersonalMorale()
	local morale = HUDA_Original_Get_Personal_Morale(self)

	if not self.militia then
		return morale
	end

	if not self:HasStatusEffect("FarFromHome") then
		return morale
	end

	local unit = gv_UnitData[self.session_id]

	if unit.class == "MilitiaRookie" or string.find(unit.session_id, "MilitiaRookie") then
		morale = morale - 3
	elseif unit.class == "MilitiaVeteran" or string.find(unit.session_id, "MilitiaVeteran") then
		morale = morale - 2
	elseif unit.class == "MilitiaElite" or string.find(unit.session_id, "MilitiaElite") then
		morale = morale - 0
	end

	return Clamp(morale, -3, 3)
end

local HUDA_OriginalInitiateUnitMovement = IModeExploration.InitiateUnitMovement

function IModeExploration:InitiateUnitMovement(pos, unitPool, fx_pos, move_type)
	move_type = move_type or "Run"

	HUDA_OriginalInitiateUnitMovement(self, pos, unitPool, fx_pos, move_type)
end
