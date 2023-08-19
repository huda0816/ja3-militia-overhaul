UndefineClass('GCMilitia')
DefineClass.GCMilitia = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {
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
	DisplayName = T(337979128555, --[[ModItemCharacterEffectCompositeDef GCMilitia DisplayName]] "Grand Chien Militia"),
	Description = T(912875803383, --[[ModItemCharacterEffectCompositeDef GCMilitia Description]] "A perk every militia solider gets after bootcamp. Which allows them to clean and maintain their weapons."),
}

