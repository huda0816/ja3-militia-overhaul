GameVar("gv_HUDA_SamStatus", "mercs")

function TFormat.HUDA_MilitiaSince(context_obj)
	if not context_obj then
		return
	end

	local unit = gv_UnitData[context_obj.session_id]

	if not unit then
		return
	end

	return Untranslated(HUDA_GetDaysSinceTime(unit.JoinDate or 0) .. " days ago")
end

function TFormat.HUDA_MilitiaOrigin(context_obj)
	if not context_obj then
		return
	end

	local unit = gv_UnitData[context_obj.session_id]

	if not unit then
		return
	end

	local sector = type(unit.JoinLocation) == "table" and unit.JoinLocation or gv_Sectors[unit.JoinLocation or "H2"]

	return Untranslated(GetSectorName(sector))
end

function TFormat.HUDA_MilitiaBackground(context_obj)
	if not context_obj then
		return
	end

	local unit = gv_UnitData[context_obj.session_id]

	if not unit then
		return
	end

	local archeType = unit.ArcheType or "Worker"

	return Untranslated(HUDA_MilitiaPersonalization.archetypes[archeType] and
		HUDA_MilitiaPersonalization.archetypes[archeType].label or "Worker")
end

function TFormat.HUDA_MilitiaBio(context_obj)
	if not context_obj then
		return
	end

	local unit = gv_UnitData[context_obj.session_id]

	if not unit then
		return
	end

	return Untranslated(unit.Bio) or Untranslated("This man's bio is a mystery.")
end

