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

	if HUDA_GetModOptions("MilitiaNoFarFromHome", false) then
		return
	end

	HUDA_MakeFarFromHome(squad)
end

function HUDA_MakeFarFromHome(squad)

	if not squad.militia then
		return
	end

	for i, unitId in ipairs(squad.units) do
		local unit = gv_UnitData[unitId]

		unit:RemoveStatusEffect("FarFromHome")

		if unit.class ~= "MilitiaElite" then
			local distance = HUDA_GetUnitDistance(unit)

			if distance > 4 then
				unit:AddStatusEffect("FarFromHome")
			end
		end
	end
end

function HUDA_SetFarFromHomeStatus(deactivated)
	local squads = gv_Squads

	for i, squad in pairs(squads) do

		if squad.militia then

			if deactivated then
				
				for i, unitId in ipairs(squad.units) do
					local unit = gv_UnitData[unitId]

					unit:RemoveStatusEffect("FarFromHome")
				end
			else
				HUDA_MakeFarFromHome(squad)
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


function OnMsg.ReachSectorCenter(squad_id, sector_id, prev_sector_id)

	local squad = gv_Squads[squad_id]

	if not squad.militia or squad.Retreat then
		return
	end

	local sector = gv_Sectors[sector_id]

	if sector.conflict or sector.Side == "player1" or sector.Side == "player2" then
		return
	end

	local sideChanged = SatelliteSectorSetSide(sector_id, squad.Side) or false
	
	if sideChanged and g_SatelliteUI then
		g_SatelliteUI:UpdateSectorVisuals(sector_id)
	end

end