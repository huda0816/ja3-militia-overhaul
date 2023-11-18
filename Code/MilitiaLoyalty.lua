GameVar("gv_HUDA_NeededMilitia", {})

function OnMsg.NewDay()
    HUDA_CheckCityOccupation()
end

-- A city needs at least 4 militia or player units per sector to not loose loyalty. A city can loose maximum 3% loyalty per day.

function HUDA_CheckCityOccupation()

    if HUDA_GetModOptions("MilitiaNoLoyaltyLoss", false) then
        return
    end

    local cities = gv_Cities
    local sectors = gv_Sectors

    for k, city in pairs(cities) do
        local city_sectors = HUDA_GetControlledCitySectors(k)

        if city_sectors and #city_sectors > 0 and city.Loyalty > 30 then
            local militia_count = 0

            for i, value in ipairs(city_sectors) do
                local sector = gv_Sectors[value]

                if sector then
                    local squads = sector.ally_and_militia_squads

                    for i, squad in ipairs(squads) do
                        militia_count = militia_count + #squad.units
                    end
                end
            end

            local needed_militia = #city_sectors * 4
            
            local loyalty_loss = 0

            if militia_count == 0 then
                loyalty_loss = 3
            else
                local percentage = MulDivRound(militia_count, 100, needed_militia)

                if percentage < 50 then
                    loyalty_loss = 2
                elseif percentage < 100 then
                    loyalty_loss = 1
                end
            end

            if loyalty_loss > 0 then
                CityModifyLoyalty(k, loyalty_loss * -1, Untranslated("Not enough militia guarding the city"))
            end
        end
    end
end


function HUDA_GetNeededMilitiaSoldiers(cityId)

    local neededSoldiers, currentSoldiers = 0, 0

    local city_sectors = HUDA_GetControlledCitySectors(cityId)

    if city_sectors and #city_sectors > 0 then
        for i, value in ipairs(city_sectors) do
            local sector = gv_Sectors[value]

            if sector then
                local squads = sector.ally_and_militia_squads

                for i, squad in ipairs(squads) do
                    currentSoldiers = currentSoldiers + #squad.units
                end
            end
        end

        neededSoldiers = #city_sectors * 4
    end

    return neededSoldiers, currentSoldiers
end

function TFormat.cityLoyaltyConditional(ctx, cityId)
	local loyalty = GetCityLoyalty(cityId)
    if not gv_PlayerCityCounts or not gv_PlayerCityCounts.cities or not gv_PlayerCityCounts.cities[cityId] then
		return false
	end
    local neededSoldiers, currentSoldiers = HUDA_GetNeededMilitiaSoldiers(cityId)

	return Untranslated(" (" .. tostring(loyalty) .. "%)" .. "\n" .. tostring(currentSoldiers) .. "/" .. tostring(neededSoldiers) .." Soldiers")
end
