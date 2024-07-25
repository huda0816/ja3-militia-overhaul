local hasTempOperationProf = false
for _, prop in ipairs(UnitProperties.properties) do
    if prop.id == 'tempOperationProfession' then
        hasTempOperationProf = true
    end
end

if not hasTempOperationProf then
    UnitProperties.properties[#UnitProperties.properties + 1] = {
        category = "General",
        id = "tempOperationProfession",
        editor = "text",
        default = ""
    }
end

DefineClass.HUDA_MilitiaPOWInterrogation = {}

function HUDA_MilitiaPOWInterrogation:GetMercsFromSector(sector)

    local mercs = sector.operations_temp_data and sector.operations_temp_data.HUDA_MilitiaInterrogation

	if not mercs then
        return
    end

    local m = {}

    for id, _ in pairs(mercs) do

        local merc = gv_UnitData[id]

        if merc then
            table.insert(m, merc)
        end

    end

    return m

end

function HUDA_MilitiaPOWInterrogation:SectorOperationStats(op, sector, check_only)
    if check_only then
        return true
    end

    local prisonInformation = HUDA_MilitiaPOW:GetPrisonData(sector.Id)

    local lines = {}

    lines[#lines + 1] = {
        text = T(08142319880486560829, "Prisoners"),
        value = T {
            08162573281645840834,
            "<current>/<max>",
            current = prisonInformation.current,
            max = prisonInformation.max
        }
    }

    lines[#lines + 1] = {
        text = T(08162319880486560820, "Revolt risk"),
        value = T {
            08162573281645840845,
            "<value>",
            value = prisonInformation.risk
        }
    }

    local mercs = self:GetMercsFromSector(sector)

	local successChance = mercs and next(mercs) and self:GetSuccessChance(mercs) or 0

    lines[#lines + 1] = {
        text = T(08162319880486560821, "Team Success Chance"),
        value = T {
            08162573281645840846,
            "<value>%",
            value = successChance
        }
    }

    -- local progressVal = op:ProgressCurrent()

    return lines -- , progressVal
end

