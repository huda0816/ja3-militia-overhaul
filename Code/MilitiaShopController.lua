GameVar("gv_HUDA_ShopInventory", {})
GameVar("gv_HUDA_ShopOrders", {})
GameVar("gv_HUDA_ShopCart", {})
GameVar("gv_HUDA_ShopQuery", {})
GameVar("gv_HUDA_ShopTierStatus", 1)
GameVar("gv_HUDA_ShopArrived", {})

function OnMsg.NewDay()
    HUDA_ShopController:Restock()
    HUDA_ShopController:RefreshOrders()
    HUDA_ShopController:CheckAbandonedCart()
end

DefineClass.HUDA_ShopController = {
    AbandonedCartTimeout = 1,
    Categories = HUDA_MilitiaShopCategories,
    InventoryTemplate = HUDA_MilitiaShopInventoryTemplate,
    DeliveryTypes = HUDA_MilitiaShopDeliveryTypes,
}

function HUDA_ShopController:SetInventoryTemplate(template)
    self.InventoryTemplate = template
end

function HUDA_ShopController:SetShopCategories(categories)
    self.Categories = categories
end

function HUDA_ShopController:SetDeliveryTypes(deliveryTypes)
    self.DeliveryTypes = deliveryTypes
end

function HUDA_ShopController:Restock()
    local tier = gv_HUDA_ShopTierStatus or 1

    local filteredProducts = table.ifilter(self.InventoryTemplate, function(_, product)
        return (product.tier or 1) <= tier
    end)

    local products = {}

    for _, product in ipairs(filteredProducts) do
        local roll = InteractionRand(100, "HUDA_ShopAvailability")

        print("Rolling for " ..
            product.id .. " with " .. roll .. " vs " .. product.availability + ((tier - product.tier) * 10))

        if roll < (product.availability or 100) + ((tier - product.tier) * 10) then
            local prod = table.copy(product)

            local tierBonus = 1 + ((tier - product.tier) * 0.5)

            print("Tier bonus for " .. product.id .. " is " .. tierBonus)

            local stock = round(product.stock * tierBonus, 1)

            print("Restocking " .. product.id .. " to " .. stock)

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
            local preparedCat = table.copy(category)

            preparedCat.productCount = #ps

            table.insert(categories, preparedCat)
        end
    end

    table.sort(categories, function(a, b)
        return a.weight < b.weight
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
        return deliveryType.pricePerItem * self:GetItemNum()
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
        return table.ifilter(preparedProducts, function(i, product)
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

    return preparedProducts
end

function HUDA_ShopController:PrepareProducts(products)
    local preparedProducts = {}

    if not next(gv_HUDA_ShopArrived) then
        gv_HUDA_ShopArrived = {}
        for i, product in ipairs(products) do
            table.insert(gv_HUDA_ShopArrived, product.id)
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

    self:SendMails("NewArrivals", {equipment = newProductsStr})
end

function HUDA_ShopController:PrepareProduct(product)
    local productData = g_Classes[product.id]

    if productData == nil then
        return product
    end

    if not table.find(gv_HUDA_ShopArrived, product.id) then
        product.new = true

        table.insert(gv_HUDA_ShopArrived, product.id)
    else
        product.new = false
    end

    product.description = product.description or productData.Description or ""
    product.name = productData.DisplayName
    product.categories = productData.Group or productData.objext_class
    product.image = productData.Icon

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
        table.insert(cartProducts, { id = product.id, count = count, name = product.name, price = product.basePrice })
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

    -- return self:DateFromTime(deliveryTime)
end

function HUDA_ShopController:DateFromTime(timeStamp)
    local t = GetTimeAsTable(timeStamp or 0)
    local month = string.format("%02d", t and t.month or 1)
    local day = string.format("%02d", t and t.day or 1)
    local year = tostring(t and t.year or 1)

    return month .. "/" .. day .. "/" .. year
end

function HUDA_ShopController:RefreshOrders()
    local orders = gv_HUDA_ShopOrders

    local time = Game.CampaignTime

    for i, order in ipairs(orders) do
        if order.status == "pending" then
            local deliveryDuration = self:GetDeliveryDuration(order)

            local deliveryTime = order.orderTime + deliveryDuration

            if time >= deliveryTime then
                HUDA_ShopController:Deliver(order)
            end
        end
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

    ObjModified(gv_HUDA_ShopOrders)
end

function HUDA_ShopController:EditAddress()
    self:CreateMessageBox("Edit Address", "Editing the delivery address is not possible at the moment.")
end

function HUDA_ShopController:Deliver(order)
    local items = {}

    for i, product in ipairs(order.products) do
        for j = 1, product.count do
            local item = PlaceInventoryItem(product.id)

            if item == nil then
                print("Item not found")
                return
            end

            table.insert(items, item)
        end
    end

    AddToSectorInventory(order.sector, items)

    order.status = "delivered"

    self:SendMails("delivered", { location = order.location or "H2" })
end

function HUDA_ShopController:Order()
    local cart = gv_HUDA_ShopCart

    local total = self:Pay(cart)

    if not total then
        return
    end

    local orders = gv_HUDA_ShopOrders;

    local order = {
        id = "order_" .. #orders + 1,
        products = cart.products,
        status = "pending",
        total = total,
        sector = "H2",
        orderTime = Game.CampaignTime,
        deliveryType = cart.deliveryType
    }

    gv_HUDA_ShopCart = {}

    table.insert(orders, order)

    self:CreateMessageBox("Order placed", "Your order has been placed. You will receive a notification when it arrives.")

    self:SendMails("orderPlaced")
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

function HUDA_ShopController:CreateMessageBox(title, text)
    local popupHost = GetDialog("PDADialog")
    popupHost = popupHost and popupHost:ResolveId("idPDAContainer")

    local dlg = CreateMessageBox(popupHost, title, text)
end

function HUDA_ShopController:SendMails(internalId, context)
    local id = internalId

    if internalId == "delivered" then
        id = "HUDA_ShipmentArrived"
        context = { location = GetSectorName(gv_Sectors[context.location]) or context.location }
    elseif internalId == "orderPlaced" then
        id = "HUDA_OrderPlaced"
    else
        id = "HUDA_" .. internalId
    end

    ReceiveEmail(id, context)
end
