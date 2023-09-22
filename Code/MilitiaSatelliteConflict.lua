-- Msg("PreSquadDespawned", squad_id, squad.CurrentSector, reason)

g_DespawnedE9Squad = false

function OnMsg.NewHour()
	g_DespawnedE9Squad = false
end

function OnMsg.PreSquadDespawned(squad_id, sector, reason)
	
	if sector == "E9" then
		g_DespawnedE9Squad = squad_id
	end
end

function OnMsg.QuestParamChanged(questId, varId, prevVal, newVal)
	
	if
		not g_DespawnedE9Squad or
		not questId == "04_Betrayal" or
		not varId == "RefugeCampEnemyControl" or
		not newVal or
		prevVal then
		return
	end

	g_DespawnedE9Squad = false

	-- local conflictDlg = GetDialog("SatelliteConflict")

	-- Inspect(conflictDlg)

	-- if conflictDlg then
	-- 	conflictDlg:Close()
	-- end

	local popupHost = GetDialog("PDADialogSatellite")
	popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

	local dlg = CreateMessageBox(popupHost, "Squad vanishes in Refugee Camp",
		"We lost contact to our militia Squad in the Refugee Camp. We should send a squad to investigate the situation. (Please press retreat)")

	dlg:Wait()

	-- local conflictDlg = GetDialog("SatelliteConflict")

	-- if conflictDlg then
	-- 	conflictDlg:Close()
	-- end

	-- Inspect(conflictDlg)
end

function UIEnterSectorInternal(sector_id, force)
	local sector = gv_Sectors[sector_id]
	if not sector then
		return
	end
	local has_player_squads = #GetSectorSquadsFromSide(sector_id, "player1", "player2") > 0 or
		#GetMilitiaSquads(sector) > 0
	if not has_player_squads then
		local pdaDiag = GetDialog("PDADialog")
		if pdaDiag and pdaDiag.Mode == "browser" then
			OpenAIMAndSelectMerc()
		end
		UIEnterSector(sector_id, force)
		return
	end
	if not ForceReloadSectorMap and gv_CurrentSectorId == sector_id then
		CloseSatelliteView()
	else
		local spawnMode = sector.conflict and sector.conflict.spawn_mode or "explore"
		LoadSector(sector_id, spawnMode)
	end
end

local HUDA_OriginalIsMerc = IsMerc

function IsMerc(o)
	if gv_Deployment and o.militia then
		return true
	end

	return HUDA_OriginalIsMerc(o)
end

