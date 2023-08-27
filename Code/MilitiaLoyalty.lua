function OnMsg.NewDay()
    HUDA_CheckCityOccupation()
end

-- A city needs at least 4 militia or player units per sector to not loose loyalty. A city can loose maximum 3% loyalty per day.

function HUDA_CheckCityOccupation()
    local cities = gv_Cities
    local sectors = gv_Sectors

    for k, city in pairs(cities) do
        local city_sectors = HUDA_GetControlledCitySectors(k)

        print("city", k, "sectors", city_sectors)

        if city_sectors and #city_sectors > 0 then
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

function HUDA_GetControlledCitySectors(city)
    local sectors = GetCitySectors(city)

    if sectors then
        local controlled_sectors = table.filter(sectors, function(i, v)
            local sector = gv_Sectors[v]
            return sector and (sector.Side == "player1" or sector.Side == "player2")
        end)

        return HUDA_ReindexTable(controlled_sectors)
    end
end
