local HUDA_MilitiaPOIs = {
    {
        id = "MilitiaBase",
        display_name = T(1000999105101286891, "Militia Base"),
        descr = T(1000999105101286891, "The Militia Base enables a variety of sector operations, reduces the costs for militia training and is used as supply hub for your militia soldiers."),
        icon = "militia_base"
    }
}

for index, poi in ipairs(HUDA_MilitiaPOIs) do
    -- table.insert(POIDescriptions, 1, poi)

    if not table.find_value(POIDescriptions, "id", poi.id) then
        table.insert(POIDescriptions, poi)
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
