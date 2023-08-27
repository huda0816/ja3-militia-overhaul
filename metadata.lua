return PlaceObj('ModDef', {
	'title', "GC-Militia / Militia Overhaul mod",
	'description', "While the heroic figures of our mercenaries are often sung about, so are the citizens of Grand Chien, who have made an important contribution to the liberation of your country in the service of the militia. This mod attempts to breathe life into the militia, making them valuable allies to the player.\n\n[b]Overview[/b]\n\n[list]\n[*]Militia squads can be moved\n[*]Militia squads can be managed through squad management\n[*]In combat, militia soldiers are controlled by the player (auto-resolve is still possible)\n[*]Militia soldiers can/must be equipped with weapons and other stuff\n[*]Militia soldiers have names, a hometown and a background story (thanks ChatGPT)\n[*]Militia soldiers have randomized stats and professions\n[*]Militia soldiers have to be paid continuously (additional costs when they are on campaign)\n[*]Especially rookies but on veterans have worse morale when fighting away from home\n[*]Cities lose loyalty when too few soldiers (including mercenaries) are stationed\n[/list]\n\n[b]Known Issues[/b]\n\n[list]\n[*]Please make a backup savegame before activating this mod\n[*]Mod can also be used in existing games and is also uninstallable. Militia will not teleport back, however.\n[*]Although the individual aspects of the mod have been tested very intensively, bugs may occur\n[*]The mod will destroy the balance of the game. Since the “Custom settings” mod has to be installed as a dependency anyway, I recommend to increase the droprate and the size of the enemy squads via this mod\n[*]The mod uses only the existing models and icons (hopefully someone will improve this in the future)\n[/list]\n\n[b]Compatibility with other mods[/b]\n\n[list]\n[*]This mod changes some core functions, but it should not collide with popular mods in general\n[*]Tested with “Custom Settings” squad sizes and militia sizes. (The mod by itself increases the squad size to 8 and also the militia squads are designed for this size)\n[*]Audaki’s UI Enhancements morale description is not correct for militia soldiers at the moment.\n[/list]\n\n[b]Plans for the future[/b]\n\n[list]\n[*]This mod is intended to be a wip and will be developed further. Feel free to post your suggestions.\n[*]In the short term the balancing will be adjusted\n[*]Militia management via a website\n[*]Militia specific operations\n[*]Revision of militia training (By default militia soldiers can’t generate XP and are randomized)\n[*]Militia pools from the cities\n[*]Perks for militia soldiers\n[*]Interactions between mercs and militia\n[*]…\n[/list]\n\n[b]Thank you, thank you, thank you![/b]\n\nWithout the community in the modding Discord and also the support of the developers, this mod would not have been possible. In particular, I would like to thank Audaki, Anarkythera, Tobias, SkunkXL and HG_Feanor for their help.\n\n[b]Credits[/b]\n\nIcon with the house was downloaded from flaticon.com and created by “Freepik\nIcon with the dog was also downloaded from flaticon.com and created by “Vitaly Gorbachev”.\nMilitia bios, names and squad-names were created with ChatGPT and Bard",
	'image', "Mod/LXPER6t/Images/gcmilitia.png",
	'last_changes', "Initial Version",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "hxmY4nT",
			'title', "Custom Settings",
			'version_major', 1,
			'version_minor', 3,
		}),
	},
	'id', "LXPER6t",
	'author', "permanent666",
	'version', 1230,
	'lua_revision', 233360,
	'saved_with_revision', 340446,
	'code', {
		"CharacterEffect/FarFromHome.lua",
		"CharacterEffect/GCMilitia.lua",
		"Code/MilitiaUtils.lua",
		"Code/MilitiaAndSquads.lua",
		"Code/MilitiaBiosAndNames.lua",
		"Code/MilitiaCompat.lua",
		"Code/MilitiaEquipment.lua",
		"Code/MilitiaFinances.lua",
		"Code/MilitiaInit.lua",
		"Code/MilitiaManagement.lua",
		"Code/MilitiaMovement.lua",
		"Code/MilitiaPerkEffects.lua",
		"Code/MilitiaPersonalization.lua",
		"Code/MilitiaSatelliteConflict.lua",
		"Code/MilitiaTraining.lua",
		"Code/MilitiaLoyalty.lua",
	},
	'has_options', true,
	'saved', 1693175071,
	'code_hash', -6604256195016032111,
})