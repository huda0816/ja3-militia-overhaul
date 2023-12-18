-- backgrounds: Student, Rich Kid, Revolutionary, ExLegion, ExArmy, SlumKid, ExCriminal, ExCop, Doctor/Nurse, Worker, Miner, Farmer, Teacher, Journalist, Refugee, ExGangMember, Prominent, Athlete

-- Prominent
-- very rare
-- Location: Everywhere
-- Equipment: Up to tier 3
-- Equipment: 2x Armor, 1x Firearm
-- Special: Increases militia popularity in GC. Everytime someone dies in the squad the prominent has to roll to stay in the militia.
-- Loyalty: medium
-- Possible Specialization: Leader

-- Athlete
-- very rare
-- Location: Everywhere
-- Equipment: Up to tier 2
-- Equipment: 1x Armor, 1x Firearm
-- Special: Higher Dexterity, Higher Agility, Higher Strength
-- Loyalty: medium
-- Possible Specialization: none

-- Student
-- common
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Weapon and 1x Armor
-- Special: Lower stats. Everytime someone dies in the squad the student has to roll to stay in the militia.
-- Loyalty: medium
-- Possible Specialization: ExplosiveExpert

-- Refugee
-- common
-- Location: Refugee Camp
-- Equipment: Up to tier 1
-- Equipment: 1x Melee or 1x Handgun
-- Special: Only recruitable in refugee camp
-- Loyalty: high
-- Possible Specialization: none

-- Journalist
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Handgun
-- Special: Higher wisdom stats, Rolls everyday to increase loyalty in the town he is in.
-- Loyalty: medium
-- Possible Specialization: Leader

-- Teacher
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Armor, 1x Handgun
-- Special: Higher wisdom and leadership stats
-- Loyalty: medium
-- Possible Specialization: Leader

-- Farmer
-- common
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Melee, 1x Armor
-- Special: Higher strength stats
-- Loyalty: medium
-- Possible Specialization: none

-- Miner
-- common
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Explosives
-- Special: Higher Explosives skill
-- Loyalty: medium
-- Possible Specialization: ExplosiveExpert

-- Worker
-- common
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Melee or 1x Handgun
-- Special: Higher mechanic skill
-- Loyalty: medium
-- Possible Specialization: Mechanic

-- Doctor/Nurse
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Armor, 1x medkit
-- Special: Higher medical skill
-- Loyalty: medium
-- Possible Specialization: Doctor

-- ExCop
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 2
-- Equipment: 1x Handgun, 1x Armor
-- Special: Higher stats, Doesn't like to be in the same squad as criminals (ExCriminal, ExGangMember, ExLegion) roll to stay in the squad if there is a criminal in the squad.
-- Loyalty: medium
-- Possible Specialization: Leader, Marksmen

-- ExCriminal
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 2
-- Equipment: 1x Firearm, 1x Melee
-- Special: Can steal money from the militia. (Someone stole money in sector ..)
-- Loyalty: low
-- Possible Specialization: ExplosiveExpert

-- RichKid
-- rare
-- Location: Pantagruel, Post Cacao
-- Special: Fully equipped
-- Equipment: Up to tier 3
-- Equipment: 2x Armor, 1x Firearm
-- Special: Lower stats. Everytime someone dies in the squad the rich kid has to roll to stay in the militia.
-- Loyalty: medium
-- Possible Specialization: none

-- Revolutionary
-- common
-- Location: Pantagruel
-- Equipment: Up to tier 2
-- Equipment: 1x Armor, 1x Firearm
-- Special: Only joins if you do not break with communists, will quit if you break with communists
-- Loyalty: high
-- Possible Specialization: Leader

-- ExLegion
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Armor, 1x Handgun or 1x Melee
-- Special: Is not affected by morale loss in battle, can betray you and join the enemy
-- Loyalty: low
-- Possible Specialization: none

-- ExGangMember
-- rare
-- Location: Everywhere
-- Equipment: Up to tier 1E
-- Equipment: 1x Melee
-- Special: There is a chance that the gang member will obtain a item (xy obtained a new ... we are not sure where he got it from but loyalty decreased)
-- Loyalty: low
-- Possible Specialization: none

