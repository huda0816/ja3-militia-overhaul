if FirstLoad then
    for _, v in ipairs(CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDAFinances"], "comment", "burn rate", "first_on_branch")) do
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
                    local value = HUDA_MilitiaFinances:GetMilitiaUpkeep() or 0
                    local text = T({
                        812946341374,
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

    for _, v in ipairs(CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDAMoneyRollover"], "comment", "burn", "first_on_branch")) do
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
                local burnRate = HUDA_MilitiaFinances:GetMilitiaUpkeep() or 0
                local text = T({
                    105101286891,
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
end -- FirstLoad

HUDA_OriginalGetMercCurrentDailySalary = GetMercCurrentDailySalary

function GetMercCurrentDailySalary(id)
    local unitData = gv_UnitData[id]

    if unitData.militia then
        return HUDA_MilitiaFinances:GetSalary(unitData)
    end

    return HUDA_OriginalGetMercCurrentDailySalary(id)
end

HUDA_OriginalGetMoneyProjection = GetMoneyProjection

function GetMoneyProjection(days)
    local money = HUDA_OriginalGetMoneyProjection(days)

    local upkeep = HUDA_MilitiaFinances:GetMilitiaUpkeep(days)
    return money - upkeep
end

local HUDA_DailyCosts = 0

function HUDA_UpdateDailyCosts()
    local upkeep = HUDA_MilitiaFinances:GetMilitiaUpkeep()
    local dailyIncome = GetDailyIncome()
    local burnRate = GetBurnRate(1)
    HUDA_DailyCosts = dailyIncome - burnRate - upkeep
end

function OnMsg.NewHour()
    HUDA_UpdateDailyCosts()
end

function TFormat.GetDailyMoneyChange()
    return T({
        780491782250,
        "<moneyWithSign(amount)>",
        amount = HUDA_DailyCosts
    })
end

function OnMsg.NewDay()
    HUDA_MilitiaFinances:PayUpkeep()
end

DefineClass.HUDA_MilitiaFinances = {
    MilitiaRookieIncome = HUDA_GetModOptions("MilitiaRookieIncome", 20),
    MilitiaVeteranIncome = HUDA_GetModOptions("MilitiaVeteranIncome", 40),
    MilitiaEliteIncome = HUDA_GetModOptions("MilitiaEliteIncome", 100),
    MilitiaCampaignCosts = HUDA_GetModOptions("MilitiaCampaignCosts", 40),
}

function HUDA_MilitiaFinances:UpdateProps(prop_name, value)
    local property_name = prop_name:gsub("huda_", "")
    self[property_name] = value
end

function HUDA_MilitiaFinances:GetSalary(unit, days)
    days = days or 1

    local base_salary = 0

    if unit.class == "MilitiaRookie" then
        base_salary = self.MilitiaRookieIncome * days
    elseif unit.class == "MilitiaVeteran" then
        base_salary = self.MilitiaVeteranIncome * days
    elseif unit.class == "MilitiaElite" then
        base_salary = self.MilitiaEliteIncome * days
    end

    return base_salary + self:AddCampaignBonus(unit)
end

function HUDA_MilitiaFinances:GetDailyCostsPerSquad(squad)
    local upkeep = 0

    for _, unitId in pairs(squad.units) do
        local unit = gv_UnitData[unitId]

        if unit.militia then
            upkeep = upkeep + self:GetSalary(unit)
        end
    end

    return round(upkeep,1)
end

function HUDA_MilitiaFinances:GetMilitiaUpkeep(days)
    local militia_units = table.filter(gv_UnitData, function(k, v)
        return v.militia and v.Squad
    end)

    local upkeep = 0

    local rookies = 0
    local veterans = 0
    local elites = 0

    for _, unit in pairs(militia_units) do
        if unit.class == "MilitiaRookie" then
            upkeep = upkeep + tonumber(self.MilitiaRookieIncome)
            rookies = rookies + 1
        elseif unit.class == "MilitiaVeteran" then
            upkeep = upkeep + tonumber(self.MilitiaVeteranIncome)
            veterans = veterans + 1
        elseif unit.class == "MilitiaElite" then
            upkeep = upkeep + tonumber(self.MilitiaEliteIncome)
            elites = elites + 1
        end

        upkeep = upkeep + self:AddCampaignBonus(unit)
    end

    return upkeep * (days or 1), rookies, veterans, elites
end

function HUDA_MilitiaFinances:AddCampaignBonus(unit)
    local unit_squad = gv_Squads[unit.Squad]

    if not unit_squad then
        return 0
    end

    local squad_distance, closest_sector = HUDA_GetShortestDistanceToCityAndBases(unit_squad.CurrentSector)

    if not closest_sector or not squad_distance or squad_distance < 2 then
        return 0
    end

    local travel_time, water_sectors = HUDA_GetSupplyTravelInfo(closest_sector, unit_squad.CurrentSector)

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
