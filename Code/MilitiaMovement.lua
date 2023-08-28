function IsPlayer1Squad(squad)
	return squad.Side == "player1"
end

function OnMsg.SquadStartedTravelling(squad)
	if squad.militia then
		local current_sector = gv_Sectors[squad.CurrentSector]

		if current_sector.militia_squad_id == squad.UniqueId then
			current_sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(current_sector, squad.UniqueId)
		end
	end
end

function OnMsg.SquadSectorChanged(squad)
	-- function OnMsg.SquadStartedTravelling(squad)
	if squad.militia and squad.PreviousSector ~= squad.CurrentSector then
		local previous_sector = gv_Sectors[squad.PreviousSector]

		if previous_sector.militia_squad_id == squad.UniqueId then
			previous_sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(previous_sector)
		end
	end
end

function OnMsg.SquadFinishedTraveling(squad)
	if not squad.militia then
		return
	end

	local units = table.filter(gv_UnitData, function(k, v)
		return table.find(squad.units, k)
	end)

	for k, unit in pairs(units) do
		unit:RemoveStatusEffect("FarFromHome")

		if unit.class ~= "MilitiaElite" then
			local distance = HUDA_GetUnitDistance(unit)

			if distance > 4 then
				unit:AddStatusEffect("FarFromHome")
			end
		end
	end
end

function OnMsg.SquadFinishedTraveling(squad)
	local current_sector = gv_Sectors[squad.CurrentSector]

	if not current_sector.militia_squad_id and squad.militia and not HUDA_IsSquadFull(squad, current_sector) then
		current_sector.militia_squad_id = squad.UniqueId
	end
end

local HUDAOriginalSquadCantMove = SquadCantMove

function SquadCantMove(squad)
	local cant_move = HUDAOriginalSquadCantMove(squad)

	if cant_move or not squad.militia then
		return cant_move
	end

	return not HUDACanTravel(squad)
end

local HUDASatellitCanTravelState = SatelliteCanTravelState

function SatelliteCanTravelState(squad, sector_id)
	local state = HUDASatellitCanTravelState(squad, sector_id)

	local squadTable = gv_Squads[squad]

	if state == "disabled" or not squadTable.militia then
		return state
	end

	local can_travel, reason = HUDACanTravel(squadTable, sector_id)

	if not can_travel then
		local popupHost = GetDialog("PDADialogSatellite")
		popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

		local dlg = CreateMessageBox(popupHost, Untranslated("Militia Training"),
			Untranslated(reason or "You cannot move as militia is currently trained"))

		dlg:Wait()

		return "disabled", Untranslated(reason or "")
	end

	if (sector_id) then
		local s1 = gv_Sectors[sector_id].XMapPosition

		if not squadTable.BornInSector then
			squadTable.BornInSector = squadTable.CurrentSector
		end

		local s2 = gv_Sectors[squadTable.BornInSector].XMapPosition
		local dist = s1:Dist(s2)
	end

	return "enabled"
end

function HUDACanTravel(squad, sector_id)
	local sectors = gv_Sectors

	local sector = sectors[squad.CurrentSector] or nil

	if not sector then
		return false
	end

	if sector.militia_training and sector.militia_squad_id == squad.UniqueId then
		return false, "Militia is in Training"
	end

	return true
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