function OnMsg.DataLoaded()
	local huda_pda_merc_rollover_attributes = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates["PDAMercRollover"], "comment",
		"attributes label")

	if huda_pda_merc_rollover_attributes then
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia and gv_SatelliteView and not HUDA_IsInventoryView() and
						not HUDA_IsSquadManagementView()
				end,
				"__class",
				"XContextWindow",
				"Margins",
				box(0, 0, 0, 0),
				"Padding",
				box(14, 3, 14, 3),
				"MinHeight",
				34,
				"LayoutMethod",
				"VList",
				"LayoutVSpacing",
				-3,
				"Background",
				RGBA(32, 35, 47, 255)
			}, {
				PlaceObj("XTemplateWindow", {
					"__class",
					"XText",
					"VAlign",
					"center",
					"MaxWidth",
					400,
					"Clip",
					false,
					"UseClipBox",
					false,
					"TextStyle",
					"SatelliteContextMenuKeybind",
					"Translate",
					true,
					"Text",
					Untranslated("<HUDA_MilitiaBio()>")
				})
			})
		)
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia and gv_SatelliteView and not HUDA_IsInventoryView() and
						not HUDA_IsSquadManagementView()
				end,
				"comment",
				"attributes label",
				"__class",
				"XText",
				"Margins",
				box(8, 0, 0, 0),
				"MinHeight",
				34,
				"Clip",
				false,
				"UseClipBox",
				false,
				"FoldWhenHidden",
				true,
				"TextStyle",
				"PDABrowserNameSmall",
				"Translate",
				true,
				"Text",
				Untranslated("Bio"),
				"TextVAlign",
				"center"
			})
		)
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia and not HUDA_IsInventoryView()
				end,
				"__class",
				"XContextWindow",
				"Margins",
				box(0, 0, 0, 0),
				"Padding",
				box(14, 3, 14, 3),
				"MinHeight",
				34,
				"LayoutMethod",
				"VList",
				"LayoutVSpacing",
				-3,
				"Background",
				RGBA(32, 35, 47, 255)
			}, {
				PlaceObj("XTemplateWindow", {
					"__class",
					"XText",
					"VAlign",
					"center",
					"Clip",
					false,
					"UseClipBox",
					false,
					"TextStyle",
					"SatelliteContextMenuKeybind",
					"Translate",
					true,
					"Text",
					Untranslated("Joined<right><style PDABrowserTextLightMedium><HUDA_MilitiaSince()></style>")
				}),
				PlaceObj("XTemplateWindow", {
					"__class",
					"XText",
					"VAlign",
					"center",
					"Clip",
					false,
					"UseClipBox",
					false,
					"TextStyle",
					"SatelliteContextMenuKeybind",
					"Translate",
					true,
					"Text",
					Untranslated("Origin<right><style PDABrowserTextLightMedium><HUDA_MilitiaOrigin()></style>")
				}),
				PlaceObj("XTemplateWindow", {
					"__class",
					"XText",
					"VAlign",
					"center",
					"Clip",
					false,
					"UseClipBox",
					false,
					"TextStyle",
					"SatelliteContextMenuKeybind",
					"Translate",
					true,
					"Text",
					Untranslated("Background<right><style PDABrowserTextLightMedium><HUDA_MilitiaBackground()></style>")
				})
			})
		)
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia and not HUDA_IsInventoryView()
				end,
				"comment",
				"attributes label",
				"__class",
				"XText",
				"Margins",
				box(8, 0, 0, 0),
				"MinHeight",
				34,
				"Clip",
				false,
				"UseClipBox",
				false,
				"FoldWhenHidden",
				true,
				"TextStyle",
				"PDABrowserNameSmall",
				"Translate",
				true,
				"Text",
				Untranslated("Militia"),
				"TextVAlign",
				"center"
			})
		)
	end

	local inventory_dialog = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["Inventory"], "Id",
		"idDlgContent")

	if inventory_dialog then
		local element = inventory_dialog.element

		element[1].MinWidth = 1700
		element[1].MaxWidth = 1700
		element[1].DrawOnTop = true
		element[1].LayoutMethod = "HWrap"

		if not HUDA_IsModActive("ii6mKUf") then
			element[2].Margins = box(-1610, 0, 0, 75)
			element[3].Margins = box(-1250, 18, 0, 0)
			element[4].Margins = box(-860, 18, 32, 32)
		end
	end

	local squadList = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates.SquadsAndMercs, 'Id', 'idTitle')

	if squadList and squadList.element then
		squadList.element.LayoutMethod = "HList"
		squadList.element.Margins = box(-10, -10, 0, 0)
		squadList.element[1].HAlign = "left"
		squadList.element[1].VAlign = "center"
		squadList.element[2].Dock = "left"
	end

	local x_fit = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SquadsAndMercs"], "__class",
		"XFitContent")

	if x_fit then
		x_fit.element.HandleMouse = false
	end

	local x_buttons = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SquadsAndMercs"], "Id",
		"idSquadButtons")

	if x_buttons then
		for index, x_button in ipairs(x_buttons.element[2]) do
			x_button[1].Id = "idBgSquadIcon"

			x_button.OnContextUpdate = function(self, context)
				self:SetFoldWhenHidden(true)
				if HUDA_IsContextMilitia(context) then
					self.idBgSquadIcon:SetImage("Mod/LXPER6t/Icons/merc_squad_militia_2.png")

					if gv_HUDA_SamStatus == "militia" then
						self:SetVisible(true)
					else
						self:SetVisible(false)
					end
				else
					if gv_HUDA_SamStatus == "mercs" then
						self:SetVisible(true)
					else
						self:SetVisible(false)
					end
				end
				if gv_HUDA_SamStatus == "mercsandmilitia" then
					self:SetVisible(true)
				end
			end
			x_button.Margins = box(0, 0, -10, 0)
			x_button.AltPress = true
			x_button.OnAltPress = function(self, gamepad)
				if g_SatelliteUI then
					if g_SatelliteUI.context_menu then
						local prev_context = g_SatelliteUI.context_menu[1].context
						prev = prev_context and prev_context.unit_id
						g_SatelliteUI:RemoveContextMenu()
					end
					local squad = self.context
					local sector_id = squad and squad.CurrentSector
					if not sector_id then
						return
					end
					self:SetRollover(false)
					g_SatelliteUI:SelectSquad(squad)
					g_SatelliteUI:OpenContextMenu(self, sector_id, squad.UniqueId)
				end
			end
		end
	end

	local squad_buttons = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SquadsAndMercs"], "Id",
		"idSquadButtons")

	if squad_buttons then
		local element = squad_buttons.element

		element.LayoutHSpacing = 0

		table.insert(element, 1, PlaceObj("XTemplateWindow", {
			"__class",
			"XButton",
			"__condition",
			function(parent, context)
				return gv_SatelliteView and HUDA_TableFind(gv_Squads, function(k, v)
					return v.militia and #v.units > 0
				end)
			end,
			"Id",
			"idMilitiaToggleButton",
			"Margins",
			box(7, 2, 0, 0),
			"MaxHeight",
			30,
			"MinHeight",
			30,
			"VAlign",
			"top",
			"FXPress",
			"MercPortraitPressPDA",
			"__context",
			function(parent, context)
				return "mercs"
			end,
			"OnLayoutComplete",
			function(self)
				ShowToggleMilitiaTutorial()
			end,
			"OnPress",
			function(self, gamepad)
				if (gv_HUDA_SamStatus == "mercs") then
					gv_HUDA_SamStatus = "militia"
					for i, button in ipairs(self.parent) do
						if button.context.UniqueId then
							if button.context.militia then
								button:SetVisible(true)
							else
								button:SetVisible(false)
							end
						end
					end
				else
					gv_HUDA_SamStatus = "mercs"
					for i, button in ipairs(self.parent) do
						if button.context.UniqueId then
							if button.context.militia then
								button:SetVisible(false)
							else
								button:SetVisible(true)
							end
						end
					end
				end
				ObjModified("ui_player_squads")
			end,
		}, {
			PlaceObj("XTemplateWindow", {
				"__class",
				"XImage",
				"Id",
				"ToggleImage",
				"Padding",
				box(5, 0, 5, 0),
				"ImageColor",
				RGBA(61, 122, 153, 255),
				"Background",
				RGBA(255, 255, 255, 255),
				"Image",
				"UI/Hud/weapon_switch"
			})
		}))

		ObjModified("ui_player_squads")
		ObjModified("hud_squads")
	end

	table.insert(XTemplates["GameShortcuts"], PlaceObj("XTemplateAction", {
		"ActionId",
		"actionDeleteMilitia",
		"ActionSortKey",
		"10000",
		"ActionName",
		Untranslated("Dismiss Unit"),
		"ActionBindable",
		true,
		"ActionMouseBindable",
		false,
		"ActionState",
		function(self, host)
			return SatelliteToggleActionState() or "enabled" or "disabled"
		end,
		"OnAction",
		function(self, host, source, ...)
			local unit_id = g_SatelliteUI and g_SatelliteUI.context_menu
			if not unit_id then
				return
			end
			unit_id = unit_id and unit_id:ResolveId("idContent"):GetContext().unit_id
			local unit = gv_UnitData[unit_id]
			local items = {}
			unit:ForEachItem(function(item, slot)
				unit:RemoveItem(slot, item)
				table.insert(items, item)
			end)
			local sector_id = gv_CurrentSectorId
			AddToSectorInventory(sector_id, items)
			RemoveUnitFromSquad(unit, "despawn")
			ObjModified("ui_player_squads")
			ObjModified("hud_squads")
		end,
		"IgnoreRepeated",
		true
	})
	)

	table.insert(XTemplates["GameShortcuts"], PlaceObj("XTemplateAction", {
		"ActionId",
		"actionEditSquad",
		"ActionSortKey",
		"10000",
		"ActionName",
		Untranslated("Edit Squad"),
		"ActionBindable",
		true,
		"ActionMouseBindable",
		false,
		"ActionState",
		function(self, host)
			return "enabled"
		end,
		"OnAction",
		function(self, host, source, ...)
			local context_menu = g_SatelliteUI and g_SatelliteUI.context_menu
			if not context_menu then
				return
			end

			local squad_id = context_menu:ResolveId("idContent"):GetContext().squad_id

			if not squad_id then
				return
			end

			local squad = gv_Squads[squad_id]

			if not squad then
				return
			end

			OpenMilitiaPDA("squad", { selected_squad = squad })
		end,
		"IgnoreRepeated",
		true
	})
	)

	local huda_context_actions = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(
		XTemplates["SatelliteViewMapContextMenu"],
		"comment", "actions")

	if huda_context_actions then
		huda_context_actions.element.__context = function(parent, context)
			if not context then
				return
			end

			if context.squad_id then
				local squad = gv_Squads[context.squad_id]

				if squad and squad.militia then
					context.actions = table.filter(context.actions,
						function(k, v) return v ~= "actionOpenCharacterContextMenu" and v ~= "idPerks" end)
					if gv_SatelliteView and context.unit_id then
						table.insert(context.actions, "actionDeleteMilitia")
					end
					if gv_SatelliteView then
						table.insert(context.actions, "actionEditSquad")
					end
				end
			end

			return context and context.actions
		end
	end

	local tm_template = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["TeamMembers"], "__template",
		"SquadsAndMercs")

	if tm_template then
		tm_template.element.__context = function(parent, context)
			local squads = GetSquadsOnMapUI()

			local militia = table.filter(squads, function(k, v) return HUDA_IsContextMilitia(v) end)
			local mercs = table.filter(squads, function(k, v) return not HUDA_IsContextMilitia(v) end)

			local both = {}

			for _, merc in pairs(mercs) do
				table.insert(both, merc)
			end

			for _, mil in pairs(militia) do
				table.insert(both, mil)
			end

			return both
		end
	end

	local inv_template = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["Inventory"], "__template",
		"SquadsAndMercs")

	if inv_template then
		inv_template.element.__context = function(parent, context) return InventorySquads() end
	end

	local template = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["PDASatellite"], "__template",
		"SquadsAndMercs")

	if template then
		template.element.__context = function(parent, context)
			local squads = GetGroupedSquads(false, true)

			local militia = table.filter(squads, function(k, v) return v.militia end)
			local mercs = table.filter(squads, function(k, v) return not v.militia end)

			local both = {}

			for _, merc in pairs(mercs) do
				table.insert(both, merc)
			end

			for _, mil in pairs(militia) do
				table.insert(both, mil)
			end

			return both
		end
	end

	XTemplates.SatelliteIconCombined[1].OnContextUpdate = function(self, context, ...)
		if context.militia then
			self.idBase:SetImage("Mod/LXPER6t/Icons/merc_squad_militia_2.png")
			self.idUpperIcon:SetImage("")
		else
			local base, up = GetSatelliteIconImages(context)
			self.idBase:SetImage(base)
			self.idUpperIcon:SetImage(up)
		end
		if context.squad and context.side == "player1" or context.side == "player2" or context.militia then
			self.idUpperIcon:SetMargins(box(0, 4, 0, 0))
			self.idUpperIcon:SetScaleModifier(point(800, 800))
			self.idUpperIcon:SetHAlign("center")
			self.idUpperIcon:SetVAlign("top")
		end
	end
