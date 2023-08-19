return {
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "FarFromHome",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'Conditions', {},
	'Modifiers', {},
	'DisplayName', T(218005868262, --[[ModItemCharacterEffectCompositeDef FarFromHome DisplayName]] "Far From Home"),
	'Description', T(558594682290, --[[ModItemCharacterEffectCompositeDef FarFromHome Description]] "Militia soldiers who fight too far from their hometown, especially rookies, face various negative effects such as loss of morale."),
	'type', "Debuff",
	'Icon', "Mod/LXPER6t/Icons/farfromhome.png",
	'Shown', true,
	'ShownSatelliteView', true,
	'HideOnBadge', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "GCMilitia",
	'object_class', "CharacterEffect",
	'msg_reactions', {
		PlaceObj('MsgReaction', {
			Event = "NewHour",
			Handler = function (self)
				local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "NewHour")
				if not reaction_idx then return end
				
				local function exec(self)
				local armor = GetEquipedArmor
				local weapons = GetEquippedWeapons
				local conditionPerHour = 1
				
				for _, item in ipairs(armor) do
							if item.Repairable and item.Condition < 80 then
							item.Condition = item.Condition + conditionPerHour
						end
				end
									
				for _, item in ipairs(weapons) do
							if item.Repairable and item.Condition < 80
							 then
							item.Condition = item.Condition + conditionPerHour
							end
				end
				end
				local id = GetCharacterEffectId(self)
				
				if id then
					local objs = {}
					for session_id, data in pairs(gv_UnitData) do
						local obj = g_Units[session_id] or data
						if obj:HasStatusEffect(id) then
							objs[session_id] = obj
						end
					end
					for _, obj in sorted_pairs(objs) do
						exec(self)
					end
				else
					exec(self)
				end
				
			end,
			HandlerCode = function (self)
				local armor = GetEquipedArmor
				local weapons = GetEquippedWeapons
				local conditionPerHour = 1
				
				for _, item in ipairs(armor) do
							if item.Repairable and item.Condition < 80 then
							item.Condition = item.Condition + conditionPerHour
						end
				end
									
				for _, item in ipairs(weapons) do
							if item.Repairable and item.Condition < 80
							 then
							item.Condition = item.Condition + conditionPerHour
							end
				end
			end,
			param_bindings = false,
		}),
	},
	'DisplayName', T(337979128555, --[[ModItemCharacterEffectCompositeDef GCMilitia DisplayName]] "Grand Chien Militia"),
	'Description', T(912875803383, --[[ModItemCharacterEffectCompositeDef GCMilitia Description]] "A perk every militia solider gets after bootcamp. Which allows them to clean and maintain their weapons."),
}),
PlaceObj('ModItemCode', {
	'name', "Finances",
	'CodeFileName', "Code/Finances.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Init",
	'CodeFileName', "Code/Init.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Movement",
	'CodeFileName', "Code/Movement.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Names",
	'CodeFileName', "Code/Names.lua",
}),
PlaceObj('ModItemCode', {
	'name', "SquadIcons",
	'CodeFileName', "Code/SquadIcons.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Training",
	'CodeFileName', "Code/Training.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Utils",
	'CodeFileName', "Code/Utils.lua",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "militiaNoWeapons",
	'DisplayName', "Militia spawn without weapons",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "militiaUpkeep",
	'DisplayName', "Militia costs upkeep",
	'DefaultValue', true,
}),
}
