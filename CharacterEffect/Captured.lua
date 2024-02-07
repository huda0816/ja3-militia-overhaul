UndefineClass('Captured')
DefineClass.Captured = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {},
	Conditions = {},
	Modifiers = {},
	DisplayName = T(304468707740, --[[ModItemCharacterEffectCompositeDef Captured DisplayName]] "Captured"),
	Description = T(299149809053, --[[ModItemCharacterEffectCompositeDef Captured Description]] "This soldier was captured an will be treated as POW after the conflict ends."),
	AddEffectText = T(994208219364, --[[ModItemCharacterEffectCompositeDef Captured AddEffectText]] "Captured"),
	OnAdded = function (self, obj)  end,
	type = "Debuff",
	Icon = "Mod/LXPER6t/Icons/captured.png",
	Shown = true,
	ShownSatelliteView = true,
	HasFloatingText = true,
}