end

function InventorySquads()
	local squads = SortSquads(gv_SatelliteView and GetSquadsInSector(false, false, true) or
		GetSquadsOnMap("reference"))

	table.sort(squads, function(a, b)
		return a.CurrentSector < b.CurrentSector
	end)

	return squads
end

function SquadWindow:Open()
	self:SetWidth(72)
	self:SetHeight(72)
	local side = self.context.Side
	local is_militia = self.context.militia
	local is_player = side == "player1" or side == "player2" or is_militia
	self.is_player = is_player
	self:SpawnSquadIcon()
	local map = self.map
	if self.context.XVisualPos then
		self.PosX, self.PosY = self.context.XVisualPos:xy()
	else
		local sectorWnd = map.sector_to_wnd[self.context.CurrentSector]
		if sectorWnd then
			self.PosX, self.PosY = sectorWnd:GetSectorCenter()
		end
	end
	XContextWindow.Open(self)
	self:CreateThread("late-update", function()
		SquadUIUpdateMovement(self)
		Sleep(25)
		self:SetAnim(self.rollover)
	end)
end

function SquadWindow:SpawnSquadIcon(parent)
	parent = parent or self
	local side = self.context.Side
	local is_militia = self.context.militia
	local is_player = side == "player1" or side == "player2" or is_militia
	self.is_player = is_player
	local img
	if is_player then
		img = XTemplateSpawn("SatelliteIconCombined", parent, SubContext(self.context, {
			side = side,
			squad = is_player and self.context.UniqueId,
			map = true
		}))
		img:SetUseClipBox(false)
	else
		img = XTemplateSpawn("XMapRollerableContextImage", parent, self.context)
		local squad_img = GetSatelliteIconImagesSquad(self.context)
		img:SetImage(squad_img or "UI/Icons/SateliteView/enemy_squad")
		img:SetUseClipBox(false)
	end
	if parent == self then
		img:SetId("idSquadIcon")
	end
	return img