if FirstLoad then
	local huda_enabled_button = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SatelliteConflict"],
		"comment", "red enabled")

	if huda_enabled_button then
		huda_enabled_button.element.ActionState = function(self, host)
			local sector = host.context
			return CanGoInMap(sector.Id) and
				#GetSquadsInSector(sector.Id, "excludeTravelling", true, "excludeArriving", "excludeRetreating") > 0 and
				"enabled" or "hidden"
		end
	end


	local huda_disabled_button = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SatelliteConflict"],
		"comment", "normal disabled")

	if huda_disabled_button then
		huda_disabled_button.element.ActionState = function(self, host)
			local sector = host.context
			return (not CanGoInMap(sector.Id) or
					#GetSquadsInSector(sector.Id, "excludeTravelling", true, "excludeArriving", "excludeRetreating") < 1) and
				"disabled" or "hidden"
		end
	end
end


function IsAutoResolveEnabled(sector)
	if not sector.conflict then
		return false
	end
	if not sector.Map then
		return true
	end
	local alliesInConflict, enemySquads = GetSquadsInSector(sector.Id, "excludeTravelling", "includeMilitia",
		"excludeArriving")
	if not alliesInConflict or #alliesInConflict == 0 then
		return false
	end
	-- local onlyMilitia = true
	-- for i, s in ipairs(alliesInConflict) do
	--   if not s.militia then
	-- 	onlyMilitia = false
	-- 	break
	--   end
	-- end
	-- if onlyMilitia then
	--   return true
	-- end
	local anyHavePreviousSector = false
	for i, squad in ipairs(alliesInConflict) do
		-- anyHavePreviousSector = not squad.militia and squad.PreviousSector
		anyHavePreviousSector = anyHavePreviousSector and squad.PreviousSector ~= sector.Id
		if anyHavePreviousSector then
			break
		end
	end
	if not anyHavePreviousSector then
		return false
	end
	if sector.autoresolve_disabled then
		return false
	end
	if not enemySquads or #enemySquads == 0 then
		return false
	end
	return CanGoInMap(sector.Id) and not sector.ForceConflict
end

function SatelliteRetreat(sector_id, sides_to_retreat)
	NetUpdateHash("SatelliteRetreat", sector_id)
	local sector = gv_Sectors[sector_id]
	if not sector.conflict then
		return
	end
	sides_to_retreat = sides_to_retreat or { "player1" }
	local previousSector = false
	local squadsToRetreat = {}
	for i, squad in ipairs(g_SquadsArray) do
		--   if not squad.militia and squad.CurrentSector == sector_id and IsSquadInConflict(squad) and table.find(sides_to_retreat, squad.Side) then
		if not squad.militia and squad.CurrentSector == sector_id and IsSquadInConflict(squad) and table.find(sides_to_retreat, squad.Side) then
			squadsToRetreat[#squadsToRetreat + 1] = squad
			if squad.PreviousSector == sector_id then
				squad.PreviousSector = false
			end
			if squad.PreviousSector then
				previousSector = squad.PreviousSector
			end
		end
	end
	if previousSector then
		for i, squad in ipairs(squadsToRetreat) do
			if not squad.PreviousSector then
				squad.PreviousSector = previousSector
			end
		end
	end
	for i, squad in ipairs(squadsToRetreat) do
		local prev_sector_id = sector.conflict.player_attacking and sector.conflict.prev_sector_id or
			squad.PreviousSector
		if IsWaterSector(prev_sector_id) and squad.PreviousLandSector then
			prev_sector_id = squad.PreviousLandSector
		end
		if prev_sector_id then
			if IsSectorUnderground(sector_id) or IsSectorUnderground(prev_sector_id) then
				SetSatelliteSquadCurrentSector(squad, prev_sector_id)
			else
				do
					local badRetreat = false
					local otherSideSquads = (squad.Side == "enemy1" or squad.Side == "enemy2") and
						g_PlayerAndMilitiaSquads or g_EnemySquads
					for i, os in ipairs(otherSideSquads) do
						if os.CurrentSector == sector_id and os.route then
							local nextDest = os.route[1] and os.route[1][1]
							if nextDest == prev_sector_id then
								badRetreat = true
								break
							end
						end
					end
					local prevSector = gv_Sectors[prev_sector_id]
					local illegalRetreat = prevSector.Passability == "Water" or prevSector.Passability == "Blocked"
					badRetreat = badRetreat or illegalRetreat
					badRetreat = badRetreat or not not table.find(otherSideSquads, "CurrentSector", prev_sector_id)
					if badRetreat then
						local illegalRetreatFallback, foundSector = false, false
						ForEachSectorCardinal(sector_id, function(otherSecId)
							local considerThisSector = false
							local otherSec = gv_Sectors[otherSecId]
							if SideIsAlly(otherSec.Side, squad.Side) then
								considerThisSector = true
							elseif not table.find(otherSideSquads, "CurrentSector", otherSecId) then
								considerThisSector = true
							end
							local forbiddenRoute = IsRouteForbidden({
								{ otherSecId }
							}, squad)
							if illegalRetreat and not illegalRetreatFallback and not forbiddenRoute then
								illegalRetreatFallback = otherSecId
							end
							if considerThisSector and not forbiddenRoute then
								foundSector = true
								prev_sector_id = otherSecId
								return "break"
							end
						end)
						if illegalRetreat and not foundSector and illegalRetreatFallback then
							prev_sector_id = illegalRetreatFallback
						end
					end
					local retreatRoute = GenerateRouteDijkstra(squad.CurrentSector, prev_sector_id, false, squad.units,
						"retreat", squad.CurrentSector, squad.side)
					retreatRoute = retreatRoute or { prev_sector_id }
					local keepJoining = false
					if squad.joining_squad then
						local squadToJoin = gv_Squads[squad.joining_squad]
						keepJoining = squadToJoin and squadToJoin.CurrentSector == prev_sector_id
					end
					SetSatelliteSquadRetreatRoute(squad, { retreatRoute }, keepJoining)
				end
			end
		end
	end
	ResolveConflict(sector, "no voice", false, "retreat")
	ResumeCampaignTime("UI")
end
