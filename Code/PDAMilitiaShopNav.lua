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
                "array",
                function(parent, context)
                    return HUDA_ShopController:GetAvailableCategories()
                end,
                "run_after",
                function(child, context, item, i, n, last)
                    child.idNavItem:SetText("<underline>" .. item.name .. "(" .. item.productCount .. ")</underline>")
                    child.idNavItem:SetContext(item)
                end
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "LayoutMethod",
                    "VList",
                    "IdNode",
                    true,
                }, {
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
                        "PDAIMPHyperLinkSmall",
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

                                dlg:SetMode("trick", {query = {category = self.context.id}, item = self.context})
                                ObjModified(dlg)
                                ObjModified("right panel")
                                ObjModified("left panel")
                                ObjModified("militia header")
                                ObjModified("pda_url")
                            end
                        })
                    })
                })
            })
        })
    })
})
