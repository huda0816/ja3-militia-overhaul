return {
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "FarFromHome",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'Conditions', {},
	'Modifiers', {},
	'DisplayName', T(336500922829, --[[ModItemCharacterEffectCompositeDef FarFromHome DisplayName]] "Far From Home"),
	'Description', T(400857602467, --[[ModItemCharacterEffectCompositeDef FarFromHome Description]] "Militia soldiers who fight too far from their hometown, especially rookies, face various negative effects such as loss of morale."),
	'type', "Debuff",
	'Icon', "Mod/LXPER6t/Icons/farfromhome.png",
	'Shown', true,
	'ShownSatelliteView', true,
	'HideOnBadge', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "GCMilitia",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'DisplayName', T(587939415775, --[[ModItemCharacterEffectCompositeDef GCMilitia DisplayName]] "Grand Chien Militia"),
	'Description', T(579526836304, --[[ModItemCharacterEffectCompositeDef GCMilitia Description]] "A perk every militia solider gets after bootcamp. Which allows them to clean and maintain their weapons."),
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaFinances",
	'CodeFileName', "Code/MilitiaFinances.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaInit",
	'CodeFileName', "Code/MilitiaInit.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaManagement",
	'CodeFileName', "Code/MilitiaManagement.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaMovement",
	'CodeFileName', "Code/MilitiaMovement.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPerkEffects",
	'CodeFileName', "Code/MilitiaPerkEffects.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPersonalization",
	'CodeFileName', "Code/MilitiaPersonalization.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaSatelliteConflict",
	'CodeFileName', "Code/MilitiaSatelliteConflict.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaBiosAndNames",
	'CodeFileName', "Code/MilitiaBiosAndNames.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaAndSquads",
	'CodeFileName', "Code/MilitiaAndSquads.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaTraining",
	'CodeFileName', "Code/MilitiaTraining.lua",
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
PlaceObj('ModItemTextStyle', {
	RolloverTextColor = 4291018156,
	TextColor = 4291018156,
	TextFont = T(302983541219, --[[ModItemTextStyle HUDASMALLPDASM TextFont]] "HMGothic Rough A, 10"),
	id = "HUDASMALLPDASM",
}),
PlaceObj('ModItemXTemplate', {
	id = "test",
	PlaceObj('XTemplateWindow', {
		'__class', "XText",
		'Dock', "bottom",
	}),
}),
}
