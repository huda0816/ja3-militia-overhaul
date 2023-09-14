PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShop",
    PlaceObj("XTemplateProperty", {
        "id",
        "HeaderButtonId",
        "editor",
        "text",
        "translate",
        false,
        "Set",
        function(self, value)
            self.HeaderButtonId = value
        end,
        "Get",
        function(self)
            return self.HeaderButtonId
        end,
        "name",
        T(536912996016, "HeaderButtonId")
    }),
    PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "__context",
        function(parent, context)
            return "shop front"
        end
    }, {
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                return gv_HUDA_ShopCart.products or {}
            end,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            8
        }, {
            PlaceObj("XTemplateFunc", {
                "name",
                "Open",
                "func",
                function(self, ...)
                    XWindow.Open(self, ...)
                    --   PDAImpHeaderEnable(self)
                end
            }),
            PlaceObj("XTemplateFunc", {
                "name",
                "OnDelete",
                "func",
                function(self, ...)
                    XWindow.OnDelete(self, ...)
                    --   PDAImpHeaderDisable(self)
                end
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XContextFrame",
                "Dock",
                "top",
                "Image",
                "UI/PDA/imp_panel",
                "FrameBox",
                box(8, 8, 8, 8),
                "ContextUpdateOnOpen",
                true
            }, {
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(20, 20, 20, 20),
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    10,
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idTitle",
                        "FoldWhenHidden",
                        true,
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPContentTitle",
                        "Translate",
                        true,
                        "Text",
                        T(145135869022, "I.M.P. MILITIA STAFF SHOP")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPContentText",
                        "Translate",
                        true,
                        "Text",
                        "Welcome to the Grand Chien Militia Staff Shop, the one-stop destination for all your militia needs! This place is for bona fide militia members only. Trying to sneak in? Well, let's just say our watchdogs have some rather persuasive ways of ensuring compliance. So, if you're part of the Grand Chien Militia, gear up and get ready to conquer."
                    })
                })
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XContextFrame",
                "Dock",
                "box",
                "Image",
                "UI/PDA/imp_panel",
                "FrameBox",
                box(8, 8, 8, 8),
                "ContextUpdateOnOpen",
                true
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XScrollArea",
                    "Id",
                    "idScrollArea",
                    "IdNode",
                    false,
                    "Margins",
                    box(20, 20, 0, 20),
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "VList",
                    "VScroll",
                    "idScrollbar"
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPContentTitle",
                        "Translate",
                        true,
                        "Text",
                        T(157984480848, "TOP SELLERS")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "Margins",
                        box(0, 0, 20, 0),
                        "LayoutMethod",
                        "VList"
                    }, {
                        PlaceObj("XTemplateForEach", {
                            "__context",
                            function(parent, context, item, i, n)
                                return item
                            end,
                            "array",
                            function(parent, context)
                                local query = { topSeller = true }

                                local products = HUDA_ShopController:GetProducts(query)

                                return products
                            end
                        }, {
                            PlaceObj("XTemplateTemplate", {
                                "__template",
                                "PDAMilitiaShopProduct"
                            }),
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XZuluScroll",
                    "Id",
                    "idScrollbar",
                    "Margins",
                    box(0, 0, 10, 0),
                    "Dock",
                    "right",
                    "UseClipBox",
                    false,
                    "Target",
                    "idScrollArea",
                    "AutoHide",
                    true
                })
            })
        })
    })
})
