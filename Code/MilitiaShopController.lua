GameVar("gv_HUDA_ShopInventory", {})
GameVar("gv_HUDA_ShopOrders", {})
GameVar("gv_HUDA_ShopCart", {})
GameVar("gv_HUDA_ShopQuery", {})
GameVar("gv_HUDA_ShopCouponCodes", {})
GameVar("gv_HUDA_ShopStatus", {})

-- TFormat

function TFormat.CurrentDeliveryAddress()
	return Untranslated(HUDA_ShopController:GetCurrentDeliveryAddress())
end

-- Hooks

function OnMsg.NewDay()
	if not HUDA_ShopController:GetStatus("initialized") or not HUDA_ShopController:GetStatus("open") then
		return
	end

	HUDA_ShopController:MaybeRestock()
	HUDA_ShopController:CheckAbandonedCart()
end

function OnMsg.NewHour()
	local t = GetTimeAsTable(Game.CampaignTime)

	if not HUDA_ShopController:GetStatus("initialized") then
		return
	end

	if t.hour > 7 and t.hour < 13 then
		HUDA_ShopController:RefreshOrders(t)
	end

	if not HUDA_ShopController:GetStatus("open") then
		return
	end

	if t.hour == 18 then
		HUDA_ShopController:UpdateTopSellers()
	end

	if t.hour == 21 then
		HUDA_ShopController:CheckTierStatus(true)
	end
end

function OnMsg.SectorSideChanged(sectorId, oldSide, newSide)
	HUDA_ShopController:CheckSectorChange(sectorId, oldSide, newSide)
end

function OnMsg.ZuluGameLoaded(game)
	HUDA_ShopController:UpdateStatus("tier", Min(3, HUDA_ShopController:GetStatus("tier") or 1))

	HUDA_ShopController:InitGVs()
end

DefineClass.HUDA_ShopController = {
	AbandonedCartTimeout = 1,
	Categories = {},
	InventoryTemplate = {},
	DeliveryTypes = {},
	CouponCodes = {},
	ValidDeliverySectors = { "H2", "K9" },
	SectorCondition = "H2",
	AlwaysOpen = HUDA_GetShopOptions('AlwaysOpen', false),
	DailyRestock = HUDA_GetShopOptions('DailyRestock', false),
	InstantShopping = HUDA_GetShopOptions('InstantShopping', false),
	AllTowns = HUDA_GetShopOptions('AllTowns', false),
	StockMultiplier = HUDA_GetShopOptions('StockMultiplier', 1, "number"),
	ShopStatus = {
		tier = HUDA_GetShopOptions('Tier', 1, "number"),
		lastRestock = 0,
		open = false,
		deliverySector = "H2",
		topSellers = {},
		arrived = {},
		initialized = false,
		maintainence = false,
	}
}

function HUDA_ShopController:UpdateStatus(property, value)
	gv_HUDA_ShopStatus = gv_HUDA_ShopStatus or {}

	gv_HUDA_ShopStatus[property] = value
end

function HUDA_ShopController:GetStatus(property)
	if not gv_HUDA_ShopStatus then
		return nil
	end

	return gv_HUDA_ShopStatus[property]
end

function HUDA_ShopController:SetPresets(deliveryTypes, categories, inventoryTemplate, couponCodes)
	self.DeliveryTypes = table.raw_copy(deliveryTypes)
	self.Categories = table.raw_copy(categories)
	self.InventoryTemplate = table.raw_copy(inventoryTemplate)
	self.CouponCodes = table.raw_copy(couponCodes)

	self:InitGVs()
end

function HUDA_ShopController:InitGVs()
	if not self:GetStatus("initialized") then
		return
	end

	self:UpdateCouponCodes()
	self:Restock()
	self:UpdateTopSellers()
end

function HUDA_ShopController:Init()
	if self:GetStatus("initialized") then
		return
	end

	if not self.AlwaysOpen and not self:CheckSectorStatus(false) then
		return
	end

	Msg("HUDAMilitaShopBeforeInit")

	gv_HUDA_ShopStatus = gv_HUDA_ShopStatus or {}

	gv_HUDA_ShopStatus = self.ShopStatus

	gv_HUDA_ShopStatus.initialized = true

	gv_HUDA_ShopStatus.open = true

	gv_HUDA_ShopCart = {}

	gv_HUDA_ShopCart.sector = gv_HUDA_ShopStatus.deliverySector or "H2"

	self:UpdateCouponCodes()

	self:Restock()

	self:SendMails("ShopLaunch")
end

function HUDA_ShopController:SetProperty(prop, value)
	self[prop] = value
end