-- ExArmy
-- very rare
-- Location: Everywhere
-- Equipment: Up to tier 2
-- Equipment: 1x Armor, 1x Firearm
-- Special: Higher stats and higher morale in battle
-- Loyalty: medium
-- Possible Specialization: Marksmen, ExplosiveExpert

-- SlumKid
-- common
-- Location: Everywhere
-- Equipment: Up to tier 1
-- Equipment: 1x Melee
-- Special: Will find items in the sector
-- Loyalty: high
-- Possible Specialization: none



local hasJoinlocation = false
local hasJoindate = false
local hasStatsRandomized = false
local hasHandledEquipment = false
local hasOldSessionIds = false
local hasArcheType = false
for _, prop in ipairs(UnitProperties.properties) do
    if prop.id == 'JoinLocation' then
        hasJoinlocation = true
    end
    if prop.id == 'JoinDate' then
        hasJoindate = true
    end
    if prop.id == 'StatsRandomized' then
        hasStatsRandomized = true
    end
    if prop.id == 'HandledEquipment' then
        hasHandledEquipment = true
    end
    if prop.id == 'OldSessionIds' then
        hasOldSessionIds = true
    end
    if prop.id == 'ArcheType' then
        hasArcheType = true
    end
end

if not hasJoinlocation then
    UnitProperties.properties[#UnitProperties.properties + 1] = {
        category = "General",
        id = "JoinLocation",
        editor = "text",
        default = "",
    }
end

if not hasJoindate then
    UnitProperties.properties[#UnitProperties.properties + 1] = {
        category = "General",
        id = "JoinDate",
        editor = "number",
        default = 0,
    }
end

if not hasStatsRandomized then
    UnitProperties.properties[#UnitProperties.properties + 1] = {
        category = "General",
        id = "StatsRandomized",
        editor = "boolean",
        default = false,
    }
end

if not hasHandledEquipment then
    UnitProperties.properties[#UnitProperties.properties + 1] = {
        category = "General",
        id = "HandledEquipment",
        editor = "boolean",
        default = false,
    }
end

if not hasOldSessionIds then
    SatelliteSquad.properties[#SatelliteSquad.properties + 1] = {
        category = "General",
        id = "OldSessionIds",
        editor = "string_list",
        default = {},
    }
end

if not hasArcheType then
    SatelliteSquad.properties[#SatelliteSquad.properties + 1] = {
        category = "General",
        id = "ArcheType",
        editor = "text",
        default = {},
    }
end

local hasSquadBornIn = false

local hasSquadSupplyBase = false

for _, prop in ipairs(SatelliteSquad.properties) do
    if prop.id == 'BornInSector' then
        hasSquadBornIn = true
    end
    if prop.id == 'SupplyBase' then
        hasSquadSupplyBase = true
    end
end

if not hasSquadBornIn then
    SatelliteSquad.properties[#SatelliteSquad.properties + 1] = {
        category = "General",
        id = "BornInSector",
        editor = "text",
        default = "",
    }
end

if not hasSquadSupplyBase then
    SatelliteSquad.properties[#SatelliteSquad.properties + 1] = {
        category = "General",
        id = "SupplyBase",
        editor = "text",
        default = "",
    }
end

