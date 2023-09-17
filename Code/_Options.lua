function HUDA_GetModOptions(id, default, type)
	id = "huda_" .. id

	return CurrentModOptions[id] or default or 0
end

function OnMsg.ApplyModOptions(mod_id)
	if CurrentModOptions then
		for k, v in pairs(CurrentModOptions) do
			if string.starts_with(k, "huda_Militia") then
				HUDA_MilitiaFinances:UpdateProps(k, v)
			end
		end
	end
end