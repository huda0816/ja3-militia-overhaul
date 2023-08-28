DefineClass.HUDA_MilitiaPersonalization = {}

function HUDA_MilitiaPersonalization:Personalize(unit_ids)
    local units = {}

    local unit_data = gv_UnitData

    if not unit_ids then
        units = unit_data and table.filter(unit_data, function(k, v) return v.militia end) or {}
    else
        units = table.filter(unit_data, function(k, v) return v.militia and HUDA_ArrayContains(unit_ids, k) end)
    end

    if units then
        for k, unit in pairs(units) do
            local gunit = g_Units[unit.session_id]

            if not unit.Nick then
                local nick = self:GetRandomMilitiaName()

                unit.Nick = nick
                unit.AllCapsNick = string.upper(nick)
                unit.snype_nick = "Militia " .. nick

                if gunit then
                    gunit.Nick = unit.Nick
                    gunit.AllCapsNick = unit.AllCapsNick
                    gunit.snype_nick = unit.snype_nick
                end
            end

            if not unit.JoinDate then
                unit.JoinDate = Game.CampaignTime

                if gunit then
                    gunit.JoinDate = unit.JoinDate
                end
            end

            if not unit.JoinLocation then
                unit.JoinLocation = HUDA_GetSector(unit)

                if gunit then
                    gunit.JoinLocation = unit.JoinLocation
                end
            end

            if not unit.Specialization or unit.Specialization == "None" then
                unit.Specialization = self:GetSpecialization(unit)

                if gunit then
                    gunit.Specialization = unit.Specialization
                end
            end

            if not unit.Bio and unit.Nick then
                unit.Bio = self:GetRandomBio(unit)

                if gunit then
                    gunit.Bio = unit.Bio
                end
            end

            if not unit.StatsRandomized then
                self:RandomizeStats(unit)
            end

            unit:AddStatusEffect("GCMilitia")

            if gunit then
                gunit:AddStatusEffect("GCMilitia")
            end
        end

        ObjModified("ui_player_squads")
    end
end

function HUDA_MilitiaPersonalization:GetRandomMilitiaName()
    local rand = InteractionRand(#HUDA_male_militia_names)

    rand = rand > 0 and rand or 1

    return HUDA_male_militia_names[rand]
end

function HUDA_MilitiaPersonalization:GetRandomMilitiaSquadName()
    local available_names = HUDA_GetAvailableSquadNames()

    local rand = InteractionRand(#available_names)

    rand = rand > 0 and rand or 1

    local name = available_names[rand]

    local filtered = table.filter(available_names, function(k, v)
        return k ~= rand
    end)

    HUDA_SetAvailableSquadNames(filtered)

    return name
end

function HUDA_MilitiaPersonalization:GetRandomBio(unit)
    local bios = self:GetBios(unit)

    if #bios == 0 then
        return
    end

    local rand = InteractionRand(#bios)

    rand = rand > 0 and rand or 1

    local bio = bios[rand]

    local filtered = table.filter(bios, function(k, v)
        return k ~= rand
    end)

    self:RemoveBios(unit, filtered)

    if not bio then
        return
    end

    return string.gsub(bio, "<name>", unit.Nick)
end

function HUDA_MilitiaPersonalization:GetBios(unit)
    return HUDA_GetAvailableBios(unit.Specialization)
end

function HUDA_MilitiaPersonalization:RemoveBios(unit, filtered)
    HUDA_SetAvailableBios(unit.Specialization, filtered)
end

function HUDA_MilitiaPersonalization:GetRandomSquadName(sector_id)
    return sector_id .. " - " .. self:GetRandomMilitiaSquadName()
end

function HUDA_MilitiaPersonalization:GetSpecialization(unit)
    local squad = gv_Squads[unit.Squad]

    if not squad then
        return "AllRounder"
    end

    local squad_index = HUDA_keyOf(squad.units, unit.session_id)

    if squad_index == 1 then
        return "Leader"
    elseif squad_index == 4 then
        return "Doctor"
    elseif squad_index == 5 then
        return "ExplosiveExpert"
    elseif squad_index == 6 then
        return "Marksmen"
    elseif squad_index == 7 then
        return "Mechanic"
    else
        return "AllRounder"
    end
end

function HUDA_MilitiaPersonalization:RandomizeStats(unit)
    local gunit = g_Units[unit.session_id]

    local defaults = {
        Health = 65,
        Agility = 65,
        Strength = 65,
        Wisdom = 50,
        Leadership = 20,
        Marksmanship = 60,
        Mechanical = 20,
        Explosives = 20,
        Medical = 20,
        Dexterity = 60,
    }

    if unit.Specialization == "Leader" then
        defaults.Leadership = 60
    elseif unit.Specialization == "Doctor" then
        defaults.Medical = 60
    elseif unit.Specialization == "ExplosiveExpert" then
        defaults.Explosives = 60
    elseif unit.Specialization == "Marksmen" then
        defaults.Marksmanship = 75
    elseif unit.Specialization == "Mechanic" then
        defaults.Mechanical = 60
    end

    for k, v in pairs(defaults) do
        if unit.class == "MilitiaVeteran" then
            v = v + 5
        elseif unit.class == "MilitiaElite" then
            v = v + 10
        end

        unit['base_' .. k] = Min(100, InteractionRandRange(v - 6, v + 6))
        unit[k] = unit['base_' .. k]

        if k == "Health" then
            unit.HitPoints = unit[k]
            unit.MaxHitPoints = unit[k]
        end

        if gunit then
            gunit['base_' .. k] = unit['base_' .. k]
            gunit[k] = unit[k]

            if k == "Health" then
                gunit.HitPoints = unit[k]
                gunit.MaxHitPoints = unit[k]
            end
        end
    end

    unit.StatsRandomized = true

    if gunit then
        gunit.StatsRandomized = true
    end
end

function HUDA_MilitiaPersonalization:PersonalizeSquad(squad_id)
    local filteredSquads = table.filter(gv_Squads, function(k, v) return v.UniqueId == squad_id end)

    local squad_ids = HUDA_TableColumn(filteredSquads, "UniqueId")

    self:PersonalizeSquads(squad_ids)
end

function HUDA_MilitiaPersonalization:PersonalizeSquads(squad_ids)
    local militaSquads

    if not squad_ids then
        militaSquads = table.filter(gv_Squads, function(k, v) return v.militia end)
    else
        militaSquads = table.filter(gv_Squads, function(k, v) return v.militia and HUDA_ArrayContains(squad_ids, k) end)
    end

    if militaSquads then
        for k, squad in pairs(militaSquads) do
            if (squad.Side == "ally") then
                squad.OriginalSide = "ally"
                squad.Side = "player1"
                squad.image = ""
            end

            if not squad.BornInSector then
                squad.BornInSector = squad.CurrentSector
            end

            if not squad.Name or squad.Name == "MILITIA" or IsT(squad.Name) then
                squad.Name = self:GetRandomSquadName(squad.CurrentSector)
            end
        end
    end
end
