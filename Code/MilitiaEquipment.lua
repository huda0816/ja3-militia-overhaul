-- Default Militia Equipment is nil

local stored_rookie_equipment = MilitiaRookie.Equipment
local stored_veteran_equipment = MilitiaVeteran.Equipment
local stored_elite_equipment = MilitiaElite.Equipment

if HUDA_GetModOptions("huda_NoWeaponsMilitia", nil) then
	MilitiaRookie.Equipment = nil
	MilitiaVeteran.Equipment = nil
	MilitiaElite.Equipment = nil
else
	MilitiaRookie.Equipment = stored_rookie_equipment
	MilitiaVeteran.Equipment = stored_veteran_equipment
	MilitiaElite.Equipment = stored_elite_equipment
end

function HUDA_UpdateEquipment(equipment)
	if equipment then
		MilitiaRookie.Equipment = stored_rookie_equipment
		MilitiaVeteran.Equipment = stored_veteran_equipment
		MilitiaElite.Equipment = stored_elite_equipment
	else
		MilitiaRookie.Equipment = nil
		MilitiaVeteran.Equipment = nil
		MilitiaElite.Equipment = nil
	end
end