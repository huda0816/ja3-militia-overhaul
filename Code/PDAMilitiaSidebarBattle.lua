function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaSidebarBattle",
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                return "sidebar battle"
            end,
            "__class",
            "XContentTemplate",
            "LayoutMethod",
            "VList"
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "__condition",
                function(parent, context)
                    return context
                end,
                "__context",
                function(parent, context)
                    local conflicts = table.ifilter(gv_HUDA_ConflictTracker, function(i, v)
                        return v.resolved
                    end)

                    if #conflicts > 0 then
                        return conflicts[#conflicts]
                    end
                end,
                "Dock",
                "top",
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                10,
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idHeadline",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "FXMouseIn",
                    "buttonRollover",
                    "FXPress",
                    "buttonPress",
                    "FXPressDisabled",
                    "IactDisabled",
                    "TextStyle",
                    "PDAIMPMercBio",
                    "Translate",
                    true,
                    "Text",
                    "Latest Battle Report"
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idTitle",
                    "TextStyle",
                    "PDAIMPMercName",
                    "Translate",
                    true,
                    "Text",
                    Untranslated("<aar.title>")
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idText",
                    "MinHeight",
                    440,
                    "MaxHeight",
                    440,
                    "OnLayoutComplete",
                    function(self)
                        local old_height = self.content_box:maxy() - self.content_box:miny()
                        local line_height = self.font_height + self.font_linespace
                        local new_height = floatfloor(old_height / line_height) * line_height
                        if (0.0 + old_height) / line_height % 1 <= 0.9 then
                            local cb = self.content_box
                            self.content_box = box(cb:minx(), cb:miny(), cb:maxx(),
                                cb:miny() + new_height)
                        end
                    end,
                    "TextStyle",
                    "PDAIMPMercBio",
                    "Translate",
                    true,
                    "Text",
                    Untranslated("<aar.text>")
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idDots",
                    "Margins",
                    box(0, -20, 0, 0),
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
                    "..."
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            if button == "L" then
                                local dlg = GetDialog(self)

                                dlg:SetMode("aar",
                                    { aar = self.context, back = { mode = dlg.Mode, params = dlg.mode_param } })
                            end
                        end
                    })
                })
            })
        })
    })
end
