PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopProduct",
    PlaceObj("XTemplateWindow", {
        "IdNode",
        true,
        "Margins",
        box(0, 10, 0, 10),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20,
        "Background",
        RGBA(255, 255, 255, 255)
    }, {
        PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 0, 0, 0),
            "Background",
            RGBA(230, 222, 202, 255)
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idItemBG",
                "IdNode",
                false,
                "MinWidth",
                140,
                "MinHeight",
                140,
                "MaxWidth",
                140,
                "MaxHeight",
                140,
                "Image",
                "UI/Hud/portrait_background",
                "ImageFit",
                "stretch"
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idProductImage",
                "MinWidth",
                140,
                "MinHeight",
                140,
                "MaxWidth",
                140,
                "MaxHeight",
                140,
                "Image",
                "UI/MercsPortraits/Igor",
                "VAlign",
                "center",
                "HAlign",
                "center",
                "ImageFit",
                "width"
            })
        }),
        PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 5, 0, 5),
            "HAlign",
            "left",
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            0
        }, {
            PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "center",
                "Dock",
                "top",
                "LayoutMethod",
                "HList",
                "LayoutVSpacing",
                0
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idProductName",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAIMPMercName",
                    "TextHAlign",
                    "left"
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idProductPrice",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAIMPGalleryName",
                    "Translate",
                    true,
                    "TextHAlign",
                    "left",
                    "TextVAlign",
                    "center"
                })
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idProductDescription",
                "HandleMouse",
                false,
                "MaxWidth",
                480,
                "MaxHeight",
                80,
                "TextStyle",
                "PDAIMPGalleryName",
                "Translate",
                true,
                "TextHAlign",
                "left"
            }),
            PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 0, 0),
                "HAlign",
                "left",
                "LayoutMethod",
                "HList",
                "Dock",
                "bottom",
                "LayoutHSpacing",
                5
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idAddToCart",
                    "TextHAlign",
                    "Right",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "Text",
                    "<underline>Add to cart</underline>"
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:AddToCart(self.context, 1)
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                        end
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idAdd5ToCart",
                    "TextHAlign",
                    "Right",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "Text",
                    "<underline>Add 5x to cart</underline>"
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:AddToCart(self.context, 5)
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                        end
                    })
                })
            })
        })
    })
})
