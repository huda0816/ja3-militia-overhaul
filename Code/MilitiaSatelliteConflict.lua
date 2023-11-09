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
		"We lost contact to our militia Squad in the Refugee Camp. We should send a squad to investigate the situation. (If there is a combat dialog: please press retreat. Your squad is gone anyway.)")

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
				#GetSquadsInSector(sector.Id, "excludeTravelling",
					not HUDA_GetModOptions("MilitiaNoControl", false), "excludeArriving", "excludeRetreating") > 0 and
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

local HUDA_OriginalIsAutoResolveEnabled = IsAutoResolveEnabled

function IsAutoResolveEnabled(sector)
	if sector.autoresolve_disabled then
		return false
	end

	if CanGoInMap(sector.Id) and sector.ForceConflict then
		return false
	end

	return HUDA_OriginalIsAutoResolveEnabled(sector)
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
		if squad.CurrentSector == sector_id and IsSquadInConflict(squad) and table.find(sides_to_retreat, squad.Side) then
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

function ResolveConflict(sector, bNoVoice, isAutoResolve, isRetreat)
	gv_ActiveCombat = false
	sector = sector or gv_Sectors[gv_CurrentSectorId]
	local mercSquads, enemySquads = GetSquadsInSector(sector.Id, "no_travel", false, "no_arriving", "no_retreat")
	-- local militiaLeft = GetMilitiaSquads(sector)
	-- if #militiaLeft > 0 and #enemySquads > 0 then
	-- 	if isAutoResolve then
	-- 		assert(false) -- Auto resolve is causing another auto resolve, infinite loop!
	-- 		table.remove_value(g_ConflictSectors, sector.Id)
	-- 		sector.conflict = false
			
	-- 		if not AnyNonWaitingConflict() then
	-- 			ResumeCampaignTime("SatelliteConflict")	
	-- 		end
	-- 		return
	-- 	end

	-- 	if g_SatelliteUI then
	-- 		AutoResolveConflict(sector)
	-- 	elseif not table.find(SatQueuedResolveConflict, sector.Id) then
	-- 		SatQueuedResolveConflict[#SatQueuedResolveConflict + 1] = sector.Id
	-- 	end
	-- 	return
	-- end
	local playerAttacking = sector.conflict and sector.conflict.player_attacking
	local fromMap = sector.conflict and sector.conflict.from_map
	if sector then
		table.remove_value(g_ConflictSectors, sector.Id)
		sector.conflict = false
		if not g_Combat then
			ShowTacticalNotification("conflictResolved")
			PlayFX("NoEnemiesLeft", "start")
		end
	end
	if not AnyNonWaitingConflict() then
		ResumeCampaignTime("SatelliteConflict")
	end
	UpdateEntranceAreasVisibility()
	local squads = GetSquadsInSector(sector.Id)
	for i, squad in ipairs(squads) do
		ObjModified(squad)
	end
	ObjModified(SelectedObj)
	ObjModified("gv_SatelliteView")
	UpdateSectorControl(sector.Id)
	if (sector.Side == "player1" or sector.Side == "player2") and not gv_SatelliteView and #mercSquads == 0 then
		local playerUnitsOnMap = GetCurrentMapUnits("player")
		local enemyUnitsOnMap = GetCurrentMapUnits("enemy")
		if #playerUnitsOnMap == 0 and 0 < #enemyUnitsOnMap then
			local first = enemyUnitsOnMap[1]
			SatelliteSectorSetSide(sector.Id, "enemy1")
		end
	end
	local playerWon = not isRetreat and (sector.Side == "player1" or sector.Side == "player2")
	if playerWon then
		sector.CustomConflictDescr = false
		RollForMilitiaPromotion(sector)
	end
	Msg("ConflictEnd", sector, bNoVoice, playerAttacking, playerWon, isAutoResolve, isRetreat, fromMap)
end

local HUDA_OriginalDropLoot = Unit.DropLoot

function Unit:DropLoot(container)
	local is_npc = self:IsNPC()
	
	local debugText =  _InternalTranslate(self.Name) .. " dropping loot: (roll must be lower)"
	
	-- Locked items never drop.
	-- Go over the equipped items, drop them to "Inventory" based on their drop chance,
	-- Equipped items from Mercs always drop(except locked items). Otherwise check the drop chance.
	local droped_items = 0
	self:ForEachItem(function(item, slot_name, left, top, self, container, is_npc)
		if slot_name == "InventoryDead" then return end
		self:RemoveItem(slot_name, item)	
		
		local dropped
		local roll = self:Random(100)
		local slot = container and "Inventory" or "InventoryDead"
		
		debugText = debugText .. "\n " ..  _InternalTranslate(item.DisplayName) .. ": roll " .. roll .. "/" .. item.drop_chance .. "% chance" 

		if not item.locked and (not is_npc or roll < item.drop_chance) then
			local addTo = container or self
			
			local pos, err = addTo:CanAddItem(slot, item)
			assert(pos, "Couldn't FIND pos in Inventory to place dropped item. Err: '" .. err .. "'")
			if pos then
				dropped, err = addTo:AddItem(slot, item, point_unpack(pos))
				assert(dropped, "Couldn't PLACE dropped item in Inventory. Err: '" .. err .. "'")
			end
		end
		
		if not dropped then
			DoneObject(item)
		elseif slot == "InventoryDead" then
			droped_items = droped_items + (item:IsLargeItem() and 2 or 1)
		end
	end, self, container, is_npc)

	if droped_items > 0 then
		self.max_dead_slot_tiles = droped_items
	end

	CombatLog("debug", debugText)
end


function Unit:DropLoot(container)
	if self.militia then
		local droped_items = 0
		local is_npc = false
		self:ForEachItem(function(item, slot_name, left, top, self, container, is_npc)
			if slot_name == "InventoryDead" then
				return
			end
			self:RemoveItem(slot_name, item)
			local dropped
			local slot = container and "Inventory" or "InventoryDead"
			if not item.locked then
				local addTo = container or self
				local pos, err = addTo:CanAddItem(slot, item)
				if pos then
					dropped, err = addTo:AddItem(slot, item, point_unpack(pos))
				end
			end
			if not dropped then
				DoneObject(item)
			elseif slot == "InventoryDead" then
				droped_items = droped_items + (item:IsLargeItem() and 2 or 1)
			end
		end, self, container, is_npc)
	else
		HUDA_OriginalDropLoot(self, container)
	end
end

function OnMsg.ConflictStart(sectorId)
	if not HUDA_GetModOptions("MilitiaNoControl", false) then
		return
	end

	local sector = gv_Sectors[sectorId]

	local militia = sector.militia_squads

	if militia then
		for i, squad in ipairs(militia) do
			squad.Side = "ally"
		end
	end
end

function OnMsg.EnterSector()
	if not HUDA_GetModOptions("MilitiaNoControl", false) then
		return
	end

	local sector = gv_Sectors[gv_CurrentSectorId]

	local militia = sector.militia_squads

	if militia then
		for i, squad in ipairs(militia) do
			squad.Side = "ally"
		end
	end
end

function OnMsg.ClosePDA()
	if not HUDA_GetModOptions("MilitiaNoControl", false) then
		return
	end

	local sector = gv_Sectors[gv_CurrentSectorId]

	local militia = sector.militia_squads

	if militia then
		for i, squad in ipairs(militia) do
			squad.Side = "ally"
		end
	end
end

function OnMsg.OpenPDA()

	for i, squad in ipairs(gv_Squads) do
		if squad.militia then
			squad.Side = "player1"			
		end
	end

	ObjModified("gv_SatelliteView")
	ObjModified("gv_Squads")
end

function OnMsg.SquadStartedTravelling(squad)
	if not HUDA_GetModOptions("MilitiaNoControl", false) then
		return
	end

	if not squad.militia then
		return
	end

	local route = squad.route

	local hostile = false

	for i, sectorId in ipairs(route[1]) do
		local sector = gv_Sectors[sectorId]

		if sector.Side == "enemy1" then
			hostile = true
			break
		end
	end

	if hostile then
		squad.route = false

		local popupHost = GetDialog("PDADialogSatellite")
		popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

		local dlg = CreateMessageBox(popupHost, Untranslated("Militia cannot move"),
			Untranslated(
				"As you are moving through or to a sector with enemy presence, your militia cannot move. (Change option to control militia in battle to move them)"))
	end
end
