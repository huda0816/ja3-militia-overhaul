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
            editor = "text"
        }
    }
}

DefineModItemPreset("HUDAMilitiaShopCouponCode", {
    EditorName = "Coupon Code",
    EditorSubmenu = "Other"
})

PlaceObj('HUDAMilitiaShopCouponCode', {
    id = "huda0816",
    discount = 50,
    multi = false,
    description = "50% off all Militia Shop items"
})

PlaceObj('HUDAMilitiaShopCouponCode', {
    id = "jadiscord",
    discount = 100,
    multi = false,
    description = "100% off all Militia Shop items"
})

PlaceObj('HUDAMilitiaShopCouponCode', {
    id = "bark0816",
    discount = 50,
    multi = false,
    description = "50% off all Militia Shop items"
})

PlaceObj('HUDAMilitiaShopCouponCode', {
    id = "reopen30",
    discount = 30,
    multi = false,
    description = "30% off all Militia Shop items"
})
