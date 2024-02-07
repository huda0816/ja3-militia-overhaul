local HUDA_OriginalGetInventoryMaxSlots = UnitProperties.GetInventoryMaxSlots

function UnitProperties:GetInventoryMaxSlots()

	local option = HUDA_GetModOptions("MilitiaItemSlots", "24 (default)", "string")

	if not self.militia or option == "24 (default)" then
		return HUDA_OriginalGetInventoryMaxSlots(self)
	end

	if option == "related to strength" then
		return Max(4, (self.Strength - 30) / 5)
	end

	return tonumber(string.match(option, "%d+"))
end