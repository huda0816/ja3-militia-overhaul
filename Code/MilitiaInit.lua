-- Savegame Hook, Transform Ally Squads to Militia Squads
function OnMsg.ZuluGameLoaded(game)
	HUDA_MilitiaPersonalization:PersonalizeSquads()
	HUDA_MilitiaPersonalization:Personalize(false, true)
end

-- Uninstall Hook, Transform Militia Squads back to Ally Squads restart required
function OnMsg.ReloadLua()
	local isBeingDisabled = not table.find(ModsLoaded, 'id', CurrentModId)
	if isBeingDisabled then
		local militaSquads = table.filter(gv_Squads, function(k, v) return v.militia end)
		if militaSquads then
			for k, squad in pairs(militaSquads) do
				squad.Side = "ally"
			end
		end
	end
end
