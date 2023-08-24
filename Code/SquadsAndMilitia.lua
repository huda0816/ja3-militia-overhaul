function TFormat.HUDA_MilitiaSince(context_obj)
	local unit = gv_UnitData[context_obj.session_id]
	local t = GetTimeAsTable(unit.JoinDate or 0)
	local month = string.format("%02d", t and t.month or 1)
	local day = string.format("%02d", t and t.day or 1)
	local year = tostring(t and t.year or 1)
	local systemDateFormat = GetDateTimeOrder()
	for i, unit in ipairs(systemDateFormat) do
		systemDateFormat[i] = "<u(" .. unit .. ")>"
	end
	systemDateFormat = table.concat(systemDateFormat, ".")
	return T({
		systemDateFormat,
		month = month,
		day = day,
		year = year
	})
end

function TFormat.HUDA_MilitiaOrigin(context_obj)
	local unit = gv_UnitData[context_obj.session_id]
	return GetSectorName(unit.JoinLocation or "Knowhere")
end

if FirstLoad then
	local huda_pda_merc_rollover_attributes = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(
		XTemplates["PDAMercRollover"], "comment",
		"attributes label")

	if huda_pda_merc_rollover_attributes then
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia
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
				})
			})
		)
		table.insert(huda_pda_merc_rollover_attributes.ancestors[1], huda_pda_merc_rollover_attributes.indices[1] + 2,
			PlaceObj("XTemplateWindow", {
				"__condition",
				function(parent, context)
					return context.militia
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

	local x_button = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SquadsAndMercs"], "__class",
		"XButton")

	if x_button then
		x_button.element[1].Id = "idBgSquadIcon"

		x_button.element.OnContextUpdate = function(self, context)
			if IsContextMilitia(context) then
				self.idBgSquadIcon:SetImage("Mod/LXPER6t/Icons/merc_squad_militia.png")
			end
		end
	end


	local huda_context_actions = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(
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
				end
			end

			return context and context.actions
		end
	end

	if tm_template then
		tm_template.element.__context = function(parent, context)
			local squads = GetSquadsOnMapUI()

			local militia = table.filter(squads, function(k, v) return IsContextMilitia(v) end)
			local mercs = table.filter(squads, function(k, v) return not IsContextMilitia(v) end)

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

	local inv_template = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["Inventory"], "__template",
		"SquadsAndMercs")

	if inv_template then
		inv_template.element.__context = function(parent, context) return InventorySquads() end
	end

	function InventorySquads()
		local squads = SortSquads(gv_SatelliteView and GetSquadsInSector(false, false, true) or
			GetSquadsOnMap("reference"))

		table.sort(squads, function(a, b)
			return a.CurrentSector < b.CurrentSector
		end)

		return squads
	end

	local template = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASatellite"], "__template",
		"SquadsAndMercs")

	if template then
		template.element.__context = function(parent, context)
			local squads = GetGroupedSquads(false, true, true)

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
			self.idBase:SetImage("Mod/LXPER6t/Icons/merc_squad_militia.png")
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
