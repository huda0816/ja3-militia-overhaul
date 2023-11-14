return PlaceObj('ModDef', {
	'title', "GC-Militia / Militia Overhaul mod",
	'description', 'Tested with 1.3\nCurrent Version: 3.3\n\nNew 3.0 features:\n\nThere is a new operation "Build militia base" which\n\n[list]\n[*]Is a supply hub for your militia (Lower upkeep costs)\n[*]Lowers training costs\n[*]Enables two new operations described below\n[/list]\n\nFrom now on militia does not spawn from thin air but has to be recruited from a limited pool. Loyalty and a militia popularity factor are cruical to find new recruits.\n\nHow to gain and loose Popularity\n[list]\n[*]You will loose 1% popularity each day.\n[*]If you gain loyalty in the city you also gain popularity\n[*]Globally winning battles will increse poularity (Loosing will decrease popularity)\n[*]Loyalty influences the number of available recruits\n[*]There is a new operation "Recruitment drive" wich will increase popularity (and give instantly new recruits based on Leadership)\n[*](If a militia unit dies you will loose popularity in it\'s hometown <- does not work at the moment)\n[/list]\n\nChanges to Loyalty:\n[list]\n[*]You now longer loose loyalty if there are not enough militia soldiers if your loyalty is below 30%\n[*]You will gain loyalty if you train militia\n[*]Loyalty influences the number of available recruits\n[*]There is a new operation "Humanitarian aid" which will increase loyality\n[/list]\n\n[b]Currently Known Issues[/b]\n[list]\n[*]Testing with 1.3 was limited, so it is possible that there are new unknown bugs\n[*]There can be bugs if the games language is changed. I am not sure if your game has to be on "AUTO" or in english. Still investigating.\n[*]If there is a militia squad at E9 or a militia squad moves to E9 at a certain event it will vanish. It does not break the event as I thought earlier it is just that the event is somehow broken as it only triggers if you defeat everyone at E9\n[*]You can deactivate the mod and your savegame will still work but there is no real uninstall at the moment. I am working on it.\n[*]Please make a backup savegame before activating this mod. Close and restart the game after activation.\n[/list]\n\n[b]Overview[/b]\n\n[list]\n[*]Militia online hub with webshop\n[*]Militia base building \n[*]New operations\n[*]Changes to militia training\n[*]Militia squads can be moved\n[*]Militia squads can be managed through squad management\n[*]Militia squads can be renamed\n[*]Militia soldiers have names, a hometown and a background story (thanks ChatGPT)\n[*]Militia soldiers have randomized stats and professions\n[*]Especially rookies but on veterans have worse morale when fighting away from home\n[*]The mod changes the default squad size to 8\n[*]Optional default - In combat, militia soldiers can be controlled by the player (auto-resolve is still possible)\n[*]Optional default - Militia soldiers must be equipped with weapons and other stuff\n[*]Optional default - Militia soldiers have to be paid continuously (additional costs when they are on campaign)\n[*]Optional default - Cities lose loyalty when too few soldiers (including mercenaries) are stationed\n[/list]\n\n[b]Compatibility with other mods[/b]\n\n[list]\n[*]This mod changes some core functions, but it should not collide with popular mods in general\n[*]Tested with “Custom Settings” squad sizes and militia sizes. (The mod by itself increases the squad size to 8 and also the militia squads are designed for this size)\n[*]Audaki’s UI Enhancements morale description is not correct for militia soldiers at the moment.\n[/list]\n\n[b]Plans for the future[/b]\n\nThis mod is intended to be a wip and will be developed further. Feel free to post your suggestions.\n\n[list]\n[*]Capturing enemy soldiers as POWs\n[*]Revision of militia training (By default militia soldiers can’t generate XP and are randomized)\n[*]Individual Loyalty\n[*]Perks for militia soldiers\n[*]…\n[/list]\n\nTrello: https://trello.com/b/GKYG4MlF/grand-chien-militia\n\n[b]Thank you modding Discord and Haemimont![/b]\n\nWithout the community in the modding Discord and also the support of the developers, this mod would not have been possible. In particular, I would like to thank Audaki, Anarkythera, Tobias, SkunkXL and HG_Feanor for their help.\n\n[b]Credits[/b]\n\nIcon with the house was downloaded from flaticon.com and created by “Freepik\nIcon with the dog was also downloaded from flaticon.com and created by “Vitaly Gorbachev”.\nMilitia bios, names and squad-names were created with ChatGPT and Bard',
	'image', "Mod/LXPER6t/Images/gcmss2.png",
	'last_changes', "Update 3.3\n\n[list]\n[*]Made militia base persistant between reloads\n[/list]",
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
	'version_major', 3,
	'version_minor', 3,
	'version', 5690,
	'lua_revision', 233360,
	'saved_with_revision', 345543,
	'code', {
		"CharacterEffect/FarFromHome.lua",
		"CharacterEffect/Captured.lua",
		"CharacterEffect/GCMilitia.lua",
		"CharacterEffect/Capturing.lua",
		"CharacterEffect/BeingCaptured.lua",
		"Code/1Options.lua",
		"Code/MilitiaAARGenerator.lua",
		"Code/MilitiaAndSquads.lua",
		"Code/MilitiaBiosAndNames.lua",
		"Code/MilitiaCompat.lua",
		"Code/MilitiaConflictTracker.lua",
		"Code/MilitiaEquipment.lua",
		"Code/MilitiaFinances.lua",
		"Code/MilitiaInit.lua",
		"Code/MilitiaLoyalty.lua",
		"Code/MilitiaManagement.lua",
		"Code/MilitiaMovement.lua",
		"Code/MilitiaNewsController.lua",
		"Code/MilitiaOperations.lua",
		"Code/MilitiaOverrides.lua",
		"Code/MilitiaPDA.lua",
		"Code/MilitiaPOIs.lua",
		"Code/MilitiaPOW.lua",
		"Code/MilitiaPerkEffects.lua",
		"Code/MilitiaPersonalization.lua",
		"Code/MilitiaSatelliteConflict.lua",
		"Code/MilitiaShopController.lua",
		"Code/MilitiaShopEmails.lua",
		"Code/MilitiaShopPresets.lua",
		"Code/MilitiaTraining.lua",
		"Code/MilitiaTutorial.lua",
		"Code/MilitiaUtils.lua",
		"Code/PDAMilitaShopTrick.lua",
		"Code/PDAMilitia.lua",
		"Code/PDAMilitiaAAR.lua",
		"Code/PDAMilitiaAmmoNav.lua",
		"Code/PDAMilitiaConstruction.lua",
		"Code/PDAMilitiaFinances.lua",
		"Code/PDAMilitiaHome.lua",
		"Code/PDAMilitiaHyperlinkHeader.lua",
		"Code/PDAMilitiaPrisonPicker.lua",
		"Code/PDAMilitiaShop.lua",
		"Code/PDAMilitiaShopAddress.lua",
		"Code/PDAMilitiaShopAddressPicker.lua",
		"Code/PDAMilitiaShopCart.lua",
		"Code/PDAMilitiaShopList.lua",
		"Code/PDAMilitiaShopNav.lua",
		"Code/PDAMilitiaShopOrder.lua",
		"Code/PDAMilitiaShopOrders.lua",
		"Code/PDAMilitiaShopProduct.lua",
		"Code/PDAMilitiaShopUnavailable.lua",
		"Code/PDAMilitiaSidebarBattle.lua",
		"Code/PDAMilitiaSidebarNewbies.lua",
		"Code/PDAMilitiaSidebarPromotions.lua",
		"Code/PDAMilitiaSidebarRIP.lua",
		"Code/PDAMilitiaSoldier.lua",
		"Code/PDAMilitiaSquad.lua",
		"Code/PDAMilitiaSquads.lua",
		"Code/POPUPMilitiaPOWInterrogation.lua",
		"Code/PeopleController.lua",
		"Code/MilitiaPOWInterrogation.lua",
		"InventoryItem/HUDA_Zipties.lua",
	},
	'has_options', true,
	'saved', 1699923547,
	'code_hash', 4985829924312741389,
	'steam_id', "3027227786",
})