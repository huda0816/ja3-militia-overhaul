-- categories = {Weapons, Ammo, Armor, Other}
-- subCategories = {Handguns, AssaultRifles, Shotguns, Rifles, MachineGuns, MeleeWeapons, HeavyWeapons, SubmachineGuns, Armor, Grenade, Components, Resource, Medicine, Tool}

function testRandom()
    local args = {
        tierRange = { 2, 3 },
        categories = { "Weapons" },
        subCategories = { "Handguns" },
        conditionRange = { 50, 80 }
    }

    local item, ammo = HUDA_MilitiaRandomItems:GetItem(args, true)

    Inspect({ item, ammo })
end

function testRandomMulti()
    local args = {
        tierRange = { 2, 3 },
        categories = { "Weapons" },
        conditionRange = { 50, 80 },
        number = 3
    }

    local items = HUDA_MilitiaRandomItems:GetItems(args)

    Inspect(items)
end

DefineClass.HUDA_MilitiaRandomItems = {}

function HUDA_MilitiaRandomItems:GetItem(args, ammoArgs)
    args = args or {}

    args.number = 1

    local items = self:GetItems(args)

    local item = items[1]

    local ammo

    if item and ammoArgs and item.base_Caliber then
        ammo = self:GetAmmo(item, ammoArgs)
    end

    return item, ammo
end

