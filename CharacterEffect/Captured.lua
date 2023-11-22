UndefineClass('Captured')
DefineClass.Captured = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {},
	Conditions = {},
	Modifiers = {},
	DisplayName = T(391335563250, --[[ModItemCharacterEffectCompositeDef Captured DisplayName]] "Captured"),
	Description = T(974882876317, --[[ModItemCharacterEffectCompositeDef Captured Description]] "This soldier was captured an will be treated as POW after the conflict ends."),
	AddEffectText = T(499266233002, --[[ModItemCharacterEffectCompositeDef Captured AddEffectText]] "Captured"),
	OnAdded = GetMissingSourceFallback(),
	type = "Debuff",
	Icon = "Mod/LXPER6t/Icons/captured.png",
	Shown = true,
	ShownSatelliteView = true,
	HasFloatingText = true,
}