function HUDA_ShopController:SetAlwaysOpen(value)
	self.AlwaysOpen = value

	if value then
		self:UpdateStatus("open", true)
	else
		if not self:CheckSectorStatus(false) then
			self:UpdateStatus("open", false)
		end
	end
end

function HUDA_ShopController:SetTier(tier)
	self.ShopStatus.tier = tier

	local currentTier = self:GetStatus("tier") or 1

	if tier > currentTier then
		self:UpdateStatus("tier", tier)
	end
end

function HUDA_ShopController:CheckSectorStatus()
	if not self.SectorCondition then
		return true
	end

	local sector = gv_Sectors and gv_Sectors[self.SectorCondition] or false

	if not sector then
		return true
	end

	if sector.Side == "player1" then
		return true
	end

	return false
end

function HUDA_ShopController:CheckSectorChange(sectorId, oldSide, newSide)
	if not self:GetStatus("initialized") then
		return
	end

	if sectorId == self.SectorCondition then
		if newSide == "player1" then
			self:UpdateStatus("open", true)
			gv_HUDA_ShopCouponCodes.reopen30.used = false

			self:SendMails("HUDA_ShopReopened")
		elseif not self.AlwaysOpen then
			self:UpdateStatus("open", false)

			self:SendMails("HUDA_ShopClosed")
		end
	end

	if newSide == "player1" then
		return
	end

	if not HUDA_ArrayContains(self.ValidDeliverySectors, sectorId) then
		return
	end

	local pendingOrders = table.ifliter(gv_HUDA_ShopOrders,
		function(i, order) return order.status == "pending" and order.sector == sectorId end)

	if not next(pendingOrders) then
		return
	end

	local ownValidSectors = self.AlwaysOpen and { GetCurrentCampaignPreset().InitialSector } or {}

	if self.AllTowns then
		local cities = gv_Cities
		for k, city in pairs(cities) do
			local city_sectors = HUDA_GetControlledCitySectors(k)
			if next(city_sectors) then
				ownValidSectors[#ownValidSectors + 1] = city_sectors[0]
			end
		end
	else
		for i, sectorId in ipairs(self.ValidDeliverySectors) do
			local sector = gv_Sectors[s]

			if sector and sector.Side == "player1" then
				ownValidSectors[#ownValidSectors + 1] = sectorId
			end
		end
	end

	if not next(ownValidSectors) then
		-- self:SendMails("SectorLostOrderRefunded", { sector = sectorId, orders = pendingOrders })

		for _, order in ipairs(pendingOrders) do
			self:Refund(order)
		end
	else
		-- self:SendMails("SectorLostOrderRerouting", { sector = sectorId, orders = pendingOrders, newSector = ownValidSectors[1] })

		ShopStatus.deliverySector = ownValidSectors[1]

		for _, order in ipairs(pendingOrders) do
			order.sector = ownValidSectors[1]
		end
	end
end

function HUDA_ShopController:UpdateTopSellers()
	local orders = gv_HUDA_ShopOrders

	if not next(orders) then
		local products = gv_HUDA_ShopInventory

		if not next(products) then
			return
		end

		local top = {}

		for _, product in ipairs(products) do
			local roll = InteractionRand(100, "topSellers")

			if roll > 80 then
				table.insert(top, { id = product.id, count = 0 })
			end
		end

		self:UpdateStatus("topSellers", top)

		return
	end

	if orders[#orders].orderTime < GameTime() - (24 * 60 * 60) then
		return
	end

	local sold = {}

	for _, order in ipairs(orders) do
		for _, item in ipairs(order.products) do
			if not sold[item.id] then
				sold[item.id] = 0
			end

			sold[item.id] = sold[item.id] + item.count
		end
	end

	local top = {}

	for id, count in pairs(sold) do
		table.insert(top, { id = id, count = count })
	end

	table.sort(top, function(a, b) return a.count > b.count end)

	self:UpdateStatus("topSellers", top)
end

function HUDA_ShopController:GetTopSellers(number)
	local top = self:GetStatus("topSellers")

	local preparedProducts = gv_HUDA_ShopInventory

	local products = {}

	for _, item in ipairs(top) do
		local product = HUDA_ArrayFind(preparedProducts, function(i, p) return p.id == item.id and p.stock > 0 end)

		if product then
			table.insert(products, product)

			if number and #products >= number then
				break
			end
		end
	end

	return products
end

function HUDA_ShopController:UpdateCouponCodes()
	local codes = self.CouponCodes

	if not next(gv_HUDA_ShopCouponCodes) then
		gv_HUDA_ShopCouponCodes = table.copy(codes)
		return
	end

	for k, code in pairs(codes) do
		if not gv_HUDA_ShopCouponCodes[k] then
			gv_HUDA_ShopCouponCodes[k] = code
		end
	end
end

function HUDA_ShopController:VerifyCoupon(id)
	local coupon = gv_HUDA_ShopCouponCodes[string.lower(id)]

	if not coupon then
		return false
	end

	if coupon.used and not coupon.multi then
		self:CreateMessageBox(T(28987978971013, "Coupon already used"), T(28987978971014, "This coupon has already been used."))
		return false
	end

	return true
end

function HUDA_ShopController:AddCouponToCart(id)
	if not id then
		return
	end

	id = string.lower(id)

	if gv_HUDA_ShopCart.coupon and gv_HUDA_ShopCart.coupon.id == id then
		return
	end

	local code = gv_HUDA_ShopCouponCodes[id]

	if not code then
		return
	end

	gv_HUDA_ShopCart.coupon = {
		id = id,
		discount = code.discount
	}

	ObjModified("shop cart")
end

function HUDA_ShopController:RemoveCouponFromCart()
	if not gv_HUDA_ShopCart.coupon then
		return
	end

	gv_HUDA_ShopCart.coupon = nil

	ObjModified("shop cart")
end

function HUDA_ShopController:SetInventoryTemplate(template, restock)
	self.InventoryTemplate = template
	if restock then
		self:Restock()
	end
end

function HUDA_ShopController:GetInventoryTemplate()
	return self.InventoryTemplate
end

function HUDA_ShopController:SetShopCategories(categories)
	self.Categories = categories
end

function HUDA_ShopController:AddShopCategory(category)
	table.insert(self.Categories, category)
end

function HUDA_ShopController:GetShopCategories()
	return self.Categories
end

function HUDA_ShopController:SetDeliveryTypes(deliveryTypes)
	self.DeliveryTypes = deliveryTypes
end

function HUDA_ShopController:GetDeliveryTypes()
	return self.DeliveryTypes
end

function HUDA_ShopController:GetCurrentDeliveryAddress()
	local id = gv_HUDA_ShopCart.sector or self:GetStatus("deliverySector") or "H2"

	return GetSectorName(gv_Sectors[id])
end

function HUDA_ShopController:MaybeRestock(sectors)
	if self.DailyRestock then
		self:UpdateStatus("lastRestock", 0)
		self:Restock()
		return
	end

	local daysSinceLastRestock = self:GetStatus("lastRestock") or 0

	self:UpdateStatus("lastRestock", daysSinceLastRestock + 1)

	if not daysSinceLastRestock or daysSinceLastRestock < 1 then
		return
	end

	local restockRoll = InteractionRand(6, "HUDA_ShopRestock")

	if restockRoll > daysSinceLastRestock then
		return
	end

	self:UpdateStatus("lastRestock", 0)

	self:Restock()
end

function HUDA_ShopController:Restock()
	local tier = Min(3, self:GetStatus("tier") or 1)

	local filteredProducts = {}

	ForEachPreset("InventoryItemCompositeDef", function(preset)
		local item = g_Classes[preset.id]
		if item.CanAppearInShop and item.CanAppearStandard and item.Tier <= tier and item.RestockWeight > 0 then
			table.insert(filteredProducts, item)
		end
	end)

	if HUDA_IsModActive("rCD6ERe") and REV_SetDefaultComponentValues then
		for _, item in ipairs(filteredProducts) do
			if item.object_class == "WeaponComponentItem" then
				REV_SetDefaultComponentValues(item.class)
			end
		end
	end

	local products = {}

	for i, productData in ipairs(filteredProducts) do
		local roll = InteractionRand(100, "HUDA_ShopAvailability")

		local product = {}

		productData.RestockWeight = productData.RestockWeight or 100
		productData.Tier = productData.Tier or 1
		productData.MaxStock = productData.MaxStock or 0

		product.basePrice = productData.Cost or 0

		if productData.MaxStock > 0 and productData.RestockWeight > 0 and roll < (productData.RestockWeight or 100) + ((tier - productData.Tier) * 10) then
			local tierBonus = 1 + ((tier - productData.Tier) * 0.5)

			local stock = round(productData.MaxStock * tierBonus * 2, 1)

			if self.StockMultiplier then
				stock = round(stock * self.StockMultiplier, 1)
			else
				local stockRoll = InteractionRandRange(80, 120, "HUDA_ShopStock")

				stock = MulDivRound(stock, stockRoll, 100)
			end

			if stock > 0 then
				product.stock = stock * (productData.ShopStackSize or 1)

				table.insert(products, {
					product = product,
					productData = productData
				})
			end
		end
	end

	gv_HUDA_ShopInventory = self:PrepareProducts(products)
end

function HUDA_ShopController:PrepareProducts(products)
	local preparedProducts = {}

	if not next(self:GetStatus("arrived") or {}) then
		local arrived = {}

		for i, product in ipairs(products) do
			table.insert(arrived, product.productData.Id)
		end

		self:UpdateStatus("arrived", arrived)
	end

	for i, productArr in ipairs(products) do
		local product = self:PrepareProduct(productArr.product, productArr.productData)

		table.insert(preparedProducts, product)
	end

	self:CheckNewArrivals(preparedProducts.product)

	return preparedProducts
end

function HUDA_ShopController:PrepareProduct(product, productData)
	local arrived = self:GetStatus("arrived") or {}

	if not table.find(arrived, productData.Id) then
		product.new = true

		table.insert(arrived, productData.Id)

		self:UpdateStatus("arrived", arrived)
	else
		product.new = false
	end

	product.id = productData.class
	product.tier = productData.Tier or 1
	product.basePrice = MulDivRound((productData.Cost or 0) / (productData.ShopStackSize or 1), 95, 100)
	product.description = productData.Description or ""
	product.name = productData.DisplayName
	product.image = productData.Icon
	product.weight = productData.Weight or nil
	product.maxStack = productData.MaxStacks or 1
	product.order = 10

	product.category = self:MapProductCategory(productData)

	local category = HUDA_ArrayFind(self.Categories, function(i, category)
		return category.id == product.category
	end)

	if productData.ShopStackSize then
		product.minAmount = productData.ShopStackSize
	elseif category then
		product.minAmount = category.minAmount
	else
		product.minAmount = 1
	end

	if productData.Caliber then
		product.caliber = productData.Caliber
		product.caliberName = self:GetCaliberName(productData.Caliber)
	end

	return product
end

function HUDA_ShopController:MapProductCategory(productData)
	local category = productData:GetCategory().id

	local subCategory = productData:GetSubCategory().id

	if string.find(productData.class, "SkillMag") then
		return "magazines"
	elseif category == "Weapons" and subCategory == "Handguns" then
		return "pistols"
	elseif category == "Weapons" and subCategory == "AssaultRifles" then
		return "assault"
	elseif category == "Weapons" and subCategory == "Shotguns" then
		return "shotguns"
	elseif category == "Weapons" and subCategory == "Rifles" then
		return "rifles"
	elseif category == "Weapons" and subCategory == "MachineGuns" then
		return "machineguns"
	elseif category == "Weapons" and subCategory == "MeleeWeapons" then
		return "melee"
	elseif category == "Weapons" and subCategory == "HeavyWeapons" then
		return "heavy"
	elseif category == "Weapons" and subCategory == "SubmachineGuns" then
		return "smgs"
	elseif category == "Ammo" then
		return "ammo"
	elseif category == "Armor" then
		return "armor"
	elseif category == "Other" and subCategory == "Grenade" then
		return "throwables"
		-- elseif category == "Other" and subCategory == "Components" then
		--     return "explosives"
		-- elseif category == "Other" and subCategory == "Resource" then
		--     return "crafting"
	elseif category == "Other" and subCategory == "Medicine" then
		return "medical"
	elseif category == "Other" and subCategory == "Tool" then
		return "tools"
	end

	return "misc"
end

function HUDA_ShopController:CheckAbandonedCart()
	local cart = gv_HUDA_ShopCart

	if cart.abandonedCartSent then
		return
	end

	if not cart.products or not next(cart.products) then
		return
	end

	local lastModified = cart.lastModified

	if not lastModified then
		return
	end

	if Game.CampaignTime - lastModified > self.AbandonedCartTimeout * 60 * 60 * 24 then
		self:SendMails("AbandonedCart")

		cart.abandonedCartSent = true
	end
end

function HUDA_ShopController:GetAvailableCategories()
	if not next(self.Categories) then
		return {}
	end

	local products = gv_HUDA_ShopInventory

	local categories = {}

	for _, category in ipairs(self.Categories) do
		local ps = table.ifilter(products, function(_, product)
			return product.category == category.id
		end)

		if next(ps) then
			local preparedCat = table.raw_copy(category)

			preparedCat.productCount = #ps

			table.insert(categories, preparedCat)
		end
	end

	table.sort(categories, function(a, b)
		return (a.order or 0) < (b.order or 0)
	end)

	return categories
end

function HUDA_ShopController:GetProductPrice()
	local cart = gv_HUDA_ShopCart

	local multiplier = HUDA_GetShopOptions("PriceMultiplierNew", 100)

	local price = 0

	if not cart.products or not next(cart.products) then
		return price
	end

	for i, product in ipairs(cart.products) do
		price = price + product.price * product.count
	end

	if cart.coupon then
		price = price - MulDivRound(price, cart.coupon.discount, 100)
	end

	if multiplier ~= 100 then
		price = MulDivRound(price, multiplier, 100)
	end

	return price
end

function HUDA_ShopController:GetDeliveryCosts()
	local cart = gv_HUDA_ShopCart

	local deliveryType = cart.deliveryType

	if not deliveryType then
		local defaultTypes = table.ifilter(self.DeliveryTypes, function(i, deliveryType)
			return deliveryType.default
		end)

		deliveryType = next(defaultTypes) and defaultTypes[1] or nil
	end

	if deliveryType then
		local weightTable = {}

		for i, category in ipairs(self.Categories) do
			weightTable[category.id] = category.weight
		end

		local weight = 0

		for i, product in ipairs(cart.products) do
			weight = weight + (product.weight or (weightTable[product.category] or 0)) * product.count
		end

		return MulDivRound(deliveryType.pricePerKilogram, weight, 1000)
	end

	return 0
end

function HUDA_ShopController:GetTotalPrice()
	local price = self:GetProductPrice()

	local deliverCosts = self:GetDeliveryCosts()

	return price + deliverCosts
end

function HUDA_ShopController:GetItemNum()
	local cart = gv_HUDA_ShopCart

	local itemNum = 0

	if not cart.products or not next(cart.products) then
		return itemNum
	end

	for i, product in ipairs(cart.products) do
		itemNum = itemNum + product.count
	end

	return itemNum
end

function HUDA_ShopController:GetDeliveryTypes()
	return self.DeliveryTypes
end

function HUDA_ShopController:SetDeliveryType(deliveryType)
	gv_HUDA_ShopCart.deliveryType = deliveryType
end

function HUDA_ShopController:AddDeliveryType(deliveryType)
	table.insert(self.DeliveryTypes, deliveryType)
end

function HUDA_ShopController:AddDeliveryTypes(deliveryTypes)
	for _, deliveryType in ipairs(deliveryTypes) do
		self:AddDeliveryType(deliveryType)
	end
end

function HUDA_ShopController:HasAmmo(caliber)
	return HUDA_ArrayFind(gv_HUDA_ShopInventory, function(i, product)
		return product.category == "ammo" and product.caliber == caliber and product.stock > 0
	end) ~= nil
end

function HUDA_ShopController:GetProducts(query, noqueryupdate)
	if not noqueryupdate then
		gv_HUDA_ShopQuery = query
	end

	local preparedProducts = gv_HUDA_ShopInventory

	if query then
		preparedProducts = table.ifilter(preparedProducts, function(i, product)
			if query.new and not product.new then
				return false
			end

			if query.new == false and product.new then
				return false
			end

			if query.topSeller and not product.topSeller then
				return false
			end

			if query.caliber and query.caliber ~= product.caliber then
				return false
			end

			if query.id and query.id ~= product.id then
				return false
			end

			if query.category and query.category ~= product.category then
				return false
			end

			return true
		end)
	end

	if query.order then
		if query.order == "price" then
			table.sort(preparedProducts, function(a, b)
				return (a.basePrice or 0) < (b.basePrice or 0)
			end)
		elseif query.order == "name" then
			table.sort(preparedProducts, function(a, b)
				return TDevModeGetEnglishText(a.name) < TDevModeGetEnglishText(a.name)
			end)
		elseif query.order == "tier" then
			table.sort(preparedProducts, function(a, b)
				return (a.tier or 1) < (b.tier or 1)
			end)
		end
	else
		table.sort(preparedProducts, function(a, b)
			return (a.order or 0) < (b.order or 0)
		end)
	end

	if query.num then
		return table.move(preparedProducts, 1, query.num, 1, {})
	end

	return preparedProducts
end

function HUDA_ShopController:CheckNewArrivals(products)
	local newProducts = table.ifilter(products, function(i, product)
		return product.new
	end)

	if not next(newProducts) then
		return
	end

	local newProductsStr = ""

	for i, product in ipairs(newProducts) do
		newProductsStr = newProductsStr .. TDevModeGetEnglishText(product.name) .. ", "
	end

	newProductsStr = string.sub(newProductsStr, 1, -3)

	self:SendMails("NewArrivals", { equipment = newProductsStr })
end

function HUDA_ShopController:GetQueryUrlParams(query)
	local params = ""

	if query then
		if query.topSeller then
			params = params .. "&topSeller=true"
		end

		if query.id then
			params = params .. "&id=" .. query.id
		end

		if query.category then
			params = params .. "&category=" .. query.category
		end

		if query.caliber then
			params = params .. "&caliber=" .. query.caliber
		end
	end

	return params ~= "" and "?" .. params or ""
end

function HUDA_ShopController:AddToCart(product, count)
	local inventory = gv_HUDA_ShopInventory

	local inventoryProduct = HUDA_ArrayFind(inventory, function(i, inventoryProduct)
		return inventoryProduct.id == product.id
	end)

	if not inventoryProduct or inventoryProduct.stock == 0 then
		self:CreateMessageBox(T(28987978971021, "Sold out"), T(28987978971022, "This product is out of stock."))

		return
	end

	if inventoryProduct.stock < count then
		self:CreateMessageBox(T(28987978971023, "Not enough in stock"),
			Untranslated("There are only " .. inventoryProduct.stock .. " items left in stock."))

		count = inventoryProduct.stock
	end

	inventoryProduct.stock = inventoryProduct.stock - count

	local cart = gv_HUDA_ShopCart

	cart.lastModified = Game.CampaignTime
	cart.abandonedCartSent = false

	local cartProducts = cart.products or {}

	local productsInCart = table.ifilter(cartProducts, function(i, cartProduct)
		return cartProduct.id == product.id
	end)

	if not next(productsInCart) then
		table.insert(cartProducts,
			{
				id = product.id,
				count = count,
				name = product.name,
				category = product.category,
				maxStack = product.maxStack,
				price = product.basePrice,
				weight = product.weight
			})
	else
		productsInCart[1].count = productsInCart[1].count + count
	end

	cart.products = cartProducts

	self:ModifyObjects()
end

function HUDA_ShopController:RemoveFromCart(product, count)
	local cart = gv_HUDA_ShopCart

	local inventory = gv_HUDA_ShopInventory

	if not cart.products or not next(cart.products) then
		return
	end

	local cartProduct = HUDA_ArrayFind(cart.products, function(i, cartProduct)
		return cartProduct.id == product.id
	end)

	if not cartProduct then
		return
	end

	local inventoryProduct = HUDA_ArrayFind(inventory, function(i, inventoryProduct)
		return inventoryProduct.id == product.id
	end)

	if inventoryProduct then
		inventoryProduct.stock = inventoryProduct.stock + (count or cartProduct.count)
	end

	if count and count < cartProduct.count then
		cartProduct.count = cartProduct.count - count
	else
		table.remove(cart.products, HUDA_GetArrayIndex(cart.products, cartProduct))
	end

	self:ModifyObjects()
end

function HUDA_ShopController:ClearCart()
	local cart = gv_HUDA_ShopCart

	local inventory = gv_HUDA_ShopInventory

	if not cart.products or not next(cart.products) then
		return
	end

	for i, cartProduct in ipairs(cart.products) do
		local inventoryProduct = HUDA_ArrayFind(inventory, function(i, inventoryProduct)
			return inventoryProduct.id == cartProduct.id
		end)

		if inventoryProduct then
			inventoryProduct.stock = inventoryProduct.stock + cartProduct.count
		end
	end

	cart.products = {}

	cart.coupon = nil

	self:ModifyObjects()
end

function HUDA_ShopController:GetCaliberName(caliberId)
	local presetsCalibers = Presets.Caliber.Default

	for k, presetCaliber in pairs(presetsCalibers) do
		if k == caliberId then
			return presetCaliber.Name
		end
	end

	return "Unknown"
end

function HUDA_ShopController:GetCalibers(products)
	products = products or gv_HUDA_ShopInventory

	local presetsCalibers = Presets.Caliber.Default

	local calibers = {}

	for i, product in ipairs(products) do
		if product.caliber and not HUDA_ArrayFind(calibers, function(i, caliber) return product.caliber == caliber.id end) then
			table.insert(calibers, presetsCalibers[product.caliber])
		end
	end

	return calibers
end

function HUDA_ShopController:GetDeliveryDuration(order)
	local deliveryDuration = order.deliveryType.duration or 3

	return deliveryDuration * 60 * 60 * 24
end

function HUDA_ShopController:ModifyObjects()
	ObjModified("shop list")
	ObjModified("shop front")
end

function HUDA_ShopController:OrderToCart(order)
	local cart = gv_HUDA_ShopCart

	local inventory = gv_HUDA_ShopInventory

	local stockMessageArr = {}

	local orderProducts = order.products

	if not orderProducts or not next(orderProducts) then
		return
	end

	local cartProducts = cart.products or {}

	for i, orderProduct in ipairs(orderProducts) do
		local productsInCart = table.ifilter(cartProducts, function(i, cartProduct)
			return cartProduct.id == orderProduct.id
		end)

		local inventoryProduct = HUDA_ArrayFind(inventory, function(i, inventoryProduct)
			return inventoryProduct.id == orderProduct.id
		end)

		if not inventoryProduct or inventoryProduct.stock == 0 then
			table.insert(stockMessageArr, orderProduct.name .. " is out of stock.")
		else
			local count = orderProduct.count

			if inventoryProduct.stock < orderProduct.count then
				table.insert(stockMessageArr,
					"There " ..
					(inventoryProduct.stock > 1 and "are" or "is") ..
					" only " .. inventoryProduct.stock .. " " .. orderProduct.name .. " left in stock.")

				count = inventoryProduct.stock
			end

			inventoryProduct.stock = inventoryProduct.stock - count

			if not next(productsInCart) then
				table.insert(cartProducts,
					{
						id = orderProduct.id,
						count = count,
						name = orderProduct.name,
						price = orderProduct.price
					})
			else
				productsInCart[1].count = productsInCart[1].count + count
			end
		end
	end

	cart.lastModified = Game.CampaignTime
	cart.products = cartProducts
	cart.abandonedCartSent = false

	if next(stockMessageArr) then
		self:CreateMessageBox(T(28987978971041, "Sold out"), Untranslated(table.concat(stockMessageArr, "\n")))
	end
end

function HUDA_ShopController:GetETA(order)
	local deliveryDuration = self:GetDeliveryDuration(order)

	local deliveryTime = order.orderTime + deliveryDuration

	local eta = deliveryTime - Game.CampaignTime

	return eta / 60 / 60 / 24
end

function HUDA_ShopController:DateFromTime(timeStamp)
	local t = GetTimeAsTable(timeStamp or 0)
	local month = string.format("%02d", t and t.month or 1)
	local day = string.format("%02d", t and t.day or 1)
	local year = tostring(t and t.year or 1)

	return month .. "/" .. day .. "/" .. year
end

function HUDA_ShopController:RefreshOrders(t)
	local orders = gv_HUDA_ShopOrders

	local pendingOrders = table.ifilter(orders, function(i, order)
		return order.status == "pending"
	end)

	if not next(pendingOrders) then
		return
	end

	for i, order in ipairs(pendingOrders) do
		local deliveryDuration = self:GetDeliveryDuration(order)

		local deliveryTime = order.orderTime + deliveryDuration

		local orderTimeObj = GetTimeAsTable(order.orderTime)

		if Game.CampaignTime >= deliveryTime and orderTimeObj.day ~= t.day then
			if self:RollDelivery(t.hour) then
				HUDA_ShopController:Deliver(order)
			end
		end
	end
end

function HUDA_ShopController:RollDelivery(hour)
	local roll = InteractionRand(120, "HUDA_ShopDelivery")

	if roll < (10 * hour) then
		return true
	end
end

function HUDA_ShopController:Refund(order)
	gv_HUDA_ShopOrders = table.ifilter(gv_HUDA_ShopOrders, function(i, o)
		return o.id ~= order.id
	end)

	AddMoney(order.total, "I.M.P.M.S.S.", true)

	local inventory = gv_HUDA_ShopInventory

	for i, product in ipairs(order.products) do
		local inventoryProduct = HUDA_ArrayFind(inventory, function(i, inventoryProduct)
			return inventoryProduct.id == product.id
		end)

		if inventoryProduct then
			inventoryProduct.stock = inventoryProduct.stock + product.count
		end
	end

	if order.coupon then
		local coupon = gv_HUDA_ShopCouponCodes[order.coupon.id]

		if coupon then
			coupon.used = false
		end
	end

	ObjModified(gv_HUDA_ShopOrders)
end

function HUDA_ShopController:Deliver(order)
	local items = {}

	for i, product in ipairs(order.products) do
		local maxStack = product.maxStack or 1

		local numOfItems = product.count / maxStack

		local remainder = product.count % maxStack

		if remainder > 0 then
			numOfItems = numOfItems + 1
		end

		for j = 1, numOfItems do
			local item = PlaceInventoryItem(product.id)

			if item == nil then
				return
			end

			if j == numOfItems and remainder > 0 then
				item.Amount = remainder
			else
				item.Amount = maxStack
			end

			table.insert(items, item)
		end
	end

	AddToSectorInventory(order.sector, items)

	order.status = "delivered"
	order.deliveryTime = Game.CampaignTime

	self:SendMails("delivered", { sector = order.sector or "H2" })
	self:NotifyDelivery(order.sector)
end

function HUDA_ShopController:Order()
	local cart = gv_HUDA_ShopCart

	local total = self:Pay(cart)

	if not total then
		return
	end

	local orders = gv_HUDA_ShopOrders;

	local order = {
		id = "order_" .. string.format("%05d", (#orders + 1)),
		products = cart.products,
		status = "pending",
		total = total,
		sector = cart.sector or "H2",
		orderTime = Game.CampaignTime,
		deliveryType = cart.deliveryType,
	}

	if cart.coupon then
		order.coupon = cart.coupon

		if not cart.coupon.multiple then
			local coupon = gv_HUDA_ShopCouponCodes[cart.coupon.id]

			if coupon then
				coupon.used = true
			end
		end
	end

	gv_HUDA_ShopCart.products = {}

	gv_HUDA_ShopCart.coupon = nil

	table.insert(orders, order)

	self:CreateMessageBox(T(28987978971051, "Order placed"), T(28987978971052, "Your order has been placed. You will receive a notification when it arrives."))

	self:SendMails("orderPlaced")

	if self.InstantShopping then
		self:Deliver(order)
	end
end

function HUDA_ShopController:ChooseAddress()
	local sector_posibilities = {}

	if self.AlwaysOpen then
		sector_posibilities = { GetCurrentCampaignPreset().InitialSector }
	end

	if self.AllTowns then
		local cities = gv_Cities
		for k, city in pairs(cities) do
			local city_sectors = HUDA_GetControlledCitySectors(k)
			if next(city_sectors) then
				sector_posibilities[#sector_posibilities + 1] = city_sectors[1]
			end
		end
	else
		for id, sector in pairs(gv_Sectors) do
			if sector.Side == "player1" and (HUDA_ArrayContains(self.ValidDeliverySectors, id) or sector.MilitiaBase) then
				sector_posibilities[#sector_posibilities + 1] = id
			end
		end
	end
	if #sector_posibilities <= 1 then
		self:CreateMessageBox(T(28987978971001, "Edit Delivery Address"), T(28987978971002, "There are no other sectors available for delivery."))
		return
	end
	local popupHost = GetDialog("PDADialog")
	popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
	if not popupHost then
		self:CreateMessageBox(T(28987978971003, "Edit Address"), T(28987978971004, "Editing the delivery address is not possible at the moment."))
	end
	local pickDlg = XTemplateSpawn("PDAMilitiaShopAddressPicker", popupHost, {
		sectors = sector_posibilities
	})
	pickDlg:Open()
	return pickDlg
end

function HUDA_ShopController:ChangeDeliveryAddress(sectorId)
	gv_HUDA_ShopCart.sector = sectorId
	self:UpdateStatus("deliverySector", sectorId)
	ObjModified("shop address")
end

function HUDA_ShopController:Pay(cart)
	local total = self:GetTotalPrice(cart)

	if Game.Money < total then
		self:CreateMessageBox(T(28987978971011, "Not enough money"), T(28987978971012, "You don't have enough money to pay for this order."))
		return false
	end

	AddMoney(-total, "I.M.P.M.S.S.", true)

	return total
end

function HUDA_ShopController:CheckTierStatus(mail)
	local currentTier = Min(3, self:GetStatus("tier") or 1)

	if currentTier == 3 then
		return
	end

	local militiaUnits = table.filter(gv_UnitData, function(k, unit)
		return unit.militia and unit.HireStatus ~= "Dead"
	end)

	local militiaNum = 0

	for k, unit in pairs(militiaUnits) do
		militiaNum = militiaNum + 1
	end

	local newTier = currentTier

	if militiaNum >= 64 then
		newTier = 3
	elseif militiaNum >= 32 then
		newTier = 2
	elseif militiaNum >= 4 then
		newTier = 1
	end

	if newTier > currentTier then
		self:UpdateStatus("tier", newTier)

		if mail then
			self:SendMails("newTier", { tier = newTier })
		end
	end
end

function HUDA_ShopController:CreateMessageBox(title, text)
	local popupHost = GetDialog("PDADialog")
	popupHost = popupHost and popupHost:ResolveId("idPDAContainer")

	local dlg = CreateMessageBox(popupHost, title, text)
end

function HUDA_ShopController:SendMails(internalId, context)
	local id = internalId

	if internalId == "delivered" then
		id = "HUDA_ShipmentArrived"
		context = { location = GetSectorName(gv_Sectors[context.sector]) or context.sector }
	elseif internalId == "orderPlaced" then
		id = "HUDA_OrderPlaced"
	else
		id = "HUDA_" .. internalId
	end

	ReceiveEmail(id, context)
end

function HUDA_ShopController:NotifyDelivery(sector)
	CombatLog("important", T({
		Untranslated(
			"An online shop order was successfully delivered in sector <em><sector></em>"),
		sector = sector
	}))
end
