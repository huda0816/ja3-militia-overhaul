PlaceObj('PresetDef', {
    group = "PresetDefs",
    id = "HUDAMilitiaShopCategory",
    PlaceObj('PropertyDefText', {
        'id', "title",
    }),
    PlaceObj('PropertyDefText', {
        'id', "description",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "weight",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "order",
    }),
})

DefineClass.HUDAMilitiaShopCategory = {
    __parents = { "Preset" },
    __generated_by_class = "PresetDef",
    properties = {
        {
            id = "title",
            title = "Name",
            help = "Name of the category",
            editor = "text",
            default = ""
        },
        {
            id = "description",
            title = "Description",
            help = "Description of the category",
            editor = "text",
            default = ""
        },
        {
            id = "weight",
            title = "Weight",
            help = "Weight of the category",
            editor = "number",
            default = 0
        },
        {
            id = "order",
            title = "Order",
            help = "Order of the category",
            editor = "number",
            default = 0
        }
    }
}

DefineModItemPreset("HUDAMilitiaShopCategory", {
    EditorName = "Shop Category",
    EditorSubmenu = "Other"
})

PlaceObj('PresetDef', {
    group = "PresetDefs",
    id = "HUDAMilitiaShopCouponCode",
    PlaceObj('PropertyDefNumber', {
        'id', "discount",
    }),
    PlaceObj('PropertyDefBool', {
        'id', "multi",
    }),
    PlaceObj('PropertyDefText', {
        'id', "description",
    })
})

DefineClass.HUDAMilitiaShopCouponCode = {
    __parents = { "Preset" },
    __generated_by_class = "PresetDef",
    properties = {
        {
            id = "discount",
            name = "Discount",
            help = "Discount in percent",
            editor = "number",
            default = 50
        },
        {
            id = "multi",
            name = "Multi",
            help = "Is this a multi-use code",
            editor = "bool",
            default = false
        },
        {
            id = "description",
            name = "Description",
            help = "Description of the code",
            editor = "text",
            default = ""
        }
    }
}

DefineModItemPreset("HUDAMilitiaShopCouponCode", {
    EditorName = "Coupon Code",
    EditorSubmenu = "Other"
})

PlaceObj('PresetDef', {
    group = "PresetDefs",
    id = "HUDAMilitiaShopDeliveryType",
    PlaceObj('PropertyDefText', {
        'id', "title",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "duration",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "pricePerKilogram",
    }),
    PlaceObj('PropertyDefBool', {
        'id', "default",
    }),
})

DefineClass.HUDAMilitiaShopDeliveryType = {
    __parents = { "Preset" },
    __generated_by_class = "PresetDef",
    properties = {
        {
            id = "title",
            name = "Name",
            help = "Name of the delivery type",
            editor = "text",
            default = ""
        },
        {
            id = "duration",
            name = "Duration",
            help = "Duration of the delivery in days",
            editor = "number",
            default = 0
        },
        {
            id = "pricePerKilogram",
            name = "Price per Kilogram",
            help = "Price per Kilogram of the delivery",
            editor = "number",
            default = 0
        },
        {
            id = "default",
            name = "Default",
            help = "Is this the default delivery type",
            editor = "bool",
            default = false
        }
    }
}

DefineModItemPreset("HUDAMilitiaShopDeliveryType", {
    EditorName = "Delivery Type",
    EditorSubmenu = "Other"
})

PlaceObj('PresetDef', {
    group = "PresetDefs",
    id = "HUDAMilitiaShopInventoryItem",
    PlaceObj('PropertyDefText', {
        'id', "description",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "weight",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "order",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "basePrice",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "stock",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "tier",
    }),
    PlaceObj('PropertyDefNumber', {
        'id', "availability",
    }),
    PlaceObj('PropertyDefBool', {
        'id', "topSeller",
    }),
    PlaceObj('PropertyDefText', {
        'id', "category",
    }),
})


DefineClass.HUDAMilitiaShopInventoryItem = {
    __parents = { "Preset" },
    __generated_by_class = "PresetDef",
    properties = {
        {
            id = "description",
            title = "Description",
            help = "Description of the Shop Item",
            editor = "text",
            default = ""
        },
        {
            id = "weight",
            title = "Weight",
            help = "Weight of the Shop Item",
            editor = "number",
            default = 0
        },
        {
            id = "order",
            title = "Order",
            help = "Order of the category",
            editor = "number",
            default = 10
        },
        {
            id = "basePrice",
            title = "Base Price",
            help = "Base Price of the Shop Item",
            editor = "number",
            default = 1000
        },
        {
            id = "stock",
            title = "Stock",
            help = "Stock of the Shop Item",
            editor = "number",
            default = 1
        },
        {
            id = "tier",
            title = "Tier",
            help = "Tier of the Shop Item",
            editor = "number",
            default = 1
        },
        {
            id = "availability",
            title = "Availability",
            help = "Availability of the Shop Item",
            editor = "number",
            default = 100
        },
        {
            id = "topSeller",
            title = "Top Seller",
            help = "Top Seller of the Shop Item",
            editor = "bool",
            default = false
        },
        {
            id = "category",
            title = "Category",
            help = "Category of the Shop Item",
            editor = "text",
            default = ""
        },
    }
}

