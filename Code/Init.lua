MilitiaRookie.Equipment = nil
MilitiaVeteran.Equipment = nil
MilitiaElite.Equipment = nil

const.Satellite.MercSquadMaxPeople = 8

-- Uninstall Hook, Transform Militia Squads back to Ally Squads
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

-- Savegame Hook, Transform Ally Squads to Militia Squads
function OnMsg.ZuluGameLoaded(game)
	print(game)

	HUDA_MilitiaPersonalization:PersonalizeSquads()
	HUDA_MilitiaPersonalization:Personalize()
end

HUDA_Original_Get_Personal_Morale = UnitProperties.GetPersonalMorale

function UnitProperties:GetPersonalMorale()
	local morale = HUDA_Original_Get_Personal_Morale(self)

	if not self.militia then
		return morale
	end

	if HUDA_GetUnitDistance(self) < 4 then
		return morale
	end

	if self.class == "MilitiaRookie" then
		morale = morale - 2
	elseif self.class == "MilitiaVeteran" then
		morale = morale - 1
	elseif self.class == "MilitiaElite" then
		morale = morale - 0
	end

	return Clamp(morale, -3, 3)
end

DefineClass.HUDA_MilitiaOverhaul = {}