function HUDA_MilitiaPOWInterrogation:HandleEscape(sectorId, goodCop, badCop)
    return {
        headLine = T(08162319880486560821, "Prisoner Escaped"),
        text = T {08162319880486560821,
                  "During a tense interrogation, <goodcop>'s soft approach and <badcop>'s harsh tactics were unexpectedly thwarted when their clever prisoner escaped, exploiting a brief distraction. This unforeseen breakout sparked an immediate investigation, leaving both mercs to reflect on their underestimated foe.",
                  {
            goodcop = goodCop.Nick,
            badcop = badCop.Nick
        }},
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleDeath(sectorId, goodCop, badCop)
    local killer = HasPerk(badCop, "Psycho") and badCop or goodCop

    local cities = gv_Cities

    for cityName, city in pairs(cities) do
        if city.Loyalty and city.Loyalty > 0 then
            CityModifyLoyalty(cityName, -2)
        end
    end

    return {
        headLine = T(08162319880486560821081, "Prisoner Died"),
        text = T {
            081623198804865608212082,
            "In the stark interrogation room, <killer>, infamous for his harsh methods, intensely questioned the prisoner. The interrogation quickly spiraled, resulting in the prisoner's unexpected death, which shook loyalty across cities and stained <killer>'s fearsome reputation.",
            killer = killer.Nick
        },
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleHurt(sectorId, goodCop, badCop)
    local basket = {'goodCop', 'badCop', 'goodCop', 'goodCop'}

    local hurt = basket[InteractionRandRange(1, 4)]

    local unit = hurt == 'goodCop' and goodCop or badCop

    unit:AddWounds(1)
    unit.HitPoints = Max(1, MulDivRound(unit.HitPoints, 75, 100))

    return {
        headLine = T {08162319880486560823083, "<interrogator> was hurt", {
            interrogator = unit.Nick
        }},
        text = T {08162319880486560824084,
                  "During an intense interrogation, <interrogator>, acclaimed for his effective techniques, suffered an injury at the hands of the prisoner. This unforeseen turn of events necessitated the prisoner's swift return to confinement and cast a shadow over <interrogator>'s otherwise exemplary performance.",
                  {
            interrogator = unit.Nick
        }}
    }
end

function HUDA_MilitiaPOWInterrogation:HandleNothing(sectorId, goodCop, badCop)
    return {
        headLine = T(08162319880486560821085, "Interrogation Yields No Results"),
        text = T {
            08162319880486560821086,
            "Faced with persistent silence, the <goodcop> and <badcop> could not extract any information from the steadfast prisoner. The session concluded, leaving a lingering hope for more fruitful outcomes in subsequent interrogations.",
            goodcop = goodCop.Nick,
            badcop = badCop.Nick
        }
    }
end

function HUDA_MilitiaPOWInterrogation:HandleIntel(sectorId, goodCop, badCop)
    local discovered_in = {}

    local intel_sectors = HUDA_TableKeys(table.filter(gv_Sectors, function(i, o)
        return o.Intel and not o.intel_discovered
    end))

    local randSector = table.interaction_rand(intel_sectors, "Satellite")

    if randSector then
        DiscoverIntelForSector(randSector, false)
    end

    return {
        headLine = T(08162319880486560821087, "Valuable Intel Secured"),
        text = T {
            08162319880486560821088,
            "The interrogation proved successful, yielding crucial information about sector <sector> from the prisoner. This intel marks a significant breakthrough in our operations.",
            sector = randSector
        },
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleStash(sectorId, goodCop, badCop)
    local basket = {
        TinyDiamonds = 80,
        DiamondBriefcase = 2,
        OpticalLens = 30,
        Microchip = 20,
        WeaponShipment = 10,
        TreasureIdol = 5,
        TreasureMask = 5,
        TreasureTablet = 5,
        TreasureFigurine = 5
    }

    local filledBasket = {}

    for k, v in pairs(basket) do
        for i = 1, v do
            table.insert(filledBasket, k)
        end
    end

    local result = table.interaction_rand(filledBasket, "stash")

    local item = PlaceInventoryItem(result)

    local items = {item}

    AddToSectorInventory(sectorId, items)

    return {
        headLine = T(08162319880486560821089, "Stash Yields Valuable Find"),
        text = T {
            081623198804865608210810,
            "The prisoner's cooperation led us to his concealed stash, where we discovered <em><got></em>. This valuable find adds a significant boost to our resources.",
            got = g_Classes[result].DisplayName
        },
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleRansom(sectorId, goodCop, badCop)
    local money = InteractionRandRange(1000, 5000, "ransom")

    AddMoney(money, "ransom", true)

    return {
        headLine = T(081623198804865608210811, "Lucrative Ransom Deal Concluded"),
        text = T {
            081623198804865608210812,
            "Upon learning of the prisoner's affluent family ties, we initiated contact for a ransom. This strategy proved fruitful, as we received $<money> for facilitating his release, bolstering our funds.",
            money = money
        },
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleMilitia(sectorId, goodCop, badCop)
    local sector = gv_Sectors[sectorId]

    local militia_squad_id = sector.militia_squad_id

    local newSquad = false

    if sector.militia_squad_id then
        local militia_squad = gv_Squads[militia_squad_id]

        if militia_squad and militia_squad.units and #militia_squad.units >= sector.MaxMilitia then
            newSquad = true
        end
    end

    militia_squad_id = newSquad and CreateNewSatelliteSquad({
        Side = "ally",
        CurrentSector = sectorId,
        militia = true,
        Name = T(1215602053470815, "MILITIA")
    }) or militia_squad_id

    sector.militia_squad_id = militia_squad_id

    local militia_squad = gv_Squads[militia_squad_id]

    CreateMilitiaUnitData(MilitiaUpgradePath[2], sector, militia_squad)

    HUDA_MilitiaPersonalization:PersonalizeSquad(militia_squad.UniqueId)

    HUDA_MilitiaPersonalization:Personalize(militia_squad.units)

    return {
        headLine = T(081623198804865608210813, "Prisoner Enlists in Militia"),
        text = T(081623198804865608210814,
            "Through persuasive efforts, we successfully convinced the prisoner to join our ranks and become a part of the militia, strengthening our forces."),
        remove = true
    }
end

function HUDA_MilitiaPOWInterrogation:HandleResult(outcome, sectorId, goodCop, badCop)

    local result = nil

    if outcome == "escape" then
        result = self:HandleEscape(sectorId, goodCop, badCop)
    elseif outcome == "death" then
        result = self:HandleDeath(sectorId, goodCop, badCop)
    elseif outcome == "hurt" then
        result = self:HandleHurt(sectorId, goodCop, badCop)
    elseif outcome == "intel" then
        result = self:HandleIntel(sectorId, goodCop, badCop)
    elseif outcome == "stash" then
        result = self:HandleStash(sectorId, goodCop, badCop)
    elseif outcome == "ransom" then
        result = self:HandleRansom(sectorId, goodCop, badCop)
    elseif outcome == "militia" then
        result = self:HandleMilitia(sectorId, goodCop, badCop)
    else
        result = self:HandleNothing(sectorId, goodCop, badCop)
    end

    if result.remove then
        table.remove(gv_HUDA_CapturedPows[sectorId], 1)
    end

    return result
end

function HUDA_MilitiaPOWInterrogation:GetTeamRating(goodCop, badCop)

    local goodCopRating = MulDivRound(goodCop.Leadership, 1, 2) + DivRound(goodCop.Wisdom, 4)
    local badCopRating = MulDivRound(badCop.Leadership, 1, 2) + DivRound(badCop.Wisdom, 4)

    local goodCopPerks = goodCop:GetPerks()
    local badCopPerks = badCop:GetPerks()

    local perkRatings = {
        JackOfAllTrades = {
            Good = 10,
            Bad = 10
        },
        FoxPerk = {
            Good = 10,
            Bad = 0
        },
        Teacher = {
            Good = 10,
            Bad = 10
        },
        Optimist = {
            Good = 20,
            Bad = -10
        },
        Negotiator = {
            Good = 40,
            Bad = 0
        },
        Scoundrel = {
            Good = 20,
            Bad = 20
        },
        Spiritual = {
            Good = -10,
            Bad = -20
        },
        Psycho = {
            Good = -40,
            Bad = 40
        },
        Pessimist = {
            Good = -10,
            Bad = 10
        },
        Loner = {
            Good = -20,
            Bad = -20
        }
    }

    for _, perk in ipairs(goodCopPerks) do
        if perkRatings[perk.class] then
            goodCopRating = goodCopRating + perkRatings[perk.class].Good
        end
    end

    for _, perk in ipairs(badCopPerks) do
        if perkRatings[perk.class] then
            badCopRating = badCopRating + perkRatings[perk.class].Bad
        end
    end

    local teamRating = goodCopRating + badCopRating

    return teamRating, goodCopRating, badCopRating

end

function HUDA_MilitiaPOWInterrogation:GetSuccessChance(mercs)

    local goodCop = nil;
    local badCop = nil;

    for _, merc in ipairs(mercs) do

		if merc.OperationProfession == "Goodcop" then
            goodCop = merc
        elseif merc.OperationProfession == "Badcop" then
            badCop = merc
        end
    end

	if not goodCop or not badCop then
		return 0
	end

    local teamRating, goodCopRating, badCopRating = HUDA_MilitiaPOWInterrogation:GetTeamRating(goodCop, badCop)

    return teamRating < 30 and 0 or DivRound(teamRating, 2)

end

function HUDA_MilitiaPOWInterrogation:OnComplete(op, sector, mercs)
    local goodCop = nil;
    local badCop = nil;

    for _, merc in ipairs(mercs) do
        if merc.tempOperationProfession == "Goodcop" then
            goodCop = merc
        elseif merc.tempOperationProfession == "Badcop" then
            badCop = merc
        end
    end

    local teamRating, goodCopRating, badCopRating = HUDA_MilitiaPOWInterrogation:GetTeamRating(goodCop, badCop)

    local successRoll = InteractionRandRange(30, 200, "Interrogation Success Roll")

	local success = successRoll < teamRating

    local successMargin = teamRating - successRoll

    local outcome = nil

    local goodOutcomes = {"intel", "intel", "stash", "ransom", "stash", "ransom", "militia"}

    local badOutcomes = {"nothing", "nothing", "nothing", "hurt", "escape", "death"}

    if success then
        local randMax = 3

        if successMargin > 80 then
            randMax = 5

            if goodCopRating > 50 then
                randMax = 6
            end
        end

        local rand = InteractionRand(randMax)

        outcome = goodOutcomes[rand + 1]
    else
        local randMax = 2
        local randMin = 0

        if successMargin < -30 then
            randMax = 4

            if successMargin < -100 then
                randMin = 1
            end

            if HasPerk(goodCop, "Psycho") or HasPerk(badCop, "Psycho") then
                randMax = 5
            end
        end

        local rand = InteractionRandRange(randMin, randMax, "Bad Outcome Roll")

        outcome = badOutcomes[rand + 1]
    end

    local result = self:HandleResult(outcome, sector.Id, goodCop, badCop)

    NetUpdateHash("CompleteCurrentMilitiaInterrorgation")
    local eventId = g_MilitiaInterrogationCompleteCounter
    g_MilitiaInterrogationCompleteCounter = g_MilitiaInterrogationCompleteCounter + 1
    local start_time = Game.CampaignTime
    CreateMapRealTimeThread(function()
        local popupHost = GetDialog("PDADialogSatellite")
        popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

        local prisonersAvailable = #(gv_HUDA_CapturedPows[sector.Id] or {}) > 0

        local buyAgainText = prisonersAvailable and
                                 T {08164602612170816, "Do you want interrogate the next prisoner? (<left> left)", {
                left = #gv_HUDA_CapturedPows[sector.Id]
            }} or T {08164602612170817, "There are no more prisoners to interrogate."}

        local dlg = CreateQuestionBox(popupHost, result.headLine, result.text, T(689884995409, "Yes"),
            T(782927325160, "No"), {
                sector = sector,
                mercs = mercs,
                textLower = buyAgainText
            }, function()
                return prisonersAvailable and "enabled" or "disabled"
            end, nil, "POPUPMilitiaPOWInterrogation")

        assert(g_MilitiaInterrogationCompletePopups[eventId] == nil)
        g_MilitiaInterrogationCompletePopups[eventId] = dlg
        NetSyncEvent("ProcessMilitiaInterrogationPopupResults", dlg:Wait(), eventId, sector.Id,
            UnitDataToSessionIds(mercs), start_time)
        g_MilitiaInterrogationCompletePopups[eventId] = nil
    end)
end

function NetSyncEvents.ProcessMilitiaInterrogationPopupResults(result, event_id, sector_id, mercs, start_time)
    if result == "ok" then
        local sector = gv_Sectors[sector_id]
        if sector.started_operations["HUDA_MilitiaInterrogation"] ~= start_time then -- other player already started it
            for _, merc in ipairs(mercs) do
                local mercT = gv_UnitData[merc]
                NetSyncEvents.MercSetOperation(merc, "HUDA_MilitiaInterrogation",
                    mercT.tempOperationProfession == "Goodcop" and "Goodcop" or "Badcop", nil, 1, false)
                mercT.tempOperationProfession = nil
            end
            NetSyncEvents.LogOperationStart("HUDA_MilitiaInterrogation", sector.Id, "log")
            NetSyncEvents.StartOperation(sector.Id, "HUDA_MilitiaInterrogation", start_time, sector.training_stat)
        end
    end
    if g_MilitiaInterrogationCompletePopups[event_id] then
        g_MilitiaInterrogationCompletePopups[event_id]:Close()
        g_MilitiaInterrogationCompletePopups[event_id] = nil
    end
end
