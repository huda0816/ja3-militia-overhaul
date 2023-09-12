PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaSoldier",
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
            local dlg = GetDialog(parent)
            if dlg.mode_param and dlg.mode_param.solider then
                context = dlg.mode_param.solider
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
                "ChildrenHandleMouse",
                false
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idTitle",
                    "Padding",
                    box(0, 0, 0, 0),
                    "Margins",
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
                    "<Nick>"
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
                    "We are currently working on this section. Please check back later."
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
                    "Margins",
                    box(0, 0, 20, 0),
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
                        "We will be adding more content to this section soon."
                    })
                })
            })
        })
    })
})
