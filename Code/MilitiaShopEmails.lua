function OnMsg.DataLoaded()
	local HUDA_hyperlink_function = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["PDAQuests_Email"],
		"name", "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)")

	if HUDA_hyperlink_function then
		local OriginalFunc = HUDA_hyperlink_function.element.func

		HUDA_hyperlink_function.element.func = function(self, hyperlink, argument, hyperlink_box, pos, button)
			if hyperlink == "OpenShopPage" then
				HUDA_OpenShopPage()
			end
			if hyperlink == "OpenSectorInventory" then
				local email = table.find_value(self.context, "id", "HUDA_ShipmentArrived") or self.context

				if email then
					HUDA_OpenSectorInventory(email.context.location)
				end
			end

			OriginalFunc(self, hyperlink, argument, hyperlink_box, pos, button)
		end
	end
end

function HUDA_OpenShopPage()
	local pda = GetDialog("PDADialog")
	pda = pda or OpenDialog("PDADialog", GetInGameInterface(), { Mode = "browser" })
	if pda.Mode ~= "browser" then
		pda:SetMode("browser")
	end
	local dlg = pda.idContent
	if dlg and dlg.Mode ~= "militia" then
		dlg:SetMode("militia")
	end
	local militia = dlg.idBrowserContent
	if militia and militia.Mode ~= "shop" then
		militia:SetMode("shop")
	end
end

function HUDA_OpenSectorInventory(sectorName)
	local sectorId = sectorName[3][1] or "H2"

	local unitsInSector = GetPlayerSectorUnits(sectorId)

	local militiaInSector = next(gv_Sectors[sectorId].militia_squads) and
		next(gv_Sectors[sectorId].militia_squads[1].units) and true or false

	if not next(unitsInSector) and not militiaInSector then
		local popupHost = GetDialog("PDADialog")
		popupHost = popupHost and popupHost:ResolveId("idPDAContainer")

		local dlg = CreateMessageBox(popupHost, "No Units in sector",
			"Move units to sector " .. sectorId .. ", to open the inventory.")
	else
		local unit

		if next(unitsInSector) then
			unit = unitsInSector[1]
		else
			local unitId = gv_Sectors[sectorId].militia_squads[1].units[1]

			unit = gv_UnitData[unitId]
		end

		OpenInventory(unit, GetSectorInventory(sectorId))
	end
end

PlaceObj('Email', {
	body = T(891704448992001,
		"Dear customer,\n\nHold onto your helmets, because the Grand Chien Militia Staff Shop has just received a top-secret shipment of game-changing gear!\n\nPrepare for action with our latest additions:\n\n<equipment>\n\n<h OpenShopPage><underline><em>Equip Now</em></underline></h>\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	label = "Important",
	id = "HUDA_NewArrivals",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992003, "I.M.P.M.S.S. - Incoming Tactical Advancements"),
	repeatable = true,
})


PlaceObj('Email', {
	body = T(891704448992004,
		"Dear customer,\n\nWe are happy to inform you that your order has been delivered to <h OpenSectorInventory location><underline><em><location></em></underline></h>.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	label = "Important",
	id = "HUDA_ShipmentArrived",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992005, "I.M.P.M.S.S. - Order delivered"),
	repeatable = true,
})

PlaceObj('Email', {
	body = T(891704448992006,
		"Dear customer,\n\nWe received your order and are preparing it for delivery.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	id = "HUDA_OrderPlaced",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992007, "I.M.P.M.S.S. - Thank you for your order"),
	repeatable = true,
})

PlaceObj('Email', {
	body = T(891704448992008,
		"Dear customer,\n\nWe noticed that you recently visited the I.M.P. Militia Staff Shop and filled your cart with top-notch weaponry, ammunition, and essential equipment. But it seems like your virtual shopping spree got interrupted, and your cart has been sitting there, waiting for you.\n\nDon't let your gear slip away! Click below to complete your purchase and ensure you're fully equipped for your next mission.\n\n<h OpenShopPage><underline><em>complete purchase</em></underline></h>\n\nSincerely,\n I.M.P.M.S.S. Customer Service\n\nP.S. Consider this your final warning. Your gear won't stay in that cart forever. Time is running out, and the battlefield is unforgiving. Don't let your indecision become your downfall. Act now, or the consequences will be dire."),
	group = "Militia",
	label = "Important",
	id = "HUDA_AbandonedCart",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992009, "I.M.P.M.S.S. - Don't Let Your Gear Slip Away!"),
	repeatable = true,
})

PlaceObj('Email', {
	body = T(891704448992010,
		"Dear Grand Chien Militia Members,\n\nWe're thrilled to announce that the Grand Chien Militia Staff Shop has officially launched, and it's now ready to serve all your tactical gear needs. To celebrate this momentous occasion, we're offering an exclusive 50% off coupon code: \"BARK0816.\"\n\nVisit the shop now and gear up for your next mission with unbeatable discounts! Don't miss out; this offer won't last forever.\n\nShop Now: <h OpenShopPage><underline><em>http://gc-militia/shop</em></underline></h>\n\nStay prepared, stay safe, and equip yourself with the best.\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	label = "Important",
	id = "HUDA_ShopLaunch",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992011, "Exciting News: Militia Staff Shop is Now Live!"),
	repeatable = true,
})

PlaceObj('Email', {
	body = T(891704448992012,
		"We regret to inform you that due to current circumstances, the Grand Chien Militia Staff Shop is temporarily closed for business.\n\nThe temporary closure is a result of Ernie Village falling under the control of hostile forces.\n\nShipping goods has become too perilous.\n\nRest assured, all pending orders will be promptly refunded.\n\nWe apologize for any inconvenience this may cause and appreciate your understanding.\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	label = "Important",
	id = "HUDA_ShopClosed",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992013, "Important Notice: Temporary Closure of Militia Staff Shop"),
	repeatable = true,
})

PlaceObj('Email', {
	body = T(891704448992014,
		"Dear Grand Chien Militia Members,\n\nGreat news! The Grand Chien Militia Staff Shop has reopened, and we're excited to get you back in action. To welcome you back, we're offering an exclusive 30% discount on all orders for the next seven days. Simply use coupon code \"REOPEN30\" at checkout.\n\nShop Now: <h OpenShopPage><underline><em>http://gc-militia/shop</em></underline></h>\n\nThis limited-time offer is our way of saying thank you for your support. Gear up with the best tactical equipment and accessories now.\n\nStay prepared, stay safe.\n\nSincerely,\n I.M.P.M.S.S. Customer Service"),
	group = "Militia",
	label = "Important",
	id = "HUDA_ShopReopened",
	sender = T(891704448992002, "shop@imp.net"),
	title = T(891704448992015, "Militia Staff Shop Reopens – Special Offer Inside!"),
	repeatable = true,
})
