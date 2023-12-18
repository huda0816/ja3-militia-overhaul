-- Savegame Hook, Transform Ally Squads to Militia Squads
function OnMsg.ZuluGameLoaded(game)
	HUDA_MilitiaPersonalization:PersonalizeSquads()
	HUDA_MilitiaPersonalization:Personalize(false, true)
end