DefineModItemPreset("HUDAMilitiaShopInventoryItem", {
    EditorName = "Shop Product",
    EditorSubmenu = "Other"
})

function OnMsg.Autorun()
    LoadPresetFiles(CurrentModDef.content_path .. "presets/")
    LoadPresetFolders(CurrentModDef.content_path .. "presets/")

    HUDA_ShopController.Categories = HUDAGetPresets('HUDAMilitiaShopCategory', 'Default', true)
    HUDA_ShopController.InventoryTemplate = HUDAGetPresets('HUDAMilitiaShopInventoryItem', 'Default', true)
    HUDA_ShopController.DeliveryTypes = HUDAGetPresets('HUDAMilitiaShopDeliveryType', 'Default', true)
    HUDA_ShopController.CouponCodes = HUDAGetPresets('HUDAMilitiaShopCouponCode')
end

GameVar("gv_HUDA_ShopInventory", {})
GameVar("gv_HUDA_ShopOrders", {})
GameVar("gv_HUDA_ShopCart", {})
GameVar("gv_HUDA_ShopQuery", {})
GameVar("gv_HUDA_ShopCouponCodes", {})
GameVar("gv_HUDA_ShopStatus", {})

-- TFormat

function TFormat.CurrentDeliveryAddress()
    return HUDA_ShopController:GetCurrentDeliveryAddress()
end

-- Hooks

function OnMsg.NewDay()
    if not gv_HUDA_ShopStatus or not gv_HUDA_ShopStatus.initialized or not gv_HUDA_ShopStatus.open then
        return
    end

    HUDA_ShopController:MaybeRestock()
    HUDA_ShopController:CheckAbandonedCart()
end

function OnMsg.NewHour()
    local t = GetTimeAsTable(Game.CampaignTime)

    if not gv_HUDA_ShopStatus.initialized then
        return
    end

    if t.hour > 7 and t.hour < 13 then
        HUDA_ShopController:RefreshOrders(t)
    end

    if not gv_HUDA_ShopStatus.open then
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
    HUDA_ShopController:InitGVs()
end

-- Functions

function HUDAGetPresets(id, group, array)
    group = group or "Default"

    if not Presets[id] then
        return {}
    end

    local presets = {}

    for k, v in pairs(Presets[id][group]) do
        if type(k) == "string" then
            if array then
                table.insert(presets, v)
            else
                presets[k] = v
            end
        end
    end

    return presets
end

