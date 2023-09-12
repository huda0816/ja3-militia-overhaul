GameVar("gv_HUDA_ShopInventory", {})
GameVar("gv_HUDA_ShopOrders", {})
GameVar("gv_HUDA_ShopCart", {})
GameVar("gv_HUDA_ShopFilter", {})
GameVar("gv_HUDA_ShopSelectedDeliveryType", "standard")

function OnMsg.NewDay()
    HUDA_ShopController:Restock()
    HUDA_ShopController:RefreshOrders()
end

DefineClass.HUDA_ShopController = {
    Categories = {
        {
            id = "assault",
            name = "Assault Rifles",
            description = "Find the best assault rifles here!",
            weight = 10
        },
        {
            id = "pistols",
            name = "Pistols",
            description = "Find the best pistols here!",
            weight = 20
        },
        {
            id = "armor",
            name = "Armor",
            description = "Find the best armor here!",
            weight = 30
        },
        {
            id = "ammo",
            name = "Ammo",
            description = "Find the best ammo here!",
            weight = 40
        },
        {
            id = "explosives",
            name = "Explosives",
            description = "Find the best explosives here!",
            weight = 50
        },
        {
            id = "tools",
            name = "Tools",
            description = "Find the best tools here!",
            weight = 60
        },
        {
            id = "misc",
            name = "Misc",
            description = "Find the best misc items here!",
            weight = 70
        }
    },
    InventoryTemplate = {
        {
            id = "FAMAS",
            stock = 5,
            basePrice = 1000,
            topSeller = true,
            category = "assault",
            tier = 1,
            supply = 100
        },
        {
            id = "KevlarHelmet",
            stock = 2,
            basePrice = 500,
            topSeller = true,
            category = "armor",
            tier = 2,
            supply = 100
        },
        {
            id = "KevlarVest",
            stock = 2,
            basePrice = 500,
            category = "armor",
            tier = 2,
            supply = 100
        },
        {
            id = "AK47",
            stock = 2,
            basePrice = 1500,
            category = "assault",
            tier = 2,
            supply = 100
        },
        {
            id = "Glock18",
            stock = 2,
            basePrice = 500,
            category = "pistols",
            tier = 2,
            supply = 50
        }
    },
    DeliveryTypes = {
        {
            id = "standard",
            name = "Standard",
            duration = 3,
            pricePerItem = 50,
            pricePerKilogram = 50,
            default = true
        },
        {
            id = "express",
            name = "Express",
            duration = 1,
            pricePerItem = 300,
            pricePerKilogram = 300
        },
        {
            id = "overnight",
            name = "Overnight",
            duration = 0,
            pricePerItem = 600,
            pricePerKilogram = 600
        }
    },
}

function HUDA_ShopController:Restock()
    gv_HUDA_ShopInventory = self.InventoryTemplate
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

function HUDA_ShopController:GetProducts(query)
    print("HUDA_ShopController:GetProducts", query.topSellers)

    local preparedProducts = self:PrepareProducts(gv_HUDA_ShopInventory)

    if query then
        return table.ifilter(preparedProducts, function(i, product)
            print(product.name, product.topSeller)

            if query.topSeller and not product.topSeller then
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

    for i, product in ipairs(products) do
        product = self:PrepareProduct(product)

        table.insert(preparedProducts, product)
    end

    return preparedProducts
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
    end

    return params ~= "" and "?" .. params or ""
end

function HUDA_ShopController:AddToCart(product, count)
    local cart = gv_HUDA_ShopCart

    cart.lastModified = Game.CampaignTime

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
end

function HUDA_ShopController:RemoveFromCart(product, count)
    local cart = gv_HUDA_ShopCart

    if not cart.products or not next(cart.products) then
        return
    end

    local productsInCarts = table.ifilter(cart.products, function(i, cartProduct)
        return cartProduct.id == product.id
    end)

    if not next(productsInCarts) then
        return
    end

    local productInCart = productsInCarts[1]

    if productInCart == nil then
        return
    end

    if count and count < productInCart.count then
        productInCart.count = productInCart.count - count
    else
        table.remove(cart.products, HUDA_GetArrayIndex(cart, productInCart))
    end
end

function HUDA_ShopController:ClearCart()
    local cart = gv_HUDA_ShopCart

    cart.products = {}
end

function HUDA_ShopController:PrepareProduct(product)
    local productData = g_Classes[product.id]

    if productData == nil then
        return product
    end

    product.description = productData.Description or ""
    product.name = productData.DisplayName
    product.categories = productData.Group or productData.objext_class
    product.image = productData.Icon

    return product
end

function HUDA_ShopController:GetDeliveryDuration(order)
    local deliveryDuration = order.deliveryType.duration or 3

    return deliveryDuration * 60 * 60 * 24
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

    ObjModified(gv_HUDA_ShopOrders)
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

    self:SendMails("delivered", { localtion = "H2" })
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
    elseif internalId == "orderPlaced" then
        id = "HUDA_OrderPlaced"
    end

    ReceiveEmail(id, context)
end

-------------------------------------- EMAILS --------------------------------------

PlaceObj('Email', {
    body =
    "Dear customer,\n\nWe are happy to inform you that your order has been delivered to <location>.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P. Customer Service",
    group = "Militia",
    label = "Important",
    id = "HUDA_ShipmentArrived",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Order delivered",
    repeatable = true,
})

PlaceObj('Email', {
    body =
    "Dear customer,\n\nWe received your order and are preparing it for delivery.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P. Customer Service",
    group = "Militia",
    id = "HUDA_OrderPlaced",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Thank you for your order",
    repeatable = true,
})
