MilitiaRookie.Equipment = nil
MilitiaVeteran.Equipment = nil
MilitiaElite.Equipment = nil

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
	MakePlayerSquads()
	UpdateNickNames()
end

function MakePlayerSquads()
	local militaSquads = table.filter(gv_Squads, function(k, v) return v.militia end)

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

			if ArrayContains(squad.Name, "MILITIA") then
				squad.Name = Untranslated(HUDAGetRandomSquadName(squad.CurrentSector))
			end
		end
	end
end

-- if FirstLoad then

-- end


HUDA_Original_Get_Personal_Morale = UnitProperties.GetPersonalMorale

function UnitProperties:GetPersonalMorale()
	local morale = HUDA_Original_Get_Personal_Morale(self)

	if not self.militia then
		return morale
	end

	print("Militia Morale")

	Inspect(self)

	if HUDA_MilitiaOverhaul:GetUnitDistance(self) < 4 then

		print("Distance: " .. HUDA_MilitiaOverhaul:GetUnitDistance(self))

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

function HUDA_MilitiaOverhaul:GetSquadDistance(squad)
	local current_sector = squad.CurrentSector

	if not current_sector then
		return 0
	end

	local squad_home_sector = squad.BornInSector or current_sector

	return GetSectorDistance(current_sector, squad_home_sector)
end

function HUDA_MilitiaOverhaul:GetUnitDistance(unit)
	
	local squad = gv_Squads[unit.Squad]

	local current_sector = squad.CurrentSector

	if not current_sector then
		return 0
	end

	local home_sector = unit.JoinSector or squad.BornInSector or current_sector

	return GetSectorDistance(current_sector, home_sector)
end

-- HUDA_GetSatelliteIconImages = GetSatelliteIconImages

-- function GetSatelliteIconImages(context)
-- 	-- if context.squad and context.squad.militia then
-- 	-- 	return "Mod/LXPER6t/Icons/merc_squad_militia.png", ""
-- 	-- end

-- 	-- return HUDAGetSatelliteIconImages(context)
-- end
