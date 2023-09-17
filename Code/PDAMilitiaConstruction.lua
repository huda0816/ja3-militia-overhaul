PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaConstruction",
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
                        T(145135869022, "Under Construction")
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
                        "This area is under construction. Please check back later."
                    })
                })
            })
        })
    })
})
