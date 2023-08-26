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
	'name', "Init",
	'CodeFileName', "Code/Init.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Personalization",
	'CodeFileName', "Code/Personalization.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Finances",
	'CodeFileName', "Code/Finances.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaManagement",
	'CodeFileName', "Code/MilitiaManagement.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Movement",
	'CodeFileName', "Code/Movement.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PerkEffects",
	'CodeFileName', "Code/PerkEffects.lua",
}),
PlaceObj('ModItemCode', {
	'name', "SatelliteConflict",
	'CodeFileName', "Code/SatelliteConflict.lua",
}),
PlaceObj('ModItemCode', {
	'name', "SquadsAndMilitia",
	'CodeFileName', "Code/SquadsAndMilitia.lua",
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
