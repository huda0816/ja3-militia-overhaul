PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopAddress",
    PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
            return "shop address"
        end,
        "__class",
        "XContentTemplate",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5,
        "Padding",
        box(5, 5, 5, 5),
        "Background",
        RGBA(255, 255, 255, 255)
    }, {
        PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "TextStyle",
            "PDAIMPMercName",
            "Translate",
            true,
            "Text",
            "Delivery Address"
        }),
        PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            3,
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(0, 0, 0, 0),
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "TextStyle",
                "PDAIMPMercBio",
                "Translate",
                true,
                "Text",
                Untranslated("Militia HQ\n<CurrentDeliveryAddress()>\nGrand Chien")
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(0, 0, 0, 0),
                "Id",
                "idNavItem",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "TextStyle",
                "PDABrowserThievesBoxLinks",
                "Translate",
                true,
                "Text",
                "<underline>Edit</underline>"
            }, {
                PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                        HUDA_ShopController:ChooseAddress()
                    end
                })
            })
        })
    })
})
