PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopAmmoNav",
    PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
            return "shop ammo nav"
        end,
        "__class",
        "XContentTemplate",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        0,
        "Padding",
        box(5, 0, 5, 0),
        "Background",
        RGBA(255, 255, 255, 255)
    }, {

        PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
                return HUDA_ShopController:GetCalibers(table.ifilter(gv_HUDA_ShopInventory, function(k, v)
                    return v.category == "ammo"
                end))
            end,
            "run_after",
            function(child, context, item, i, n, last)
                child.idAmmoNavItem:SetText("<underline>" .. item.Name .. "</underline>")
                child.idAmmoNavItem:SetContext(item)
                if (gv_HUDA_ShopQuery.caliber == item.id) then
                    child.idAmmoNavItem:SetTextStyle("PDABrowserThievesBoxLinksVisited")
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
                    "Margins",
                    box(0, 0, 0, 0),
                    "Id",
                    "idAmmoNavItem",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
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

                            dlg:SetMode("trick",
                                {
                                    query = { category = "ammo", caliber = self.context.id },
                                    item = { name = self.context.Name .. " ammunition",
                                        description = "Get " .. self.context.Name .. " ammunition here" }
                                })
                            ObjModified(dlg)
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                            ObjModified("pda_url")
                        end
                    })
                })
            })
        }),

    })
})
