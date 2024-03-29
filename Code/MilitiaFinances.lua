function OnMsg.DataLoaded()
    for _, v in ipairs(HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["PDAFinances"], "comment", "burn rate", "first_on_branch")) do
        table.insert(v.ancestors[1], v.indices[1] + 1, PlaceObj("XTemplateWindow", {
            "comment",
            "militia upkeep",
            "LayoutMethod",
            "HList"
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Dock",
                "left",
                "TextStyle",
                "PDA_FinancesText",
                "Translate",
                true,
                "Text",
                Untranslated("Militia")
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Dock",
                "right",
                "TextStyle",
                "PDA_FinancesText",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                    local value = gv_HUDA_MilitiaFinances.dailyUpkeep or 0
                    local text = T({
                        999812946341374,
                        "<style PDA_FinancesValueText><money(value)></style>/Day",
                        value = value
                    })
                    self:SetText(text)
                end,
                "Translate",
                true
            })
        })
        )
    end

    for _, v in ipairs(HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["PDAMoneyRollover"], "comment", "burn", "first_on_branch")) do
        v.ancestors[1][5].GridY = 4
        v.ancestors[1][6].GridY = 4

        table.insert(v.ancestors[1], PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridX",
            2,
            "GridY",
            3,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
                local burnRate = gv_HUDA_MilitiaFinances.dailyUpkeep or 0
                local text = T({
                    999105101286891,
                    "<money(burnRate)>/Day",
                    burnRate = burnRate
                })
                self:SetText(text)
            end,
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
        })
        )

        table.insert(v.ancestors[1], PlaceObj("XTemplateWindow", {
            "comment",
            "militia",
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridY",
            3,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            Untranslated("Militia"),
            "HideOnEmpty",
            true
        })
        )
    end
end

HUDA_OriginalGetMercCurrentDailySalary = GetMercCurrentDailySalary

function GetMercCurrentDailySalary(id)
    local unitData = gv_UnitData[id]

    if unitData.militia then
        return HUDA_MilitiaFinances:GetSalary(unitData, 1, true)
    end

    return HUDA_OriginalGetMercCurrentDailySalary(id)
end

HUDA_OriginalGetMoneyProjection = GetMoneyProjection

function GetMoneyProjection(days)
    local money = HUDA_OriginalGetMoneyProjection(days)

    local upkeep = (gv_HUDA_MilitiaFinances.dailyUpkeep or 0) * days
    return money - upkeep
end

local HUDA_DailyCosts = 0

function HUDA_UpdateDailyCosts()
    local upkeep = gv_HUDA_MilitiaFinances.dailyUpkeep or 0
    local dailyIncome = GetDailyIncome()
    local burnRate = GetBurnRate(1)
    HUDA_DailyCosts = dailyIncome - burnRate - upkeep
end

function OnMsg.NewHour()
    HUDA_UpdateDailyCosts()
end

function TFormat.GetDailyMoneyChange()
    return T({
        999780491782250,
        "<moneyWithSign(amount)>",
        amount = HUDA_DailyCosts
    })
end

function OnMsg.NewDay()
    gv_HUDA_MilitiaFinances.dailyUpkeep = nil
    gv_HUDA_MilitiaFinances.squadsUpkeep = {}
    HUDA_MilitiaFinances:PayUpkeep()
    HUDA_UpdateDailyCosts()
end

GameVar("gv_HUDA_MilitiaFinances", {})

DefineClass.HUDA_MilitiaFinances = {
    MilitiaRookieIncome = HUDA_GetModOptions("MilitiaRookieIncome", 20, "number"),
    MilitiaVeteranIncome = HUDA_GetModOptions("MilitiaVeteranIncome", 40, "number"),
    MilitiaEliteIncome = HUDA_GetModOptions("MilitiaEliteIncome", 100, "number"),
    MilitiaCampaignCosts = HUDA_GetModOptions("MilitiaCampaignCosts", 40, "number"),
}

function HUDA_MilitiaFinances:UpdateProps(prop_name, value)
    local property_name = prop_name:gsub("huda_", "")
    self[property_name] = tonumber(string.match(value, "%d+"))
end

