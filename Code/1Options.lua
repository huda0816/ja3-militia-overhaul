function HUDA_GetModOptions(id, default, type)
	id = "huda_" .. id

	if type == "number" then
		return tonumber(CurrentModOptions[id]) or default
	end

	return CurrentModOptions[id] or default
end

function HUDA_GetShopOptions(id, default, type)
	id = "huda_MilitiaShop" .. id

	if CurrentModOptions[id] == nil then
		return default
	end

	if type == "number" then
		return tonumber(CurrentModOptions[id])
	end

	return CurrentModOptions[id]
end

function OnMsg.ApplyModOptions(mod_id)
	if CurrentModOptions then
		for k, v in pairs(CurrentModOptions) do
			if string.starts_with(k, "huda_MilitiaShop") then
				if (k == "huda_MilitiaShopTier") then
					HUDA_ShopController:SetTier(tonumber(v))
				elseif (k == "huda_MilitiaShopAlwaysOpen") then
					HUDA_ShopController:SetAlwaysOpen(v)
				elseif (k == "huda_MilitiaShopStockMultiplier") then
					HUDA_ShopController:SetProperty(string.gsub(k, "huda_MilitiaShop", ""), tonumber(v))
				else
					HUDA_ShopController:SetProperty(string.gsub(k, "huda_MilitiaShop", ""), v)
				end
			else
				if (
						k == "huda_MilitiaCampaignCosts" or
						k == "huda_MilitiaEliteIncome" or
						k == "huda_MilitiaRookieIncome" or
						k == "huda_MilitiaVeteranIncome") then
					HUDA_MilitiaFinances:UpdateProps(k, v)
				elseif (k == "huda_MilitiaNoFarFromHome") then
					HUDA_SetFarFromHomeStatus(v)
				end
			end
		end
	end
end
