function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaShopUnavailable",
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
            PlaceObj("XTemplateFunc", {
                "name",
                "Open",
                "func",
                function(self, ...)
                    XWindow.Open(self, ...)
                    PDAImpHeaderEnable(self)
                end
            }),
            PlaceObj("XTemplateFunc", {
                "name",
                "OnDelete",
                "func",
                function(self, ...)
                    XWindow.OnDelete(self, ...)
                    PDAImpHeaderDisable(self)
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
                "__context",
                function(parent, context)
                    return gv_HUDA_ShopCart.products or {}
                end,
                "LayoutMethod",
                "VList",
                "IdNode",
                false,
                "LayoutVSpacing",
                8
            }, {
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
                            Untranslated("***Important Notice: Temporary Shop Closure***")
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
                            Untranslated("Dear Valued Members of the Grand Chien Militia,\n\nWe regret to inform you that due to current circumstances, the Grand Chien Militia Staff Shop is temporarily closed for business. The safety and security of our supply chain are paramount, and we must exercise caution during these challenging times.\n\nThe temporary closure is a result of Ernie Village, falling under the control of hostile forces. Shipping goods has become too perilous, putting our dedicated staff and precious cargo at risk.\n\nWe understand the inconvenience this may cause, but we want to emphasize the significance of regaining control of Ernie Village. By doing so, you ensure the swift reopening of the shop, allowing you to access the essential equipment and provisions you require.\n\nThank you for your understanding.\n\nSincerely,\n\nI.M.P. Militia Staff Shop Team")
                        })
                    })
                })
            })
        })
    })
end