function HUDA_MilitiaRandomItems:GetAmmo(item, ammoArgs)
    local ammos = GetAmmosWithCaliber(item.base_Caliber, true)

    if not ammos then
        return
    end

    ammoArgs = type(ammoArgs) == "table" and ammoArgs or {}

    local ammoType = ammoArgs.type

    local ammo = ammos[1]

    if ammoType == "random" then
        ammo = ammos[InteractionRandRange(1, #ammos)]
    elseif ammoType then
        for _, a in ipairs(ammos) do
            if "Ammo" .. ammoType .. "Color" == a.colorStyle then
                ammo = a
            end
        end
    end

    local tempAmmo = PlaceInventoryItem(ammos[1].id)

    local ammoAmount = tempAmmo.MaxStacks

    if ammoArgs.amountRange or ammoArgs.amount then
        if ammoArgs.amount and not ammoArgs.amountRange then
            ammoArgs.amountRange = { ammoArgs.amount, ammoArgs.amount }
        end

        ammoAmount = InteractionRandRange(ammoArgs.amountRange[1], ammoArgs.amountRange[2])
    end

    tempAmmo.Amount = ammoAmount

    return tempAmmo
end

function HUDA_MilitiaRandomItems:GetItems(args)
    args = args or {}

    local defaults = {
        tierRange = { 1, 3 },          -- one can use tier instead
        categories = {},               -- empty array is random, or one can use category instead
        subCategories = {},            -- empty array is ramdom, or one can use subCategory instead
        numberRange = { 1, 1 },        -- one can use number instead
        conditionRange = { 100, 100 }, -- one can use condition instead
        stackRange = "ShopStackSize",
        draw = "RandRestockWeight"     -- possible values RestockWeight, even, RandRestockWeight
    }

    args = self:ParseArgs(args, defaults)

    local items = self:QueryItems(args)

    return items
end

function HUDA_MilitiaRandomItems:QueryItems(args)
    local maxTier = Max(args.tierRange[1], args.tierRange[2]) or 1
    local minTier = Min(args.tierRange[1], args.tierRange[2]) or 1

    local number = args.numberRange and InteractionRandRange(args.numberRange[1], args.numberRange[2]) or 1

    local filteredItems = {}

    ForEachPreset("InventoryItemCompositeDef", function(preset)
        local item = g_Classes[preset.id]

        if not item.CanAppearInShop then
            goto continue
        end

        if item.RestockWeight <= 0 then
            goto continue
        end

        if item.Tier > maxTier then
            goto continue
        end

        if item.Tier < minTier then
            goto continue
        end

        if not self:HasCatAndSubCat(item, args.categories, args.subCategories) then
            goto continue
        end

        table.insert(filteredItems, item)

        ::continue::
    end)

    local preparedItems = {}

    if args.draw == "RestockWeight" then
        table.sort(filteredItems, function(a, b)
            return a.RestockWeight < b.RestockWeight
        end)

        for n = 1, number do
            local item = filteredItems[n]

            if item then
                table.insert(preparedItems, self:PrepareItem(item.class, args))
            end
        end
    else
        for n = 1, number do
            local item = self:DrawItem(filteredItems, args.draw)

            if item then
                table.insert(preparedItems, self:PrepareItem(item.class, args))
            end
        end
    end

    return preparedItems
end

function HUDA_MilitiaRandomItems:PrepareItem(itemId, args)
    local item = PlaceInventoryItem(itemId)

    if args.conditionRange and args.conditionRange[1] ~= args.conditionRange[2] then
        local condition = InteractionRandRange(args.conditionRange[1], args.conditionRange[2])
        item.Condition = condition
    end

    if args.stackRange and args.stackRange ~= "ShopStackSize" then
        local stack = InteractionRandRange(args.stackRange[1], args.stackRange[2])
        item.Amount = stack
    elseif args.stackRange == "ShopStackSize" then
        item.Amount = item.ShopStackSize
    elseif args.stackRange then
        item.Amount = args.stackRange[1]
    end

    return item
end

function HUDA_MilitiaRandomItems:ParseArgs(args, defaults)
    local parsed = {}

    for k, v in pairs(defaults) do
        if k == "numberRange" and args.number then
            parsed.numberRange = { args.number, args.number }
        elseif k == "conditionRange" and args.condition then
            parsed.conditionRange = { args.condition, args.condition }
        elseif k == "stackRange" and args.stack and args.stack ~= "ShopStackSize" then
            parsed.stackRange = { args.stack, args.stack }
        elseif k == "tierRange" and args.tier then
            parsed.tierRange = { args.tier, args.tier }
        elseif k == "categories" and args.category then
            parsed.categories = args.category == "random" and {} or { args.category }
        elseif k == "subCategories" and args.subCategory then
            parsed.subCategories = args.subcategory == "random" and {} or { args.subCategory }
        else
            parsed[k] = args[k] or v
        end
    end

    return parsed
end

function HUDA_MilitiaRandomItems:DrawItem(items, draw)
    draw = draw or "RandRestockWeight"

    local total = 0

    if draw == "even" then
        total = #items
    else
        for _, v in ipairs(items) do
            total = total + v.RestockWeight
        end
    end

    local rand = InteractionRandRange(1, total)

    if draw == "even" then
        return items[rand]
    end

    local currentWeight = 0

    for _, v in ipairs(items) do
        currentWeight = currentWeight + v.RestockWeight

        if rand <= currentWeight then
            return v
        end
    end
end

function HUDA_MilitiaRandomItems:HasCatAndSubCat(item, requiredCats, requiredSubCats)
    if not next(requiredCats) and not next(requiredSubCats) then
        return true
    end

    if next(requiredCats) then
        local itemCat = item:GetCategory().id

        local hasCat = false

        for _, cat in ipairs(requiredCats) do
            if itemCat == cat then
                hasCat = true
            end
        end

        if not hasCat then
            return false
        end
    end

    if next(requiredSubCats) then
        local hasSubCat = false

        hasSubCat = self:HasArmorSubCat(item, requiredSubCats)

        if hasSubCat then
            return true
        end

        local itemSubCat = item:GetSubCategory().id

        for _, subCat in ipairs(requiredSubCats) do
            if itemSubCat == subCat then
                hasSubCat = true
            end
        end

        if not hasSubCat then
            return false
        end
    end

    return true
end

function HUDA_MilitiaRandomItems:HasArmorSubCat(item, requiredSubCats)
    local armorSubCats = { "Helmet", "Armor", "Leggings" }

    for _, subCat in ipairs(requiredSubCats) do
        for _, armorSubCat in ipairs(armorSubCats) do
            if subCat == armorSubCat and string.find(string.lower(item.class), string.lower(armorSubCat)) then
                return true
            end
        end
    end

    return false
end
