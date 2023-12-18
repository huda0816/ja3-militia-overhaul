local hasMilitiaBase = false
local hasMilitiaPrison = false

for _, prop in ipairs(SatelliteSector.properties) do
    if prop.id == 'MilitiaBase' then
        hasMilitiaBase = true
    end
    if prop.id == 'MilitiaPrison' then
        hasMilitiaPrison = true
    end
end

if not hasMilitiaBase then
    SatelliteSector.properties[#SatelliteSector.properties + 1] = {
        category = "General",
        id = "MilitiaBase",
        editor = "bool",
        default = false,
    }
end

if not hasMilitiaPrison then
    SatelliteSector.properties[#SatelliteSector.properties + 1] = {
        category = "General",
        id = "MilitiaPrison",
        editor = "bool",
        default = false,
    }
end

local HUDA_MilitiaPOIs = {
    {
        id = "MilitiaBase",
        display_name = T(1000999105101286891, "Militia Base"),
        descr = T(1000999105101286891,
            "The Militia Base enables a variety of sector operations, reduces the costs for militia training and is used as supply hub for your militia soldiers. It also includes a small holding cell for POWs."),
        icon = "militia_base"
    },
    {
        id = "MilitiaPrison",
        display_name = T(1000999105101280816, "Prison"),
        descr = T(1000999105101286891,
            "This is a dedicated prison, which is usually larger than the prison cells in militia bases and guard posts. Make sure there are always enough guards on site to prevent a revolt."),
        icon = "militia_prison"
    }
}

for index, poi in ipairs(HUDA_MilitiaPOIs) do
    -- table.insert(POIDescriptions, 1, poi)

    if not table.find_value(POIDescriptions, "id", poi.id) then
        table.insert(POIDescriptions, poi)
    end
end

function OnMsg.ZuluGameLoaded()
    for k, sector in pairs(gv_Sectors) do
        if k == "L6" and sector.Side == "player1" then
            sector.MilitiaPrison = true
        end
    end
end

local HUDA_OriginalGetSatelliteIconImages = GetSatelliteIconImages

function GetSatelliteIconImages(context)
    local base_img, upper_img = HUDA_OriginalGetSatelliteIconImages(context)

    local building = context.building

    if #(building or {}) > 0 then
        local preset = table.find_value(POIDescriptions, "id", building)

        if preset and preset.icon ~= "hospital" and table.find_value(HUDA_MilitiaPOIs, "id", building) then
            upper_img = "Mod/LXPER6t/Icons/" .. preset.icon .. ".png"
        end
    end

    return base_img, upper_img
end

function OnMsg.SectorSideChanged(sectorId, oldSide, newSide)
    if newSide == "player1" then
        return
    end
end

function HUDA_POIDestroy(sectorId)
    local sector = gv_Sectors[sectorId]

    local hasPoi = false

    for index, poi in ipairs(HUDA_MilitiaPOIs) do
        if sector[poi.id] then
            hasPoi = true
        end

        sector[poi.id] = false
    end

    if not hasPoi then
        return
    end

    g_SatelliteUI:UpdateSectorVisuals(sectorId)

    CombatLog("important", T({
        Untranslated(
            "Your buildings in sector <em><sectorId></em> have been destroyed"),
        sectorId = sectorId
    }))
end

function HUDA_HasPOI(poiId, cityId)
    local citySectors = GetCitySectors(cityId)

    for index, sectorId in ipairs(citySectors) do
        local sector = gv_Sectors[sectorId]

        if sector[poiId] then
            return true, sectorId
        end
    end

    return false
end

local HUDA_OriginalGetGuardpostRollover = GetGuardpostRollover

function GetGuardpostRollover(sector)
    if sector.Side ~= "player1" and sector.Side ~= "ally" then
        return HUDA_OriginalGetGuardpostRollover(sector)
    end

    local descr = T { 1000999105101280829, "Outposts under player control uncover fog of war in adjacent sectors" }

    local prisonDescr = HUDA_MilitiaPOW:GetPrisonDescription(sector.Id)

    if prisonDescr then
        descr = table.concat({ descr, prisonDescr }, "\n\n")
    end

    return descr
end

local HUDA_OriginalGetPOITextForRollover = PointOfInterestRolloverClass.GetPOITextForRollover

function PointOfInterestRolloverClass:GetPOITextForRollover(buildingId, sector)
    
    if not table.find(HUDA_MilitiaPOIs, "id", buildingId) then
        return HUDA_OriginalGetPOITextForRollover(self, buildingId, sector)
    end

    if not buildingId or not sector or not g_SatelliteUI then return end

    local poiPreset = table.find_value(POIDescriptions, "id", buildingId)
    if not poiPreset then return end

    local prisonDescr = HUDA_MilitiaPOW:GetPrisonDescription(sector.Id)

    if prisonDescr then
        return table.concat({ poiPreset.descr, prisonDescr }, "\n\n")
    end

    return poiPreset.descr
end