DefineClass.HUDA_ShopController = {
    AbandonedCartTimeout = 1,
    Categories = HUDA_MilitiaShopCategories, -- HUDAGetPresets('HUDAMilitiaShopCategory', 'Default', true),
    InventoryTemplate = HUDA_MilitiaShopInventoryTemplate, -- HUDAGetPresets('HUDAMilitiaShopInventoryItem', 'Default', true),
    DeliveryTypes = HUDA_MilitiaShopDeliveryTypes, -- HUDAGetPresets('HUDAMilitiaShopDeliveryType', 'Default', true),
    CouponCodes = HUDA_MilitiaShopCouponCodes, -- HUDAGetPresets('HUDAMilitiaShopCouponCode'),
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



function HUDA_ShopController:InitGVs()
    if not gv_HUDA_ShopStatus.initialized then
        return
    end

    self:UpdateCouponCodes()

    self:Restock()
end

function HUDA_ShopController:Init()
    if gv_HUDA_ShopStatus.initialized then
        return
    end

    if not self.AlwaysOpen and not self:CheckSectorStatus(false) then
        return
    end

    Msg("HUDAMilitaShopBeforeInit")

    gv_HUDA_ShopStatus = self.ShopStatus

    gv_HUDA_ShopStatus.initialized = true

    gv_HUDA_ShopStatus.open = true

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
        gv_HUDA_ShopStatus.open = true
    else
        if not self:CheckSectorStatus(false) then
            gv_HUDA_ShopStatus.open = false
        end
    end
end

function HUDA_ShopController:SetTier(tier)
    self.ShopStatus.tier = tier

    local currentTier = gv_HUDA_ShopStatus.tier or 1

    if tier > currentTier then
        gv_HUDA_ShopStatus.tier = tier
    end
end

function HUDA_ShopController:CheckSectorStatus()
    if not self.SectorCondition then
        return true
    end

    local sector = gv_Sectors[self.SectorCondition]

    if not sector then
        return true
    end

    if sector.Side == "player1" then
        return true
    end

    return false
end

function HUDA_ShopController:CheckSectorChange(sectorId, oldSide, newSide)
    if not gv_HUDA_ShopStatus.initialized then
        if newSide == "player1" and sectorId == self.SectorCondition then
            self:Init()
        end
        return
    end

    if sectorId == self.SectorCondition then
        if newSide == "player1" then
            gv_HUDA_ShopStatus.open = true

            gv_HUDA_ShopCouponCodes.reopen30.used = false

            self:SendMails("HUDA_ShopReopened")
        elseif not self.AlwaysOpen then
            gv_HUDA_ShopStatus.open = false

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

    gv_HUDA_ShopStatus.topSellers = top
end

function HUDA_ShopController:GetTopSellers(number)
    local top = gv_HUDA_ShopStatus.topSellers

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
        self:CreateMessageBox("Coupon already used", "This coupon has already been used.")
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

function HUDA_ShopController:AddInventoryProduct(product, restock)
    table.insert(self.InventoryTemplate, product)
    if restock then
        self:Restock()
    end
end

function HUDA_ShopController:AddInventoryProducts(products, restock)
    for _, product in ipairs(products) do
        table.insert(self.InventoryTemplate, product)
    end
    if restock then
        self:Restock()
    end
end

function HUDA_ShopController:AddCouponCode(code, data, notUpdate)
    if not code or not data then
        return
    end

    code = string.lower(code)

    if self.CouponCodes[code] then
        return
    end

    self.CouponCodes[code] = data

    if not notUpdate then
        self:UpdateCouponCodes()
    end
end

function HUDA_ShopController:AddCouponCodes(codes)
    for code, data in pairs(codes) do
        self:AddCouponCode(code, data, true)
    end

    self:UpdateCouponCodes()
end

function HUDA_ShopController:SetShopCategories(categories)
    self.Categories = categories
end

function HUDA_ShopController:AddShopCategory(category)
    table.insert(self.Categories, category)
end

function HUDA_ShopController:AddShopCategories(categories)
    for _, category in ipairs(categories) do
        table.insert(self.Categories, category)
    end
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
    local id = gv_HUDA_ShopCart.sector or gv_HUDA_ShopStatus.deliverySector or "H2"

    return GetSectorName(gv_Sectors[id])
end

function HUDA_ShopController:MaybeRestock(sectors)
    if self.DailyRestock then
        gv_HUDA_ShopStatus.lastRestock = 0
        self:Restock()
        return
    end

    local daysSinceLastRestock = gv_HUDA_ShopStatus.lastRestock or 0

    gv_HUDA_ShopStatus.lastRestock = daysSinceLastRestock + 1

    if not daysSinceLastRestock or daysSinceLastRestock < 1 then
        return
    end

    local restockRoll = InteractionRand(6, "HUDA_ShopRestock")

    if restockRoll > daysSinceLastRestock then
        return
    end

    gv_HUDA_ShopStatus.lastRestock = 0

    self:Restock()
end

function HUDA_ShopController:Restock()
    Msg("HUDAMilitaShopBeforeRestock")

    local tier = gv_HUDA_ShopStatus.tier or 1



    local filteredProducts = table.ifilter(self.InventoryTemplate, function(_, product)
        return tonumber(product.tier or 1) <= tonumber(tier)
    end)

    local products = {}

    for i, product in ipairs(filteredProducts) do
        local roll = InteractionRand(100, "HUDA_ShopAvailability")

        if roll < (product.availability or 100) + ((tier - product.tier) * 10) then
            local prod = table.raw_copy(product)

            local tierBonus = 1 + ((tier - product.tier) * 0.5)

            local stock = round(product.stock * tierBonus, 1)

            if self.StockMultiplier then
                stock = round(stock * self.StockMultiplier, 1)
            else
                local stockRoll = InteractionRandRange(80, 120, "HUDA_ShopStock")

                stock = MulDivRound(stock, stockRoll, 100)
            end

            prod.stock = stock

            table.insert(products, prod)
        end
    end

    gv_HUDA_ShopInventory = self:PrepareProducts(products)
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
            local preparedCat = category

            preparedCat.productCount = #ps

            table.insert(categories, preparedCat)
        end
    end

    table.sort(categories, function(a, b)
        return a.order < b.order
    end)

    return categories
end

function HUDA_ShopController:GetProductPrice()
    local cart = gv_HUDA_ShopCart

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

        return MulDivRound(deliveryType.pricePerKilogram, weight, 100)
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

    if query.num then
        return table.move(preparedProducts, 1, query.num, 1, {})
    end

    return preparedProducts
end

function HUDA_ShopController:PrepareProducts(products)
    local preparedProducts = {}

    if not next(gv_HUDA_ShopStatus.arrived) then
        gv_HUDA_ShopStatus.arrived = {}
        for i, product in ipairs(products) do
            table.insert(gv_HUDA_ShopStatus.arrived, product.id)
        end
    end

    for i, product in ipairs(products) do
        product = self:PrepareProduct(product)

        table.insert(preparedProducts, product)
    end

    self:CheckNewArrivals(preparedProducts)

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

function HUDA_ShopController:PrepareProduct(product)
    local productData = g_Classes[product.id]

    if productData == nil then
        return product
    end

    if not table.find(gv_HUDA_ShopStatus.arrived, product.id) then
        product.new = true

        table.insert(gv_HUDA_ShopStatus.arrived, product.id)
    else
        product.new = false
    end

    product.description = product.description or productData.Description or ""
    product.name = productData.DisplayName
    product.categories = productData.Group or productData.objext_class
    product.image = productData.Icon
    product.weight = product.weight or productData.Weight

    if productData.Caliber then
        product.caliber = productData.Caliber
        product.caliberName = self:GetCaliberName(productData.Caliber)
    end

    return product
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
        self:CreateMessageBox("Sold out", "This product is out of stock.")

        return
    end

    if inventoryProduct.stock < count then
        self:CreateMessageBox("Not enough in stock",
            "There are only " .. inventoryProduct.stock .. " items left in stock.")

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
               
                price = product
                            .basePrice
           
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
        inventoryProduct.stock = inventoryProduct.stock + count
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
        self:CreateMessageBox("Sold out", table.concat(stockMessageArr, "\n"))
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
        if product.category == "ammo" then
            
            local numOfItems = product.count / 500

            local remainder = product.count % 500

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
                    item.Amount = 500
                end

                table.insert(items, item)
            end
        else
            for j = 1, product.count do
                local item = PlaceInventoryItem(product.id)

                if item == nil then
                    return
                end

                table.insert(items, item)
            end
        end
    end

    AddToSectorInventory(order.sector, items)

    order.status = "delivered"
    order.deliveryTime = Game.CampaignTime

    self:SendMails("delivered", { sector = order.sector or "H2" })
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

    gv_HUDA_ShopCart = {}

    table.insert(orders, order)

    self:CreateMessageBox("Order placed", "Your order has been placed. You will receive a notification when it arrives.")

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
        for i, sectorId in ipairs(self.ValidDeliverySectors) do
            local sector = gv_Sectors[sectorId]

            if sector.Side == "player1" then
                sector_posibilities[#sector_posibilities + 1] = sectorId
            end
        end
    end
    if #sector_posibilities <= 1 then
        self:CreateMessageBox("Edit Delivery Address", "There are no other sectors available for delivery.")
        return
    end
    local popupHost = GetDialog("PDADialog")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
    if not popupHost then
        self:CreateMessageBox("Edit Address", "Editing the delivery address is not possible at the moment.")
    end
    local pickDlg = XTemplateSpawn("PDAMilitiaShopAddressPicker", popupHost, {
        sectors = sector_posibilities
    })
    pickDlg:Open()
    return pickDlg
end

function HUDA_ShopController:ChangeDeliveryAddress(sectorId)
    gv_HUDA_ShopCart.sector = sectorId
    gv_HUDA_ShopStatus.deliverySector = sectorId
    ObjModified("shop address")
end

function HUDA_ShopController:Pay(cart)
    local total = self:GetTotalPrice(cart)

    if Game.Money < total then
        self:CreateMessageBox("Not enough money", "You don't have enough money to pay for this order.")
        return false
    end

    AddMoney(-total, "I.M.P.M.S.S.", true)

    return total
end

function HUDA_ShopController:CheckTierStatus(mail)
    local currentTier = gv_HUDA_ShopStatus.tier

    if currentTier == 5 then
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
        newTier = 5
    elseif militiaNum >= 48 then
        newTier = 4
    elseif militiaNum >= 32 then
        newTier = 3
    elseif militiaNum >= 16 then
        newTier = 2
    elseif militiaNum >= 4 then
        newTier = 1
    end

    if newTier > currentTier then
        gv_HUDA_ShopStatus.tier = newTier

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
