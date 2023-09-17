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
        PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
                local scrollBar = self.idScrollbar

                local lastScrollPos = scrollBar and scrollBar:GetScroll()

                XContentTemplate.RespawnContent(self)
                RunWhenXWindowIsReady(self, function()
                    if self.idScrollbar and lastScrollPos then
                        self.idScrollbar:SetScroll(lastScrollPos)
                    end
                    if self.idScrollArea and lastScrollPos then
                        self.idScrollArea:ScrollTo(0, lastScrollPos)
                    end
                end)
            end
        }),
        PlaceObj("XTemplateWindow", {
            "__class",
            "XContextFrame",
            "Dock",
            "top",
            "IdNode",
            false,
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
            "IdNode",
            false,
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
                    "Pending Orders"
                }),
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(0, 0, 0, 0),
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
                            return not HUDA_ArrayFind(gv_HUDA_ShopOrders, function(i, v)
                                return v.status == "pending"
                            end)
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
                            local pendingOrders = table.ifilter(gv_HUDA_ShopOrders, function(i, v)
                                return v.status == "pending"
                            end)

                            table.sort(pendingOrders, function(a, b)
                                return a.id > b.id
                            end)

                            return pendingOrders
                        end
                    }, {
                        PlaceObj("XTemplateTemplate", {
                            "__template",
                            "PDAMilitiaShopOrder"
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Padding",
                    box(0, 20, 0, 10),
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
                    "Order Archive"
                }),
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(0, 0, 0, 0),
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
                            return not HUDA_ArrayFind(gv_HUDA_ShopOrders, function(i, v)
                                return v.status ~= "pending"
                            end)
                        end,
                        'Text',
                        "No archived orders",
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
                            local archiveOrders = table.ifilter(gv_HUDA_ShopOrders, function(i, v)
                                return v.status ~= "pending"
                            end)

                            table.sort(archiveOrders, function(a, b)
                                return a.deliveryTime < b.deliveryTime
                            end)

                            return archiveOrders
                        end
                    }, {
                        PlaceObj("XTemplateTemplate", {
                            "__template",
                            "PDAMilitiaShopOrder"
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
                box(0, 5, 5, 5),
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
