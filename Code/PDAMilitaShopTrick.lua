function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaShopTrick",
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
                    local dlg = GetDialog(self.parent)
                    if dlg.mode_param then
                        dlg:SetMode("shop_list", dlg.mode_param)
                    end
                end
            })
        })
    })
end
