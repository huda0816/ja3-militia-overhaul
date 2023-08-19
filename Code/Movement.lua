-- g_travelsquad = {}

-- function OnMsg.SquadStartedTravelling(squad)
-- 	g_travelsquad = squad

-- 	if (squad.route and squad.route.displayedSectionEnd) then
-- 		local destination = gv_Sectors[squad.route.displayedSectionEnd]
-- 		local start = gv_Sectors[squad.CurrentSector]

-- 		local s2 = gv_Sectors[squadTable.BornInSector].XMapPosition
-- 		local dist = destination.XMapPosition:Dist(start.XMapPosition)

-- 	end
-- end

function IsPlayer1Squad(squad)
	return squad.Side == "player1"
end

function OnMsg.SquadStartedTravelling(squad)
	if squad.militia then
		local current_sector = gv_Sectors[squad.CurrentSector]

		if current_sector.militia_squad_id == squad.UniqueId then
			if #current_sector.militia_squads > 1 then
				current_sector.militia_squad_id = table.filter(current_sector.militia_squads, function(k, v)
					return v.UniqueId ~= squad.UniqueId
				end)[1].UniqueId
			else
				current_sector.militia_squad_id = nil
			end
		end
	end
end

function OnMsg.SquadSectorChanged(squad)
	-- function OnMsg.SquadStartedTravelling(squad)
	if squad.militia and squad.PreviousSector ~= squad.CurrentSector then
		local previous_sector = gv_Sectors[squad.PreviousSector]

		if previous_sector.militia_squad_id == squad.UniqueId then
			if #previous_sector.militia_squads > 0 then
				previous_sector.militia_squad_id = previous_sector.militia_squads[1].UniqueId
			else
				previous_sector.militia_squad_id = nil
			end
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
			local distance = HUDA_MilitiaOverhaul:GetUnitDistance(unit)

			print("Distance: " .. distance)

			if distance > 4 then
				unit:AddStatusEffect("FarFromHome")
			end
		end
	end
end

function OnMsg.SquadFinishedTraveling(squad)
	local current_sector = gv_Sectors[squad.CurrentSector]

	if not current_sector.militia_squad_id and squad.militia then
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
