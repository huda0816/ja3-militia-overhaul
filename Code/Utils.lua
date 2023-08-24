function ArrayContains(array, value)
	for k, v in pairs(array) do
		if v == value then
			return true
		end
	end

	return false
end

function IsContextMilitia(context)
	local militia = false

	if context.militia then
		militia = true
	elseif context.UniqueId then
		local squad = gv_Squads[context.UniqueId]

		if squad then
			militia = squad.militia
		end
	end

	return militia
end

function HUDA_GetAllMilitiaSoldiers()
	return table.filter(gv_UnitData, function(k, v)
        return v.militia
    end)
end

HUDA_FindElement = CustomSettingsMod.Utils.XTemplate_FindElementsByProp
