return PlaceObj('ModDef', {
	'title', "GC-Militia / Militia Overhaul mod",
	'description', '[b]Overview[/b]\n\n[list]\n[*]Militia online hub with webshop\n[*]Webshop uses Bobby Rays item configuration\n[*]Militia base building \n[*]New operations\n[*]Changes to militia training\n[*]Enemies can be captured and interrogated\n[*]New logistic operation to transfer or sell items\n[*]Militia squads can be moved\n[*]Militia squads can be managed through squad management\n[*]Militia squads can be renamed\n[*]Militia soldiers have names, a hometown and a background story (thanks ChatGPT)\n[*]Militia soldiers have randomized stats and professions\n[*]Especially rookies but on veterans have worse morale when fighting away from home\n[*]The mod changes the default squad size to 8\n[*]Optional default - In combat, militia soldiers can be controlled by the player (auto-resolve is still possible)\n[*]Optional default - Randomized militia equipment based on the militia soldiers background\n[*]Optional default - Militia soldiers have to be paid continuously (additional costs when they are on campaign)\n[*]Optional default - Cities lose loyalty when too few soldiers (including mercenaries) are stationed\n[/list]\n\n[b]Compatibility with other mods[/b]\n\n[list]\n[*]List will be updated soon\n[/list]\n\n[b]Currently Known Issues[/b]\n[list]\n[*]Testing with 1.5 was limited, so it is possible that there are new unknown bugs\n[*]There can be bugs if the games language is changed. I am not sure if your game has to be on "AUTO" or in english. Still investigating.\n[*]If there is a militia squad at E9 or a militia squad moves to E9 at a certain event it will vanish. It does not break the event as I thought earlier it is just that the event is somehow broken as it only triggers if you defeat everyone at E9\n[*]You can deactivate the mod and your savegame will still work but there is no real uninstall at the moment. I am working on it.\n[*]Please make a backup savegame before activating this mod. Close and restart the game after activation.\n[/list]\n\n[b]Plans for the future[/b]\n\nThis mod is intended to be a wip and will be developed further. Feel free to post your suggestions.\n\n[list]\n[*]Proper backgrounds for militia with special effects\n[*]City policies\n[/list]\n\n[b]Thank you modding Discord and Haemimont![/b]\n\nWithout the community in the modding Discord and also the support of the developers, this mod would not have been possible. In particular, I would like to thank Audaki, Anarkythera, Tobias, SkunkXL and HG_Feanor for their help.\n\n[b]Credits[/b]\n\nIcons downloaded from flaticon.com and created by “Freepik\nIcon with the dog was also downloaded from flaticon.com and created by “Vitaly Gorbachev”.\nMilitia bios, names and squad-names were created with ChatGPT and Bard',
	'image', "Mod/LXPER6t/Images/gcmss2.png",
	'last_changes', "Update 5.7\n\n[list]\n[*]Fixed bug with randomized weapons\n[*]Fixed bug with hyperlinks in emails\n[*]Tried to make mod more translateable\n[/list]",
	'dependencies', {},
	'id', "LXPER6t",
	'author', "permanent666",
	'version_major', 5,
	'version_minor', 7,
	'version', 6868,
	'lua_revision', 233360,
	'saved_with_revision', 350233,
	'code', {
		"CharacterEffect/FarFromHome.lua",
		"CharacterEffect/Captured.lua",
		"CharacterEffect/GCMilitia.lua",
		"CharacterEffect/Capturing.lua",
		"CharacterEffect/BeingCaptured.lua",
		"CharacterEffect/BleedingOut.lua",
		"Code/1Options.lua",
		"Code/XTemplateUtility.lua",
		"Code/MilitiaInventory.lua",
		"Code/MilitiaRandomItems.lua",
		"Code/MilitiaAARGenerator.lua",
		"Code/MilitiaAndSquads.lua",
		"Code/MilitiaBiosAndNames.lua",
		"Code/MilitiaConflictTracker.lua",
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
		"Code/MilitiaPOWInterrogation.lua",
		"Code/MilitiaPerkEffects.lua",
		"Code/MilitiaPersonalization.lua",
		"Code/MilitiaSatelliteConflict.lua",
		"Code/MilitiaShopController.lua",
		"Code/MilitiaShopEmails.lua",
		"Code/MilitiaShopPresets.lua",
		"Code/MilitiaTraining.lua",
		"Code/MilitiaTransfer.lua",
		"Code/MilitiaTransferOR.lua",
		"Code/MilitiaTransferPDA.lua",
		"Code/MilitiaTransferXDrag.lua",
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
		"InventoryItem/HUDA_Zipties.lua",
	},
	'default_options', {
		huda_MilitiaCampaignCosts = "40 (default)",
		huda_MilitiaEliteIncome = "100 (default)",
		huda_MilitiaEquipmentSetting = "Randomized",
		huda_MilitiaItemSlots = "24 (default)",
		huda_MilitiaNoControl = false,
		huda_MilitiaNoDownedEnemies = false,
		huda_MilitiaNoFarFromHome = false,
		huda_MilitiaNoLoyaltyLoss = false,
		huda_MilitiaRepairThreshold = "80 (default)",
		huda_MilitiaRookieIncome = "20 (default)",
		huda_MilitiaShopAllTowns = false,
		huda_MilitiaShopAlwaysOpen = false,
		huda_MilitiaShopDailyRestock = false,
		huda_MilitiaShopInstantShopping = false,
		huda_MilitiaShopPriceMultiplierNew = "100",
		huda_MilitiaShopStockMultiplier = "1",
		huda_MilitiaShopTier = "1",
		huda_MilitiaVeteranIncome = "40 (default)",
	},
	'has_data', true,
	'saved', 1713018019,
	'code_hash', 940428672095980415,
	'affected_resources', {
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "FarFromHome",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "Captured",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "GCMilitia",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "Capturing",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "BeingCaptured",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "CharacterEffectCompositeDef",
			'Id', "BleedingOut",
			'ClassDisplayName', "Character effect",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "ConstDef",
			'Id', "ConflictRetreatPenalty",
			'ClassDisplayName', "Constant",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "InventoryItemCompositeDef",
			'Id', "HUDA_Zipties",
			'ClassDisplayName', "Inventory item",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "MsgDef",
			'Id', "HUDAMilitiaPromoted",
			'ClassDisplayName', "Message definition",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "MsgDef",
			'Id', "HUDAMilitaShopBeforeInit",
			'ClassDisplayName', "Message definition",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "MsgDef",
			'Id', "HUDAMilitaShopBeforeRestock",
			'ClassDisplayName', "Message definition",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "HUDA_MilitiaBase",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "HUDA_MilitiaHumanitarianAid",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "HUDA_MilitiaRecruitmentDrive",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "HUDA_MilitiaInterrogation",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "MilitiaTraining",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "SectorOperation",
			'Id', "HUDA_MilitiaSellItems",
			'ClassDisplayName', "Sector operation",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "TextStyle",
			'Id', "HUDASMALLPDASM",
			'ClassDisplayName', "Text style",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "TextStyle",
			'Id', "HUDAProductOutOfStock",
			'ClassDisplayName', "Text style",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "TextStyle",
			'Id', "PDAMilitiaShopCouponCode",
			'ClassDisplayName', "Text style",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "TextStyle",
			'Id', "PDAMilitiaShopCouponCodeValid",
			'ClassDisplayName', "Text style",
		}),
	},
	'steam_id', "3027227786",
	'TagBalancing&Difficulty', true,
	'TagSatview&Operations', true,
})