end

function GetSatelliteSquadsForContextMenu(sectorId)
	if not sectorId then
		return empty_table
	end
	local squads = GetSquadsInSector(sectorId, "excludeTravelling", true, "excludeArriving")
	if #squads <= 1 then
		return empty_table
	end
	return squads
end

function RemoveUnitFromSquad(unit_data, reason)
	local squad_id = unit_data.Squad
	local squad = gv_Squads[squad_id]
	unit_data.OldSquad = squad_id
	unit_data.Squad = false
	if g_Units[unit_data.session_id] then
		local unit = g_Units[unit_data.session_id]
		unit.OldSquad = squad_id
		if reason == "despawn" then
			unit.session_id = false
		end
		if not (unit:IsDead() and unit:IsMerc() and squad) or not (#squad.units > 1) then
			unit.Squad = false
		else
			unit_data.Squad = squad_id
		end
	end
	if not squad then
		return
	end
	table.remove_value(squad.units, unit_data.session_id)
	-- There is some bug with millitia units being present twice in
	-- their squad for some reason 0.0
	while table.find(squad.units, unit_data.session_id) do
		assert(false) -- Unit was in the squad twice+ 0.0
		table.remove_value(squad.units, unit_data.session_id)
	end
	if not squad.units or #squad.units == 0 then
		Msg("PreSquadDespawned", squad_id, squad.CurrentSector, reason)
		if squad.militia then
			local sector = gv_Sectors[squad.CurrentSector]
			if sector.militia_squad_id == squad.UniqueId then
				sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(sector, squad.UniqueId)
			end
		end
		RemoveSquadsFromLists(squad)
		gv_Squads[squad_id] = nil
		Msg("SquadDespawned", squad_id, squad.CurrentSector, squad.Side)
	else
		if squad.militia then
			local sector = gv_Sectors[squad.CurrentSector]
			sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(sector)
		end
	end
	ObjModified(squad)
end

function XSatelliteViewMap:OpenContextMenu(ctrl, sector_id, squad_id, unit_id)
	if self.travel_mode then
		self:ExitTravelMode()
	end
	local actions = {}
	local squad = gv_Squads[squad_id]
	local squadName = squad and Untranslated(squad.Name)
	if unit_id then
		table.insert(actions, "idInventory")
		table.insert(actions, "idPerks")
	else
		local squadsOnSector = GetSquadsInSector(sector_id)
		local canEnterWithAny = false
		local currentSelectedSquad = self.selected_squad
		if currentSelectedSquad and table.find(squadsOnSector, currentSelectedSquad) and GetSquadEnterSectorState(currentSelectedSquad.UniqueId) then
			canEnterWithAny = currentSelectedSquad
		end
		if not canEnterWithAny then
			for i, s in ipairs(squadsOnSector) do
				if GetSquadEnterSectorState(s.UniqueId) then
					canEnterWithAny = s
					break
				end
			end
		end
		local selSquad = canEnterWithAny or squad
		if selSquad and selSquad.Side == "player1" and self.selected_squad ~= selSquad then
			self:SelectSquad(selSquad)
		end
		if SatelliteToggleActionState() == "enabled" and canEnterWithAny then
			table.insert(actions, "actionToggleSatellite")
		end
		if 0 < #squadsOnSector then
			table.insert(actions, "idOperations")
		end
		if squad_id and CanCancelSatelliteSquadTravel() == "enabled" then
			table.insert(actions, "idCancelTravel")
		end
		table.insert(actions, "actionContextMenuViewSectorStash")
	end
	if #actions == 0 then
		return
	end
	if IsKindOf(ctrl, "XMapObject") then
		SetCampaignSpeed(0, GetUICampaignPauseReason("UIContextMenu"))
	end
	local overrideRollover = false
	if RolloverWin and IsKindOf(RolloverWin, "ZuluContextMenu") then
		overrideRollover = RolloverWin
		RolloverWin = false
		RolloverControl = false
	else
		XDestroyRolloverWindow()
	end
	local context = {
		sector_id = sector_id,
		squad_id = squad_id,
		actions = actions,
		unit_id = unit_id
	}
	local popupHost = GetParentOfKind(self, "PDAClass")
	popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
	local menu = overrideRollover or XTemplateSpawn("SatelliteViewMapContextMenu", popupHost, context)
	self.context_menu = menu
	menu:SetAnchor(ctrl:ResolveRolloverAnchor())
	if IsKindOf(ctrl, "XMapRolloverable") then
		ctrl:SetupMapSafeArea(menu)
	else
		menu:SetMargins(box(30, 2, 0, 0))
	end
	if menu.window_state ~= "open" then
		menu:Open()
	end
	menu.idContent:SetContext(context, true)
	menu:SetModal(true)
	return menu
end

function OnMsg.SatelliteNewSquadSelected(selected_squad, old_squad, force)
	if not old_squad then
		return
	end

	if old_squad == selected_squad then
		return
	end

	if selected_squad.militia then
		if gv_HUDA_SamStatus == "militia" then
			return
		end

		gv_HUDA_SamStatus = "militia"
	else
		if gv_HUDA_SamStatus == "mercs" then
			return
		end

		gv_HUDA_SamStatus = "mercs"
	end

	ObjModified("ui_player_squads")
end

function OnMsg.ClosePDA()
	gv_HUDA_SamStatus = "mercsandmilitia"

	ObjModified("ui_player_squads")
end

function OnMsg.OpenPDA()
	gv_HUDA_SamStatus = "mercs"

	ObjModified("ui_player_squads")
end
