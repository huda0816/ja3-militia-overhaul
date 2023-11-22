return {
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "FarFromHome",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'Conditions', {},
	'Modifiers', {},
	'DisplayName', T(479710184445, --[[ModItemCharacterEffectCompositeDef FarFromHome DisplayName]] "Far From Home"),
	'Description', T(589914191202, --[[ModItemCharacterEffectCompositeDef FarFromHome Description]] "Militia soldiers who fight too far from their hometown, especially rookies, face various negative effects such as loss of morale."),
	'type', "Debuff",
	'Icon', "Mod/LXPER6t/Icons/farfromhome.png",
	'Shown', true,
	'ShownSatelliteView', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "Captured",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'Conditions', {},
	'Modifiers', {},
	'DisplayName', T(391335563250, --[[ModItemCharacterEffectCompositeDef Captured DisplayName]] "Captured"),
	'Description', T(974882876317, --[[ModItemCharacterEffectCompositeDef Captured Description]] "This soldier was captured an will be treated as POW after the conflict ends."),
	'AddEffectText', T(499266233002, --[[ModItemCharacterEffectCompositeDef Captured AddEffectText]] "Captured"),
	'OnAdded', GetMissingSourceFallback(),
	'type', "Debuff",
	'Icon', "Mod/LXPER6t/Icons/captured.png",
	'Shown', true,
	'ShownSatelliteView', true,
	'HasFloatingText', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "GCMilitia",
	'object_class', "CharacterEffect",
	'msg_reactions', {},
	'DisplayName', T(639680942517, --[[ModItemCharacterEffectCompositeDef GCMilitia DisplayName]] "Grand Chien Militia"),
	'Description', T(468935194750, --[[ModItemCharacterEffectCompositeDef GCMilitia Description]] "A perk every militia solider gets after bootcamp. Which allows them to clean and maintain their weapons."),
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Group', "System",
	'Id', "Capturing",
	'object_class', "StatusEffect",
	'unit_reactions', {
		PlaceObj('UnitReaction', {
			Event = "OnBeginTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:CapturingBeginTurn(self, target)
			end,
			param_bindings = false,
		}),
		PlaceObj('UnitReaction', {
			Event = "OnEndTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:CapturingEndTurn(self, target)
			end,
			param_bindings = false,
		}),
	},
	'DisplayName', T(124552607340, --[[ModItemCharacterEffectCompositeDef Capturing DisplayName]] "Capturing"),
	'Description', T(437350905663, --[[ModItemCharacterEffectCompositeDef Capturing Description]] "Capturing a downed or unconscious enemy. No more actions available this turn."),
	'AddEffectText', T(147219111219, --[[ModItemCharacterEffectCompositeDef Capturing AddEffectText]] "Capturing"),
	'OnAdded', function (self, obj)
		HUDA_MilitiaPOW:CapturingOnAdded(self, obj)
	end,
	'OnRemoved', function (self, obj)
		HUDA_MilitiaPOW:CapturingOnRemoved(self, obj)
	end,
	'Icon', "Mod/LXPER6t/Icons/capture.png",
	'RemoveOnSatViewTravel', true,
	'Shown', true,
	'HasFloatingText', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Group', "System",
	'Id', "BeingCaptured",
	'object_class', "StatusEffect",
	'Icon', "Mod/LXPER6t/Icons/capture.png",
	'RemoveOnSatViewTravel', true,
}),
PlaceObj('ModItemCharacterEffectCompositeDef', {
	'Id', "BleedingOut",
	'Parameters', {
		PlaceObj('PresetParamNumber', {
			'Name', "add_penalty",
			'Value', -15,
			'Tag', "<add_penalty>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "add_initial_bonus",
			'Value', 100,
			'Tag', "<add_initial_bonus>",
		}),
	},
	'object_class', "CharacterEffect",
	'unit_reactions', {
		PlaceObj('UnitReaction', {
			Event = "OnEndTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:HandleBleedingOut(self,target)
			end,
			param_bindings = false,
		}),
	},
	'Conditions', {
		PlaceObj('CombatIsActive', {
			param_bindings = false,
		}),
	},
	'DisplayName', T(362679879722, --[[ModItemCharacterEffectCompositeDef BleedingOut DisplayName]] "Downed"),
	'Description', T(151977344401, --[[ModItemCharacterEffectCompositeDef BleedingOut Description]] "This character is in <color EmStyle>Critical condition</color> and will bleed out unless treated with the <color EmStyle>Bandage</color> action or gets <color EmStyle>Captured</color>. The character remains alive if a successful check against Health is made next turn."),
	'OnAdded', function (self, obj)  end,
	'Icon', "UI/Hud/Status effects/bleedingout",
	'Shown', true,
}),
PlaceObj('ModItemCode', {
	'name', "1Options",
	'CodeFileName', "Code/1Options.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaAARGenerator",
	'CodeFileName', "Code/MilitiaAARGenerator.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaAndSquads",
	'CodeFileName', "Code/MilitiaAndSquads.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaBiosAndNames",
	'CodeFileName', "Code/MilitiaBiosAndNames.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaCompat",
	'CodeFileName', "Code/MilitiaCompat.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaConflictTracker",
	'CodeFileName', "Code/MilitiaConflictTracker.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaEquipment",
	'CodeFileName', "Code/MilitiaEquipment.lua",
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
	'name', "MilitiaLoyalty",
	'CodeFileName', "Code/MilitiaLoyalty.lua",
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
	'name', "MilitiaNewsController",
	'CodeFileName', "Code/MilitiaNewsController.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaOperations",
	'CodeFileName', "Code/MilitiaOperations.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaOverrides",
	'CodeFileName', "Code/MilitiaOverrides.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPDA",
	'CodeFileName', "Code/MilitiaPDA.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPOIs",
	'CodeFileName', "Code/MilitiaPOIs.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPOW",
	'CodeFileName', "Code/MilitiaPOW.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaPOWInterrogation",
	'CodeFileName', "Code/MilitiaPOWInterrogation.lua",
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
	'name', "MilitiaShopController",
	'CodeFileName', "Code/MilitiaShopController.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaShopEmails",
	'CodeFileName', "Code/MilitiaShopEmails.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaShopPresets",
	'CodeFileName', "Code/MilitiaShopPresets.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaTraining",
	'CodeFileName', "Code/MilitiaTraining.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaTutorial",
	'CodeFileName', "Code/MilitiaTutorial.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaUtils",
	'CodeFileName', "Code/MilitiaUtils.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitaShopTrick",
	'CodeFileName', "Code/PDAMilitaShopTrick.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitia",
	'CodeFileName', "Code/PDAMilitia.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaAAR",
	'CodeFileName', "Code/PDAMilitiaAAR.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaAmmoNav",
	'CodeFileName', "Code/PDAMilitiaAmmoNav.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaConstruction",
	'CodeFileName', "Code/PDAMilitiaConstruction.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaFinances",
	'CodeFileName', "Code/PDAMilitiaFinances.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaHome",
	'CodeFileName', "Code/PDAMilitiaHome.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaHyperlinkHeader",
	'CodeFileName', "Code/PDAMilitiaHyperlinkHeader.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaPrisonPicker",
	'CodeFileName', "Code/PDAMilitiaPrisonPicker.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShop",
	'CodeFileName', "Code/PDAMilitiaShop.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopAddress",
	'CodeFileName', "Code/PDAMilitiaShopAddress.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopAddressPicker",
	'CodeFileName', "Code/PDAMilitiaShopAddressPicker.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopCart",
	'CodeFileName', "Code/PDAMilitiaShopCart.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopList",
	'CodeFileName', "Code/PDAMilitiaShopList.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopNav",
	'CodeFileName', "Code/PDAMilitiaShopNav.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopOrder",
	'CodeFileName', "Code/PDAMilitiaShopOrder.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopOrders",
	'CodeFileName', "Code/PDAMilitiaShopOrders.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopProduct",
	'CodeFileName', "Code/PDAMilitiaShopProduct.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaShopUnavailable",
	'CodeFileName', "Code/PDAMilitiaShopUnavailable.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSidebarBattle",
	'CodeFileName', "Code/PDAMilitiaSidebarBattle.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSidebarNewbies",
	'CodeFileName', "Code/PDAMilitiaSidebarNewbies.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSidebarPromotions",
	'CodeFileName', "Code/PDAMilitiaSidebarPromotions.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSidebarRIP",
	'CodeFileName', "Code/PDAMilitiaSidebarRIP.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSoldier",
	'CodeFileName', "Code/PDAMilitiaSoldier.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSquad",
	'CodeFileName', "Code/PDAMilitiaSquad.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PDAMilitiaSquads",
	'CodeFileName', "Code/PDAMilitiaSquads.lua",
}),
PlaceObj('ModItemCode', {
	'name', "POPUPMilitiaPOWInterrogation",
	'CodeFileName', "Code/POPUPMilitiaPOWInterrogation.lua",
}),
PlaceObj('ModItemCode', {
	'name', "PeopleController",
	'CodeFileName', "Code/PeopleController.lua",
}),
PlaceObj('ModItemCode', {
	'name', "MilitiaItemsSale",
	'CodeFileName', "Code/MilitiaItemsSale.lua",
}),
PlaceObj('ModItemConstDef', {
	group = "Loyalty",
	id = "ConflictRetreatPenalty",
	value = -5,
}),
PlaceObj('ModItemInventoryItemCompositeDef', {
	'Group', "Other - Tools",
	'Id', "HUDA_Zipties",
	'object_class', "MiscItem",
	'ScrapParts', 1,
	'Repairable', false,
	'Icon', "Mod/LXPER6t/Icons/zipties.png",
	'DisplayName', T(187743445065, --[[ModItemInventoryItemCompositeDef HUDA_Zipties DisplayName]] "Zip ties"),
	'DisplayNamePlural', T(405053988640, --[[ModItemInventoryItemCompositeDef HUDA_Zipties DisplayNamePlural]] "Zip ties"),
	'AdditionalHint', T(410307956607, --[[ModItemInventoryItemCompositeDef HUDA_Zipties AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Are used to capture downed or unconscious enemies \n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Can be used 10 times\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Used automatically from the Inventory"),
	'UnitStat', "Dexterity",
	'Cost', 300,
	'CanAppearInShop', true,
	'RestockWeight', 150,
	'APCost', 4,
}),
PlaceObj('ModItemMsgDef', {
	Description = "When a militia soldier gets promoted",
	Params = "unit, oldid",
	comment = "Fires after militia got promoted",
	id = "HUDAMilitiaPromoted",
}),
PlaceObj('ModItemMsgDef', {
	Description = "Before the shop gets initialized",
	group = "Msg",
	id = "HUDAMilitaShopBeforeInit",
}),
PlaceObj('ModItemMsgDef', {
	Description = "Before a shop restocks",
	group = "Msg",
	id = "HUDAMilitaShopBeforeRestock",
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaCampaignCosts",
	'DisplayName', "Aditional costs when on campaign",
	'Help', "per 20hours of supply travel time",
	'DefaultValue', "40",
	'ChoiceList', {
		"0",
		"10",
		"20",
		"30",
		"40",
		"50",
		"60",
		"70",
		"80",
		"90",
		"100",
		"110",
		"120",
		"130",
		"140",
		"150",
		"160",
		"170",
		"180",
		"190",
		"200",
		"210",
		"220",
		"230",
		"240",
		"250",
		"260",
		"270",
		"280",
		"290",
		"300",
		"310",
		"320",
		"330",
		"340",
		"350",
		"360",
		"370",
		"380",
		"390",
		"400",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaEliteIncome",
	'DisplayName', "Daily Upkeep Elite",
	'DefaultValue', "100",
	'ChoiceList', {
		"0",
		"10",
		"20",
		"30",
		"40",
		"50",
		"60",
		"70",
		"80",
		"90",
		"100",
		"110",
		"120",
		"130",
		"140",
		"150",
		"160",
		"170",
		"180",
		"190",
		"200",
		"210",
		"220",
		"230",
		"240",
		"250",
		"260",
		"270",
		"280",
		"290",
		"300",
		"310",
		"320",
		"330",
		"340",
		"350",
		"360",
		"370",
		"380",
		"390",
		"400",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaRepairThreshold",
	'DisplayName', "Maximum repair item percentage",
	'Help', "Maximum percentage militia can repair items on their own. Setting the value to 0 can also improve performance",
	'DefaultValue', "80",
	'ChoiceList', {
		"0",
		"10",
		"20",
		"30",
		"40",
		"50",
		"60",
		"70",
		"80",
		"90",
		"100",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaRookieIncome",
	'DisplayName', "Daily Upkeep Rookie",
	'DefaultValue', "20",
	'ChoiceList', {
		"0",
		"10",
		"20",
		"30",
		"40",
		"50",
		"60",
		"70",
		"80",
		"90",
		"100",
		"110",
		"120",
		"130",
		"140",
		"150",
		"160",
		"170",
		"180",
		"190",
		"200",
		"210",
		"220",
		"230",
		"240",
		"250",
		"260",
		"270",
		"280",
		"290",
		"300",
		"310",
		"320",
		"330",
		"340",
		"350",
		"360",
		"370",
		"380",
		"390",
		"400",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaShopPriceMultiplier",
	'DisplayName', "Shop: Multiplier for Items in the Staff Shop",
	'DefaultValue', "1",
	'ChoiceList', {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"10",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaShopStockMultiplier",
	'DisplayName', "Shop: Multiplies the default stock values",
	'DefaultValue', "1",
	'ChoiceList', {
		"1",
		"2",
		"3",
		"4",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaShopTier",
	'DisplayName', "Shop: Current tier",
	'Help', "Higher tier means better stuff",
	'DefaultValue', "1",
	'ChoiceList', {
		"1",
		"2",
		"3",
		"4",
		"5",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "huda_MilitiaVeteranIncome",
	'DisplayName', "Daily Upkeep Veteran",
	'DefaultValue', "40",
	'ChoiceList', {
		"0",
		"10",
		"20",
		"30",
		"40",
		"50",
		"60",
		"70",
		"80",
		"90",
		"100",
		"110",
		"120",
		"130",
		"140",
		"150",
		"160",
		"170",
		"180",
		"190",
		"200",
		"210",
		"220",
		"230",
		"240",
		"250",
		"260",
		"270",
		"280",
		"290",
		"300",
		"310",
		"320",
		"330",
		"340",
		"350",
		"360",
		"370",
		"380",
		"390",
		"400",
	},
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaNoControl",
	'DisplayName', "Experimental: Militia fights on its own",
	'Help', "Restart or Game (not Campaign) required. If this option is selected you will not control militia in battle and cannot fight offensively with militia squads.",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaNoDownedEnemies",
	'DisplayName', "Deactivate the downing of enemies and militia",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaNoFarFromHome",
	'DisplayName', 'Deactivate "Far from home" Character effect',
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaNoLoyaltyLoss",
	'DisplayName', "No loyalty loss in towns with not enough militia",
	'Help', "If this option is selected militia won't impact loyalty",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaShopAllTowns",
	'DisplayName', "Shop: Ship to all towns",
	'Help', "Ships to all player controlled towns",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaShopAlwaysOpen",
	'DisplayName', "Shop: Always open",
	'Help', "Shop stays open even if Ernie is lost.",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaShopDailyRestock",
	'DisplayName', "Shop: Gets restocked daily",
	'Help', "No randomness",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_MilitiaShopInstantShopping",
	'DisplayName', "Shop: Instant Shopping",
	'Help', "Gear arrives without delivery time",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "huda_militiaNoWeapons",
	'DisplayName', "Militia spawns without weapons",
	'DefaultValue', true,
}),
PlaceObj('ModItemSectorOperation', {
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
					self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		if next(merc_names) then
			CombatLog("important", T{352089713704, "<em><mercs></em> finished <em><activity></em> in <SectorName(sector)>", mercs = ConcatListWithAnd(merc_names),activity = self.display_name, sector = sector})
		end
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetOperationCost = function (self, merc, profession, idx)
		local sector = merc:GetSector()
		
		local loyalty = sector and GetCityLoyalty(sector.City) or 0
		
		local baseCost = 2000
		
		local variableCosts = MulDivRound(1000, 100 - loyalty, 100)
		
		local cost = baseCost + variableCosts
		
		if HasPerk(merc, "Negotiator") then
			local discount = CharacterEffectDefs.Negotiator:ResolveValue("discountPercent")
			cost = cost - MulDivRound(cost, discount, 100)
		end
		
		return {[1] = {value = cost, resource = "Money"}}
	end,
	GetSectorSlots = function (self, prof, sector)
		return 1
	end,
	GetTimelineEventDescription = GetMissingSourceFallback(),
	HasOperation = function (self, sector)
		local cityId = sector.City
		
		if not cityId or cityId == "none" then
			return false
		end
		
		local sectors = GetCitySectors(cityId)
		
		for i, sector in ipairs(sectors) do
			local sector = gv_Sectors[sector]
			
			if sector and sector.MilitiaBase then
				return false
			end
		end
		
		return true
	end,
	IsEnabled = function (self, sector)
		if HUDA_MilitiaOperations:HasOngoingOperation(self.id, sector) then
			return false, T{0818764949488129, "There is an ongoing operation of the same kind in this city"}	
		end
		
		local mercs_available = GetAvailableMercs(sector, self, "Baseconstructor")
		local mercs_current = GetOperationProfessionals(sector.Id,"Baseconstructor")
		if #mercs_available == 0 and #mercs_current == 0 then
				return false, T(4492052589120815, "No mercs with enough mechanical skills available (min. 20)")
		end
		
		return true
	end,
	ModifyProgress = function (self, value, sector)
		local ac = sector.custom_operations and sector.custom_operations[self.id]
		if ac then
			ac.progress = ac.progress + value
		end
	end,
	OnComplete = function (self, sector, mercs)
		local ca = sector.custom_operations[self.id]
		ca.progress = 0
		sector.custom_operations[self.id]  = nil
		sector.MilitiaBase = true
		g_SatelliteUI:UpdateSectorVisuals(sector.Id)
	end,
	OnSetOperation = function (self, merc, arg)
		local sector = merc:GetSector()
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = sector.custom_operations[self.id] or {progress = 0}
	end,
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Baseconstructor",
			'display_name', T(830204262674, --[[ModItemSectorOperation HUDA_MilitiaBase display_name]] "Constructing merc"),
			'description', T(841149831422, --[[ModItemSectorOperation HUDA_MilitiaBase description]] "The assigned Mercs are constructing a militia base"),
			'display_name_all_caps', T(273152604751, --[[ModItemSectorOperation HUDA_MilitiaBase display_name_all_caps]] "CONSTRUCTING MERC"),
			'display_name_plural', T(217204946425, --[[ModItemSectorOperation HUDA_MilitiaBase display_name_plural]] "Constructing mercs"),
			'display_name_plural_all_caps', T(822643120671, --[[ModItemSectorOperation HUDA_MilitiaBase display_name_plural_all_caps]] "CONSTRUCTING MERCS"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc, sector, prediction)
		return self.target_contribution
	end,
	ProgressCurrent = function (self, merc, sector, prediction)
		return sector.custom_operations and sector.custom_operations[self.id] and sector.custom_operations[self.id].progress or -1
	end,
	ProgressPerTick = function (self, merc, prediction)
		local _, val = self:GetRelatedStat(merc)
		local sector = merc:GetSector()
		local militia_id = sector.militia_squad_id
		local militia = 0
		
		if militia_id then
			local squad = gv_Squads[militia_id]
			if squad then
		   	militia = #squad.units
			end
		end
		
		return 20 + val/2 + Min(60 , militia * 15)
	end,
	RequiredResources = {
		"Money",
	},
	SectorMercsTick = GetMissingSourceFallback(),
	ShowInCombatBadge = false,
	SortKey = 35,
	Tick = function (self, merc)
		local sector = merc:GetSector()
					local progress_per_tick = self:ProgressPerTick(merc)
					if CheatEnabled("FastActivity") then
						progress_per_tick = progress_per_tick*100
					end
					self:ModifyProgress(progress_per_tick, sector)
					self:CheckCompleted(merc, sector)
	end,
	description = T(737414284013, --[[ModItemSectorOperation HUDA_MilitiaBase description]] "Build a Militia Base as supply hub for local militia and to enable additional operations in this city. Additionally it will enable you to order equipment from the I.M.P.M.S.S to this location. Having militia in this sector will reduce build time."),
	display_name = T(534350386428, --[[ModItemSectorOperation HUDA_MilitiaBase display_name]] "Build Militia Base"),
	icon = "Mod/LXPER6t/Images/mb_operation.png",
	id = "HUDA_MilitiaBase",
	image = "Mod/LXPER6t/Images/Screenshot0006 3.png",
	log_msg_start = T(304526445261, --[[ModItemSectorOperation HUDA_MilitiaBase log_msg_start]] "<color EmStyle><mercs></color> started <color EmStyle>construction</color> in "),
	min_requirement_stat = "Mechanical",
	min_requirement_stat_value = 20,
	related_stat = "Mechanical",
	short_name = T(752099215233, --[[ModItemSectorOperation HUDA_MilitiaBase short_name]] "Militia Base"),
	sub_title = T(483625519754, --[[ModItemSectorOperation HUDA_MilitiaBase sub_title]] "Build a militia base in this city"),
	target_contribution = 5600,
}),
PlaceObj('ModItemSectorOperation', {
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
					self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetOperationCost = function (self, merc, profession, idx)
		return {[1] = {value = 2000, resource = "Money"}, [2] = {value = 20, resource = "Meds"}}
	end,
	GetSectorSlots = function (self, prof, sector)
		return 1
	end,
	GetTimelineEventDescription = GetMissingSourceFallback(),
	HasOperation = function (self, sector)
		local cityId = sector.City
		
		if not cityId then
			return false
		end
		
		local sectors = GetCitySectors(cityId)
		
		for i, sector in ipairs(sectors) do
			local sector = gv_Sectors[sector]
			
			if sector and sector.MilitiaBase then
				return true
			end
		end
		
		return false
	end,
	IsEnabled = function (self, sector)
		if HUDA_MilitiaOperations:HasOngoingOperation(self.id, sector) then
			return false, T{0818764949488129, "There is an ongoing operation of the same kind in this city"}	
		end
		
		local mercs_available = GetAvailableMercs(sector, self, "Humanitarianworker")
		local mercs_current = GetOperationProfessionals(sector.Id,"Humanitarianworker")
		if #mercs_available == 0 and #mercs_current == 0 then
				return false, T(449205258912, "No mercs with enough medical skills available")
		end
		
		local hasCooldown, timeLeft = HUDA_MilitiaOperations:HasCooldown(self.id, sector)
		
		if not hasCooldown then 
		    return true
		else
			return false, T{0818764949488129, "You have to wait <hours> hours until you can restart the operation", hours = timeLeft}
		end
	end,
	ModifyProgress = function (self, value, sector)
		local ac = sector.custom_operations and sector.custom_operations[self.id]
		if ac then
			ac.progress = ac.progress + value
		end
	end,
	OnComplete = function (self, sector, mercs)
		sector.custom_operations[self.id]  = nil
		
		local merc = mercs[1]
		
		local loyalty = GetCityLoyalty(sector.City) or 0
		
		local maxLoyaltyGain = 10
		
		local newLoyalty = 2 + MulDivRound(6, 100 - loyalty, 100)
		
		CityModifyLoyalty(sector.City, newLoyalty)
		CombatLog("important", T{3520897137040815, "<em><merc></em> finished <em>humanitarian aid</em> in <SectorName(sector)>. Loyalty increased by <loyalty>% in <city>", merc = merc.Nick, sector = sector, city = sector.City, loyalty = newLoyalty})
		
		HUDA_MilitiaOperations:SetCooldown(self.id,sector,48)
	end,
	OnRemoveOperation = function (self, merc)
		local sector = merc:GetSector()
		
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = nil
		
		HUDA_MilitiaOperations:SetOngoingOperation(self.id, sector, false)
	end,
	OnSetOperation = function (self, merc, arg)
		local sector = merc:GetSector()
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = sector.custom_operations[self.id] or {progress = 0}
		
		HUDA_MilitiaOperations:SetOngoingOperation(self.id, sector, true)
	end,
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Humanitarianworker",
			'display_name', T(353007867615, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid display_name]] "Humanitarian aid worker"),
			'description', T(526067066400, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid description]] "The assigned Mercs is organizing humanitarian aid"),
			'display_name_all_caps', T(267497388928, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid display_name_all_caps]] "HUMANITARIAN AID WORKER"),
			'display_name_plural', T(614302646615, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid display_name_plural]] "Humanitarian aid workers"),
			'display_name_plural_all_caps', T(273430019688, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid display_name_plural_all_caps]] "HUMANITARIAN AID WORKERS"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc, sector, prediction)
		return self.target_contribution
	end,
	ProgressCurrent = function (self, merc, sector, prediction)
		return sector.custom_operations and sector.custom_operations[self.id] and sector.custom_operations[self.id].progress or 0
	end,
	ProgressPerTick = function (self, merc, prediction)
		local sector = merc:GetSector()
		local militia_id = sector.militia_squad_id
		local militia = 0
		
		if militia_id then
			local squad = gv_Squads[militia_id]
			if squad then
		   	militia = #squad.units
			end
		end
		
		return 100 + Min(60 , militia * 15)
	end,
	RequiredResources = {
		"Money",
		"Meds",
	},
	SectorMercsTick = GetMissingSourceFallback(),
	ShowInCombatBadge = false,
	SortKey = 35,
	Tick = function (self, merc)
		local sector = merc:GetSector()
					local progress_per_tick = self:ProgressPerTick(merc)
					if CheatEnabled("FastActivity") then
						progress_per_tick = progress_per_tick*100
					end
					self:ModifyProgress(progress_per_tick, sector)
					self:CheckCompleted(merc, sector)
	end,
	description = T(249717759210, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid description]] "Support the local population with food and medical care. This action will increase the loyalty in this town. It takes less time if you have militia soldiers in this sector. The effectiveness is decreased if loyalty is already high."),
	display_name = T(336873968455, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid display_name]] "Humanitarian Aid"),
	icon = "Mod/LXPER6t/Images/mb_operation.png",
	id = "HUDA_MilitiaHumanitarianAid",
	image = "Mod/LXPER6t/Images/Screenshot0007 2.png",
	log_msg_start = T(979850606998, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid log_msg_start]] "<color EmStyle><mercs></color> started <color EmStyle>humanitarian aid</color> in "),
	min_requirement_stat = "Medical",
	min_requirement_stat_value = 50,
	related_stat = "Medical",
	short_name = T(453922818934, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid short_name]] "Humanitarian Aid"),
	sub_title = T(883497354414, --[[ModItemSectorOperation HUDA_MilitiaHumanitarianAid sub_title]] "Support the local population with food and medical care"),
	target_contribution = 4000,
}),
PlaceObj('ModItemSectorOperation', {
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
					self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetOperationCost = function (self, merc, profession, idx)
		local cost = 500
		
		if HasPerk(merc, "Negotiator") then
			local discount = CharacterEffectDefs.Negotiator:ResolveValue("discountPercent")
			cost = cost - MulDivRound(cost, discount, 100)
		end
		
		return {[1] = {value = cost, resource = "Money"}}
	end,
	GetSectorSlots = function (self, prof, sector)
		return 1
	end,
	GetTimelineEventDescription = GetMissingSourceFallback(),
	HasOperation = function (self, sector)
		local cityId = sector.City
		
		if not cityId then
			return false
		end
		
		local sectors = GetCitySectors(cityId)
		
		for i, sector in ipairs(sectors) do
			local sector = gv_Sectors[sector]
			
			if sector and sector.MilitiaBase then
				return true
			end
		end
		
		return false
	end,
	IsEnabled = function (self, sector)
		if HUDA_MilitiaOperations:HasOngoingOperation(self.id, sector) then
			return false, T{0818764949488129, "There is an ongoing operation of the same kind in this city"}	
		end
		
		local hasCooldown, timeLeft = HUDA_MilitiaOperations:HasCooldown(self.id, sector)
		
		if not hasCooldown then 
		    return true
		else
			return false, T{0818764949488129, "You have to wait <hours> hours until you can restart the operation", hours = timeLeft}
		end
	end,
	ModifyProgress = function (self, value, sector)
		local ac = sector.custom_operations and sector.custom_operations[self.id]
		if ac then
			ac.progress = ac.progress + value
		end
	end,
	OnComplete = function (self, sector, mercs)
		sector.custom_operations[self.id]  = nil
		
		HUDA_MilitiaTraining:HandleRecruitmentDrive(sector, mercs)
		HUDA_MilitiaOperations:SetCooldown(self.id,sector,48)
	end,
	OnRemoveOperation = function (self, merc)
		local sector = merc:GetSector()
		
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = nil
		
		HUDA_MilitiaOperations:SetOngoingOperation(self.id, sector, false)
	end,
	OnSetOperation = function (self, merc, arg)
		local sector = merc:GetSector()
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = sector.custom_operations[self.id] or {progress = 0}
		
		HUDA_MilitiaOperations:SetOngoingOperation(self.id, sector, true)
	end,
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Recruiter",
			'display_name', T(413858088407, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive display_name]] "Recruiter"),
			'description', T(113671157268, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive description]] "The assigned merc is recruiting new soldiers for the militia"),
			'display_name_all_caps', T(296447821331, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive display_name_all_caps]] "RECRUITER"),
			'display_name_plural', T(620905389324, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive display_name_plural]] "Recruiters"),
			'display_name_plural_all_caps', T(846277655303, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive display_name_plural_all_caps]] "RECRUITERS"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc, sector, prediction)
		return 3200
	end,
	ProgressCurrent = function (self, merc, sector, prediction)
		return sector.custom_operations and sector.custom_operations[self.id] and sector.custom_operations[self.id].progress or 0
	end,
	ProgressPerTick = function (self, merc, prediction)
		return 100
	end,
	RequiredResources = {
		"Money",
	},
	SectorMercsTick = GetMissingSourceFallback(),
	ShowInCombatBadge = false,
	SortKey = 35,
	Tick = function (self, merc)
		local sector = merc:GetSector()
					local progress_per_tick = self:ProgressPerTick(merc)
					if CheatEnabled("FastActivity") then
						progress_per_tick = progress_per_tick*100
					end
					self:ModifyProgress(progress_per_tick, sector)
					self:CheckCompleted(merc, sector)
	end,
	description = T(937153060998, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive description]] "Take to the streets and educate the population to find new recruits for your militia and increase the popularity of your cause. Leadership will influence the success of the operation."),
	display_name = T(216838084813, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive display_name]] "Recruitment Drive"),
	icon = "Mod/LXPER6t/Images/mb_operation.png",
	id = "HUDA_MilitiaRecruitmentDrive",
	image = "Mod/LXPER6t/Images/Screenshot0008-min.png",
	log_msg_start = T(915358052528, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive log_msg_start]] "<color EmStyle><mercs></color> started <color EmStyle>recruitment drive</color> in "),
	min_requirement_stat = "Leadership",
	related_stat = "Leadership",
	short_name = T(419987446690, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive short_name]] "Recruitment Drive"),
	sub_title = T(293030032736, --[[ModItemSectorOperation HUDA_MilitiaRecruitmentDrive sub_title]] "Find new recruits for your militia"),
}),
PlaceObj('ModItemSectorOperation', {
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
					self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
		    merc.tempOperationProfession = merc.OperationProfession
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetOperationCost = function (self, merc, profession, idx)
		return {}
	end,
	GetSectorSlots = function (self, prof, sector)
		return 1
	end,
	GetTimelineEventDescription = GetMissingSourceFallback(),
	HasOperation = function (self, sector)
		if sector.Guardpost or sector.MilitiaBase or sector.MilitiaPrison then
			return true
		end
		
		return false
	end,
	IsEnabled = function (self, sector)
		if not gv_HUDA_CapturedPows or  #(gv_HUDA_CapturedPows[sector.Id] or {}) < 1 then
			return false, T{0818764949480920, "There are no Prisoners to interrogate"}	
		end
		
		return true
	end,
	ModifyProgress = function (self, value, sector)
		local ac = sector.custom_operations and sector.custom_operations[self.id]
		if ac then
			ac.progress = ac.progress + value
		end
	end,
	OnComplete = function (self, sector, mercs)
		sector.custom_operations[self.id] = nil
		HUDA_MilitiaPOWInterrogation:OnComplete(self, sector, mercs)
	end,
	OnRemoveOperation = function (self, merc)
		local sector = merc:GetSector()
		
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = nil
	end,
	OnSetOperation = function (self, merc, arg)
		local sector = merc:GetSector()
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = sector.custom_operations[self.id] or {progress = 0}
	end,
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Goodcop",
			'display_name', T(734176418412, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name]] "Good Cop"),
			'description', T(848626656108, --[[ModItemSectorOperation HUDA_MilitiaInterrogation description]] "The assigned merc is interrogating"),
			'display_name_all_caps', T(956705129158, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_all_caps]] "GOOD COP"),
			'display_name_plural', T(821199569777, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_plural]] "Good Cop"),
			'display_name_plural_all_caps', T(929519572424, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_plural_all_caps]] "GOOD COP"),
		}),
		PlaceObj('SectorOperationProfession', {
			'id', "Badcop",
			'display_name', T(586048431905, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name]] "Bad Cop"),
			'description', T(951620628204, --[[ModItemSectorOperation HUDA_MilitiaInterrogation description]] "The assigned merc is interrogating"),
			'display_name_all_caps', T(446797879002, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_all_caps]] "BAD COP"),
			'display_name_plural', T(406446268506, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_plural]] "Bad Cop"),
			'display_name_plural_all_caps', T(424358483701, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name_plural_all_caps]] "BAD COP"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc, sector, prediction)
		return 4800
	end,
	ProgressCurrent = function (self, merc, sector, prediction)
		return sector.custom_operations and sector.custom_operations[self.id] and sector.custom_operations[self.id].progress or 0
	end,
	ProgressPerTick = function (self, merc, prediction)
		return 100
	end,
	SectorMercsTick = GetMissingSourceFallback(),
	SectorOperationStats = function (self, sector, check_only)
		return HUDA_MilitiaPOWInterrogation:SectorOperationStats(self, sector, check_only)
	end,
	ShowInCombatBadge = false,
	SortKey = 35,
	Tick = function (self, merc)
		local sector = merc:GetSector()
		           local progress_per_tick = self:ProgressPerTick(merc)
					if CheatEnabled("FastActivity") then
						progress_per_tick = progress_per_tick*100
					end
					self:ModifyProgress(progress_per_tick, sector)
					self:CheckCompleted(merc, sector)
	end,
	description = T(869525760013, --[[ModItemSectorOperation HUDA_MilitiaInterrogation description]] "Interrogate the prisoners to obtain valuable information. Mercenaries with high leadership are best suited for interrogations. There are also perks that influence the outcome of the interrogation."),
	display_name = T(757716983700, --[[ModItemSectorOperation HUDA_MilitiaInterrogation display_name]] "Interrogation"),
	icon = "Mod/LXPER6t/Icons/pow_operations.png",
	id = "HUDA_MilitiaInterrogation",
	image = "Mod/LXPER6t/Images/Screenshot0015.png",
	log_msg_start = T(902593439314, --[[ModItemSectorOperation HUDA_MilitiaInterrogation log_msg_start]] "<color EmStyle><mercs></color> started <color EmStyle>interrogation</color> in "),
	min_requirement_stat = "Leadership",
	related_stat = "Leadership",
	short_name = T(357060892972, --[[ModItemSectorOperation HUDA_MilitiaInterrogation short_name]] "Interrogation"),
	sub_title = T(891097602479, --[[ModItemSectorOperation HUDA_MilitiaInterrogation sub_title]] "Interrogate the prisoners"),
}),
PlaceObj('ModItemSectorOperation', {
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
						self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		if next(merc_names) then
			CombatLog("important", T{258083168009, "<em><mercs></em> completed <em><activity></em> in <SectorName(sector)>", mercs = ConcatListWithAnd(merc_names),activity = self.display_name, sector = sector})
		end
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetAssignMessage = function (self, nameCombination, costTexts)
		costTexts = table.concat(costTexts, T(642697486575, ", "))
		return T{253336352123, "Training the locals to fight will require some additional funds. Do you want to pay <costTexts>", names = nameCombination, costTexts = costTexts}
	end,
	GetOperationCost = function (self, merc, profession, idx)
		return HUDA_MilitiaTraining:GetOperationCost(self, merc, profession, idx)
	end,
	GetSectorSlots = function (self, prof)
		return 2
	end,
	GetTimelineEventDescription = function (self, sector_id, eventcontext)
		local mercs
		local professionId = self.Professions and self.Professions[1] and self.Professions[1].id
		if eventcontext.mercs then
			mercs = table.map(eventcontext.mercs, function(id) return gv_UnitData[id].Nick end)
		else
			mercs = GetOperationProfessionalsGroupedByProfession(sector_id, self.id)
			mercs = table.map(professionId and mercs[professionId] or mercs, "Nick")
		end
		mercs = ConcatListWithAnd(mercs)
		return T{342825966200, "<em><mercs></em> will finish training militia.", mercs = mercs}
	end,
	HasOperation = function (self, sector)
		return sector.Militia
	end,
	IsEnabled = function (self, sector)
		return HUDA_MilitiaTraining:IsEnabled(self, sector)
	end,
	ModifyProgress = function (self, value, sector)
		sector.militia_training_progress = sector.militia_training_progress + value
	end,
	OnComplete = function (self, sector, mercs)
		HUDA_MilitiaTraining:OnComplete(self, sector, mercs)
	end,
	OnRemoveOperation = function (self, merc)
		return HUDA_MilitiaTraining:OnRemoveOperation(self, merc)
	end,
	OnSetOperation = function (self, merc, arg)
		return HUDA_MilitiaTraining:OnSetOperation(self, merc, arg)
	end,
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "min_progress",
			'Value', 10,
			'Tag', "<min_progress>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "max_progress",
			'Value', 25,
			'Tag', "<max_progress>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "min_loyalty_cost_mul",
			'Value', 3,
			'Tag', "<min_loyalty_cost_mul>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "trained_rookies",
			'Tag', "<trained_rookies>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "trained_veterans",
			'Tag', "<trained_veterans>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "cost_per_unit",
			'Value', 150,
			'Tag', "<cost_per_unit>",
		}),
	},
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Trainer",
			'display_name', T(542943973735, --[[ModItemSectorOperation MilitiaTraining display_name]] "Trainer"),
			'description', T(229002779587, --[[ModItemSectorOperation MilitiaTraining description]] "The Trainer is working with the locals turning them into Militia troops."),
			'display_name_all_caps', T(956332383455, --[[ModItemSectorOperation MilitiaTraining display_name_all_caps]] "TRAINER"),
			'display_name_plural', T(912372826030, --[[ModItemSectorOperation MilitiaTraining display_name_plural]] "Trainers"),
			'display_name_plural_all_caps', T(570441522246, --[[ModItemSectorOperation MilitiaTraining display_name_plural_all_caps]] "TRAINERS"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc)
		return const.Satellite.MilitiaTrainingThreshold
	end,
	ProgressCurrent = function (self, merc, sector)
		return sector.militia_training_progress or 0
	end,
	ProgressPerTick = function (self, merc, prediction)
		local sector = merc:GetSector()
		local min_progress = self:ResolveValue("min_progress")
		local max_progress = self:ResolveValue("max_progress")
		local progress = min_progress + (merc.Leadership) * (max_progress - min_progress) / 100
		if HasPerk(merc, "Teacher") then
			local trainingBonusPercent = CharacterEffectDefs.Teacher:ResolveValue("MilitiaTrainingBonusPercent") 
			progress = progress + MulDivRound(progress, trainingBonusPercent, 100)
		end
		if HasPerk(merc, "JackOfAllTrades") then
			local mod = CharacterEffectDefs.JackOfAllTrades:ResolveValue("activityDurationMod")
			progress = progress + MulDivRound(progress, mod, 100)
		end
		return progress
	end,
	RequiredResources = {
		"Money",
	},
	SectorOperationStats = function (self, sector, check_only)
		return HUDA_MilitiaTraining:SectorOperationStats(self, sector, check_only)
	end,
	SortKey = 30,
	description = T(282564535277, --[[ModItemSectorOperation MilitiaTraining description]] "Whip the civilian population into shape, turning them into a local Militia able to defend against hostile troops. Picking a Trainer with high <color EmStyle>Leadership</color> and a high <color EmStyle>Loyalty</color> of the local population both contribute to faster training."),
	display_name = T(795846673506, --[[ModItemSectorOperation MilitiaTraining display_name]] "Militia Training"),
	icon = "UI/SectorOperations/T_Icon_Activity_TrainingMilitia",
	id = "MilitiaTraining",
	image = "UI/Messages/Operations/train_militia",
	log_msg_start = T(530750486518, --[[ModItemSectorOperation MilitiaTraining log_msg_start]] "<color EmStyle><mercs></color> started <color EmStyle>training Militia</color> in "),
	param_bindings = {},
	related_stat = "Leadership",
	short_name = T(752668063817, --[[ModItemSectorOperation MilitiaTraining short_name]] "Militia"),
	sub_title = T(563690126663, --[[ModItemSectorOperation MilitiaTraining sub_title]] "Militia training is available"),
	trained_rookies = 5,
	trained_veterans = 0,
}),
PlaceObj('ModItemSectorOperation', {
	CanPerformOperation = GetMissingSourceFallback(),
	CheckCompleted = function (self, merc, sector)
		if self:ProgressCurrent(merc, sector) >= self:ProgressCompleteThreshold(merc, sector) then
					self:Complete(sector)
		end
	end,
	Complete = function (self, sector)
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		local merc_names = {}
		for _, merc in ipairs(mercs) do
			merc_names[#merc_names + 1] = merc.Nick
			merc:SetCurrentOperation("Idle")
		end
		self:OnComplete(sector, mercs)
		if next(merc_names) then
			CombatLog("important", T{258083168009, "<em><mercs></em> completed <em><activity></em> in <SectorName(sector)>", mercs = ConcatListWithAnd(merc_names),activity = self.display_name, sector = sector})
		end
		Msg("OperationCompleted", self, mercs, sector)
	end,
	Custom = false,
	GetSectorSlots = function (self, prof, sector)
		return 1
	end,
	GetTimelineEventDescription = GetMissingSourceFallback(),
	HasOperation = function (self, sector)
		return true
	end,
	IsEnabled = function (self, sector)
		return true
	end,
	OnComplete = function (self, sector, mercs)
		HUDA_MilitiaTransfer:OnComplete(self, sector, mercs)
	end,
	OnRemoveOperation = function (self, merc)
		local sector = merc:GetSector()
		local mercs = GetOperationProfessionals(sector.Id, self.id,false, merc.session_id)
		-- reset items
		if #mercs<=0 then
			sector.sector_repair_items_queued = {}
			-- SectorOperationFillItemsToRepair(sector.Id,mercs)
			ObjModified(sector.sector_repair_items_queued)
			if sector.started_operations and sector.started_operations.RepairItems then
				NetSyncEvent("InterruptSectorOperation", sector.Id,"RepairItems")				
			end
			
			Msg("OperationCompleted", self, mercs, sector)
		end
	end,
	OnSetOperation = function (self, merc, arg)
		print("set sell")
		local sector = merc:GetSector()
		local mercs = GetOperationProfessionals(sector.Id, self.id)
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = {progress = 0, sector_transfer = {}, sector_transfer_queue = {}, sector_destination = ""}
		-- reset items
		-- sector.sector_repair_items_queued = {}
		--SectorOperationFillItemsToRepair(sector.Id,mercs)
		--ObjModified(sector.sector_repair_items_queued)
	end,
	Professions = {
		PlaceObj('SectorOperationProfession', {
			'id', "Logistician",
			'display_name', T(231801278144, --[[ModItemSectorOperation HUDA_MilitiaSellItems display_name]] "Logistician"),
			'description', T(693663146337, --[[ModItemSectorOperation HUDA_MilitiaSellItems description]] "The Logistician will package the items for shipping"),
			'display_name_all_caps', T(334124120936, --[[ModItemSectorOperation HUDA_MilitiaSellItems display_name_all_caps]] "LOGISTICIAN"),
			'display_name_plural', T(941933818023, --[[ModItemSectorOperation HUDA_MilitiaSellItems display_name_plural]] "LOGISTICIAN"),
			'display_name_plural_all_caps', T(583970100531, --[[ModItemSectorOperation HUDA_MilitiaSellItems display_name_plural_all_caps]] "LOGISTICIAN"),
		}),
	},
	ProgressCompleteThreshold = function (self, merc, sector, prediction)
		return 100
	end,
	ProgressCurrent = function (self, merc, sector, prediction)
		return sector.custom_operations and sector.custom_operations[self.id] and sector.custom_operations[self.id].progress or 0
	end,
	ProgressPerTick = function (self, merc, prediction)
		return 1
	end,
	SectorMercsTick = GetMissingSourceFallback(),
	SortKey = 50,
	Tick = function (self, merc)
		local sector = merc:GetSector()
					local progress_per_tick = self:ProgressPerTick(merc)
					if CheatEnabled("FastActivity") then
						progress_per_tick = progress_per_tick*100
					end
					self:ModifyProgress(progress_per_tick, sector)
					self:CheckCompleted(merc, sector)
	end,
	description = T(755251452409, --[[ModItemSectorOperation HUDA_MilitiaSellItems description]] "This logistics operation makes it possible to collect items in a city, transfer them to other sectors or sell them to Arulco's emerging new army."),
	display_name = T(644135474473, --[[ModItemSectorOperation HUDA_MilitiaSellItems display_name]] "Collect & Transfer"),
	icon = "UI/SectorOperations/T_Icon_Activity_Traveling",
	id = "HUDA_MilitiaSellItems",
	image = "UI/Messages/Operations/repair_item",
	related_stat = "Strength",
	short_name = T(455632938641, --[[ModItemSectorOperation HUDA_MilitiaSellItems short_name]] "Collect Items, Transfer or sell them"),
	sub_title = T(600149283128, --[[ModItemSectorOperation HUDA_MilitiaSellItems sub_title]] "Collect items in the city, transfer or sell them"),
}),
PlaceObj('ModItemTextStyle', {
	RolloverTextColor = 4291018156,
	TextColor = 4291018156,
	TextFont = T(155354300368, --[[ModItemTextStyle HUDASMALLPDASM TextFont]] "HMGothic Rough A, 10"),
	id = "HUDASMALLPDASM",
}),
PlaceObj('ModItemTextStyle', {
	RolloverTextColor = 4281612093,
	ShadowType = "outline",
	TextColor = 4290724685,
	TextFont = T(493635898926, --[[ModItemTextStyle HUDAProductOutOfStock TextFont]] "HMGothic Regular A, 16"),
	group = "Zulu PDA",
	id = "HUDAProductOutOfStock",
}),
PlaceObj('ModItemTextStyle', {
	RolloverTextColor = 4290132532,
	ShadowType = "outline",
	TextColor = 4290132532,
	TextFont = T(321991763119, --[[ModItemTextStyle PDAMilitiaShopCouponCode TextFont]] "HMGothic Regular A, 14"),
	id = "PDAMilitiaShopCouponCode",
}),
PlaceObj('ModItemTextStyle', {
	RolloverTextColor = 4286349920,
	ShadowType = "outline",
	TextColor = 4286349920,
	TextFont = T(477823887267, --[[ModItemTextStyle PDAMilitiaShopCouponCodeValid TextFont]] "HMGothic Regular A, 14"),
	id = "PDAMilitiaShopCouponCodeValid",
}),
}
