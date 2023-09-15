PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopList",
    PlaceObj("XTemplateProperty", {
        "id",
        "NavButtonId",
        "editor",
        "text",
        "translate",
        false,
        "Set",
        function(self, value)
            self.NavButtonId = value
        end,
        "Get",
        function(self)
            return self.NavButtonId
        end,
        "name",
        T(536912996016, "NavButtonId")
    }),
    PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "__context",
        function(parent, context)
            return "shop list"
        end
    }, {
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                local dlg = GetDialog(parent)
                if dlg.mode_param then
                    context = dlg.mode_param
                end
                return context
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
                    AddPageToBrowserHistory("shop_list")
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
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(self.context.item.name)
                        end,
                        "Translate",
                        true,
                        "Text",
                        "<name>"
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
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(self.context.item.description)
                        end,
                        "Translate",
                        true,
                        "Text",
                        "<item<description>>"
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
                    box(20, 20, 20, 20),
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "VList",
                    "VScroll",
                    "idScrollbar"
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                            local query = table.copy(context.query)

                            query.new = true

                            local products = HUDA_ShopController:GetProducts(query)

                            return #products > 0
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "LayoutMethod",
                        "VList"
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
                            "New Arrivals"
                        }),
                        PlaceObj("XTemplateWindow", {
                            "Margins",
                            box(0, 0, 0, 0),
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
                                    local query = table.copy(context.query)

                                    query.new = true

                                    local products = HUDA_ShopController:GetProducts(query)

                                    return products
                                end
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShopProduct"
                                })
                            })
                        })
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                            local query = table.copy(context.query)

                            query.new = false

                            local products = HUDA_ShopController:GetProducts(query)

                            return #products > 0
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "LayoutMethod",
                        "VList"
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
                            "Products"
                        }),
                        PlaceObj("XTemplateWindow", {
                            "Margins",
                            box(0, 0, 0, 0),
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
                                    local query = table.copy(context.query)

                                    query.new = false

                                    local products = HUDA_ShopController:GetProducts(query)

                                    return products
                                end
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShopProduct"
                                })
                            })
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XZuluScroll",
                    "Id",
                    "idScrollbar",
                    "Margins",
                    box(0, 0, 0, 0),
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
