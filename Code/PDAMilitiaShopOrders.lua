PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopOrders",
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
        "__context",
        function(parent, context)
            return "order list"
        end,
        "__class",
        "XContentTemplate",
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
                "VList"
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
                    "Margin",
                    box(0, 0, 0, 10),
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "TextStyle",
                    "PDAIMPContentTitle",
                    "Translate",
                    true,
                    "Text",
                    T(145135869022, "Your orders")
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
                    "Here you can see the orders you have placed. Pending Orders can still be refunded."
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
                    box(0, 0, 0, 10),
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
                    T(157984480848, "Pending Orders")
                }),
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(0, 0, 20, 0),
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    10
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__class',
                        "XText",
                        "__condition",
                        function(parent, context)
                            return not next(gv_HUDA_ShopOrders)
                        end,
                        'Text',
                        "No pending orders",
                        "Id",
                        "idDate",
                        "Dock",
                        "left",
                        "TextStyle",
                        "PDAIMPMercBio"
                    }),
                    PlaceObj("XTemplateForEach", {
                        "__context",
                        function(parent, context, item, i, n)
                            return item
                        end,
                        "array",
                        function(parent, context)
                            return table.ifilter(gv_HUDA_ShopOrders, function(i, v)
                                return v.status == "pending"
                            end)
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            -- child[1][1]:SetText("Order date: " .. HUDA_ShopController:DateFromTime(item.orderTime))
                            child.idDate:SetText("Order date: " .. HUDA_ShopController:DateFromTime(item.orderTime))

                            child.idOrderNumber:SetText("Nr. " .. item.id)


                            child.idTotal:SetText((item.total or 0) .. "$")
                            child.idStatus:SetText("ETA: " .. HUDA_ShopController:GetETA(item) .. "d")
                        end
                    }, {
                        PlaceObj('XTemplateWindow', {
                            "IdNode",
                            true,
                            "Background",
                            RGBA(255, 255, 255, 255),
                            "LayoutMethod",
                            "VList",
                        }, {
                            PlaceObj('XTemplateWindow', {
                                "comment",
                                "header",
                                "LayoutMethod",
                                "HList",
                                "Margins",
                                box(5, 5, 5, 5),
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    '__class',
                                    "XText",
                                    'Text',
                                    "Datum",
                                    "Id",
                                    "idDate",
                                    "Dock",
                                    "left",
                                    "TextStyle",
                                    "PDAIMPMercBio",
                                }),
                                PlaceObj('XTemplateWindow', {
                                    '__class',
                                    "XText",
                                    'Text',
                                    "Ordernummer",
                                    "Id",
                                    "idOrderNumber",
                                    "Dock",
                                    "right",
                                    "TextStyle",
                                    "PDAIMPMercBio",
                                }),
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "__class",
                                "XImage",
                                "Margins",
                                box(0, 0, 0, 0),
                                "VAlign",
                                "center",
                                "Transparency",
                                141,
                                "Image",
                                "UI/PDA/separate_line_vertical",
                                "ImageFit",
                                "stretch-x"
                            }),
                            PlaceObj('XTemplateWindow', {
                                "comment",
                                "content",
                                "LayoutMethod",
                                "HList",
                                "Margins",
                                box(5, 5, 5, 5),
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    "comment",
                                    "produkte",
                                    "Dock",
                                    "left",
                                    "LayoutMethod",
                                    "VList",
                                }, {
                                    PlaceObj('XTemplateForEach', {
                                        "__context",
                                        function(parent, context, item, i, n)
                                            return item
                                        end,
                                        "array",
                                        function(parent, context)
                                            return context.products
                                        end,
                                        "run_after",
                                        function(child, context, item, i, n, last)
                                            child.idProductName:SetText(item.name .. " x " .. item.count)
                                        end
                                    }, {
                                        PlaceObj('XTemplateWindow', {
                                            "comment",
                                            "produkt",
                                            "IdNode",
                                            true,
                                            "LayoutMethod",
                                            "HList"
                                        }, {
                                            PlaceObj('XTemplateWindow', {
                                                '__class',
                                                "XText",
                                                'Text',
                                                "Produktname x 5",
                                                "Id",
                                                "idProductName",
                                                "TextStyle",
                                                "PDAIMPMercBio",
                                            }),
                                        }),
                                    }),
                                }),
                                PlaceObj('XTemplateWindow', {
                                    "comment",
                                    "rightbox",
                                    "Dock",
                                    "right",
                                    "LayoutMethod",
                                    "VList",
                                }, {
                                    PlaceObj('XTemplateWindow', {
                                        '__class',
                                        "XText",
                                        "Id",
                                        "idStatus",
                                        'Text',
                                        "Status / Lieferdatum",
                                        "HAlign",
                                        "right",
                                        "TextStyle",
                                        "PDAIMPMercBio",
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class',
                                        "XText",
                                        'Text',
                                        "Total",
                                        "Id",
                                        "idTotal",
                                        "HAlign",
                                        "right",
                                        "TextStyle",
                                        "PDAIMPMercBio",
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        'LayoutMethod',
                                        "HList",
                                        "Dock",
                                        "bottom",
                                        "HAlign",
                                        "right",
                                        'LayoutHSpacing',
                                        5
                                    }, {
                                        PlaceObj('XTemplateWindow', {
                                            '__class',
                                            "XText",
                                            "MouseCursor",
                                            "UI/Cursors/Pda_Hand.tga",
                                            'Text',
                                            "<underline>Buy again</underline>",
                                            "TextStyle",
                                            "PDABrowserThievesBoxLinks",
                                        }, {
                                            PlaceObj("XTemplateFunc", {
                                                "name",
                                                "OnMouseButtonDown(self, pos, button)",
                                                "func",
                                                function(self, pos, button)
                                                    HUDA_ShopController:OrderToCart(self.context)
                                                    ObjModified("order list")
                                                    ObjModified("right panel")
                                                    ObjModified("left panel")
                                                    ObjModified("militia header")
                                                end
                                            })
                                        }),
                                        PlaceObj('XTemplateWindow', {
                                            '__class',
                                            "XText",
                                            "MouseCursor",
                                            "UI/Cursors/Pda_Hand.tga",
                                            'Text',
                                            "<underline>Refund</underline>",
                                            "TextStyle",
                                            "PDABrowserThievesBoxLinks",
                                        }, {
                                            PlaceObj("XTemplateFunc", {
                                                "name",
                                                "OnMouseButtonDown(self, pos, button)",
                                                "func",
                                                function(self, pos, button)
                                                    HUDA_ShopController:Refund(self.context)
                                                    ObjModified("order list")
                                                    ObjModified("right panel")
                                                    ObjModified("left panel")
                                                    ObjModified("militia header")
                                                end
                                            })
                                        })                                        
                                    }),
                                })
                            }),
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
