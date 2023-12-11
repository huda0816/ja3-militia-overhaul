local hasMilitiaTrainingRookies = false
local hasMilitiaTrainingVeterans = false

for _, prop in ipairs(SatelliteSector.properties) do
	if prop.id == 'militia_training_rookies' then
		hasMilitiaTrainingRookies = true
	end
	if prop.id == 'militia_training_veterans' then
		hasMilitiaTrainingVeterans = true
	end
end

if not hasMilitiaTrainingRookies then
	SatelliteSector.properties[#SatelliteSector.properties + 1] = {
		category = "General",
		id = "militia_training_rookies",
		editor = "number",
		default = 0,
	}
end

if not hasMilitiaTrainingVeterans then
	SatelliteSector.properties[#SatelliteSector.properties + 1] = {
		category = "General",
		id = "militia_training_veterans",
		editor = "number",
		default = 0,
	}
end

-- Overrides the original function. There is no other way
function RollForMilitiaPromotion(sector)
	sector = type(sector) == "table" and sector or gv_Sectors[sector]

	local squads = GetMilitiaSquads(sector)

	local promotedCount = 0
	for _, squad in ipairs(squads) do
		local unitIds = table.copy(squad.units)
		for _, id in ipairs(unitIds) do
			local chance = 10
			local roll = InteractionRand(100, "MilitiaPromotion")
			if chance > roll then
				local unitData = gv_UnitData[id]
				local copy = table.raw_copy(unitData)
				local oldUnits = table.copy(squad.units)

				if unitData.class == "MilitiaRookie" then
					CreateMilitiaUnitData("MilitiaVeteran", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				elseif unitData.class == "MilitiaVeteran" then
					CreateMilitiaUnitData("MilitiaElite", sector, squad)
					DeleteMilitiaUnitData(unitData.session_id, squad)
					promotedCount = promotedCount + 1
				end

				local new_guy_id = HUDA_ArrayFind(squad.units, function(i, v)
					return not HUDA_ArrayContains(oldUnits, v)
				end)

				if new_guy_id then
					local new_guy = gv_UnitData[new_guy_id]

					if new_guy then
						HUDA_MergeMilitia(new_guy, copy)
						Msg("HUDAMilitiaPromoted", new_guy, copy.session_id)
					end
				end
			end
		end
	end
	if 0 < promotedCount then
		if 1 < promotedCount then
			CombatLog("important", T({
				999293615811082,
				"<promotedCount> militia got promoted in <SectorName(sectorId)>",
				promotedCount = promotedCount,
				sectorId = sector.Id
			}))
		else
			CombatLog("important", T({
				999488327770041,
				"A militia unit got promoted in <SectorName(sectorId)>",
				promotedCount = promotedCount,
				sectorId = sector.Id
			}))
		end
	end

	ObjModified("ui_player_squads")
end

function CompleteCurrentMilitiaTraining(sector, mercs, rookies, veterans)
	NetUpdateHash("CompleteCurrentMilitiaTraining")
	local eventId = g_MilitiaTrainingCompleteCounter
	g_MilitiaTrainingCompleteCounter = g_MilitiaTrainingCompleteCounter + 1
	local start_time = Game.CampaignTime
	CreateMapRealTimeThread(function()
		local militia_squad, count_trained = SpawnMilitia(const.Satellite.MilitiaUnitsPerTraining, sector, "operation",
			rookies, veterans)
		sector.militia_training = false

		local militia_types = { MilitiaRookie = 0, MilitiaElite = 0, MilitiaVeteran = 0 }
		for _, unit_id in ipairs(militia_squad.units) do
			local unit = gv_UnitData[unit_id]
			militia_types[unit.class] = militia_types[unit.class] + 1
		end

		local city = HUDA_MilitiaTraining:GetCity(sector)

		---local params = { sector_ID = Untranslated(sector.name), sector_name = sector.display_name, mercs = merc_list_text }

		local popupHost = GetDialog("PDADialogSatellite")
		popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

		if militia_types.MilitiaVeteran >= (sector.MaxMilitia - militia_types.MilitiaElite) then
			--max trainig reached
			local dlg = CreateMessageBox(
				popupHost,
				T(295710973806, "Militia Training"),
				T { 522643975325,
					"Militia training is finished - trained <militia_trained> defenders.<newline><GameColorD>(<sectorName>)</GameColorD>",
					sectorName = GetSectorName(sector),
					militia_trained = count_trained } ..
				"\n\n" ..
				T(306458255966,
					"Militia can’t be trained further. Victories in combat can advance militia soldiers to Elite levels.")
			)
			dlg:Wait()
		elseif gv_HUDA_MilitiaRecruits[city] <= 0 and militia_types.MilitiaRookie <= 0 then
			-- we have no more recruits
			local dlg = CreateMessageBox(
				popupHost,
				T(295710973806, "Militia Training"),
				T { 0816522643975325,
					"Militia training is finished - trained <militia_trained> defenders.<newline><GameColorD>(<sectorName>)</GameColorD>",
					sectorName = GetSectorName(sector),
					militia_trained = count_trained } ..
				"\n\n" ..
				T(0816306458255966,
					"There are no more recruits available for training. Try to improve loyalty and attractivity to get more recruits.")
			)
			dlg:Wait()
		else
			-- train one more time
			local cost, costTexts, names, errors = GetOperationCosts(mercs, "MilitiaTraining", "Trainer", "refund")
			local rookies, veterans = HUDA_MilitiaTraining:GetTrainingGroup(sector,
				#mercs * const.Satellite.MilitiaUnitsPerTraining, city)
			local buyAgainText = T { 0816460261217340, "Do you want to train <rookies> rookies and <veterans> veterans?", rookies =
				rookies, veterans = veterans }
			local costText = table.concat(costTexts, ", ")
			local dlg = CreateQuestionBox(
				popupHost,
				T(295710973806, "Militia Training"),
				T { 522643975325,
					"Militia training is finished - trained <militia_trained> defenders.<newline><GameColorD>(<sectorName>)</GameColorD>",
					sectorName = GetSectorName(sector),
					militia_trained = count_trained },
				T(689884995409, "Yes"),
				T(782927325160, "No"),
				{ sector = sector, mercs = mercs, textLower = buyAgainText, costText = costText },
				function()
					return not next(errors) and
						(militia_types.MilitiaVeteran < (sector.MaxMilitia - militia_types.MilitiaElite)) and "enabled" or
						"disabled"
				end,
				nil,
				"ZuluChoiceDialog_MilitiaTraining")

			assert(g_MilitiaTrainingCompletePopups[eventId] == nil)
			g_MilitiaTrainingCompletePopups[eventId] = dlg
			NetSyncEvent("ProcessMilitiaTrainingPopupResults", dlg:Wait(), eventId, sector.Id,
				UnitDataToSessionIds(mercs), cost, start_time)
			g_MilitiaTrainingCompletePopups[eventId] = nil
		end
	end)
end

function HUDA_SpawnEmmaSquads(trainAmount, sector)
	local militia_squad_id = CreateNewSatelliteSquad({
		Side = "ally",
		CurrentSector = sector.Id,
		militia = true,
		Name = T(121560205347, "MILITIA")
	})

	sector.militia_squad_id = sector.militia_squad_id or militia_squad_id

	local militia_squad = gv_Squads[militia_squad_id]

	for i = 1, trainAmount do
		CreateMilitiaUnitData(MilitiaUpgradePath[2], sector, militia_squad)
	end

	HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

	HUDA_MilitiaPersonalization:Personalize(militia_squad.units, true)
end

function SpawnMilitia(trainAmount, sector, bFromOperation, rookies, veterans)
	assert(MilitiaUpgradePath and #MilitiaUpgradePath > 0)

	if not bFromOperation then
		HUDA_SpawnEmmaSquads(trainAmount, sector)
		return
	end

	local militia_id = sector.militia_squad_id

	-- pushing the militia soldiers into a table so we can keep their stats and stuff
	local original_units = {}
	local session_id_array = {}

	if militia_id then
		local militia = gv_Squads[militia_id]

		if militia.units then
			local unit_data = gv_UnitData

			for index, value in ipairs(militia.units) do
				original_units[value] = table.raw_copy(unit_data[value])
				table.insert(session_id_array, value)
			end
		end
	end

	local militia_squad_id = sector.militia_squad_id or
		CreateNewSatelliteSquad({
			Side = "ally",
			CurrentSector = sector.Id,
			militia = true,
			Name = T(121560205347, "MILITIA")
		})
	sector.militia_squad_id = militia_squad_id

	local militia_squad = gv_Squads[militia_squad_id]

	local count = { MilitiaRookie = 0, MilitiaVeteran = 0 }
	for i, unit_id in ipairs(militia_squad and militia_squad.units) do
		local class = gv_UnitData[unit_id].class
		if class == "MilitiaRookie" then count.MilitiaRookie = count.MilitiaRookie + 1 end
		if class == "MilitiaVeteran" then count.MilitiaVeteran = count.MilitiaVeteran + 1 end
	end

	trainAmount = bFromOperation and (rookies + veterans) or trainAmount

	local count_trained = 0
	for i = 1, trainAmount do
		local squadUnits = militia_squad.units or empty_table
		local leastExpMember = GetLeastExpMilitia(militia_squad.units)

		if #squadUnits < sector.MaxMilitia and i <= rookies then
			CreateMilitiaUnitData(MilitiaUpgradePath[1], sector, militia_squad)
			count_trained = count_trained + 1
		elseif leastExpMember then -- level up
			if bFromOperation and count.MilitiaRookie <= 0 then
				break
			end

			local leastExperiencedTemplate = bFromOperation and "MilitiaRookie" or leastExpMember.class
			local leastExpIdx = table.find(MilitiaUpgradePath, leastExperiencedTemplate)

			leastExpIdx = leastExpIdx or 0
			leastExpIdx = leastExpIdx + 1
			local upgradedClass = MilitiaUpgradePath[leastExpIdx]
			if not (not (leastExpIdx > #MilitiaUpgradePath) and upgradedClass) then
				break
			end

			DeleteMilitiaUnitData(leastExpMember.session_id, militia_squad)
			CreateMilitiaUnitData(upgradedClass, sector, militia_squad)
			count_trained = count_trained + 1
			count.MilitiaRookie = count.MilitiaRookie - 1
			count.MilitiaVeteran = count.MilitiaVeteran + 1
		end
	end

	HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

	local unit_data = gv_UnitData

	local upgraded_units = table.ifilter(militia_squad.units, function(i, v)
		return not string.find(v, "Rookie") and not HUDA_ArrayContains(session_id_array, v)
	end)

	local deleted_units = table.ifilter(session_id_array, function(i, v)
		return not HUDA_ArrayContains(militia_squad.units, v)
	end)

	for index, value in ipairs(upgraded_units) do
		if unit_data[value] then
			HUDA_MergeMilitia(unit_data[value], original_units[deleted_units[index]])
		end
	end

	HUDA_MilitiaPersonalization:Personalize(militia_squad.units)

	local is_squad_full = HUDA_IsSquadFull(militia_squad, sector)

	if is_squad_full then
		sector.militia_squad_id = HUDA_GetTrainableMilitiaSquad(sector, militia_squad.UniqueId)
	end

	ObjModified("ui_player_squads")

	return militia_squad, count_trained
end

function HUDA_MergeMilitia(new, original)
	local protected = {
		randomization_seed = true,
		session_id = true,
		ActionPoints = true,
		Experience = true,
		HitPoints = true,
		MaxHitPoints = true,
		MaxAttacks = true,
		applied_modifiers = true,
	}

	local stats = {
		'Health',
		'Agility',
		'Dexterity',
		'Strength',
		'Wisdom',
		'Leadership',
		'Marksmanship',
		'Mechanical',
		'Explosives',
		'Medical',
	}

	for k, v in pairs(original) do
		if not protected[k] then
			if HUDA_ArrayContains(stats, k) and HUDA_IsMilitiaPromoted(original, new) then
				local randV = v + InteractionRandRange(1, 3, "MilitiaPromotion")

				local baseDiff = randV - new['base_' .. k]

				new[k] = randV

				new:AddModifier("randstat" .. k, k, false, baseDiff)

				if k == "Health" then
					new.HitPoints = new[k]
					new.MaxHitPoints = new[k]
				end
			else
				new[k] = v
			end
		end
	end

	if new.session_id ~= original.session_id then
		new.OldSessionIds = new.OldSessionIds or {}

		table.insert(new.OldSessionIds, original.session_id)
	end
end

function HUDA_IsMilitiaPromoted(original, new)
	if (string.find(original.session_id, "Rookie") ~= nil and string.find(new.session_id, "Veteran") ~= nil) or
		(string.find(original.session_id, "Veteran") ~= nil and string.find(new.session_id, "Elite") ~= nil) then
		return true
	end
end

local HUDA_OriginalGetOperationMercsListContext = GetOperationMercsListContext

function GetOperationMercsListContext(sector, mode_param)
	local context = HUDA_OriginalGetOperationMercsListContext(sector, mode_param)

	local operation = SectorOperations[mode_param.operation]

	if mode_param.assign_merc or not operation or operation.id ~= "MilitiaTraining" then
		return context
	end

	-- add militia list

	local mercs = {}
	local militia_squad_id = sector.militia_squad_id
	local militia_squad = militia_squad_id and gv_Squads[militia_squad_id]
	local count = {
		MilitiaRookie = 0,
		MilitiaVeteran = 0,
		MilitiaElite = 0
	}
	for i, unit_id in ipairs(militia_squad and militia_squad.units) do
		local class = gv_UnitData[unit_id].class
		count[class] = count[class] + 1
	end
	if 0 < count.MilitiaRookie then
		mercs[#mercs + 1] = {
			class = "MilitiaRookie",
			def = "MilitiaRookie",
			prof = "Militia",
			in_progress = false,
			click = false,
			count = count.MilitiaRookie
		}
	end
	if 0 < count.MilitiaVeteran then
		mercs[#mercs + 1] = {
			class = "MilitiaVeteran",
			def = "MilitiaVeteran",
			prof = "Militia",
			in_progress = false,
			click = false,
			count = count.MilitiaVeteran
		}
	end
	if 0 < count.MilitiaElite then
		mercs[#mercs + 1] = {
			class = "MilitiaElite",
			def = "MilitiaElite",
			prof = "Militia",
			in_progress = false,
			click = false,
			count = count.MilitiaElite
		}
	end

	local trainers = GetOperationProfessionals(sector.Id, operation.id, "Trainer")

	if #trainers > 0 then
		-- add in progress	

		local added_MilitiaRookie = sector.militia_training_rookies or 0
		local added_MilitiaVeteran = sector.militia_training_veterans or 0

		if added_MilitiaRookie > 0 then
			table.insert(mercs, 1,
				{
					class = "MilitiaRookie",
					prof = "Militia",
					in_progress = true,
					click = false,
					count = added_MilitiaRookie
				})
		end
		if added_MilitiaVeteran > 0 then
			table.insert(mercs, 1,
				{
					class = "MilitiaVeteran",
					prev = "MilitiaRookie",
					prof = "Militia",
					in_progress = true,
					click = false,
					count = added_MilitiaVeteran
				})
		end
	end

	context[2] = {
		mercs = mercs,
		title = T(977391598484, "Militia"),
		click = false,
		operation = mode_param.operation
	}


	return context
end

function OnMsg.ZuluGameLoaded(game)
	HUDA_MilitiaTraining:Init()
end

function OnMsg.NewDay()
	HUDA_MilitiaTraining:DailyModifierReduction()

	HUDA_MilitiaTraining:RestockMilitia()
end

function OnMsg.LoyaltyChanged(cityId, change)
	HUDA_MilitiaTraining:HandleLoyalityChange(cityId, change)
end

function OnMsg.ConflictEnd(sector, bNoVoice, playerAttacking, playerWon, isAutoResolve)
	HUDA_MilitiaTraining:HandleConflictEnd(sector, playerAttacking, playerWon)
end

function OnMsg.UnitDied(unit, killer, results)
	if not unit.militia then
		return
	end

	HUDA_MilitiaTraining:HandleMilitiaDies(unit, killer, results)
end

GameVar("gv_HUDA_MilitiaRecruits", {})
GameVar("gv_HUDA_MilitiaModifier", {})
GameVar("gv_HUDA_MilitiaLeft", {})
GameVar("gv_HUDA_MilitiaTrainingCurrent")

DefineClass.HUDA_MilitiaTraining = {
	MaxMilitiaPerCity = {
		Bloemstad = 0,
		Chalet = 84,
		ErnieVillage = 62,
		Fleatown = 89,
		IlleMorat = 71,
		Landsbach = 69,
		Pantagruel = 125,
		Payak = 73,
		PortDiancie = 168,
		Sabra = 0
	},
	MinDailyRecruits = 10, -- minimum militia recruits per day in percent of remianing militia per city if loyalty is 100 without modifier
	MaxDailyRecruits = 20, -- maximum militia recruits per day in percent of remaining militia per city if loyalty is 100 without modifier
	DailyModifierDecrease = 1
}

function HUDA_MilitiaTraining:GetTrainingGroup(sector, groupSize, city)
	local trainingGroup = { Recruits = 0, Veterans = 0 }

	local militiaSquadId = sector.militia_squad_id

	local freeSpace = sector.MaxMilitia or 0

	local militiaSquad = militiaSquadId and gv_Squads[militiaSquadId]

	local units = militiaSquad and militiaSquad.units or {}

	freeSpace = freeSpace - #units

	local uptrainables = 0

	for k, u in pairs(units) do
		local unit = gv_UnitData[u]

		if unit and unit.class == "MilitiaRookie" then
			uptrainables = uptrainables + 1
		end
	end

	city = city or self:GetCity(sector)

	local cityRecruits = gv_HUDA_MilitiaRecruits[city] or 0

	groupSize = groupSize or const.Satellite.MilitiaUnitsPerTraining

	for i = 1, groupSize do
		if freeSpace > 0 and cityRecruits > 0 then
			trainingGroup.Recruits = trainingGroup.Recruits + 1

			cityRecruits = cityRecruits - 1

			freeSpace = freeSpace - 1
		elseif uptrainables > 0 then
			trainingGroup.Veterans = trainingGroup.Veterans + 1

			uptrainables = uptrainables - 1
		end
	end

	return trainingGroup.Recruits, trainingGroup.Veterans
end

function HUDA_MilitiaTraining:RestockMilitia()
	gv_HUDA_MilitiaRecruits = gv_HUDA_MilitiaRecruits or {}

	local cities = gv_Cities

	for k, city in pairs(cities) do
		local cityRecruits = gv_HUDA_MilitiaRecruits[k] or 0

		if HUDA_IsControlledCity(k) then
			local loyalty = city.Loyalty

			local remainingMilitia = gv_HUDA_MilitiaLeft[k] or 0

			local max_recruits = MulDivRound(remainingMilitia, self.MaxDailyRecruits, 100)

			local min_recruits = MulDivRound(remainingMilitia, self.MinDailyRecruits, 100)

			local recruits = InteractionRandRange(min_recruits, max_recruits, "Recruits")

			recruits = MulDivRound(recruits, loyalty, 100)

			self:ModifyRecruits(recruits, k)
		end
	end
end

function HUDA_MilitiaTraining:Init()
	gv_HUDA_MilitiaRecruits = self:InitMilitiaRecruits()
	gv_HUDA_MilitiaModifier = self:InitMilitiaModifier()
	gv_HUDA_MilitiaLeft = self:InitMilitiaLeft()
end

function HUDA_MilitiaTraining:GetCity(sector)
	local city = sector.City

	if not city or city == "none" then
		local closest_city, distance = HUDA_GetClosestCity(sector.Id, true)

		if distance > 3 then
			return false, T(0817764949488129, "You do not have a city close enough to this sector")
		end

		city = closest_city
	end

	return city ~= "none" and city or false
end

function HUDA_MilitiaTraining:IsEnabled(op, sector)
	if (not sector or sector.City == "none") and not sector.Guardpost then
		return false, T(0817764949488129, "No militia training possible in this sector")
	end

	local city = self:GetCity(sector)

	local least_exp_templ = self:GetLeastExpMilitia(sector)

	if least_exp_templ == "MilitiaRookie" then
		return true
	end

	gv_HUDA_MilitiaRecruits = gv_HUDA_MilitiaRecruits or {}

	if (gv_HUDA_MilitiaRecruits[city] or 0) > 0 then
		return true
	end

	return false, T(0816764949488129, "No recruits available in this city")
end

function HUDA_MilitiaTraining:GetLeastExpMilitia(sector)
	if not sector then
		return false
	end

	local militia_squads = sector.militia_squads

	if not militia_squads then
		return false
	end

	local units = {}

	for _, squad in ipairs(militia_squads) do
		for _, unit in ipairs(squad.units) do
			table.insert(units, unit)
		end
	end

	local ud = GetLeastExpMilitia(units)
	return ud and ud.class
end

function HUDA_MilitiaTraining:SectorOperationStats(op, sector, check_only)
	if check_only then
		return true
	end

	local city = self:GetCity(sector)

	local lines = {}

	lines[#lines + 1] = {
		text = T(0814231988048656, "City"),
		value = T { 0816257328164584, "<value>", value = gv_Cities[city].DisplayName }
	}

	lines[#lines + 1] = {
		text = T(0816231988048656, "Available Recruits"),
		value = T { 0816257328164584, "<value>", value = city and gv_HUDA_MilitiaRecruits[city] or 0 }
	}

	lines[#lines + 1] = {
		text = T(231988048655, "City Loyalty"),
		value = T { 257328164584, "<percent(value)>", value = city and gv_Cities[city].Loyalty or 0 }
	}

	lines[#lines + 1] = {
		text = T(0817231988048655, "Popularity"),
		value = T { 0817257328164584, "<percent(value)>", value = city and gv_HUDA_MilitiaModifier[city] or 0 }
	}

	local progressVal = MulDivRound(sector.militia_training_progress, 100, op:ProgressCompleteThreshold())

	local militia_squad_id = sector.militia_squad_id
	local militia_squad = militia_squad_id and gv_Squads[militia_squad_id]
	lines[#lines + 1] = {
		text = T(718591666122, "Active Militia"),
		value = T { 702630905213, "<current>/<max>", current = #(militia_squad and militia_squad.units or ""), max =
			sector.MaxMilitia }
	}

	return lines, progressVal
end

function HUDA_MilitiaTraining:GetOperationCost(op, merc, profession, idx)
	local sector = merc:GetSector()
	local other = GetOperationProfessionals(sector.Id, "MilitiaTraining", false, merc.session_id)
	if sector.militia_training and #other > 0 and idx ~= "refund" then
		return {}
	end

	local city = self:GetCity(sector)

	local costPerUnit = op:ResolveValue("cost_per_unit")

	local rookies, veterans = self:GetTrainingGroup(sector, 2 * const.Satellite.MilitiaUnitsPerTraining, city)

	local cost = (rookies + veterans) * costPerUnit

	local loyalty = sector and GetCityLoyalty(city) or 100

	local costForVenue = (HUDA_HasMilitiaBase(sector) or sector.Guardpost) and 0 or MulDivRound(800, 100 - loyalty, 100)

	cost = cost + costForVenue

	if HasPerk(merc, "Negotiator") then
		local discount = CharacterEffectDefs.Negotiator:ResolveValue("discountPercent")
		cost = cost - MulDivRound(cost, discount, 100)
	end

	return { [1] = { value = cost, resource = "Money", min = true } }
end

function HUDA_MilitiaTraining:OnSetOperation(op, merc, arg)
	local sector = merc:GetSector()
	local workers = GetOperationProfessionals(sector.Id, "MilitiaTraining", "Trainer") or {}

	local city = self:GetCity(sector)

	self:ModifyRecruits(sector.militia_training_rookies, city, 100)
	local rookies, veterans = self:GetTrainingGroup(sector, #workers * const.Satellite.MilitiaUnitsPerTraining, city)
	sector.militia_training_rookies = rookies
	sector.militia_training_veterans = veterans
	gv_HUDA_MilitiaTrainingCurrent = gv_HUDA_MilitiaTrainingCurrent or {}
	gv_HUDA_MilitiaTrainingCurrent[sector.Id] = {
		rookies = sector.militia_training_rookies,
		veterans = sector.militia_training_veterans
	}
	self:ModifyRecruits(-rookies, city, 100)
	sector.militia_training = true
end

function HUDA_MilitiaTraining:OnRemoveOperation(op, merc)
	local sector = merc:GetSector()
	local city = self:GetCity(sector)
	local workers = GetOperationProfessionals(sector.Id, "MilitiaTraining", false, merc.session_id) or {}
	self:ModifyRecruits(sector.militia_training_rookies, city, 100)
	sector.militia_training_rookies = 0
	sector.militia_training_veterans = 0
	sector.militia_training = #workers > 0
end

function HUDA_MilitiaTraining:OnComplete(op, sector, mercs)
	gv_HUDA_MilitiaTrainingCurrent = gv_HUDA_MilitiaTrainingCurrent or {}

	local trainingGroup = gv_HUDA_MilitiaTrainingCurrent[sector.Id]

	local city = self:GetCity(sector)

	local rookies = trainingGroup and trainingGroup.rookies or 0
	local veterans = trainingGroup and trainingGroup.veterans or 0

	if rookies > 0 then
		CityModifyLoyalty(city, Max(1, MulDivRound(rookies, 50, 100)), T(0816435104569687, "Militia Training"))
	end

	gv_HUDA_MilitiaTrainingCurrent[sector.Id] = nil
	HUDA_MilitiaTraining:ModifyRecruits(-rookies, city, 100)
	CompleteCurrentMilitiaTraining(sector, mercs, rookies, veterans)
	sector.militia_training_progress = 0
end

function HUDA_MilitiaTraining:InitMilitiaRecruits()
	local cities = gv_Cities

	local militia_recruits = {}

	for k, city in pairs(cities) do
		militia_recruits[k] = gv_HUDA_MilitiaRecruits[k] or 0
	end

	return militia_recruits
end

function HUDA_MilitiaTraining:InitMilitiaModifier()
	local cities = gv_Cities

	local militia_modifier = {}

	for k, city in pairs(cities) do
		militia_modifier[k] = gv_HUDA_MilitiaModifier[k] or 100
	end

	return militia_modifier
end

function HUDA_MilitiaTraining:InitMilitiaLeft()
	local cities = gv_Cities

	local militia_left = {}

	for k, city in pairs(cities) do
		militia_left[k] = gv_HUDA_MilitiaLeft[k] or self.MaxMilitiaPerCity[k]
	end

	return militia_left
end

function HUDA_MilitiaTraining:DailyModifierReduction()
	self:ModifyModifier(-self.DailyModifierDecrease)
end

function HUDA_MilitiaTraining:HandleRecruitmentDrive(sector, mercs)
	-- new recruits will Join in city

	local merc = mercs[1]

	local leaderShip = merc.Leadership

	local modifier = MulDivRound(30, leaderShip, 100)

	local recruits = MulDivRound(15, leaderShip, 100)

	local minRecruits = MulDivRound(5, leaderShip, 100)

	self:ModifyModifier(modifier, sector.City)

	local recruitsLeft = gv_HUDA_MilitiaLeft[sector.City]

	local newRecruits = Max(minRecruits, MulDivRound(recruitsLeft, recruits, 100));

	local rand = InteractionRandRange(80, 110, "Recruitment Drive")

	newRecruits = Max(1, MulDivRound(newRecruits, rand, 100))

	CombatLog("important",
		T { 0816352089713704,
			"<em><merc></em> finished <em>Recruitment Drive</em> in <SectorName(sector)> hiring <recruits> recruits and increasing the popularity to join by <modifier>%.", merc =
			merc.Nick, sector = sector, recruits = newRecruits, modifier = modifier })

	self:ModifyRecruits(newRecruits, sector.City, 100)
end

function HUDA_MilitiaTraining:HandleLoyalityChange(city_id, change)
	-- recruits in city will leave if loyalty is reduced

	if change < 0 then
		local currentRecruits = gv_HUDA_MilitiaRecruits[city_id]

		local leavingRecruits = MulDivRound(currentRecruits, 5, 100);

		self:ModifyRecruits(-leavingRecruits, city_id)
	end

	if change > 0 then
		self:ModifyModifier(5, city_id)
	end
end

function HUDA_MilitiaTraining:HandleConflictEnd(sector, playerAttacking, playerWon)
	if playerWon then
		self:ModifyModifier(5)
	else
		self:ModifyModifier(-10)

		local cities = gv_Cities

		for k, city in pairs(cities) do
			local currentRecruits = gv_HUDA_MilitiaRecruits[k]

			local leavingRecruits = MulDivRound(currentRecruits, 5, 100);

			self:ModifyRecruits(-leavingRecruits, k)
		end
	end
end

function HUDA_MilitiaTraining:HandleMilitiaDies(unit, killer, results)
	if not unit.JoinLocation then
		return
	end

	local joinSectorId = unit.JoinLocation

	local joinSector = gv_Sectors(joinSectorId)

	local city = self:GetCity(joinSector)

	if not city then
		return
	end

	local currentRecruits = gv_HUDA_MilitiaRecruits[city]

	local leavingRecruits = MulDivRound(currentRecruits, 10, 100);

	self:ModifyRecruits(-leavingRecruits, city)

	self:ModifyModifier(-2, city)

	local roll = Random(100)

	-- if roll < 50 then
	CityModifyLoyalty(city, -1,
		T { 0818435104569687, "<nick> Died", nick = unit.Nick or "Soldier" })
	-- end
end

function HUDA_MilitiaTraining:ModifyRecruits(number, city, modifier)
	if city then
		if not modifier then
			modifier = gv_HUDA_MilitiaModifier[city] or 100
		end

		if number < 0 then
			modifier = 100
		end

		local recruits = MulDivRound(number, modifier, 100)

		gv_HUDA_MilitiaRecruits[city] = (gv_HUDA_MilitiaRecruits[city] or 0) + recruits

		gv_HUDA_MilitiaLeft[city] = Max(0, (gv_HUDA_MilitiaLeft[city] or 0) - recruits)
	else
		local cities = gv_Cities

		for k, city in pairs(cities) do
			self:ModifyRecruits(number, k, modifier)
		end
	end
end

function HUDA_MilitiaTraining:ModifyModifier(number, city)
	if city then
		local controlled = HUDA_IsControlledCity(city)

		if controlled then
			gv_HUDA_MilitiaModifier[city] = Min(Max((gv_HUDA_MilitiaModifier[city] or 0) + number, 30), 150)
		end
	else
		local cities = gv_Cities

		for k, city in pairs(cities) do
			self:ModifyModifier(number, k)
		end
	end
end
