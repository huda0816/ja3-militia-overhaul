function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        __is_kind_of = "XDialog",
        group = "Zulu PDA",
        id = "PDAMilitiaPrisonPicker",
        PlaceObj("XTemplateWindow", {
            "__class",
            "ZuluModalDialog",
            "Id",
            "idMain",
            "Background",
            RGBA(30, 30, 35, 115),
            "HostInParent",
            true
        }, {
            PlaceObj("XTemplateWindow", {
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                742,
                "MinHeight",
                370,
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                -7
            }, {
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "header",
                    "Dock",
                    "top",
                    "MinHeight",
                    24,
                    "MaxHeight",
                    24
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XFrame",
                        "Image",
                        "UI/PDA/os_header",
                        "FrameBox",
                        box(5, 5, 5, 5),
                        "SqueezeY",
                        false
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idTitle",
                        "Margins",
                        box(10, 0, 0, 0),
                        "VAlign",
                        "center",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAQuests_HeaderSmall",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("Choose a Sector"),
                        "TextVAlign",
                        "center"
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "content",
                    "Dock",
                    "box"
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XFrame",
                        "IdNode",
                        false,
                        "Margins",
                        box(0, -3, 0, 0),
                        "Dock",
                        "box",
                        "Image",
                        "UI/PDA/Event/T_Event_Background",
                        "FrameBox",
                        box(5, 5, 5, 5)
                    }),
                    PlaceObj("XTemplateWindow", {
                        "Padding",
                        box(10, 10, 10, 10)
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "select prisons",
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "Margins",
                                box(0, 2, 0, 0),
                                "Dock",
                                "top"
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XFrame",
                                    "Dock",
                                    "box",
                                    "Image",
                                    "UI/PDA/os_background",
                                    "FrameBox",
                                    box(3, 3, 3, 3)
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idText",
                                    "Padding",
                                    box(15, 5, 15, 10),
                                    "Dock",
                                    "bottom",
                                    "TextStyle",
                                    "PDARolloverText",
                                    "Translate",
                                    true,
                                    "Text",
                                    Untranslated("Choose a sector where the prisoners will be sent to")
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XList",
                                "Id",
                                "idList",
                                "IdNode",
                                false,
                                "Margins",
                                box(0, 10, 0, 0),
                                "BorderWidth",
                                0,
                                "Dock",
                                "top",
                                "LayoutVSpacing",
                                5,
                                "Background",
                                RGBA(0, 0, 0, 0),
                                "FocusedBackground",
                                RGBA(0, 0, 0, 0),
                                "LeftThumbScroll",
                                false,
                                "SetFocusOnOpen",
                                true
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDACommonButton",
                                    "Padding",
                                    box(0, 0, 8, 0),
                                    "MinHeight",
                                    40,
                                    "MaxHeight",
                                    40,
                                    "LayoutMethod",
                                    "HList",
                                    "LayoutHSpacing",
                                    0,
                                    "OnPress",
                                    function(self, gamepad)

                                        local pows = GetDialog(self).context.prisoners

                                        HUDA_MilitiaPOW:SetPrisonersSector(pows)

                                        local dlg = GetDialog(self)
                                        dlg:Close()
                                    end
                                }, {
                                    PlaceObj("XTemplateWindow", {
                                        "__class",
                                        "XSquareWindow",
                                        "Margins",
                                        box(0, 0, 5, 0),
                                        "Background",
                                        RGBA(191, 67, 97, 255),
                                        "HAlign",
                                        "left",
                                        "VAlign",
                                        "top",
                                        "MinWidth",
                                        38,
                                        "MaxWidth",
                                        38
                                    }, {
                                        PlaceObj("XTemplateWindow", {
                                            "__class",
                                            "XText",
                                            "Text",
                                            Untranslated("x"),
                                            "Margins",
                                            box(2, 0, 0, 0),
                                            "HAlign",
                                            "center",
                                            "VAlign",
                                            "center",
                                            "Clip",
                                            false,
                                            "TextStyle",
                                            "PDASatelliteRollover_SectorTitle",
                                            "Translate",
                                            true,
                                            "TextHAlign",
                                            "center",
                                            "TextVAlign",
                                            "center"
                                        })
                                    }),
                                    PlaceObj("XTemplateWindow", {
                                        "__class",
                                        "XText",
                                        "Text",
                                        Untranslated("Hand over the prisoners to the local authorities"),
                                        "Margins",
                                        box(2, 0, 0, 0),
                                        "HAlign",
                                        "left",
                                        "VAlign",
                                        "center",
                                        "Clip",
                                        false,
                                        "TextStyle",
                                        "PDACommonButton",
                                        "Translate",
                                        true,
                                        "TextHAlign",
                                        "left",
                                        "TextVAlign",
                                        "center"
                                    }),
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "IsSelectable(self)",
                                        "func",
                                        function(self)
                                            return true
                                        end
                                    }),
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "SetSelected(self, selected)",
                                        "func",
                                        function(self, selected)
                                            self:SetFocus(selected)
                                            self:SetImage(selected and "UI/PDA/os_system_buttons_yellow" or
                                                "UI/PDA/os_system_buttons")
                                        end
                                    })
                                }),
                                PlaceObj("XTemplateForEach", {
                                    "array",
                                    function(parent, context)
                                        return context.sectors
                                    end,
                                    "__context",
                                    function(parent, context, item, i, n)
                                        return item
                                    end,
                                    "run_after",
                                    function(child, context, item, i, n, last)
                                        local sectorId = context.Id
                                        local sector = gv_Sectors[sectorId]
                                        local color, _, _, textColor = GetSectorControlColor(sector.Side)
                                        local text = textColor .. sectorId .. "</color>"
                                        child.idSectorId:SetText(T({
                                            764093693143,
                                            "<SectorIdColored(id)>",
                                            id = sectorId
                                        }))
                                        child.idSectorSquare:SetBackground(color)
                                        child:SetText(Untranslated((sector.display_name or "") ..
                                            " " .. context.current .. "+" .. context.new .. "/" .. context.max))

                                        child.idSectorGuards:SetText(Untranslated("Risk: " ..
                                            context.risk ..
                                            " | Guards: " .. context.guards .. "/" .. context.neededGuards))
                                        child.idIcon:SetVisible(false)
                                        child.idIcon:SetFoldWhenHidden(true)
                                        if i == 1 then
                                            child:OnSetRollover(true)
                                        end
                                    end
                                }, {
                                    PlaceObj("XTemplateTemplate", {
                                        "__template",
                                        "PDACommonButton",
                                        "Padding",
                                        box(0, 0, 8, 0),
                                        "MinHeight",
                                        40,
                                        "MaxHeight",
                                        40,
                                        "LayoutMethod",
                                        "HList",
                                        "LayoutHSpacing",
                                        0,
                                        "OnPress",
                                        function(self, gamepad)
                                            local sectorId = self.context.Id

                                            local pows = GetDialog(self).context.prisoners

                                            HUDA_MilitiaPOW:SetPrisonersSector(pows, sectorId)

                                            local dlg = GetDialog(self)
                                            dlg:Close()
                                        end
                                    }, {
                                        PlaceObj("XTemplateWindow", {
                                            "__class",
                                            "XSquareWindow",
                                            "Id",
                                            "idSectorSquare",
                                            "Margins",
                                            box(0, 0, 5, 0),
                                            "HAlign",
                                            "left",
                                            "VAlign",
                                            "top",
                                            "MinWidth",
                                            38,
                                            "MaxWidth",
                                            38
                                        }, {
                                            PlaceObj("XTemplateWindow", {
                                                "__class",
                                                "XText",
                                                "Id",
                                                "idSectorId",
                                                "Margins",
                                                box(2, 0, 0, 0),
                                                "HAlign",
                                                "center",
                                                "VAlign",
                                                "center",
                                                "Clip",
                                                false,
                                                "TextStyle",
                                                "PDASatelliteRollover_SectorTitle",
                                                "Translate",
                                                true,
                                                "TextHAlign",
                                                "center",
                                                "TextVAlign",
                                                "center"
                                            })
                                        }),
                                        PlaceObj("XTemplateWindow", {
                                            "__class",
                                            "XText",
                                            "Id",
                                            "idSectorGuards",
                                            "Margins",
                                            box(2, 0, 0, 0),
                                            "HAlign",
                                            "right",
                                            "VAlign",
                                            "center",
                                            "Dock",
                                            "right",
                                            "Clip",
                                            false,
                                            "TextStyle",
                                            "PDACommonButton",
                                            "Translate",
                                            true,
                                            "TextHAlign",
                                            "center",
                                            "TextVAlign",
                                            "center"
                                        }),
                                        PlaceObj("XTemplateFunc", {
                                            "name",
                                            "OnSetRollover(self, rollover)",
                                            "func",
                                            function(self, rollover)
                                                if not rollover then
                                                    return
                                                end
                                                local sectorId = self.context.Id
                                            end
                                        }),
                                        PlaceObj("XTemplateFunc", {
                                            "name",
                                            "IsSelectable(self)",
                                            "func",
                                            function(self)
                                                return true
                                            end
                                        }),
                                        PlaceObj("XTemplateFunc", {
                                            "name",
                                            "SetSelected(self, selected)",
                                            "func",
                                            function(self, selected)
                                                self:SetFocus(selected)
                                                self:SetImage(selected and "UI/PDA/os_system_buttons_yellow" or
                                                    "UI/PDA/os_system_buttons")
                                            end
                                        })
                                    })
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "controller selection",
                                "__context",
                                function(parent, context)
                                    return "GamepadUIStyleChanged"
                                end,
                                "__class",
                                "XContextWindow",
                                "Visible",
                                false,
                                "ContextUpdateOnOpen",
                                true,
                                "OnContextUpdate",
                                function(self, context, ...)
                                    local popup = self:ResolveId("node")
                                    local list = popup.idList
                                    if GetUIStyleGamepad() then
                                        list:SetInitialSelection(1)
                                    else
                                        list:SetSelection(false)
                                    end
                                end
                            })
                        })
                    })
                })
            })
        })
    })
end
