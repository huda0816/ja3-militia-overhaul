PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopNav",
    PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
            return "shop nav"
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
            "Products"
        }),
        PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            3,
        }, {
            PlaceObj("XTemplateForEach", {
                "__context",
                function(parent, context, item, i, n)
                    return item
                end,
                "array",
                function(parent, context)
                    return HUDA_ShopController:GetAvailableCategories()
                end,
                "run_after",
                function(child, context, item, i, n, last)

                    local text = item.menuTitle or item.title

                    local productCount = item.hideProductCount and "" or "(" .. item.productCount .. ")"

                    child.idNavItem:SetText("<underline>" .. text .. productCount .."</underline>")
                    if (gv_HUDA_ShopQuery.category == item.id) then
                        child.idNavItem:SetTextStyle("PDABrowserThievesBoxLinksVisited")
                    end
                end
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    0,
                    "IdNode",
                    true,
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "__context",
                        function(parent, context)
                            return context
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "Id",
                        "idNavItem",
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "TextStyle",
                        "PDABrowserThievesBoxLinks",
                        "IdNode",
                        true,
                        "Translate",
                        true,
                        "Text",
                        "Placeholder"
                    }, {
                        PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonDown(self, pos, button)",
                            "func",
                            function(self, pos, button)
                                local dlg = GetDialog(self)

                                dlg:SetMode("trick", { query = { category = self.context.id }, item = self.context })
                                ObjModified(dlg)
                                ObjModified("right panel")
                                ObjModified("left panel")
                                ObjModified("militia header")
                                ObjModified("pda_url")
                            end
                        })
                    }),
                    PlaceObj("XTemplateTemplate", {
                        "__condition",
                        function(parent, context)
                            return context.id == "ammo" and gv_HUDA_ShopQuery.category == "ammo"
                        end,
                        "Id",
                        "idAmmoNav",
                        "__template",
                        "PDAMilitiaShopAmmoNav"
                    }),
                })
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "__condition",
                function(parent, context)
                    return #gv_HUDA_ShopOrders > 0
                end,
                "TextHAlign",
                "center",
                "Margins",
                box(0, 10, 0, 0),
                "Padding",
                box(2, 5, 2, 5),
                "BorderWidth",
                1,
                "BorderColor",
                RGBA(255, 255, 255, 255),
                "Background",
                RGBA(88, 92, 68, 255),
                "RolloverBorderColor",
                RGBA(65, 65, 65, 255),
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "TextStyle",
                "PDABrowserColaCopyright",
                "OnLayoutComplete",
                function(self)
                    local dlg = GetDialog(self)
                    if dlg.Mode == "orders" then
                        self:SetText("shop")
                    else
                        self:SetText("orders")
                    end
                end
            }, {
                PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                        if button == "L" then
                            local dlg = GetDialog(self)

                            if dlg.Mode == "orders" then
                                dlg:SetMode("shop")
                            else
                                dlg:SetMode("orders")
                            end
                        end
                        ObjModified("right panel")
                        -- ObjModified("left panel")
                        -- ObjModified("militia header")
                    end
                })
            })
        })
    })
})
