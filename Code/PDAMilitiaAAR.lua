function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaAAR",
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                local dlg = GetDialog(parent)
                context = dlg.mode_param
                return context
            end,
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XContextFrame",
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
                        "Id",
                        "idDate",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("<GetDateFromTime()>")
                    }),
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
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPContentTitle",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("<aar.aar.title>")
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
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPContentText",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("<aar.aar.text>")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Margins",
                        box(0, 5, 0, 0),
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "FXMouseIn",
                        "buttonRollover",
                        "FXPress",
                        "buttonPress",
                        "FXPressDisabled",
                        "IactDisabled",
                        "TextStyle",
                        "PDAIMPHyperLink",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("<underline>Back</underline>"),
                    }, {
                        PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonDown(self, pos, button)",
                            "func",
                            function(self, pos, button)
                                if button == "L" then
                                    local dlg = GetDialog(self)

                                    dlg:SetMode(self.context.back.mode, self.context.back.params)
                                end
                            end
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
end
