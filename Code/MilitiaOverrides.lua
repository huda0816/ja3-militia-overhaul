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


local l_get_sector_operation_resource_amount

function GetSectorOperationResource(sector, item_id)
	l_get_sector_operation_resource_amount = 0
--[[	-- sector inventory
	local containers = sector.sector_inventory or empty_table
	for cidx, container in ipairs(containers) do
		if container[2] then -- is opened
			local items = container[3] or empty_table
			for idx, item in ipairs(items) do
				if item.class == item_id then
					l_get_sector_operation_resource_amount = l_get_sector_operation_resource_amount + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
				end	
			end
		end
	end
--]]
	-- bags
	local squads = GetSquadsInSector(sector.Id, nil, false)
	for _, s in ipairs(squads) do
		local bag = GetSquadBag(s.UniqueId) 
		for i, item in ipairs(bag) do
			if item.class == item_id then
				l_get_sector_operation_resource_amount = l_get_sector_operation_resource_amount + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
			end
		end
	end
	-- all mercs
	local mercs = GetPlayerMercsInSector(sector.Id)
	for _, id in ipairs(mercs) do
		local unit = gv_UnitData[id]
		unit:ForEachItemDef(item_id, function(item)
			l_get_sector_operation_resource_amount = l_get_sector_operation_resource_amount + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
		end)
	end
	
	return l_get_sector_operation_resource_amount
end

function GetPlayerMercsInSector(sector_id)
	local mercs = {}
	local squads = GetSquadsInSector(sector_id, nil, false)
	for i, s in ipairs(squads) do
		table.iappend(mercs, s.units)
	end
	return mercs
end

local HUDA_Original_Get_Personal_Morale = UnitBase.GetPersonalMorale

function UnitBase:GetPersonalMorale()
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
		morale = morale - 1
	elseif unit.class == "MilitiaElite" or string.find(unit.session_id, "MilitiaElite") then
		morale = morale - 0
	end
	
	return Clamp(morale, -3, 3)
end

-- function OnMsg.OnCalcPersonalMorale(morale)
	
-- 	if not self.militia then
-- 		return morale
-- 	end

-- 	if not self:HasStatusEffect("FarFromHome") then
-- 		return morale
-- 	end

-- 	local unit = gv_UnitData[self.session_id]

-- 	if unit.class == "MilitiaRookie" or string.find(unit.session_id, "MilitiaRookie") then
-- 		morale = morale - 3
-- 	elseif unit.class == "MilitiaVeteran" or string.find(unit.session_id, "MilitiaVeteran") then
-- 		morale = morale - 1
-- 	elseif unit.class == "MilitiaElite" or string.find(unit.session_id, "MilitiaElite") then
-- 		morale = morale - 0
-- 	end

-- 	return morale
-- end

local HUDA_OriginalInitiateUnitMovement = IModeExploration.InitiateUnitMovement

function IModeExploration:InitiateUnitMovement(pos, unitPool, fx_pos, move_type)
	move_type = move_type or "Run"

	HUDA_OriginalInitiateUnitMovement(self, pos, unitPool, fx_pos, move_type)
end
