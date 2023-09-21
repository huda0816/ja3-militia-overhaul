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
            editor = "text"
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

PlaceObj('HUDAMilitiaShopDeliveryType', {
    id = "standard",
    title = "Standard",
    duration = 4,
    pricePerKilogram = 30,
    default = true
})

PlaceObj('HUDAMilitiaShopDeliveryType', {
    id = "express",
    title = "Express",
    duration = 2,
    pricePerKilogram = 100
})

PlaceObj('HUDAMilitiaShopDeliveryType', {
    id = "overnight",
    title = "Overnight",
    duration = 0,
    pricePerKilogram = 200
})