PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaSquad",
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
            if dlg.mode_param and dlg.mode_param.selected_squad then
                context = dlg.mode_param.selected_squad
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
                "VList"
            }, {
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(0, 0, 0, 0),
                    "LayoutMethod",
                    "HList"
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
                        "Margins",
                        box(0, 0, 5, 10),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPContentTitle",
                        "Translate",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                            self:SetText(context.Name)
                        end,
                        "Text",
                        Untranslated("<Name>")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XFrame",
                        "Margins",
                        box(0, 0, 5, 10),
                        "Visible",
                        false,
                        "FoldWhenHidden",
                        true,
                        "Id",
                        "idEditNameWrapper",
                        "HAlign",
                        "left",
                        "VAlign",
                        "center",
                        "MinWidth",
                        324,
                        "MinHeight",
                        39,
                        "MaxWidth",
                        324,
                        "Image",
                        "UI/PDA/imp_bar",
                        "FrameBox",
                        box(5, 5, 5, 5)
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "__class",
                            "XEdit",
                            "Id",
                            "idEditName",
                            "Margins",
                            box(10, 0, 10, 0),
                            "BorderWidth",
                            0,
                            "HAlign",
                            "left",
                            "VAlign",
                            "center",
                            "MinWidth",
                            324,
                            "MaxWidth",
                            324,
                            "Background",
                            RGBA(240, 240, 240, 0),
                            "MouseCursor",
                            "UI/Cursors/Pda_Hand.tga",
                            "FocusOrder",
                            point(0, 0),
                            "FocusedBorderColor",
                            RGBA(240, 240, 240, 0),
                            "FocusedBackground",
                            RGBA(240, 240, 240, 0),
                            "DisabledBorderColor",
                            RGBA(240, 240, 240, 0),
                            "DisabledBackground",
                            RGBA(240, 240, 240, 0),
                            "TextStyle",
                            "PDAIMPEdit",
                            "UserText",
                            true,
                            "UserTextType",
                            "name",
                            "OnLayoutComplete",
                            function(self)
                                self:SetText(self.context.Name or "")
                            end,
                            "OnTextChanged",
                            function(self)
                                local squad = gv_Squads[self.context.UniqueId]
                                local text = self:GetText()
                                local len = string.len(text[1] or "")

                                if len > 0 and len < 30 then
                                    squad.Name = text
                                else
                                    self:SetText(squad.Name)
                                end
                                PlayFX("Typing", "start")
                                ObjModified(self.context)
                                ObjModified(gv_Squads)
                            end,
                            "MaxLen",
                            30,
                            "AutoSelectAll",
                            true,
                            "HintColor",
                            RGBA(240, 240, 240, 0)
                        }, {
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnShortcut(self, shortcut, source, ...)",
                                "func",
                                function(self, shortcut, source, ...)
                                    if GetUIStyleGamepad() then
                                        return "break"
                                    end
                                    if shortcut == "Enter" or shortcut == "Escape" then
                                        self.parent:ResolveId("idEditToggle"):SetVisible(true)
                                        self.parent:ResolveId("idEditToggleEnd"):SetVisible(false)
                                        self.parent:ResolveId("idEditNameWrapper"):SetVisible(false)
                                        self.parent:ResolveId("idTitle"):SetVisible(true)
                                    else
                                        return XEdit.OnShortcut(self, shortcut, source)
                                    end
                                end
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnSetFocus(self, old_focus)",
                                "func",
                                function(self, old_focus)
                                    -- self:SetText(self.context.Name)
                                    if GetUIStyleGamepad() then
                                        self:OpenControllerTextInput()
                                        self:SetFocus(false)
                                    else
                                        XEdit.OnSetFocus(self, old_focus)
                                    end
                                end
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnKillFocus",
                                "func",
                                function(self, ...)
                                    if self:GetText() then
                                        -- g_ImpTest.final.name = self:GetText()
                                    end
                                    XEdit.OnKillFocus(self)
                                end
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnMouseButtonDoubleClick(self, pos, button)",
                                "func",
                                function(self, pos, button)
                                    if GetUIStyleGamepad() then
                                        return "break"
                                    end
                                end
                            })
                        })
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idEditToggle",
                        "FoldWhenHidden",
                        true,
                        "Margins",
                        box(0, 0, 20, 20),
                        "Padding",
                        box(0, 0, 0, 0),
                        "Background",
                        RGBA(255, 0, 0, 0),
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "TextStyle",
                        "PDABrowserThievesBoxLinks",
                        "Translate",
                        true,
                        "Text",
                        "<underline>Edit</underline>"
                    }, {
                        PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonDown(self, pos, button)",
                            "func",
                            function(self, pos, button)
                                self:SetVisible(false)
                                self.parent:ResolveId("idEditToggleEnd"):SetVisible(true)
                                self.parent:ResolveId("idEditNameWrapper"):SetVisible(true)
                                self.parent:ResolveId("idTitle"):SetVisible(false)
                                self.parent:ResolveId("idEditNameWrapper"):SetFocus()
                            end
                        })
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idEditToggleEnd",
                        "Visible",
                        false,
                        "FoldWhenHidden",
                        true,
                        "Margins",
                        box(0, 0, 20, 20),
                        "Padding",
                        box(0, 0, 0, 0),
                        "Background",
                        RGBA(255, 0, 0, 0),
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "TextStyle",
                        "PDABrowserThievesBoxLinks",
                        "Translate",
                        true,
                        "Text",
                        "<underline>Exit</underline>"
                    }, {
                        PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonDown(self, pos, button)",
                            "func",
                            function(self, pos, button)
                                self:SetVisible(false)
                                self.parent:ResolveId("idEditToggle"):SetVisible(true)
                                self.parent:ResolveId("idEditNameWrapper"):SetFocus(false)
                                self.parent:ResolveId("idEditNameWrapper"):SetVisible(false)
                                self.parent:ResolveId("idTitle"):SetVisible(true)
                            end
                        })
                    }),
                }),
                PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "Grid",
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "GridX",
                        1,
                        "GridY",
                        1,
                        "OnLayoutComplete",
                        function(self)
                            local city, distance = HUDA_GetClosestCity(self.context.BornInSector)
                            self:SetText(Untranslated("<em>Founded " ..
                            (distance > 0 and "near" or "in") .. ":</em> " .. city))
                        end
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "GridX",
                        1,
                        "GridY",
                        2,
                        "Text",
                        Untranslated("<em>Current Location:</em> <CurrentSector>")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "GridX",
                        2,
                        "GridY",
                        1,
                        "Text",
                        Untranslated("<em>Costs per Day:</em> <MilitiaSquadCosts(context)>$")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "GridX",
                        2,
                        "GridY",
                        2,
                        "Text",
                        Untranslated("<em>Status:</em> <MilitiaStatus(context)>")
                    }),
                }),
                PlaceObj("XTemplateWindow", {
                    "__context",
                    function(parent, context)
                        local conflicts = gv_HUDA_ConflictTracker

                        local squadConflicts = {}

                        for i, conflict in ipairs(conflicts) do
                            local squadConflict = HUDA_ArrayFind(conflict.squads, function(i, squad)
                                return squad.id == context.UniqueId
                            end)

                            if squadConflict then
                                table.insert(squadConflicts, conflict)
                            end

                            if (#squadConflicts >= 3) then
                                break
                            end
                        end

                        return squadConflicts
                    end,
                    "__condition",
                    function(parent, context)
                        return next(context)
                    end,
                    "LayoutMethod",
                    "VList",
                }, {
                    PlaceObj("XTemplateWindow", {
                        "comment",
                        "line",
                        "__class",
                        "XImage",
                        "Margins",
                        box(0, 10, 0, 10),
                        "VAlign",
                        "center",
                        "Transparency",
                        141,
                        "Image",
                        "UI/PDA/separate_line_vertical",
                        "ImageFit",
                        "stretch-x"
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Padding",
                        box(0, 0, 0, 0),
                        "Margins",
                        box(0, 0, 0, 10),
                        "HAlign",
                        "left",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPMercName",
                        "Translate",
                        true,
                        "Text",
                        "Latest Battles"
                    }),
                    PlaceObj("XTemplateWindow", {
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        5
                    }, {
                        PlaceObj("XTemplateForEach", {
                            "__context",
                            function(parent, context, item, i, n)
                                return item
                            end
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Padding",
                                box(0, 0, 0, 0),
                                "TextStyle",
                                "PDAIMPGalleryName",
                                "MouseCursor",
                                "UI/Cursors/Pda_Hand.tga",
                                "MinWidth",
                                200,
                                "Translate",
                                true,
                                "Text",
                                Untranslated(
                                    "<ConflictDirection(context)> Battle against <enemy.affiliation> in <sectorId> | <ConflictDaysAgo(context)>d ago | <ConflictResult(conflict)>")
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnMouseButtonDown(self, pos, button)",
                                    "func",
                                    function(self, pos, button)
                                        if button == "L" then
                                            local dlg = GetDialog(self)
                                            dlg:SetMode("aar", { aar = self.context, back = { mode = dlg.Mode, params = dlg.mode_param } })
                                        end
                                    end
                                })
                            })
                        })
                    })
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
                    "MEMBERS"
                }),
                PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(0, 0, 20, 0),
                    "LayoutMethod",
                    "VList"
                }, {
                    PlaceObj("XTemplateForEach", {
                        "__context",
                        function(parent, context, item, i, n)
                            return item
                        end,
                        "array",
                        function(parent, context)
                            local leader = HUDA_GetSquadLeader(context.units)

                            local units = { leader }

                            for i, unit in ipairs(context.units) do
                                local unit_table = gv_UnitData[unit]

                                if unit_table and unit_table ~= leader then
                                    table.insert(units, unit_table)
                                end
                            end
                            return units
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            child.idSoldierName:SetText(item.Nick)
                            child.idSoldierHome:SetText("Origin: " ..
                                GetSectorName(HUDA_GetSectorById(item.JoinLocation)))
                            child.idSoldierJoined:SetText("Joined: " ..
                                HUDA_GetDaysSinceTime(item.JoinDate) .. " days ago")
                            child.idSoldierSpecialty:SetText("Role: " ..
                                HUDA_GetSpecializationName(item.Specialization) .. (i == 1 and " / Squad Leader" or ""))
                            child.idPortrait:SetImage(item.Portrait)
                        end
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "IdNode",
                            true,
                            "Margins",
                            box(0, 10, 0, 10),
                            "LayoutMethod",
                            "HList",
                            "LayoutHSpacing",
                            20,
                            "Dock",
                            "top",
                            "HAlign",
                            "left"
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "Margins",
                                box(0, 0, 0, 0),
                                "HAlign",
                                "left"
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XImage",
                                    "Id",
                                    "idPortraitBG",
                                    "IdNode",
                                    false,
                                    "MinWidth",
                                    100,
                                    "MinHeight",
                                    114,
                                    "MaxWidth",
                                    100,
                                    "MaxHeight",
                                    114,
                                    "Image",
                                    "UI/Hud/portrait_background",
                                    "ImageFit",
                                    "stretch"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XImage",
                                    "Id",
                                    "idPortrait",
                                    "MinWidth",
                                    100,
                                    "MinHeight",
                                    114,
                                    "MaxWidth",
                                    100,
                                    "MaxHeight",
                                    114,
                                    "Image",
                                    "UI/MercsPortraits/Igor",
                                    "ImageFit",
                                    "stretch",
                                    "ImageRect",
                                    box(36, 0, 264, 251)
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "Margins",
                                box(0, 0, 0, 0),
                                "HAlign",
                                "left",
                                "LayoutMethod",
                                "VList",
                                "LayoutVSpacing",
                                0
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSoldierName",
                                    "HandleMouse",
                                    false,
                                    "TextStyle",
                                    "PDAIMPMercName",
                                    "TextHAlign",
                                    "left"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSoldierHome",
                                    "HandleMouse",
                                    false,
                                    "TextStyle",
                                    "PDAIMPGalleryName",
                                    "Translate",
                                    true,
                                    "TextHAlign",
                                    "left"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSoldierJoined",
                                    "HandleMouse",
                                    false,
                                    "TextStyle",
                                    "PDAIMPGalleryName",
                                    "Translate",
                                    true,
                                    "TextHAlign",
                                    "left"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSoldierSpecialty",
                                    "HandleMouse",
                                    false,
                                    "TextStyle",
                                    "PDAIMPGalleryName",
                                    "Translate",
                                    true,
                                    "TextHAlign",
                                    "left"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "__condition",
                                    function(parent, context)
                                        return false
                                    end,
                                    "Id",
                                    "idSoldierMode",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "TextStyle",
                                    "PDAIMPHyperLinkSmall",
                                    "Translate",
                                    true,
                                    "Text",
                                    "<underline>Details</underline>"
                                }, {
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "OnMouseButtonDown(self, pos, button)",
                                        "func",
                                        function(self, pos, button)
                                            local dlg = GetDialog(self)
                                            dlg:SetMode("soldier", { soldier = self.context })
                                        end
                                    })
                                })
                            })
                        })
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
