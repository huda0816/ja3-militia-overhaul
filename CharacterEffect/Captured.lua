UndefineClass('Captured')
DefineClass.Captured = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {},
	Conditions = {},
	Modifiers = {},
	DisplayName = T(853091363003, --[[ModItemCharacterEffectCompositeDef Captured DisplayName]] "Captured"),
	Description = T(747540003476, --[[ModItemCharacterEffectCompositeDef Captured Description]] "This soldier was captured an will be treated as POW after the conflict ends."),
	OnAdded = function (self, obj)
		HUDA_MilitiaPOW:POW(self, obj)
	end,
	type = "Debuff",
	Icon = "Mod/LXPER6t/Icons/captured.png",
	Shown = true,
	ShownSatelliteView = true,
}