DefineClass.HUDA_MilitiaPersonalization = {
    archetypes = {
        prominent = {
            weight = -10,
            max = 1,
            equipment = {
                { category = "Weapons", tier = 3,               subCategories = { "SubmachineGuns", "AssaultRifles", "Handguns" }, condition = "almostNew", chance = 100, ammo = "high" },
                { category = "Armor",   subCategory = "Helmet", tierRange = { 2, 3 },                                              condition = "almostNew", chance = 100 },
                { category = "Armor",   subCategory = "Armor",  tierRange = { 2, 3 },                                              condition = "almostNew", chance = 100 },
            }
        },
        athlete = {
            weight = 5,
            equipment = {
                { category = "Weapons", tier = 2,               condition = "almostNew", chance = 100,            ammo = "medium" },
                { category = "Armor",   subCategory = "Helmet", tierRange = { 1, 2 },    condition = "almostNew", chance = 100 },
                { category = "Armor",   subCategory = "Armor",  tierRange = { 1, 2 },    condition = "almostNew", chance = 100 },
            }
        },
        student = {
            weight = 100,
            equipment = {
                { category = "Weapons", subCategories = { "Handguns" },        tier = 1, ammo = "low" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" }, tier = 1 },
            }
        },
        refugee = {
            weight = 100,
            citiesExclusive = { "Refugee Camp" },
            equipment = {
                { category = "Weapons", subCategories = { "MeleeWeapons", "Handguns" }, tier = 1, ammo = "low" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" },          tier = 1, },
            }
        },
        journalist = {
            weight = 5,
            equipment = {
                { category = "Weapons", subCategories = { "Handguns" },        tier = 1, condition = "good", ammo = "low" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" }, tier = 1, condition = "good", },
            }
        },
        teacher = {
            weight = 5,
            equipment = {
                { category = "Weapons", subCategories = { "Handguns" },        tier = 1, condition = "good", ammo = "medium" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" }, tier = 1, condition = "good", },
            }
        },
        farmer = {
            weight = 100,
            equipment = {
                { category = "Weapons", subCategories = { "MeleeWeapons" },       tierRange = { 1, 2 } },
                { category = "Weapons", subCategories = { "Shotguns", "Rifles" }, tier = 1,            chance = 50, ammo = "low" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" },    tier = 1, },
            }
        },
        miner = {
            weight = 100,
            equipment = {
                { category = "Weapons", subCategories = { "Shotguns", "SubmachineGuns", "AssaultRifles", "Handguns" }, tier = 1, ammo = "low" },
                { category = "Weapons", subCategories = { "Grenade" },                                                 tier = 1, },
                { category = "Armor",   subCategories = { "Armor", "Helmet" },                                         tier = 1, },
            }
        },
        worker = {
            weight = 100,
            equipment = {
                { category = "Weapons", subCategories = { "Shotguns", "SubmachineGuns", "AssaultRifles", "Handguns" }, tier = 1, ammo = "low" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" },                                         tier = 1, },
            }
        },
        doctor = {
            weight = 5,
            equipment = {
                { category = "Weapons",  subCategories = { "Handguns", "SubmachineGuns" }, tier = 2,             condition = "good", ammo = "medium" },
                { category = "Armor",    subCategories = { "Armor", "Helmet" },            tierRange = { 1, 2 }, condition = "good", },
                { category = "Medicine", tier = 1,                                         condition = "good", },
            }
        },
        exCop = {
            weight = 5,
            equipment = {
                { category = "Weapons", subCategories = { "Handguns", "Shotguns" }, tier = 2,             condition = "good", ammo = "medium" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" },      tierRange = { 1, 2 }, condition = "good", },
            }
        },
        exCriminal = {
            weight = 5,
            equipment = {
                { category = "Weapons", subCategories = { "Handguns" },     tierRange = { 1, 2 }, condition = "good", ammo = "medium" },
                { category = "Weapons", subCategories = { "MeleeWeapons" }, tier = { 1 },         condition = "good" },
            }
        },
        richKid = {
            weight = -5,
            cities = { "Port Cacao", "Pantagruel" },
            equipment = {
                { category = "Weapons", tier = 2,               subCategories = { "AssaultRifles" }, condition = "almostNew", chance = 100, ammo = "high" },
                { category = "Weapons", tierRange = { 1, 2 },   subCategories = { "Handguns" },      condition = "almostNew", ammo = "high" },
                { category = "Armor",   subCategory = "Helmet", tier = 2,                            condition = "almostNew", chance = 100 },
                { category = "Armor",   subCategory = "Armor",  tier = 2,                            condition = "almostNew", chance = 100 },
            }
        },
        revolutionary = {
            weight = 100,
            cities = { "Pantagruel" },
            equipment = {
                { category = "Weapons", tier = 1,               subCategories = { "SubmachineGuns", "AssaultRifles" }, condition = "almostNew", chance = 100, ammo = "high" },
                { category = "Armor",   subCategory = "Helmet", tier = 1,                                              condition = "almostNew" },
                { category = "Armor",   subCategory = "Armor",  tier = 1,                                              condition = "almostNew" },
            }
        },
        exLegion = {
            weight = 5,
            equipment = {
                { category = "Weapons", tier = 1,                           subCategories = { "Shotguns", "SubmachineGuns", "AssaultRifles", "Handguns" }, condition = "almostNew", chance = 100, ammo = "medium" },
                { category = "Weapons", subCategories = { "MeleeWeapons" }, tierRange = { 1, 2 }, },
                { category = "Armor",   subCategory = "Helmet",             tier = 1, },
                { category = "Armor",   subCategory = "Armor",              tier = 1, },
            }
        },
        exGangMember = {
            weight = 5,
            equipment = {
                { category = "Weapons", subCategories = { "MeleeWeapons" }, tierRange = { 1, 2 }, chance = 100 },
                { category = "Weapons", subCategories = { "Handguns" },     tier = 1,             chance = 100, ammo = "high" },
            }
        },
        exArmy = {
            weight = 5,
            equipment = {
                { category = "Weapons", tier = 2,               subCategories = { "AssaultRifles" }, condition = "almostNew", chance = 100, ammo = "high" },
                { category = "Armor",   subCategory = "Helmet", tierRange = { 1, 2 },                condition = "almostNew", chance = 100 },
                { category = "Armor",   subCategory = "Armor",  tierRange = { 1, 2 },                condition = "almostNew", chance = 100 },
            }
        },
        slumKid = {
            weight = 100,
            equipment = {
                { category = "Weapons", subCategories = { "MeleeWeapons" },    tier = 1, condition = "bad" },
                { category = "Weapons", subCategories = { "Handguns" },        tier = 1, condition = "bad", ammo = "none" },
                { category = "Armor",   subCategories = { "Armor", "Helmet" }, tier = 1, condition = "bad", },
            }
        },
    }
}

function HUDA_MilitiaPersonalization:FilterArcheTypes(city)
    local filteredArchetypes = {}

    local units = gv_UnitData

    local militia = table.filter(units, function(k, v) return v.militia end)

    for name, v in pairs(self.archetypes) do
        if v.cities and not HUDA_ArrayContains(v.cities, city) then
            goto continue
        end

        if v.citiesExclusive and HUDA_ArrayContains(v.citiesExclusive, city) then
            filteredArchetypes = {}

            filteredArchetypes[name] = v

            return filteredArchetypes
        end

        if v.max and v.max > 0 then
            local count = table.count(table.filter(militia, function(k, v) return v.ArcheType == name end))

            if count >= v.max then
                goto continue
            end
        end

        filteredArchetypes[name] = v

        ::continue::
    end

    return filteredArchetypes
end

function HUDA_MilitiaPersonalization:GetArchetype(unit)
    local sectorId = unit.JoinLocation

    local sector = gv_Sectors[sectorId]

    local city = sector and sector.City

    gv_HUDA_MilitiaModifier = gv_HUDA_MilitiaModifier or {}

    local popularity = gv_HUDA_MilitiaModifier[city] or 100

    local popularitySurplus = Max(0, popularity - 100)

    local filteredArchetypes = self:FilterArcheTypes(city)

    return self:DrawArchetype(filteredArchetypes, popularitySurplus)
end

function HUDA_MilitiaPersonalization:DrawArchetype(archetypes, popularitySurplus)
    local total = 0

    for name, v in pairs(archetypes) do
        total = total + Min(100, v.weight + popularitySurplus)
    end

    local rand = InteractionRandRange(1, total)

    local currentWeight = 0

    for name, v in pairs(archetypes) do
        currentWeight = currentWeight + Min(100, v.weight + popularitySurplus)

        if rand <= currentWeight then
            return name
        end
    end
end

function HUDA_MilitiaPersonalization:GetRandomItems(unit)
    local equipment = unit.ArcheType and self.archetypes[unit.ArcheType] and self.archetypes[unit.ArcheType].equipment or
        {}

    for _, v in ipairs(equipment) do
        local roll = InteractionRand(100)

        local chance = v.chance or 90

        local preparedEquipment = {}

        if roll <= chance then
            preparedEquipment = v

            if preparedEquipment.condition == "almostNew" then
                preparedEquipment.conditionRange = { 90, 98 }
            elseif preparedEquipment.condition == "good" then
                preparedEquipment.conditionRange = { 80, 90 }
            elseif preparedEquipment.condition == "bad" then
                preparedEquipment.conditionRange = { 30, 50 }
            else
                preparedEquipment.conditionRange = { 70, 80 }
            end

            preparedEquipment.condition = nil

            local ammo = {}

            if preparedEquipment.ammo == "high" then
                ammo.amountRange = { 100, 200 }
            elseif preparedEquipment.ammo == "medium" then
                ammo.amountRange = { 50, 100 }
            elseif preparedEquipment.ammo == "low" then
                ammo.amountRange = { 10, 50 }
            else
                ammo = nil
            end

            local item, ammo = HUDA_MilitiaRandomItems:GetItem(preparedEquipment, ammo)

            if item then
                if unit:CanAddItem("Handheld A", item) then
                    unit:AddItem("Handheld A", item)
                elseif unit:CanAddItem("Head", item) then
                    unit:AddItem("Head", item)
                elseif unit:CanAddItem("Torso", item) then
                    unit:AddItem("Torso", item)
                elseif unit:CanAddItem("Legs", item) then
                    unit:AddItem("Legs", item)
                else
                    unit:AddItem("Inventory", item)
                end

                if ammo then
                    item:Reload(ammo, "suspend_fx")
                    unit:AddItem("Inventory", ammo)
                end

                CombatLog("debug",
                    Untranslated { "<nick> is an <archetype> and got <item> with <ammo> ammo", nick = unit.Nick, archetype = unit.ArcheType, item = item.class, ammo = ammo and ammo.Amount or 0 })
            end
        end
    end
end

function HUDA_MilitiaPersonalization:Personalize(unit_ids, first)
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

            if not unit.JoinDate or unit.JoinDate == 0 then
                unit.JoinDate = Game.CampaignTime

                if gunit then
                    gunit.JoinDate = unit.JoinDate
                end
            end

            if not unit.JoinLocation or unit.JoinLocation == "" then
                unit.JoinLocation = HUDA_GetSectorId(unit)

                if gunit then
                    gunit.JoinLocation = unit.JoinLocation
                end
            end

            if not unit.ArcheType or unit.ArcheType == "" then
                unit.ArcheType = self:GetArchetype(unit)

                if gunit then
                    gunit.ArcheType = unit.ArcheType
                end
            end

            if not unit.HandledEquipment then
                if HUDA_GetModOptions("militiaNoWeapons") == true and not first then
                    unit:ForEachItem(function(item, slot)
                        unit:RemoveItem(slot, item)
                    end)

                    self:GetRandomItems(unit)
                end

                unit.HandledEquipment = true
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
    -- return sector_id .. " - " .. self:GetRandomMilitiaSquadName()
    return self:GetRandomMilitiaSquadName()
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

        local randV = Min(100, InteractionRandRange(v - 6, v + 6))

        local baseDiff = randV - unit['base_' .. k]

        unit[k] = randV

        unit:AddModifier("randstat" .. k, k, false, baseDiff)

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

            local squad_name = IsT(squad.Name) and TDevModeGetEnglishText(squad.Name) or squad.Name

            if squad_name == "MILITIA" then
                squad.Name = self:GetRandomSquadName(squad.CurrentSector)
            end

            if not squad.BornInSector or squad.BornInSector == "" then
                squad.BornInSector = squad.CurrentSector
            end

            if not squad.SupplyBase or squad.SupplyBase == "" then
                local squad_distance, closest_sector = HUDA_GetShortestDistanceToCityAndBases(squad.CurrentSector)
                squad.SupplyBase = closest_sector
            end
        end
    end
end