function HUDA_MilitiaFinances:GetSalary(unit, days, campaignBonus)
    days = days or 1

    local base_salary = 0

    if unit.class == "MilitiaRookie" then
        base_salary = tonumber(self.MilitiaRookieIncome) * days
    elseif unit.class == "MilitiaVeteran" then
        base_salary = tonumber(self.MilitiaVeteranIncome) * days
    elseif unit.class == "MilitiaElite" then
        base_salary = tonumber(self.MilitiaEliteIncome) * days
    end

    if campaignBonus then
        base_salary = base_salary + self:AddCampaignBonus(unit)
    end

    return base_salary
end

function HUDA_MilitiaFinances:GetDailyCostsPerSquad(squad)
    local upkeep = 0

    if gv_HUDA_MilitiaFinances.squadsUpkeep and gv_HUDA_MilitiaFinances.squadsUpkeep[squad.UniqueId] then
        return gv_HUDA_MilitiaFinances.squadsUpkeep[squad.UniqueId]
    end

    local campaignBonus = self:GetCampaignBonus(squad.UniqueId)

    for _, unitId in pairs(squad.units) do
        local unit = gv_UnitData[unitId]

        if unit.militia then
            upkeep = upkeep + self:GetSalary(unit)
        end

        upkeep = upkeep + campaignBonus
    end

    upkeep = round(upkeep, 1)

    gv_HUDA_MilitiaFinances.squadsUpkeep = gv_HUDA_MilitiaFinances.squadsUpkeep or {}

    gv_HUDA_MilitiaFinances.squadsUpkeep[squad.UniqueId] = upkeep

    return upkeep
end

function HUDA_MilitiaFinances:GetMilitiaUpkeep(days, force)
    if not force and gv_HUDA_MilitiaFinances.dailyUpkeep then
        return gv_HUDA_MilitiaFinances.dailyUpkeep * (days or 1)
    end

    local militia_squads = table.filter(gv_Squads, function(k, v)
        return v.militia
    end)

    local upkeep = 0

    local rookies = 0
    local veterans = 0
    local elites = 0

    for _, squad in pairs(militia_squads) do
        local campaignBonus = self:GetCampaignBonus(squad.UniqueId)

        local militia_units = table.filter(gv_UnitData, function(k, v)
            return v.militia and v.Squad == squad.UniqueId
        end)

        for _, unit in pairs(militia_units) do
            upkeep = upkeep + self:GetSalary(unit)

            if unit.class == "MilitiaRookie" then
                rookies = rookies + 1
            elseif unit.class == "MilitiaVeteran" then
                veterans = veterans + 1
            elseif unit.class == "MilitiaElite" then
                elites = elites + 1
            end

            upkeep = upkeep + campaignBonus
        end
    end

    gv_HUDA_MilitiaFinances.dailyUpkeep = upkeep

    return upkeep * (days or 1), rookies, veterans, elites
end

function HUDA_MilitiaFinances:AddCampaignBonus(unit)
    return self:GetCampaignBonus(unit.Squad)
end

function HUDA_MilitiaFinances:GetCampaignBonus(squadId)

    local squad = gv_Squads[squadId]

    if not squad then
        return 0
    end

    local squad_distance, closest_sector = HUDA_GetShortestDistanceToCityAndBases(squad.CurrentSector)

    gv_Squads[squadId].SupplyBase = closest_sector

    if not closest_sector or not squad_distance or squad_distance < 2 then
        return 0
    end

    local travel_time, water_sectors = HUDA_GetSupplyTravelInfo(closest_sector, squad.CurrentSector)

    local water_price = water_sectors and #water_sectors * DivRound(self.MilitiaCampaignCosts, 10) or 0

    local price = DivRound(travel_time, 3600) * DivRound(self.MilitiaCampaignCosts, 20) + water_price

    return price
end

function HUDA_MilitiaFinances:PayUpkeep()
    local upkeep, rookies, veterans, elites = self:GetMilitiaUpkeep()

    if upkeep > 0 then
        AddMoney(-upkeep, "Militia upkeep", true)
        self:NotifyPayment(upkeep, rookies, veterans, elites)
    end
end

function HUDA_MilitiaFinances:NotifyPayment(upkeep, rookies, veterans, elites)
    CombatLog("important", T({
        Untranslated(
            "<em><upkeep>$</em>  militia upkeep paid for <em><rookies></em> rookies, <em><veterans></em> veterans and <em><elites></em> elites"),
        upkeep = upkeep,
        rookies = rookies,
        veterans = veterans,
        elites = elites
    }))
end
