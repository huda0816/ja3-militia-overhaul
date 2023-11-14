-- DefineClass.HUDA_MilitiaPOWInterrogation = {}

-- function HUDA_MilitiaPOWInterrogation:SectorOperationStats(op, sector, check_only)
--     if check_only then
--         return true
--     end

--     local prisonInformation = HUDA_MilitiaPOW:GetPrisonData(sector.Id)

--     local lines = {}

--     lines[#lines + 1] = {
--         text = T(08142319880486560829, "Prisoners"),
--         value = T { 08162573281645840834, "<current>/<max>", current = prisonInformation.current, max = prisonInformation.max }
--     }

--     lines[#lines + 1] = {
--         text = T(08162319880486560820, "Revolt risk"),
--         value = T { 08162573281645840845, "<value>", value = prisonInformation.risk }
--     }

--     -- local progressVal = op:ProgressCurrent()

--     return lines --, progressVal
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleEscape(sectorId, goodCop, badCop)
--     return {
--         headLine = T(08162319880486560821, "Escape"),
--         text = T(08162319880486560821, "We are still investigating how this could happen but the prisoner escaped!"),
--         remove = true
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleDeath(sectorId, goodCop, badCop)
--     local killer = HasPerk(badCop, "Psycho") and badCop or goodCop

--     local cities = gv_Cities

--     for cityName, city in pairs(cities) do
--         if city.Loyalty and city.Loyalty > 0 then
--             CityModifyLoyalty(cityName, -2)
--         end
--     end

--     return {
--         headLine = T(08162319880486560821081, "Prisoner Died"),
--         text = T { 081623198804865608212082, "Maybe it wasn't the best idea to let <killer> handle this interrogation. Now we lost loyalty in all cities.", killer = killer.Nick },
--         remove = true
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleHurt(sectorId, goodCop, badCop)
--     goodCop:AddWounds(1)

--     return {
--         headLine = T { 08162319880486560823083, "<interrogator> got hurt", { interrogator = goodCop.Nick } },
--         text = T { 08162319880486560824084, "The prisoner managed to hurt <interrogator>. We had to bring him back into his cell", { interrogator = goodCop.Nick } }
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleNothing(sectorId, goodCop, badCop)
--     return {
--         headLine = T(08162319880486560821085, "He didn't say anything"),
--         text = T(08162319880486560821086, "The prisoner didn't say anything. Maybe we will have more luck next time.")
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleIntel(sectorId, goodCop, badCop)
--     local discovered_in = {}
--     local intel_sectors = GetAvailableIntelSectors(sectorId)

--     local randSector = table.interaction_rand(intel_sectors, "Satellite")

--     Inspect(randSector)

--     if randSector then
--         DiscoverIntelForSector(randSector, false)
--     end

--     local sectorList = ConcatListWithAnd(table.map(discovered_in, function(o) return GetSectorName(gv_Sectors[o]); end))

--     return {
--         headLine = T(08162319880486560821087, "Got Intel"),
--         text = T { 08162319880486560821088, "We got some valuable intel from the prisoner about sector <sector>", sector = randSector },
--         remove = true
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleStash(sectorId, goodCop, badCop)
--     return {
--         headLine = T(08162319880486560821089, "Gave away his stash"),
--         text = T(081623198804865608210810, "The prisoner gave away the location of his secret stash."),
--         remove = true
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleRansom(sectorId, goodCop, badCop)

--     local money = InteractionRandRange(1000, 5000, "ransom")

--     AddMoney(money, "ransom",true)

--     return {
--         headLine = T(081623198804865608210811, "Got Ransom"),
--         text = T{081623198804865608210812,
--             "The prisoner told us that he has a rich family and we should contacted them for a ransom. We got <money>$ from them.", money = money },
--         remove = true
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleMilitia(sectorId, goodCop, badCop)
--     return {
--         headLine = T(081623198804865608210813, "Joined Militia"),
--         text = T(081623198804865608210814, "We could convince the prisoner to join our militia.")
--     }
-- end

-- function HUDA_MilitiaPOWInterrogation:HandleResult(outcome, sectorId, goodCop, badCop)
--     print("HUDA_MilitiaPOWInterrogation:HandleResult", outcome)

--     local result = nil

--     result = self:HandleDeath(sectorId, goodCop, badCop)

--     -- if outcome == "escape" then
--     --     result = self:HandleEscape(sectorId, goodCop, badCop)
--     -- elseif outcome == "death" then
--     --     result = self:HandleDeath(sectorId, goodCop, badCop)
--     -- elseif outcome == "hurt" then
--     --     result = self:HandleHurt(sectorId, goodCop, badCop)
--     -- elseif outcome == "intel" then
--     --     result = self:HandleIntel(sectorId, goodCop, badCop)
--     -- elseif outcome == "stash" then
--     --     result = self:HandleStash(sectorId, goodCop, badCop)
--     -- elseif outcome == "ransom" then
--     --     result = self:HandleRansom(sectorId, goodCop, badCop)
--     -- elseif outcome == "militia" then
--     --     result = self:HandleMilitia(sectorId, goodCop, badCop)
--     -- else
--     --     result = self:HandleNothing(sectorId, goodCop, badCop)
--     -- end

--     print("HUDA_MilitiaPOWInterrogation:HandleResult", result, sectorId)

--     if result.remove then
--         table.remove(gv_HUDA_CapturedPows[sectorId], 1)
--     end

--     return result
-- end

-- function HUDA_MilitiaPOWInterrogation:OnComplete(op, sector, mercs)
--     local goodCop = nil;
--     local badCop = nil;

--     for _, merc in ipairs(mercs) do
--         if merc.tempOperationProfession == "Goodcop" then
--             goodCop = merc
--         elseif merc.tempOperationProfession == "Badcop" then
--             badCop = merc
--         end
--     end

--     local goodCopRating = DivRound(goodCop.Leadership, 2)
--     local badCopRating = DivRound(badCop.Leadership, 2)

--     local goodCopPerks = goodCop:GetPerks()
--     local badCopPerks = badCop:GetPerks()

--     local perkRatings = {
--         Optimist = {
--             Good = 10,
--             Bad = -10,
--         },
--         Negotiator = {
--             Good = 40,
--             Bad = 0,
--         },
--         Scoundrel = {
--             Good = 20,
--             Bad = 20,
--         },
--         Spiritual = {
--             Good = -10,
--             Bad = -20,
--         },
--         Psycho = {
--             Good = -40,
--             Bad = 40,
--         },
--         Pessimist = {
--             Good = -10,
--             Bad = 10,
--         },
--         Loner = {
--             Good = -20,
--             Bad = -20,
--         }
--     }


--     for _, perk in ipairs(goodCopPerks) do
--         if perkRatings[perk.class] then
--             goodCopRating = goodCopRating + perkRatings[perk.class].Good
--         end
--     end

--     for _, perk in ipairs(badCopPerks) do
--         if perkRatings[perk.class] then
--             badCopRating = badCopRating + perkRatings[perk.class].Bad
--         end
--     end

--     local teamRating = goodCopRating + badCopRating

--     local successRoll = InteractionRandRange(30, 170, "Interrogation Success Roll")

--     local success = successRoll < teamRating

--     local successMargin = teamRating - successRoll

--     local outcome = nil

--     local goodOutcomes = {
--         "intel",
--         "stash",
--         "ransom",
--         "militia",
--     }

--     local badOutcomes = {
--         "nothing",
--         "hurt",
--         "escape",
--         "death",
--     }

--     if success then
--         local randMax = 2

--         if successMargin > 80 and goodCopRating > 100 then
--             randMax = 3
--         end

--         local rand = InteractionRand(randMax)

--         outcome = goodOutcomes[rand + 1]
--     else
--         local randMax = 0
--         local randMin = 0

--         if successMargin < -30 then
--             randMax = 2

--             if successMargin < -100 then
--                 randMin = 1
--             end

--             if HasPerk(goodCop, "Psycho") or HasPerk(badCop, "Psycho") then
--                 randMax = 3
--             end
--         end

--         local rand = InteractionRandRange(randMin, randMax, "Bad Outcome Roll")

--         outcome = badOutcomes[rand + 1]
--     end

--     local result = self:HandleResult(outcome, sector.Id, goodCop, badCop)

--     NetUpdateHash("CompleteCurrentMilitiaInterrorgation")
--     local eventId = g_MilitiaInterrogationCompleteCounter
--     g_MilitiaInterrogationCompleteCounter = g_MilitiaInterrogationCompleteCounter + 1
--     local start_time = Game.CampaignTime
--     CreateMapRealTimeThread(function()
--         local popupHost = GetDialog("PDADialogSatellite")
--         popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

--         local prisonersAvailable = #(gv_HUDA_CapturedPows[sector.Id] or {}) > 0

--         local buyAgainText = prisonersAvailable and
--             T { 08164602612170816, "Do you want interrogate the next prisoner? (<left> left)", { left = #gv_HUDA_CapturedPows[sector.Id] } } or
--             T { 08164602612170817, "There are no more prisoners to interrogate." }

--         local dlg = CreateQuestionBox(
--             popupHost,
--             result.headLine,
--             result.text,
--             T(689884995409, "Yes"),
--             T(782927325160, "No"),
--             { sector = sector, mercs = mercs, textLower = buyAgainText },
--             function()
--                 return prisonersAvailable and "enabled" or "disabled"
--             end,
--             nil,
--             "POPUPMilitiaPOWInterrogation")

--         assert(g_MilitiaInterrogationCompletePopups[eventId] == nil)
--         g_MilitiaInterrogationCompletePopups[eventId] = dlg
--         NetSyncEvent("ProcessMilitiaInterrogationPopupResults", dlg:Wait(), eventId, sector.Id,
--             UnitDataToSessionIds(mercs), start_time)
--         g_MilitiaInterrogationCompletePopups[eventId] = nil
--     end)
-- end

-- function NetSyncEvents.ProcessMilitiaInterrogationPopupResults(result, event_id, sector_id, mercs, start_time)
--     if result == "ok" then
--         local sector = gv_Sectors[sector_id]
--         if sector.started_operations["HUDA_MilitiaInterrogation"] ~= start_time then --other player already started it
--             for _, merc in ipairs(mercs) do
--                 local mercT = gv_UnitData[merc]
--                 NetSyncEvents.MercSetOperation(merc, "HUDA_MilitiaInterrogation",
--                     mercT.tempOperationProfession == "Goodcop" and "Goodcop" or "Badcop", nil, 1, false)
--                 mercT.tempOperationProfession = nil
--             end
--             NetSyncEvents.LogOperationStart("HUDA_MilitiaInterrogation", sector.Id, "log")
--             NetSyncEvents.StartOperation(sector.Id, "HUDA_MilitiaInterrogation", start_time, sector.training_stat)
--         end
--     end
--     if g_MilitiaInterrogationCompletePopups[event_id] then
--         g_MilitiaInterrogationCompletePopups[event_id]:Close()
--         g_MilitiaInterrogationCompletePopups[event_id] = nil
--     end
-- end
