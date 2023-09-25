DefineClass.HUDAMilitiaShopCategory = {
    __parents = {
        "Preset",
        "ZuluModifiable",
    },
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
            id = "menuTitle",
            title = "Menu Name",
            help = "Name of the category in the menu. If empty title is used",
            editor = "text",
            default = false
        },
        {
            id = "image",
            title = "Category image",
            help = "Image of the category (optional)",
            editor = "ui_image",
            default = false
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
            help = "Fallback weight if no product or item weight is defined (in grams) 1000 = 1kg",
            editor = "number",
            default = 0
        },
        {
            id = "order",
            title = "Order",
            help = "Order of the category",
            editor = "number",
            default = 0
        },
        {
            id = "hideProductCount",
            title = "Hide Product Count",
            help = "Hide Item Number in the sidebar menu",
            editor = "bool",
            default = false
        }
    }
}

DefineModItemPreset("HUDAMilitiaShopCategory", {
    EditorName = "Shop Category",
    EditorSubmenu = "Militia Shop"
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
            default = 50,
            min = 0,
            max = 100
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
    EditorSubmenu = "Militia Shop"
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
            default = 0,
            min = 0
        },
        {
            id = "pricePerKilogram",
            name = "Price per Kilogram",
            help = "Price per Kilogram of the delivery",
            editor = "number",
            default = 0,
            min = 0
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
    EditorSubmenu = "Militia Shop"
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
            help = "Fallback weight of the Shop Item in grams (1000 = 1kg).",
            editor = "number",
            default = 0,
            min = 0,
        },
        {
            id = "order",
            title = "Order",
            help = "Order of the shop item in the category",
            editor = "number",
            default = 10
        },
        {
            id = "basePrice",
            title = "Base Price",
            help = "Base Price of the Shop Item",
            editor = "number",
            min = 0,
            default = 1000
        },
        {
            id = "stock",
            title = "Stock",
            help = "How many Items per restock are available.",
            editor = "number",
            min = 1,
            default = 1
        },
        {
            id = "tier",
            title = "Tier",
            help = "Tier of the Shop Item 1-5",
            editor = "number",
            min = 1,
            max = 5,
            default = 1
        },
        {
            id = "availability",
            title = "Availability",
            help = "Availability of the Shop Item. If it is below 100% there is a chance it will not be restocked",
            editor = "number",
            min = 0,
            max = 100,
            default = 100
        },
        {
            id = "topSeller",
            title = "Top Seller",
            help = "Is the Item a top Seller",
            editor = "bool",
            default = false
        },
        {
            id = "category",
            title = "Category",
            help = "Category of the Shop Item",
            editor = "text",
            default = false,
        },
    }
}

DefineModItemPreset("HUDAMilitiaShopInventoryItem", {
    EditorName = "Shop Product",
    EditorSubmenu = "Militia Shop"
})

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

function OnMsg.Autorun()
    LoadPresetFolder(CurrentModDef.content_path .. "presets/")
end

function OnMsg.ZuluGameLoaded()
    local categories = HUDAGetPresets('HUDAMilitiaShopCategory', 'Default', true)
    local inventoryTemplate = HUDAGetPresets('HUDAMilitiaShopInventoryItem', 'Default', true)
    local deliveryTypes = HUDAGetPresets('HUDAMilitiaShopDeliveryType', 'Default', true)
    local couponCodes = HUDAGetPresets('HUDAMilitiaShopCouponCode')

    HUDA_ShopController:SetPresets(deliveryTypes, categories, inventoryTemplate, couponCodes)
end
