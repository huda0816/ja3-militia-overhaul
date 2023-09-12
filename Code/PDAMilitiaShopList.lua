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
                print("PDAMilitiaShopList Open")
                AddPageToBrowserHistory("banner_page", "PDABrowserAskThieves")
                PDABrowserTabState.banner_page.mode_param = "PDABrowserAskThieves"
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
                    "OnContextUpdate",
                    function(self, context, ...)
                        self:SetText(context.item.name)
                    end,
                    "TextStyle",
                    "PDAIMPContentTitle",
                    "Translate",
                    true,
                    "Text",
                    T(145135869022, "Category bla")
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
                    "category bla text"
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
                            -- local query = next(gv_HUDA_ShopFilter) and gv_HUDA_ShopFilter or { topSeller = true }

                            local products = HUDA_ShopController:GetProducts(context.query)

                            return products
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            child.idProductName:SetText(item.name)
                            child.idProductDescription:SetText(item.description or "")
                            child.idProductPrice:SetText(item.basePrice .. "$")
                            child.idProductImage:SetImage(item.image)
                        end
                    }, {
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
                                        "PDAIMPHyperLinkSmall",
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
                                        "PDAIMPHyperLinkSmall",
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
                                }),

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
