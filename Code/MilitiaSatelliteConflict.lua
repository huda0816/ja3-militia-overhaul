function UIEnterSectorInternal(sector_id, force)
	local sector = gv_Sectors[sector_id]
	if not sector then
		return
	end
	local has_player_squads = #GetSectorSquadsFromSide(sector_id, "player1", "player2") > 0 or
	#GetMilitiaSquads(sector) > 0
	if not has_player_squads then
		local pdaDiag = GetDialog("PDADialog")
		if pdaDiag and pdaDiag.Mode == "browser" then
			OpenAIMAndSelectMerc()
		end
		UIEnterSector(sector_id, force)
		return
	end
	if not ForceReloadSectorMap and gv_CurrentSectorId == sector_id then
		CloseSatelliteView()
	else
		local spawnMode = sector.conflict and sector.conflict.spawn_mode or "explore"
		LoadSector(sector_id, spawnMode)
	end
end

if FirstLoad then
    local huda_enabled_button = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SatelliteConflict"], "comment", "red enabled")

    if huda_enabled_button then
        huda_enabled_button.element.ActionState = function(self, host)
            local sector = host.context
			return CanGoInMap(sector.Id) and
            #GetSquadsInSector(sector.Id, "excludeTravelling", true, "excludeArriving", "excludeRetreating") > 0 and
            "enabled" or "hidden"
        end
    end


    local huda_disabled_button = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SatelliteConflict"], "comment", "normal disabled")

    if huda_disabled_button then

		huda_disabled_button.element.ActionState = function(self, host)
            local sector = host.context
			return (not CanGoInMap(sector.Id) or
            #GetSquadsInSector(sector.Id, "excludeTravelling", true, "excludeArriving", "excludeRetreating") < 1) and
            "disabled" or "hidden"
        end
    end
end
